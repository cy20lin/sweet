## cmake/sweet_config.cmake
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

## public interfaces ##

function(sweet_config config option)
  if("${option}" STREQUAL "ADD")
    _sweet_config_add("${config}" "${ARGN}")
    set("${config}" "${${config}}" PARENT_SCOPE)
  elseif("${option}" STREQUAL "RESET")
    set("${config}" "" PARENT_SCOPE)
  elseif("${option}" STREQUAL "UNSET")
    unset("${config}" PARENT_SCOPE)
  endif()
endfunction()

## implementation details ##

function(_sweet_config_add config)
  sweet_escape_list_value(ARGN "${ARGN}")
  list(APPEND "${config}" "${ARGN}")
  set("${config}" "${${config}}" PARENT_SCOPE)
endfunction()
