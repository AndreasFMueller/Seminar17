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
 * Implements the Hollingsworth Hunter integration method
 *
 */

#ifndef SHCL_INTEGRAL_IMPL_HOLLINGSWORTHHUNTER_HPP_
#define SHCL_INTEGRAL_IMPL_HOLLINGSWORTHHUNTER_HPP_
#pragma once

#include "../Integral.hpp"

#include <complex>
#include <cstddef>
#include <type_traits>
#include <vector>

template<
	typename T,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct HollingsworthHunter final : Integral<T> {
	using value_type = T;
	using data_type = std::complex<value_type>;
	using container1d = std::vector<data_type>;

	~HollingsworthHunter() = default;

protected:
	data_type integrateImpl(value_type const & delta, container1d const & data) const override {

		value_type delta24 { delta / 24 };

		if (data.size() == 2) {
			return delta * (data.at(0) + data.at(1)) / 2.0;
		}

		if (data.size() == 3) {
			return delta * (data.at(0) + 4.0 * data.at(1) + data.at(2)) / 3.0;
		}

		if (data.size() == 4) {
			return 9.0 * data.at(0) * delta24 + 27.0 * data.at(1) * delta24 + 27.0 * data.at(2) * delta24 + 9.0 * data.at(3) * delta24;
		}

		if (data.size() == 5) {
			return 9.0 * data.at(0) * delta24 + 28.0 * data.at(1) * delta24 + 22.0 * data.at(2) * delta24 + 28.0 * data.at(3) * delta24 + 9.0 * data.at(4) * delta24;
		}

		data_type fa { 9.0 * data.at(0) * delta24 + 28.0 * data.at(1) * delta24 + 23.0 * data.at(2) * delta24 };
		data_type fb { 9.0 * data.at(data.size() - 1) * delta24 + 28.0 * data.at(data.size() - 2) * delta24 + 23.0 * data.at(data.size() - 3) * delta24 };

		data_type mid { 0 };

		for (std::size_t i { 3 }; i < data.size() - 3; ++i) {
			mid += data.at(i) * delta;
		}

		return fa + mid + fb;
	}
};

#endif
