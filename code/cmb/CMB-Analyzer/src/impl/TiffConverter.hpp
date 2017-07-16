/*
 * Copyright (C) 2017 Hansruedi Patzen
 *
 * This file is part of CMB-Analyzer.
 *
 * CMB-Analyzer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * CMB-Analyzer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with CMB-Analyzer. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef IMPL_TIFFCONVERTER_HPP_
#define IMPL_TIFFCONVERTER_HPP_

#include "Dimensions.hpp"
#include "Extremas.hpp"

#include <tiffio.h>

#include <string>
#include <stdexcept>

struct TiffConverter {

	TiffConverter(
			std::string const & filePath,
			double const minTemp,
			double const maxTemp
		) : image { load(filePath) },
				minTemp { minTemp },
				maxTemp { maxTemp },
				dimensions { size(TIFFTAG_IMAGEWIDTH, image), size(TIFFTAG_IMAGELENGTH, image) },
				raster { initRaster(image, dimensions) },
				extrema { findExtremas() },
				mb { initMB(extrema, minTemp) },
				mr { initMR(extrema, maxTemp) }
			{ }

	~TiffConverter() {
		_TIFFfree(raster);
		TIFFClose(image);
	}

	TiffConverter(TiffConverter const &) = delete;
	TiffConverter & operator=(TiffConverter const &) = delete;

	Dimensions getDimensions(
		) const {

		return dimensions;
	}

	double convertPoint(
			int const row,
			int const column
		) const {

		if (row >= 0 && row < dimensions.rows && column >= 0 && column < dimensions.columns) {

			uint32 pixel { raster[row * dimensions.columns + column] };
			int red { TIFFGetR(pixel) };
			int green { TIFFGetG(pixel) };
			int blue { TIFFGetB(pixel) };

			int y { red + green + blue };

			int numerator { y - extrema.top };

			if (blue > red) {
				return (extrema.top == extrema.left) ? 0 : numerator / mb;
			}

			return (extrema.top == extrema.right) ? 0 : numerator / mr;
		}

		throw std::runtime_error { "Invalid image index." };
	}

private:
	TIFF * const image;
	double const minTemp;
	double const maxTemp;
	Dimensions const dimensions;
	uint32 * raster;
	Extremas const extrema;
	double const mb;
	double const mr;

	TIFF * load(
			std::string const & filePath
		) {

		auto tiff = TIFFOpen(filePath.c_str(), "r");

		if (tiff) {
			return tiff;
		}

		throw std::runtime_error { "Could not open TIFF Image." };
	}

	int size(
			uint32_t tag,
			TIFF * const image
		) {

		int field { };
		TIFFGetField(image, tag, &field);
		return field;
	}

	uint32 * initRaster(
			TIFF * const image,
			Dimensions const dimensions
		) {

		uint32 * raster { reinterpret_cast<uint32 *>(_TIFFmalloc(dimensions.columns * dimensions.rows * sizeof(uint32))) };

		if (raster && TIFFReadRGBAImage(image, dimensions.columns, dimensions.rows, raster)) {
			return raster;
		}

		throw std::runtime_error { "Could not initialize tiff raster." };
	}

	Extremas findExtremas(
		) {

		Extremas peaks { 3 * 255, 3 * 255, 3 * 255 };

		for (int row { 0 }; row < dimensions.rows; ++row) {
			for (int column { 0 }; column < dimensions.columns; ++column) {

				uint32 pixel { raster[row * dimensions.columns + column] };
				int red { TIFFGetR(pixel) };
				int green { TIFFGetG(pixel) };
				int blue { TIFFGetB(pixel) };

				int rgb { red + green + blue };

				if (blue >= green && blue >= red && rgb < peaks.left) {
					peaks.left = rgb;
				}

				if (red >= green && red >= blue && rgb < peaks.right) {
					peaks.right = rgb;
				}
			}
		}

		return peaks;
	}

	double initMB(
			Extremas const & extrema,
			double const minTemp
		) {

		return (extrema.top - extrema.left) / -minTemp;
	}

	double initMR(
			Extremas const & extrema,
			double const maxTemp
		) {

		return (extrema.right - extrema.top) / maxTemp;
	}
};

#endif
