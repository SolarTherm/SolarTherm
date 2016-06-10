within SolarTherm.Models.Control;
block ColdTankLogic

  Modelica.Blocks.Interfaces.RealInput level_ref
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}})));
    parameter SI.Irradiance DNI_min = 400;
    parameter Real level_min = 10;

  Modelica.Blocks.Interfaces.BooleanOutput y
    annotation (Placement(transformation(extent={{98,-10},{118,10}})));
  Modelica.Blocks.Interfaces.RealInput DNI_ref
    annotation (Placement(transformation(extent={{-120,30},{-80,70}})));
equation

  y=(DNI_ref>DNI_min) and (level_ref>level_min);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ColdTankLogic;
