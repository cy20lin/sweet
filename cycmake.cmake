cmake_minimum_required(VERSION 3.1)

get_property(__is_cycmake_included GLOBAL PROPERTY CYCMAKE_INCLUDED)
if(__is_cycmake_included)
  return()
endif()
message(STATUS "include cycmake internal cmake files")
set_property(GLOBAL PROPERTY CYCMAKE_INCLUDED 1)
include("${CMAKE_CURRENT_LIST_DIR}/cmake/all.cmake")
