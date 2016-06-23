#include "Call.h"

const char* Call::noParamCallLabelsArr[] = {"PP_Open", "PP_Close", "PP_IsGameOver", "PP_GetMapSize", "PP_GetStartPosition", "PP_GetNumSpecialAreas", NULL};
const char* Call::unitCallLabelsArr[] = {"PP_Unit_GetCoalition", "PP_Unit_GetType", "PP_Unit_GetPosition", "PP_Unit_GetHealth", "PP_Unit_GetMaxHealth", "PP_Unit_GetPendingCommands", "PP_Unit_GetGroup", "PP_Unit_GetNumPdgCmds", NULL};
const char* Call::errorsArr[] = {"out_of_range", "wrong_coalition", "wrong_unit", "wrong_target", "wrong_position", NULL};
const char* Call::coalitionsArr[] = {"MY_COALITION", "ALLY_COALITION", "ENEMY_COALITION", NULL};
ParamsMap Call::paramsMap;

Call::Call(std::string label, ErrorType err, std::string info) : Trace(CALL,info), label(label), error(err), ind_ret(0) {}

Call::Call(const Call *c) : Trace(CALL,c->info) {
	label = c->label;
	error = c->error;
	ind_ret = c->ind_ret;
	for (int i = 0; i < ind_ret; i++)
		ret[i] = c->ret[i];
}

bool Call::operator==(Trace *t) const {
	bool res = false;
	if (t->isCall()) {
		const Call *c = dynamic_cast<const Call*>(t);
		if (label.compare(c->label) == 0 && error == c->error) {
			if (!hasReturn() || !c->hasReturn() || !Call::paramsMap.contains(label,"return") || compareReturn(c))
				res = compare(c);
		}
	}
	return res;
}

double Call::getEditDistance(const Call *c) const {
	if (label.compare(c->label) == 0 && error == c->error) {
		double dis = 0;
		unsigned int tot = 2;
		if (ind_ret != 0 && c->ind_ret != 0 && label.compare("PP_GetUnitAt") != 0) {
			tot++;
			if (!compareReturn(c))
				dis++;
		}
		std::pair<int,int> sub_dis = distance(c);
		dis += sub_dis.first;
		tot += sub_dis.second;
		return dis / tot;
	}
	return EDIT_MISMATCH_SCORE;
}

void Call::filterCall(const Call *c) {
	if (!Call::paramsMap.contains(label,"return") && ind_ret > 0 && !compareReturn(c) && ind_ret > - 1)
		ind_ret = -1;
	filter(c);
}

std::vector<std::string> Call::getListIdWrongParams(Call *c) const {
	std::vector<std::string> ids;
	if (ind_ret != 0 && c->ind_ret != 0 && label.compare("PP_GetUnitAt") != 0 && !compareReturn(c))
		ids.push_back("return");
	std::vector<std::string> _ids = id_wrong_params(c);
	ids.insert(ids.end(), _ids.begin(), _ids.end());
	return ids;
}

void Call::display(std::ostream &os) const {
	for (int i = 0; i <= numTab; i++)
		os << "\t";
	if (delayed)
		os << "delayed ";
	if (error != NONE)
		os << errorsArr[static_cast<int>(error)] << " ";
	os << label;
	std::string s = getParams();
	if (s.compare("") != 0)
		os << " ";
	os << s;
	s = getReturn();
	if (ind_ret > 0 || ind_ret == -1)
		os << " - " << s;
	os << std::endl;
}

unsigned int Call::length() const {
	return 1;
}

std::string Call::getLabel() const {
	return label;
}

Call::ErrorType Call::getError() const {
	return error;
}

std::string Call::getReturn() const {
	if (ind_ret > -1) {
		std::string s = "";
		for (int i = 0; i < ind_ret; i++) {
			s += boost::lexical_cast<std::string>(ret[i]);
			if (i < ind_ret-1)
				s += " ";
		}
		return s;
	}
	return "?";
}

bool Call::addReturnCode(float code) {
	if (ind_ret < MAX_SIZE_PARAMS) {
		ret[ind_ret++] = code;
		return true;
	}
	return false;
}

bool Call::compareReturn(const Call *c) const {
	if (ind_ret == c->ind_ret) {
		for (int i = 0; i < ind_ret; i++) {
			if (ret[i] != c->ret[i])
				return false;
		}
		return true;
	}
	return false;
}

void Call::setReturn() {
	ind_ret = -1;
}

bool Call::hasReturn() const {
	return ind_ret != 0;
}

/**
 * Permet d'extraire l'ensemble des calls contenus dans le vecteur de traces donné en argument.
 * 
 * \param[in] traces le vecteur de traces dont l'on souhaite récupérer la liste de calls
 * \param[in] setMod un booléen qui est à faux si on autorise les doublons, et à vrai sinon
 *
 * \return un vecteur de calls
 */
Call::call_vector Call::getCalls(const std::vector<Trace::sp_trace>& traces, bool setMod) {
	Call::call_vector v;
	std::stack<Sequence::sp_sequence> stack;
	Trace::sp_trace spt;
	Sequence::sp_sequence sps;
	unsigned int i = 0;
	bool pass = false;
	while(i < traces.size() || !stack.empty()) {
		if (!stack.empty()) {
			while (!stack.empty() && sps->isEndReached()) {
				stack.pop();
				if (!stack.empty())
					sps = stack.top();
			}
			if (!sps->isEndReached()) {
				spt = sps->next();
				pass = true;
			}
		}
		if (stack.empty() && i < traces.size()) {
			spt = traces.at(i++);
			pass = true;
		}
		if (pass) {
			pass = false;
			if (spt->isSequence()) {
				sps = boost::dynamic_pointer_cast<Sequence>(spt);
				sps->reset();
				stack.push(sps);
			}
			else if (spt->isCall()) {
				sp_call spc = boost::dynamic_pointer_cast<Call>(spt);
				if (!setMod)
					v.push_back(spc);
				else {
					bool found = false;
					for (unsigned int j = 0; !found && j < v.size(); j++) {
						if (v.at(j)->getLabel().compare(spc->getLabel()) == 0)
							found = true;
					}
					if (!found)
						v.push_back(spc);
				}
			}
		}
	}
	return v;
}
