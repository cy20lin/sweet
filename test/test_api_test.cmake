## test/test_api_test.cmake
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## License: MIT
##

macro(test_api_test)
  testcase(test_api)
  #
  reset_log()
  log_expect("a")
  log_actual("a")
  check_log_equal("check_log_equal between identical logs")
  #
  reset_log()
  log_actual("")
  log_expect("a")
  check_log_not_equal("check_log_not_equal between different logs")
  #
  reset_log()
  log_actual("")
  check_log_not_equal("check_log_not_equal between empty (actual) log and empty line")
  #
  reset_log()
  log_expect("")
  check_log_not_equal("check_log_not_equal between empty (expect) log and empty line")
  #
  reset_log()
  log_expect("")
  log_actual("")
  check_log_equal("check_log_equal for empty line")
  #
  set(CHECK_RESULT 1)
  check_result_equal("check_result_equal")
  #
  set(CHECK_RESULT 0)
  check_result_not_equal("check_result_not_equal")
  #
  endtestcase()
endmacro()
test_api_test()
