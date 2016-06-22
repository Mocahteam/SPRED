#include "Sequence.h"
#include "TracesAnalyser.h"

Sequence::Sequence(std::string info, bool index) : Trace(SEQUENCE,info), index(index), num(0), pt(0), valid(false), endReached(false), shared(false) {}

Sequence::Sequence(unsigned int num) : Trace(SEQUENCE), index(false), num(num), pt(0), valid(false), endReached(false), shared(false) {
	updateNumMap(num);
}

Sequence::Sequence(const_sp_sequence sps) : Trace(SEQUENCE,sps->getInfo()), pt(0), valid(false), endReached(false), shared(false) {
	num = sps->getNum();
	index = sps->hasIndex();
	updateNumMap(sps->getNumMap());
}

Sequence::Sequence(const_sp_sequence sps_up, const_sp_sequence sps_down) : Trace(SEQUENCE), index(false), pt(0), valid(false), endReached(false), shared(true) {
	num = std::max(sps_up->getNum(),sps_down->getNum());
	updateNumMap(sps_up->getNumMap());
	updateNumMap(sps_down->getNumMap());
}

// deprecated. A remplacer par le code de la fonction compare
bool Sequence::operator==(Trace *t) const {
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

void Sequence::resetAligned() {
	Trace::resetAligned();
	for (unsigned int i = 0; i < traces.size(); i++)
		traces.at(i)->resetAligned();
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

//Version alternative de compare
// bool Sequence::compare(Trace* t) {
	// bool res = false;
	// if (t->isSequence()) {
		// Sequence *s = dynamic_cast<Sequence*>(t);
		// Call::call_vector calls = Call::getCalls(getTraces());
		// Call::call_vector s_calls = Call::getCalls(s->getTraces());
		// if (calls.size() == s_calls.size()) {
			// res = true;
			// for (unsigned int i = 0; res && i < calls.size(); i++) {
				// if (!calls.at(i)->operator==(s_calls.at(i).get()))
					// res = false;
			// }
		// }
	// }
	// return res;
// }

Trace::sp_trace Sequence::clone() const {
	sp_sequence sps_clone = boost::make_shared<Sequence>(shared_from_this());
	for (unsigned int i = 0; i < traces.size(); i++)
		sps_clone->addTrace(traces.at(i)->clone());
	return sps_clone;
}

void Sequence::display(std::ostream &os) const {
	numTab++;
	for (int i = 0; i < numTab; i++)
		os << "\t";
	if (delayed)
		os << "delayed ";
	os << "Sequence < " << getNumMapString(getPercentageNumMap()) << " >" << std::endl;
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

std::vector<Trace::sp_trace>& Sequence::getTraces() {
	return traces;
}

unsigned int Sequence::getNum() const {
	return num;
}

bool Sequence::hasIndex() const {
	return index;
}

void Sequence::addOne() {
	updateNumMap(num,-1);
	updateNumMap(++num);	
}

unsigned int Sequence::size() const {
	return traces.size();
}

const Trace::sp_trace& Sequence::at(unsigned int i) const {
	return traces.at(i);
}

void Sequence::addTrace(const Trace::sp_trace& spt) {
	traces.push_back(spt);
}

const Trace::sp_trace& Sequence::next() {
	const Trace::sp_trace& spt = traces.at(pt++);
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

std::map<unsigned int,double> Sequence::getPercentageNumMap() const {
	std::map<unsigned int,double> pNumMap;
	std::map<unsigned int,unsigned int>::const_iterator it = numMap.begin();
	double sum = 0;
	while(it != numMap.end())
		sum += (it++)->second;
	it = numMap.begin();
	while(it != numMap.end()) {
		pNumMap.insert(std::make_pair<unsigned int,double>(it->first,it->second/sum));
		it++;
	}
	return pNumMap;
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

void Sequence::completeNumMap(const Sequence::sp_sequence& sps) {
	unsigned int num = 0;
	std::map<unsigned int,unsigned int>::const_iterator it = sps->getNumMap().begin();
	while(it != sps->getNumMap().end()) {
		num += it->first * it->second;
		it++;
	}
	if (numMap.find(1) != numMap.end()) {
		it = numMap.begin();
		while (it != numMap.end()) {
			num -= it->second;
			it++;
		}
		updateNumMap(1,num);
	}
}

double Sequence::getNumMapMeanDistance(const Sequence::sp_sequence& sps) const {
	std::map<unsigned int,double> fmap = getPercentageNumMap();
	std::map<unsigned int,double> smap = sps->getPercentageNumMap();
	double fm = 0, sm = 0;
	std::map<unsigned int,double>::const_iterator it = fmap.begin();
	while (it != fmap.end()) {
		fm += it->first * it->second;
		it++;
	}
	it = smap.begin();
	while (it != smap.end()) {
		sm += it->first * it->second;
		it++;
	}
	return std::abs(fm - sm) / (fm + sm);
}

bool Sequence::isImplicit() {
	return numMap.size() == 1 && numMap.find(1) != numMap.end() && numMap.at(1) == 1;
}