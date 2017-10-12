
macro(sweet_config_test__forward_check)

endmacro()

macro(sweet_config_test)
  monitor(sweet_config)
  testcase(sweet_config_test)
  reset_log()
  log_expect("a")
  log_actual("a")
  check("a")
  # sweet_config_test__forward_check(c1 ADD INCLUDES "/path/to/lib1/include" "/path/to/lib2/include")
  # sweet_config_test__forward_check(c1 ADD PROPERTIES "/path/to/lib1/include" "/path/to/lib2/include")
  # sweet_config_test__forward_check(c1 ADD PROPERTIES "/path/to/lib1/include" "/path/to/lib2/include")
  endtestcase()
endmacro()
sweet_config_test()


