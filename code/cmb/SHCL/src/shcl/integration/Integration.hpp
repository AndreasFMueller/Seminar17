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
 * Defines the Integration interface
 *
 */

#ifndef SHCL_INTEGRATION_INTEGRATION_HPP_
#define SHCL_INTEGRATION_INTEGRATION_HPP_
#pragma once

#include "../../../include/shcl/internal/shcl_types.h"

#include "../integral/Integral.hpp"
#include "../legendre/Legendre.hpp"
#include "../fourier/Fourier.hpp"

#include <type_traits>

template<
	typename T,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct Integration {

	using value_type = T;

	virtual ~Integration() = default;

	virtual void execute(Info<value_type> const & info, Integral<value_type> const * const integral, Fourier<value_type> const * const fourier, shcl_complex * outData) const = 0;
};

#endif
