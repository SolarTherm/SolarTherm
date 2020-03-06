within SolarTherm.Models.Control;

model pulse_modified
  parameter SI.Time width = 20;
  parameter SI.Time period = 1800;
  parameter Modelica.SIunits.Time startTime = 0 "Time instant of first pulse";
  parameter Real on_level = 70;
  parameter Real L_mea_tank_lower_bound = 10;
  parameter Real L_mea_hopper_upper_bound = 95;
  parameter Real L_mea_tank_upper_bound = 30;
  Real i (start=0);
  //discrete SI.Time start;
  SI.Time check;
  Boolean on;
  extends Modelica.Blocks.Interfaces.partialBooleanSource;
  Modelica.Blocks.Interfaces.RealInput L_mea_hopper annotation(
    Placement(visible = true, transformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput L_mea_tank annotation(
    Placement(visible = true, transformation(origin = {-120, -56}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -56}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  
 algorithm
 when L_mea_hopper < on_level and L_mea_tank > L_mea_tank_lower_bound then
    on := true "start the lift!";
  elsewhen L_mea_hopper > L_mea_hopper_upper_bound or L_mea_tank < L_mea_tank_upper_bound then
    on := false "stop the lift when hopper is full or tank is not enough";
  end when;
  if on == true then
    check := rem(pre(i),period);
    if check >= 0 and check < width then
      y := true;
    elseif check >= width and check<period then 
      y:= false;
    end if;
    i := pre(i) + 1;
  else  
    y:=false;
    i:=0;
  end if;
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end pulse_modified;