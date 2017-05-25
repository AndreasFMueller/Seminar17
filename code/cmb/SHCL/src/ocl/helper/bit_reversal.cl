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
 * Bit Reversal for a 8 Point Vector.
 * Reverse bits function from: http://aggregate.ee.engr.uky.edu/MAGIC/
 */
#ifdef DOUBLE_PRECISION
// http://aggregate.ee.engr.uky.edu/MAGIC/
// 64 bit adaption
ulong2 reverse_bits_2(ulong2 x) {
    x = (((x & 0xaaaaaaaaaaaaaaaa) >> 1) | ((x & 0x5555555555555555) << 1));
    x = (((x & 0xcccccccccccccccc) >> 2) | ((x & 0x3333333333333333) << 2));
    x = (((x & 0xf0f0f0f0f0f0f0f0) >> 4) | ((x & 0x0f0f0f0f0f0f0f0f) << 4));
    x = (((x & 0xff00ff00ff00ff00) >> 8) | ((x & 0x00ff00ff00ff00ff) << 8));
    x = (((x & 0xffff0000ffff0000) >> 16) | ((x & 0x0000ffff0000ffff) << 16));
    return((x >> 32) | (x << 32));
}
ulong4 reverse_bits_4(ulong4 x) {
    x = (((x & 0xaaaaaaaaaaaaaaaa) >> 1) | ((x & 0x5555555555555555) << 1));
    x = (((x & 0xcccccccccccccccc) >> 2) | ((x & 0x3333333333333333) << 2));
    x = (((x & 0xf0f0f0f0f0f0f0f0) >> 4) | ((x & 0x0f0f0f0f0f0f0f0f) << 4));
    x = (((x & 0xff00ff00ff00ff00) >> 8) | ((x & 0x00ff00ff00ff00ff) << 8));
    x = (((x & 0xffff0000ffff0000) >> 16) | ((x & 0x0000ffff0000ffff) << 16));
    return((x >> 32) | (x << 32));
}
ulong8 reverse_bits_8(ulong8 x) {
    x = (((x & 0xaaaaaaaaaaaaaaaa) >> 1) | ((x & 0x5555555555555555) << 1));
    x = (((x & 0xcccccccccccccccc) >> 2) | ((x & 0x3333333333333333) << 2));
    x = (((x & 0xf0f0f0f0f0f0f0f0) >> 4) | ((x & 0x0f0f0f0f0f0f0f0f) << 4));
    x = (((x & 0xff00ff00ff00ff00) >> 8) | ((x & 0x00ff00ff00ff00ff) << 8));
    x = (((x & 0xffff0000ffff0000) >> 16) | ((x & 0x0000ffff0000ffff) << 16));
    return((x >> 32) | (x << 32));
}
#elif SINGLE_PRECISION
// http://aggregate.ee.engr.uky.edu/MAGIC/
// 32 bit
uint2 reverse_bits_2(uint2 x) {
	x = (((x & 0xaaaaaaaa) >> 1) | ((x & 0x55555555) << 1));
	x = (((x & 0xcccccccc) >> 2) | ((x & 0x33333333) << 2));
	x = (((x & 0xf0f0f0f0) >> 4) | ((x & 0x0f0f0f0f) << 4));
	x = (((x & 0xff00ff00) >> 8) | ((x & 0x00ff00ff) << 8));
	return((x >> 16) | (x << 16));
}
uint4 reverse_bits_4(uint4 x) {
	x = (((x & 0xaaaaaaaa) >> 1) | ((x & 0x55555555) << 1));
	x = (((x & 0xcccccccc) >> 2) | ((x & 0x33333333) << 2));
	x = (((x & 0xf0f0f0f0) >> 4) | ((x & 0x0f0f0f0f) << 4));
	x = (((x & 0xff00ff00) >> 8) | ((x & 0x00ff00ff) << 8));
	return((x >> 16) | (x << 16));
}
uint8 reverse_bits_8(uint8 x) {
	x = (((x & 0xaaaaaaaa) >> 1) | ((x & 0x55555555) << 1));
	x = (((x & 0xcccccccc) >> 2) | ((x & 0x33333333) << 2));
	x = (((x & 0xf0f0f0f0) >> 4) | ((x & 0x0f0f0f0f) << 4));
	x = (((x & 0xff00ff00) >> 8) | ((x & 0x00ff00ff) << 8));
	return((x >> 16) | (x << 16));
}
#endif

uint4 generate_bit_mask_4(uint4 n, size_t stage, size_t msbPos) {
	// if (msbPos + stage) == 32 undefined behavior -> n << 32 == n << 0!
	uint4 mask = n << msbPos;
	mask <<= stage;
	mask >>= msbPos;
	mask >>= stage;
	return mask;
}

uint4 reverse_4(uint4 n, size_t stage, size_t msbPos, size_t pow) {
	uint4 mask = generate_bit_mask_4(n, stage, msbPos);
	size_t valid_bits = pow - stage;
	n >>= valid_bits;
	n <<= valid_bits;
	n <<= msbPos;
	n = reverse_bits_4(n);
	n <<= valid_bits;
	n |= mask;
	return n;
}

/*
 * Bit Reversal for a 8 Point Vector.
 * Reverse bits function from: http://aggregate.ee.engr.uky.edu/MAGIC/
 */
uint8 generate_bit_mask_8(uint8 n, size_t stage, size_t msbPos) {
	// if (msbPos + stage) == 32 undefined behavior -> n << 32 == n << 0!
	uint8 mask = n << msbPos;
	mask <<= stage;
	mask >>= msbPos;
	mask >>= stage;
	return mask;
}

uint8 reverse_8(uint8 n, size_t stage, size_t msbPos, size_t pow) {
	uint8 mask = generate_bit_mask_8(n, stage, msbPos);
	size_t valid_bits = pow - stage;
	n >>= valid_bits;
	n <<= valid_bits;
	n <<= msbPos;
	n = reverse_bits_8(n);
	n <<= valid_bits;
	n |= mask;
	return n;
}

/*
 * Bit Reversal for a 2 Point Vector.
 * Reverse bits function from: http://aggregate.ee.engr.uky.edu/MAGIC/
 */
uint2 generate_bit_mask_2(uint2 n, size_t stage, size_t msbPos) {
	// if (msbPos + stage) == 32 undefined behavior -> n << 32 == n << 0!
	uint2 mask = n << msbPos;
	mask <<= stage;
	mask >>= msbPos;
	mask >>= stage;
	return mask;
}

uint2 reverse_2(uint2 n, size_t stage, size_t msbPos, size_t pow) {
	uint2 mask = generate_bit_mask_2(n, stage, msbPos);
	size_t valid_bits = pow - stage;
	n >>= valid_bits;
	n <<= valid_bits;
	n <<= msbPos;
	n = reverse_bits_2(n);
	n <<= valid_bits;
	n |= mask;
	return n;
}