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

#ifndef INCLUDE_SHCL_INTERNAL_VISIBILITY_H_
#define INCLUDE_SHCL_INTERNAL_VISIBILITY_H_
#pragma once

/**
 * @file
 *
 * @brief Defines export visibilities macros for different platforms
 */

#if defined(_WIN32) || defined(__CYGWIN_)
	#ifdef shcl_EXPORTS
		#ifdef __GNUC__
			#define SHCL_EXPORT __attribute__ ((dllexport))
		#else
			#define SHCL_EXPORT __declspec(dllexport)
		#endif
	#else
		#ifdef __GNUC__
			#define SHCL_EXPORT __attribute__ ((dllimport))
		#else
			#define SHCL_EXPORT __declspec(dllimport)
		#endif
	#endif
#else
	#if __GNUC__ >= 4
		#define SHCL_EXPORT __attribute__ ((visibility ("default")))
	#else
		#define SHCL_EXPORT
	#endif
#endif

#endif
