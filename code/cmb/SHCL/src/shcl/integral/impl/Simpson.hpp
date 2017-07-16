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
 * Implements the Simpson rule integration method
 *
 */

#ifndef SHCL_INTEGRAL_IMPL_SIMPSON_HPP_
#define SHCL_INTEGRAL_IMPL_SIMPSON_HPP_
#pragma once

#include "../Integral.hpp"

#include <complex>
#include <cstddef>
#include <stdexcept>
#include <type_traits>
#include <vector>

template<
	typename T,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct Simpson final : Integral<T> {

	using value_type = T;
	using data_type = std::complex<value_type>;
	using container1d = std::vector<data_type>;

	~Simpson() = default;

protected:
	data_type integrateImpl(value_type const & delta, container1d const & data) const override {

		if ((data.size() & 1) == 0) {
			throw std::invalid_argument { "Number of points must be odd!" };
		}

		value_type delta3 { delta / 3 };

		data_type fa { data.at(0) * delta3 };
		data_type fb { data.at(data.size() - 1) * delta3 };

		data_type mid4 { 0 };
		data_type mid2 { 0 };

		for (std::size_t k { 1 }; k < data.size() - 2; k += 2) {
			mid4 += 4.0 * data.at(k) * delta3;
		}

		for (std::size_t k { 2 }; k < data.size() - 2; k += 2) {
			mid2 += 2.0 * data.at(k) * delta3;
		}

		return fa + mid4 + mid2 + fb;
	}

};

#endif
