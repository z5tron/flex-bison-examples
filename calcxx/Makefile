all:
	flex -ocalc++-scanner.cc calc++-scanner.ll
	bison --defines=calc++-parser.hh -ocalc++-parser.cc calc++-parser.yy
	g++ calc++-driver.cc calc++.cc calc++-parser.cc calc++-scanner.cc
