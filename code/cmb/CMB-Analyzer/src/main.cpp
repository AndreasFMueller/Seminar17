/*
 * Copyright (C) 2017 Hansruedi Patzen
 *
 * This file is part of CMB-Analyzer.
 *
 * CMB-Analyzer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * CMB-Analyzer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with CMB-Analyzer. If not, see <http://www.gnu.org/licenses/>.
 */

#include "impl/Runner.hpp"

#include <iostream>
#include <stdexcept>

int main(
		int const argc,
		char const * const argv[]
	) {

	Runner runner { };

	try {
		runner.parseArgs(argc, argv, std::cout);
		runner();
	} catch (std::exception const & e) {
		std::cerr << e.what() << '\n';
	}

	runner.printResult(std::cout);
}
