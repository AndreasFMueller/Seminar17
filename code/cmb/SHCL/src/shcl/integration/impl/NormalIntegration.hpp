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
 * Implementation for the normal spherical harmonical transformation integration.
 *
 */

#ifndef SHCL_INTEGRATION_IMPL_NORMALINTEGRATION_HPP_
#define SHCL_INTEGRATION_IMPL_NORMALINTEGRATION_HPP_
#pragma once

#include "../Integration.hpp"

#include "../../../../include/shcl/internal/shcl_types.h"
#include "../../../cpu/Threading.hpp"

#include "../../../constants/constants.hpp"

#include "../../integral/Integral.hpp"
#include "../../legendre/Legendre.hpp"
#include "../../fourier/Fourier.hpp"

#include <cstdint>
#include <complex>
#include <type_traits>
#include <vector>

template<
	typename T,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct NormalIntegration final : Integration<T> {

	using value_type = T;
	using data_type = std::complex<value_type>;
	using container1d = std::vector<data_type>;
	using container1d_real = std::vector<value_type>;

	~NormalIntegration() = default;

	void execute(Info<value_type> const & info, Integral<value_type> const * const integral, Fourier<value_type> const * const fourier, shcl_complex * outData) const override {

		for (int32_t imageNumber { 0 }; imageNumber < info.numberOfImages; ++imageNumber) {

			Threading { } (info.maxL + 1, [&](int32_t l) {
				for (int32_t m { -l }; m <= l; ++m) {
					container1d_real legendreTheta { info.legendreLongitude(l, m) };
					container1d fourierTheta { fourier->transformed(m, imageNumber) };

					container1d multipliedData { };
					multipliedData.resize(info.rows);

					for (int32_t n { 0 }; n < info.rows; ++n) {
						multipliedData.at(n) = legendreTheta.at(n) * fourierTheta.at(n);
					}

					value_type sign { (m < 0 && (m & 1) == 1) ? -1.0 : 1.0 };

					data_type result { sign * integral->integrate(0, MATH_CONST::PI<value_type>(), multipliedData) };

					int32_t index { info.coefficientIndex(l, m, imageNumber) };

					outData[index][0] = result.real();
					outData[index][1] = result.imag();
				}
			});
		}
	}
};

#endif
