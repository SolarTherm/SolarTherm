within SolarTherm.Models.Control;
model StartUpLogic3
  //power block startup+ time of standby
  Modelica.Blocks.Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{90,-20},{130,20}})));

  parameter SI.Time t_start = 0.5*3600;
  parameter SI.Time t_standby = 2*3600;
  parameter Real y_des;
  parameter Real y_start;
  Boolean standby;
  Boolean startup;
protected
  discrete SI.Time t_off;
  discrete SI.Time t_on;
initial equation
  pre(t_off) = 0;
  pre(t_on) = 0;
equation
  when u then
    t_on = time;
  end when;
  when not u then
    t_off = time;
  end when;

  when t_on-(t_off+t_standby)>0 then
    startup=true;
  elsewhen (time-t_on)>t_start then
    startup=false;
  end when;
  standby = (time-t_off)<t_standby;
  y = if u then (if (startup) then y_start else y_des) else 0;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StartUpLogic3;
