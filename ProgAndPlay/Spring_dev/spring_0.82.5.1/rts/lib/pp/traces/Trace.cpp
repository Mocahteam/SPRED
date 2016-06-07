#include "Trace.h"

int Trace::numTab = 0;

Trace::Trace(TraceType type): indSearch(-1), lenSearch(1), endSearch(0), type(type), delayed(false) {}

bool Trace::isSequence() const {
	return type == SEQUENCE;
}

bool Trace::isEvent() const {
	return type == EVENT;
}

bool Trace::isCall() const {
	return type == CALL;
}

bool Trace::isDelayed() const {
	return delayed;
}

void Trace::setDelayed() {
	delayed = true;
}

const Trace::sp_trace& Trace::getParent() const {
	return parent;
}

const Trace::sp_trace& Trace::getAligned() const {
	return aligned;
}

void Trace::setParent(const sp_trace& spt) {
	parent = spt;
}

void Trace::setAligned(const sp_trace& spt) {
	aligned = spt;
}

void Trace::resetAligned() {
	aligned.reset();
}

unsigned int Trace::getLevel() const {
	unsigned int level = 0;
	sp_trace spt = parent;
	while (spt) {
		spt = spt->getParent();
		level++;
	}
	return level;
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

unsigned int Trace::getLength(const std::vector<sp_trace>& traces) {
	unsigned int len = 0;
	for (unsigned int i = 0; i < traces.size(); i++)
		len += traces.at(i)->length();
	return len;
}