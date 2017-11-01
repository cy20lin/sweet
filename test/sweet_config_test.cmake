## test/sweet_config_test.cmake
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

macro(sweet_config_test)
  monitor(_sweet_target_add)
  testcase(sweet_config_test)
  # if(COMMAND sweet_config)
  #   set(CHECK_RESULT 1)
  # elseif()
  #   set(CHECK_RESULT 0)
  # endif()
  # check_result_equal("if COMMAND sweet_config defined")
  #
  reset_log()
  sweet_config(c1 ADD INCLUDES arg1 arg2)
  _sweet_target_add_configs(t c1)
  log_expect_command(_sweet_target_add t INCLUDES arg1 arg2)
  check_log_equal("target_config(c1 ADD INCLUDES arg1 arg2)")
  save_log()
  # _sweet_target_add is called only if config is not empty
  reset_log()
  sweet_config(c1 RESET)
  _sweet_target_add_configs(t c1)
  check_log_equal("target_config(c2 RESET)")
  save_log()
  #
  reset_log()
  sweet_config(c3 ADD INCLUDES "")
  _sweet_target_add_configs(t c3)
  log_expect_command(_sweet_target_add t INCLUDES)
  check_log_equal("target_config(c1 ADD INCLUDES \"\")")
  save_log()
  #
  endtestcase()
endmacro()
sweet_config_test()


