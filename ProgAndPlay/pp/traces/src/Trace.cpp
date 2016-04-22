#include "Trace.h"

unsigned int Trace::numTab = 0;

Trace::Trace(TraceType type): indSearch(-1), lenSearch(1), endSearch(0), type(type), delayed(false) {}

Trace::TraceType Trace::getType() const {
	return type;
}

bool Trace::isSequence() const {
	return type == SEQUENCE;
}

bool Trace::isDelayed() const {
	return delayed;
}

void Trace::setDelayed() {
	delayed = true;
}

int Trace::inArray(const char *ch, const char *arr[]) {
	unsigned int i = 0;
	while (arr[i] != NULL) {
		if (strcmp(ch, arr[i]) == 0)
			return i;
		i++;
	}
	return -1;
}