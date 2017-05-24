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
 * Holds the OpenCL information and provides the Fourier function implementation
 *
 */

#ifndef SHCL_FOURIER_IMPL_OCLFFT_HPP_
#define SHCL_FOURIER_IMPL_OCLFFT_HPP_
#pragma once

#define CL_USE_DEPRECATED_OPENCL_1_2_APIS
#define __CL_ENABLE_EXCEPTIONS

#pragma GCC diagnostic ignored "-Wignored-attributes"

#include "helper/OCLCodeInclude.hpp"

#include "../Fourier.hpp"

#ifdef MAC
#include <OpenCL/cl.hpp>
#else
#include <CL/cl.hpp>
#endif

#include <cstddef>
#include <cstdint>
#include <complex>
#include <stdexcept>
#include <type_traits>
#include <vector>

template<
	typename T,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct OCLFFT final : Fourier<T>{

	using value_type = T;
	using data_type = std::complex<value_type>;
	using container1d = std::vector<data_type>;

	using value_type_cl = float;
	using data_type_cl = cl_float2;
	using container1d_cl = std::vector<data_type_cl>;
	using container2d_cl = std::vector<container1d_cl>;
	using container3d_cl = std::vector<container2d_cl>;

	OCLFFT(Info<value_type> const & info, value_type const & scaleFactor, shcl_complex * const inDataPtr)
		: info { info },
		  scaleFactor { scaleFactor },
		  inData { initData(inDataPtr) }
		{
			initOCL();
		}

	~OCLFFT() = default;

	void execute() override {
		for (int32_t imageNumber { 0 }; imageNumber < info.numberOfImages; ++imageNumber) {
			for (int32_t rowId { 0 }; rowId < info.rows; ++rowId) {
				runRowFFT(rowId, imageNumber);
			}
		}
	}

	container1d transformed(int32_t const & m, int32_t const & transformNumber) const override {
		int32_t posM { (m < 0) ? info.columns + m : m };

		container1d fftData { };
		fftData.reserve(info.rows);

		for (auto const & row : inData.at(transformNumber)) {
			fftData.push_back(data_type { row.at(posM).s[0], row.at(posM).s[1] } * scaleFactor);
		}

		return fftData;
	}

private:
	Info<value_type> const & info;
	value_type const scaleFactor;
	container3d_cl inData;
	std::vector<cl_float2> points;
	std::vector<cl::Platform> platforms;
	std::vector<cl::Device> devices;
	cl::Context context;
	cl::Program::Sources source;
	cl::Program program;
	cl::CommandQueue queue;
	cl_ulong localMemorySize;

	container3d_cl initData(shcl_complex * inDataPtr) {
		if (!isPowerOfTwo(info.columns)) {
			throw std::runtime_error { "OCL FFT rows need to be a power of two!" };
		}

		container3d_cl images { };
		for (int32_t imageNumber { 0 }; imageNumber < info.numberOfImages; ++imageNumber) {
			container2d_cl image { };
			for (int32_t rowId { 0 }; rowId < info.rows; ++rowId) {
				container1d_cl imageRow { };
				for (int32_t columnId { 0 }; columnId < info.columns; ++ columnId) {
					shcl_complex point { *inDataPtr[info.imageIndex(columnId, rowId, imageNumber)] };
					imageRow.push_back( { static_cast<value_type_cl>(point[0]), static_cast<value_type_cl>(point[1]) } );
				}
				image.push_back(imageRow);
			}
			images.push_back(image);
		}
		return images;
	}

	bool isPowerOfTwo (std::size_t const & x) {
	  return ((x != 0) && !(x & (x - 1)));
	}

	void initOCL() {
		cl::Platform::get(&platforms);
		platforms.at(0).getDevices(CL_DEVICE_TYPE_ALL, &devices);
		context = { devices };

		std::string programString { FFT_interal::generateProgramCode() };

		source = {1, std::make_pair(programString.c_str(), programString.length() + 1) };
		program = { context, source };
		program.build(devices, "-cl-mad-enable -DSINGLE_PRECISION");
		queue = { context, devices.at(0) };
		localMemorySize = devices.at(0).getInfo<CL_DEVICE_LOCAL_MEM_SIZE>();
	}

	void runRowFFT(int32_t const & rowId, int32_t const & transformNumber) {
		cl::Kernel fftLocalMemKernel { program, "fft_stage_init" };
		cl::Kernel fftGlobalMemKernel { program, "fft_stage_n" };
		cl::Kernel fftFinalGlobalMemKernel { program, "fft_stage_final" };

		cl_ulong const numberOfPoints { inData.at(transformNumber).at(rowId).size() };

		cl::Buffer dataInBuffer { context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, numberOfPoints * sizeof(cl_float2), &inData.at(transformNumber).at(rowId)[0] };
		cl::Buffer dataOutBuffer { context, CL_MEM_WRITE_ONLY, numberOfPoints * sizeof(cl_float2) };
		cl_ulong maxWorkGroupSize { fftLocalMemKernel.getWorkGroupInfo<CL_KERNEL_WORK_GROUP_SIZE>(devices.at(0)) };
		cl_ulong pointsPerGroup { localMemorySize / sizeof(cl_float2) };

		std::size_t pow { FFT_interal::powerOfTwo(numberOfPoints) };
		std::size_t maxWorkGroupPow { FFT_interal::powerOfTwo(maxWorkGroupSize) };

		std::size_t workGroupPow = std::min(pow - 2, maxWorkGroupPow);

		if (((pow - workGroupPow) & 1) != (pow & 1)) {
			--workGroupPow;
		}

		cl_ulong workGroupSize = std::max(1ul << workGroupPow, 1ul);

		if (pointsPerGroup > numberOfPoints) {
			pointsPerGroup = numberOfPoints;
		}

		fftLocalMemKernel.setArg(0, dataInBuffer);
		fftLocalMemKernel.setArg(1, dataOutBuffer);
		fftLocalMemKernel.setArg(2, localMemorySize, nullptr);
		fftLocalMemKernel.setArg(3, pointsPerGroup);
		fftLocalMemKernel.setArg(4, numberOfPoints);

		std::size_t globalSize = (numberOfPoints / pointsPerGroup) * workGroupSize;

		queue.enqueueNDRangeKernel(fftLocalMemKernel, cl::NullRange, cl::NDRange { globalSize }, cl::NDRange { workGroupSize });

		std::unique_ptr<cl_float2[]> dataOut { std::make_unique<cl_float2[]>(numberOfPoints) };

		queue.enqueueReadBuffer(dataOutBuffer, CL_TRUE, 0, numberOfPoints * sizeof(cl_float2), dataOut.get());

		cl::Buffer dataInOutBuffer { context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, numberOfPoints * sizeof(cl_float2), dataOut.get() };

		for (cl_ulong indexSpace { pointsPerGroup }; indexSpace < globalSize; indexSpace <<= 1) {
				fftGlobalMemKernel.setArg(0, dataInOutBuffer);
				fftGlobalMemKernel.setArg(1, pointsPerGroup);
				fftGlobalMemKernel.setArg(2, indexSpace);

				queue.enqueueNDRangeKernel(fftGlobalMemKernel, cl::NullRange, cl::NDRange { globalSize }, cl::NDRange { workGroupSize });

				queue.enqueueReadBuffer(dataInOutBuffer, CL_TRUE, 0, numberOfPoints * sizeof(cl_float2), dataOut.get());
		}

		if (globalSize > pointsPerGroup) {
			for (std::size_t indexSpace { globalSize }; indexSpace < numberOfPoints; indexSpace <<= 1) {
				fftFinalGlobalMemKernel.setArg(0, dataInOutBuffer);
				fftFinalGlobalMemKernel.setArg(1, numberOfPoints);
				fftFinalGlobalMemKernel.setArg(2, indexSpace);

				queue.enqueueNDRangeKernel(fftFinalGlobalMemKernel, cl::NullRange, cl::NDRange { globalSize }, cl::NDRange { workGroupSize });

				queue.enqueueReadBuffer(dataInOutBuffer, CL_TRUE, 0, numberOfPoints * sizeof(cl_float2), dataOut.get());

			}
		}

		queue.finish();

		std::vector<cl_float2> dataPoints { dataOut.get(), dataOut.get() + numberOfPoints };

		inData.at(transformNumber).at(rowId) = dataPoints;
	}
};

#endif
