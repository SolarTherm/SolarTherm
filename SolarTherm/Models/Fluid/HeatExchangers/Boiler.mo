within SolarTherm.Models.Fluid.HeatExchangers;
model Boiler
  import Modelica.SIunits.Conversions.*;
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;
  parameter Modelica.SIunits.Temperature T_cold_set = from_degC(290);
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  parameter Modelica.SIunits.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";  

  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(visible = true,transformation(extent={{-110,-12},{-90,8}},  rotation=
           0), iconTransformation(extent = {{-10, 90}, {10, 110}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium =
        Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(visible = true,transformation(extent={{110,-10},{90,10}}, rotation=0), iconTransformation(extent = {{10, -112}, {-10, -92}}, rotation = 0)));

  Modelica.SIunits.HeatFlowRate Q_flow;
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpAux(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(nPorts = 1, redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_cold_set, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_hot(y = m_flow) annotation(
    Placement(visible = true, transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.SIunits.MassFlowRate m_flow;
equation
  Q_flow = m_flow*(inStream(fluid_a.h_outflow) - h_cold_set);
  connect(sink.ports[1], fluid_a) annotation(
    Line(points = {{-60, 0}, {-100, 0}, {-100, -2}}, color = {0, 127, 255}));
  connect(pumpAux.fluid_b, fluid_b) annotation(
    Line(points = {{60, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(source.ports[1], pumpAux.fluid_a) annotation(
    Line(points = {{14, 0}, {40, 0}}, color = {0, 127, 255}));
  connect(m_hot.y, pumpAux.m_flow) annotation(
    Line(points = {{41, 40}, {50, 40}, {50, 8}}, color = {0, 0, 127}));
annotation(
    Icon(graphics = {Text(origin = {0, -6}, lineColor = {0, 0, 255}, extent = {{-149, -114}, {151, -154}}, textString = "%name"),
    Rectangle(fillColor = {135, 135, 135}, fillPattern = FillPattern.Backward, extent = {{-100, 64}, {100, -64}}),
        Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -44}, {100, 44}}),
        Rectangle(fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -44}, {100, 44}}),
        Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{18, 0}, {48, -29}}),
        Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-1, 29}, {29, 0}}),
        Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{43, 31}, {73, 2}}),
        Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-31, 1}, {-1, -28}}),
        Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{50, 15}, {80, -14}}),
        Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-72, 25}, {-42, -4}}),
        Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{71, -11}, {101, -40}}),
        Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{72, 28}, {102, -1}}),
        Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{71, 40}, {101, 11}}),
        Line(points={{0,-64},{0,-100}}, color={0,127,255}),
        Line(origin = {-40, 0},points={{40,100},{40,64}}, color={0,127,255}),
        Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{58, -11}, {88, -40}}),
        Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{71, 1}, {101, -28}})}));
end Boiler;