within SolarTherm.Utilities;
/*
      Scaling up the wind speed from the ground to tower height of H. 
          > Logarithmic relation is used https://is.gd/jK0emQ
          > Typical meteorological wind speed data is measured at 2 m above ground https://is.gd/57SNBs

*/

model WspdScaler
  import ln = Modelica.Math.log;
  parameter Real z0 = 1e-3 "Surface roughness. According to https://is.gd/m7EaZT , dessert z0 is 0.001";
  parameter Real H_tower = 200 "Tower height [m]";
  Modelica.Blocks.Interfaces.RealInput WspdGround annotation(
    Placement(visible = true, transformation(origin = {-112, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput WspdOut annotation(
    Placement(visible = true, transformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  WspdOut = WspdGround * (ln(H_tower/z0))/(ln(2/z0));
annotation(
    Icon(graphics = {Rectangle(origin = {6, -5}, extent = {{-98, 75}, {92, -71}}), Text(origin = {46, 57}, extent = {{-52, 37}, {52, -37}}, textString = "Wind Scaler"), Text(origin = {-30, -67}, extent = {{-60, 9}, {60, -9}}, textString = "Logarithmic Correlation")}));
end WspdScaler;