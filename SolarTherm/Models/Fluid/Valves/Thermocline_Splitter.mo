within SolarTherm.Models.Fluid.Valves;
model Thermocline_Splitter
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true);
  Modelica.Fluid.Interfaces.FluidPort_a fluid_c(redeclare package Medium =
        Medium) annotation (Placement(visible = true,transformation(extent = {{-10, 0}, {10, 20}}, rotation = 0),
        iconTransformation(origin = {0, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium =
        Medium) annotation (Placement(visible = true,transformation(extent = {{-60, 60}, {-40, 80}}, rotation = 0),
        iconTransformation(origin = {-80, 80}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium =
        Medium) annotation (Placement(visible = true,transformation(extent = {{40, 60}, {60, 80}}, rotation = 0),
        iconTransformation(origin = {80, 80}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));


equation

  fluid_b.p = fluid_a.p;
  fluid_c.p = fluid_a.p;
  fluid_a.m_flow + fluid_b.m_flow + fluid_c.m_flow = 0.0;
  if fluid_a.m_flow + fluid_b.m_flow < -1e-6 then //a and c are merging into block
    fluid_b.h_outflow = (fluid_a.m_flow*inStream(fluid_a.h_outflow) + fluid_c.m_flow*inStream(fluid_c.h_outflow))/(fluid_a.m_flow+fluid_c.m_flow);
    fluid_a.h_outflow = inStream(fluid_a.h_outflow);
    fluid_c.h_outflow = inStream(fluid_c.h_outflow);
  elseif fluid_a.m_flow + fluid_b.m_flow > 1e-6 then //a splits into b and c
    fluid_c.h_outflow = inStream(fluid_a.h_outflow);
    fluid_b.h_outflow = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = inStream(fluid_a.h_outflow);
  else
    fluid_a.h_outflow = inStream(fluid_b.h_outflow);
    fluid_b.h_outflow = inStream(fluid_a.h_outflow);
    fluid_c.h_outflow = inStream(fluid_c.h_outflow);
  end if;
  
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,0},
            {100,100}})),              Icon(coordinateSystem(extent = {{-100, 0}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1), graphics = {Line(origin = {-40.0259, 80.013}, points = {{-40, 0}, {40, 0}, {120, 0}}, thickness = 1), Line(origin = {0, 40}, points = {{0, 40}, {0, -20}, {0, -40}}, thickness = 1), Polygon(origin = {40, 80}, fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, points = {{-10, 10}, {-10, -10}, {10, 0}, {-10, 10}, {-10, 10}}), Polygon(origin = {-40, 80}, fillColor = {135, 135, 135}, fillPattern = FillPattern.Solid, points = {{-10, 10}, {-10, -10}, {10, 0}, {-10, 10}, {-10, 10}}), Polygon(origin = {0, 43}, fillColor = {124, 124, 124}, fillPattern = FillPattern.Solid, points = {{-8, 7}, {8, 7}, {0, -7}, {-8, 7}, {-8, 7}}), Polygon(origin = {0, 59}, rotation = 180, fillColor = {124, 124, 124}, fillPattern = FillPattern.Solid, points = {{-8, 7}, {8, 7}, {0, -7}, {-8, 7}, {-8, 7}}), Line(origin = {0, 59.2254}, points = {{-12, -34}, {12, -34}, {12, 8}, {60, 8}, {60, 34}, {-60, 34}, {-60, 8}, {-12, 8}, {-12, -34}, {-12, -34}})}),
    Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end Thermocline_Splitter;