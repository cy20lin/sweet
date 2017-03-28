## cmake/target.cmake --- target manipulating utilities
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

# target operations
#   make_target_name           name output
#   make_target_pattern        name output
#   target_add
#   target_create target_name  target_type ...
# metadata operations
#   sub object operations
#     target_metadata_get_ref  target var output
#     target_metadata_get      target var output
#     target_metadata_set      target var value
#     target_metadata_unset    target var value
#   object operations
#     target_generate_metadata name
#     target_generate_metadata target pattern prefix
#     target_unset_metadata    target
#     target_apply_metadata    target
# target use operations
#   target_use_target            target targets...
#   target_use_config            target configs...
#   target_use_package           target packages...
#   target_use_targets           target targets...
#   target_use_configs           target configs...
#   target_use_packages          target packages...
#
###
# target operations
#   make_target_name           name output
#   make_target_pattern        name output
#   target_add
#   target_create target_name  target_type ...

set(TARGET_DATA_TYPES 
  PROPERTIES
  FEATURES
  OPTIONS
  DEFINITIONS
  INCLUDES
  LIBRARIES
  SOURCES
  )

function(__target_add_basic target data_type)
  message("target_add(${ARGV})")
  if(ARGN STREQUAL "")
    return()
  elseif(data_type STREQUAL "NOTHING")
    return()
  endif()
  if (data_type STREQUAL "PROPERTIES" ) # OR data_type STREQUAL "set_properties")
    if ("${ARGV2}" STREQUAL "PROPERTIES")
      set_target_properties("${target}" ${ARGN})
    else()
      set_target_properties("${target}" PROPERTIES ${ARGN})
    endif()
  elseif (data_type STREQUAL "SOURCES") # OR data_type STREQUAL "target_sources")
    target_sources("${target}" ${ARGN})
  elseif (data_type STREQUAL "INCLUDES") # OR data_type STREQUAL "include_directories")
    target_include_directories("${target}" ${ARGN})
  elseif (data_type STREQUAL "LIBRARIES") # OR data_type STREQUAL "link_libraries")
    target_link_libraries("${target}" ${ARGN})
  elseif (data_type STREQUAL "DEFINITIONS") # OR data_type STREQUAL "compile_definitions")
    target_compile_definitions("${target}" ${ARGN})
  elseif (data_type STREQUAL "FEATURES") # OR data_type STREQUAL "compile_features")
    target_compile_features("${target}" ${ARGN})
  elseif (data_type STREQUAL "OPTIONS") # OR data_type STREQUAL "compile_options")
    target_compile_options("${target}" ${ARGN})
  elseif (data_type STREQUAL "DEPENDENCIES") # OR data_type STREQUAL "compile_options")
    add_compile_options("${target}" ${ARGN})
  elseif (data_type STREQUAL "DEPENDENCIES") # OR data_type STREQUAL "compile_options")
    add_compile_options("${target}" ${ARGN})
  elseif (data_type STREQUAL "CUSTOM_COMMAND") # OR data_type STREQUAL "compile_options")
    add_custom_command(TARGET "${target}" ${ARGN})
  else()
    message(FATAL_ERROR "in function 'target_add': wrong target data type")
  endif()
endfunction()

function(target_use_targets target)
  foreach(target_ IN LISTS ARGN)
    if("${target}" STREQUAL "${target_}")
      message(AUTHOR_WARNING "target_use_targets: target '${target}' references itself.")
    endif()
    foreach(args IN LISTS "${target_}_EXPORT_CONFIGS_LIST")
      __target_add_basic("${target}" ${args})
    endforeach()
  endforeach()
endfunction()

function(target_use_configs target)
  foreach(config IN LISTS ARGN)
    foreach(args IN LISTS "${config}_CONFIGS_LIST")
      __target_add_basic("${target}" ${args})
    endforeach()
  endforeach()
endfunction()

function(target_use_packages target)
  foreach(package IN LISTS ARGN)
    if(${package}_FOUND)
      set("${package}_INCLUDES" SYSTEM ${${package}_INCLUDES})
      foreach(data_type IN LISTS TARGET_DATA_TYPES)
          __target_add_basic("${target}" "${data_type}" ${${package}_${data_type}})
        endif()
      endforeach()
    else()
      message(AUTHOR_WARNING "package: '${package}' not found.")
    endif()
  endforeach()
endfunction()

function(target_use target)
  foreach(object IN LISTS ARGN)
    if(DEFINED ${object}_FOUND)
      target_use_packages("${target}" "${object}")
    elseif(DEFINED ${object}_CONFIGS_LIST)
      target_use_configs("${target}" "${object}")
    elseif(DEFINED ${object}_TARGET_NAME)
      target_use_targets("${target}" "${object}")
    endif()
  endforeach()
endfunction()

function(__target_add_compound target type)
  if (type STREQUAL "PACKAGES")
    target_use_packages("${target}" ${ARGN})
  elseif (type STREQUAL "CONFIGS")
    target_use_configs("${target}" ${ARGN})
  elseif (type STREQUAL "TARGETS")
    target_use_targets("${target}" ${ARGN})
  elseif (type STREQUAL "AUTO")
    target_use("${target}" ${ARGN})
  else()
    __target_add_basic("${target}" "${type}" ${ARGN})
  endif()
endfunction()


function(target_add target type)
  # implementation-decision: 
  # using escape_argn(ARGN "${ARGN}") or not
  if (type STREQUAL "CONFIGURE")
    string(CONFIGURE "${ARGN}" ARGN)
    __target_add_compound("${target}" ${ARGN})
  else()
    __target_add_compound("${target}" "${type}" ${ARGN})
  endif()
endfunction()

function(target_create target type)
  if (type STREQUAL "EXECUTABLE" OR type STREQUAL "add_executable")
    add_executable(${target} ${ARGN} "")
  elseif(type STREQUAL "LIBRARY" OR type STREQUAL "add_library")
    add_library(${target} ${ARGN} "")
    set(type "STATIC_LIBRARY")
    foreach(subtype STATIC SHARED MODULE INTERFACE ALIAS UNKNOWN)
      if (ARGV2 STREQUAL "${subtype}")
        set(type "${subtype}_LIBRARY")
        break()
      endif()
    endforeach()
  elseif(type STREQUAL "CUSTOM" OR type STREQUAL "add_custom_target")
    add_custom_target(${target} ${ARGN} "")
  elseif(type STREQUAL "STATIC_LIBRARY")
    add_library(${target} STATIC ${ARGN} "")
  elseif(type STREQUAL "SHARED_LIBRARY")
    add_library(${target} SHARED ${ARGN} "")
  elseif(type STREQUAL "MODULE_LIBRARY")
    add_library(${target} MODULE ${ARGN} "")
  elseif(type STREQUAL "INTERFACE_LIBRARY") 
    add_library(${target} INTERFACE ${ARGN} "")
  elseif(type STREQUAL "OBJECT_LIBRARY")
    add_library(${target} OBJECT ${ARGN} "")
  elseif(type STREQUAL "UNKNOWN_LIBRARY")
    add_library(${target} UNKNOWN ${ARGN} "")
  elseif(type STREQUAL "ALIAS_LIBRARY")
    add_library(${target} ALIAS ${ARGN} "")
  else()
    message(FATAL_ERROR "in function 'target_create': wrong target type")
  endif()
  set("${target}_TYPE" "TARGET" PARENT_SCOPE)
  set("${target}_TARGET_TYPE" "${type}" PARENT_SCOPE)
  set("${target}_TARGET_NAME" "${target}" PARENT_SCOPE)
endfunction()

###
# metadata operations
#   sub object operations
#     target_internal_unset    target var value
#     target_internal_get_ref  target var output
#     target_internal_get      target var output
#     target_internal_set      target var value
#     target_export_unset    target var value
#     target_export_get_ref  target var output
#     target_export_get      target var output
#     target_export_set      target var value

###
# metadata operations
#   object operations
#     target_generate_metadata name
#     target_generate_metadata target pattern prefix
#     target_unset_metadata    target
#     target_apply_metadata    target

function(target_generate_metadata name)
  # args
  #   name
  #   target_name, pattern, prefix
  # matadata
  # .PREFIX
  # .PATTERN
  # .TARGET_NAME
  # .SRC_DIR
  # .INCLUDE_DIR
  # .SRC_FILES
  # .INCLUDE_FILES
  # .PUBLIC_SOURCES
  # .PRIVATE_SOURCES
  # .TARGET_TYPE

  ###
  # .PREFIX
  if(NOT "${ARGV2}" STREQUAL "")
    set(prefix "${ARGV2}")
  else()
    set(prefix "${PROJECT_SOURCE_DIR}")
  endif()
  set("${target_name}_PREFIX" "${prefix}"     PARENT_SCOPE)

  ###
  # .PATTERN
  # .TARGET_NAME
  if(NOT "${ARGV1}" STREQUAL "")
    set(target_name "${ARGV0}")
    set(pattern "${ARGV1}")
  else()
    string(FIND "${name}" "/" is_pattern)
    if (NOT ${is_pattern} EQUAL -1)
      string(REPLACE "/" "_" target_name "${name}")
    else()
      set(target_name "${name}")
    endif()
    set(pattern "${name}")
  endif()
  set("${target_name}_PATTERN"     "${pattern}"     PARENT_SCOPE)
  set("${target_name}_TARGET_NAME" "${target_name}" PARENT_SCOPE)
  set("${target_name}_PREFIX"      "${prefix}"      PARENT_SCOPE)

  ###
  # .SRC_DIR
  # .INCLUDE_DIR
  # .SRC_FILES
  # .INCLUDE_FILES
  # .PUBLIC_SOURCES
  # .PRIVATE_SOURCES
  # .PUBLIC_SOURCES
  set(${target_name}_INCLUDE_DIR     "${prefix}/include/${pattern}")
  set(${target_name}_SRC_DIR         "${prefix}/src/${pattern}")
  set(${target_name}_INCLUDE_DIR     "${prefix}/include/${pattern}" PARENT_SCOPE)
  set(${target_name}_SRC_DIR         "${prefix}/src/${pattern}" PARENT_SCOPE)
  foreach(ref "${target_name}_SRC" "${target_name}_INCLUDE")
    if (NOT EXISTS "${${ref}_DIR}" OR NOT IS_DIRECTORY "${${ref}_DIR}")
      get_filename_component(path "${${ref}_DIR}/.." ABSOLUTE)
      file(GLOB files "${path}" "${path}/${target_name}.*")
      remove_if_is_directory(files "${files}")
      set(${ref}_DIR "" PARENT_SCOPE)
    else()
      get_filename_component(path "${${ref}_DIR}/.." ABSOLUTE)
      file(GLOB files "${path}" "${path}/${target_name}.*")
      file(GLOB_RECURSE files_ "${${ref}_DIR}" "${${ref}_DIR}/*")
      list(APPEND files ${files_})
      remove_if_is_directory(files "${files}")
    endif()
    set("${ref}_FILES" "${files}" PARENT_SCOPE)
    set("${ref}_FILES" "${files}")
  endforeach()
  # set(source_ext_list .cpp .cxx .c .cc .h .hh .ipp .ixx)
  set(source_ext_list .c .C .c++ .cc .cpp .cxx .m .M .mm .h .hh .h++ .hm .hpp .hxx .in .txx .ipp .ixx)
  foreach(name SRC INCLUDE)
    keep_if_end_with(files "${${target_name}_${name}_FILES}" ${source_ext_list})
    set(${target_name}_${name}_SOURCES "${files}" PARENT_SCOPE)
    set(${target_name}_${name}_SOURCES "${files}")
  endforeach()
  config_add(${target_name}_INTERNAL
    PUBLIC "${${target_name}_INCLUDE_FILES}"
    PRIVATE "${${target_name}_SRC_FILES}" PARENT_SCOPE)

  ###
  # .TARGET_TYPE
  # if(NOT "${${target_name}_TARGET_TYPE}" STREQUAL "")
  #   foreach(name INCLUDE SRC)
  #     if("${target_name}_${name}_DIR" STREQUAL "")
  #       set(has_${name} 1)
  #     else()
  #       set(has_${name} 0)
  #     endif()
  #   endforeach()
  #   set(guess_case_11 "STATIC_LIBRARY")
  #   set(guess_case_01 "EXECUTABLE")
  #   set(guess_case_10 "INTERFACE_LIBRARY")
  #   set(guess_case_00 "")
  #   set(${target_name}_TARGET_TYPE "${guess_case_${has_INCLUDE}${has_SRC}}" PARENT_SCOPE)
  #   # if("${${target_name}_TARGET_TYPE}" STREQUAL "")
  #   #   target_unset_metadata("${target_name}" PARENT_SCOPE)
  #   #   return()
  #   # endif()
  # endif()
  set(target_type "${${target_name}_TARGET_TYPE}")

  ### glob_target_source_files ###
  # .INCLUDES
  # .LIBRARIES
  get_filename_component(path "${${target_name}_INCLUDE_DIR}/.." ABSOLUTE)
  set(${target_name}_EXPORT_INCLUDES "${path}" PARENT_SCOPE)
  if (target_type STREQUAL "STATIC_LIBRARY")
    set(${target_name}_EXPORT_LIBRARIES "${target_name}" PARENT_SCOPE) 
  elseif (target_type STREQUAL "SHARED_LIBRARY")
    set(${target_name}_EXPORT_LIBRARIES "${target_name}" PARENT_SCOPE) 
  elseif (target_type STREQUAL "MODULE_LIBRARY")
    set(${target_name}_EXPORT_LIBRARIES "${target_name}" PARENT_SCOPE) 
  elseif (target_type STREQUAL "OBJECT_LIBRARY")
    set(${target_name}_EXPORT_SOURCES "PRIVATE;$<TARGET_OBJECTS:${target_name}>" PARENT_SCOPE) 
  endif()
endfunction()

function(target_apply_metadata target)
  foreach(data_type IN LISTS TARGET_DATA_TYPES)
    target_add("${target}" "${data_type}" "${${target}_INTERNAL_${data_type}}")
  endforeach()
endfunction()

macro(target_unset_metadata target_name)
  foreach(var
    TARGET_NAME
    TARGET_TYPE
    PREFIX
    PATTERN
    SRC_DIR
    INCLUDE_DIR
    SRC_FILES
    INCLUDE_FILES

    EXPORT_PROPERTIES
    EXPORT_FEATURES
    EXPORT_OPTIONS
    EXPORT_DEFINITIONS
    EXPORT_INCLUDES
    EXPORT_LIBRARIES
    EXPORT_SOURCES

    INTERNAL_PROPERTIES
    INTERNAL_FEATURES
    INTERNAL_OPTIONS
    INTERNAL_DEFINITIONS
    INTERNAL_INCLUDES
    INTERNAL_LIBRARIES
    INTERNAL_SOURCES
    )
    unset(${target_name}_${var} ${ARGN})
  endforeach()
endmacro()


###
# target_use_target            target targets...
# target_use_config            target configs...
# target_use_package           target packages...
# target_use_targets           target targets...
# target_use_configs           target configs...
# target_use_packages          target packages...
