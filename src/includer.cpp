#include <cassert>
#include <regex>
#include <fstream>
#include <sstream>

#include "includer.hpp"


includer::_branch::_branch(int p) : pos(p) {
    
}
includer::_branch::~_branch() {
    for(_branch *b : inner) {
        delete b;
    }
}
includer::_branch *includer::_branch::add(int p) {
    _branch *b = new _branch(p);
    b->parent = this;
    inner.push_back(b);
    return b;
}
void includer::_branch::pop() {
    assert(inner.size() > 0);
    delete inner.back();
    inner.pop_back();
}

std::string includer::_branch::dir() const {
    size_t dpos = 0;
    for (size_t i = 0; i < fullname.size(); ++i) {
        if (fullname[i] == '/') {
            dpos = i;
        }
    }
    return fullname.substr(0, dpos);
}

std::unique_ptr<std::istream> includer::_open(
    const std::string &fullname
) const {
    auto i = _fmem.find(fullname);

    if (i != _fmem.end()) {
        return std::make_unique<std::stringstream>(i->second);
    } else {
        return std::make_unique<std::ifstream>(fullname);
    }
}
std::pair<std::unique_ptr<std::istream>, std::string> includer::_find(
    const std::string &name,
    const std::string &dir
) const {
    std::unique_ptr<std::istream> file;
    std::string fullname;

    // try open file in each dir

    // relative include
    if (dir.size() > 0) {
        fullname = dir + "/" + name;
        file = _open(fullname);
    }
    // include from dirs specified
    if(dir.size() == 0 || !(file && *file)) {
        for(const std::string &dir : _dirs) {
            fullname = dir + "/" + name;
            file = _open(fullname);
            if(*file) {
                break;
            }
        }
    }
    // global include
    if (!(file && *file)) {
        fullname = name;
        file = _open(fullname);
    }
    //assert(file && *file);

    return std::make_pair(std::move(file), std::move(fullname));
}

static bool _is_whitespace(char c) {
    return c == ' ' || c == '\t';
}
static bool _is_symbol(char c) {
    return !_is_whitespace(c);
}
static bool _is_letter(char c) {
    return 
        (c >= '0' && c <= '9') ||
        (c >= 'A' && c <= 'Z') ||
        (c >= 'a' && c <= 'z') ||
        (c == '_' || c == '$');
}

static bool _skip_whitespaces(const std::string &line, size_t &p) {
    for (; p < line.size() && _is_whitespace(line[p]); ++p) {}
    return p >= line.size();
}
static std::string _read_word(const std::string &line, size_t &p, bool(*check)(char)=_is_letter) {
    std::string word; 
    for (; p < line.size() && check(line[p]); ++p) {
        word += line[p];
    }
    return word;
}

static bool _directive(const std::string &line, std::string &directive, std::string &value) {
    directive.clear();
    value.clear();
    size_t p = 0;
    if (_skip_whitespaces(line, p)) { return false; }
    if (line[p] != '#') {
        // not a directive
        return false;
    }
    p += 1;
    if (_skip_whitespaces(line, p)) { return true; }
    directive = _read_word(line, p);
    if (_skip_whitespaces(line, p)) { return true; }
    value = _read_word(line, p, _is_symbol);
    return true;
}

bool includer::_read(const std::string name, _branch *branch, int depth) {
    assert(depth < 16);
    
    auto p = _find(
        name,
        branch->parent != nullptr ? branch->parent->dir() : ""
    );
    std::unique_ptr<std::istream> file = std::move(p.first);
    std::string fullname = std::move(p.second);
    
    if(!*file) {
        if (branch->parent != nullptr) {
            _log += "\n" + (
                branch->parent->fullname + ":" +
                std::to_string(branch->parent->lsize + 1) + ": " +
                "cannot open file '" + name + "'"
            );
        } else {
            _log += "\n" + ("cannot open file '" + name + "'");
        }
        return false;
    }

    for(const std::string &n : _ignore) {
        if(n == fullname) {
            return false;
        }
    }

    branch->name = name;
    branch->fullname = fullname;
    
    // read file line by line
    std::string line;
    std::vector<int> gates;
    bool gate_skip = false;
    while(std::getline(*file, line)) {
        std::string directive, value;
        bool skip = false;
        if (_directive(line, directive, value)) {
            if (directive == "if" || directive == "ifdef" || directive == "ifndef" ||
                directive == "else" || directive == "endif") {
                if (directive == "endif") {
                    assert(!gates.empty());
                    if (gates.back() < 2) {
                        skip = true;
                    }
                    gates.pop_back();
                } else if (directive == "else") {
                    assert(!gates.empty());
                    if (gates.back() < 2) {
                        gates.back() = !gates.back();
                        skip = true;
                    }
                } else {
                    int gate_type = 2;
                    if (directive != "if") {
                        auto it = _defs.find(value);
                        if (it != _defs.end()) {
                            if (directive == "ifdef") {
                                gate_type = it->second;
                            } else {
                                gate_type = !it->second;
                            }
                        }
                    }
                    if (gate_type < 2) {
                        skip = true;
                    }
                    gates.push_back(gate_type);
                }
                gate_skip = false;
                for (int x : gates) {
                    if (x < 2) {
                        gate_skip = gate_skip || !x;
                    }
                }
            } else if(directive == "include" && !gate_skip) {
                if (value.size() > 2 && (
                    (value[0] == '"' && value[value.size() - 1] == '"') ||
                    (value[0] == '<' && value[value.size() - 1] == '>')
                )) {
                    skip = true;
                    std::string path = value.substr(1, value.size() - 2);
                    _branch *b = branch->add(branch->pos + branch->size);
                    if (_read(path, b, depth + 1)){
                        branch->size += b->size;
                    } else {
                        branch->pop();
                    }
                }
            } else if(directive == "pragma" && !gate_skip) {
                if(value == "once") {
                    skip = true;
                    _ignore.push_back(fullname);
                }
            }
        }
        if (!skip && !gate_skip) {
            _data += line;
        }
        _data += "\n";
        branch->size += 1;
        branch->lsize += 1;
    }
    assert(gates.empty());

    return true;
}

bool includer::_locate(int gp, const _branch *br, std::string &fn, int &lp) const {
    if(gp < br->pos || gp >= br->pos + br->size) {
        return false;
    }
    int shift = gp - br->pos;
    for(const _branch *b : br->inner) {
        if(gp < b->pos) {
            break;
        }
        if(_locate(gp, b, fn, lp)) {
            return true;
        }
        shift -= b->size;
    }
    lp = shift;
    fn = br->fullname;
    return true;
}

includer::includer(
    const std::string &name,
    const std::list<std::string> &dirs,
    const std::map<std::string, std::string> &fmem,
    const std::map<std::string, bool> &defs
):
    _name(name), _dirs(dirs), _fmem(fmem), _defs(defs), _trunk(0)
{}

bool includer::include() {
    return _read(_name, &_trunk);
}

const std::string &includer::log() const {
    return _log;
}

const std::string &includer::data() const {
    return _data;
}

bool includer::locate(int gpos, std::string *fullname, int *lpos) const {
    return _locate(gpos, &_trunk, *fullname, *lpos);
}

std::string includer::convert(const std::string &message) const {
    std::string result;
    std::string string(message);
    std::regex expr("([^\\s]+):(\\d+):(\\d+):");
    std::smatch match;
    
    while(std::regex_search(string, match, expr)) {
        std::string filename;
        int lpos;
        result += match.prefix().str();
        if (locate(std::stoi(std::string(match[2])), &filename, &lpos)) {
            result += filename + ":" + std::to_string(lpos);
        } else {
            result += std::string(match[1]) + ":" + std::string(match[2]);
        }
        string = ":" + std::string(match[3]) + ":" + match.suffix().str();
        
    }
    result += string;
    
    return result;
}
