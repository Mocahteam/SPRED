#include "Sequence.h"

Sequence::Sequence(unsigned int num, bool shared): Trace(SEQUENCE), num(num), pt(0), valid(false), endReached(false), shared(shared) {}

bool Sequence::operator==(Trace* t) {
	bool res = false;
	if (t->isSequence()) {
		Sequence *s = dynamic_cast<Sequence*>(t);
		if (length() == s->length()) {
			reset();
			s->reset();
			std::stack<Sequence*> firstStack;
			firstStack.push(this);
			std::stack<Sequence*> secondStack;
			secondStack.push(s);
			Trace *first = next().get();
			Trace *second = s->next().get();
			while (!firstStack.empty() && !secondStack.empty()) {
				while (first->isSequence()) {
					s = dynamic_cast<Sequence*>(first);
					firstStack.push(s);
					first = s->next().get();
				}
				while (second->isSequence()) {
					s = dynamic_cast<Sequence*>(second);
					secondStack.push(s);
					second = s->next().get();
				}
				if (first->operator==(second)) {
					s = firstStack.top();
					while (!firstStack.empty() && s->isEndReached()) {
						firstStack.pop();
						if (!firstStack.empty())
							s = firstStack.top();
					}
					first = s->next().get();
					s = secondStack.top();
					while (!secondStack.empty() && s->isEndReached()) {
						secondStack.pop();
						if (!secondStack.empty())
							s = secondStack.top();
					}
					second = s->next().get();
				}
				else
					break;
			}
			if (firstStack.empty() && secondStack.empty())
				res = true;
		}
	}
	// else if (traces.size() == 1)
		// res = at(0)->operator==(t);
	return res;
}

void Sequence::display(std::ostream &os) const {
	unsigned int i = 0;
	numTab++;
	for (i = 0; i < numTab; i++)
		os << "\t";
	if (delayed)
		os << "delayed ";
	os << "Sequence(" << num << ")" << std::endl;
	for (i = 0; i < traces.size(); i++)
		traces.at(i)->display(os);
	numTab--;
}

unsigned int Sequence::length() const {
	unsigned int len = 0;
	for (unsigned int i = 0; i < traces.size(); i++)
		len += traces.at(i)->length();
	return len;
}

void Sequence::removeRedundancies() {
	int cpt;
	sp_sequence sps;
	std::vector<sp_trace>::iterator it = traces.begin();
	while (it != traces.end()) {
		if ((*it)->isSequence())
			boost::dynamic_pointer_cast<Sequence>(*it)->removeRedundancies();
		else {
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

unsigned int Sequence::getNum() const {
	return num;
}

void Sequence::addOne() {
	num++;
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
}

void Sequence::resetValid(bool v) {
	for (unsigned int i = 0; i < traces.size(); i++) {
		if (traces.at(i).get()->isSequence()) {
			Sequence *s = dynamic_cast<Sequence*>(traces.at(i).get());
			s->setValid(v);
		}
	}
}

bool Sequence::checkValid() {
	for (unsigned int i = 0; i < traces.size(); i++) {
		if (traces.at(i).get()->isSequence()) {
			Sequence *s = dynamic_cast<Sequence*>(traces.at(i).get());
			if (!s->isValid())
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
		unsigned int i;
		for (i = 0; i < traces.size(); i++) {
			if (!traces.at(i).get()->isDelayed()) {
				break;
			}
		}
		if (i == traces.size())
			delayed = true;
	}
	return delayed;
}