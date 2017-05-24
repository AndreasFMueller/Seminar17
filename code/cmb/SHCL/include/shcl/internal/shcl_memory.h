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

/**
 * @file
 *
 * @brief This file contains the interface to handle SHCL memory acquisition and release.
 */

#ifndef INCLUDE_SHCL_INTERNAL_SHCL_MEMORY_H_
#define INCLUDE_SHCL_INTERNAL_SHCL_MEMORY_H_
#pragma once

#include <shcl/internal/visibility.h>
#include <shcl/internal/shcl_types.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Allocate and initialize enough memory to hold the number of image data.
 *
 * @warning The out_error must be checked after calling this function.
 *
 * @param[in] info The info object containing the information needed to calculate the space to allocate.
 *
 * @param[out] out_error A pointer to an error object. Might be NULL.
 *
 * @return A pointer to the first index of the data array.
 */
SHCL_EXPORT
shcl_complex * shcl_calloc_image(
		shcl_info_const const info,
		shcl_error * out_error
	);

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Allocate and initialize enough memory to hold the number of clm specified by the #shcl_transform.
 *
 * @warning The out_error must be checked after calling this function.
 *
 * @param[in] info The info object containing the information needed to calculate the space to allocate.
 *
 * @param[out] out_error A pointer to an error object. Might be NULL.
 *
 * @return A pointer to the first index of the data array.
 */
SHCL_EXPORT
shcl_complex * shcl_calloc_clm(
		shcl_info_const const info,
		shcl_error * out_error
	);

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Free the memory for the given data array pointer.
 *
 * @param[in] data A pointer to the #shcl_complex data which needs to be freed.
 */
SHCL_EXPORT
void shcl_free(
		shcl_complex * data
	);

#ifdef __cplusplus
}
#endif

#endif
