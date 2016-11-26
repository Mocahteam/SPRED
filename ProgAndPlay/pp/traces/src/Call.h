/**
 * \file Call.h
 * \brief Déclaration des classes Call et ParamsMap
 * \author meresse
 * \version 0.1
 */

#ifndef __CALL_H__
#define __CALL_H__

#define MAX_SIZE_PARAMS 2

#include <iostream>
#include <fstream>
#include <sstream>
#include <map>
#include <vector>
#include <algorithm>
#include <stdexcept>
#include <rapidjson/document.h>
#include <boost/lexical_cast.hpp>

#include "Trace.h"

/** 
  *	si DEFAULT_COMPRESSION_MOD == 0, alors aucune valeur de paramètre n'est utilisé durant la compression. Sinon, tous les paramètres sont pris en compte pour la compression.
  */
#define DEFAULT_COMPRESSION_MOD 0

/** 
 * \class ParamsMap
 * \brief Classe utilisée pour le chargement des paramètres de compression à partir du fichier JSON 'params.json'.
 */
class ParamsMap {
		
public:

	/**
	  * \brief Constructeur de la classe ParamsMap.
	  */
	ParamsMap() : loaded(false) {}
	
	/**
	  * \brief Chargement des paramètres de compression
      *
	  * Le booléen \p loaded est mis à vrai si la chaine à bien été parsée, de sorte que le chargement ne puisse être effectué qu'une seule fois. 
	  * 
      * \param json : une chaîne de caractères contenant les données au format JSON.
	  */
	void initMap(const std::string& json) {
		if (!loaded) {
			try {
				rapidjson::Document doc;
				if (doc.Parse<0>(json.c_str()).HasParseError())
					throw std::runtime_error("parse error");
				if (doc.IsObject()) {
					for (rapidjson::Value::ConstMemberIterator it = doc.MemberBegin(); it != doc.MemberEnd(); it++) {
						string_vector v;
						for (rapidjson::Value::ConstMemberIterator _it = it->value.MemberBegin(); _it != it->value.MemberEnd(); _it++) {
							if (_it->value.IsBool() && _it->value.GetBool())
								v.push_back(_it->name.GetString());
						}
						map.insert(std::make_pair<std::string,string_vector>(it->name.GetString(),v));
					}
					loaded = true;
				}
			}
			catch (const std::runtime_error& e) {
				std::cout << e.what() << std::endl;
			}
		}
	}
	
	/**
	  * \brief Récupération des paramètres de compression
      *
	  * Le booléen \p loaded est mis à vrai si la chaine à bien été parsée, de sorte que le chargement ne puisse être effectué qu'une seule fois.
	  *
	  * Si cette fonction alors que \p loaded est à faux (la fonction ParamsMap::initMap n'a pas été appelée ou le parsing a échoué), un mode de compression par défaut est utilisé.
	  * Suivant la valeur de DEFAULT_COMPRESSION_MOD :
	  * 	- 0 : Aucun paramètre n'est pris en considération pour la compression (compression maximale)
	  *		- 1 : Tous les paramètres sont pris en considération pour la compression (compression minimale)
	  * 
      * \param label : un label de fonction utilisée pouvant être utilisée dans Call.
	  * \param param : un nom de paramètre associé à la fonction \p label.
	  *
	  * \return vrai si la valeur du paramètre \p param du label \p label doit être pris en considération lors de la compression et faux sinon.
	  */
	bool contains(std::string label, std::string param) const {
		if (!loaded) {
			#if DEFAULT_COMPRESSION_MOD == 1
				return true;
			#else
				return false;
			#endif
		}
		return map.find(label) != map.end() && std::find(map.at(label).begin(), map.at(label).end(), param) != map.at(label).end();
	}
	
private:

	typedef std::vector<std::string> string_vector;
	
	/**
	  * Une entrée label:param signifie que le paramètre param de la fonction label doit être pris en considération pour la compression, i.e. que les valeurs de ce paramètre pour deux appels doivent être égaux pour que ces deux appels puissent être considérés comme égaux.
	  */
	std::map<std::string,string_vector> map;
	
	/**
	  * Un booléen mis à vrai lorsque la fonction ParamsMap::initMap a été appelée et que les paramètres de compression ont bien été chargés.
	  */
	bool loaded;
	
};


/** 
 * \class Call
 * \brief Classe abstraite héritant de Trace. Cette classe sert de classe mère pour toutes les classes définies dans le fichier CallDef.h.
 */
class Call : public Trace {
	
public:

	/**
	  * Définition du type pointeur intelligent vers un objet Call.
	  */
	typedef boost::shared_ptr<Call> sp_call;
	
	typedef std::vector<sp_call> call_vector;

	/**
	  * \brief Enumération utilisée pour connaître le type d'erreur associé à l'objet Call.
	  */
	enum ErrorType {
		NONE = -1,
		OUT_OF_RANGE,
		WRONG_COALITION,
		WRONG_UNIT,
		WRONG_TARGET,
		WRONG_POSITION
	};
	
	/**
	  * \brief Constructeur principal de la classe Call.
	  *
	  * \param label le label de la fonction modélisée par l'objet Call.
	  * \param error l'erreur survenue lors de l'appel de la fonction représentée par l'objet Call.
	  * \param info le label attribué par l'expert.
	  */
	Call(std::string label, ErrorType error, std::string info = "");
	
	/**
	  * Constructeur de la classe Call utilisé notamment lors de la copie de l'objet.
	  */
	Call(const Call *c);
	
	/**
	  * Tableau contenant les chaînes de caractères associées aux différentes valeurs définies dans l'enumération Call::ErrorType.
	  */
	static const char* errorsArr[];
	
	/**
	  * Tableau contenant les chaînes de caractères associées aux différentes valeurs définies dans l'enumération CallMisc::Coalition.
	  */
	static const char* coalitionsArr[];
	
	/**
	  * Tableau contenant les labels autorisés à être utilisé pour l'instanciation d'un objet NoParamCall.
	  */
	static const char* noParamCallLabelsArr[];
	
	/**
	  * Tableau contenant les labels autorisés à être utilisé pour l'instanciation d'un objet UnitCall.
	  */
	static const char* unitCallLabelsArr[];
	
	/**
	  * Variable utilisée pour le chargement et le stockage des paramètres de compression. 
	  *
	  * \see ParamsMap
	  */
	static ParamsMap paramsMap;
	
	/**
	  * \brief Récupération de la valeur d'une énumération à partir d'une chaîne de caractères.
	  *
	  * La chaîne \p ch est recherchée dans le tableau \p arr et l'indice de sa position est utilisée pour récupérér la bonne valeur d'énumération.
	  *
	  * \param ch : la chaîne de caractères.
	  * \param arr : le tableau de chaînes de caractères dans lequel \p ch est recherchée.
	  *
	  * \return la valeur de l'énumération associée à \p ch.
	  *
	  * \see Call::getEnumLabel
	  */
	template<typename E>
	static E getEnumType(const char *ch, const char **arr) {
		return static_cast<E>(Trace::inArray(ch,arr));
	}

	/**
	  * \brief Récupération d'une chaîne de caractères à partir de la valeur d'une énumération.
	  *
	  * On utilise l'entier associé à la valeur de l'énumération pour récupérer la chaîne de caractères contenu dans \p arr.
	  *
	  * \param e : la valeur de l'énumération.
	  * \param arr : le tableau de chaînes de caractères où l'on récupère la chaîne.
	  *
	  * \return la chaîne de caractères associée à la valeur de l'énumération si elle peut être récupérée dans \p arr, ou NULL sinon.
	  *
	  * \see Call::getEnumType
	  */
	template<typename E>
	static const char* getEnumLabel(E e, const char **arr) {
		int ind = static_cast<int>(e);
		if (ind > -1)
			return arr[ind];
		return NULL;
	}
	
	/**
	  * \brief Récupération de la longueur (l'espace occupé dans un vecteur de traces) d'un appel.
	  *
	  * \return 1
	  */
	virtual unsigned int length() const;
	
	/**
	  * \brief Comparaison de l'objet Call avec une trace \p t.
	  *
	  * \param t : la trace utilisée pour la comparaison.
	  *
	  * \return vrai si la trace \p t est également un appel et qu'elle a les mêmes paramètres (label, type d'erreur, valeur de retour, et paramètres pris en considération lors de la compression) que cet appel.
	  */
	virtual bool operator==(Trace *t) const;
	
	/**
	  * \brief Détection des paramètres non robustes.
	  *
	  * Cette fonction est utilisée pour affecter aux paramètres non robustes de l'appel, i.e. ceux non pris en compte lors de la compression et dont la valeur diffère entre deux itération d'une même séquence, la valeur -1.
	  * Attention : cette fonction doit être appelée uniquement si operator==(c) renvoie vrai.
	  *
	  * \param c : un pointeur vers l'appel utilisé pour la comparaison.
	  */
	virtual void filterCall(const Call *c);
	
	/**
	  * \brief Affichage des informations de l'objet Call.
	  *
	  * \param os le flux de sortie utilisé pour l'affichage.
	  */
	virtual void display(std::ostream &os = std::cout) const;
	
	/**
	  * \brief Clonage d'un appel.
	  *
	  * \return une copie de l'objet Call.
	  */
	virtual Trace::sp_trace clone() const = 0;
	
	/**
	  * \brief Récupération des paramètres de l'appel sous forme de chaîne de caractères.
	  *
	  * Cette fonction est notamment utilisée lors de l'export des traces vers un document XML.
	  *
	  * \return une chaîne de caractères formatée contenant les valeurs des différents paramètres de l'appel séparées par des espaces.
	  */
	virtual std::string getParams() const = 0;
	
	/**
	  * \brief Récupération des paramètres de l'appel sous forme de chaîne de caractères.
	  *
	  * Cette fonction est notamment utilisée lors de la construction du feedback qui sera fait au joueur.
	  *
	  * \return une chaîne de caratères formatée contenant les valeurs des différents paramètres de l'appel.
	  */
	virtual std::string getReadableParams() const = 0;
	
	/**
	  * \brief Récupération des identifiants des paramètres non conformes.
	  *
	  * Si \p c pointe vers un objet Call, les identifiants des paramètres dont les valeurs diffèrent de ceux de \p c sont ajoutés à la liste. Sinon, si \p c est à NULL et si la valeur de \p error est différente de Call::ErrorType::None, alors l'identifiant du paramètre ayant causé cette erreur est ajouté à la liste.
	  * Cette fonction est utilisée lors de la construction des messages qui seront affichés au joueur.
	  *
	  * \param c : un pointeur vers l'objet Call utilisé pour la comparaison.
	  *
	  * \return la liste d'identifiants des paramètres non conformes.
	  */
	virtual std::vector<std::string> getListIdWrongParams(Call *c = NULL) const;
	
	/**
	  * \brief Calcul de la distance entre deux appels.
	  *
	  * \param c : un pointeur vers l'objet Call dont l'on souhaite mesurer la distance avec cet appel.
	  *
	  * \return la distance dans l'intervalle [0,1] entre les deux appels. Si la distance est égale à 0, les deux appels sont complètement identiques. Si elle est égale à 1, les deux appels ont des labels et/ou des types d'erreur différents.
	  */
	double getEditDistance(const Call *c) const;
	
	/**
	  * \brief Getter pour la variable \p label.
	  *
	  * \return la chaîne de caractères \p label de l'appel.
	  */
	std::string getLabel() const;
	
	/**
	  * \brief Getter pour la variable \p error.
	  *
	  * \return le type d'erreur associé à l'appel.
	  */
	ErrorType getError() const;
	
	/**
	  * \brief Ajout d'une valeur dans le tableau \p ret contenant les codes de retour de l'appel.
	  *
	  * \param code : le code retour de l'appel à sauvegarder dans le tableau \p ret.
	  *
	  * \return vrai si la valeur a bien été sauvegardée dans \p ret, et faux sinon (plus de place disponible).
	  */
	bool addReturnCode(float code);
	
	/**
	  * \brief Récupération des codes de retour sous forme de chaîne de caractères.
	  *
	  * \return une chaîne de caractères formatée contenant les valeurs du retour de l'appel séparées par des espaces.
	  */
	std::string getReturn() const;
	
	/**
	  * \brief Comparaison des codes de retour entre deux appels.
	  *
	  * \param c : un pointeur vers l'appel utilisé pour la comparaison.
	  * 
	  * \return vrai si le tableau \p ret de l'objet pointé par \p c est identique à celui de cet appel.
	  */
	bool compareReturn(const Call *c) const;
	
	/**
	  * \brief Mise à -1 de \p ind_ret.
	  *
	  * Cette fonction doit être appelée pour enregistrer le retour de l'appel comme étant un paramètre non robuste.
	  */
	void setReturn();
	
	/**
	  * \brief Indique si l'appel a un retour.
	  *
	  * \return vrai si l'appel a un retour (robuste ou non), et faux sinon. 
	  */
	bool hasReturn() const;
	
protected:

	/**
	  * \brief Comparaison entre deux appels.
	  *
	  * \param c : un pointeur vers l'objet Call utilisé pour la comparaison.
	  *
	  * \return vrai si les deux appels sont égaux, et faux sinon.
	  *
	  * \see Call::operator==
	  */
	virtual bool compare(const Call *c) const = 0;
	
	/**
	  * \brief Détection des paramètres non robustes.
	  *
	  * \param c : un pointeur vers l'objet Call utilisé pour la comparaison.
	  *
	  * \see Call::filterCall
	  */
	virtual void filter(const Call *c) = 0;
	
	/**
	  * \brief Détermination de la distance entre deux appels.
	  *
	  * \param c : un pointeur vers l'objet Call utilisé pour la comparaison.
	  *
	  * \return un couple d'entiers où le premier élément correspond au nombre de paramètres qui diffèrent entre les deux appels et où le second élément est le nombre de comparaisons effectués.
	  *
	  * \see Call::getEditDistance
	  */
	virtual std::pair<int,int> distance(const Call *c) const = 0;
	
	/**
	  * \see Call::getListIdWrongParams 
	  */
	virtual std::vector<std::string> id_wrong_params(Call *c) const = 0;
	
	/**
	  * Le label associé permettant d'identifier la fonction modélisée par l'objet Call.
	  */
	std::string label;
	
	/**
	  * Variable permettant de connaître le type d'erreur retourné lors de l'appel à la fonction Call::label, si une erreur a été retournée. Si aucune erreur n'est présente, la variable prend la valeur Call::ErrorType::NONE.
	  */
	ErrorType error;
	
	/**
	  * Indice utilisée pour remplir le tableau Call::ret.
	  */
	int ind_ret;
	
	/**
	  * Tableau contenant les valeurs de retour de l'appel à la fonction Call::label.
	  */
	float ret[MAX_SIZE_PARAMS];
		
};

#endif