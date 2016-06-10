within SolarTherm.Models.Control;
block ColdTankLogic4

    parameter SI.Irradiance DNI_min = 400;

  Modelica.Blocks.Interfaces.BooleanOutput y
    annotation (Placement(transformation(extent={{98,-10},{118,10}})));
  Modelica.Blocks.Interfaces.RealInput DNI_ref
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
equation

      y=DNI_ref>DNI_min;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ColdTankLogic4;
