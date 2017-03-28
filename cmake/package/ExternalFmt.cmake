## cmake/package/ExternalFmt.cmake --- configuration for building external package 'fmt'
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

ExternalProject_Add(Fmt
  GIT_REPOSITORY    "https://github.com/fmtlib/fmt"
  GIT_TAG           master
  PREFIX            "${CMAKE_BINARY_DIR}/external"
  CMAKE_ARGS        "-DCMAKE_INSTALL_PREFIX:PATH=${PACKAGE_INSTALL_PREFIX}"
)
