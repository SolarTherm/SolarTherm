Simple Model
============

Simulating
----------

Start the shell::

    OMShell-terminal

Load the simple model and the standard libraries::

    loadModel(SolarTherm.ControlSimple)
    loadModel(Modelica)

Simulate the model for 20 seconds and plot results::

    simulate(SolarTherm.ControlSimple, stopTime=20)
    plot({sol.port1.p, tank.e, gen.p})

A simple python script has been written to call these commands through the python interface.  Call this using::

    python test/run_simply.py
