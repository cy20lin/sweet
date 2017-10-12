Tutorial
========

The problem
-----------

It's painful when it comes to sharing configurations between targets in CMake,
such as sharing sources, include directories, libraries, building options, building
definitions, ...etc.

Recalling the structure of a typical cmake project file, it often contains a list
of commands creating targets, and list of commands configuring the properties,
including pathes, libraries, definitions, options, ...etc, for each target.
It's annoying that sometimes some of the targets sharing with a portion of
configuration, that is, some of the configs are the same, but still we has
to configure these target respectively. Causing the duplication of configuration.
Especially, when the project scaling up, those configuration codes become much more
messy, managing those code is hard, because of the duplication of common configs.
It is kind of unintuitive.


The ``CONFIG`` concept
----------------------

To solve the problem. Sweet introduces the concept of ``CONFIG``, a ``CONFIG`` is a
identifier that internally contains set of configurations, and can be apply to
whatever target you want latter. ``CONFIG`` provide a abstraction to grouping related
configurations into a single ``CONFIG`` instance. It helps managing configurations for
targets with less effort.


Abstract package settings into ``CONFIG``
-----------------------------------------

For example, given a project has two targets, ``a``, ``b``, ``c``.
Target ``a`` depends on ``Boost`` and ``Fmt``.
Target ``b`` depends on ``OpenCV`` and ``Fmt``.
Target ``c`` depends on ``Boost``, ``OpenCV``, and ``Fmt``.

A typical ``CMakeLists.txt`` for that project may look like this:

.. code:: cmake

  cmake_minimum_required(VERSION 3.1)
  project(a_proj)

  # Finding packages
  find_package(Boost)
  find_package(OpenCV)
  find_package(Fmt)

  # Creating targets
  add_executable(a src/a/main.cpp)
  add_executable(b src/b/main.cpp)
  add_executable(c src/c/main.cpp)

  # Configuring target a
  target_include_libraries(a "${BOOST_INCLUDE_DIRS}")
  target_link_libraries(a "${BOOST_LIBRARIES}")
  target_include_libraries(b "${FMT_INCLUDE_DIRS}")
  target_link_libraries(b "${FMT_LIBRARIES}")

  # Configuring target b
  target_include_libraries(b "${OPENCV_INCLUDE_DIR}")
  target_link_libraries(b "${OPENCV_LIBS}")
  target_include_libraries(b "${FMT_INCLUDE_DIRS}")    
  target_link_libraries(b "${FMT_LIBRARIES}")          

  # Configuring target c
  target_include_libraries(c "${BOOST_INCLUDE_DIRS}")
  target_link_libraries(c "${BOOST_LIBRARIES}")
  target_include_libraries(c "${OPENCV_INCLUDE_DIRS}")
  target_link_libraries(c "${OPENCV_LIBS}")
  target_include_libraries(c "${FMT_INCLUDE_DIRS}")
  target_link_libraries(c "${FMT_LIBRARIES}")

With the help of ``sweet``, the project file ``CMakeLists.txt`` becomes.

.. code:: cmake

  cmake_minimum_required(VERSION 3.1)
  project(a_proj)

  # Finding packages
  find_package(Boost)
  find_package(OpenCV)
  find_package(Fmt)

  # Creating targets
  add_executable(a src/a/main.cpp)
  add_executable(b src/b/main.cpp)
  add_executable(c src/c/main.cpp)

  # Create a config called boost, add boost related settings
  sweet_config(boost ADD INCLUDES "${BOOST_INCLUDE_DIRS}")
  sweet_config(boost ADD LIBRARIES "${BOOST_LIBRARIES}")

  # Create a config called fmt, add fmt related settings
  sweet_config(fmt ADD INCLUDES "${FMT_INCLUDE_DIRS}")
  sweet_config(fmt ADD LIBRARIES "${FMT_LIBRARIES}")

  # Create a config called opencv, add opencv related settings
  sweet_config(opencv ADD INCLUDES "${OPENCV_INCLUDE_DIRS}")
  sweet_config(opencv ADD LIBRARIES "${OPENCV_LIBS}")

  # Apply configs for each target
  sweet_target(a ADD CONFIGS boost fmt)
  sweet_target(b ADD CONFIGS opencv fmt)
  sweet_target(c ADD CONFIGS boost opencv fmt)

Use deffered variables in CONFIG
----------------------------------

CONFIG may also depends on the variables that is not exist in the current
definition context but defined in the application context latter.
By using `CONFIGURE` keyword, all deffered variables will only be evaluated
and expanded into real configuration during the config application process to
targets. The deffered variables is resloved according to specific application
context. With different context, the result may vary. 

Deffered variables increase the portability and abstraction of CONFIG. With this
technique it is possible to using variables that would be defined latter and not
exist in current definition context. It is also possible to define a CONFIG 
that is sensitive to local application context variables, but shares some
common properties, too.

Using the previous example with some modification. Suppose that this time we want
to have our CONFIG being defined first, and search for the packages latter. What
we need in this case is to use `deffered variables` in CONFIG to refered to the
variables that will be defined latter in the process of finding the packages.

.. code:: cmake

  cmake_minimum_required(VERSION 3.1)
  project(a_proj)

  # Create a config called boost, add boost related settings
  sweet_config(boost CONFIGURE ADD INCLUDES "\${BOOST_INCLUDE_DIRS}")
  sweet_config(boost CONFIGURE ADD LIBRARIES "\${BOOST_LIBRARIES}")

  # Create a config called fmt, add fmt related settings
  sweet_config(fmt CONFIGURE ADD INCLUDES "\${FMT_INCLUDE_DIRS}")
  sweet_config(fmt CONFIGURE ADD LIBRARIES "\${FMT_LIBRARIES}")

  # Create a config called opencv, add opencv related settings
  sweet_config(opencv CONFIGURE ADD INCLUDES "\${OPENCV_INCLUDE_DIRS}")
  sweet_config(opencv CONFIGURE ADD LIBRARIES "\${OPENCV_LIBS}")

  # Finding packages
  find_package(Boost)
  find_package(OpenCV)
  find_package(Fmt)

  # Creating targets
  add_executable(a src/a/main.cpp)
  add_executable(b src/b/main.cpp)
  add_executable(c src/c/main.cpp)

  # Apply configs for each target
  sweet_target(a ADD CONFIGS boost fmt)
  sweet_target(b ADD CONFIGS opencv fmt)
  sweet_target(c ADD CONFIGS boost opencv fmt)

