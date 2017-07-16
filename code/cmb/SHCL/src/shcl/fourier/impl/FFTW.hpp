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
 * Holds the FFTW information and provides the Fourier function implementation
 *
 */

#ifndef SHCL_FOURIER_IMPL_FFTW_HPP_
#define SHCL_FOURIER_IMPL_FFTW_HPP_
#pragma once

#include "../Fourier.hpp"

#include "../../../../include/shcl/internal/shcl_types.h"
#include "../../calculation/Info.hpp"

#include <fftw3.h>

#include <cstdint>
#include <cmath>
#include <complex>
#include <type_traits>
#include <vector>

template<
	typename T = double,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct FFTW final : Fourier<T> {

	using value_type = T;
	using data_type = std::complex<value_type>;
	using container1d = std::vector<data_type>;

	FFTW(Info<value_type> const & info, value_type const & scaleFactor, shcl_complex * const inData)
		: info { info },
		  scaleFactor { scaleFactor },
		  transformedData { initFFTOutData() },
		  plan { initPlan(inData) }
		{ }

	~FFTW() {
		fftw_free(transformedData);
		fftw_destroy_plan(plan);
	}

	void execute() override {
		fftw_execute(plan);
	}

	container1d transformed(int32_t const & m, int32_t const & transformNumber) const override {
		int32_t posM { (m < 0) ? info.columns + m : m };
		container1d fftData { };
		fftData.reserve(info.rows);

		for (int32_t rowId { 0 }; rowId < info.rows; ++rowId) {
			int32_t index { info.imageIndex(posM, rowId, transformNumber) };
			fftData.push_back(data_type { transformedData[index][0], transformedData[index][1] } * scaleFactor);
		}
		return fftData;
	}

private:
	Info<value_type> const & info;
	value_type const scaleFactor;
	fftw_complex * transformedData;
	fftw_plan plan;

	fftw_plan initPlan(shcl_complex * const inData) {
		fftw_init_threads();

		uint32_t hardwareThreads = std::thread::hardware_concurrency();

		fftw_plan_with_nthreads(hardwareThreads ? hardwareThreads : 1);

		int32_t rowLength { info.columns };
		int32_t numberOfRows { info.rows * info.numberOfImages };

		int32_t rank { 1 };
		int32_t * n = &rowLength;
		int32_t * embed { n };

		int32_t distance { 1 };
		int32_t stride { 1 };

		switch (info.arrayMajor) {
		case SHCL_ROW_MAJOR:
			distance = info.columns;
			stride = 1;
			break;
		case SHCL_COLUMN_MAJOR:
			distance = 1;
			stride = info.rows;
			break;
		default:
			throw std::runtime_error { "Invalid array major type." };
		}

		return fftw_plan_many_dft(rank, n, numberOfRows, inData, embed, stride, distance, transformedData, embed, stride, distance, FFTW_FORWARD, FFTW_ESTIMATE);
	}

	fftw_complex * initFFTOutData() {
		return fftw_alloc_complex(info.columns * info.rows * info.numberOfImages);
	}
};

#endif
