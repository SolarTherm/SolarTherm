within SolarTherm.Models.Fluid.Sources;
model FluidSink "Infinite fluid sink"
 replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  /*Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium=Medium,
    m_flow(min=0));*/
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium,
    m_flow(min=0)) annotation(
    Placement(visible = true, transformation(origin = {-100, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
 port_a.h_outflow = 0; // shouldn't flow backwards anyway
end FluidSink;