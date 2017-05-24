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
 * Holds the normal Legendre-Polynomial data and calculation method
 *
 */

#ifndef SHCL_LEGENDRE_IMPL_LEGENDREPL_HPP_
#define SHCL_LEGENDRE_IMPL_LEGENDREPL_HPP_

#include "../Legendre.hpp"

#include "../../../cpu/Threading.hpp"

#include <gsl/gsl_sf_legendre.h>

#include <cstdint>
#include <cmath>
#include <memory>
#include <stdexcept>
#include <type_traits>
#include <vector>

template<
	typename T = double,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct LegendrePl final : Legendre<T> {
	using value_type = T;
	using container1d = std::vector<value_type>;
	using container2d = std::vector<container1d>;

	LegendrePl(int32_t const & maxL, int32_t const & numberOfPoints) : Legendre<T> { maxL, numberOfPoints }, data { initData((numberOfPoints + 1) / 2) } { }

	~LegendrePl() = default;

protected:
	void calculateImpl(value_type const & delta, int32_t const & maxL) override {

		Threading { } (static_cast<int32_t>(data.size()), [&](int32_t n){
			std::unique_ptr<double[]> result { std::make_unique<double[]>(maxL + 1) };

			value_type const theta { n * delta };
			value_type const cosine { std::cos(theta) };
			value_type const sine { std::sin(theta) };

			if (gsl_sf_legendre_Pl_array(maxL, cosine, result.get())) {
				throw std::invalid_argument("Error when calculating the Legendre polynomials");
			}

			container1d thetaVector { };
			thetaVector.reserve(maxL + 1);

			for (int32_t l { 0 }; l <= maxL; ++l) {
				thetaVector.push_back(result[l] * sine * scaleFactor(l));
			}

			data.at(n) = thetaVector;
		});
	}

	container1d longitudeImpl(int32_t const & l, int32_t const & m, int32_t const & numberOfPoints) const override {
		if (m != 0) {
			throw std::invalid_argument { "Normal Legendre polynomials only support m = 0!" };
		}

		container1d result { };


		for (auto const & PLTheta : data) {
			result.push_back(PLTheta.at(l));
		}

		int32_t sign { ((l & 1) == 1) ? -1 : 1 };

		for (int32_t n { numberOfPoints / 2 }; n > 0; --n) {
			result.push_back(sign * data.at(n - 1).at(l));
		}

		return result;
	}

private:
	container2d data;

	inline value_type scaleFactor(int32_t const & l) const {
		return std::sqrt(l + 0.5);
	}

	container2d initData(int32_t const & size) {
		container2d dataVector { };
		dataVector.resize(size);
		return dataVector;
	}
};

#endif
