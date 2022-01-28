within SolarTherm.Models.Control;
model PowerBlockControl_PVCSP_Particle
  extends SolarTherm.Icons.Control;
  parameter Modelica.SIunits.MassFlowRate m_flow_on=1400
    "Constant mass flow rate on";
  parameter Modelica.SIunits.MassFlowRate m_flow_off=0
    "Constant mass flow rate off";
  parameter Real L_on=90 "Level of start discharge";
  parameter Real L_off=10 "Level of stop discharge";

  parameter Real L_df_on=99 "Level of start defocus";
  parameter Real L_df_off=96 "Level of stop defocus";
  //Boolean on;
  
  Boolean ramping;
  
  parameter Real P_net = 1e8 "Nameplate for the Hybrid System [W]";
  parameter Real CSP_name_plate = 1e8 "Nameplate of the CSP [W]";
  parameter Real PV_name_plate = 0.2e8 "Nameplate of the PV system [W]";
  
  Real PB_time_spend_ramping(start=0);
  
  //Zeb Ramping
  parameter SI.Time t_ramp_delay = 1800 "Half hour startup delay";
  SI.Time t_ramp_start(start = 0.0) "current time of simulation when ramping starts";
  SI.Time t_ramp_end(start = t_ramp_delay) "current time of simulation when ramping ends";
  SI.Efficiency PB_ramp_fraction;

  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (Placement(transformation(extent={{-128,-70},{-88,-30}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow
    annotation (Placement(transformation(extent={{92,-20},{132,20}})));
  SolarTherm.Models.Control.Level2Logic defocus_logic(
    y(start=false),
    level_max=L_df_on,
    level_min=L_df_off) annotation (Placement(transformation(
        extent={{-17,-10},{17,10}},
        rotation=-90,
        origin={-3.55271e-015,-51})));
  Modelica.Blocks.Interfaces.BooleanOutput defocus annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-114})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-108,50})));
  SolarTherm.Models.Control.StartUpLogic5_PVCSP_particle logic(
    m_flow_max=m_flow_on,
    m_flow_startup=m_flow_on/2,
    level_on=L_on,
    level_off=L_off,
    m_flow_standby=0,
    P_net = P_net,
    CSP_name_plate = CSP_name_plate,
    PV_name_plate = PV_name_plate)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput rampingout annotation(
    Placement(visible = true, transformation(origin = {115, -45}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {115, -45}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PV_input annotation(
    Placement(visible = true, transformation(origin = {-110, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-128, -20}, {-88, 20}}, rotation = 0)));
algorithm
  when logic.m_flow > 1e-6 then
    t_ramp_start := time;
    t_ramp_end := time + t_ramp_delay;
  end when;
equation
  PB_ramp_fraction = min(1.0, (time - t_ramp_start) / (t_ramp_end - t_ramp_start));
  ramping = if PB_ramp_fraction < 0.99 then true else false;

  der(PB_time_spend_ramping) = if ramping then 1 else 0;
  
  m_flow = logic.m_flow * PB_ramp_fraction;


  connect(rampingout,ramping);
  connect(defocus_logic.level_ref, L_mea) annotation (Line(points={{
          -4.44089e-016,-34},{0,-34},{0,-20},{-38,-20},{-38,-50},{-108,-50}},
        color={0,0,127}));
  connect(defocus_logic.y, defocus) annotation (Line(points={{-2.22045e-015,
          -69.36},{-2.22045e-015,-69.36},{-2.22045e-015,-82},{0,-82},{0,-114}},
        color={255,0,255}));
  connect(logic.level, L_mea) annotation (Line(points={{-10.8,0},{-38,0},{-38,
          -50},{-64,-50},{-64,-50},{-108,-50},{-108,-50}}, color={0,0,127}));
  connect(logic.m_flow_in, m_flow_in) annotation (Line(points={{0,10.4},{0,50},
          {0,50},{-108,50}}, color={0,0,127}));
  connect(logic.PV_input, PV_input) annotation(
    Line(points = {{-10, -4}, {-56, -4}, {-56, 2}, {-110, 2}, {-110, 2}}, color = {0, 0, 127}));
  annotation (Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end PowerBlockControl_PVCSP_Particle;