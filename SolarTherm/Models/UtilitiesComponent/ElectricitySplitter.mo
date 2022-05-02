within SolarTherm.Models.UtilitiesComponent;

model ElectricitySplitter
  parameter Real limit = 1e8 "Limit above which input will be curtailed, directed to y2";
  Modelica.Blocks.Interfaces.RealInput u1 annotation(
    Placement(visible = true, transformation(origin = {-112, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y1 annotation(
    Placement(visible = true, transformation(origin = {102, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y2 annotation(
    Placement(visible = true, transformation(origin = {4, -104}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {4, -104}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  if u1 > limit then
      y1 = limit;
      y2 = u1 - limit;
  else
      y1 = u1;
      y2 = 0;    
  end if;

annotation(
    Icon(graphics = {Rectangle(origin = {0, -12}, extent = {{-100, 88}, {100, -88}}), Text(origin = {-21, 13}, extent = {{-29, 11}, {67, -41}}, textString = "Electricity Splitter")}));
end ElectricitySplitter;