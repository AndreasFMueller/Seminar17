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

#ifndef FFT_STAGE_0_HEAD_CL_
#define FFT_STAGE_0_HEAD_CL_
#pragma once

float8 fft_4_stage_0(float2 x0, float2 x2, float2 x1, float2 x3) {
	float2 twiddeled_x1_x3_diff = (float2)(x1.s1 - x3.s1, x3.s0 - x1.s0);
	return (float8)(
			x0 + x2 + x1 + x3,
			x0 - x2 + twiddeled_x1_x3_diff,
			x0 + x2 - x1 - x3,
			x0 - x2 - twiddeled_x1_x3_diff
		);
}

float16 fft_8_stage_0(float2 x0, float2 x4, float2 x2, float2 x6, float2 x1, float2 x5, float2 x3, float2 x7) {
	float8 fft_4_result_0 = fft_4_stage_0(x0, x4, x2, x6);
	float8 fft_4_result_1 = fft_4_stage_0(x1, x5, x3, x7);

	float2 twiddeled_x5_x7_sum = (float2)(fft_4_result_1.s2 + fft_4_result_1.s3, fft_4_result_1.s3 - fft_4_result_1.s2);
	float2 twiddeled_x1_x3_diff = (float2)(fft_4_result_1.s5, -fft_4_result_1.s4);
	float2 twiddeled_x5_x7_diff = (float2)(fft_4_result_1.s6 - fft_4_result_1.s7, fft_4_result_1.s6 + fft_4_result_1.s7);
	
	return (float16)(
		fft_4_result_0.s01 + fft_4_result_1.s01,
		mad(M_SQRT1_2_F, twiddeled_x5_x7_sum, fft_4_result_0.s23),
		fft_4_result_0.s45 + twiddeled_x1_x3_diff,
		mad(-M_SQRT1_2_F, twiddeled_x5_x7_diff, fft_4_result_0.s67),
		fft_4_result_0.s01 - fft_4_result_1.s01,
		mad(-M_SQRT1_2_F, twiddeled_x5_x7_sum, fft_4_result_0.s23),
		fft_4_result_0.s45 - twiddeled_x1_x3_diff,
		mad(M_SQRT1_2_F, twiddeled_x5_x7_diff, fft_4_result_0.s67)
	);
}

#endif