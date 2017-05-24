/*
 * Copyright (C) 2016 Hansruedi Patzen
 *
 * This file is part of SHCL.
 *
 * SHCL is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SHCL is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with SHCL. If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Provide a helper struct for C++ Threading. Passing in the maximum number of points to evaluate and the function to run.
 *
 */

#ifndef CPU_THREADING_HPP_
#define CPU_THREADING_HPP_
#pragma once

#include <cstdint>
#include <exception>
#include <stdexcept>
#include <thread>
#include <vector>

struct Threading {

	template<typename Fn>
	void operator()(int32_t const & numberOfPoints, Fn && func) const {

		if (numberOfPoints < 0) {
			throw std::invalid_argument { "Number of points for threading must be >= 0!" };
		}

		int32_t hardwareThreads = static_cast<int32_t>(std::thread::hardware_concurrency());

		int32_t cores { hardwareThreads ? hardwareThreads : 1 };

		if (numberOfPoints < cores) {
			cores = numberOfPoints;
		}

		int32_t nPerThread { numberOfPoints / cores };
		int32_t missingDiff { numberOfPoints - nPerThread * cores };

		std::vector<std::thread> pool { };
		pool.reserve(cores + 1);

		std::vector<std::exception_ptr> exceptionPool { };
		exceptionPool.resize(cores + 1);

		for (int32_t core { 0 }; core <= cores; ++core) {
			int32_t const start { core * nPerThread };
			int32_t const end { (core == cores) ? start + missingDiff : start + nPerThread };

			pool.push_back(std::thread {
				[&, core, start, end] {
					try {
						for (int32_t n { start }; n < end; ++n) {
							func(n);
						}
					} catch (...) {
						exceptionPool.at(core) = std::current_exception();
					}
				}
			});

		}

		for (auto & t : pool) {
			if (t.joinable()) {
				t.join();
			}
		}

		for (auto && threadException : exceptionPool) {
			if (threadException) {
				std::rethrow_exception(threadException);
			}
		}
	}
};

#endif
