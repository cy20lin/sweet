## test/test.cmake
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

macro(test_init_variables)
  # Show CMAKE_ARGC and CMAKE_ARGV<N>
  message("CMAKE_ARGC=${CMAKE_ARGC}")
  math(EXPR n "${CMAKE_ARGC} - 1")
  foreach(i RANGE 0 ${n})
    message("CMAKE_ARGV${i}=${CMAKE_ARGV${i}}")
    set("ARGV${i}" "${CMAKE_ARGV${i}}")
  endforeach()
  # Setup variables
  math(EXPR TEST_ARGC "${CMAKE_ARGC} - 3")
  message("TEST_ARGC=${TEST_ARGC}")
  if(NOT "${TEST_ARGC}" LESS 1)
    foreach(i RANGE 3 ${n})
      math(EXPR ii "0${i}-3")
      set("TEST_ARGV${ii}" "${CMAKE_ARGV${i}}")
      message("TEST_ARGV${ii}=${CMAKE_ARGV${i}}")
    endforeach()
  endif()
  set(TEST_DIR "${CMAKE_CURRENT_LIST_DIR}")
  set(TEST_CMAKE "${CMAKE_CURRENT_LIST_FILE}")
  if(NOT DEFINED PROJECT_SOURCE_DIR)
    get_filename_component(PROJECT_SOURCE_DIR "${TEST_DIR}/.." ABSOLUTE)
  endif()
  message("PROJECT_BINARY_DIR CHECK")
  if(NOT DEFINED PROJECT_BINARY_DIR)
    message("PROJECT_BINARY_DIR IS NOT DEFINED")
    set(PROJECT_BINARY_DIR "${PROJECT_SOURCE_DIR}")
  endif()
  if(NOT DEFINED TEST_CACHE_DIR)
    set(TEST_CACHE_DIR "${PROJECT_BINARY_DIR}/.sweet_test_cache")
  endif()
  message("TEST_DIR=${TEST_DIR}")
  message("TEST_CMAKE=${TEST_CMAKE}")
  message("TEST_CACHE_DIR=${TEST_CACHE_DIR}")
  message("PROJECT_SOURCE_DIR=${PROJECT_SOURCE_DIR}")
  message("PROJECT_BINARY_DIR=${PROJECT_BINARY_DIR}")
endmacro()

macro(test_load_sweet)
  include("${PROJECT_SOURCE_DIR}/sweet.cmake")
endmacro()

macro(test_load_utilities)
  include("${PROJECT_SOURCE_DIR}/test/test_api.cmake")
endmacro()

macro(test_sweet)
  test(sweet)
  include("${TEST_DIR}/test_api_test.cmake")
  include("${TEST_DIR}/sweet_target_test.cmake")
  include("${TEST_DIR}/sweet_config_test.cmake")
  include("${TEST_DIR}/sweet_minimum_required_test.cmake")
  endtest()
endmacro()

macro(test_cleanup)
endmacro()

macro(test_prepare_cache_dir)
  file(REMOVE_RECURSE "${TEST_CACHE_DIR}")
  file(MAKE_DIRECTORY "${TEST_CACHE_DIR}")
  # message("${TEST_CACHE_DIR}")
endmacro()

macro(test_cleanup_cache_dir)
  # file(REMOVE_RECURSE "${TEST_CACHE_DIR}")
endmacro()


if(DEFINED CMAKE_ARGC)
  test_init_variables()
  test_load_utilities()
  test_load_sweet()
  test_prepare_cache_dir()
  test_sweet()
  test_cleanup_cache_dir()
  if("${TEST_RESULT}" STREQUAL failed)
    message(FATAL_ERROR "Test failed.")
  endif()
else()
  message("[error] can only run in script mode")
endif()

