within SolarTherm.Icons;
partial class ResistiveHeater
	extends Modelica.Icons.Package;
	annotation (
		Icon(coordinateSystem(preserveAspectRatio=false), 
			graphics={
			Line(
				origin = {-75, 0}, 
				points = {{-25, 0}, {25, 0}}, 
				color = {0,127,255}, 
				thickness = 1.0),
			Line(
				origin = {0, 0}, 
				points = {{0, 0}, {100, 0}}, 
				color = {239, 41, 41}, 
				thickness = 1.0),
			Ellipse(
				origin = {1, 0}, 
				fillColor = {255, 255, 255}, 
				fillPattern = FillPattern.Solid, 
				lineThickness = 0.25, 
				extent = {{-50, 50}, {50, -50}}), 
			Polygon(origin = {1, -3}, 
				fillColor = {252, 233, 79}, 
				fillPattern = FillPattern.Solid, 
				lineThickness = 0.25, 
				points = {{1, 49}, {-31, -5}, {5, -1}, {-1, -43}, {27, 17}, {-7, 11}, {1, 49}})
				}),
		Diagram(
			coordinateSystem(preserveAspectRatio=false)));
end ResistiveHeater;