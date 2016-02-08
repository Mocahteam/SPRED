
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
/* Redéfinition des types de boost pour faciliter la lisibilité              */
/*****************************************************************************/

typedef boost::interprocess::managed_shared_memory::segment_manager ShmManager;
typedef boost::interprocess::interprocess_mutex Mutex;
typedef boost::interprocess::interprocess_condition Condition;

/*
 * Définition d'un vector de coordonnée
 */
// Permet d'allouer les coordonnées à l'aide du manageur dans la mémoire
// partagée
typedef boost::interprocess::allocator<GEI_Pos, ShmManager> PosAllocator;
/* vector à proprement dis */
typedef boost::interprocess::vector<GEI_Pos, PosAllocator> VectPos;

/*
 * Représentation d'une unité
 */
typedef struct {
  GEI_Coalition coalition; /* indique la coalition de l'unité */
  int type;                /* indique le type de l'unité */
  GEI_Pos pos;             /* indique la position de l'unité */
  float health;            /* indique la vie de l'unité */
  int group;               /* indique le groupe auquel appartient l'unité */
  int inactiveTime;        /* indique depuis combien de temps l'unité est
                            * inactive */
} GEI_ShortUnit;

/*
 * Définition de la map représantant l'ensemble des unités classées par leur
 * identifiant
 */
/* représente lle type des données stockées dans la map */
typedef std::pair<int, GEI_ShortUnit> MapData;
/* permet d'allouer les données de la map à l'aide du manageur dans la mémoire partagée */
typedef boost::interprocess::allocator<MapData, ShmManager> MapDataAllocator;
/* map à proprement dite */
typedef boost::interprocess::map<int, GEI_ShortUnit, std::less<int>, MapDataAllocator> MapUnits;

/*
 * Définition du vector référençant un ensemble d'unité de la map
 */
// Permet d'allouer les données du vector à l'aide du manageur dans la mémoire
// partagée
typedef boost::interprocess::allocator<int, ShmManager> UnitKeyAllocator;
/* vector à proprement dis */
typedef boost::interprocess::vector<int, UnitKeyAllocator> VectUnits;

/*
 * Représentation d'une commande
 */
// Permet d'allouer un paramettre à l'aide du manageur dans la mémoire
// partagée
typedef boost::interprocess::allocator<float, ShmManager> ParamAllocator;
/* permet de stocker l'ensemble des paramettres d'une commande */
typedef boost::interprocess::vector<float, ParamAllocator> Params;
/* la commande à proprement dite */
typedef struct {
  int unitID;		/* identifiant de l'unité */
  int idCommand;	/* identifiant de la commande */
  Params * params;	/* liste des paramettres de la commande */
} GEI_Command;

/*
 * Définition de la queue contenant la liste des commandes en attente
 */
// Permet d'allouer une commande à l'aide du manageur dans la mémoire partagée
typedef boost::interprocess::allocator<GEI_Command, ShmManager>
                                                          CommandAllocator;
/* la liste des commandes à proprement dite */
typedef boost::interprocess::vector<GEI_Command, CommandAllocator> Commands;


/*****************************************************************************/
/* Définition des variables globales                                         */
/*****************************************************************************/

/* Défini le nombre de propriétaire possible */
#define NB_COALITIONS 3
#define CMD_GROUPADD 36
#define CMD_STOP 0

/* Représente des données paratagées entre les processus */
typedef struct {
  /* pour assurer la synchronisation */
  Mutex * mutex;
  Condition * cond;
  /* indique si une demande de mise à jour a été effectuée */
  bool * update;
  /* Contient l'ensemble des unités visibles par le joueur */
  MapUnits * units;
  /* Contient les unités réparties en fonction de leur coalition */
  VectUnits * coalitions;
  /* Contient la liste des commandes en attente */
  Commands * pendingCommand;
  /* Contient la taille de la carte */
  GEI_Pos * mapSize;
  /* Contient la position de départ */
  GEI_Pos * startPosition;
  /* Contient l'ensemble des positions des zones constructibles */
  VectPos * buildingLand;
} GEI_sharedData;

/* Contient l'ensemble des données partagées */
static GEI_sharedData shd;

/* le segment de mémoire partagée */
boost::interprocess::managed_shared_memory * segment = NULL;

/* Représente les données copiées en local */
typedef std::map<int, GEI_ShortUnit, std::less<int> > LocalMapUnits;
typedef struct {
  /* Contient l'ensemble des unités visibles par le joueur */
  LocalMapUnits * units;
  /* Contient les unités réparties en fonction de leur coalition */
  std::vector<int> * coalitions [NB_COALITIONS];
  /* Contient la taille de la carte */
  GEI_Pos mapSize;
  /* Contient la position de départ */
  GEI_Pos startPosition;
  /* Contient l'ensemble des positions des zones constructibles */
  std::vector<GEI_Pos> * buildingLand;
} GEI_localData;

/* Contient l'ensemble des données partagées */
static GEI_localData ld;

/* indique si la GEI a été ouverte */
bool opened = false;
/* indique si les données locales ont été renseignées */
bool refreshed = false;

/*****************************************************************************/
/* Fonctions internes                                                        */
/*****************************************************************************/

/*
 * Vérifie si la GEI est bien initialisée.
 * fctName : nom de la fonction ayant appelée isInitialised.
 * isRefreshed : indique si l'on souhaite vérifier que le jeu a bien été au
 *               moins une fois rafraichi
 * retourne : 0 si la bibliothèque est bien initialisée
 *            -1 si la GEI n'est pas ouverte
 *            -13 si le jeu n'a jamais été rafraichi
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
 * Vérifie si les paramètres passés sont corrects
 * fctName : nom de la fonction ayant appelée checkParams
 * unit : pour tester si cette unité est valide ou pas
 * checkOwner : pour vérifier si unit est la propriété du joueur ou pas
 * coalition : pour tester si cette coalition est valide ou pas
 * target : pour tester si cette unité est valide ou pas
 * isRefreshed : indique si l'on souhaite vérifier que le jeu a bien été au
 *               moins une fois rafraichi
 * retourne : 0 si tout les paramètres sont valides
 *            -1 si la GEI n'est pas ouverte
 *            -2 si unit n'est pas trouvée
 *            -3 si vous n'êtes pas le propriétaire de l'unité unit
 *            -4 si coalition n'est pas valide
 *            -5 si target n'est pas trouvé
 *            -13 si le jeu n'a jamais été rafraichi
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
 * Ajoute une commande à la liste des commandes en attente.
 * unitID : identifiant de l'unité
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
  // création du nom de ce parametre
  // pour manipuler facilement la chaine
  std::ostringstream oss (std::ostringstream::out);
  oss << "param" << shd.pendingCommand->size();
  const ParamAllocator paramAlloc_inst (segment->get_segment_manager());
  // construction de vector dans la mémoire partagée et recopie des éléments
  // du vector passé en paramettre
  tmp.params =
        segment->construct<Params>(oss.str().c_str())
                         (params.begin(),
                          params.end(),
                          paramAlloc_inst);
  shd.pendingCommand->push_back(tmp);
  // le mutex est automatiquement libéré en sortie du bloc (grace au
  // scoped_lock)
}


/*****************************************************************************/
/* Fonctions de communication avec le jeu                                    */
/*****************************************************************************/

int GEI_Open(){
  if (!opened){
    try{
#if (defined BOOST_WINDOWS) && !(defined BOOST_DISABLE_WIN32)
      // ne chercher à supprimer la mémoire partagée coté client que dans le
      // cas de Windows
      boost::interprocess::shared_memory_object::remove("GEI_SharedMemory");
#endif
      // ouverture de la mémoire partagée
      segment = new boost::interprocess::managed_shared_memory
                                   (boost::interprocess::open_only,
                                    "GEI_SharedMemory");

      // trouver les éléments dans la mémoire partagée
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
      // ne chercher à supprimer la mémoire partagée coté client que dans le
      // cas de Windows
      boost::interprocess::shared_memory_object::remove("GEI_SharedMemory");
#endif
      return -11;
    }
    /* indiquer que les données locales n'ont pas été renseignées */
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
    // réouverture de la GEI
    return GEI_Open();
  }
}

int GEI_Refresh (){
  int ret = checkParams("GEI_Refresh", NULL, false, NULL, NULL, false);
  if (ret == 0){
    // prise du mutex
    boost::interprocess::scoped_lock<Mutex> lock(*shd.mutex);
    // demander la mise à jour
    *(shd.update) = true;
    // attendre la fin de la mise à jour pendant 1 seconde maximum. Au delà
    // on concidère que le jeu ne répond pas
    // récupération de l'heure actuelle
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
      // recopie des données pertinantes en local
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
    // le mutex est automatiquement libéré en sortie du bloc (grace au
    // scoped_lock)
  }
  return ret;
}

int GEI_Close (){
  int ret = checkParams("GEI_Close", NULL, false, NULL, NULL, false);
  if (ret == 0){
    opened = false;
    /* destruction du segment permettant l'accès aux données */
    delete segment;
    segment = NULL;
    /* destruction des données locales */
    refreshed = false;
    ld.units = NULL;
    for (int i = 0 ; i < NB_COALITIONS ; i++)
      ld.coalitions[i] = NULL;
    ld.buildingLand = NULL;
#if (defined BOOST_WINDOWS) && !(defined BOOST_DISABLE_WIN32)
    // ne chercher à supprimer la mémoire partagée coté client que dans le
    // cas de Windows
    boost::interprocess::shared_memory_object::remove("GEI_SharedMemory");
#endif
  }
  return ret;
}

GEI_Pos GEI_MapSize (){
  GEI_Pos tmp;
  // vérification de l'initialisation
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
  // vérification de l'initialisation
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
  // vérification de l'initialisation
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
      // retourne directement la donnée. Si l'index n'est pas bon, une
      // exeption sera levée
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
    // récupération de l'unité
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
    // récupération de l'unité
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
    // vérification de l'initialisation
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
      params[1] = -1; // ce champs est rempli lors de l'éxécution de la
                      // commande (càd coté moteur du jeu)
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
      std::vector<float> bidon; // seulement pour passer un paramètre
      addCommand(unit, CMD_STOP, bidon);
    }
  }
  return ret;
}
