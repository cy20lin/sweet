## cmake/package.cmake --- package installing utilities
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

function(__setup_external_variables)
  set_if_not_defined(EXTERNAL_WORKING_PREFIX "${CMAKE_BINARY_DIR}/external" PARENT_SCOPE)
  set_if_not_defined(EXTERNAL_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/external" PARENT_SCOPE)
  set_if_not_defined(EXTERNAL_PACKAGE_DIR "${CMAKE_SOURCE_DIR}/cmake/include/package" PARENT_SCOPE)
endfunction()

function(__setup_package_variables package)
  set(PACKAGE_NAME           "${package}" PARENT_SCOPE)
  set(PACKAGE_INSTALL_PREFIX "${EXTERNAL_INSTALL_PREFIX}")
  set(PACKAGE_WORKING_PREFIX "${EXTERNAL_WORKING_PREFIX}")
  set(PACKAGE_STAGE_PREFIX   "${EXTERNAL_WORKING_PREFIX}/stage/${package}" PARENT_SCOPE)
  set(PACKAGE_BINARY_DIR     "${EXTERNAL_WORKING_PREFIX}/build/${package}" PARENT_SCOPE) 
  set(PACKAGE_SOURCE_DIR     "${EXTERNAL_PACKAGE_DIR}" PARENT_SCOPE)
endfunction()

function(install_package package)
  if (PACKAGE_${package}_INSTALLED)
    return()
  endif()
  __setup_package_variables("${package}")
  execute_process(
    COMMAND "${CMAKE_COMMAND}"
    -D "PACKAGE_NAME=${PACKAGE_NAME}"
    -D "PACKAGE_INSTALL_PREFIX:PATH=${PACKAGE_INSTALL_PREFIX}"
    -D "PACKAGE_WORKING_PREFIX:PATH=${PACKAGE_WORKING_PREFIX}"
    -D "PACKAGE_STAGE_PREFIX:PATH=${PACKAGE_STAGE_PREFIX}"
    -D "PACKAGE_BINARY_DIR:PATH=${PACKAGE_BINARY_DIR}"
    -D "PACKAGE_SOURCE_DIR:PATH=${PACKAGE_SOURCE_DIR}"
    -D "CMAKE_INSTALL_PREFIX:PATH=${PACKAGE_INSTALL_PREFIX}"
    -G "${CMAKE_GENERATOR}"
    "${PACKAGE_SOURCE_DIR}"
    WORKING_DIRECTORY "${PACKAGE_BINARY_DIR}"
    RESULT_VARIABLE error
  )
  if (error)
    set(PACKAGE_${package}_INSTALLED 0 PARENT_SCOPE)
    return()
  endif()
  execute_process(
    COMMAND "${CMAKE_COMMAND}"
    --build .
    WORKING_DIRECTORY "${PACKAGE_BINARY_DIR}"
    RESULT_VARIABLE error
  )
  if (NOT error)
    set(PACKAGE_${package}_INSTALLED 1 PARENT_SCOPE)
  else ()
    set(PACKAGE_${package}_INSTALLED 0 PARENT_SCOPE)
  endif()
endfunction()

function(list_available_packages out_list)
  file(GLOB files RELATIVE "${EXTERNAL_PACKAGE_DIR}" "${EXTERNAL_PACKAGE_DIR}/External*.cmake")
  foreach(file IN LISTS files)
    if (EXISTS "${EXTERNAL_PACKAGE_DIR}/${file}" AND
        NOT IS_DIRECTORY "${EXTERNAL_PACKAGE_DIR}/${file}")
      string(LENGTH "${file}" len)
      set(begin 8)
      math(EXPR size "${len} - 14") 
      string(SUBSTRING "${file}" ${begin} ${size} package)
      list(APPEND ${out_list} "${package}")
    endif()
  endforeach()
  set(${out_list} "${${out_list}}" PARENT_SCOPE)
endfunction()

function(list_installed_packages out_list)
  list_available_external_packages(packages)
  foreach(package IN LISTS packages)
    if (${PACKAGE_${package}_INSTALLED})
      list(APPEND out_list "${file}")
    endif()
  endforeach()
  set(out_list "${out_list}" PARENT_SCOPE)
endfunction()

function(install_packages)
  foreach(package IN LISTS ARGN)
    install_package("${package}")
    set(PACKAGE_${package}_INSTALLED ${PACKAGE_${package}_INSTALLED} PARENT_SCOPE)
  endforeach()
endfunction()

macro(setup_package package)
  find_package(${package} ${ARGN}
    HINTS "${PACKAGE_INSTALL_PREFIX}")
  if (${package}_FOUND)
    return()
  endif()
  setup_package(${package})
  find_package(${package}
    PATHS "${PACKAGE_INSTALL_PREFIX}"
    NO_DEFAULT_PATH)
endmacro()

__setup_external_variables()
