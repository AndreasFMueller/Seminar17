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

#ifndef INCLUDE_SHCL_INTERNAL_SHCL_INFO_H_
#define INCLUDE_SHCL_INTERNAL_SHCL_INFO_H_
#pragma once

#include <shcl/internal/visibility.h>
#include <shcl/internal/shcl_types.h>

#include <stdint.h>

/**
 * @file
 *
 * @brief This file contains the interface to handle and interact with SHCL info objects.
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Creates a constant info object
 *
 * Allows a user to create a constant info object which can be used to execute a
 * shcl_plan. This object can be used to run different plans given the same data
 * dimensions.
 *
 * @warning Upon creation the info object will calculate all needed Legendre-Polynomials. Which could
 * take some time.
 *
 * @warning The out_error must be checked after calling this function.
 *
 * @param[in] transform_type Specifies the kind of transformation the user wants to run.
 * Valid values are:
 * - SHCL_MENDEZ
 * - SHCL_NORMAL
 *
 * @param[in] array_major Specifies in which array major the given data is present.
 * Valid values are:
 * - SHCL_ROW_MAJOR
 * - SHCL_Column_MAJOR
 *
 * @param[in] columns Specifies the number of columns the images has. This is equal to the number
 * of discrete phi values.
 *
 * @param[in] rows Specifies the number of rows the image has. This is equal to the number of
 * discrete theta values.
 *
 * @param[in] number_of_images Specifies the number of images one wants to transform with a single plan.
 * This can be used when multiple images are present in a sequence.
 *
 * @param[in] max_l Specifies the maximum l one is interested in for this specific transform. In
 * conjunction with the inverse transform this will determine the number of clm present in the input.
 * This _must_ be smaller than the number of rows.
 *
 * @param[in] platform Specifies the platform on which the transform will be run.
 * Valid values are:
 * - SHCL_CPU
 * - SHCL_OCL
 *
 * @param[in] integration_method Specifies the preferred integration method.
 * Valid values are:
 * - SHCL_HOLLINGSWORTH
 * - SHCL_SIMPSON
 * - SHCL_TRAPEZOIDAL
 * - SHCL_RIEMANN
 *
 * @param[in] scaling Specifies whether the transform should be scaled and if so in which direction.
 * Valid values are:
 * - SHCL_SCALE_SYMMETRIC
 * - SHCL_SCALE_FORWARD
 * - SHCL_SCALE_INVERSE
 * - SCHL_SCALE_NONE
 *
 * @param[out] out_error A pointer to an error object. Might be NULL.
 *
 * @return Returns a pointer to a constant info object.
 */
SHCL_EXPORT
shcl_info_const shcl_create_info(
		shcl_transform transform_type,
		shcl_array_major array_major,
		int32_t columns,
		int32_t rows,
		int32_t number_of_images,
		int32_t max_l,
		shcl_platform platform,
		shcl_integration integration_method,
		shcl_scaling scaling,
		shcl_error * out_error
	);

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Cleanup and destroy the info object and all its data.
 *
 * @warning Calling destroy multiple times on the same error object will result in undefined behavior.
 *
 * @warning The info object must be destroyed _AFTER_ every depending plan has been destroyed!
 *
 * @param[in] info The info object to be destroyed.
 */
SHCL_EXPORT
void shcl_destroy_info(
		shcl_info_const info
	);

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Calculates the coefficient index based on the given information.
 *
 * @warning The out_error must be checked after calling this function.
 *
 * @param[in] info The info object use for boundary checks.
 *
 * @param[in] l Specifies the l which one wants to access.
 *
 * @param[in] m Specifies the m which one wants to access. Must be _smaller or equal_ than l.
 *
 * @param[in] image_number Specifies for which image the requested transformed point belongs to. Must be _smaller_ than the
 * specified number_of_images when the info was created.
 *
 * @param[out] out_error A pointer to an error object. Might be NULL.
 *
 * @return Returns the coefficients index.
 */
SHCL_EXPORT
int32_t shcl_coefficient_index(
		shcl_info_const const info,
		int32_t const l,
		int32_t const m,
		int32_t const image_number,
		shcl_error * out_error
	);

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Calculates the image index based on the given information.
 *
 * @warning The out_error must be checked after calling this function.
 *
 * @param[in] info The info object use for boundary checks.
 *
 * @param[in] column_id Specifies the column in which the point is found.
 *
 * @param[in] row_id Specifies the row in which the point is found.
 *
 * @param[in] image_number Specifies for which image the requested point belongs to. Must be smaller than the
 * specified number_of_images when the info was created.
 *
 * @param[out] out_error A pointer to an error object. Might be NULL.
 *
 * @return Returns the image index.
 */
SHCL_EXPORT
int32_t shcl_image_index(
		shcl_info_const const info,
		int32_t const column_id,
		int32_t const row_id,
		int32_t const image_number,
		shcl_error * out_error
	);


#ifdef __cplusplus
}
#endif

#endif
