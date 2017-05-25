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

#ifndef INCLUDE_SHCL_INTERNAL_SHCL_ERROR_H_
#define INCLUDE_SHCL_INTERNAL_SHCL_ERROR_H_
#pragma once

#include <shcl/internal/visibility.h>
#include <shcl/internal/shcl_types.h>

/**
 * @file
 *
 * @brief This file contains the interface to handle and interact with SHCL error object.
 */
#ifdef __cplusplus
extern "C" {
#endif

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Retrieve the contained error message from the error object.
 *
 * @warning If the error is not empty it must be destroyed by the user!
 *
 * @param[in] error The error object whose message should be retrieved. Might be NULL.
 *
 * @return A pointer to the message contained in the error or NULL if there was no error.
 */
SHCL_EXPORT
char const * shcl_error_message(
		shcl_error const error
	);

/**
 * @author Hansruedi Patzen
 * @since 0.1.0
 *
 * @brief Cleanup and destroy the error object
 *
 * @warning Calling destroy multiple times on the same error object will result in undefined behavior.
 *
 * @warning This function must be called after every _positive_ error check to prevent leaking memory!
 *
 * @param[in] error The error object to be destroyed.
 */
SHCL_EXPORT
void shcl_destroy_error(
		shcl_error error
	);

#ifdef __cplusplus
}
#endif

#endif
