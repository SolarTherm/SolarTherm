Simple Model
============

Simulating
----------

Start the shell::

    OMShell-terminal

Load the simple model and the standard libraries::

    loadModel(SolarTherm.Examples.SystemSimple)
    loadModel(Modelica)

Simulate the model for 20 seconds and plot results::

    simulate(SolarTherm.Examples.SystemSimple, stopTime=20)
    plot({sol.port1.p, tank.e, gen.p})

A simple python script has been written to call these commands through the python interface.  Call this from the source directory using::

    python2 src/python/examples/run_simple
