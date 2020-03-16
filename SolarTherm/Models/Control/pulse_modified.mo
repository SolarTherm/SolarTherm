within SolarTherm.Models.Control;

model pulse_modified
  parameter SI.Time width = 20;
  parameter SI.Time period = 1800;
  parameter SI.Time filling_time = 20;
  parameter Real on_level = 70;
  parameter Real L_mea_tank_lower_bound = 10;
  parameter Real L_mea_hopper_upper_bound = 95;
  parameter Real L_mea_tank_upper_bound = 30;
  //Real start(start=0);
  //discrete SI.Time start;

  Modelica.Blocks.Interfaces.RealInput L_mea_hopper annotation(
    Placement(visible = true, transformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput L_mea_tank annotation(
    Placement(visible = true, transformation(origin = {-120, -56}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -56}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 
 
protected
  Real check;
  Real abc (start=0, nominal =0);
  Real intermediate_y;
  Boolean on;
  Modelica.Blocks.Interfaces.BooleanOutput y annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  when L_mea_hopper < on_level and L_mea_tank > L_mea_tank_upper_bound then
    on = true "start the lift!";
  elsewhen L_mea_hopper >= L_mea_hopper_upper_bound or L_mea_tank < L_mea_tank_lower_bound then
    on = false "stop the lift when hopper is full or tank is not enough";
  end when;
  
  if on == true then
    der(abc) = 1;
    check = rem(abc,period+width+filling_time);
    if check >= 0 and check < width then
      intermediate_y=1;
    else  
      intermediate_y=0;
    end if;
  else
    der(abc) = 0;
    check = 0;
    intermediate_y =0;
  end if;
  
  if intermediate_y == 1 then
    y=true;
  else
    y=false;
  end if;
  annotation(
    experiment(StartTime = 0, StopTime = 2000, Tolerance = 1e-06, Interval = 0.002));
end pulse_modified;