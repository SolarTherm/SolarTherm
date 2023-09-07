within SolarTherm.Icons;
partial class Boiler
annotation(
    Icon(graphics = {
        Line(
			points={{-60,0},{-100,0}}, 
			color={0,127,255}),
        Line(
			points={{60, 0},{100,0}}, 
			color={0,127,255}),
		Rectangle(
			origin = {-1, 0},
			rotation = 90, 
			fillColor = {135, 135, 135}, 
			fillPattern = FillPattern.Backward, 
			extent = {{-60, 61}, {60, -61}}),
        Rectangle(
			rotation = 90, 
			fillColor = {255, 255, 255}, 
			fillPattern = FillPattern.HorizontalCylinder, 
			extent = {{-60, -44}, {60, 44}}),
        Rectangle(
			rotation = 90, 
			fillColor = {0, 127, 255}, 
			fillPattern = FillPattern.HorizontalCylinder, 
			extent = {{-60, -44}, {60, 44}}),
        Ellipse(
			origin = {2, -54},
			rotation = 90, 
			lineColor = {0, 0, 255}, 
			fillColor = {255, 255, 255}, 
			pattern = LinePattern.None, 
			fillPattern = FillPattern.Solid, 
			extent = {{43, 31}, {73, 2}}),
        Ellipse(
			origin = {-8, 0},
			rotation = 90, 
			lineColor = {0, 0, 255}, 
			fillColor = {255, 255, 255}, 
			pattern = LinePattern.None, 
			fillPattern = FillPattern.Solid, 
			extent = {{-31, 1}, {-1, -28}}),
        Ellipse(
			origin = {0, -108},
			rotation = 90, 
			lineColor = {0, 0, 255}, 
			fillColor = {255, 255, 255}, 
			pattern = LinePattern.None, 
			fillPattern = FillPattern.Solid, 
			extent = {{50, 15}, {80, -14}}),
        Ellipse(
			origin = {10, 98},
			rotation = 90, 
			lineColor = {0, 0, 255}, 
			fillColor = {255, 255, 255}, 
			pattern = LinePattern.None, 
			fillPattern = FillPattern.Solid, 
			extent = {{-72, 25}, {-42, -4}}),
        Ellipse(
			origin = {0, -122},
			rotation = 90, 
			lineColor = {0, 0, 255}, 
			fillColor = {255, 255, 255}, 
			pattern = LinePattern.None, 
			fillPattern = FillPattern.Solid, 
			extent = {{71, 40}, {101, 11}}),
        Ellipse(
			origin = {0, -116},
			rotation = 90, 
			lineColor = {0, 0, 255}, 
			fillColor = {255, 255, 255}, 
			pattern = LinePattern.None, 
			fillPattern = FillPattern.Solid, 
			extent = {{58, -11}, {88, -40}}),
        Ellipse(
			origin = {6, -76},
			rotation = 90, 
			lineColor = {0, 0, 255}, 
			fillColor = {255, 255, 255}, 
			pattern = LinePattern.None, 
			fillPattern = FillPattern.Solid, 
			extent = {{71, 1}, {101, -28}})}));
end Boiler;