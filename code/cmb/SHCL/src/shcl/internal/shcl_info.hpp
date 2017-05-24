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
 * Defines a C++ SHCL information struct
 *
 */

#ifndef SHCL_INTERNAL_SHCL_INFO_HPP_
#define SHCL_INTERNAL_SHCL_INFO_HPP_
#pragma once

#include "../../shcl/calculation/Info.hpp"

#include <utility>

struct lib_info {
	template<typename... Args>
	lib_info(Args && ... args) : actual { std::forward<Args>(args)... } { }
	Info<double> actual;
};

#endif
