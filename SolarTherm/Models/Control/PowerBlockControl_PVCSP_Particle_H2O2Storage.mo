within SolarTherm.Models.Control;
model PowerBlockControl_PVCSP_Particle_H2O2Storage
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
  parameter Real Q_HX_des = 0.2e8 "PHX thermal rating at design point[W]";
  parameter Real eta_gross_base = 0.5 "PB cycle thermal eff (after HX eff) at design point";
  
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
  SolarTherm.Models.Control.StartUpLogic5_PVCSP_particle_H2O2Storage logic(
    m_flow_max=m_flow_on,
    m_flow_startup=m_flow_on/2,
    level_on=L_on,
    level_off=L_off,
    m_flow_standby=0,
    P_net = P_net,
    CSP_name_plate = CSP_name_plate,
    Q_HX_des = Q_HX_des,
    eta_gross_base = eta_gross_base
  ) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput rampingout annotation(
    Placement(visible = true, transformation(origin = {115, -45}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {115, -45}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PV_input annotation(
    Placement(visible = true, transformation(origin = {-110, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-128, -20}, {-88, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow_HX annotation(
    Placement(visible = true, transformation(extent = {{92, 16}, {132, 56}}, rotation = 0), iconTransformation(extent = {{92, 16}, {132, 56}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_mea annotation(
    Placement(visible = true, transformation(origin = {-44, 106}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-44, 106}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amb_input annotation(
    Placement(visible = true, transformation(origin = {12, 106}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {12, 106}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput H2_tank_charging annotation(
    Placement(visible = true, transformation(origin = {56, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {56, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

  Modelica.Blocks.Interfaces.BooleanOutput on_discharge annotation(
    Placement(visible = true, transformation(origin = {112, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {112, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
  when logic.m_flow > 10 then
    t_ramp_start := time;
    t_ramp_end := time + t_ramp_delay;
  end when;
equation
  PB_ramp_fraction = min(1.0, (time - t_ramp_start) / (t_ramp_end - t_ramp_start));
  ramping = if PB_ramp_fraction < 0.99 then true else false;

  der(PB_time_spend_ramping) = if ramping then 1 else 0;
  
  m_flow = if H2_tank_charging then logic.m_flow * PB_ramp_fraction else 0;
  on_discharge = logic.on_discharge;

  connect(T_amb_input,logic.T_amb_input) "Extra connection to connect T_amb with logic.T_amb_input";
  connect(T_mea, logic.T_HTF_in) "Extra connection to connect T_mea with logic.T_HTF_in";
  connect(rampingout,ramping) "Extra connection to connect ramping with logic.ramping";
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
  connect(logic.m_flow_HX_industrial, m_flow_HX) annotation(
    Line(points = {{12, 4}, {42, 4}, {42, 36}, {112, 36}, {112, 36}}, color = {0, 0, 127}));
  annotation (Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end PowerBlockControl_PVCSP_Particle_H2O2Storage;