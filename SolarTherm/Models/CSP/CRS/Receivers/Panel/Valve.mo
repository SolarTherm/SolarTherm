within SolarTherm.Models.CSP.CRS.Receivers.Panel;
model Valve
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true);
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b2(redeclare package Medium =
        Medium) annotation (Placement(visible = true,transformation(extent = {{-10, 0}, {10, 20}}, rotation = 0),
        iconTransformation(extent = {{-10, -70}, {10, -50}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium =
        Medium) annotation (Placement(visible = true,transformation(extent = {{-60, 60}, {-40, 80}}, rotation = 0),
        iconTransformation(extent = {{-60, -10}, {-40, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b1(redeclare package Medium =
        Medium) annotation (Placement(visible = true,transformation(extent = {{40, 60}, {60, 80}}, rotation = 0),
        iconTransformation(extent = {{40, -10}, {60, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput m_flow annotation (Placement(
        visible = true,transformation(
        
        origin={0,100},extent={{-20,-20},{20,20}},
        rotation=-90), iconTransformation(
        
        origin={0, 34},extent={{-6,-6},{6,6}},
        rotation=-90)));
equation
   fluid_a.p=fluid_b2.p;

   fluid_a.h_outflow=inStream(fluid_a.h_outflow);
   fluid_b1.h_outflow=inStream(fluid_a.h_outflow);
   fluid_b2.h_outflow=inStream(fluid_a.h_outflow);

   fluid_a.Xi_outflow=inStream(fluid_a.Xi_outflow);
   fluid_b2.Xi_outflow=inStream(fluid_a.Xi_outflow);
   fluid_b1.Xi_outflow=inStream(fluid_a.Xi_outflow);

   fluid_b1.m_flow=-(fluid_a.m_flow-m_flow);
   fluid_b2.m_flow=-m_flow;

  annotation (Diagram(coordinateSystem(preserveAspectRatio = false)),              Icon(coordinateSystem(preserveAspectRatio = false), graphics={Polygon(origin = {0, -70},fillPattern = FillPattern.Solid, points = {{50, 100}, {50, 40}, {0, 70}, {50, 100}}), Polygon(origin = {0, -70},fillPattern = FillPattern.Solid, points = {{-50, 100}, {-50, 40}, {0, 70}, {-50, 100}}), Polygon(origin = {0, -70},fillPattern = FillPattern.Solid, points = {{0, 70}, {-40, 10}, {40, 10}, {0, 70}}), Line(origin = {0, -69.6974}, points = {{0, 100}, {0, 70}})}),
    Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end Valve;
