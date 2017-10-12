sweet_include
-------------

Load and run CMake code from a file or module.

.. code:: cmake

  sweet_include(<file|module> [OPTIONAL] [RESULT_VARIABLE <VAR>]
                              [NO_POLICY_SCOPE])

Like cmake `include <https://cmake.org/cmake/help/latest/command/include.html>`__ command,
:doc:`/command/sweet_include` load and run CMake code from a file or module. In addition,
:doc:`/command/sweet_include` also set :doc:`/variable/SWEET_CURRENT_LIST` to the path of the
loaded file or module in the loading process.

