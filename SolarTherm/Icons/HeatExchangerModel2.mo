within SolarTherm.Icons;
partial model HeatExchangerModel2

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),graphics={Ellipse(origin = {-31, 11}, lineColor = {46, 52, 54}, fillColor = {186, 189, 182}, pattern = LinePattern.None, fillPattern = FillPattern.HorizontalCylinder, extent = {{31, 29}, {-29, -31}}),
       Ellipse(origin = {30.03, 11}, lineColor = {46, 52, 54}, fillColor = {186, 189, 182}, pattern = LinePattern.None, fillPattern = FillPattern.HorizontalCylinder, extent = {{29.97, 29}, {-28.03, -31}}),
       Rectangle(origin = {0, 9}, lineColor = {46, 52, 54}, fillColor = {186, 189, 182}, pattern = LinePattern.None, fillPattern = FillPattern.HorizontalCylinder, extent = {{-32, 31}, {32, -29}}),
       Rectangle(origin = {-29, 43}, lineColor = {85, 87, 83}, fillColor = {211, 215, 207}, pattern = LinePattern.None, fillPattern = FillPattern.VerticalCylinder, extent = {{-5, 3}, {5, -3}}),
       Rectangle(origin = {27, -23}, lineColor = {85, 87, 83}, fillColor = {186, 189, 182}, pattern = LinePattern.None, fillPattern = FillPattern.VerticalCylinder, extent = {{-5, 3}, {5, -3}}),
       Line(origin = {0, 10}, points = {{-60, 15}, {42, 15}, {42, 0}, {-42, 0}, {-42, -15}, {60, -15}}, thickness = 0.5)}),
       Diagram(coordinateSystem(preserveAspectRatio=false)));
end HeatExchangerModel2;