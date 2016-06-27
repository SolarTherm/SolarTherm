Libraries
=========
Here we list a number of existing libraries and within them the components that might be useful.  Many of these libraries provide components that can be used for the detailed simulation of solar thermal power plants.  However, it is yet to be seen if they are suitable for performing year long simulations and if they have enough flexibility to enable rapid development and prototyping of new configurations.

Modelica
--------
A number of standard and third party Modelica libraries are listed `here <https://www.modelica.org/libraries>`__ with more details found `here <https://build.openmodelica.org/Documentation/index.html>`__.

Modelica
^^^^^^^^
The `Modelica standard library`_.

`Machines <http://modelica.github.io/Modelica/om/Modelica.Electrical.Machines.html>`__
    Models for synchronous, asynchronous and DC machines.

`Fluid <http://modelica.github.io/Modelica/om/Modelica.Fluid.html>`__
    1-dimensional thermo-fluid flow in pipes, vessels, fluid machines, valves and fittings.  Any of the media from the Media library can be used.  The components in this library need a System component at the top level to describe the surrounding environment, assumptions, initialisation and default parameters.  Some of the assumption options are: reversible flows, dynamic vs steady-state, ignore storage of mass, momentum and energy.

    `Connectors <http://modelica.github.io/Modelica/om/Modelica.Fluid.UsersGuide.ComponentDefinition.FluidConnectors.html>`__
        Ideal mixing is used to handle joins of more than two connectors.  It makes use of `stream <https://github.com/modelica/Modelica/blob/release/Modelica%203.2.1/Resources/Documentation/Fluid/Stream-Connectors-Overview-Rationale.pdf>`_ connections to handle enthalpy and other fluid properties.  For a single substance medium, mass flow rate, absolute pressure and specific enthalpy are used.  For multi-substance media mass fractions are used for both significant components and trace components (fluid properties are ignored but mass is balanced).  The connectors don't model any friction or velocity changes at the point of connection, so explicit components should be modelled if this or non-ideal mixing is needed (for example fittings).

    `Vessels <http://modelica.github.io/Modelica/om/Modelica.Fluid.Vessels.html>`__
        Closed volume and open tank vessels as well as base classes to build your own.  They are ideally mixed and have the option for heat transfer through a thermal port.  Pressure losses for the fluid ports can be turned on to model different types of port connections to the vessel.

    `Pipes <http://modelica.github.io/Modelica/om/Modelica.Fluid.Pipes.html>`__
        Models for static (no mass or energy storage) and dynamic pipes.  A dynamic pipe can be used to produce the same results as the static pipe by changing a setting.  There are lots of parameter settings, so it might be best to refer to the examples to get an idea of how to model different types of pipes.  A finite volume method and staggered grid scheme is used to approximate the PDEs.  The pipe is split into a user selectable number of nodes.  I has heat ports which can be used for thermal losses or other heat exchange purposes.

    `Machines <http://modelica.github.io/Modelica/om/Modelica.Fluid.Machines.html>`__
        Pistons and pumps.  The centrifugal pumps can either be ideally controlled or externally operated by a shaft or electronic signal.

`Media <http://modelica.github.io/Modelica/om/Modelica.Media.UsersGuide.html>`__
    Media thermodynamic parameters are defined with functions, polynomial equations or tables.  Fluids include ideal gases, water, air, table-based incompressible fluids and compressible liquids.  Instructions are provided on how to `define <http://modelica.github.io/Modelica/om/Modelica.Media.UsersGuide.MediumDefinition.html>`__ and `use <http://modelica.github.io/Modelica/om/Modelica.Media.UsersGuide.MediumUsage.html>`__ media.  Custom fluids can be provided and will work with other components as long as they extend the media interface.
    

`Thermal <http://modelica.github.io/Modelica/om/Modelica.Thermal.html>`__
    This is split into two libraries, one on incompressible fluid heat flows and one on heat transfer with lumped elements.  It is not obvious how the thermal fluid flows is different from what is provided in the Fluid library.  One possibility is that the media is simplified here because the focus is on thermal transfer?

`Blocks <http://modelica.github.io/Modelica/om/Modelica.Blocks.html>`__
    Blocks contains input/output blocks that can do a whole range of things including PID control, filtering, transfer functions, mathematical operations, logic, sampling, limiting, delays, signal generation and table interpolation (for tabled data provided in hard-coded C).

`Utilities <http://modelica.github.io/Modelica/om/Modelica.Utilities.html>`__
    This library provides functionality for file operations, reading/writing to files/streams and operations on strings.

.. _Modelica standard library: http://modelica.github.io/Modelica/

ThermoSysPro
^^^^^^^^^^^^
ThermoSysPro_ is an EDF library that provides common components for the static and dynamic modelling of nuclear, thermal and solar power power plants, and energy conversion systems.

It has models of combustion chambers, boilers, heat exchangers and machines.  It also has models for `molten salt <https://build.openmodelica.org/Documentation/ThermoSysPro.Properties.MoltenSalt.html>`_ and a `solar collector <https://build.openmodelica.org/Documentation/ThermoSysPro.Solar.SolarCollector.html>`_.  There is a paper from SolarPACES 2013 on using this library for modelling three types of solar plant by `Baligh El Hefni 2013 <http://www.sciencedirect.com/science/article/pii/S1876610214005761>`_.

It is open source, but the only access I have found to the library is from checking out the OpenModelica fork `here <https://github.com/OpenModelica/OpenModelica-testsuite/tree/master/openmodelica/uncertainties/TestModels/ThermoSysPro>`__.

.. _ThermoSysPro: http://www.eurosyslib.com/

ThermoCycle
^^^^^^^^^^^
ThermoCycle_ is unique in its ability to handle non-conventional working fluids (refridgerants, ammonia, etc).  It has a focus on organic rankine cycles and heat pumps.  The connectors used are compatible with the Modelica standard library.  It uses the external library CoolProp_ in order to obtain the properties of these complex fluids, which is connected through the ExternalMedia_ interface.  The library documentation has some potentially useful tips on how to handle numerical problems.

It contains models for a couple of solar collectors and some tutorials on their website.  They have a number of `papers <http://www.thermocycle.net/publications/>`_, including one on dynamic simulation of a micro-CSP plant with storage `Ireland et al. 2014 <http://orbi.ulg.ac.be/handle/2268/169522>`_.  The publications page also contains links to a couple of repositories which might contain additional models resulting from these publications.

I have only seen mention of Dymola on the website, so it is yet to be seen whether this will work under OpenModelica.  The github link to the library is `here <https://github.com/thermocycle/Thermocycle-library>`__.

.. _ThermoCycle: http://www.thermocycle.net/

ThermoPower
^^^^^^^^^^^
ThermoPower_ is for the dynamic modelling of thermal power plants with the purpose of studying control system strategies and architectures.  It contains model a model of a gas turbine and a steam turbine.

It lists quite a number of papers including one on a solar supercritical CO2 brayton cycle by `Casella and Colonna 2011 <http://www.sco2powercyclesymposium.org/resource_center/system_modeling_control/development-of-modelica-dynamic-model-of-solar-supercritical-co2-brayton-cycle-power-plants-for-control-studies>`_.

It was developed primarily for Dymola.  It has some reporting on the test failures under OpenModelica.  The github repository is `here <https://github.com/modelica-3rdparty/ThermoPower>`__.

.. _ThermoPower: https://build.openmodelica.org/Documentation/ThermoPower.html

Buildings
^^^^^^^^^
`Buildings <http://simulationresearch.lbl.gov/modelica>`_ is used to model the thermal performance of buildings.

ReaderTMY3_
    Reads TMY3 weather data, including those supplied with EnergyPlus.  It is a block component type that provides the data on ports to which other components can connect.  An example is provided `here <https://build.openmodelica.org/Documentation/Buildings.BoundaryConditions.WeatherData.Examples.ReaderTMY3.html>`__.  This example failed on an initial test with OpenModelica.

.. _Buildings: http://simulationresearch.lbl.gov/modelica
.. _ReaderTMY3: https://build.openmodelica.org/Documentation/Buildings.BoundaryConditions.WeatherData.ReaderTMY3.html

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
