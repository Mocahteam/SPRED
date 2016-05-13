#include "Call.h"

const char* Call::errorsArr[6] = {"out_of_range", "wrong_coalition", "wrong_unit", "wrong_target", "wrong_position", NULL};
const ParamsMap Call::paramsMap;

Call::Call(std::string label, ErrorType err): Trace(), label(label), error(err), ind_ret(0) {}

bool Call::operator==(Trace* t) {
	bool res = false;
	if (t->isCall()) {
		Call *c = dynamic_cast<Call*>(t);
		if (label.compare(c->label) == 0 && error == c->error) {
			if (ind_ret > 0 && !compareReturn(c)) {
				if (Call::paramsMap.contains(label,"return"))
					return false;
				if (ind_ret > - 1)
					ind_ret = -1;
				if (c->ind_ret > -1)
					c->ind_ret = - 1;
			}
			res = compare(c);
		}
	}
	return res;
}

void Call::display(std::ostream &os) const {
	for (int i = 0; i <= numTab; i++)
		os << "\t";
	if (delayed)
		os << "delayed ";
	if (error != NONE)
		os << errorsArr[static_cast<int>(error)] << " ";
	os << label;
	os << " " << getParams();
	std::string s = getReturn();
	if (error == Call::NONE && paramsMap.contains(label,"return"))
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
		for (int i = 0; i < ind_ret; i++)
			s += boost::lexical_cast<std::string>(ret[i]) + " ";
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

bool Call::compareReturn(Call *c) const {
	if (ind_ret == c->ind_ret) {
		for (int i = 0; i < ind_ret; i++) {
			if (ret[i] != c->ret[i])
				return false;
		}
		return true;
	}
	return false;
}

void Call::setIndRet() {
	ind_ret = -1;
}

Call::ErrorType Call::getErrorType(const char *ch) {
	Call::ErrorType err = Call::NONE;
	int ind = Trace::inArray(ch, Call::errorsArr);
	if (ind > -1)
		err = static_cast<Call::ErrorType>(ind);
	return err;
}

const char* Call::getErrorLabel(Call::ErrorType err) {
	if (err != Call::NONE)
		return Call::errorsArr[static_cast<int>(err)];
	return NULL;
}
