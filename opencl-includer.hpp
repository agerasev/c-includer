#ifndef OPENCL_INCLUDER
#define OPENCL_INCLUDER

#include <string>

class CLIncluder {
private:
	static std::string load_source(const std::string &fn) throw(cl::exception)
	{
		FILE *fp;
		size_t size;
		char *source = NULL;
	
		fp = fopen(fn.data(),"r");
		if(!fp)
			throw cl::exception(std::string("Cannot open file '") + fn + std::string("'"));
	
		fseek(fp,0,SEEK_END);
		size = ftell(fp);
		fseek(fp,0,SEEK_SET);
	
		source = (char*)malloc(sizeof(char)*(size+1));
		fread(source,1,size,fp);
		source[size] = '\0';
	
		fclose(fp);
	
		std::string ret(source);
		free(source);
	
		return ret;
	}
	
	static std::vector<std::string> find_pragmas_in_source(const std::string &source)
	{
		std::string string;
		std::smatch match;
		std::regex expr;
		std::vector<std::string> result;

		string = source;
		expr = "\\b(kernel)([ ]*)([^ ]*)([ ]*)([^ \\(]*)";
		while(std::regex_search(string,match,expr))
		{
			result.push_back(match[5]);
			string = match.suffix().str();
		}
	
		string = source;
		expr = "\\b(__kernel)([ ]*)([^ ]*)([ ]*)([^ \\(]*)";
		while(std::regex_search(string,match,expr))
		{
			result.push_back(match[5]);
			string = match.suffix().str();
		}
	
		return result;
	}
	
public:
	CLIncluder(const std::string &file) {
		
	}
	~CLIncluder() = default;
	
	
};

#endif // OPENCL_INCLUDER