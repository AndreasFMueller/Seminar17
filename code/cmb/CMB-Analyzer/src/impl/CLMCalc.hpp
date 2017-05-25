/*
 * Copyright (C) 2017 Hansruedi Patzen
 *
 * This file is part of CMB-Analyzer.
 *
 * CMB-Analyzer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * CMB-Analyzer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with CMB-Analyzer. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef IMPL_CLMCALC_HPP_
#define IMPL_CLMCALC_HPP_

#include "TiffConverter.hpp"

#include <shcl.h>

#include <complex>
#include <stdexcept>
#include <string>
#include <vector>

struct CLMCalc {

	CLMCalc(
			std::string const & filePath,
			int const maxL,
			double minTemp,
			double maxTemp
		) : converter { filePath, minTemp, maxTemp },
				maxL { maxL },
				error { },
				info { createInfo(converter, maxL) },
				inData { allocInData(converter, info) },
				outData { allocOutData(info) },
				plan { createPlan(info, inData, outData) }
			{ }

	~CLMCalc(
		) {

		shcl_destroy_plan(plan);
		shcl_free(inData);
		shcl_free(outData);
		shcl_destroy_info(info);
		shcl_destroy_error(error);
	}

	void operator()(
		) {

		shcl_execute_plan(plan, &error);
		errorConverter();
	}

	std::vector<double> clmVariance(
		) {

		std::vector<double> clFactors { };
		clFactors.reserve(maxL + 1);

		for (int l { 0 }; l <= maxL; ++l) {

			double amp { };
			double meanFactor { 1.0 / (2.0 * l + 1.0) };

			for (int m { -l }; m <= l; ++m) {

				int index { shcl_coefficient_index(info, l, m, 0, &error) };

				errorConverter();

				auto clm = std::complex<double> { outData[index][0], outData[index][1] };
				amp += (clm.real() * clm.real() + clm.imag() * clm.imag());
			}

			clFactors.push_back(meanFactor * amp);
		}

		return clFactors;
	}

private:
	TiffConverter const converter;
	int const maxL;
	shcl_error error;
	shcl_info_const info;
	shcl_complex * inData;
	shcl_complex * outData;
	shcl_plan plan;

	void errorConverter(
		) {

		if (error) {
			throw std::runtime_error { shcl_error_message(error) };
		}
	}

	shcl_info_const createInfo(
			TiffConverter const & converter,
			int const maxL
		) {

		auto info = shcl_create_info(
				SHCL_NORMAL,
				SHCL_ROW_MAJOR,
				converter.getDimensions().columns,
				converter.getDimensions().rows,
				1,
				maxL,
				SHCL_CPU,
				SHCL_HOLLINGSWORTH,
				SHCL_SCALE_SYMMETRIC,
				&error
			);
		errorConverter();
		return info;
	}

	shcl_complex * allocInData(
			TiffConverter const & converter,
			shcl_info_const const info
		) {

		auto data = shcl_calloc_image(info, &error);
		errorConverter();

		for (int row { 0 }; row < converter.getDimensions().rows; ++row) {
			for (int column { 0 }; column < converter.getDimensions().columns; ++column) {

				int index { shcl_image_index(info, column, row, 0, &error) };

				errorConverter();

				data[index][0] = converter.convertPoint(row, column);
				data[index][1] = 0;
			}
		}

		return data;
	}

	shcl_complex * allocOutData(
			shcl_info_const const info
		) {

		auto data = shcl_calloc_clm(info, &error);
		errorConverter();
		return data;
	}

	shcl_plan createPlan(
			shcl_info_const const info,
			shcl_complex * inData,
			shcl_complex * outData
		) {

		auto plan = shcl_create_plan(info, inData, outData, SHCL_FORWARD, &error);
		errorConverter();
		return plan;
	}
};

#endif
