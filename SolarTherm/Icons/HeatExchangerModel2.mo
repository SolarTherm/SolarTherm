within SolarTherm.Icons;
partial model HeatExchangerModel2

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),graphics={
       Ellipse(
          origin={-31,11},
          fillColor = {0,85,255},
          pattern = LinePattern.None,
          fillPattern = FillPattern.HorizontalCylinder,
          extent = {{31, 29}, {-29, -31}},
          endAngle = 360,
          lineColor={0,0,0}),
       Ellipse(
          origin={30.0333,11},
          fillColor = {0,85,255},
          pattern = LinePattern.None,
          fillPattern = FillPattern.HorizontalCylinder,
          extent={{29.9667,29},{-28.0333,-31}},
          endAngle = 360,
          lineColor={0,0,0}),
       Rectangle(
          origin={0,9},
          fillColor={0,85,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-32,31},{32,-29}},
          lineColor={0,0,0}),
       Rectangle(
          origin={-29,43},
          fillColor = {0,85,255},
          pattern = LinePattern.None,
          fillPattern = FillPattern.VerticalCylinder,
          extent = {{-5, 3}, {5, -3}},
          lineColor={0,0,0}),
       Rectangle(
          origin={27,-23},
          fillColor = {0,85,255},
          pattern = LinePattern.None,
          fillPattern = FillPattern.VerticalCylinder,
          extent = {{-5, 3}, {5, -3}},
          lineColor={0,0,0}),
       Line(
          origin={0,10},
          points={{-60,15},{42,15},{42,0},{-42,0},{-42,-15},{60,-15}},
          color={255,0,0},
          thickness=1)}),
       Diagram(coordinateSystem(preserveAspectRatio=false)));
end HeatExchangerModel2;
