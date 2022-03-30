within SolarTherm.Models.UtilitiesComponent;

model SimpleElectricalHeater
/*
  Simple electrical heater using constant efficiency value
*/

import SI = Modelica.SIunits;
import CN = Modelica.Constants;

/*HTF properties*/
replaceable package Medium_Utilities = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph;

/*Parameters*/
parameter SI.Temperature T_hot_tank_target = 800 + 273.15 "Target temperature of the hot tank [K]";
parameter SI.SpecificEnthalpy h_out = Medium_Utilities.h_T(T_hot_tank_target) "Enthalpy of the pcl at outlet stream [J/kg]";

/*Sizing of the electrical heater*/
parameter SI.Power W_dumped = 1e6 "Electrical power supply at design point [W]";
parameter SI.Efficiency eta = 0.9 "Electric to thermal efficiency of the heater";
parameter SI.Power Q_heater_rating = W_dumped * eta "Thermal rating of the heater at design point [W]";

/*Fluid Connection*/
Modelica.Fluid.Interfaces.FluidPort_b particle_port_out(redeclare package Medium = Medium) annotation(
  Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

Modelica.Fluid.Interfaces.FluidPort_a particle_port_in(redeclare package Medium = Medium) annotation(
  Placement(visible = true, transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  
/*Real connection*/
Modelica.Blocks.Interfaces.RealInput W_electric annotation(
    Placement(visible = true, transformation(origin = {-1, 49}, extent = {{-9, -9}, {9, 9}}, rotation = -90), iconTransformation(origin = {-1, 49}, extent = {{-9, -9}, {9, 9}}, rotation = -90)));

/*Control*/
Boolean on "State of operation of the heater based on W_electric";

/*Variables*/
SI.SpecificEnthalpy h_in "Inlet enthalpy (given by fluid connection)";
SI.MassFlowRate mdot_pcl "Mass flow rate of the particle being drawn from the cold tank [kg/s]";

equation

/*Fluid connection equations*/
particle_port_in.p = particle_port_out.p "Pressure balance";
particle_port_in.m_flow + particle_port_out.m_flow = 0 "Mass flow balance";
particle_port_in.h_outflow = inStream(particle_port_out.h_outflow);
particle_port_out.h_outflow = h_out "outlet port's h_outflow will always be at T = T_hot_tank_target";
particle_port_in.m_flow = mdot_pcl;

on = W_electric > 100;

h_in = inStream(particle_port_in.h_outflow);

if on then
    mdot_pcl = W_electric * eta / (h_out-h_in);
else
    mdot_pcl = 0;
end if;






annotation(
    Diagram(graphics = {Rectangle(origin = {0, 9}, extent = {{-70, 33}, {70, -33}}), Text(origin = {1, 8}, extent = {{-37, 12}, {37, -12}}, textString = "Electrical Heater", fontSize = 26), Line(origin = {0, 20}, points = {{-70, 0}, {70, 0}}), Line(origin = {0, -4}, points = {{-70, 0}, {70, 0}})}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {0, 2}, lineThickness = 1, extent = {{-70, 38}, {70, -38}}), Line(origin = {0, 20}, points = {{-70, 0}, {70, 0}}, pattern = LinePattern.Dash, thickness = 1), Line(origin = {0, -20}, points = {{-70, 0}, {70, 0}}, pattern = LinePattern.Dash, thickness = 1), Text(origin = {1, -1}, extent = {{-57, 15}, {57, -15}}, textString = "Simple Electrical Heater")}));
end SimpleElectricalHeater;