sweet_target(ADD ...)
=====================

Add and apply specific ``<type>`` of ``[<setting>]...`` into ``<target>``. 
This function is intended to be a generic target manipulating interface.

.. code:: cmake

    sweet_target(ADD <target> <type> <settings...>)
    # <type> ::= PROPERTIES  | SOURCES  | LIBRARIES | INCLUDES | FEATURES | OPTIONS |
    #            DEFINITIONS | NOTHING  | PACKAGES  | CONFIGS  | TARGETS  | AUTO

Set properties
--------------

Targets can have properties that affect how they are built. `More... <https://cmake.org/cmake/help/v3.1/command/set_target_properties.html>`__

.. code:: cmake

    sweet_target(ADD <target> PROPERTIES [<property> <value>]...)
    # is equivalent to following command
    set_target_properties(<target> PROPERTIES [<property> <value>]...)

Add sources
-----------

Add sources to a target. `More... <https://cmake.org/cmake/help/v3.1/command/target_sources.html>`__

.. code:: cmake

    sweet_target(ADD <target> SOURCES )
    # is equivalent to following command
    target_sources(<target> ) 

Include directories
-------------------

Add include directories to a target. `More... <https://cmake.org/cmake/help/v3.1/command/target_include_directories.html>`__

.. code:: cmake

    sweet_target(ADD <target> INCLUDES <arg>...)
    # is equivalent to following command
    target_include_directories(<target> <arg>...)

Link libraries
--------------

Link a target to given libraries. `More... <https://cmake.org/cmake/help/v3.1/command/target_link_libraries.html>`__

.. code:: cmake

    sweet_target(ADD <target> LIBRARIES <arg>...) 
    # is equivalent to following command
    target_link_libraries(<target> <arg>...)

Set compile options
-------------------

Add compile options to a target. `More... <https://cmake.org/cmake/help/v3.1/command/target_compile_definitions.html>`__

.. code:: cmake

    sweet_target(ADD <target> OPTIONS <arg>...) 
    # is equivalent to following command
    target_compile_options(<target> <arg>...)

Set compile definitions
-----------------------

Add compile definitions to a target. `More... <https://cmake.org/cmake/help/v3.8/command/target_compile_definitions.html>`__

.. code:: cmake

    sweet_target(ADD <target> DEFINITIONS <arg>...) 
    # is equivalent to following command
    target_compile_definitions(<target> <arg>...)

Set compile features
--------------------

Add expected compiler features to a target. `More... <https://cmake.org/cmake/help/v3.1/command/target_compile_features.html>`__

.. code:: cmake

    sweet_target(ADD <target> FEATURES <arg>...) 
    # is equivalent to following command
    target_compile_features(<target> <arg>...)

Add dependencies
----------------

Add a dependency between top-level targets. `More... <https://cmake.org/cmake/help/v3.1/command/add_dependencies.html>`__

.. code:: cmake

    sweet_target(ADD <target> DEPENDENCIES <arg>...) 
    # is equivalent to following command
    add_dependencies(<target> <arg>...)

Add custom commands
-------------------

Add a custom build rule to the generated build system. `More... <https://cmake.org/cmake/help/v3.1/command/add_custom_command.html>`__

.. code:: cmake

    sweet_target(ADD <target> CUSTOM_COMMAND <arg>...) 
    # is equivalent to following command
    add_custom_command(TARGET <target> <arg>...)
