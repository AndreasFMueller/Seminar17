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

#ifndef INCLUDE_SHCL_INTERNAL_SHCL_TYPES_H_
#define INCLUDE_SHCL_INTERNAL_SHCL_TYPES_H_
#pragma once

/**
 * @file
 *
 * @brief This file contains the type definitions for the SHCL Library.
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @typedef shcl_complex
 *
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Specifies the complex data type used in the SHCL.
 */
typedef double shcl_complex[2];

/**
 * @typedef shcl_error
 *
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Specifies a pointer to a SHCL error object.
 */
typedef struct lib_error * shcl_error;

/**
 * @typedef shcl_info_const
 *
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Specifies a pointer to the constant SHCL info object.
 */
typedef struct lib_info const * shcl_info_const;

/**
 * @typedef shcl_plan
 *
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Specifies a pointer to a SHCL plan object.
 */
typedef struct lib_plan * shcl_plan;

/**
 * @enum shcl_transform
 *
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Specifies the available transform types.
 *
 * @param SHCL_NORMAL Use this if you want to run a normal spherical transformation.
 *
 * @param SHCL_MENDEZ Use this if you want to run a Méndez transformation.
 */
typedef enum {
	SHCL_NORMAL,
	SHCL_MENDEZ
} shcl_transform;

/**
 * @enum shcl_direction
 *
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Specify in which direction you want to transform.
 *
 * @param SHCL_FORWARD Use this if you want to run a forward transformation.
 *
 * @param SHCL_INVERSE Use this if you want to run an inverse transformation.
 */
typedef enum {
	SHCL_FORWARD,
	SHCL_INVERSE
} shcl_direction;

/**
 * @enum shcl_platform
 *
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Specify which platform you want to use.
 *
 * @param SHCL_CPU Use normal CPU instructions and libraries.
 *
 * @param SHCL_OCL Use OpenCL Code whenever possible.
 */
typedef enum {
	SHCL_CPU,
	SHCL_OCL
} shcl_platform;

/**
 * @enum shcl_array_major
 *
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Specify which array major the data is in.
 *
 * @param SHCL_ROW_MAJOR Use this if your data is in a row major format.
 *
 * @param SHCL_COLUMN_MAJOR Use this if your data is in a column major format.
 */
typedef enum {
	SHCL_ROW_MAJOR,
	SHCL_COLUMN_MAJOR
} shcl_array_major;

/**
 * @enum shcl_scaling
 *
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Specify what type of scaling you want to use.
 *
 * @param SHCL_NONE Do not scale in any direction.
 *
 * @param SHCL_SYMMETRIC Scale in both directions using 1/sqrt(N).
 *
 * @param SHCL_FORWARD Scale only when doing a forward transform using 1/N.
 *
 * @param SHCL_INVERSE Scale only when doing an inverse transform using 1/N.
 */
typedef enum {
	SHCL_SCALE_NONE,
	SHCL_SCALE_SYMMETRIC,
	SHCL_SCALE_FORWARD,
	SHCL_SCALE_INVERSE
} shcl_scaling;

/**
 * @enum shcl_integration
 *
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Specify which integral calculation method you want to use to integrate over the theta values..
 *
 * @param SHCL_RIEMANN Use normal left-point Riemann sums.
 *
 * @param SHCL_TRAPEZOIDAL Use the trapezoidal rule.
 *
 * @param SHCL_SIMPSON Use the Simpson rule.
 *
 * @param SHCL_HOLLINGSWORTH Use the Hollingsworth-Hunter rule.
 */
typedef enum {
	SHCL_RIEMANN,
	SHCL_TRAPEZOIDAL,
	SHCL_SIMPSON,
	SHCL_HOLLINGSWORTH
} shcl_integration;

#ifdef __cplusplus
}
#endif

#endif
