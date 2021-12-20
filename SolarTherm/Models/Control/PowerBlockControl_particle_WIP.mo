within SolarTherm.Models.Control;

model PowerBlockControl_particle_WIP
  extends SolarTherm.Icons.Control;
  parameter Modelica.SIunits.MassFlowRate m_flow_on = 1400 "Constant mass flow rate on";
  parameter Modelica.SIunits.MassFlowRate m_flow_off = 0 "Constant mass flow rate off";
  parameter Real L_on = 90 "Level of start discharge";
  parameter Real L_off = 10 "Level of stop discharge";
  parameter Real L_df_on = 99 "Level of start defocus";
  parameter Real L_df_off = 96 "Level of stop defocus";
  Boolean ramping;
  /*PB state*/
  Boolean on(start = false);
  Boolean start_up(start = false);
  Boolean ramp_down(start = false);
  discrete Modelica.SIunits.Time t_off;
  discrete Modelica.SIunits.Time t_on;
  Real time_PB_in_start_up(start = 0);
  Real time_PB_in_ramp_down(start = 0);
  //Zeb Ramping
  parameter SI.Time t_ramp_delay = 1800 "Half hour startup delay";
  //SI.Time t_ramp_start(start = 0.0) "current time of simulation when ramping starts";
  SI.Time t_ramp_up_end(start = t_ramp_delay) "current time of simulation when ramping ends";
  SI.Time t_ramp_down_end(start = t_ramp_delay) "current time of simulation when ramping ends";
  //SI.Efficiency PB_ramp_fraction;
  Modelica.Blocks.Interfaces.RealInput L_mea annotation(
    Placement(transformation(extent = {{-128, -70}, {-88, -30}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow annotation(
    Placement(transformation(extent = {{92, -20}, {132, 20}})));
  SolarTherm.Models.Control.Level2Logic defocus_logic(y(start = false), level_max = L_df_on, level_min = L_df_off) annotation(
    Placement(transformation(extent = {{-17, -10}, {17, 10}}, rotation = -90, origin = {-3.55271e-015, -51})));
  Modelica.Blocks.Interfaces.BooleanOutput defocus annotation(
    Placement(transformation(extent = {{20, -20}, {-20, 20}}, rotation = 90, origin = {0, -114})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 0, origin = {-108, 50})));
  SolarTherm.Models.Control.StartUpLogic5_particle logic(m_flow_max = m_flow_on, m_flow_startup = m_flow_on / 2, level_on = L_on, level_off = L_off, m_flow_standby = 0) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanOutput rampingout annotation(
    Placement(visible = true, transformation(origin = {115, -45}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {115, -45}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
initial equation
  pre(t_off) = 0;
  pre(t_on) = 0;
equation
  when logic.m_flow > 1e-3 then
    on = true;
  elsewhen logic.m_flow <= 1e-3 then
    on = false;
  end when;
/*When on or off note down the time*/
  when on then
    t_on = time;
    t_ramp_up_end = t_on + t_ramp_delay;
  end when;
  when on == false then
    t_off = time;
    t_ramp_down_end = t_off + t_ramp_delay;
  end when;
  if on then
    if time > t_on and time < t_ramp_up_end then
      start_up = true;
    else
      start_up = false;
    end if;
    ramp_down = false;
  else
    if time > t_off and time < t_ramp_down_end then
      ramp_down = true;
    else
      ramp_down = false;
    end if;
    start_up = false;
  end if;
/*
     FIXME: If no mass flow during RD or SU (ramp down or start up) the start-up time has to be carried over
  */
  if on then
    if start_up then
      ramping = true;
/*If there are enough particles in the tank then start-up*/
      if logic.m_flow > 0 then
        m_flow = min(logic.m_flow_startup, logic.m_flow);
/*Don't start-up --> Should we include a penalty here??*/
      else
        m_flow = 0;
      end if;
    else
      ramping = false;
      m_flow = logic.m_flow;
    end if;
  else
    if ramp_down then
      ramping = true;
/*If there are enough particles in the tank then ramp_down*/
      if logic.m_flow > 0 then
        m_flow = min(logic.m_flow_startup, logic.m_flow);
/*Don't ramp-down --> Should we include a penalty here??*/
      else
        m_flow = 0;
      end if;
    else
      ramping = false;
      m_flow = 0;
    end if;
  end if;
  if start_up then
    der(time_PB_in_start_up) = 1;
  else
    der(time_PB_in_start_up) = 0;
  end if;
  if ramp_down then
    der(time_PB_in_ramp_down) = 1;
  else
    der(time_PB_in_ramp_down) = 0;
  end if;
  connect(rampingout, ramping);
  connect(defocus_logic.level_ref, L_mea) annotation(
    Line(points = {{-4.44089e-016, -34}, {0, -34}, {0, -20}, {-38, -20}, {-38, -50}, {-108, -50}}, color = {0, 0, 127}));
  connect(defocus_logic.y, defocus) annotation(
    Line(points = {{-2.22045e-015, -69.36}, {-2.22045e-015, -69.36}, {-2.22045e-015, -82}, {0, -82}, {0, -114}}, color = {255, 0, 255}));
  connect(logic.level, L_mea) annotation(
    Line(points = {{-10.8, 0}, {-38, 0}, {-38, -50}, {-64, -50}, {-64, -50}, {-108, -50}, {-108, -50}}, color = {0, 0, 127}));
  connect(logic.m_flow_in, m_flow_in) annotation(
    Line(points = {{0, 10.4}, {0, 50}, {0, 50}, {-108, 50}}, color = {0, 0, 127}));
//  connect(logic.m_flow, m_flow)
//    annotation (Line(points={{11,0},{52,0},{112,0}}, color={0,0,127}));
//PB_ramp_fraction = 1;
//PB_ramp_fraction = min(1.0, (time - t_ramp_start) / (t_ramp_end - t_ramp_start));
//ramping = if PB_ramp_fraction < 0.99 then true else false;
//Ramp fraction cannot exceed 1;
//if ramping == true then
//    m_flow = logic.m_flow_standby;
//else
//    m_flow = logic.m_flow;
// end if;
//End Zeb Ramping
  annotation(
    Documentation(revisions = "<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end PowerBlockControl_particle_WIP;