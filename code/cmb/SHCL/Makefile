##
# Copyright (C) 2016 Hansruedi Patzen
#
# This file is part of SHCL.
#
# SHCL is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SHCL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with SHCL. If not, see <http://www.gnu.org/licenses/>.
##

# Tools
GCC = g++
RM = rm
RMDIR = rm -r
CP = cp -R
CD = cd
MAKE = make
SYMLINK = ln -sf
PREBUILD_SCRIPT = ./prebuild/k2b.sh
DOXYGEN = doxygen
AS_ROOT = sudo

# GCC Flags
LIB_FLAG = -shared -fPIC
STD_FLAG = -std=c++14
VISIBILITY_FLAG = -fvisibility=hidden
OPTIMIZE_FLAG = -O3
WARNING_FLAG = -Wall -Wextra -Wconversion -Werror
PEDANTIC_FLAG = -pedantic -pedantic-errors

CXX_FLAGS = $(LIB_FLAG) $(STD_FLAG) $(VISIBILITY_FLAG) $(OPTIMIZE_FLAG) $(WARNING_FLAG) $(PEDANTIC_FLAG)

# Library dependencies
THREAD_LIB = -lpthread
MATH_LIB = -lm
GSL_LIB = -lgsl -lgslcblas
FFTW3_LIB = -lfftw3 -lfftw3_threads
OPENCL_LIB = -lOpenCL

DEPENDENCY_LIBS = $(THREAD_LIB) $(MATH_LIB) $(GSL_LIB) $(FFTW3_LIB) $(OPENCL_LIB)

# CPP implementation files
IMPL_FILE_DIR = ./src/shcl/internal/impl
ERROR_CPP = $(IMPL_FILE_DIR)/shcl_error.cpp
INFO_CPP = $(IMPL_FILE_DIR)/shcl_info.cpp
PLAN_CPP = $(IMPL_FILE_DIR)/shcl_plan.cpp
MEMORY_CPP = $(IMPL_FILE_DIR)/shcl_memory.cpp

CPP_FILES = $(ERROR_CPP) $(INFO_CPP) $(PLAN_CPP) $(MEMORY_CPP)

# Prebuild OpenCL to Binary file
OCL_TO_BINARY_H = ./src/ocl/shcl_ocl_binary.h

# Library headers
HEADER_DIR = ./include
INTERNAL_DIR = ./shcl
MAIN_LIB_FILE = shcl.h

# Docs directory
DOCS_DIR = ./docs

# Install directories
INCLUDE_DIR = /usr/include
LIB_DIR = /usr/lib

# Current library version
LIB_MAJOR_VERSION = 0
LIB_MINOR_VERSION = 1
LIB_PATCH_VERSION = 0

LIB_VERSION = $(LIB_MAJOR_VERSION).$(LIB_MINOR_VERSION).$(LIB_PATCH_VERSION)

# Library file name
LIB_FILE = libSHCL.so
LIB_FILE_FULL = $(LIB_FILE).$(LIB_VERSION)

.PHONY:	build install update docs clean uninstall \
	uninstalllib uninstallheaders

build:	$(LIB_FILE_FULL) 

$(OCL_TO_BINARY_H):
	$(PREBUILD_SCRIPT)

$(LIB_FILE_FULL):	$(OCL_TO_BINARY_H) $(CPP_FILES)
	$(GCC) $(CXX_FLAGS) -I$(HEADER_DIR) $^ -o $@ $(DEPENDENCY_LIBS)

docs:
	$(DOXYGEN)

install:	build
	$(AS_ROOT) $(CP) $(HEADER_DIR)/* $(INCLUDE_DIR)
	$(AS_ROOT) $(CP) $(LIB_FILE_FULL) $(LIB_DIR)
	$(AS_ROOT) $(SYMLINK) $(LIB_DIR)/$(LIB_FILE_FULL) $(LIB_DIR)/$(LIB_FILE)
	$(AS_ROOT) $(SYMLINK) $(LIB_DIR)/$(LIB_FILE_FULL) $(LIB_DIR)/$(LIB_FILE).$(LIB_MAJOR_VERSION)

update:	clean build uninstall install

clean:
	$(RM) -f $(LIB_FILE_FULL) $(OCL_TO_BINARY_H)
	$(RMDIR) -f $(DOCS_DIR)

uninstall:	uninstallheaders uninstalllib

uninstallheaders:
	$(AS_ROOT) $(RM) $(INCLUDE_DIR)/$(MAIN_LIB_FILE)
	$(AS_ROOT) $(RMDIR) $(INCLUDE_DIR)/$(INTERNAL_DIR)

uninstalllib:
	$(AS_ROOT) $(RM) $(LIB_DIR)/$(LIB_FILE) $(LIB_DIR)/$(LIB_FILE).$(LIB_MAJOR_VERSION) $(LIB_DIR)/$(LIB_FILE_FULL)

