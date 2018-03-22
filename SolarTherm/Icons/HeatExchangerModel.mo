within SolarTherm.Icons;
partial model HeatExchangerModel

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),graphics={
       Ellipse(
          origin = {-61, 11},
          fillColor = {0,85,255},
          pattern = LinePattern.None,
          fillPattern = FillPattern.HorizontalCylinder,
          extent = {{31, 29}, {-29, -31}},
          endAngle = 360,
          lineColor={0,0,0}),
       Ellipse(
          origin = {59, 11},
          fillColor = {0,85,255},
          pattern = LinePattern.None,
          fillPattern = FillPattern.HorizontalCylinder,
          extent = {{31, 29}, {-29, -31}},
          endAngle = 360,
          lineColor={0,0,0}),
       Rectangle(
          origin={0,9},
          fillColor={0,85,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-60,31},{60,-29}},
          lineColor={0,0,0}),
       Rectangle(
          origin = {-55, 43},
          fillColor = {0,85,255},
          pattern = LinePattern.None,
          fillPattern = FillPattern.VerticalCylinder,
          extent = {{-5, 3}, {5, -3}},
          lineColor={0,0,0}),
       Rectangle(
          origin = {55, -23},
          fillColor = {0,85,255},
          pattern = LinePattern.None,
          fillPattern = FillPattern.VerticalCylinder,
          extent = {{-5, 3}, {5, -3}},
          lineColor={0,0,0}),
       Line(
          origin={0,10},
          points={{-85,21},{65,21},{65,14},{-65,14},{-65,7},{65,7},{65,0},
          {-65,0},{-65,-7},{65,-7},{65,-14},{-65,-14},{-65,-21},{85,-21}},
          color={255,0,0},
          thickness=1)}),
       Diagram(coordinateSystem(preserveAspectRatio=false)));
end HeatExchangerModel;
