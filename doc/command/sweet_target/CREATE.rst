sweet_target(CREATE ...)
========================

Create a specific type of target. This function is intended to be a
generic target creating interface.

.. code:: cmake

    sweet_target(CREATE <target> <type> [<maybe_subtype>] [<arg>]...)
    # <type> ::= EXECUTABLE | LIBRARY | CUSTOM

Create an ``EXECUTABLE`` target
-------------------------------

Add an executable to the project using the specified source files. 

.. code:: cmake

    sweet_target(CREATE <target> EXECUTABLE [<arg>]...)
    # is equivalent to following command
    add_executable(<target> ...)

Create a ``LIBRARY`` target
---------------------------

Add an executable to the project using the specified source files. 

.. code:: cmake

    sweet_target(CREATE <target> LIBRARY <subtype> [<arg>]...)
    # is equivalent to following command
    add_library(<target> <subtype> [<arg>]...)
    # <subtype> ::= STATIC | SHARED | MODULE | ALIAS | INTEFRACE | OBJECT

Create a ``CUSTOM`` target
--------------------------

Add a target with no output so it will always be built.

.. code:: cmake

    sweet_target(CREATE <target> CUSTOM [<arg>]...)
    # is equivalent to following command
    add_custom_target(<target> [<arg>]...)
    # <subtype> ::= STATIC | SHARED | MODULE | ALIAS 
