#pragma once

#include <cstdio>
#include <cstring>

#include <list>
#include <string>
#include <exception>
#include <regex>

class includer {
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
	
private:
	class FileReader {
	public:
		FILE *file = nullptr;
		FileReader(const std::string &filename) {
			file = fopen(filename.data() ,"r");
			if(!file) {
				throw exception("cannot open file '" + filename + "'");
			}
		}
		~FileReader() {
			fclose(file);
		}
	};
	
	struct file_info {
		std::string name;
		int begin, end = 0;
		int size = 0;
	};
	
	std::list<file_info> files;
	std::list<file_info*> stack;
	int counter = 0;
	
	std::string incdir;
	std::string source;
	
	void add_line(const char *line) {
		source += line;
		stack.back()->size++;
		++counter;
	}
	
	void load_file(const std::string &filename) {
		char *line = nullptr;
		size_t n = 0;
		
		for(const file_info *info : stack) {
			if(info->name == filename) {
				throw exception("include recursion in file '" + filename + "'");
			}
		}
		
		std::string path = filename;
		if(incdir.size() > 0) {
			path = incdir + "/" + path;
		}
		FileReader reader(path);
		
		file_info info;
		file_info *info_ptr;
		info.name = filename;
		info.begin = counter;
		files.push_back(info);
		info_ptr = &files.back();
		
		stack.push_back(info_ptr);
		
		std::string string;
		std::smatch match;
		std::regex include("^[ \t]*#include[ ]*[\"<]([^ ]*)[\">]"), pragma("^[  \t]*#pragma[ ]*([^ \t\n]*)");
		while(getline(&line, &n, reader.file) > 0) {
			string = std::string(line);
			if(std::regex_search(string, match, include)) {
				add_line("\n");
				load_file(std::string(match[1]).data());
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
						if(prev_info.name == filename && prev_info.end != 0) {
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
		if(line != nullptr)
			free(line);
		
		info_ptr->end = counter;
		
		stack.pop_back();
	}
	
	std::pair<std::string, int> get_location(int pos) const {
		const file_info *info_ptr;
		int rpos = pos + 1;
		for(const file_info &info : files) {
			// printf("%s %d : %d\n", info.name.data(), info.begin, info.end);
			if(info.begin < pos && info.end >= pos) {
				int trpos = pos - info.begin;
				if(rpos > trpos) {
					info_ptr = &info;
					rpos = trpos;
				}
			}
		}
		for(const file_info &info : files) {
			if(info.begin >= info_ptr->begin && info.end < pos) {
				//printf("%s %d : %d\n", info.name.data(), info.begin, info.end);
				rpos -= info.size;
			}
		}
		return std::pair<std::string, int>(info_ptr->name, rpos);
	}
	
public:
	includer(const std::string &filename, const std::string &include_dir = "") {
		incdir = include_dir;
		load_file(filename);
		//printf("%s", source.data());
	}
	~includer() = default;
	
	std::string get_source() const {
		return source;
	}
	
	std::string restore_location(const std::string &msg) const {
		std::string result;
		std::string string(msg);
		// some of GLSL output formats
		std::regex expr("^[a-zA-Z:\\(\\) ]*(\\d+)[:\\(\\) ]+(\\d+)[:\\)]*"); 
		std::smatch match;
		
		while(std::regex_search(string,match,expr))
		{
			std::pair<std::string, int> pair = get_location(std::stoi(std::string(match[2])));
			result += match.prefix().str() + pair.first + ": " + std::string(match[1]) + ":" + std::to_string(pair.second);
			string = match.suffix().str();
		}
		result += string;
		
		return result;
	}
};
