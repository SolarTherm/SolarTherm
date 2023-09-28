within SolarTherm.Icons;
partial class GridInput
  annotation(
    Icon(graphics = {
    Line(points = {{40, 20}, {-40, -20}, {-40, 20}, {40, -20}, {40, 20}}), 
    Line(origin = {0, -100}, points = {{-80, 0}, {80, 0}}), 
    Line(origin = {0, -60.17}, points = {{-80, -40}, {-40, 40}, {40, 40}, {80, -40}}), 
    Line(points = {{-40, -20}, {60, -60}, {-60, -60}, {40, -20}}), 
    Line(points = {{-60, -60}, {80, -100}}), 
    Line(points = {{60, -60}, {-80, -100}}), 
    Line(origin = {0.17, 39.78}, points = {{-40.1708, -19.7764}, {39.8292, -19.7764}, {39.8292, 20.2236}, {-40.1708, -19.7764}, {-40.1708, 20.2236}, {39.8292, -19.7764}}), 
    Line(origin = {0, 80}, points = {{-40, -20}, {0, 20}, {40, -20}, {-40, -20}}), 
    Line(origin = {-70, 40}, points = {{30, -20}, {-30, 0}, {30, 20}}), 
    Line(origin = {70, 40}, points = {{-30, 20}, {30, 0}, {-30, -20}}), 
    Text(
		origin = {-10, 254}, 
		lineColor = {0, 0, 255}, 
		extent = {{-149, -114}, {151, -154}}, 
		textString = "%name")}));
end GridInput;