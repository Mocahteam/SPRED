#include "Event.h"

const char* Event::concatEventsArr[] = {"game_paused", "game_unpaused", NULL};
const char* Event::noConcatEventsArr[] = {"start_mission", "end_mission", "new_execution", "end_execution", "eof", NULL};

Event::Event(std::string label): Trace(EVENT), label(label) {}

bool Event::operator==(Trace *t) const {
	bool res = false;
	if (t->isEvent()) {
		Event *e = dynamic_cast<Event*>(t);
		if (label.compare(e->label) == 0)
			res = true;
	}
	return res;
}

void Event::display(std::ostream &os) const {
	for (int i = 0; i <= numTab; i++)
		os << "\t";
	os << label;
	os << " " << getParams() << std::endl;
}

unsigned int Event::length() const {
	return 0;
}

std::string Event::getLabel() const {
	return label;
}

std::string Event::getParams() const {
	return "";
}