## cmake/package/CMakeLists.txt --- helper for building external package
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

project(External${PACKAGE_NAME})
include(ExternalProject)
include("${CMAKE_CURRENT_LIST_DIR}/External${PACKAGE_NAME}.cmake")
