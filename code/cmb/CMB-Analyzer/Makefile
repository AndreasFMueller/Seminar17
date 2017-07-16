##
# Copyright (C) 2017 Hansruedi Patzen
#
# This file is part of CMB-Analyzer.
#
# CMB-Analyzer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# CMB-Analyzer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with CMB-Analyzer. If not, see <http://www.gnu.org/licenses/>.
##

# Tools
GCC = g++
RM = rm
RMDIR = rm -r
CP = cp
CD = cd
MAKE = make
SYMLINK = ln -sf
AS_ROOT = sudo

# GCC Flags
STD_FLAG = -std=c++14
OPTIMIZE_FLAG = -O3
WARNING_FLAG = -Wall -Wextra -Wconversion -Werror
PEDANTIC_FLAG = -pedantic -pedantic-errors

CXX_FLAGS = $(STD_FLAG) $(OPTIMIZE_FLAG) $(WARNING_FLAG) $(PEDANTIC_FLAG)

# Binary dependencies
TIFF_LIB = -ltiff
SHCL_LIB = -lSHCL

DEPENDENCY_LIBS = $(TIFF_LIB) $(SHCL_LIB)

# CPP implementation files
IMPL_FILE_DIR = ./src
MAIN_CPP = $(IMPL_FILE_DIR)/main.cpp

CPP_FILES = $(MAIN_CPP)

# Install directories
BIN_DIR = /usr/bin

# Current binary version
BIN_MAJOR_VERSION = 0
BIN_MINOR_VERSION = 1
BIN_PATCH_VERSION = 0

BIN_VERSION = $(BIN_MAJOR_VERSION).$(BIN_MINOR_VERSION).$(BIN_PATCH_VERSION)

# Binary file name
BIN_FILE = cmb-analyzer
BIN_FILE_FULL = $(BIN_FILE).$(BIN_VERSION)

.PHONY:	build install update clean uninstall

build:	$(BIN_FILE_FULL) 

$(BIN_FILE_FULL):	$(CPP_FILES)
	$(GCC) $(CXX_FLAGS) $^ -o $@ $(DEPENDENCY_LIBS)

install:	build
	$(AS_ROOT) $(CP) $(BIN_FILE_FULL) $(BIN_DIR)
	$(AS_ROOT) $(SYMLINK) $(BIN_DIR)/$(BIN_FILE_FULL) $(BIN_DIR)/$(BIN_FILE)

update:	clean build uninstall install

clean:
	$(RM) -f $(BIN_FILE_FULL)

uninstall:
	$(AS_ROOT) $(RM) $(BIN_DIR)/$(BIN_FILE) $(BIN_DIR)/$(BIN_FILE).$(BIN_MAJOR_VERSION) $(BIN_DIR)/$(BIN_FILE_FULL)

