#include "Call.h"

const char* Call::errorsArr[6] = {"out_of_range", "wrong_coalition", "wrong_unit", "wrong_target", "wrong_position", NULL};

Call::Call(std::string label, ErrorType err): Trace(), label(label), error(err) {}

bool Call::operator==(Trace* t) {
	bool res = false;
	if (t->getType() == CALL) {
		Call *c = dynamic_cast<Call*>(t);
		if (label.compare(c->label) == 0 && error == c->error)
			res = compare(c);
	}
	// else if (t->isSequence()) {
		// Sequence *s = dynamic_cast<Sequence*>(t);
		// if (s->size() == 1)
			// res = operator==(s->at(0).get());
	// }
	return res;
}

void Call::display(std::ostream &os) const {
	for (unsigned int i = 0; i <= numTab; i++)
		os << "\t";
	if (delayed)
		os << "delayed ";
	if (error != NONE)
		os << errorsArr[static_cast<int>(error)] << " ";
	os << label;
	os << " " << getParams() << std::endl;
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
