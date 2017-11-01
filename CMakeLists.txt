## CMakeLists.txt
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

cmake_minimum_required (VERSION 3.1)

project(sweet NONE)

# --target=install

install(
  FILES
  sweet.cmake
  sweet-config.cmake
  DESTINATION
  lib/cmake/sweet
  )

install(
  DIRECTORY
  cmake
  DESTINATION
  lib/cmake/sweet
  )

# --target=test

include(CTest)
add_test(
  NAME test.all
  COMMAND
  "${CMAKE_COMMAND}"
  "-DPROJECT_SOURCE_DIR=${PROJECT_SOURCE_DIR}"
  "-DPROJECT_BINARY_DIR=${PROJECT_BINARY_DIR}"
  -P test.cmake
  WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/test"
  )

# --target=doc

if(NOT DEFINED SPHINX_BUILDER)
  set(SPHINX_BUILDER html)
endif()

if(NOT DEFINED SPHINX_COMMAND)
  set(SPHINX_COMMAND "sphinx-build")
endif()

add_custom_target(doc
  "${SPHINX_COMMAND}"
  -M "${SPHINX_BUILDER}"
  "${PROJECT_SOURCE_DIR}/doc"
  "${PROJECT_BINARY_DIR}/doc"
  WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
  )
