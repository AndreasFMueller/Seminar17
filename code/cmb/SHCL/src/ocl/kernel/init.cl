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

#ifndef FFT_KERNEL_INIT_CL_
#define FFT_KERNEL_INIT_CL_
#pragma once

__kernel void fft_stage_init(
		__global float2 * global_data_in,
		__global float2 * global_data_out,
		__local float2 * local_data,
		ulong points_per_work_group,
		ulong N
	) {
	
	if (N == 1) {
		// single element fft
		global_data_out[0] = global_data_in[0];
	}
	
	if (N == 2) {
		// two element fft-butterfly
		global_data_out[0] = global_data_in[0] + global_data_in[1];
		global_data_out[1] = global_data_in[0] - global_data_in[1];
	}
	
	__constant size_t const total_points_pow = calc_power_of_two_of(N);
	__constant size_t const msb_position = sizeof(size_t) * 8 - total_points_pow;
	__constant size_t const group_points_pow = calc_power_of_two_of(points_per_work_group);

	// copy data from global memory to local and perform 4 or 8 point fft depending on points per group
	
	size_t initial_fft_points = 0;
	
	size_t const points_per_work_item = points_per_work_group / get_local_size(0);
	size_t const local_address = get_local_id(0) * points_per_work_item;
	size_t const global_address = get_group_id(0) * points_per_work_group + local_address;
	
	size_t stage = 0;

	if ((group_points_pow & 1) == 0) {
		// 4 point fft
		initial_fft_points = 4;
		
		uint4 point_indexes = (uint4)(
				global_address,
				global_address + 1,
				global_address + 2,
				global_address + 3
			);

		uint4 local_mem_indexes = (uint4)(
				local_address,
				local_address + 1,
				local_address + 2,
				local_address + 3
			);
		
		for (uint i = 0; i < points_per_work_item; i += initial_fft_points) {
			uint4 point_indexes_reversed = reverse_4(point_indexes, total_points_pow, msb_position, total_points_pow);
			
			float8 fft_4_result = fft_4_stage_0(
					global_data_in[point_indexes_reversed.s0],
					global_data_in[point_indexes_reversed.s1],
					global_data_in[point_indexes_reversed.s2],
					global_data_in[point_indexes_reversed.s3]
				);
			
			local_data[local_mem_indexes.s0] = fft_4_result.s01; 
			local_data[local_mem_indexes.s1] = fft_4_result.s23;
			local_data[local_mem_indexes.s2] = fft_4_result.s45;
			local_data[local_mem_indexes.s3] = fft_4_result.s67;
			
			point_indexes += initial_fft_points;
			local_mem_indexes += initial_fft_points;
		}
		
		stage = 2;
	} else {
		// 8 point fft
		initial_fft_points = 8;
		
		uint8 point_indexes = (uint8)(
				global_address,
				global_address + 1,
				global_address + 2,
				global_address + 3,
				global_address + 4,
				global_address + 5,
				global_address + 6,
				global_address + 7
			);
		
		uint8 local_mem_indexes = (uint8)(
				local_address,
				local_address + 1,
				local_address + 2,
				local_address + 3,
				local_address + 4,
				local_address + 5,
				local_address + 6,
				local_address + 7
			);
		
		for (uint i = 0; i < points_per_work_item; i += initial_fft_points) {
			uint8 point_indexes_reversed = reverse_8(point_indexes, total_points_pow, msb_position, total_points_pow);
			
			float16 fft_8_result = fft_8_stage_0(
					global_data_in[point_indexes_reversed.s0],
					global_data_in[point_indexes_reversed.s1],
					global_data_in[point_indexes_reversed.s2],
					global_data_in[point_indexes_reversed.s3],
					global_data_in[point_indexes_reversed.s4],
					global_data_in[point_indexes_reversed.s5],
					global_data_in[point_indexes_reversed.s6],
					global_data_in[point_indexes_reversed.s7]
				);
				
			local_data[local_mem_indexes.s0] = fft_8_result.s01; 
			local_data[local_mem_indexes.s1] = fft_8_result.s23;
			local_data[local_mem_indexes.s2] = fft_8_result.s45;
			local_data[local_mem_indexes.s3] = fft_8_result.s67;
			local_data[local_mem_indexes.s4] = fft_8_result.s89; 
			local_data[local_mem_indexes.s5] = fft_8_result.sAB;
			local_data[local_mem_indexes.s6] = fft_8_result.sCD;
			local_data[local_mem_indexes.s7] = fft_8_result.sEF;
			
			point_indexes += initial_fft_points;
			local_mem_indexes += initial_fft_points;
		}
		
		stage = 3;
	}
	
	// let each item do its thing
	
	size_t fft_index_space = initial_fft_points;
	
	for (; fft_index_space < points_per_work_item; fft_index_space <<= 2) {
		
		for (uint fft_index = 0; fft_index < fft_index_space; ++fft_index) {

			uint4 local_mem_index = (uint4)(
					fft_index + local_address,
					fft_index + local_address + fft_index_space,
					fft_index + local_address + (fft_index_space << 1),
					fft_index + local_address + (fft_index_space << 1) + fft_index_space
				);
			
			float cos_value;
			float sin_value = -sincos(M_PI_F * fft_index / fft_index_space, &cos_value);
			float2 w1 = (float2)(cos_value, sin_value);
			
			sin_value = -sincos(M_PI_F * fft_index / (fft_index_space << 1), &cos_value);
			float2 w2 = (float2)(cos_value, sin_value);
			
			sin_value = -sincos(M_PI_F * (fft_index + fft_index_space) / (fft_index_space << 1), &cos_value);
			float2 w3 = (float2)(cos_value, sin_value);
			
			float8 fft_4_result = fft_4_stage_x(
					local_data[local_mem_index.s0],
					local_data[local_mem_index.s1],
					local_data[local_mem_index.s2],
					local_data[local_mem_index.s3],
					w1,
					w2,
					w3
				);
			
			local_data[local_mem_index.s0] = fft_4_result.s01;
			local_data[local_mem_index.s1] = fft_4_result.s23;
			local_data[local_mem_index.s2] = fft_4_result.s45;
			local_data[local_mem_index.s3] = fft_4_result.s67;
		}
		stage += 2;
	}
	
	barrier(CLK_LOCAL_MEM_FENCE);
	
	// let items work together
	
	for (; fft_index_space < get_local_size(0); fft_index_space <<= 2) {
		uint offset = get_local_id(0) & (fft_index_space - 1); // & (4-1) == mod 4
		uint start_address = (get_local_id(0) >> stage) * (fft_index_space << 2) + offset;
		
		for (uint fft_local_group_round = 0; fft_local_group_round < (points_per_work_item >> 2); ++fft_local_group_round) {
			
			uint local_start_index = fft_local_group_round * (get_local_size(0) << 2) + start_address;
			
			uint4 local_mem_index = (uint4)(
					local_start_index,
					local_start_index + fft_index_space,
					local_start_index + (fft_index_space << 1),
					local_start_index + (fft_index_space << 1) + fft_index_space
				);
			
			float cos_value;
			float sin_value = -sincos(M_PI_F * offset / fft_index_space, &cos_value);
			float2 w1 = (float2)(cos_value, sin_value);
			
			sin_value = -sincos(M_PI_F * offset / (fft_index_space << 1), &cos_value);
			float2 w2 = (float2)(cos_value, sin_value);
			
			sin_value = -sincos(M_PI_F * (offset + fft_index_space) / (fft_index_space << 1), &cos_value);
			float2 w3 = (float2)(cos_value, sin_value);
			
			float8 fft_4_result = fft_4_stage_x(
					local_data[local_mem_index.s0],
					local_data[local_mem_index.s1],
					local_data[local_mem_index.s2],
					local_data[local_mem_index.s3],
					w1,
					w2,
					w3
				);
				
			local_data[local_mem_index.s0] = fft_4_result.s01;
			local_data[local_mem_index.s1] = fft_4_result.s23;
			local_data[local_mem_index.s2] = fft_4_result.s45;
			local_data[local_mem_index.s3] = fft_4_result.s67;
		}
		stage += 2;
		barrier(CLK_LOCAL_MEM_FENCE);
	}
	
	// do further butterflies with work group items grouped together
	
	for (; fft_index_space < points_per_work_group; fft_index_space <<= 2) {

		for (uint local_group_round = 0; local_group_round < points_per_work_group / (fft_index_space << 2); ++local_group_round) {
			
			for (uint local_group_space = 0; local_group_space < fft_index_space; local_group_space += get_local_size(0)) {

				uint offset = get_local_id(0) + local_group_space;
				uint start_address = local_group_round * (fft_index_space << 2) + offset;
				
				uint4 local_mem_index = (uint4)(
						start_address,
						start_address + fft_index_space,
						start_address + (fft_index_space << 1),
						start_address + (fft_index_space << 1) + fft_index_space
					);
				
				float cos_value;
				float sin_value = -sincos(M_PI_F * offset / fft_index_space, &cos_value);
				float2 w1 = (float2)(cos_value, sin_value);
				
				sin_value = -sincos(M_PI_F * offset / (fft_index_space << 1), &cos_value);
				float2 w2 = (float2)(cos_value, sin_value);
				
				sin_value = -sincos(M_PI_F * (offset + fft_index_space) / (fft_index_space << 1), &cos_value);
				float2 w3 = (float2)(cos_value, sin_value);
				
				float8 fft_4_result = fft_4_stage_x(
						local_data[local_mem_index.s0],
						local_data[local_mem_index.s1],
						local_data[local_mem_index.s2],
						local_data[local_mem_index.s3],
						w1,
						w2,
						w3
					);
					
				local_data[local_mem_index.s0] = fft_4_result.s01;
				local_data[local_mem_index.s1] = fft_4_result.s23;
				local_data[local_mem_index.s2] = fft_4_result.s45;
				local_data[local_mem_index.s3] = fft_4_result.s67;
			}
		}
		stage += 2;
		barrier(CLK_LOCAL_MEM_FENCE);
	}
	
	// copy data back to global memory
	
	uint4 local_mem_indexes = (uint4)(
			local_address,
			local_address + 1,
			local_address + 2,
			local_address + 3
		);
		
	uint4 point_indexes = (uint4)(
			global_address,
			global_address + 1,
			global_address + 2,
			global_address + 3
		);

	__constant uint const points_to_copy = 4;
	
	for (uint i = 0; i < points_per_work_item; i += points_to_copy) {
		global_data_out[point_indexes.s0] = local_data[local_mem_indexes.s0];
		global_data_out[point_indexes.s1] = local_data[local_mem_indexes.s1];
		global_data_out[point_indexes.s2] = local_data[local_mem_indexes.s2];
		global_data_out[point_indexes.s3] = local_data[local_mem_indexes.s3];
		
		point_indexes += points_to_copy;
		local_mem_indexes += points_to_copy;
	}
}

#endif