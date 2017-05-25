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
 * Defines SHCL plan related functions.
 *
 */

#include "../../../../include/shcl/internal/shcl_plan.h"
#include "../shcl_plan.hpp"
#include "../shcl_error.hpp"

#include <memory>

extern "C" {

shcl_plan shcl_create_plan(
		shcl_info_const const info,
		shcl_complex * in_data,
		shcl_complex * out_data,
		shcl_direction direction,
		shcl_error * out_error
	) {
	shcl_plan plan { nullptr };
	translateExceptions(out_error, [&]{
		plan = std::make_unique<lib_plan>(info, in_data, out_data, direction).release();
	});
	return plan;
}

void shcl_destroy_plan(
		shcl_plan plan
	) {
	delete plan;
}

void shcl_execute_plan(
		shcl_plan const plan,
		shcl_error * out_error
	) {
	translateExceptions(out_error, [&]{
		plan->actual.execute();
	});
}

}