#!/bin/bash

#
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
#

NOTICE='/*
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
 '

# multiple files
#find ../ -name '*.cl' -type f -exec sh -c 'd=$(dirname {}); f=$(basename {}); cd $d; xxd -i $f > $f.h' -- {} \;

# single file
cd ./src/ocl
export CURRENT_DIR=$(pwd)
rm -f shcl_ocl_binary.h
echo "$NOTICE" >> shcl_ocl_binary.h
find ../ -name '*.cl' -type f -exec sh -c 'd=$(dirname {}); f=$(basename {}); cd $d; xxd -i $f >> $CURRENT_DIR/shcl_ocl_binary.h' -- {} \;

