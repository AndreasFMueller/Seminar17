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

#ifndef UTILITY_CL_
#define UTILITY_CL_
#pragma once

// endless loop if N == 0!!
size_t calc_power_of_two_of(size_t N) {
	size_t pow = 0;
	while(!((N >> pow) & 1)) ++pow;
	return pow;
}

float2 complexmult(float2 a, float2 b) {
	//return (float2)(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
	return (float2)(mad(a.x, b.x, -a.y * b.y), mad(a.x, b.y, a.y * b.x));
}

#endif