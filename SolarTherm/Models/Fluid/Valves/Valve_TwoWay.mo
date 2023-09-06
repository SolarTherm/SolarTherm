within SolarTherm.Models.Fluid.Valves;
model Valve_TwoWay
  import SI = Modelica.SIunits;
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true);
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium =
        Medium) annotation (Placement(visible = true,transformation(extent = {{-60, 60}, {-40, 80}}, rotation = 0),
        iconTransformation(origin = {-80, 50}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium =
        Medium) annotation (Placement(visible = true,transformation(extent = {{40, 60}, {60, 80}}, rotation = 0),
        iconTransformation(origin = {80, 50}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput open annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-2, 60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));  
  SI.MassFlowRate m_flow;
algorithm
  
equation
  fluid_a.m_flow + fluid_b.m_flow = 0.0;
  //m_flow = fluid_a.m_flow;
  
  m_flow = if open then fluid_a.m_flow else 0.0;
    
  //Pressure Equality
  fluid_b.p = fluid_a.p;

  fluid_a.h_outflow = inStream(fluid_b.h_outflow);
  fluid_b.h_outflow = inStream(fluid_a.h_outflow);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,0},
            {100,100}})),              Icon(coordinateSystem(extent = {{-100, 0}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1), graphics = {Line(origin = {-40.0259, 50.013}, points = {{-40, 0}, {40, 0}, {120, 0}}, thickness = 1), Polygon(origin = {-12, 50}, fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, points = {{-10, 10}, {-10, -10}, {10, 0}, {-10, 10}, {-10, 10}}),  Polygon(origin = {28, 50}, fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, points = {{-10, 10}, {-10, -10}, {-30, 0}, {-10, 10}, {-10, 10}})}),
    Documentation(revisions ="<html>
		<p>By Zebedee Kee on 03/12/2020</p>
		</html>",info="<html>
		<p>This component is a pipe teejunction where fluid_a is always an inlet and fluid_b is always an outlet. Fluid_c however can flow two-ways therefore depending on the relative flow rates of fluid_a and fluid_b, outlet enthalpies of b and c are calculated.</p>
		</html>"));
end Valve_TwoWay;