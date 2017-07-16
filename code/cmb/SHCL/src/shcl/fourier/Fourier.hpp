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
 * Interface for Fourier related functions
 *
 */

#ifndef SHCL_FOURIER_FOURIER_HPP_
#define SHCL_FOURIER_FOURIER_HPP_
#pragma once

#include "../../../include/shcl/internal/shcl_types.h"

#include <cstdint>
#include <complex>
#include <type_traits>
#include <vector>

template<
	typename T,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct Fourier {
	using value_type = T;
	using data_type = std::complex<value_type>;
	using container1d = std::vector<data_type>;

	virtual ~Fourier() = default;
	virtual void execute() = 0;
	virtual container1d transformed(int32_t const & m, int32_t const & transformNumber) const = 0;
};

#endif
