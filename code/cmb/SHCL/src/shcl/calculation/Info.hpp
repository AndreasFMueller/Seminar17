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
 * Holds all the SHCL calculation information
 */

#ifndef SHCL_CALCULATION_INFO_HPP_
#define SHCL_CALCULATION_INFO_HPP_
#pragma once

#include "../../../include/shcl/internal/shcl_types.h"

#include "../../constants/constants.hpp"

#include "../legendre/Legendre.hpp"
#include "../legendre/impl/LegendrePlm.hpp"
#include "../legendre/impl/LegendrePl.hpp"

#include <cstdint>
#include <memory>
#include <stdexcept>
#include <type_traits>
#include <vector>

template<
	typename T,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct Info {

	Info(shcl_transform transform_type,
			shcl_array_major array_major,
			int32_t columns,
			int32_t rows,
			int32_t number_of_images,
			int32_t max_l,
			shcl_platform platform,
			shcl_integration integration_method,
			shcl_scaling scaling
	) : transformType { check(transform_type, columns, rows, max_l) },
		  arrayMajor { check(array_major) },
		  columns { checkSmallerZero(columns) },
		  rows { checkSmallerZero(rows) },
		  numberOfImages { checkSmallerOne(number_of_images) },
		  maxL { checkSmallerZero(max_l) },
		  platform { check(platform) },
		  integrationMethod { check(integration_method) },
		  scaling { check(scaling) },
		  legendre { initLegendre() }
		{ }

	using value_type = T;
	using container1d = std::vector<value_type>;
	using calc_legendre = std::unique_ptr<Legendre<value_type>>;
	using calc_legendre_const = std::unique_ptr<Legendre<value_type> const>;

	shcl_transform const transformType;
	shcl_array_major const arrayMajor;
	int32_t const columns;
	int32_t const rows;
	int32_t const numberOfImages;
	int32_t const maxL;
	shcl_platform const platform;
	shcl_integration const integrationMethod;
	shcl_scaling const scaling;

	int32_t coefficientIndex(int32_t l, int32_t m, int32_t imageNumber) const {
		checkCLMParam(m, l);
		checkImageNumber(imageNumber);

		switch (transformType) {
		case SHCL_MENDEZ:
			checkMendezM(m);
			return l + imageNumber * (maxL + 1);
		case SHCL_NORMAL:
			return l * (l + 1) + m + imageNumber * (maxL + 1) * (maxL + 1);
		default:
			throw new std::runtime_error { "Invalid transform type." };
		}
	}

	int32_t imageIndex(int32_t columnId, int32_t rowId, int32_t imageNumber) const {
		checkImageParam(columnId, rowId);
		checkImageNumber(imageNumber);

		int32_t index { 0 };

		switch (arrayMajor) {
		case SHCL_ROW_MAJOR:
			index = rowId * columns + columnId;
			break;
		case SHCL_COLUMN_MAJOR:
			index = rowId + columnId * rows;
			break;
		default:
			throw new std::runtime_error { "Invalid array major type." };
		}

		return index + imageNumber * columns * rows;
	}

	container1d legendreLongitude(int32_t const & l, int32_t const & m) const {
		switch (transformType) {
		case SHCL_MENDEZ:
			checkMendezM(m);
			break;
		case SHCL_NORMAL:
			break;
		default:
			throw std::runtime_error { "Invalid transform type." };
		}
		return legendre.get()->longitude(l, m);
	}

private:
	calc_legendre_const const legendre;

	calc_legendre_const initLegendre() const {
		calc_legendre legendre { nullptr };
		switch (platform) {
		case SHCL_CPU:
			legendre = configureCPULegendre();
			break;
		case SHCL_OCL:
			legendre = configureOCLLegendre();
			break;
		default:
			throw std::runtime_error { "Invalid calculation method." };
		}
		legendre.get()->calculate(0, MATH_CONST::PI<value_type>());
		return legendre;
	}

	calc_legendre configureCPULegendre() const {
		switch (transformType) {
		case SHCL_MENDEZ:
			return std::make_unique<LegendrePl<>>(maxL, rows);
		case SHCL_NORMAL:
			return std::make_unique<LegendrePlm<>>(maxL, rows);
		default:
			throw std::runtime_error { "Invalid transform type." };
		}
	}

	// No OCL Legendre method available, so return CPU ones instead.
	calc_legendre configureOCLLegendre() const {
		return configureCPULegendre();
	}

	shcl_transform check(shcl_transform const & transformType, int32_t const & columns, int32_t const & rows, int32_t const & maxL) const {

		if (transformType == SHCL_NORMAL && columns <= maxL) {
			throw std::runtime_error { "Number of columns must be bigger than max l." };
		}

		if (maxL >= rows) {
			throw std::runtime_error { "Must provide more rows than the max l." };
		}

		switch (transformType) {
		case SHCL_MENDEZ:
		case SHCL_NORMAL:
			return transformType;
		default:
			throw std::runtime_error { "Invalid transform type specified." };
		}
	}

	shcl_direction check(shcl_direction const & direction) const {
		switch (direction) {
		case SHCL_FORWARD:
		case SHCL_INVERSE:
			return direction;
		default:
			throw std::runtime_error { "Invalid direction value specified." };
		}
	}

	shcl_array_major check(shcl_array_major const & arrayMajor) const {
		switch (arrayMajor) {
		case SHCL_ROW_MAJOR:
		case SHCL_COLUMN_MAJOR:
			return arrayMajor;
		default:
			throw std::runtime_error { "Invalid array major value specified." };
		}
	}

	shcl_platform check(shcl_platform const & platform) const {
		switch (platform) {
		case SHCL_CPU:
		case SHCL_OCL:
			return platform;
		default:
			throw std::runtime_error { "Invalid platform specified." };
		}
	}

	shcl_integration check(shcl_integration const & integration) const {
		switch (integration) {
		case SHCL_HOLLINGSWORTH:
		case SHCL_SIMPSON:
		case SHCL_TRAPEZOIDAL:
		case SHCL_RIEMANN:
			return integration;
		default:
			throw std::runtime_error { "Invalid integration method specified." };
		}
	}

	shcl_scaling check(shcl_scaling const & scaling) const {
		switch (scaling) {
		case SHCL_SCALE_SYMMETRIC:
		case SHCL_SCALE_FORWARD:
		case SHCL_SCALE_INVERSE:
		case SHCL_SCALE_NONE:
			return scaling;
		default:
			throw std::runtime_error { "Invalid scaling value specified." };
		}
	}

	void checkImageParam(int32_t const & columnId, int32_t const & rowId) const {
		checkSmallerZero(rowId);
		checkSmallerZero(columnId);

		if (rowId >= rows || columnId >= columns) {
			throw std::runtime_error { "Invalid row or column index." };
		}
	}

	void checkCLMParam(int32_t const & m, int32_t const & l) const {
		checkSmallerZero(l);

		if (m > l || m < -l || l > maxL) {
			throw std::runtime_error { "Invalid m or l." };
		}
	}

	void checkImageNumber(int32_t const & imageNumber) const {
		checkSmallerZero(imageNumber);

		if (imageNumber >= numberOfImages) {
			throw std::runtime_error { "Image number cannot be greater than specified." };
		}
	}

	int32_t checkSmallerZero(int32_t const & param) const {
		if (param < 0) {
			throw std::runtime_error { "Parameter cannot be smaller than 0." };
		}
		return param;
	}

	int32_t checkSmallerOne(int32_t const & param) const {
		if (param < 1) {
			throw std::runtime_error { "Parameter cannot be smaller than 1." };
		}
		return param;
	}

	void checkMendezM(int32_t const & m) const {
		if (m != 0) {
			throw std::runtime_error { "The Méndez-Transform is 0 for all m not equal 0." };
		}
	}
};

#endif
