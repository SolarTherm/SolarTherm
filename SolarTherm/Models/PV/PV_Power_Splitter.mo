within SolarTherm.Models.PV;

model PV_Power_Splitter
  /*These variables will be given by the system level model*/
  Real fraction_P_PV_AEL;
  Real fraction_P_PV_TES;
  Real fraction_P_PV_dumped;
  Real P_check;
  
  Modelica.Blocks.Interfaces.RealInput P_PV_in annotation(
    Placement(visible = true, transformation(origin = {-114, 4}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-114, 4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_PV_AEL annotation(
    Placement(visible = true, transformation(origin = {108, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_PV_TES annotation(
    Placement(visible = true, transformation(origin = {8, -106}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {8, -106}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput P_PV_dumped annotation(
    Placement(visible = true, transformation(origin = {-2, 108}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-2, 108}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation

  P_PV_AEL = fraction_P_PV_AEL * P_PV_in;
  P_PV_TES = fraction_P_PV_TES * P_PV_in;
  P_PV_dumped = fraction_P_PV_dumped * P_PV_in;
  P_check = P_PV_in - P_PV_AEL - P_PV_dumped - P_PV_TES;

end PV_Power_Splitter;