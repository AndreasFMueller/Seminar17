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
 * Holds the associated Legendre-Polynomial data and calculation method
 *
 */

#ifndef SHCL_LEGENDRE_IMPL_LEGENDREPLM_HPP_
#define SHCL_LEGENDRE_IMPL_LEGENDREPLM_HPP_

#include "../Legendre.hpp"

#include "../../../cpu/Threading.hpp"

#include <gsl/gsl_sf_legendre.h>

#include <cstdint>
#include <memory>
#include <stdexcept>
#include <type_traits>
#include <vector>

template<
	typename T = double,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct LegendrePlm final : Legendre<T> {

	using value_type = T;
	using container1d = std::vector<value_type>;
	using container2d = std::vector<container1d>;
	using container3d = std::vector<container2d>;

	LegendrePlm(int32_t const & maxL, int32_t const & numberOfPoints) : Legendre<T> { maxL, numberOfPoints }, data { initData((numberOfPoints + 1) / 2) } { }

	~LegendrePlm() = default;

protected:
	void calculateImpl(value_type const & delta, int32_t const & maxL) override {

		int32_t const arraySize { static_cast<int32_t>(gsl_sf_legendre_array_n(maxL)) };

		Threading { } (static_cast<int32_t>(data.size()), [&](int32_t n) {
			std::unique_ptr<double[]> result { std::make_unique<double[]>(arraySize) };

			value_type const theta { n * delta };
			value_type const cosine { std::cos(theta) };
			value_type const sine { std::sin(theta) };

			if (gsl_sf_legendre_array(GSL_SF_LEGENDRE_FULL, maxL, cosine, result.get())) {
				throw std::invalid_argument("Error when calculating the Legendre polynomials");
			}

			container2d thetaVector { };

			for (int32_t l { 0 }; l <= maxL; ++l) {
				container1d lVector { };
				for (int32_t m { 0 }; m <= l; ++m) {
					lVector.push_back(result[gsl_sf_legendre_array_index(l, m)] * sine);
				}
				thetaVector.push_back(lVector);
			}

			data.at(n) = thetaVector;
		});
	}

	container1d longitudeImpl(int32_t const & l, int32_t const & m, int32_t const & numberOfPoints) const override {
		int32_t absoluteM { std::abs(m) };
		container1d result { };

		for (auto const & PLMTheta : data) {
			result.push_back(PLMTheta.at(l).at(absoluteM));
		}

		int sign { (((l + absoluteM) & 1) == 1) ? -1 : 1 };

		for (int32_t n { numberOfPoints / 2 }; n > 0; --n) {
			result.push_back(sign * data.at(n - 1).at(l).at(absoluteM));
		}

		return result;
	}

private:
	container3d data;

	container3d initData(int32_t const & size) {
		container3d dataVector { };
		dataVector.resize(size);
		return dataVector;
	}
};

#endif
