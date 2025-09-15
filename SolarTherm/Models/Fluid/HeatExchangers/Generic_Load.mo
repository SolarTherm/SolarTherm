within SolarTherm.Models.Fluid.HeatExchangers;

model Generic_Load//Simplify Boiler
import SI = Modelica.SIunits;
import Modelica.SIunits.Conversions.*;
  replaceable package Medium = SolarTherm.Media.Air.Air_amb_p;
  //parameter Modelica.SIunits.HeatFlowRate Q_flow_ref=50e6 "Design thermal power";
  parameter Modelica.SIunits.Temperature T_cold_des = from_degC(290);
  parameter Modelica.SIunits.Temperature T_hot_des = from_degC(565);
  final parameter Medium.ThermodynamicState state_cold_des = Medium.setState_pTX(p_des, T_cold_des) "Cold fluid thermodynamic state at design";
  final parameter Medium.ThermodynamicState state_hot_des = Medium.setState_pTX(p_des, T_hot_des) "Cold fluid thermodynamic state at design";
  final parameter Modelica.SIunits.SpecificEnthalpy h_cold_des = Medium.specificEnthalpy(state_cold_des) "Cold fluid specific enthalpy at design";  
  final parameter Modelica.SIunits.SpecificEnthalpy h_hot_des = Medium.specificEnthalpy(state_hot_des) "Cold fluid specific enthalpy at design";
  //final parameter SI.MassFlowRate m_flow_ref = Q_flow_ref / (h_hot_set - h_cold_set) "Mass flow rate at design";
  //final parameter Real nu_eps=1e-3 "Minimum load";
  //parameter Real nu_min=1e-3 "Minimum turbine operation";
  parameter SI.Pressure p_des = 101325.0 "Design pressure of inlet fluid (Pa)";
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(visible = true,transformation(extent={{-110,-12},{-90,8}},  rotation=
           0), iconTransformation(extent = {{-110, 70}, {-90, 90}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium =
        Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(visible = true,transformation(extent={{110,-10},{90,10}}, rotation=0), iconTransformation(extent = {{-90, -90}, {-110, -70}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealOutput h_out_signal "outlet specific enthalpy" annotation (Placement(visible = true, transformation(origin = {-80, -72}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {-80, -108}, extent = {{8, -8}, {-8, 8}}, rotation = 90))) ;

  //Real load;
  //Boolean logic;
  Medium.BaseProperties state_in;
  Medium.BaseProperties state_out;
  SI.HeatFlowRate Q_flow;
  SI.Energy E_thermal(start=0.0);
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;

equation
  state_in.h = h_in;

  state_in.p = p_des;
  
  state_out.h = h_out;
  state_out.p = p_des;
  //load=max(nu_eps,fluid_a4.00.m_flow/m_flow_ref);
  //logic=load>nu_min;
  h_in=inStream(fluid_a.h_outflow);
  h_out=h_cold_des;
  h_out_signal=h_cold_des;
  
  if fluid_a.m_flow > 1.0e-6 then
    Q_flow = (h_in-h_out)*fluid_a.m_flow;
  else
    Q_flow = 0.0;
  end if;
  
  fluid_b.h_outflow = h_cold_des;
  fluid_a.h_outflow = h_in;
  
  fluid_a.m_flow + fluid_b.m_flow = 0.0;
  fluid_a.p=fluid_b.p;
  
  der(E_thermal)=Q_flow;
  annotation(
    Icon(graphics = {Text(origin = {-2, 4}, lineColor = {0, 0, 255}, extent = {{-149, -114}, {151, -154}}, textString = "%name"), Ellipse(origin = {56, 0}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-72, 25}, {-42, -4}}, endAngle = 360), Ellipse(origin = {63.96, 64.23}, lineThickness = 1, extent = {{-15.96, 15.77}, {15.96, -15.77}}, endAngle = 360), Ellipse(origin = {-18.04, 32.23}, lineThickness = 1, extent = {{-15.96, 15.77}, {15.96, -15.77}}, endAngle = 360), Ellipse(origin = {63.96, 0.23}, lineThickness = 1, extent = {{-15.96, 15.77}, {15.96, -15.77}}, endAngle = 360), Ellipse(origin = {-18.04, -31.77}, lineThickness = 1, extent = {{-15.96, 15.77}, {15.96, -15.77}}, endAngle = 360), Ellipse(origin = {63.96, -63.77}, lineThickness = 1, extent = {{-15.96, 15.77}, {15.96, -15.77}}, endAngle = 360), Rectangle(origin = {21, 87}, lineColor = {238, 238, 236}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{19, 7}, {-19, -7}}), Rectangle(origin = {23, 1}, lineColor = {238, 238, 236}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{41, 89}, {-41, -89}}), Line(origin = {35.5772, 80}, points = {{28, 0}, {-136, 0}}, thickness = 1), Line(origin = {36, -80}, points = {{28, 0}, {-136, 0}}, thickness = 1), Rectangle(origin = {12, -91.9565}, lineColor = {238, 238, 236}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{16, 6.45652}, {-16, -7.04348}}), Line(origin = {35.5772, 48}, points = {{28, 0}, {-54, 0}}, thickness = 1), Line(origin = {35.5772, 16}, points = {{28, 0}, {-54, 0}}, thickness = 1), Line(origin = {36.1565, -15.7293}, points = {{28, 0}, {-54, 0}}, thickness = 1), Line(origin = {35.47, -47.5}, points = {{28, 0}, {-54, 0}}, thickness = 1)}, coordinateSystem(initialScale = 0.1)));
end Generic_Load;