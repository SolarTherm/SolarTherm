within SolarTherm.Icons;
partial class Temperature

annotation (defaultComponentName="temperature",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{0,100},{0,50}}, color={0,0,127}),
        Line(points={{-92,0},{100,0}}, color={0,128,255}),
        Ellipse(
          extent={{-20,-68},{20,-30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,50},{12,-34}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,50},{-12,70},{-10,76},{-6,78},{0,80},{6,78},{10,76},{
              12,70},{12,50},{-12,50}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-12,50},{-12,-35}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{12,50},{12,-34}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-40,-10},{-12,-10}}, color={0,0,0}),
        Line(points={{-40,20},{-12,20}}, color={0,0,0}),
        Line(points={{-40,50},{-12,50}}, color={0,0,0}),
        Text(
          extent={{94,122},{0,92}},
          lineColor={0,0,0},
          textString="T")}),
  Documentation(info="<HTML>
<p>
This component monitors the temperature of the passing fluid.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end Temperature;
