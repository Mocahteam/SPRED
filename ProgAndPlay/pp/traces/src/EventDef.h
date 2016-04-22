#ifndef __EVENT_DEF_H__
#define __EVENT_DEF_H__

#include <boost/lexical_cast.hpp>

class StartMissionEvent : public Event {

public:

	StartMissionEvent(std::string mission_name, int start_time): Event("start_mission"), mission_name(mission_name), start_time(start_time) {}
	
	std::string getParams() const {
		return mission_name + " " + boost::lexical_cast<std::string>(start_time);
	}
	
	std::string getMissionName() const {
		return mission_name;
	}
	
	int getStartTime() const {
		return start_time;
	}
	
private:
	
	std::string mission_name;
	int start_time;
	
};

class EndMissionEvent : public Event {

public:

	EndMissionEvent(std::string status, int end_time): Event("end_mission"), status(status), end_time(end_time) {}
	
	std::string getParams() const {
		return status + " " + boost::lexical_cast<std::string>(end_time);
	}
	
	std::string getStatus() const {
		return status;
	}
	
	int getEndTime() const {
		return end_time;
	}
	
private:
	
	std::string status;
	int end_time;
	
};

class NewExecutionEvent : public Event {

public:

	NewExecutionEvent(int start_time): Event("new_execution"), start_time(start_time) {}
	
	std::string getParams() const {
		return boost::lexical_cast<std::string>(start_time);
	}
	
	int getStartTime() const {
		return start_time;
	}
	
private:
	
	int start_time;
	
};

class EndExecutionEvent : public Event {

public:

	EndExecutionEvent(int end_time): Event("end_execution"), end_time(end_time) {}
	
	std::string getParams() const {
		return boost::lexical_cast<std::string>(end_time);
	}
	
	int getEndTime() const {
		return end_time;
	}
	
private:
	
	int end_time;
	
};

#endif