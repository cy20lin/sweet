## cmake/sweet_config.cmake
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

## public interfaces ##

function(sweet_target __target __option)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0007 NEW)
    if("${__option}" STREQUAL "CONFIGURE")
      _sweet_target_configure("${__target}" ${ARGN})
    elseif("${__option}" STREQUAL "ADD")
      _sweet_target_add("${__target}" ${ARGN})
    elseif("${__option}" STREQUAL "CREATE")
      _sweet_target_create("${__target}" ${ARGN})
    endif()
    cmake_policy(POP)
endfunction()

## implementation details ##

function(_sweet_target_configure __target)
  string(CONFIGURE "${ARGN}" ARGN)
  sweet_target("${__target}" ${ARGN})
endfunction()

function(_sweet_target_add __target __option)
  if("${__option}" STREQUAL "PROPERTIES")
    set_target_properties("${__target}" ${ARGN})
  elseif("${__option}" STREQUAL "SOURCES")
    target_sources("${__target}" ${ARGN})
  elseif("${__option}" STREQUAL "INCLUDES"
      OR "${__option}" STREQUAL "INCLUDE_DIRECTORIES")
    target_include_directories("${__target}" ${ARGN})
  elseif("${__option}" STREQUAL "LIBRARIES"
      OR "${__option}" STREQUAL "LINK_LIBRARIES" )
    target_link_libraries("${__target}" ${ARGN})
  elseif("${__option}" STREQUAL "DEFINITIONS"
      OR "${__option}" STREQUAL "COMPILE_DEFINITIONS" )
    target_compile_definitions("${__target}" ${ARGN})
  elseif("${__option}" STREQUAL "FEATURES"
      OR "${__option}" STREQUAL "COMPILE_FEATURES" )
    target_compile_features("${__target}" ${ARGN})
  elseif("${__option}" STREQUAL "OPTIONS"
      OR "${__option}" STREQUAL "COMPILE_OPTIONS" )
    target_compile_options("${__target}" ${ARGN})
  elseif("${__option}" STREQUAL "CUSTOM_COMMAND" )
    add_custom_command(TARGET "${__target}" ${ARGN})
  elseif("${__option}" STREQUAL "CONFIGS" )
    _sweet_target_add_configs("${__target}" ${ARGN})
  elseif("${__option}" STREQUAL "PACKAGES" )
    _sweet_target_add_packages("${__target}" ${ARGN})
  endif()
endfunction()

function(_sweet_target_add_configs __target)
  foreach(__config IN LISTS ARGN)
    foreach(__args IN LISTS "${__config}")
      _sweet_target_add("${__target}" ${__args})
    endforeach()
  endforeach()
endfunction()

function(_sweet_target_add_packages __target)
  foreach(__package IN LISTS ARGN)
    if("${__package}" STREQUAL "" OR NOT "${${__package}_FOUND}")
      continue()
    endif()
    sweet_target("${__target}" ADD CONFIGS "${__package}")
    foreach(__suffix LIBRARIES LIBRARY LIBS)
      if (NOT "${${__package}_${__suffix}}" STREQUAL "")
        # [NOTE] CMP0023
        if(POLICY CMP0023)
          sweet_target("${__target}" ADD LIBRARIES PRIVATE ${${__package}_${__suffix}})
        else()
          sweet_target("${__target}" ADD LIBRARIES ${${__package}_${__suffix}})
        endif()
        break()
      endif()
    endforeach()
    foreach(__suffix INCLUDES INCLUDE_DIR INCLUDE_DIRS)
      if (NOT "${${__package}_${__suffix}}" STREQUAL "")
        sweet_target("${__target}" ADD INCLUDES PRIVATE ${${__package}_${__suffix}})
        break()
      endif()
    endforeach()
    foreach(__suffix DEFINITIONS)
      if (NOT "${${__package}_${__suffix}}" STREQUAL "")
        sweet_target("${__target}" ADD DEFINITIONS ${${__package}_${__suffix}})
        break()
      endif()
    endforeach()
  endforeach()
endfunction()

##
function(_sweet_target_create)
  if("${__option}" STREQUAL "EXECUTABLE")
    add_executable("${__target}" ${ARGN} "")
  elseif("${__option}" STREQUAL "SOURCES")
    add_library("${__target}" ${ARGN} "")
  elseif("${__option}" STREQUAL "CUSTOM_TARGET")
    add_custom_command(TARGET "${__target}" ${ARGN} "")
  endif()
endfunction()
