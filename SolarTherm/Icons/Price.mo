within SolarTherm.Icons;
partial class Price

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          lineColor={0,0,0},
          extent={{-100,-102},{100,98}},
          radius=25,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,80},{-80,-80},{80,-80}}, color={0,0,0}),
        Line(points={{-60,-44},{-30,20},{-2,-14},{32,48},{52,-18},{68,-32}},
            color={255,0,0}),
        Text(
          extent={{10,30},{120,92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="$")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Price;
