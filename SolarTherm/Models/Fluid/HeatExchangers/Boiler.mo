within SolarTherm.Models.Fluid.HeatExchangers;
model Boiler//Copied from Armando's windPV-salt_TES
import Modelica.SIunits.Conversions.*;
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_ref=50e6 "Design thermal power";
  parameter Modelica.SIunits.Temperature T_cold_set = from_degC(290);
  parameter Modelica.SIunits.Temperature T_hot_set = from_degC(565);
  final parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  final parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Cold salt thermodynamic state at design";
  final parameter Modelica.SIunits.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";  
  final parameter Modelica.SIunits.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Cold salt specific enthalpy at design";  
  final parameter SI.MassFlowRate m_flow_ref = Q_flow_ref / (h_hot_set - h_cold_set) "Mass flow rate at design";
  final parameter Real nu_eps=1e-3 "Minimum load";
  parameter Real nu_min=1e-3 "Minimum turbine operation";

  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(visible = true,transformation(extent={{-110,-12},{-90,8}},  rotation=
           0), iconTransformation(extent = {{-10, 90}, {10, 110}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium =
        Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(visible = true,transformation(extent={{110,-10},{90,10}}, rotation=0), iconTransformation(extent = {{10, -112}, {-10, -92}}, rotation = 0)));

  Real load;
  Boolean logic;
  
  Modelica.SIunits.HeatFlowRate Q_flow;
  Modelica.SIunits.Energy E_thermal;
  Modelica.SIunits.SpecificEnthalpy h_in;
  Modelica.SIunits.SpecificEnthalpy h_out;
protected
  Real k_q;
equation
  load=max(nu_eps,fluid_a.m_flow/m_flow_ref);
  logic=load>nu_min;
  h_in=inStream(fluid_a.h_outflow);
  //h_out=fluid_b.h_outflow;
  fluid_b.h_outflow = h_cold_set;
  h_out=fluid_a.h_outflow;
  fluid_a.m_flow+fluid_b.m_flow=0;
  fluid_a.p=fluid_b.p;
  if logic then
    k_q=1;
    Q_flow=-fluid_a.m_flow*(h_out-h_in);
  else
    k_q=0;
    h_out=h_cold_set;
  end if;
  Q_flow/(Q_flow_ref*load)=k_q;
  Q_flow = der(E_thermal);
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