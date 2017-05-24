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
 * Defines SHCL information handling functions
 *
 */

#include "../../../../include/shcl/internal/shcl_info.h"

#include "../shcl_info.hpp"
#include "../shcl_error.hpp"

#include <cstdint>
#include <memory>

extern "C" {

shcl_info_const shcl_create_info(
			shcl_transform transform_type,
			shcl_array_major array_major,
			int32_t columns,
			int32_t rows,
			int32_t number_of_images,
			int32_t max_l,
			shcl_platform calc_method,
			shcl_integration integration_method,
			shcl_scaling scaling,
			shcl_error * out_error
		) {
	shcl_info_const info { nullptr };
	translateExceptions(out_error, [&]{
		info = std::make_unique<lib_info>(transform_type, array_major, columns, rows, number_of_images, max_l, calc_method, integration_method, scaling).release();
	});
	return info;
}

void shcl_destroy_info(
		shcl_info_const info
	) {
	delete info;
}

int32_t shcl_coefficient_index(
		shcl_info_const const info,
		int32_t const l,
		int32_t const m,
		int32_t const image_number,
		shcl_error * out_error
	) {
	int32_t index { 0 };
	translateExceptions(out_error, [&]{
		index = info->actual.coefficientIndex(l, m, image_number);
	});
	return index;
}

int32_t shcl_image_index(
		shcl_info_const const info,
		int32_t const column_id,
		int32_t const row_id,
		int32_t const image_number,
		shcl_error * out_error
	) {
	int32_t index { 0 };
	translateExceptions(out_error, [&]{
		index = info->actual.imageIndex(column_id, row_id, image_number);
	});
	return index;
}

}