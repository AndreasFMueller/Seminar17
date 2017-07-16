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

#ifndef INCLUDE_SHCL_INTERNAL_SHCL_PLAN_H_
#define INCLUDE_SHCL_INTERNAL_SHCL_PLAN_H_
#pragma once

#include <shcl/internal/visibility.h>
#include <shcl/internal/shcl_types.h>

#include <stdint.h>

/**
 * @file
 *
 * @brief This file contains the interface to handle and interact with SHCL plan objects.
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief
 *
 * @warning The out_error must be checked after calling this function.
 *
 * @param[in] info An info object containing all the information needed to run the plan including the Legendre-Polynomials.
 *
 * @param[in] in_data The input data, depending on the direction this is either the image or the clm data.
 *
 * @param[in] out_data The output data, depending on the direction this is either the clm or the image data.
 *
 * @param[in] direction Specifies the transformation direction.
 * Valid values are:
 * - SHCL_FORWARD
 * - SHCL_INVERSE
 *
 * @param[out] out_error The error object whose message should be retrieved. Might be NULL.
 *
 * @return Returns a pointer to a plan object.
 */
SHCL_EXPORT
shcl_plan shcl_create_plan(
		shcl_info_const const info,
		shcl_complex * in_data,
		shcl_complex * out_data,
		shcl_direction direction,
		shcl_error * out_error
	);

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Cleanup and destroy the plan object and all its data.
 *
 * @warning Calling destroy multiple times on the same error object will result in undefined behavior.
 *
 * @warning The plan object must be destroyed _BEFORE_ its info has been destroyed!
 *
 * @param[in] plan The plan object to be destroyed.
 */
SHCL_EXPORT
void shcl_destroy_plan(
		shcl_plan plan
	);

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Execute the plan which runs the specified transformation and puts the result in the output data array.
 *
 * @warning The out_error must be checked after calling this function.
 *
 * @param[in] plan The plan you want to run.
 *
 * @param[out] out_error The error object whose message should be retrieved. Might be NULL.
 */
SHCL_EXPORT
void shcl_execute_plan(
		shcl_plan const plan,
		shcl_error * out_error
	);

#ifdef __cplusplus
}
#endif

#endif
