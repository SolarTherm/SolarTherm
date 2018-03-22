within SolarTherm.Icons;
partial model TurbineModel

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),graphics={
      Polygon(
        fillColor = {108, 108, 108},
        pattern = LinePattern.None,
        fillPattern = FillPattern.Solid,
        points = {{-40, 40}, {40, 20}, {40, -20}, {-40, -40}, {-40, 40}}),
      Ellipse(
        origin = {113, -83},
        lineColor = {255, 85, 0},
        fillColor = {108, 108, 108},
        pattern = LinePattern.None,
        fillPattern = FillPattern.Solid,
        extent = {{-85, 103}, {-65, 63}},
        endAngle = 360),
      Ellipse(
        origin={8,67},
        lineColor={108,108,108},
        fillColor={156,156,156},
        fillPattern=FillPattern.Sphere,
        extent={{-68,-27},{-28,-107}},
        endAngle=360)}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end TurbineModel;
