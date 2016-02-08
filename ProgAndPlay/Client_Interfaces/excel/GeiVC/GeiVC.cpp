
#include "GeiVC.h"

#include <vector>
#include <iostream>

#include <boost/config.hpp>
#include <boost/interprocess/managed_shared_memory.hpp>
#include <boost/interprocess/containers/map.hpp>
#include <boost/interprocess/containers/vector.hpp>
#include <boost/interprocess/containers/string.hpp>
#include <boost/interprocess/sync/interprocess_condition.hpp>
#include "boost/date_time/gregorian/gregorian.hpp"
#include "boost/date_time/posix_time/posix_time.hpp"

/*****************************************************************************/
/* Red�finition des types de boost pour faciliter la lisibilit�              */
/*****************************************************************************/

typedef boost::interprocess::managed_shared_memory::segment_manager ShmManager;
typedef boost::interprocess::interprocess_mutex Mutex;
typedef boost::interprocess::interprocess_condition Condition;

/*
 * D�finition d'un vector de coordonn�e
 */
// Permet d'allouer les coordonn�es � l'aide du manageur dans la m�moire
// partag�e
typedef boost::interprocess::allocator<GEI_Pos, ShmManager> PosAllocator;
/* vector � proprement dis */
typedef boost::interprocess::vector<GEI_Pos, PosAllocator> VectPos;

/*
 * Repr�sentation d'une unit�
 */
typedef struct {
  GEI_Coalition coalition; /* indique la coalition de l'unit� */
  int type;                /* indique le type de l'unit� */
  GEI_Pos pos;             /* indique la position de l'unit� */
  float health;            /* indique la vie de l'unit� */
  int group;               /* indique le groupe auquel appartient l'unit� */
  int inactiveTime;        /* indique depuis combien de temps l'unit� est
                            * inactive */
} GEI_ShortUnit;

/*
 * D�finition de la map repr�santant l'ensemble des unit�s class�es par leur
 * identifiant
 */
/* repr�sente lle type des donn�es stock�es dans la map */
typedef std::pair<int, GEI_ShortUnit> MapData;
/* permet d'allouer les donn�es de la map � l'aide du manageur dans la m�moire partag�e */
typedef boost::interprocess::allocator<MapData, ShmManager> MapDataAllocator;
/* map � proprement dite */
typedef boost::interprocess::map<int, GEI_ShortUnit, std::less<int>, MapDataAllocator> MapUnits;

/*
 * D�finition du vector r�f�ren�ant un ensemble d'unit� de la map
 */
// Permet d'allouer les donn�es du vector � l'aide du manageur dans la m�moire
// partag�e
typedef boost::interprocess::allocator<int, ShmManager> UnitKeyAllocator;
/* vector � proprement dis */
typedef boost::interprocess::vector<int, UnitKeyAllocator> VectUnits;

/*
 * Repr�sentation d'une commande
 */
// Permet d'allouer un paramettre � l'aide du manageur dans la m�moire
// partag�e
typedef boost::interprocess::allocator<float, ShmManager> ParamAllocator;
/* permet de stocker l'ensemble des paramettres d'une commande */
typedef boost::interprocess::vector<float, ParamAllocator> Params;
/* la commande � proprement dite */
typedef struct {
  int unitID;		/* identifiant de l'unit� */
  int idCommand;	/* identifiant de la commande */
  Params * params;	/* liste des paramettres de la commande */
} GEI_Command;

/*
 * D�finition de la queue contenant la liste des commandes en attente
 */
// Permet d'allouer une commande � l'aide du manageur dans la m�moire partag�e
typedef boost::interprocess::allocator<GEI_Command, ShmManager>
                                                          CommandAllocator;
/* la liste des commandes � proprement dite */
typedef boost::interprocess::vector<GEI_Command, CommandAllocator> Commands;


/*****************************************************************************/
/* D�finition des variables globales                                         */
/*****************************************************************************/

/* D�fini le nombre de propri�taire possible */
#define NB_COALITIONS 3
#define CMD_GROUPADD 36
#define CMD_STOP 0

/* Repr�sente des donn�es paratag�es entre les processus */
typedef struct {
  /* pour assurer la synchronisation */
  Mutex * mutex;
  Condition * cond;
  /* indique si une demande de mise � jour a �t� effectu�e */
  bool * update;
  /* Contient l'ensemble des unit�s visibles par le joueur */
  MapUnits * units;
  /* Contient les unit�s r�parties en fonction de leur coalition */
  VectUnits * coalitions;
  /* Contient la liste des commandes en attente */
  Commands * pendingCommand;
  /* Contient la taille de la carte */
  GEI_Pos * mapSize;
  /* Contient la position de d�part */
  GEI_Pos * startPosition;
  /* Contient l'ensemble des positions des zones constructibles */
  VectPos * buildingLand;
} GEI_sharedData;

/* Contient l'ensemble des donn�es partag�es */
static GEI_sharedData shd;

/* le segment de m�moire partag�e */
boost::interprocess::managed_shared_memory * segment = NULL;

/* Repr�sente les donn�es copi�es en local */
typedef std::map<int, GEI_ShortUnit, std::less<int> > LocalMapUnits;
typedef struct {
  /* Contient l'ensemble des unit�s visibles par le joueur */
  LocalMapUnits * units;
  /* Contient les unit�s r�parties en fonction de leur coalition */
  std::vector<int> * coalitions [NB_COALITIONS];
  /* Contient la taille de la carte */
  GEI_Pos mapSize;
  /* Contient la position de d�part */
  GEI_Pos startPosition;
  /* Contient l'ensemble des positions des zones constructibles */
  std::vector<GEI_Pos> * buildingLand;
} GEI_localData;

/* Contient l'ensemble des donn�es partag�es */
static GEI_localData ld;

/* indique si la GEI a �t� ouverte */
bool opened = false;
/* indique si les donn�es locales ont �t� renseign�es */
bool refreshed = false;

/*****************************************************************************/
/* Fonctions internes                                                        */
/*****************************************************************************/

/*
 * V�rifie si la GEI est bien initialis�e.
 * fctName : nom de la fonction ayant appel�e isInitialised.
 * isRefreshed : indique si l'on souhaite v�rifier que le jeu a bien �t� au
 *               moins une fois rafraichi
 * retourne : 0 si la biblioth�que est bien initialis�e
 *            -1 si la GEI n'est pas ouverte
 *            -13 si le jeu n'a jamais �t� rafraichi
 */
static int isInitialized (std::string fctName = "", bool isRefreshed = true){
  if (!opened){
    std::cerr << fctName << " : GEI not opened" << std::endl;
    return -1;
  }
  if (isRefreshed && !refreshed){
    std::cerr << fctName << " : GEI not refreshed" << std::endl;
    return -13;
  }
  return 0;
}

/*
 * V�rifie si les param�tres pass�s sont corrects
 * fctName : nom de la fonction ayant appel�e checkParams
 * unit : pour tester si cette unit� est valide ou pas
 * checkOwner : pour v�rifier si unit est la propri�t� du joueur ou pas
 * coalition : pour tester si cette coalition est valide ou pas
 * target : pour tester si cette unit� est valide ou pas
 * isRefreshed : indique si l'on souhaite v�rifier que le jeu a bien �t� au
 *               moins une fois rafraichi
 * retourne : 0 si tout les param�tres sont valides
 *            -1 si la GEI n'est pas ouverte
 *            -2 si unit n'est pas trouv�e
 *            -3 si vous n'�tes pas le propri�taire de l'unit� unit
 *            -4 si coalition n'est pas valide
 *            -5 si target n'est pas trouv�
 *            -13 si le jeu n'a jamais �t� rafraichi
 */
static int checkParams (std::string fctName = "",
                        LocalMapUnits::iterator * unit = NULL,
                        bool checkOwner = false,
                        int * coalition = NULL,
                        LocalMapUnits::iterator * target = NULL,
						bool isRefreshed = true){
  int ret = isInitialized (fctName, isRefreshed);
  if (ret < 0) return ret;
  if (unit){
    if (*unit == ld.units->end()){
      std::cerr << fctName << " : unit not found" << std::endl;
      return -2;
    }
    if (checkOwner){
      if ((*unit)->second.coalition != ME){
        std::cerr << fctName << " : you are not the unit owner" << std::endl;
        return -3;
      }
    }
  }
  if (coalition){
    if (*coalition < 0 || *coalition >= NB_COALITIONS){
      std::cerr << fctName << " : coalition out of range" << std::endl;
      return -4;
    }
  }
  if (target){
    if (*target == ld.units->end()){
      std::cerr << fctName << " : target not found" << std::endl;
      return -5;
    }
  }
  return 0;
}

/*
 * Ajoute une commande � la liste des commandes en attente.
 * unitID : identifiant de l'unit�
 * idCommand : identifiant de la commande
 * params : liste des paramettres de la commande
 */
static void addCommand(int unitID, int idCommand,
                             const std::vector<float>& params){
  // construction de la commande
  GEI_Command tmp;
  tmp.unitID = unitID;
  tmp.idCommand = idCommand;
  // prise du mutex
  boost::interprocess::scoped_lock<Mutex> lock(*shd.mutex);
  // cr�ation du nom de ce parametre
  // pour manipuler facilement la chaine
  std::ostringstream oss (std::ostringstream::out);
  oss << "param" << shd.pendingCommand->size();
  const ParamAllocator paramAlloc_inst (segment->get_segment_manager());
  // construction de vector dans la m�moire partag�e et recopie des �l�ments
  // du vector pass� en paramettre
  tmp.params =
        segment->construct<Params>(oss.str().c_str())
                         (params.begin(),
                          params.end(),
                          paramAlloc_inst);
  shd.pendingCommand->push_back(tmp);
  // le mutex est automatiquement lib�r� en sortie du bloc (grace au
  // scoped_lock)
}


/*****************************************************************************/
/* Fonctions de communication avec le jeu                                    */
/*****************************************************************************/

int GEI_Open(){
  if (!opened){
    try{
#if (defined BOOST_WINDOWS) && !(defined BOOST_DISABLE_WIN32)
      // ne chercher � supprimer la m�moire partag�e cot� client que dans le
      // cas de Windows
      boost::interprocess::shared_memory_object::remove("GEI_SharedMemory");
#endif
      // ouverture de la m�moire partag�e
      segment = new boost::interprocess::managed_shared_memory
                                   (boost::interprocess::open_only,
                                    "GEI_SharedMemory");

      // trouver les �l�ments dans la m�moire partag�e
      shd.mutex = segment->find<Mutex>("mutex").first;
      shd.cond = segment->find<Condition>("cond").first;
      shd.update = segment->find<bool>("update").first;
      shd.units = segment->find<MapUnits>("units").first;
      shd.coalitions = segment->find<VectUnits>("coalitions").first;
      shd.pendingCommand = segment->find<Commands>("pendingCommand").first;
      shd.mapSize = segment->find<GEI_Pos>("mapSize").first;
      shd.startPosition = segment->find<GEI_Pos>("startPosition").first;
      shd.buildingLand = segment->find<VectPos>("buildingLand").first;
    } catch (...){
      std::cerr << "GEI_Open : open shared memory error" << std::endl;
      delete segment;
      segment = NULL;
#if (defined BOOST_WINDOWS) && !(defined BOOST_DISABLE_WIN32)
      // ne chercher � supprimer la m�moire partag�e cot� client que dans le
      // cas de Windows
      boost::interprocess::shared_memory_object::remove("GEI_SharedMemory");
#endif
      return -11;
    }
    /* indiquer que les donn�es locales n'ont pas �t� renseign�es */
    refreshed = false;
    ld.units = NULL;
    for (int i = 0 ; i < NB_COALITIONS ; i++)
      ld.coalitions[i] = NULL;
    ld.buildingLand = NULL;
    /* validation de l'ouverture */
    opened = true;
    return 0;
  }
  else{
    if (GEI_Close() < 0){
      std::cerr << "GEI_Open : GEI already opened, impossible to reload GEI" << std::endl;
      return -6;
    }
    // r�ouverture de la GEI
    return GEI_Open();
  }
}

int GEI_Refresh (){
  int ret = checkParams("GEI_Refresh", NULL, false, NULL, NULL, false);
  if (ret == 0){
    // prise du mutex
    boost::interprocess::scoped_lock<Mutex> lock(*shd.mutex);
    // demander la mise � jour
    *(shd.update) = true;
    // attendre la fin de la mise � jour pendant 1 seconde maximum. Au del�
    // on concid�re que le jeu ne r�pond pas
    // r�cup�ration de l'heure actuelle
    boost::posix_time::ptime pt (boost::date_time::microsec_clock<boost::posix_time::ptime>::universal_time());
    // ajouter 1 seconde
    pt = pt + boost::posix_time::seconds(1);
    // se mettre en attente
    if (!shd.cond->timed_wait(lock, pt)){
      std::cerr << "GEI_Refresh : silent game" << std::endl;
      ret = -12;
    }
    else{
      // suppression des enciennes valeurs
      delete ld.units;
      for (int i = 0 ; i < NB_COALITIONS ; i++)
        delete ld.coalitions[i];
      ld.units = NULL;
      for (int i = 0 ; i < NB_COALITIONS ; i++)
        ld.coalitions[i] = NULL;
      // recopie des donn�es pertinantes en local
      ld.units = new LocalMapUnits (shd.units->begin(), shd.units->end());
      for (int i = 0 ; i < NB_COALITIONS ; i++)
        ld.coalitions[i] = new std::vector<int> (shd.coalitions[i].begin(),
                                                 shd.coalitions[i].end());
      if (!refreshed){
        ld.mapSize = *(shd.mapSize);
        ld.startPosition = *(shd.startPosition);
        ld.buildingLand = new std::vector<GEI_Pos> (shd.buildingLand->begin(),
                                                    shd.buildingLand->end());
      }
      refreshed = true;
    }
    // le mutex est automatiquement lib�r� en sortie du bloc (grace au
    // scoped_lock)
  }
  return ret;
}

int GEI_Close (){
  int ret = checkParams("GEI_Close", NULL, false, NULL, NULL, false);
  if (ret == 0){
    opened = false;
    /* destruction du segment permettant l'acc�s aux donn�es */
    delete segment;
    segment = NULL;
    /* destruction des donn�es locales */
    refreshed = false;
    ld.units = NULL;
    for (int i = 0 ; i < NB_COALITIONS ; i++)
      ld.coalitions[i] = NULL;
    ld.buildingLand = NULL;
#if (defined BOOST_WINDOWS) && !(defined BOOST_DISABLE_WIN32)
    // ne chercher � supprimer la m�moire partag�e cot� client que dans le
    // cas de Windows
    boost::interprocess::shared_memory_object::remove("GEI_SharedMemory");
#endif
  }
  return ret;
}

GEI_Pos GEI_MapSize (){
  GEI_Pos tmp;
  // v�rification de l'initialisation
  int ret = checkParams("GEI_MapSize");
  if (ret == 0)
    return ld.mapSize;
  else{
    tmp.x = ret;
    tmp.y = ret;
  }
  return tmp;
}

GEI_Pos GEI_StartPosition (){
  GEI_Pos tmp;
  // v�rification de l'initialisation
  int ret = checkParams("GEI_StartPosition");
  if (ret == 0)
    return ld.startPosition;
  else{
    tmp.x = ret;
    tmp.y = ret;
  }
  return tmp;
}

int GEI_GetNumBuildingLand (){
  int ret = checkParams("GEI_GetNumBuildingLand");
  if (ret == 0)
    ret = ld.buildingLand->size();
  return ret;
}

GEI_Pos GEI_BuildingLandPosition(int bl){
  GEI_Pos tmp;
  // v�rification de l'initialisation
  int ret = checkParams("GEI_BuildingLandPosition");
  if (ret == 0){
    try {
      tmp = ld.buildingLand->at(bl);
    } catch (std::out_of_range e){
      std::cerr << "GEI_BuildingLandPosition : building land not found" << std::endl;
      tmp.x = -9;
      tmp.y = -9;
    }
  }
  else {
    tmp.x = -1;
    tmp.y = -1;
  }
  return tmp;
}

int GEI_GetNumUnits (GEI_Coalition c){
  int ret = checkParams("GEI_GetNumUnits", NULL, false, (int*)&c);
  if (ret == 0)
    ret = ld.coalitions[c]->size();
  return ret;
}

GEI_Unit GEI_GetUnitAt (int index, GEI_Coalition c){
  int ret = checkParams("GEI_GetUnitAt", NULL, false, (int*)&c);
  if (ret == 0){
    try{
      // retourne directement la donn�e. Si l'index n'est pas bon, une
      // exeption sera lev�e
      ret = ld.coalitions[c]->at(index);
    } catch (std::out_of_range e) {
      std::cerr << "GEI_GetUnitAt : index out of range" << std::endl;
      ret = -7;
    }
  }
  return ret;
}

GEI_Coalition GEI_Unit_GetCoalition (GEI_Unit unit){
  int ret = isInitialized("GEI_Unit_GetCoalition");
  if (ret == 0){
    // r�cup�ration de l'unit�
    LocalMapUnits::iterator u = ld.units->find(unit);
    ret = checkParams("GEI_Unit_GetCoalition", &u);
    if (ret == 0)
      ret = u->second.coalition;
  }
  return (GEI_Coalition)ret;
}

int GEI_Unit_GetType (GEI_Unit unit){
  int ret = isInitialized("GEI_Unit_GetType");
  if (ret == 0){
    // r�cup�ration de l'unit�
    LocalMapUnits::iterator u = ld.units->find(unit);
    ret = checkParams("GEI_Unit_GetType", &u);
    if (ret == 0)
      ret = u->second.type;
  }
  return ret;
}

GEI_Pos GEI_Unit_GetPosition (GEI_Unit unit){
  GEI_Pos tmp;
  int ret = isInitialized("GEI_Unit_GetPosition");
  if (ret == 0){
    // v�rification de l'initialisation
    LocalMapUnits::iterator u = ld.units->find(unit);
    ret = checkParams("GEI_Unit_GetPosition", &u);
    if (ret == 0)
      tmp = u->second.pos;
    else{
      tmp.x = ret;
      tmp.y = ret;
    }
  }
  return tmp;
}

float GEI_Unit_GetHealth (GEI_Unit unit){
  int ret = isInitialized("GEI_Unit_GetHealth");
  if (ret == 0){
    LocalMapUnits::iterator u = ld.units->find(unit);
    ret = checkParams("GEI_Unit_GetHealth", &u);
    if (ret == 0)
      return u->second.health;
  }
  return ret;
}

int GEI_Unit_InactiveTime (GEI_Unit unit){
  int ret = isInitialized("GEI_Unit_InactiveTime");
  if (ret == 0){
    LocalMapUnits::iterator u = ld.units->find(unit);
    ret = checkParams("GEI_Unit_InactiveTime", &u);
    if (ret == 0)
      ret = u->second.inactiveTime;
  }
  return ret;
}

int GEI_Unit_GetGroup (GEI_Unit unit){
  int ret = isInitialized("GEI_Unit_GetGroup");
  if (ret == 0){
    LocalMapUnits::iterator u = ld.units->find(unit);
    ret = checkParams("GEI_Unit_GetGroup", &u);
    if (ret == 0)
      ret = u->second.group;
  }
  return ret;
}

int GEI_Unit_SetGroup (GEI_Unit unit, int group){
  int ret = isInitialized("GEI_Unit_SetGroup");
  if (ret == 0){
    LocalMapUnits::iterator u = ld.units->find(unit);
    ret = checkParams("GEI_Unit_SetGroup", &u, true);
    if (ret == 0){
      if (group < -1 || group > 9){
        std::cerr << "GEI_Unit_SetGroup : invalid group, must be between -1 and 9 inclusive" << std::endl;
        ret = -10;
      }
      else{
        std::vector<float> params (1, 0);
        params[0] = group;
        addCommand(unit, CMD_GROUPADD, params);
      }
    }
  }
  return ret;
}

int GEI_Unit_ActionOnUnit (int unit, int action, int target){
  int ret = isInitialized("GEI_Unit_ActionOnUnit");
  if (ret == 0){
    LocalMapUnits::iterator u = ld.units->find(unit);
    LocalMapUnits::iterator t = ld.units->find(target);
    ret = checkParams("GEI_Unit_ActionOnUnit", &u, true, NULL, &t);
    if (ret == 0){
      // enregistrer la commande
      std::vector<float> params (1, 0);
      params[0] = target;
      addCommand(unit, action, params);
    }
  }
  return ret;
}

int GEI_Unit_ActionOnPosition (int unit, int action, float x, float y){
  int ret = isInitialized("GEI_Unit_ActionOnPosition");
  if (ret == 0){
    LocalMapUnits::iterator u = ld.units->find(unit);
    ret = checkParams("GEI_Unit_ActionOnPosition", &u, true);
    if (ret == 0){
      // enregistrer la commande
      std::vector<float> params (3, 0);
      params[0] = x;
      params[1] = -1; // ce champs est rempli lors de l'�x�cution de la
                      // commande (c�d cot� moteur du jeu)
      params[2] = y;
      addCommand(unit, action, params);
    }
  }
  return ret;
}

int GEI_Unit_Stop (GEI_Unit unit){
  int ret = isInitialized("GEI_Unit_Stop");
  if (ret == 0){
    LocalMapUnits::iterator u = ld.units->find(unit);
    ret = checkParams("GEI_Unit_Stop", &u, true);
    if (ret == 0){
      std::vector<float> bidon; // seulement pour passer un param�tre
      addCommand(unit, CMD_STOP, bidon);
    }
  }
  return ret;
}
