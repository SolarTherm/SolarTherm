OpenModelica
============

Solvers
-------
The different integration methods are listed `here <https://openmodelica.org/doc/OpenModelicaUsersGuide/latest/simulationflags.html#integration-methods>`_.  The primary solver used is DASSL.

Compilation and Debugging
-------------------------
Return flat Modelica for last class in file ``file.mo`` which uses MSL and SolarTherm libraries::

    omc file.mo Modelica SolarTherm

Create graph dot model for DAE of class (silencing flat model output)::

    omc -q -d=daedumpgraphv file.mo

Use ``omc --help=debug`` to get more debug options.

Language
--------

Here are some notes on different aspects of the Modelica language.  Some of the
quirks presented here may just be specific to OpenModelica, whereas others are
part of the language specification.

Expandable Connectors
"""""""""""""""""""""
Expandable connectors can have some defined components:

.. code-block:: modelica

    expandable connector Bus
        Real a;
    end Bus;

Those that are undefined must be connected to a defined component, and the connect operator must be used:

.. code-block:: modelica

    model Model
        input Real x;
        input Real y;
        Bus bus1;
        Bus bus2;
    equation
        connect(x, bus1.a);
        connect(y, bus1.b);

        connect(bus2.b, bus1.b); // Fail: two undefined components connected
        bus1.b = y; // Fail: connect must be used to construct b
    end Model;

Expandable connectors cannot have flow components, but may contain non-expandable flow components.

The direction (input/output) of an expandable connector component will be determined using the normal rules with respect to the direction of the component connected to.
