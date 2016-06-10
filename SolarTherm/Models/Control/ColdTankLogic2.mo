within SolarTherm.Models.Control;
block ColdTankLogic2

  Modelica.Blocks.Interfaces.RealInput level_ref
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}})));
    parameter SI.Irradiance DNI_min = 400;
    parameter Real level_min = 10;

  Modelica.Blocks.Interfaces.BooleanOutput y(start=true)
    annotation (Placement(transformation(extent={{98,-10},{118,10}})));
  Modelica.Blocks.Interfaces.RealInput DNI_ref
    annotation (Placement(transformation(extent={{-120,30},{-80,70}})));
protected
  Real eps(start=0);
equation

    if level_ref+eps>level_min+eps then
      y=DNI_ref>DNI_min;
      eps=0;
    else
      y=false;
      eps=10;
    end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ColdTankLogic2;
