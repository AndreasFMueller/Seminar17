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
 * Allows user to acquire and releasing memory for the in and output data
 *
 */

#include "../../../../include/shcl/internal/shcl_memory.h"

#include "../shcl_error.hpp"
#include "../shcl_info.hpp"

#include <stdexcept>

extern "C" {

shcl_complex * shcl_calloc_image(
		shcl_info_const const info,
		shcl_error * out_error
	) {
	shcl_complex * data { nullptr };
	translateExceptions(out_error, [&]{
		data = new shcl_complex[info->actual.rows * info->actual.columns * info->actual.numberOfImages] { };
	});
	return data;
}

shcl_complex * shcl_calloc_clm(
		shcl_info_const const info,
		shcl_error * out_error
	) {
	shcl_complex * data { nullptr };
	translateExceptions(out_error, [&]{
		switch (info->actual.transformType) {
		case SHCL_MENDEZ:
			data = new shcl_complex[info->actual.maxL + 1] { };
			break;
		case SHCL_NORMAL:
			data = new shcl_complex[(info->actual.maxL + 1) * (info->actual.maxL + 1)]  { };
			break;
		default:
			throw std::runtime_error { "Invalid transform type." };
		}
	});
	return data;
}

void shcl_free(
		shcl_complex * data
	) {
	delete[] data;
}

}