within SolarTherm.Models.Control;
block ColdTankLogic3

  Modelica.Blocks.Interfaces.RealInput level_ref
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}})));
    parameter SI.Irradiance DNI_min = 400;
    parameter Real level_min = 10;

  Modelica.Blocks.Interfaces.BooleanOutput y(start=true)
    annotation (Placement(transformation(extent={{98,-10},{118,10}})));
  Modelica.Blocks.Interfaces.RealInput DNI_ref
    annotation (Placement(transformation(extent={{-120,30},{-80,70}})));
protected
  parameter Real level_max=20;
equation

  when level_ref>level_max then
    y=(DNI_ref>DNI_min);
  elsewhen level_ref<level_min then
    y=false;
  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ColdTankLogic3;
