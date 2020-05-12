within SolarTherm.Icons;
partial class HeatExchangerIcon
	annotation (
	Icon(coordinateSystem(extent = {{-40, -40}, {40, 40}},preserveAspectRatio=true), 
	graphics = {
	Rectangle(
		origin = {10, 10}, 
		fillColor = {85, 85, 255}, 
		fillPattern = FillPattern.HorizontalCylinder, 
		extent = {{-40, 20}, {20, -40}}), 
	Ellipse(
		origin = {-30, 0}, 
		fillColor = {85, 85, 255}, 
		pattern = LinePattern.None, 
		fillPattern = FillPattern.HorizontalCylinder, 
		extent = {{-22, 30}, {22, -30}}, 
		endAngle = 360), 
	Rectangle(
		origin = {-26, 33}, 
		fillPattern = FillPattern.Solid, 
		extent = {{-2, 3}, {2, -3}}), 
	Rectangle(
		origin = {-26, -33}, 
		fillPattern = FillPattern.Solid, 
		extent = {{-2, 3}, {2, -3}}), 
	Ellipse(
		origin = {28, 0}, 
		fillColor = {85, 85, 255}, 
		pattern = LinePattern.None, 
		fillPattern = FillPattern.HorizontalCylinder, 
		extent = {{-22, 30}, {22, -30}}, 
		endAngle = 360), 
	Line(
		origin = {18.16, 3.16}, 
		points = {{24.8675, -24.1325}, {-57.1325, -24.1325}, {-57.1325, -10.1325}, {20.8675, -10.1325}, {20.8675, 3.86754}, {-57.1325, 3.86754}, {-57.1325, 17.8675}, {24.8675, 17.8675}}, 
		color = {255, 0, 0}, 
		thickness = 1), 
	Text(
		origin = {10, 50}, 
		lineColor = {0, 0, 255}, 
		extent = {{-30, 1}, {30, -9}}, 
		textString = "%name")}),
	Diagram(
	coordinateSystem(extent = {{-40, -40}, {40, 40}})
	)
	);
end HeatExchangerIcon;
