Libraries
=========
Here we list a number of existing libraries and within them the components that might be useful.

Modelica
--------
A number of standard and third party Modelica libraries are listed in the `Modelica library documentation`_.

.. _Modelica library documentation: https://build.openmodelica.org/Documentation/index.html

Modelica
^^^^^^^^
The `Modelica standard library`_.

.. _Modelica standard library: http://modelica.github.io/Modelica/

ThermoSysPro
^^^^^^^^^^^^
ThermoSysPro_ is an EDF library that provides common components for the static and dynamic modelling of nuclear, thermal and solar power power plants, and energy conversion systems.

Of interest it has models for `molten salt <https://build.openmodelica.org/Documentation/ThermoSysPro.Properties.MoltenSalt.html>`_ and a `solar collector <https://build.openmodelica.org/Documentation/ThermoSysPro.Solar.SolarCollector.html>`_.  There is a paper from SolarPACES 2013 on using this library for modelling three types of solar plant by `Baligh El Hefni 2013 <http://www.sciencedirect.com/science/article/pii/S1876610214005761>`_.

It is open source, but the only access I have found to the library is from checking out the OpenModelica fork `here <https://github.com/dmikurube/OpenModelica/tree/master/testsuite/uncertainties/TestModels/ThermoSysPro>`_.

.. _ThermoSysPro: http://www.eurosyslib.com/

ThermoCycle
^^^^^^^^^^^
ThermoCycle_ is unique in its ability to handle non-conventional working fluids (refridgerants, ammonia, etc).  It uses the external library CoolProp_ in order to obtain the properties of these complex fluids, which is connected through the ExternalMedia_ interface.

It contains models for a couple of solar collectors and some tutorials on their website.  They have a number of `papers <http://www.thermocycle.net/publications/>`_, including one on dynamic simulation of a micro-CSP plant with storage `Ireland et al. 2014 <http://orbi.ulg.ac.be/handle/2268/169522>`_.  The publications page also contains links to a couple of repositories which might contain additional models resulting from these publications.

I have only seen mention of Dymola on the website, so it is yet to be seen whether this will work under OpenModelica.  The github link to the library is `here <https://github.com/thermocycle/Thermocycle-library>`_.

.. _ThermoCycle: http://www.thermocycle.net/

ThermoPower
^^^^^^^^^^^
ThermoPower_ is for the dynamic modelling of thermal power plants with the purpose of studying control system strategies and architectures.

It lists quite a number of papers including one on a solar supercritical CO2 brayton cycle by `Casella and Colonna 2011 <http://www.sco2powercyclesymposium.org/resource_center/system_modeling_control/development-of-modelica-dynamic-model-of-solar-supercritical-co2-brayton-cycle-power-plants-for-control-studies>`_.

It was developed primarily for Dymola.  It has some reporting on the test failures under OpenModelica.  The github repository is `here <https://github.com/modelica-3rdparty/ThermoPower>`_.

.. _ThermoPower: https://build.openmodelica.org/Documentation/ThermoPower.html

Buildings
^^^^^^^^^
`Buildings <http://simulationresearch.lbl.gov/modelica>`_ is used to model the thermal performance of buildings.

Buildings.BoundaryConditions.WeatherData.ReaderTMY3_ is used to read in TMY3 weather data, including those supplied with EnergyPlus.  It is a block component type that provides the data on ports to which other components can connect.  An example is provided `here <https://build.openmodelica.org/Documentation/Buildings.BoundaryConditions.WeatherData.Examples.ReaderTMY3.html>`_.  This example failed on an initial test with OpenModelica.

.. _Buildings: http://simulationresearch.lbl.gov/modelica
.. _Buildings.BoundaryConditions.WeatherData.ReaderTMY3: https://build.openmodelica.org/Documentation/Buildings.BoundaryConditions.WeatherData.ReaderTMY3.html

Other
-----
ExternalMedia
^^^^^^^^^^^^^
ExternalMedia_ provides a framework for interfacing external fluid property code.  It works with FluidProp_ and CoolProp_, but has only been tested for OpenModelica on Windows (Dymola on Linux).

.. _ExternalMedia: https://github.com/modelica/ExternalMedia

CoolProp
^^^^^^^^
CoolProp_ is a C++ library for calculating fluid properties.

.. _CoolProp: http://www.coolprop.org/

FluidProp
^^^^^^^^^
FluidProp_ is proprietary but a free version is available with a subset of the features.

.. _FluidProp: http://www.asimptote.nl/software/fluidprop
