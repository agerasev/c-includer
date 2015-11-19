#pragma once

#include <cstdio>
#include <cstring>

#include <list>
#include <string>
#include <exception>
#include <regex>

class cl_includer {
private:
	struct file_info {
		std::string name;
		int begin, end = 0;
	};
	
	std::list<file_info> files;
	std::list<std::string> stack;
	int counter = 0;
	
	std::string source;
	
	void add_line(const char *line) {
		source += line;
		++counter;
	}
	
	int load_file(const std::string &filename) {
		FILE *file;
		char *line = nullptr;
		size_t n = 0;
		int ret = 0;
		
		for(const std::string &name : stack) {
			if(name == filename) {
				printf("include recursion in file '%s'\n", filename.data());
				return -1;
			}
		}
		
		file = fopen(filename.data() ,"r");
		if(!file) {
			printf("cannot open file '%s'", filename.data());
			return -1;
		}
		
		stack.push_back(filename);
		file_info info;
		file_info *info_ptr;
		info.name = filename;
		info.begin = counter;
		files.push_back(info);
		info_ptr = &files.back();
		
		std::string string;
		std::smatch match;
		std::regex include("#include[ ]*[\"<]([^ ]*)[\">]"), pragma("#pragma[ ]*([^ \t\n]*)");
		while(getline(&line, &n, file) > 0) {
			string = std::string(line);
			if(std::regex_search(string, match, include)) {
				if(load_file(std::string(match[1]).data()) < 0) {
					ret = -1;
					break;
				}
				add_line("\n");
				continue;
			}
			if(std::regex_search(string, match, pragma)) {
				std::string keyword(match[1]);
				if(keyword == "omit") {
					add_line("\n");
					break;
				}
				if(keyword == "once") {
					int found = 0;
					for(const file_info &prev_info : files) {
						// printf("%s == %s\n", prev_info.name.data(), filename.data());
						if(prev_info.name == filename && prev_info.end != 0) {
							// printf("%s == %s\n", prev_info.name.data(), filename.data());
							found = 1;
							break;
						}
					}
					add_line("\n");
					if(found) {
						break;
					}
					continue;
				}
			}
			add_line(line);
		}
		
		info_ptr->end = counter;
		
		stack.pop_back();
		
		fclose(file);
		return 0;
	}
	
public:
	
	class exception : public std::exception {
	private:
		std::string msg;
	public:
		exception(const std::string &str) : msg(str) {}
		virtual ~exception() noexcept {}
		virtual const char *what() const noexcept override {
			return msg.data();
		}
	};
	
	cl_includer(const std::string &filename) {
		load_file(filename);
		printf("%s", source.data());
	}
	~cl_includer() = default;
	
	
};
