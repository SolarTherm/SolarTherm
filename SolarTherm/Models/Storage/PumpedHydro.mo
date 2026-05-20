within SolarTherm.Models.Storage;

model PumpedHydro
extends SolarTherm.Icons.PumpedHydro;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  
  parameter Real Level_start = 0.50 "Starting Level of Storage 0.0-1.0";
  parameter SI.Energy E_max = 2.0e9 "Storage capacity (J)";
  
  Modelica.Blocks.Interfaces.RealInput P_input annotation(Placement(visible=true, transformation(origin={0,0}, extent={{-20, -20},{20, 20}}, rotation=0), iconTransformation(origin = {-80, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_output annotation(
    Placement(visible = true, transformation(origin = {108, 2}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {80, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
    
  SI.Energy E_stored(start=E_max*Level_start) "Energy stored (J)";
  Real Level(start=Level_start) "Level of storage 0.0-1.0";
  

equation

end PumpedHydro;