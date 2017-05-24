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

/*
 * Holds the OpenCL FFT Code as a string
 */

#ifndef SHCL_FOURIER_IMPL_HELPER_OCLCODEINCLUDE_HPP_
#define SHCL_FOURIER_IMPL_HELPER_OCLCODEINCLUDE_HPP_
#pragma once

#include <cstddef>
#include <string>

namespace FFT_interal {
	#include "../../../../ocl/shcl_ocl_binary.h"

	std::size_t powerOfTwo(std::size_t N) {
		std::size_t pow = 0;
		while(!((N >> pow) & 1)) ++pow;
		return pow;
	}

	std::string generateProgramCode() {
		std::string bitReversal { reinterpret_cast<char*>(bit_reversal_cl), bit_reversal_cl_len };
		std::string fftInitHead { reinterpret_cast<char*>(fft_stage_0_head_cl), fft_stage_0_head_cl_len };
		std::string fftStageNHead { reinterpret_cast<char*>(fft_stages_head_cl), fft_stages_head_cl_len };
		std::string utility { reinterpret_cast<char*>(utility_cl), utility_cl_len };

		std::string initKernel { reinterpret_cast<char*>(init_cl), init_cl_len };
		std::string stageNKernel { reinterpret_cast<char*>(stage_n_cl), stage_n_cl_len };
		std::string stageFinalKernel { reinterpret_cast<char*>(stage_final_cl), stage_final_cl_len };

		std::string programString {
			bitReversal + '\n'
			+ fftInitHead + '\n'
			+ fftStageNHead + '\n'
			+ utility + '\n'
			+ initKernel + '\n'
			+ stageNKernel + '\n'
			+ stageFinalKernel + '\n'
		};

		return programString;
	}
}

#endif
