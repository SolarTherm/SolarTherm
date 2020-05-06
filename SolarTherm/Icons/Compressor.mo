within SolarTherm.Icons;

partial class Compressor
annotation(
	Diagram(
		coordinateSystem(extent = {{-40, -60}, {40, 60}}),
		graphics = {
			Text(
				origin = {0, 0}, 
				extent = {{-100, -100}, {100, -100}}, 
				textString = "%name",
				lineColor={0,0,255}
				)
			}
		),
	Icon(
		coordinateSystem(extent = {{-40, -60}, {40, 60}},preserveAspectRatio=true), 
		graphics = {
			Text(
				origin = {0, 0}, 
				extent = {{-40, -80}, {80, -60}}, 
				textString = "%name",
				lineColor={0,0,255}),
			Polygon(
				origin = {0, 2}, 
				rotation = 180, 
				fillColor = {0, 0, 127}, 
				fillPattern = FillPattern.Solid, 
				points = {{-40, 32}, {-40, -28}, {40, -58}, {40, 62}, {-40, 32}}
				)
				}
		)
	);
end Compressor;
