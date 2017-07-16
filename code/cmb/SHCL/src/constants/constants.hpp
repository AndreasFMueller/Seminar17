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
 * Provides a small namespace for common math constants
 */

#ifndef CONSTANTS_CONSTANTS_HPP_
#define CONSTANTS_CONSTANTS_HPP_
#pragma once

#include <cmath>
#include <type_traits>

namespace MATH_CONST {

template<
	typename T,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
inline constexpr T PI() { return std::acos(static_cast<T>(-1)); }

}

#endif
