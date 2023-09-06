within SolarTherm.Models.Fluid.Sources;
model FluidSink_Valve "Infinite fluid sink"
 replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
 Modelica.Fluid.Interfaces.FluidPort_a port_a(
  redeclare package Medium=Medium,
  m_flow(min=0))     annotation (Placement(visible = true,transformation(extent={{-110,-12},{-90,8}},  rotation=
           0), iconTransformation(origin = {-100, 8.88178e-16}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
 Modelica.Blocks.Interfaces.BooleanInput shut annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-38, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));  
  //Medium.BaseProperties Fluid "Fluid state calculator";
equation
  //Fluid.h = inStream(port_a.h_outflow);
  //Fluid.p = port_a.p;
 port_a.h_outflow = inStream(port_a.h_outflow);//0; // shouldn't flow backwards anyway
 if shut == true then
  port_a.m_flow = 0.0;
 end if;
annotation(
    Icon(graphics = {Rectangle(origin = {0, -1}, extent = {{6, 19}, {76, -17}}), Text(origin = {39, 0}, extent = {{-23, 16}, {23, -16}}, textString = "Sink"), Line(origin = {-44, 0}, points = {{-50, 0}, {50, 0}}), Polygon(origin = {-30, 0}, fillColor = {130, 130, 130}, fillPattern = FillPattern.Solid, points = {{-8, 0}, {8, 14}, {8, -14}, {-8, 0}}), Polygon(origin = {-62, 0}, fillColor = {130, 130, 130}, fillPattern = FillPattern.Solid, points = {{24, 0}, {8, 14}, {8, -14}, {24, 0}}), Text(origin = {-44, -20}, extent = {{-8, 2}, {22, -14}}, textString = "shut")}, coordinateSystem(initialScale = 0.1)));
end FluidSink_Valve;