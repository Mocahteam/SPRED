#include "TracesParser.h"

#include <errno.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>

int compressAllTraces(std::string dir_path, bool on) {
	DIR *pdir;
	struct dirent *pent;
	pdir = opendir(dir_path.c_str());
	if (!pdir){
		perror("");
		return -1;
	}
	while ((pent = readdir(pdir))) {
		if (strchr(pent->d_name, '.') == NULL) {
			std::cout << "move to directory " << pent->d_name << std::endl;
			compressAllTraces(dir_path + "\\" + pent->d_name, on);
		}
		else if (strcmp(pent->d_name, ".") != 0 && strcmp(pent->d_name, "..") != 0) {
			std::string filename(pent->d_name);
			if (filename.find("_compressed") == std::string::npos && filename.compare("meta.log") != 0) {
				std::cout << "parse " << dir_path << "\\" << filename << std::endl;
				TracesParser tp;
				if (on)
					tp.parseTraceFileOnline(dir_path, filename);
				else
					tp.parseTraceFileOffline(dir_path, filename);
			}
		}
	}
	closedir(pdir);
	return 0;
}

int main(int argc, char *argv[]) {
	if (argc != 4 || (strcmp(argv[1], "on") != 0 && strcmp(argv[1], "off") != 0)) {
		std::cout << "Usage : parser on|off dir_path all|filename.log" << std::endl;
		return -1;
	}
	bool on = strcmp(argv[1], "on") == 0;
	if (strcmp(argv[3], "all") == 0)
		return compressAllTraces(argv[2], on);
	else {
		TracesParser tp;
		if (on)
			tp.parseTraceFileOnline(argv[2], argv[3]);
		else
			tp.parseTraceFileOffline(argv[2], argv[3]);
	}
	return 0;
}