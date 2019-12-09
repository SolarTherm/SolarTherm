within SolarTherm.Models.Control;
block Level2Logic

  Modelica.Blocks.Interfaces.RealInput level_ref
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
    parameter Real level_max = 90;
    parameter Real level_min = 10;

  Modelica.Blocks.Interfaces.BooleanOutput y
    annotation (Placement(transformation(extent={{98,-10},{118,10}})));
initial equation
  y= (level_ref>level_max) and
                             (level_ref>level_min);

equation
  when level_ref>level_max then
    y=true;
  elsewhen level_ref<level_min then
    y=false;
  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Level2Logic;
