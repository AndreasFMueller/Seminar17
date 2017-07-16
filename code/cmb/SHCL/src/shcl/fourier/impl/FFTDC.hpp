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
 * Holds implementation to calculate the DC Term of a Fourier-Transform only.
 */

#ifndef SHCL_FOURIER_IMPL_FFTDC_HPP_
#define SHCL_FOURIER_IMPL_FFTDC_HPP_
#pragma once

#include "../Fourier.hpp"

#include "../../../../include/shcl/internal/shcl_types.h"
#include "../../../cpu/Threading.hpp"

#include "../../calculation/Info.hpp"

#include <cstdint>
#include <cmath>
#include <complex>
#include <type_traits>
#include <vector>

template<
	typename T = double,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct MendezMean final : Fourier<T> {

	using value_type = T;
	using data_type = std::complex<value_type>;
	using container1d = std::vector<data_type>;
	using container2d = std::vector<container1d>;

	MendezMean(Info<value_type> const & info, value_type const & scaleFactor, shcl_complex * const inData)
			: info { info },
			  scaleFactor { scaleFactor },
			  transformedData { initTransformData() },
			  inData { inData }
			{ }

	~MendezMean() = default;

	void execute() override {
		for (int32_t imageNumber { 0 }; imageNumber < info.numberOfImages; ++imageNumber) {
			container1d mean { };
			mean.resize(info.rows);

			Threading { } (info.rows, [&](int32_t rowId) {
				data_type sum { 0 };
				for (int32_t columnId { 0 }; columnId < info.columns; ++columnId) {
					int32_t index { info.imageIndex(columnId, rowId, imageNumber) };
					sum += data_type { inData[index][0], inData[index][1] };
				}
				mean.at(rowId) = sum * scaleFactor;
			});

			transformedData.at(imageNumber) = mean;
		}
	}

	container1d transformed(int32_t const & m, int32_t const & transformNumber) const override {
		if (m != 0) {
			throw std::runtime_error { "m must equal zero for the Méndez-Transform." };
		}

		return transformedData.at(transformNumber);
	}

private:
	Info<value_type> const & info;
	value_type scaleFactor;
	container2d transformedData;
	shcl_complex * inData;

	container2d initTransformData() {
		container2d fftData { };
		fftData.resize(info.numberOfImages);
		return fftData;
	}
};

#endif
