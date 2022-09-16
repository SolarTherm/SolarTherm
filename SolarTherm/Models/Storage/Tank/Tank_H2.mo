within SolarTherm.Models.Storage.Tank;

model Tank_H2
  /*Simple Hydrogen Tank*/
  import SI = Modelica.SIunits;
  
  parameter Real LHV_H2 = 120e6 "Lower heating value of the H2 in J/kg. https://www.engineeringtoolbox.com/fuels-higher-calorific-values-d_169.html
  10.8 MJ/m3 with density 0.09 kg/m3";
  parameter SI.Energy E_tank_capacity = 0.4606 * 3600 * 10 * LHV_H2 "Tank energy capacity in Joule";
  parameter Real H2_demand = 5 "demand of H2 in kg/s";
  
  parameter Real L_start = 3 "Level of the tank in % at the start";
  parameter Real h2_tnk_empty_lb = 5 "[CTRL] Hot tank empty trigger lower bound";
  parameter Real h2_tnk_empty_ub = 10 "[CTRL] Hot tank trigger to start dispatching";
  parameter Real h2_tnk_full_lb = 93 "[CTRL] Hot tank full trigger lower bound";
  parameter Real h2_tnk_full_ub = 95 "[CTRL] Hot tank full trigger upper bound";
  
  Real L_tank(start=L_start);
  SI.Energy E_tank(start=L_start/100 * E_tank_capacity);
  Boolean on_discharge;
  Boolean on_charge;
  
  
  /*Connections*/
  Modelica.Blocks.Interfaces.RealInput H2_in annotation(
  Placement(visible = true, transformation(origin = {-108, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-108, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput H2_out annotation(
    Placement(visible = true, transformation(origin = {106, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {0, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 108},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput L annotation(
    Placement(visible = true, transformation(origin = {108, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput charging annotation(
    Placement(visible = true, transformation(origin = {102, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput discharging annotation(
    Placement(visible = true, transformation(origin = {104, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput on_discharge_TES annotation(
    Placement(visible = true, transformation(origin = {56, 104}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {56, 104}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
initial equation
  on_discharge = L_tank > h2_tnk_empty_ub;
  on_charge = L_tank < h2_tnk_full_ub;
equation
  when L_tank > h2_tnk_empty_ub then
    on_discharge = true;
  elsewhen L_tank < h2_tnk_empty_lb then
    on_discharge = false;
  end when;
 
  when L_tank > h2_tnk_full_ub then
    on_charge = false;
  elsewhen L_tank < h2_tnk_full_lb then
    on_charge = true;
  end when;
  
  charging = on_charge; discharging = on_discharge and on_discharge_TES;
  
  H2_out = if discharging then H2_demand else 0;  
  
  der(E_tank) = H2_in * LHV_H2 - H2_out * LHV_H2 "dE/dt of the H2 tank";
  L_tank = E_tank/E_tank_capacity *100 "Level of the tank";
  L = L_tank "Signal out of the level of the tank";

annotation(
    Icon(graphics = {Rectangle(origin = {-8, 16}, extent = {{-92, 84}, {108, -116}}), Text(origin = {-68, 24}, extent = {{-2, 2}, {144, -66}}, textString = "Tank H2 Simple")}, coordinateSystem(initialScale = 0.1)));
end Tank_H2;