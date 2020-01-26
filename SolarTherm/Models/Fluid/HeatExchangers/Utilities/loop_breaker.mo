within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
model loop_breaker
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium, m_flow(min=0)) annotation (
  Placement(visible = true,transformation(extent={{-110, -10}, {-90, 10}},  rotation=0), iconTransformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium, m_flow(max=0)) annotation (
  Placement(visible = true,transformation(extent={{88, -10}, {110, 10}},  rotation=0), iconTransformation(extent = {{110, -10}, {90, 10}}, rotation = 0)));

equation
  port_a.h_outflow = 0; // shouldn't flow backwards anyway
  port_b.p=101325;
  port_a.p=101325;
  port_b.h_outflow=inStream(port_a.h_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);

end loop_breaker;
