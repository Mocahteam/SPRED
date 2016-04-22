#include "Event.h"

Event::Event(std::string label): Trace(EVENT), label(label) {}

bool Event::operator==(Trace* t) {
	bool res = false;
	if (t->getType() == EVENT) {
		Event *e = dynamic_cast<Event*>(t);
		if (label.compare(e->label) == 0)
			res = true;
	}
	// else if (t->isSequence()) {
		// Sequence *s = dynamic_cast<Sequence*>(t);
		// if (s->size() == 1)
			// res = operator==(s->at(0).get());
	// }
	return res;
}

void Event::display(std::ostream &os) const {
	unsigned int i = 0;
	for (i = 0; i <= numTab; i++)
		os << "\t";
	os << label;
	os << " " << getParams() << std::endl;
}

unsigned int Event::length() const {
	return 1;
}

std::string Event::getLabel() const {
	return label;
}

std::string Event::getParams() const {
	return "";
}