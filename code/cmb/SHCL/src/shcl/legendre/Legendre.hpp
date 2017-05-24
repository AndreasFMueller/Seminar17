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
 * Defines an interface for Legendre functions
 */

#ifndef SHCL_LEGENDRE_LEGENDRE_HPP_
#define SHCL_LEGENDRE_LEGENDRE_HPP_

#include <cstdint>
#include <stdexcept>
#include <type_traits>
#include <vector>

template<
	typename T = double,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct Legendre {

	using value_type = T;
	using container1d = std::vector<value_type>;

	virtual ~Legendre() = default;

	void calculate(value_type const & from, value_type const & to) {
		value_type const delta { (numberOfPoints == 1) ? 0 : (to - from) / (numberOfPoints - 1) };
		calculateImpl(delta, maxL);
	}

	container1d longitude(int32_t const & l, int32_t const & m) const {
		return longitudeImpl(l, m, numberOfPoints);
	}

protected:
	Legendre(int32_t const & maxL, int32_t const & numberOfPoints) : maxL { maxL }, numberOfPoints { initNumberOfPoints(numberOfPoints) } { }

	virtual void calculateImpl(value_type const & delta, int32_t const & maxL) = 0;
	virtual container1d longitudeImpl(int32_t const & l, int32_t const & m, int32_t const & numberOfPoints) const = 0;

private:
	int32_t const maxL;
	int32_t const numberOfPoints;

	int32_t initNumberOfPoints(int32_t const & numberOfPoints) {
		if (numberOfPoints < 1) {
			throw std::invalid_argument { "Number of points must be greater 0." };
		}
		return numberOfPoints;
	}
};

#endif
