all: main

main: main.cpp includer.hpp
	g++ -std=c++11 -g -o $@ $<
