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
 * Defines the Integral interface
 *
 */

#ifndef SHCL_INTEGRAL_INTEGRAL_HPP_
#define SHCL_INTEGRAL_INTEGRAL_HPP_
#pragma once

#include <complex>
#include <type_traits>
#include <vector>

template<
	typename T,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct Integral {

	using value_type = T;
	using data_type = std::complex<value_type>;
	using container1d = std::vector<data_type>;

	virtual ~Integral() = default;

	data_type integrate(value_type const & from, value_type const & to, container1d const & data) const {

		if (data.size() < 2) {
			return 0;
		}

		value_type delta { (to - from) / static_cast<value_type>((data.size() - 1)) };

		return integrateImpl(delta, data);
	}

protected:
	virtual data_type integrateImpl(value_type const & delta, container1d const & data) const = 0;
};

#endif
