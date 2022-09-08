within SolarTherm.Models.Storage.Tank;

model Tank_O2
  /*Simple O2 Tank -- Mass-based tank*/
  import SI = Modelica.SIunits;
  
  parameter SI.Mass M_tank_capacity = 2.073 * 3600 * 10 "Tank mass capacity";
  parameter Real O2_demand = 2.073 "demand of O2 in kg/s";
  
  parameter Real L_start = 3 "Level of the tank in % at the start";
  parameter Real o2_tnk_empty_lb = 5 "[CTRL] Hot tank empty trigger lower bound";
  parameter Real o2_tnk_empty_ub = 10 "[CTRL] Hot tank trigger to start dispatching";
  parameter Real o2_tnk_full_lb = 93 "[CTRL] Hot tank full trigger lower bound";
  parameter Real o2_tnk_full_ub = 95 "[CTRL] Hot tank full trigger upper bound";
  
  Real L_tank(start=L_start);
  SI.Mass M_tank(start=L_start/100 * M_tank_capacity);
  Boolean on_discharge;
  Boolean on_charge;
  
  
  /*Connections*/
  Modelica.Blocks.Interfaces.RealInput O2_in annotation(
  Placement(visible = true, transformation(origin = {-108, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-108, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput O2_out annotation(
    Placement(visible = true, transformation(origin = {106, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {0, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 108},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput L annotation(
    Placement(visible = true, transformation(origin = {108, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput charging annotation(
    Placement(visible = true, transformation(origin = {102, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput discharging annotation(
    Placement(visible = true, transformation(origin = {104, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
  on_discharge = L_tank > o2_tnk_empty_ub;
  on_charge = L_tank < o2_tnk_full_ub;
equation
  when L_tank > o2_tnk_empty_ub then
    on_discharge = true;
  elsewhen L_tank < o2_tnk_empty_lb then
    on_discharge = false;
  end when;
 
  when L_tank > o2_tnk_full_ub then
    on_charge = false;
  elsewhen L_tank < o2_tnk_full_lb then
    on_charge = true;
  end when;
  
  charging = on_charge; discharging = on_discharge;
  
  O2_out = if on_discharge then O2_demand else 0;  
  
  der(M_tank) = O2_in - O2_out "dM/dt of the O2 tank";
  L_tank = M_tank/M_tank_capacity *100 "Level of the tank";
  L = L_tank "Signal out of the level of the tank";

annotation(
    Icon(graphics = {Rectangle(origin = {-8, 16}, extent = {{-92, 84}, {108, -116}}), Text(origin = {-68, 24}, extent = {{-2, 2}, {144, -66}}, textString = "Tank O2 Simple")}, coordinateSystem(initialScale = 0.1)));
end Tank_O2;