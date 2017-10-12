macro(sweet_target_test)
  testcase(sweet_target_test)
  reset_log()
  log_expect("1")
  log_actual("1")
  check("b")
  save_check_log()

  reset_log()
  log_expect("1")
  log_actual("2")
  check("c")
  save_check_log()

  reset_log()
  check("d")
  save_check_log()

  reset_log()
  log_expect("")
  log_actual("")
  check("d")
  save_check_log()

  endtestcase()
endmacro()
sweet_target_test()


