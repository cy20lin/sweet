## cmake/config.cmake --- config manipulating utilities
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

function(__config_add_basic config)
  escape_value(ARGN "${ARGN}")
  list(APPEND "${config}_CONFIGS_LIST" "${ARGN}")
  set("${config}_CONFIGS_LIST" "${${config}_CONFIGS_LIST}" PARENT_SCOPE)
endfunction()

function(__config_use_configs config _)
  foreach(config_ IN LISTS ARGN)
    list(APPEND "${config}_CONFIGS_LIST" "${${config_}_CONFIGS_LIST}")
  endforeach()
  set("${config}_CONFIGS_LIST" "${${config}_CONFIGS_LIST}" PARENT_SCOPE)
endfunction()

function(__config_use_targets config _)
  foreach(target IN LISTS ARGN)
    list(APPEND "${config}_CONFIGS_LIST" "${${target}_EXPORT_CONFIGS_LIST}")
  endforeach()
  set("${config}_CONFIGS_LIST" "${${config}_CONFIGS_LIST}" PARENT_SCOPE)
endfunction()

function(__config_use_packages config _)
  foreach(package IN LISTS ARGN)
    if(${package}_found)
      set("${target}_INCLUDES" SYSTEM ${${target}_INCLUDES})
      foreach(data_type IN LISTS TARGET_DATA_TYPES)
        config_add("${target}" "${data_type}" ${${package}_${data_type}})
      endforeach()
    else()
      message(author_warning "package: '${package}' not found.")
    endif()
  endforeach()
  set("${config}_CONFIGS_LIST" "${${config}_CONFIGS_LIST}" PARENT_SCOPE)
endfunction()

function(__config_use target)
  foreach(object IN LISTS ARGN)
    if(DEFINED ${object}_FOUND)
      __config_use_packages("${target}" "${object}")
    elseif(DEFINED ${object}_CONFIGS_LIST)
      __config_use_configs("${target}" "${object}")
    elseif(DEFINED ${object}_TARGET_NAME)
      __config_use_targets("${target}" "${object}")
    endif()
  endforeach()
endfunction()


function(__config_add_compound config type)
  if(type STREQUAL "TARGETS")
  elseif(type STREQUAL "TARGETS")
    __config_use_targets("${config}" ${ARGN})
  elseif(type STREQUAL "CONFIGS")
    __config_use_configs("${config}" ${ARGN})
  elseif(type STREQUAL "PACKAGES")
    __config_use_packages("${config}" ${ARGN})
  elseif(type STREQUAL "AUTO")
    __config_use("${config}" ${ARGN})
  else()
    __config_add_basic("${config}" "${type}" ${ARGN})
  endif()
  set("${config}_CONFIGS_LIST" "${${config}_CONFIGS_LIST}" PARENT_SCOPE)
endfunction()

function(__config_add_configure config cn)
  string(CONFIGURE "${ARGN}" ARGN)
  __config_add_compound("${config}" ${ARGN})
  set("${config}_CONFIGS_LIST" "${${config}_CONFIGS_LIST}" PARENT_SCOPE)
endfunction()

function(config_add config type)
  if(ARGV1 STREQUAL "NO_DEFER")
    if(ARGV2 STREQUAL "CONFIGURE")
      # nd cn dt args...
      # ARGN = cn dt args..
      __config_add_configure("${config}" ${ARGN})
    else()
      # nd dt args...
      # ARGN = dt args..
      __config_add_compound("${config}" ${ARGN})
    endif()
  else()
    __config_add_basic("${config}" "${type}" ${ARGN})
  endif()
  set("${config}_CONFIGS_LIST" "${${config}_CONFIGS_LIST}" PARENT_SCOPE)
endfunction()

function(config_dump config)
  foreach(args IN LISTS ${config}_CONFIGS_LIST)
    message("target_add(${config};${args})")
  endforeach()
endfunction()



function(config_insert config index)
  escape_value(ARGN "${ARGN}")
  list(INSERT "${config}_CONFIGS_LIST" "${index}" "${ARGN}")
  set("${config}_CONFIGS_LIST" "${${config}_CONFIGS_LIST}" PARENT_SCOPE)
endfunction()

macro(config_prepend config)
  config_insert("${config}" 0 "${ARGN}")
endmacro()

function(config_reset config)
  set("${ref}_CONFIGS_LIST" "" PARENT_SCOPE)
endfunction()

function(config_unset config)
  unset("${ref}_CONFIGS_LIST" PARENT_SCOPE)
endfunction()

function(config_append config) 
  escape_value(ARGN "${ARGN}")
  list(APPEND "${config}_CONFIGS_LIST" "${ARGN}")
  set("${config}_CONFIGS_LIST" "${${config}_CONFIGS_LIST}" PARENT_SCOPE)
endfunction()
