within SolarTherm.Models.Fluid.HeatExchangers;


model loop_breaker
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium, m_flow(min=0)) annotation (
  Placement(visible = true,transformation(extent={{-110, -10}, {-90, 10}},  rotation=0), iconTransformation(origin = {-100, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium, m_flow(max=0)) annotation (
  Placement(visible = true,transformation(extent={{88, -10}, {110, 10}},  rotation=0), iconTransformation(origin = {100, -2.22045e-16}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));

equation
  port_a.h_outflow = 0; // shouldn't flow backwards anyway
  port_b.p = port_a.p;
  port_b.h_outflow= inStream(port_a.h_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);

annotation(
    Diagram(graphics = {Rectangle(extent = {{-80, 40}, {80, -40}}), Text(origin = {2, 1}, extent = {{-46, 13}, {46, -13}}, textString = "loop breaker"), Line(origin = {-89, 0}, points = {{-9, 0}, {9, 0}, {9, 0}}), Line(origin = {90, 0}, points = {{-10, 0}, {10, 0}, {10, 0}})}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(extent = {{-80, 20}, {80, -20}}), Line(origin = {-90, 0}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {90, 0}, points = {{-10, 0}, {10, 0}, {10, 0}}), Text(origin = {-1, 9}, extent = {{-41, 9}, {41, -7}}, textString = "Lo"), Text(origin = {1, -9}, extent = {{-31, 9}, {31, -9}}, textString = "Br")}, coordinateSystem(initialScale = 0.1)));
end loop_breaker;