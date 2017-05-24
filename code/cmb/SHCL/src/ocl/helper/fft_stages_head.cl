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

#ifndef FFT_STAGES_HEAD_CL_
#define FFT_STAGES_HEAD_CL_
#pragma once

float8 fft_4_stage(float2 x0, float2 x2, float2 x1, float2 x3, float8 twiddles) {
	
	float2 b1 = (float2)(
			mad(-x1.s1, twiddles.s3, x1.s0),
			mad( x1.s0, twiddles.s3, x1.s1)
		);
	
	float2 b2 = (float2)(
			mad(-x2.s1, twiddles.s5, x2.s0),
			mad( x2.s0, twiddles.s5, x2.s1)
		);
		
	float2 b3 = (float2)(
			mad(-x3.s1, twiddles.s7, x3.s0),
			mad( x3.s0, twiddles.s7, x3.s1)
		);
		
	float2 c0 = mad( b2, twiddles.s4, x0);
	float2 c2 = mad(-b2, twiddles.s4, x0);
	float2 c1 = mad( b3, twiddles.s6, b1);
	float2 c3 = mad(-b3, twiddles.s6, b1);
	
	return (float8)(
			mad( c1, twiddles.s2, c0),
			mad(-c1, twiddles.s2, c0),
			mad(-c3.s1, twiddles.s2, c2.s0),
			mad( c3.s0, twiddles.s2, c2.s1),
			mad( c3.s1, twiddles.s2, c2.s0),
			mad(-c3.s0, twiddles.s2, c2.s1)
		);
}

float2 mult(float2 a, float2 b) {
	return (float2)(mad(a.x, b.x, -a.y * b.y), mad(a.x, b.y, a.y * b.x));
}

float8 fft_4_stage_x(float2 x0, float2 x2, float2 x1, float2 x3, float2 w1, float2 w2, float2 w3) {
	float2 a0 = x0 + mult(x2, w1);
	float2 a1 = x0 - mult(x2, w1);
	float2 a2 = x1 + mult(x3, w1);
	float2 a3 = x1 - mult(x3, w1);
	
	float2 b0 = a0 + mult(a2, w2);
	float2 b1 = a0 - mult(a2, w2);
	float2 b2 = a1 + mult(a3, w3);
	float2 b3 = a1 - mult(a3, w3);
	
	return (float8)(
			b0,b2,b1,b3
		);
}

float4 fft_2_stage_x(float2 x0, float2 x2, float2 w1) {
	return (float4)(
			x0 + mult(x2, w1),
			x0 - mult(x2, w1)
		);
}

#endif