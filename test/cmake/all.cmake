macro(test name)
  message("[test] ${name}")
  set(CHECK_PASSED_COUNT 0)
  set(CHECK_FAILED_COUNT 0)
  set(TESTCASE_PASSED_COUNT 0)
  set(TESTCASE_FAILED_COUNT 0)
  set(TEST_NAME "${name}")
  set(TEST_BINARY_DIR "${TEST_CACHE_DIR}/${name}")
  # set(TEST_EXPECT_LOG_PATH "${TEST_BINARY_DIR}/expect.log")
  # set(TEST_ACTUAL_LOG_PATH "${TEST_BINARY_DIR}/actual.log")
endmacro()

macro(endtest)
  if("${TESTCASE_FAILED_COUNT}" EQUAL 0)
    set(TEST_RESULT passed)
  else()
    set(TEST_RESULT failed)
  endif()
  message("[endtest] ${TEST_RESULT}; testcase: ${TESTCASE_FAILED_COUNT} failed, ${TESTCASE_PASSED_COUNT} passed; check: ${CHECK_FAILED_COUNT} failed, ${CHECK_PASSED_COUNT} passed")
endmacro()

macro(testcase name)
  math(EXPR TESTCASE_COUNT "0${TESTCASE_COUNT} + 1")
  set(TESTCASE_CHECK_COUNT 0)
  set(TESTCASE_BINARY_DIR "${TEST_BINARY_DIR}/${name}")
  set(TEST_EXPECT_LOG_PATH "${TESTCASE_BINARY_DIR}/expect.log")
  set(TEST_ACTUAL_LOG_PATH "${TESTCASE_BINARY_DIR}/actual.log")
  file(MAKE_DIRECTORY "${TESTCASE_BINARY_DIR}")
  set(TESTCASE_CHECK_PASSED_COUNT 0)
  set(TESTCASE_CHECK_FAILED_COUNT 0)
  set(TESTCASE_NAME "${name}")
  remove_log()
  message("  [testcase][${TESTCASE_COUNT}] ${name}")
endmacro()

macro(endtestcase)
  if("${TESTCASE_CHECK_FAILED_COUNT}" EQUAL 0)
    set(TESTCASE_RESULT passed)
    math(EXPR TESTCASE_PASSED_COUNT "${TESTCASE_PASSED_COUNT} + 1")
  else()
    set(TESTCASE_RESULT failed)
    math(EXPR TESTCASE_FAILED_COUNT "${TESTCASE_FAILED_COUNT} + 1")
  endif()
  # set(TEST_EXPECT_LOG_PATH "${TEST_BINARY_DIR}/expect.log")
  # set(TEST_ACTUAL_LOG_PATH "${TEST_BINARY_DIR}/actual.log")
  file(REMOVE_RECURSE "${TEST_EXPECT_LOG_PATH}" expect_log)
  file(REMOVE_RECURSE "${TEST_ACTUAL_LOG_PATH}" acutal_log)
  message("  [endtestcase][${TESTCASE_COUNT}] ${TESTCASE_RESULT}; check: ${TESTCASE_CHECK_FAILED_COUNT} failed, ${TESTCASE_CHECK_PASSED_COUNT} passed")
endmacro()

function(remove_log)
  file(REMOVE "${TEST_ACTUAL_LOG_PATH}")
  file(REMOVE "${TEST_EXPECT_LOG_PATH}")
endfunction()

function(reset_log)
  file(WRITE "${TEST_ACTUAL_LOG_PATH}" "")
  file(WRITE "${TEST_EXPECT_LOG_PATH}" "")
endfunction()

function(monitor command)
  # message("${PROJECT_SOURCE_DIR}/test/cmake/monitor.cmake.in")
  configure_file(
    "${PROJECT_SOURCE_DIR}/test/cmake/monitor.cmake.in"
    "${TEST_CACHE_DIR}/cmake/monitor/${command}.cmake"
    @ONLY)
  include("${TEST_CACHE_DIR}/cmake/monitor/${command}.cmake")
endfunction()

function(log_actual msg)
  file(APPEND "${TEST_ACTUAL_LOG_PATH}" "${msg}\n")
  # message("      [log_actual] ${msg}")
endfunction()

function(log_expect msg)
  file(APPEND "${TEST_EXPECT_LOG_PATH}" "${msg}\n")
  # message("      [log_expect] ${msg}")
endfunction()

function(expect command)
  log_expect("function=${fn}")
  math(EXPR argc "0${ARGC} - 1")
  log_expect("ARGC=${argc}")
  foreach(i RANGE 1 "${argc}")
    math(EXPR ii "${i} - 1")
    log_expect("ARGV${ii}=${ARGV${i}}")
  endforeach()
  log_expect("")
endfunction()

macro(check description)
  math(EXPR TESTCASE_CHECK_COUNT "0${TESTCASE_CHECK_COUNT} + 1")
  math(EXPR CHECK_COUNT "0${CHECK_COUNT} + 1")
  set(CHECK_BINARY_DIR "${TESTCASE_BINARY_DIR}/")
  message("    [check][${TESTCASE_CHECK_COUNT}] ${description}")
  unset(expect_log)
  unset(actual_log)
  file(READ "${TEST_EXPECT_LOG_PATH}" expect_log)
  file(READ "${TEST_ACTUAL_LOG_PATH}" actual_log)
  string(COMPARE EQUAL "${expect_log}" "${actual_log}" CHECK_RESULT)
  if("${CHECK_RESULT}" EQUAL 0)
    math(EXPR TESTCASE_CHECK_FAILED_COUNT "${TESTCASE_CHECK_FAILED_COUNT} + 1")
    math(EXPR CHECK_FAILED_COUNT "${CHECK_FAILED_COUNT} + 1")
    message("    [endcheck][${TESTCASE_CHECK_COUNT}] failed")
  else()
    math(EXPR TESTCASE_CHECK_PASSED_COUNT "${TESTCASE_CHECK_PASSED_COUNT} + 1")
    math(EXPR CHECK_PASSED_COUNT "${CHECK_PASSED_COUNT} + 1")
    message("    [endcheck][${TESTCASE_CHECK_COUNT}] passed")
  endif()
endmacro()

macro(save_check_log)
  file(REMOVE_RECURSE "${TESTCASE_BINARY_DIR}/${TESTCASE_CHECK_COUNT}")
  file(MAKE_DIRECTORY "${TESTCASE_BINARY_DIR}/${TESTCASE_CHECK_COUNT}")
  file(RENAME "${TESTCASE_BINARY_DIR}/expect.log" "${TESTCASE_BINARY_DIR}/${TESTCASE_CHECK_COUNT}/expect.log")
  file(RENAME "${TESTCASE_BINARY_DIR}/actual.log" "${TESTCASE_BINARY_DIR}/${TESTCASE_CHECK_COUNT}/actual.log")
endmacro()
