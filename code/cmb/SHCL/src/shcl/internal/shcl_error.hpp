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
 * Defines a C++ SHCL error struct and the error translation function
 *
 */

#ifndef SHCL_INTERNAL_SHCL_ERROR_HPP_
#define SHCL_INTERNAL_SHCL_ERROR_HPP_

#pragma once

#include "../calculation/Error.hpp"

#include <stdexcept>
#include <utility>

struct lib_error {
	template<typename... Args>
	lib_error(Args && ... args) : actual { std::forward<Args>(args)... } { }
	Error actual;
};

// Returns true if the provided function fn executed without throwing an error, false otherwise
// If calling fn threw an error, capture it in *out_error.
template<typename Fn>
bool translateExceptions(shcl_error * out_error, Fn && fn) {
	try {
		fn();
	} catch (std::exception const & e) {
		*out_error = new lib_error { e.what() };
		return false;
	} catch (...) {
		*out_error = new lib_error { "Unknown internal error" };
		return false;
	}
	return true;
}

#endif
