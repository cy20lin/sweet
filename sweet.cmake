## sweet.cmake
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

get_filename_component(SWEET_ROOT "${CMAKE_CURRENT_LIST_DIR}" ABSOLUTE)

# Test self
if(NOT EXISTS "${SWEET_ROOT}/sweet.cmake")
  message(FATAL_ERROR "[sweet] Can't find 'sweet.cmake' in: ${SWEET_ROOT}")
endif()

get_property(SWEET_INCLUDED GLOBAL PROPERTY SWEET_INCLUDED)
if(SWEET_INCLUDED)
  return()
endif()

set_property(GLOBAL PROPERTY SWEET_INCLUDED 1)
include("${SWEET_ROOT}/cmake/sweet_config.cmake")
include("${SWEET_ROOT}/cmake/sweet_escape.cmake")
include("${SWEET_ROOT}/cmake/sweet_target.cmake")
include("${SWEET_ROOT}/cmake/sweet_version.cmake")
message(STATUS "[sweet] SWEET_ROOT: ${SWEET_ROOT}")
