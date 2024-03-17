#!/bin/bash
cd "$(dirname "$0")"
mkdir -pv build
cd build
cmake ../ \
  -DCMAKE_INSTALL_PREFIX="/azerothcore/"  \
  -DAPPS_BUILD="all"                      \
  -DTOOLS_BUILD="none"                    \
  -DSCRIPTS="static"                      \
  -DMODULES="static"                      \
  -DWITH_WARNINGS="1"                     \
  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
  -DCMAKE_C_COMPILER="/usr/bin/clang"     \
  -DCMAKE_CXX_COMPILER_LAUNCHER="ccache"  \
  -DCMAKE_C_COMPILER_LAUNCHER="ccache"    \
  # -DNOPCH=1

#cmake ../ -DCMAKE_INSTALL_PREFIX=$HOME/azeroth-server/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=all -DSCRIPTS=static -DMODULES=static
make -j 32
make install
