#include "Sequence.h"

Sequence::Sequence(std::string info, bool num_fixed) : Trace(SEQUENCE,info), num_fixed(num_fixed), num(0), pt(0), endReached(false), shared(false), root(false) {}

Sequence::Sequence(unsigned int num, bool root) : Trace(SEQUENCE), num_fixed(false), num(num), pt(0), endReached(false), shared(false), root(root) {
	updateNumMap(num);
}

Sequence::Sequence(const_sp_sequence sps) : Trace(sps.get()), pt(0), endReached(false), shared(false) {
	num = sps->getNum();
	num_fixed = sps->hasNumberIterationFixed();
	root = sps->isRoot();
	updateNumMap(sps->getNumMap());
}

Sequence::Sequence(const_sp_sequence sps_up, const_sp_sequence sps_down) : Trace(SEQUENCE), num_fixed(false), pt(0), endReached(false), shared(true), root(false) {
	num = std::max(sps_up->getNum(),sps_down->getNum());
	updateNumMap(sps_up->getNumMap());
	updateNumMap(sps_down->getNumMap());
}

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
	bool res = false;
	if (t->isSequence()) {
		Sequence *s = dynamic_cast<Sequence*>(t);
		Call::call_vector calls = getCalls();
		Call::call_vector s_calls = s->getCalls();
		if (calls.size() == s_calls.size()) {
			res = true;
			for (unsigned int i = 0; res && i < calls.size(); i++) {
				if (!calls.at(i)->operator==(s_calls.at(i).get()))
					res = false;
			}
		}
	}
	return res;
}

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
	if (!root)
		os << "Sequence < " << getNumMapString(getPercentageNumMap()) << " >" << std::endl;
	else
		os << "Root" << std::endl;
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

int Sequence::getIndex(const Trace::sp_trace& spt) const {
	for (unsigned int i = 0; i < traces.size(); i++) {
		if (traces.at(i) == spt)
			return i;
	}
	return -1;
}

bool Sequence::isRoot() const {
	return root;
}

unsigned int Sequence::getNum() const {
	return num;
}

bool Sequence::hasNumberIterationFixed() const {
	return num_fixed;
}

void Sequence::addOne() {
	updateNumMap(num,-1);
	updateNumMap(++num);	
}

unsigned int Sequence::size() const {
	return traces.size();
}

const Trace::sp_trace& Sequence::at(unsigned int i) const {
	if (i >= traces.size())
		throw std::runtime_error("cannot access to the trace at position 'i' in 'traces' vector");
	return traces.at(i);
}

bool Sequence::addTrace(Trace::sp_trace spt, int ind) {
	if (ind >= -1 && ind <= (int)traces.size()) {
		if (ind == -1)
			traces.push_back(spt);
		else
			traces.insert(traces.begin()+ind, spt);
		spt->setParent(shared_from_this());
		return true;
	}
	return false;
}

const Trace::sp_trace& Sequence::next() {
	if (pt >= traces.size())
		throw std::runtime_error("cannot access to the trace at position 'pt' in 'traces' vector");
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

bool Sequence::isImplicit() const {
	return numMap.size() == 1 && numMap.find(1) != numMap.end() && numMap.at(1) == 1;
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
		if (update < 0 && numMap.at(num) <= 0)
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

void Sequence::completeNumMap() {
	if (getParent()) {
		Sequence::sp_sequence sps = boost::dynamic_pointer_cast<Sequence>(getParent());
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

/**
 * \brief Extraction de l'ensemble des sequences contenus dans le vecteur de traces de la séquence. La séquence appelante est inclus dans le résultat.
 * 
 * \return un vecteur de sequences
 */
Sequence::sequence_vector Sequence::getSequences() {
	Sequence::sequence_vector v;
	Trace::sp_trace spt;
	Sequence::sp_sequence sps = shared_from_this();
	sps->reset();
	std::stack<Sequence::sp_sequence> stack;
	stack.push(sps);
	v.push_back(sps);
	while(!stack.empty()) {
		while (!stack.empty() && sps->isEndReached()) {
			stack.pop();
			if (!stack.empty())
				sps = stack.top();
		}
		if (!sps->isEndReached()) {
			spt = sps->next();
			if (spt->isSequence()) {
				sps = boost::dynamic_pointer_cast<Sequence>(spt);
				sps->reset();
				stack.push(sps);
				v.push_back(sps);
			}
		}
	}
	return v;
}

/**
 * \brief Extraction de l'ensemble des calls contenus dans le vecteur de traces de la séquence
 * 
 * \param setMod : un booléen qui est à faux si on autorise les doublons, et à vrai sinon
 *
 * \return un vecteur de calls
 */
Call::call_vector Sequence::getCalls(bool setMod) {
	Call::call_vector v;
	Sequence::sp_sequence sps = shared_from_this();
	if (sps->length() > 0) {
		Trace::sp_trace spt;
		sps->reset();
		std::stack<Sequence::sp_sequence> stack;
		stack.push(sps);
		while(!stack.empty()) {
			while (!stack.empty() && sps->isEndReached()) {
				stack.pop();
				if (!stack.empty())
					sps = stack.top();
			}
			if (!sps->isEndReached()) {
				spt = sps->next();
				if (spt->isSequence()) {
					sps = boost::dynamic_pointer_cast<Sequence>(spt);
					sps->reset();
					stack.push(sps);
				}
				else if (spt->isCall()) {
					Call::sp_call spc = boost::dynamic_pointer_cast<Call>(spt);
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
	}
	return v;
}