within SolarTherm.Models.Control;
block Switch2
extends Modelica.Blocks.Icons.PartialBooleanBlock;

  Modelica.Blocks.Interfaces.RealInput in1 "Connector of first Real input signal"
    annotation (Placement(visible = true, transformation(extent = {{-140, 2}, {-100, 42}}, rotation = 0), iconTransformation(extent = {{-140, 2}, {-100, 42}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput in2 "Connector of first Real input signal"
    annotation (Placement(visible = true, transformation(extent = {{-140, 50}, {-100, 90}}, rotation = 0), iconTransformation(extent = {{-140, 50}, {-100, 90}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput u2 "Connector of Boolean input signal"
    annotation (Placement(visible = true, transformation(extent = {{-140, -54}, {-100, -14}}, rotation = 0), iconTransformation(extent = {{-140, -54}, {-100, -14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u3 "Connector of second Real input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput y1 "Connector of Real output signal"
    annotation (Placement(visible = true, transformation(extent = {{100, -40}, {120, -20}}, rotation = 0), iconTransformation(extent = {{100, -40}, {120, -20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y2 "Connector of Real output signal"
    annotation (Placement(visible = true, transformation(extent = {{100, 20}, {120, 40}}, rotation = 0), iconTransformation(extent = {{100, 20}, {120, 40}}, rotation = 0)));
  
  equation
  y1 = if u2 then in1 else u3;
  y2 = if u2 then in2 else u3;
  
  annotation (
    defaultComponentName="switch1",
    Documentation(info="<html>
<p>The Logical.Switch switches, depending on the
logical connector u2 (the middle connector)
between the two possible input signals
u1 (upper connector) and u3 (lower connector).</p>
<p>If u2 is <b>true</b>, the output signal y is set equal to
u1, else it is set equal to u3.</p>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{12.0,0.0},{100.0,0.0}},
          color={0,0,127}),
        Line(points={{-100.0,0.0},{-40.0,0.0}},
          color={255,0,255}),
        Line(points={{-100.0,-80.0},{-40.0,-80.0},{-40.0,-80.0}},
          color={0,0,127}),
        Line(points={{-40.0,12.0},{-40.0,-12.0}},
          color={255,0,255}),
        Line(points={{-100.0,80.0},{-38.0,80.0}},
          color={0,0,127}),
        Line(points={{-38.0,80.0},{6.0,2.0}},
          color={0,0,127},
          thickness=1.0),
        Ellipse(lineColor={0,0,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2.0,-8.0},{18.0,8.0}})}));
end Switch2;