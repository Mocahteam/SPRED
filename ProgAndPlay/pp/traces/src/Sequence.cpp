#include "Sequence.h"

Sequence::Sequence(): Trace(SEQUENCE), num(0), pt(0), valid(false), endReached(false), shared(false) {}

Sequence::Sequence(unsigned int num): Trace(SEQUENCE), num(num), pt(0), valid(false), endReached(false), shared(false) {
	updateNumMap(num);
}

Sequence::Sequence(sp_sequence sps): Trace(SEQUENCE), pt(0), valid(false), endReached(false), shared(false) {
	num = sps->getNum();
	updateNumMap(sps->getNumMap());
}

Sequence::Sequence(sp_sequence sps_up, sp_sequence sps_down): Trace(SEQUENCE), pt(0), valid(false), endReached(false), shared(true) {
	num = std::max(sps_up->getNum(),sps_down->getNum());
	updateNumMap(sps_up->getNumMap());
	updateNumMap(sps_down->getNumMap());
}

bool Sequence::operator==(Trace *t) {
	bool res = false;
	if (t->isSequence()) {
		Sequence *s = dynamic_cast<Sequence*>(t);
		if (traces.size() == s->size()) {
			for (unsigned int i = 0; i < traces.size(); i++) {
				if (!at(i)->operator==(s->at(i).get()))
					return false;
			}
			res = true;
		}
	}
	return res;
}

bool Sequence::compare(Trace* t) {
	bool res = false, next_up = false, next_down = false;
	if (t->isSequence()) {
		Sequence *s = dynamic_cast<Sequence*>(t);
		if (length() == s->length()) {
			reset();
			s->reset();
			std::stack<Sequence*> upStack;
			upStack.push(this);
			std::stack<Sequence*> downStack;
			downStack.push(s);
			Trace *up = next().get();
			Trace *down = s->next().get();
			while (!upStack.empty() || !downStack.empty()) {
				while (up->isSequence()) {
					s = dynamic_cast<Sequence*>(up);
					upStack.push(s);
					up = s->next().get();
				}
				while (down->isSequence()) {
					s = dynamic_cast<Sequence*>(down);
					downStack.push(s);
					down = s->next().get();
				}
				next_up = up->isEvent();
				next_down = down->isEvent();
				if (!next_up && !next_down) {
					if (up->operator==(down)) {
						next_up = true;
						next_down = true;
					}
					else
						break;
				}
				if (next_up) {
					s = upStack.top();
					while (!upStack.empty() && s->isEndReached()) {
						upStack.pop();
						if (!upStack.empty())
							s = upStack.top();
					}
					up = s->next().get();
					next_up = false;
				}
				if (next_down) {
					s = downStack.top();
					while (!downStack.empty() && s->isEndReached()) {
						downStack.pop();
						if (!downStack.empty())
							s = downStack.top();
					}
					down = s->next().get();
					next_down = false;
				}
			}
			if (upStack.empty() && downStack.empty())
				res = true;
		}
	}
	return res;
}

void Sequence::display(std::ostream &os) const {
	numTab++;
	for (int i = 0; i < numTab; i++)
		os << "\t";
	if (delayed)
		os << "delayed ";
	os << "Sequence < " << getNumMapString() << " >" << std::endl;
	for (unsigned int i = 0; i < traces.size(); i++)
		traces.at(i)->display(os);
	numTab--;
}

unsigned int Sequence::length() const {
	unsigned int len = 0;
	for (unsigned int i = 0; i < traces.size(); i++)
		len += traces.at(i)->length();
	return len;
}

void Sequence::removeRedundancies(std::vector<sp_trace>& traces) {
	int cpt;
	sp_sequence sps;
	std::vector<sp_trace>::iterator it = traces.begin();
	while (it != traces.end()) {
		if ((*it)->isSequence()) {
			sps = boost::dynamic_pointer_cast<Sequence>(*it);
			sps->removeRedundancies(sps->getTraces());
		}
		else if (!(*it)->isEvent() || Trace::inArray(boost::dynamic_pointer_cast<Event>(*it)->getLabel().c_str(), Event::noConcatEventsArr) == -1) {
			std::vector<sp_trace>::iterator _it = it+1;
			cpt = 1;
			while (_it != traces.end() && (*it)->operator==((*_it).get())) {
				cpt++;
				_it++;
			}
			if (cpt > 1) {
				sps = boost::make_shared<Sequence>(cpt);
				sps->addTrace(*it);
				traces.erase(it,_it);
				it = traces.insert(it,sps);
			}
		}
		it++;
	}
}

std::vector<sp_trace>& Sequence::getTraces() {
	return traces;
}

unsigned int Sequence::getNum() const {
	return num;
}

void Sequence::addOne() {
	updateNumMap(num,-1);
	updateNumMap(++num);	
}

unsigned int Sequence::size() const {
	return traces.size();
}

const sp_trace& Sequence::at(unsigned int i) const {
	return traces.at(i);
}

void Sequence::addTrace(const sp_trace& spt) {
	traces.push_back(spt);
}

const sp_trace& Sequence::next() {
	const sp_trace& spt = traces.at(pt++);
	if (pt == traces.size()) {
		pt = 0;
		endReached = true;
	}
	else if (pt == 1 && endReached)
		endReached = false;
	return spt;
}

unsigned int Sequence::getPt() const {
	return pt;
}

void Sequence::reset() {
	pt = 0;
	endReached = false;
	Sequence *s;
	for (unsigned int i = 0; i < traces.size(); i++) {
		if (traces.at(i)->isSequence()) {
			s = dynamic_cast<Sequence*>(traces.at(i).get());
			s->reset();
		}
	}
}

bool Sequence::isEndReached() const {
	return endReached;
}

bool Sequence::isShared() const {
	return shared;
}

bool Sequence::isValid() const {
	return valid;
}

void Sequence::setValid(bool v) {
	valid = v;
	if (!v) {
		sp_sequence sps;
		for (unsigned int i = 0; i < traces.size(); i++) {
			if (traces.at(i)->isSequence()) {
				sps = boost::dynamic_pointer_cast<Sequence>(traces.at(i));
				sps->setValid(v);
			}
		}
	}
}

bool Sequence::checkValid() {
	sp_sequence sps;
	for (unsigned int i = 0; i < traces.size(); i++) {
		if (traces.at(i)->isSequence()) {
			sps = boost::dynamic_pointer_cast<Sequence>(traces.at(i));
			if (!sps->isValid())
				return false;
		}
	}
	return true;
}

bool Sequence::isUniform() const {
	if (!traces.empty()) {
		Trace *t = traces.at(0).get();
		for (unsigned int i = 1; i < traces.size(); i++) {
			if (!t->operator==(traces.at(i).get()))
				return false;
		}
	}
	return true;
}

bool Sequence::checkDelayed() {
	if (!delayed) {
		for (unsigned i = 0; i < traces.size(); i++) {
			if (traces.at(i)->isSequence()) {
				Sequence *s = dynamic_cast<Sequence*>(traces.at(i).get());
				if (!s->checkDelayed())
					return false;
			}
			else if (!traces.at(i)->isDelayed())
				return false;
		}
		delayed = true;
	}
	return delayed;
}

const std::map<unsigned int,unsigned int>& Sequence::getNumMap() const {
	return numMap;
}

std::string Sequence::getNumMapString() const {
	std::string s = "";
	std::map<unsigned int,unsigned int>::const_iterator it = numMap.begin();
	while (it != numMap.end()) {
		if (it != numMap.begin())
			s += " ";
		s += boost::lexical_cast<std::string>(it->first) + ":" + boost::lexical_cast<std::string>(it->second);
		it++;
	}
	return s;
}

void Sequence::updateNumMap(unsigned int num, int update) {
	if (numMap.find(num) == numMap.end())
		numMap.insert(std::make_pair<unsigned int, unsigned int>(num,update));
	else {
		numMap.at(num) += update;
		if (update < 0 && numMap.at(num) == 0)
			numMap.erase(num);
	}
}

void Sequence::updateNumMap(const std::map<unsigned int,unsigned int>& numMap) {
	std::map<unsigned int, unsigned int>::const_iterator it = numMap.begin();
	while (it != numMap.end()) {
		updateNumMap(it->first,it->second);
		it++;
	}
}