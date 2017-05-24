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

#ifndef FFT_KERNEL_STAGE_N_CL_
#define FFT_KERNEL_STAGE_N_CL_
#pragma once

__kernel void fft_stage_n(
		__global float2 * global_data,
		ulong points_per_work_group,
		ulong fft_index_space
	) {
	
	// let all work groups work together to finish
	
	uint offset = get_global_id(0) & (fft_index_space - 1); // & (4-1) == mod 4
	uint start_address = (get_global_id(0) / fft_index_space) * (fft_index_space << 1) + offset;
	
	for (uint fft_global_group_round = 0; fft_global_group_round < (points_per_work_group >> 1) / get_local_size(0); ++fft_global_group_round) {
		
		uint global_start_index = fft_global_group_round * (get_global_size(0) << 1) + start_address;
		
		uint2 global_mem_index = (uint2)(
				global_start_index,
				global_start_index + fft_index_space
			);
		
		float cos_value;
		float sin_value = -sincos(M_PI_F * offset / fft_index_space, &cos_value);
		float2 w1 = (float2)(cos_value, sin_value);
		
		float4 fft_2_result = fft_2_stage_x(
				global_data[global_mem_index.s0],
				global_data[global_mem_index.s1],
				w1
			);
		
		global_data[global_mem_index.s0] = fft_2_result.s01;
		global_data[global_mem_index.s1] = fft_2_result.s23;
	}
}

#endif