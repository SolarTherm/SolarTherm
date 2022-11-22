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

/*Parameter for controller*/
parameter Real cold_tnk_empty_lb = 5 "[CTRL] Hot tank empty trigger lower bound";
parameter Real cold_tnk_empty_ub = 10 "[CTRL] Hot tank trigger to start dispatching";

/*Parameters*/
parameter SI.Temperature T_hot_tank_target = 800 + 273.15 "Target temperature of the hot tank [K]";
parameter SI.SpecificEnthalpy h_out = Medium_Utilities.h_T(T_hot_tank_target) "Enthalpy of the pcl at outlet stream [J/kg]";

/*Sizing of the electrical heater*/
parameter SI.Power W_dumped = 1e6 "Electrical power supply at design point [W]";
parameter SI.Efficiency eta = 0.9 "Electric to thermal efficiency of the heater";
parameter SI.Power Q_heater_rating = W_dumped * eta "Thermal rating of the heater at design point [W]";

/*How deep partload operation that your electrical heater has to endure?*/
parameter Real eta_part_load = 0.5 "How deep the allowed partload operation";
parameter SI.Power W_on = if W_dumped < 1 and W_dumped >=0 then 1e10 else 0 "Minimum threshold supplied power above which the heater is on. If W_dumped == 0 then sett W_on to a very large value, else follow the calculation [W]";
SI.Power W_check(start=0);
SI.Power W_net(start=0);
SI.Power W_loss(start=0);
SI.Power W_dumped_htr(start=0);

/*Fluid Connection*/
Modelica.Fluid.Interfaces.FluidPort_b particle_port_out(redeclare package Medium = Medium) annotation(
  Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

Modelica.Fluid.Interfaces.FluidPort_a particle_port_in(redeclare package Medium = Medium) annotation(
  Placement(visible = true, transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  
/*Real connection*/
Modelica.Blocks.Interfaces.RealInput W_electric annotation(
    Placement(visible = true, transformation(origin = {-23, 47}, extent = {{-9, -9}, {9, 9}}, rotation = -90), iconTransformation(origin = {-23, 47}, extent = {{-9, -9}, {9, 9}}, rotation = -90)));
Modelica.Blocks.Interfaces.RealInput L annotation(
    Placement(visible = true, transformation(origin = {29, 49}, extent = {{-9, -9}, {9, 9}}, rotation = -90), iconTransformation(origin = {25, 47}, extent = {{-9, -9}, {9, 9}}, rotation = -90)));

/*Control*/
Boolean on "State of operation of the heater based on W_electric";
Boolean on_discharge "Can we draw particle from Cold Tank?";

/*Variables*/
SI.SpecificEnthalpy h_in "Inlet enthalpy (given by fluid connection)";
SI.MassFlowRate mdot_pcl "Mass flow rate of the particle being drawn from the cold tank [kg/s]";
SI.Energy E_dumped_electricity(start=0) "Electricity dumped by the system. Happens when no heater but over producing electricity";
SI.Mass M_pcl_heater_PB "Mass of particle generated from PB elec";
SI.Mass M_pcl_heater_PV "Mass of particle generated from PV elec";

Modelica.Blocks.Interfaces.RealOutput mdot_heater annotation(
    Placement(visible = true, transformation(origin = {6, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {2, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
Modelica.Blocks.Interfaces.RealInput W_PB annotation(
    Placement(visible = true, transformation(origin = {49, 53}, extent = {{-11, -11}, {11, 11}}, rotation = -90), iconTransformation(origin = {46, 48}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
Modelica.Blocks.Interfaces.RealInput W_PV annotation(
    Placement(visible = true, transformation(origin = {65, 53}, extent = {{-11, -11}, {11, 11}}, rotation = -90), iconTransformation(origin = {70, 48}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
initial equation
on_discharge = L > cold_tnk_empty_ub;

equation

/*Fluid connection equations*/
//particle_port_in.p = particle_port_out.p "Pressure balance"; --> need not to have this EQ since it already has one more equation (mass flow)
particle_port_in.m_flow + particle_port_out.m_flow = 0 "Mass flow balance";
particle_port_in.h_outflow = inStream(particle_port_out.h_outflow);
particle_port_out.h_outflow = h_out "outlet port's h_outflow will always be at T = T_hot_tank_target";
particle_port_in.m_flow = mdot_pcl;

when L > cold_tnk_empty_ub then
    on_discharge = true;
elsewhen L < cold_tnk_empty_lb then
    on_discharge = false;
end when;


on = W_electric > W_on and on_discharge;

h_in = inStream(particle_port_in.h_outflow);

if on then
    W_net = W_electric * eta;
    W_loss = W_electric * (1-eta);
    mdot_pcl = W_net / (h_out-h_in);
    der(M_pcl_heater_PB) = W_PB * eta / (h_out-h_in);
    der(M_pcl_heater_PV) = W_PV * eta / (h_out-h_in);
else
    W_net = 0;
    W_loss = 0;
    mdot_pcl = 0;
    der(M_pcl_heater_PB) = 0;
    der(M_pcl_heater_PV) = 0;
end if;

W_dumped_htr = W_electric - W_net - W_loss;
der(E_dumped_electricity) = W_dumped_htr;
mdot_heater = mdot_pcl "signal to PB controller";
W_check = W_electric - W_net - W_loss - W_dumped_htr;




annotation(
    Diagram(graphics = {Rectangle(origin = {0, 9}, extent = {{-70, 33}, {70, -33}}), Text(origin = {1, 8}, extent = {{-37, 12}, {37, -12}}, textString = "Electrical Heater", fontSize = 26), Line(origin = {0, 20}, points = {{-70, 0}, {70, 0}}), Line(origin = {0, -4}, points = {{-70, 0}, {70, 0}})}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {0, 2}, lineThickness = 1, extent = {{-70, 38}, {70, -38}}), Line(origin = {0, 20}, points = {{-70, 0}, {70, 0}}, pattern = LinePattern.Dash, thickness = 1), Line(origin = {0, -20}, points = {{-70, 0}, {70, 0}}, pattern = LinePattern.Dash, thickness = 1), Text(origin = {1, -1}, extent = {{-57, 15}, {57, -15}}, textString = "Simple Electrical Heater")}, coordinateSystem(initialScale = 0.1)));
end SimpleElectricalHeater;