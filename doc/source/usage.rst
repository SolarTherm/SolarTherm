Usage
=====

Note: SolarTherm is currently at an early stage of development.  The instructions provided here will change over time, providing the user with more capabilities.

The basic process for using SolarTherm is to construct a Modelica model of the system, drawing on components from the provided Modelica libraries, and then simulate it using one of the provided scripts.  If required components are missing from the provided libraries, then these can be modelled separately and then integrated into the SolarTherm library.

A full tutorial on the process is provided in a later section. Here we list the different components of the project along with a basic description.

Components
----------
SolarTherm
    A Modelica library containing typical system components required to model a full solar thermal power plant.  Models with varying degrees of complexity are included so that the user can make a trade off between simulation speed and accuracy.

solartherm
    A python library that provides common functions and classes for the other tools to use.

st_simulate
    A python script for simulating a plant model.  It compiles the model, calls the simulation, and post processes the results.  It can also be used for performing parameter sweeps or just changing individual parameters without having to recompile the model each time.

st_plotmat
    A python script for easily plotting the results from a simulation.  Behind the scenes it uses the common `matplotlib <http://matplotlib.org>`_ library.

st_wea_to_mo
    A python script for converting TMY3 weather data into a format that is suitable for import into a simulation table.

st_get_aemo_prices
    A python script that downloads spot market prices from `AEMO <http://aemo.com.au/>`_ for a particular year and region, and then converts them into a simulation-table-ready format.
