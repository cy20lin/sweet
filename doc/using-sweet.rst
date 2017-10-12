Using Sweet
===========

Just clone into your <project-dir>/cmake and than include sweet.cmake
in your ``CMakeLists.txt``.

.. code:: sh

  pushd /path/to/your/project/cmake
  git clone https://github.com/cy20lin/sweet 
  popd

.. code:: cmake
          
  # CMake version 3.1 or above is required
  cmake_minimum_required (VERSION 3.1)
  # Maybe some code here ...
  include("cmake/sweet/sweet.cmake")
  # Now you can use Sweet's APIs
