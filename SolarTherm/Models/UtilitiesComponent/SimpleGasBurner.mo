within SolarTherm.Models.UtilitiesComponent;

model SimpleGasBurner
  import SI = Modelica.SIunits;

  parameter SI.Energy LHV_fuel = 120.21e6 "LHV of fuel";
  parameter SI.Efficiency eta_burner = 0.8 "Burner efficiency";
  
  Modelica.Blocks.Interfaces.RealInput fuel_in annotation(
    Placement(visible = true, transformation(origin = {-6, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-6, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_burner annotation(
    Placement(visible = true, transformation(origin = {6, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-2, -104}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  
  Q_flow_burner = LHV_fuel * fuel_in * eta_burner "Heat produced by burning the fuel";

annotation(
    Icon(graphics = {Text(origin = {-27, 18}, extent = {{-19, 8}, {71, -36}}, textString = "Simple Burner"), Rectangle(origin = {-6, 9}, extent = {{-94, 91}, {106, -109}})}, coordinateSystem(initialScale = 0.1)));
end SimpleGasBurner;