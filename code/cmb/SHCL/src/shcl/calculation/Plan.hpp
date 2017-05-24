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
 * Holds the information for a SHCL Plan
 */

#ifndef SHCL_CALCULATION_PLAN_HPP_
#define SHCL_CALCULATION_PLAN_HPP_

#pragma once

#include "../../../include/shcl/internal/shcl_types.h"

#include "../internal/shcl_info.hpp"

#include "../integration/Integration.hpp"
#include "../integration/impl/MendezIntegration.hpp"
#include "../integration/impl/NormalIntegration.hpp"

#include "../integral/Integral.hpp"
#include "../integral/impl/HollingsworthHunter.hpp"
#include "../integral/impl/Simpson.hpp"
#include "../integral/impl/Trapezoidal.hpp"
#include "../integral/impl/RiemannSum.hpp"

#include "../fourier/Fourier.hpp"
#include "../fourier/impl/FFTDC.hpp"
#include "../fourier/impl/FFTW.hpp"
#include "../fourier/impl/OCLFFT.hpp"

#include <complex>
#include <memory>
#include <stdexcept>
#include <type_traits>
#include <vector>

template<
	typename T,
	typename = std::enable_if_t<std::is_floating_point<T>::value, T>
>
struct Plan {
	using value_type = T;
	using data_type = std::complex<value_type>;
	using container1d = std::vector<data_type>;
	using container2d = std::vector<container1d>;
	using container3d = std::vector<container2d>;

	using calc_fourier = std::unique_ptr<Fourier<value_type>>;
	using calc_integral = std::unique_ptr<Integral<value_type>>;
	using calc_integration = std::unique_ptr<Integration<value_type>>;

	Plan(shcl_info_const const info,
			shcl_complex * inData,
			shcl_complex * outData,
			shcl_direction direction
	) : info { check(info) },
			inData { check(inData) },
			outData { check(outData) },
			direction { check(direction) },
			fourier { nullptr },
			integral { nullptr },
			integration { nullptr },
			executePlan { nullptr }
	{
		configurePlan();
	}

	void execute() {
		executePlan();
	}

private:
	Info<value_type> const & info;
	shcl_complex * inData;
	shcl_complex * outData;
	shcl_direction direction;
	calc_fourier fourier;
	calc_integral integral;
	calc_integration integration;
	std::function<void()> executePlan;

	Info<value_type> const & check(shcl_info_const const info) {
		if (info) {
			return info->actual;
		}

		throw std::runtime_error { "Invalid SHCL info object specified." };
	}

	shcl_complex * check(shcl_complex * data) {
		if (data) {
			return data;
		}

		throw std::runtime_error { "Invalid data pointer." };
	}

	shcl_direction check(shcl_direction const & direction) const {
		switch (direction) {
		case SHCL_FORWARD:
		case SHCL_INVERSE:
			return direction;
		default:
			throw std::runtime_error { "Invalid direction value specified." };
		}
	}

	void configurePlan() {
		switch (direction) {
		case SHCL_FORWARD:
			configureForwardPlan();
			break;
		case SHCL_INVERSE:
			throw std::runtime_error { "Not implemented yet!" };
		default:
			throw std::runtime_error { "Invalid direction parameter." };
		}
	}

	void configureForwardPlan() {
		switch (info.platform) {
		case SHCL_CPU:
			fourier = configureCPUFourier();
			integral = configureCPUIntegral();
			integration = configureCPUIntegration();
			break;
		case SHCL_OCL:
			fourier = configureOCLFourier();
			integral = configureOCLIntegral();
			integration = configureOCLIntegration();
			break;
		default:
			throw std::runtime_error { "Invalid calculation method." };
		}
		executePlan = [&]() {
			fourier.get()->execute();
			integration.get()->execute(info, integral.get(), fourier.get(), outData);
		};
	}

	void configureInversePlan() {
		switch (info.platform) {
		case SHCL_CPU:
		case SHCL_OCL:
		default:
			throw std::runtime_error { "Not implemented yet!" };
		}
	}

	calc_fourier configureCPUFourier() {
		switch (info.transformType) {
		case SHCL_MENDEZ:
			return std::make_unique<MendezMean<value_type>>(info, scaleFactor(), inData);
		case SHCL_NORMAL:
			return std::make_unique<FFTW<value_type>>(info, scaleFactor(), inData);
		default:
			throw std::runtime_error { "Invalid transform type." };
		}
	}

	calc_fourier configureOCLFourier() {
		return std::make_unique<OCLFFT<value_type>>(info, scaleFactor(), inData);
	}

	calc_integral configureCPUIntegral() {
		switch (info.integrationMethod) {
		case SHCL_HOLLINGSWORTH:
			return std::make_unique<HollingsworthHunter<value_type>>();
		case SHCL_SIMPSON:
			return std::make_unique<Simpson<value_type>>();
		case SHCL_TRAPEZOIDAL:
			return std::make_unique<Trapezoidal<value_type>>();
		case SHCL_RIEMANN:
			return std::make_unique<RiemannSum<value_type>>();
		default:
			throw std::runtime_error { "Invalid integration method." };
		}
	}

	// Not implemented yet use CPU integral methods
	calc_integral configureOCLIntegral() {
		return configureCPUIntegral();
	}

	calc_integration configureCPUIntegration() {
		switch (info.transformType) {
		case SHCL_MENDEZ:
			return std::make_unique<MendezIntegration<value_type>>();
		case SHCL_NORMAL:
			return std::make_unique<NormalIntegration<value_type>>();
		default:
			throw std::runtime_error { "Invalid transform type." };
		}
	}

	// Not implemented yet use CPU integration
	calc_integration configureOCLIntegration() {
		return configureCPUIntegration();
	}

	value_type scaleFactor() {
		switch (info.scaling) {
		case SHCL_SCALE_NONE:
			return 1.0;
		case SHCL_SCALE_SYMMETRIC:
			return 1.0 / std::sqrt(info.columns);
		case SHCL_SCALE_FORWARD:
			return (direction == SHCL_FORWARD) ? 1.0 / info.columns : 1.0;
		case SHCL_SCALE_INVERSE:
			return (direction == SHCL_INVERSE) ? 1.0 / info.columns : 1.0;
		default:
			throw std::runtime_error { "Invalid scaling type." };
		}
	}
};

#endif
