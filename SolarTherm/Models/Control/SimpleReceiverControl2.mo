within SolarTherm.Models.Control;
model SimpleReceiverControl2
  extends Icons.Control;
  //Batch controller parameter
  parameter SI.Frequency f_mtr_max = 60;
  parameter Real poles = 2;
  parameter Real safety_factor = 2;
  parameter SI.AngularVelocity omega_max_mtr = 120 * f_mtr_max / 2 * 0.104719755 "converting RPM to rad/s";
  parameter SI.Length H_hopper = 20;
  parameter SI.Length H_tower = 200;
  parameter SI.Length H_total = H_hopper+H_tower;
  parameter SI.Length d_hopper = 20;
  parameter SI.Length d_gear = 1;
  parameter SI.Density rho_particle = 3300;
  parameter SI.MassFlowRate m_flow_fac = 2000 "receiver design mass flow rate";
  parameter Real packing_factor = 0.7;
  parameter SI.Temperature T_ref=from_degC(800) "Setpoint of temperature";
  parameter Real on_level = 50;
  parameter Real L_mea_hopper_upper_bound = 95;
  parameter Real L_mea_tank_upper_bound = 30;
  parameter Real L_mea_tank_lower_bound = 10;
  parameter SI.Time pouring_time = 20;
  parameter SI.Time t_sk = 1800;
  
  parameter Real L_on = 30 "Level of start discharge";
  parameter Real L_off=10 "Level of stop discharge";
  parameter Real L_df_on=99 "Level of start defocus";
  parameter Real L_df_off=96 "Level of stop defocus";
  parameter Real eta_rec_th_des = 0.856;
  
    
  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
        
  Modelica.Blocks.Interfaces.BooleanOutput defocus annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,-114})));
    
    
  SolarTherm.Models.Control.Level2Logic defocusLogic (
    y(start=false),
    level_max=L_df_off,
    level_min=L_df_on
    ) 
   annotation(Placement(visible = true, transformation(origin = {0, -58}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
   
  Modelica.Blocks.Interfaces.RealOutput m_flow annotation(
    Placement(visible = true, transformation(extent = {{94, -18}, {130, 18}}, rotation = 0), iconTransformation(extent = {{94, -18}, {130, 18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput L_mea_hopper annotation(
    Placement(visible = true, transformation(origin = {-110, 62}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 62}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  SolarTherm.Models.Control.PulseController pulseController(on_level=on_level,L_mea_hopper_upper_bound=L_mea_hopper_upper_bound,L_mea_tank_lower_bound=L_mea_tank_lower_bound,L_mea_tank_upper_bound=L_mea_tank_upper_bound,pouring_time=pouring_time,t_sk=t_sk,m_flow_fac=m_flow_fac) annotation(
    Placement(visible = true, transformation(origin = {-1, 55}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
equation
  connect(L_mea, defocusLogic.level_ref) annotation(
    Line(points = {{-108, 0}, {-88, 0}, {-88, -26}, {0, -26}, {0, -48}}, color = {0, 0, 127}));
  connect(L_mea_hopper, pulseController.L_mea_hopper) annotation(
    Line(points = {{-110, 62}, {-38, 62}, {-38, 62}, {-38, 62}}, color = {0, 0, 127}));
  connect(L_mea, pulseController.L_mea_tank) annotation(
    Line(points = {{-108, 0}, {-88, 0}, {-88, 52}, {-38, 52}, {-38, 52}}, color = {0, 0, 127}));
  connect(pulseController.mass_flow_batch, m_flow) annotation(
    Line(points = {{38, 56}, {70, 56}, {70, 0}, {112, 0}, {112, 0}}, color = {0, 0, 127}));
  connect(defocusLogic.y, defocus) annotation(
    Line(points = {{0, -69}, {0, -114}}, color = {255, 0, 255}));
protected
  annotation (Documentation(revisions = "<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"),
    Diagram);
end SimpleReceiverControl2;