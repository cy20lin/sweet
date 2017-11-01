## test/sweet_config_test.cmake
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

macro(sweet_target_test)
  testcase(sweet_target_test)
  set(commands
    set_target_properties\\\;PROPERTIES
    target_sources\\\;SOURCES
    target_include_directories\\\;INCLUDES
    target_link_libraries\\\;LIBRARIES
    target_compile_definitions\\\;DEFINITIONS
    target_compile_features\\\;FEATURES
    target_compile_options\\\;OPTIONS
    _sweet_target_add_configs\\\;CONFIGS
    _sweet_target_add_packages\\\;PACKAGES
  )
  foreach(pair IN LISTS commands)
    list(GET pair 0 command)
    list(GET pair 1 key)
    monitor(${command})
    #
    reset_log()
    sweet_target(t ADD ${key} arg1 "arg2 with space")
    log_expect_command(${command} t arg1 "arg2 with space")
    check_log_equal("sweet_target(t ADD ${key} arg1 \"arg 2 with space\")")
    save_log()
    #
    reset_log()
    set(arg1 ARG1)
    sweet_target(t CONFIGURE ADD ${key} "\${arg1}")
    log_expect_command(${command} t ARG1)
    check_log_equal([[target_target(t CONFIGURE ADD "\\\\\\\${arg1}")]])
    save_log()
    #
    reset_log()
    sweet_target(t ADD ${key})
    log_expect_command(${command} t)
    check_log_equal("sweet_target(t ADD ${key})")
    save_log()
    #
    reset_log()
    sweet_target(t ADD ${key} "")
    log_expect_command(${command} t)
    check_log_equal("sweet_target(t ADD ${key} \"\")")
    save_log()
    #
  endforeach()
  endtestcase()
  include("${SWEET_ROOT}/cmake/sweet_target.cmake")
endmacro()
sweet_target_test()


