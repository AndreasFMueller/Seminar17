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

#ifndef IMPL_RUNNER_HPP_
#define IMPL_RUNNER_HPP_

#include "CLMCalc.hpp"

#include <ostream>
#include <stdexcept>
#include <string>
#include <vector>

struct Runner {

	Runner(
		) : isDone { false }, imagePath { }, maxL { -1 }, min { -500 }, max { 500 } { }

	void operator()(
		) {

		if (!isDone) {
			CLMCalc calc { imagePath, maxL, min, max };
			calc();
			variances = calc.clmVariance();
			isDone = true;
		}
	}

	void parseArgs(
			int const argc,
			char const * const argv[],
			std::ostream & out
		) {

		std::string error { };
		bool helpFlag { false };

		for (int i { 1 }; i < argc; ++i) {
			std::string flag { argv[i] };

			if (flag == "-i" || flag == "--image") {

				int start { i + 1 };

				if (start < argc && !isFlagParam(*(argv[start]))) {
					imagePath = argv[start];
					++i;
				}
			}

			if (flag == "-l" || flag == "--max-l") {

				int start { i + 1 };

				if (start < argc && !isFlagParam(*(argv[start]))) {
					try {
						maxL = std::stoi(argv[start]);
					} catch (std::exception const & e) {
						error = "Cannot convert input l to a double value.";
					}
					++i;
				}
			}

			if (flag == "-r" || flag == "--range") {

				if (i + 2 < argc) {
					try {
						min = std::stod(argv[i + 1]);
						max = std::stod(argv[i + 2]);
					} catch (std::exception const & e) {
						error = "Cannot convert input range to a double value.";
					}
				} else {
					error = "Not enough arguments supplied for the -r flag.";
				}

				i += 2;
			}

			if (flag == "-h" || flag == "--help") {
				printUsage(out);
				helpFlag = true;
				isDone = true;
			}
		}

		if (maxL < 0) {
			error = "Maximum l must be greater or equal 0.";
		}

		if (imagePath.empty()) {
			error = "No image provided.";
		}

		if (!error.empty()) {
			printUsage(out);
			throw std::runtime_error { error };
		}

		if (!helpFlag) {
			isDone = false;
		}
	}

	void printResult(
			std::ostream & out
		) {

		for (auto const & variance : variances) {
			out << variance << ' ';
		}
		out << '\n';
	}

private:
	bool isDone;
	std::string imagePath;
	int maxL;
	double min;
	double max;
	std::vector<double> variances;

	bool isFlagParam(
			char const c
		) {

		return c == '-';
	}

	void printUsage(
			std::ostream & out
		) {

		out	<< "Usage:\n"
			<< "   -l <int>              Define the maximum l for which the c_l^m should be calculated (must be >= 0).\n"
			<< "   --max-l <number>      See -l.\n"
			<< "   -i <tiff image>       Set the path to the tiff image file which should be analyzed.\n"
			<< "   --image               See -i.\n"
			<< "   -r <double> <double>  Set the range that the deepest blue to red represent. (Default: -500 500)\n"
			<< "   --range               See -r.\n"
			<< "   -h                    Show this help menu.\n"
			<< "   --help                See -h.\n";
	}
};

#endif
