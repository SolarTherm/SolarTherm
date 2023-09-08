within SolarTherm.Models.Control;
model ScheduleLogic
  // Parameters
  parameter Modelica.SIunits.Time t_start = 0.5 * 3600;
  parameter Modelica.SIunits.Time t_standby = 2 * 3600;
  parameter Real m_flow_max;
  parameter Real m_flow_startup;
  parameter Real m_flow_standby;
  parameter Real level_on = 20;
  parameter Real level_off = 5;

  // Variables
  Boolean standby;
  Boolean startup(start = false, fixed = true);
  Boolean on_charge;
  Boolean on_discharge;
  discrete Modelica.SIunits.Time t_off;
  discrete Modelica.SIunits.Time t_on;

  // Blocks
  Modelica.Blocks.Interfaces.RealInput level annotation(
    Placement(visible = true, transformation(extent = {{-120, -80}, {-80, -40}}, rotation = 0), iconTransformation(extent = {{-128, -100}, {-88, -60}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow annotation(
    Placement(transformation(extent = {{90, -20}, {130, 20}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in annotation(
    Placement(visible = true, transformation(origin = {-100, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-108, 0},extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput m_flow_sch annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-108, 80},extent = {{20, -20}, {-20, 20}}, rotation = 180)));
initial equation
  pre(t_off) = 0;
  pre(t_on) = 0;
initial equation
  on_discharge = level > level_on and level > level_off;
equation
  on_charge = m_flow_in > 1e-3;
  when level > level_on then
    on_discharge = true;
  elsewhen level < level_off then
    on_discharge = false;
  end when;
  when on_charge or on_discharge then
    t_on = time;
  end when;
  when not (on_charge or on_discharge) then
    t_off = time;
  end when;
  when t_on - (t_off + t_standby) > 0 then
    startup = true;
  elsewhen time - t_on > t_start then
    startup = false;
  end when;
  standby = time - t_off < t_standby;
  if on_charge or on_discharge then
    if startup then
      m_flow = m_flow_startup;
    else
      if on_discharge then
        m_flow = m_flow_sch;
      else
        m_flow = min(m_flow_in, m_flow_sch);
      end if;
    end if;
  else
    if standby then
      m_flow = m_flow_standby;
    else
      m_flow = 0;
    end if;
  end if;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end ScheduleLogic;