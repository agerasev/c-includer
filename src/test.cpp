#define CATCH_CONFIG_MAIN
#include <catch.hpp>
#include <includer.hpp>


TEST_CASE("C Includer", "[include]") {
    SECTION("No include") {
        std::string main = "\
int main() {\n\
    return 0;\n\
}\n\
";
        includer includer(
            "main.c",
            std::list<std::string>{},
            std::map<std::string, std::string>{
                std::make_pair(std::string("main.c"), main)
            }
        );

        REQUIRE(includer.include());
        REQUIRE(includer.data() == main);
    }

    SECTION("Single include") {
        std::string main = "\
#include <header.h>\n\
#include <header.h>\n\
// Main function\n\
int main() {\n\
    return RET_CODE;\n\
}\n\
";
        std::string header = "\
#pragma once\n\
// Return code\n\
static const int RET_CODE = 0;\n\
";

        std::string result = "\
\n\
// Return code\n\
static const int RET_CODE = 0;\n\
\n\
\n\
// Main function\n\
int main() {\n\
    return RET_CODE;\n\
}\n\
";
        includer includer(
            "main.c",
            std::list<std::string>{},
            std::map<std::string, std::string>{
                std::make_pair(std::string("main.c"), main),
                std::make_pair(std::string("header.h"), header)
            }
        );

        REQUIRE(includer.include());
        REQUIRE(includer.data() == result);
    }

    SECTION("Recursion") {
        std::string first = "\
#pragma once\n\
#include <second.h>\n\
";
        std::string second = "\
#pragma once\n\
#include <first.h>\n\
";

        includer includer(
            "first.h",
            std::list<std::string>{},
            std::map<std::string, std::string>{
                std::make_pair(std::string("first.h"), first),
                std::make_pair(std::string("second.h"), second)
            }
        );

        REQUIRE(includer.include());
        REQUIRE(includer.data() == "\n\n\n\n");
    }

    SECTION("Multiple headers") {
        std::string main = "\
#include <h02.h>\n\
#include <h01.h>\n\
";
        std::string h01 = "\
#pragma once\n\
#include <h02.h>\n\
h01\n\
";
        std::string h02 = "\
#pragma once\n\
#include <h01.h>\n\
h02\n\
";

        includer includer(
            "main.c",
            std::list<std::string>{},
            std::map<std::string, std::string>{
                std::make_pair(std::string("main.c"), main),
                std::make_pair(std::string("h01.h"), h01),
                std::make_pair(std::string("h02.h"), h02)
            }
        );

        REQUIRE(includer.include());
        REQUIRE(includer.data() == "\n\n\nh01\n\nh02\n\n\n");
    }

    SECTION("Multiple headers") {
        std::string main = "\
0\n\
1\n\
2\n\
#include <h01.h>\n\
9\n\
10\n\
#include <h03.h>\n\
15\n\
16\n\
";
        std::string h01 = "\
3\n\
#include <h02.h>\n\
7\n\
";
        std::string h02 = "\
4\n\
5\n\
";
        std::string h03 = "\
11\n\
12\n\
13\n\
";

        includer includer(
            "main.c",
            std::list<std::string>{},
            std::map<std::string, std::string>{
                std::make_pair(std::string("main.c"), main),
                std::make_pair(std::string("h01.h"), h01),
                std::make_pair(std::string("h02.h"), h02),
                std::make_pair(std::string("h03.h"), h03)
            }
        );

        REQUIRE(includer.include());
        std::list<std::string> lines;
        std::string accum;
        for (char c : includer.data()) {
            if (c == '\n') {
                lines.push_back(accum);
                accum.clear();
            } else {
                accum += c;
            }
        }
        lines.push_back(accum);
        int i = 0;
        for (const std::string &line : lines) {
            if (line.size() > 0) {
                REQUIRE(std::stoi(line) == i);
            }
            i += 1;
        }
    }

    SECTION("Multiple headers") {
        std::string main = "\
00\n\
01\n\
02\n\
#include <h01.h>\n\
04\n\
05\n\
#include <h03.h>\n\
07\n\
08\n\
";
        std::string h01 = "\
10\n\
#include <h02.h>\n\
12\n\
";
        std::string h02 = "\
20\n\
21\n\
";
        std::string h03 = "\
30\n\
31\n\
32\n\
";

        includer includer(
            "main.c",
            std::list<std::string>{},
            std::map<std::string, std::string>{
                std::make_pair(std::string("main.c"), main),
                std::make_pair(std::string("h01.h"), h01),
                std::make_pair(std::string("h02.h"), h02),
                std::make_pair(std::string("h03.h"), h03)
            }
        );

        REQUIRE(includer.include());
        std::list<std::string> lines;
        std::string accum;
        for (char c : includer.data()) {
            if (c == '\n') {
                lines.push_back(accum);
                accum.clear();
            } else {
                accum += c;
            }
        }
        assert(accum.size() == 0);
        int gpos = 0;
        for (const std::string &line : lines) {
            std::string name;
            int lpos;
            REQUIRE(includer.locate(gpos, &name, &lpos));
            if (line.size() > 0) {
                REQUIRE(line.size() == 2);
                char f = line[0];
                int l = std::stoi(line.substr(1, 1));
                if (f == '0') {
                    REQUIRE(name == "main.c");
                } else {
                    std::string hn = "h0x.h";
                    hn[2] = f;
                    REQUIRE(name == hn);
                }
                REQUIRE(lpos == l);
            }
            gpos += 1;
        }
        REQUIRE(!includer.locate(gpos, nullptr, nullptr));
    }

        SECTION("Definitions") {
        std::string source = "\
1\n\
#ifdef ABC\n\
2\n\
#ifdef XYZ\n\
3\n\
#ifndef DEF\n\
4\n\
#else // DEF\n\
5\n\
#endif // DEF\n\
6\n\
#else // XYZ\n\
7\n\
#endif // XYZ\n\
8\n\
#else // !ABC\n\
9\n\
#endif // ABC\n\
A\n\
#if defined(ABC)\n\
B\n\
#endif // ABC\n\
C\n\
";

        std::string result = "\
1\n\
\n\
2\n\
#ifdef XYZ\n\
3\n\
\n\
\n\
\n\
5\n\
\n\
6\n\
#else // XYZ\n\
7\n\
#endif // XYZ\n\
8\n\
\n\
\n\
\n\
A\n\
#if defined(ABC)\n\
B\n\
#endif // ABC\n\
C\n\
";
        includer includer(
            "main.c",
            std::list<std::string>{},
            std::map<std::string, std::string>{
                std::make_pair(std::string("main.c"), source)
            },
            std::map<std::string, bool>{
                std::make_pair(std::string("ABC"), true),
                std::make_pair(std::string("DEF"), true)
            }
        );

        REQUIRE(includer.include());
        REQUIRE(includer.data() == result);
    }

        SECTION("Define gate include") {
        std::string source = "\
#ifdef ABC\n\
#include <h0.h>\n\
#else // !ABC\n\
#include <h1.h>\n\
#endif // ABC\n\
";
        std::string h0 = "\
H0 0\n\
H0 1\n\
H0 2\n\
";
        std::string h1 = "\
H1 0\n\
H1 1\n\
H1 2\n\
";

        std::string result = "\
\n\
\n\
\n\
H1 0\n\
H1 1\n\
H1 2\n\
\n\
\n\
";
        includer includer(
            "main.c",
            std::list<std::string>{},
            std::map<std::string, std::string>{
                std::make_pair(std::string("main.c"), source),
                std::make_pair(std::string("h0.h"), h0),
                std::make_pair(std::string("h1.h"), h1)
            },
            std::map<std::string, bool>{
                std::make_pair(std::string("ABC"), false)
            }
        );

        REQUIRE(includer.include());
        REQUIRE(includer.data() == result);
    }
};
