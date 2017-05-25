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
 * Implements the Riemann sum integration method
 *
 */

#ifndef SHCL_INTEGRAL_IMPL_RIEMANNSUM_HPP_
#define SHCL_INTEGRAL_IMPL_RIEMANNSUM_HPP_
#pragma once

#include "../Integral.hpp"

#include <complex>
#include <type_traits>
#include <vector>

template<
	typename T,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct RiemannSum final : Integral<T> {
	using value_type = T;
	using data_type = std::complex<value_type>;
	using container1d = std::vector<data_type>;

	~RiemannSum() = default;

protected:
	data_type integrateImpl(value_type const & delta, container1d const & data) const override {

		data_type result { 0 };

		for (auto const & point : data) {
			result += point * delta;
		}

		return result;
	}

};

#endif
