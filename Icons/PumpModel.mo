within SolarTherm.Icons;
partial class PumpModel

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
              100}}), graphics={
          Rectangle(
            extent={{-100,46},{100,-46}},
            lineColor={0,0,0},
            fillColor={0,127,255},
            fillPattern=FillPattern.HorizontalCylinder),
          Polygon(
            points={{-48,-60},{-72,-100},{72,-100},{48,-60},{-48,-60}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,0},
            fillPattern=FillPattern.VerticalCylinder),
          Ellipse(
            extent={{-80,80},{80,-80}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Sphere,
            fillColor={0,100,199}),
          Polygon(
            points={{-28,30},{-28,-30},{50,-2},{-28,30}},
            lineColor={0,0,0},
            pattern=LinePattern.None,
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={255,255,255})}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end PumpModel;
