within SolarTherm.Models.Control;
model StartUpLogic

  Modelica.Blocks.Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{72,-20},{112,20}})));
  parameter SI.Time delay;
  parameter Real y_ref;
  parameter Real y_0;
protected
  discrete Modelica.SIunits.Time entryTime "Time instant when u became true";
initial equation
  pre(entryTime) = 0;
equation
  when u then
    entryTime = time;
  end when;
  y = if u then min(y_ref,y_0+(y_ref-y_0)*(time - entryTime)/delay) else y_0;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StartUpLogic;
