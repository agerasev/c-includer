#include <cstdio>

#include "includer.hpp"

int main(int argc, char *argv[]) {
	includer inc("solve-tree.frag", std::list<std::string>({"shaders"}));
	
	std::istringstream iss(inc.data());
	std::string line;
	int gpos = 0;
	std::string filename;
	int lpos;
	while(std::getline(iss, line)) {
		if(inc.locate(gpos, filename, lpos)) {
			std::ifstream file(filename);
			if(!file) {
				fprintf(stderr, "cannot open file %s\n", filename.c_str());
				continue;
			}
			std::string sline;
			for(int i = 0; i <= lpos; ++i) {
				if(!std::getline(file, sline)) {
					fprintf(stderr, "cannot read line %d in file %s\n", lpos, filename.c_str());
					break;
				}
			}
			if(sline != line) {
				fprintf(stderr, "line %d mismatch\n%s\n%s\n", gpos, line.c_str(), sline.c_str());
			}
		} else {
			fprintf(stderr, "cannot locate line %d\n", gpos);
		}
		gpos += 1;
	}
	
	return 0;
}
