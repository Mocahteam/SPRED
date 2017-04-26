#include <errno.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>

#include "TracesParser.h"
#include "TracesAnalyser.h"

static std::string dir_path = "C:\\Program Files (x86)\\Spring\\traces";
static std::string mission_name;
static TracesParser tp(false);

int compressAllTraces(std::string dir_path) {
	DIR *pdir;
	struct dirent *pent;
	pdir = opendir(dir_path.c_str());
	if (!pdir) {
		perror("");
		return -1;
	}
	while ((pent = readdir(pdir))) {
		if (strchr(pent->d_name, '.') == NULL) {
			std::cout << "move to directory " << pent->d_name << std::endl;
			compressAllTraces(dir_path + "\\" + pent->d_name);
		}
		else if (strcmp(pent->d_name, ".") != 0 && strcmp(pent->d_name, "..") != 0) {
			std::string filename(pent->d_name);
			if (filename.find("_compressed") == std::string::npos && filename.find(".log") != std::string::npos && filename.compare("meta.log") != 0) {
				std::cout << "parse " << dir_path << "\\" << filename << std::endl;
				tp.parseTraceFileOffline(dir_path, filename);
			}
		}
	}
	closedir(pdir);
	return 0;
}

const std::string loadFile(std::string full_path) {
	std::string res;
	std::ifstream in(full_path.c_str());
	if (in.good()) {
		std::string line;
		while(std::getline(in,line))
			res += line;
	}
	return res;
}

std::vector<std::string> loadExpertsXml() {
	std::vector<std::string> experts_xml;
	std::string path = "expert\\" + mission_name;
	DIR *pdir;
	struct dirent *pent;
	pdir = opendir(path.c_str());
	if (pdir) {
		while ((pent = readdir(pdir))) {
			std::string name = pent->d_name;
			if (name.find(".xml") != std::string::npos && name.compare("feedbacks.xml") != 0)
				experts_xml.push_back(loadFile(path + "\\" + name));
		}
	}
	closedir(pdir);
	return experts_xml;
}

int main(int argc, char *argv[]) {
	if (argc < 2 || argc > 4 || strcmp(argv[1],"-h") == 0 || strcmp(argv[1],"--help") == 0) {
		std::cout << "Usage : parser all|filename [dir_path] [-la]\n\n";
		std::cout << "all : all complete traces files present in dir_path directory and its subdirectories (recursively) will be compressed\n\n";
		std::cout << "filename : the complete traces file named filename will be compressed. This file must have the extension .log\n\n";
		std::cout << "dir_path : path to the directory containing complete traces files\n\n";
		std::cout << "-la : launch analysis after compression. If this option is used :\n\n";
		std::cout << "\t- \"params.json\" can be present in the same directory. If not, the default compression mod will be used.\n";
		std::cout << "\t- \"feedbacks.xml\" must be present in the same directory\n";
		std::cout << "\t- \"feedbacks.xml\" in the directory \"expert\\mission_name\" can be present to add extra feedbacks for the mission\n";
		std::cout << "\t- there must be at least one solution (an XML file) for the mission in the directory \"expert\\mission_name\"\n\n";
		return -1;
	}
	bool analysis = (argc == 3 && strcmp(argv[2],"-la") == 0) || (argc == 4 && strcmp(argv[3],"-la") == 0);
	if (argc >= 3 && strcmp(argv[2],"-la") != 0)
		dir_path = argv[2];
	std::string params_json = loadFile("./params.json");
	if (params_json.compare("") != 0)
		tp.initParamsMap(params_json);
	if (strcmp(argv[1], "all") == 0)
		return compressAllTraces(dir_path);
	else {
		// Compression
		tp.parseTraceFileOffline(dir_path, argv[1]);
		std::cout << "traces compressed" << std::endl;
		if (analysis) {
			std::cout << "launch analysis" << std::endl;
			// Analysis
			TracesAnalyser ta;
			mission_name = argv[1];
			mission_name.replace(mission_name.find(".log"), 4, "");
			const std::string feedbacks_xml = loadFile("./feedbacks.xml");
			const std::string mission_feedbacks_xml = loadFile("expert\\" + mission_name + "\\feedbacks.xml");
			ta.loadXmlInfos(feedbacks_xml,mission_feedbacks_xml);
			std::vector<std::string> experts_xml = loadExpertsXml();
			if (experts_xml.empty())
				std::cout << "no expert solutions" << std::endl;
			std::string json = ta.constructFeedback(loadFile(std::string(dir_path) + "\\" + mission_name + "_compressed.xml"), experts_xml);
			std::cout << json << std::endl;	
			std::ofstream jsonFile;
			jsonFile.open("feedback.json");
			if (jsonFile.good()) {
				jsonFile << json;
				jsonFile.close();
			}
		}
	}
	return 0;
}