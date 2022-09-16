within SolarTherm.Models.UtilitiesComponent;

model H2_splitter
  import SI = Modelica.SIunits;
  import MedGas = Modelica.Media.IdealGases.Common.Functions;
  
  
  parameter SI.MassFlowRate mdot_recycle = 1 "Flow to be splitted";
  
  parameter SI.MassFlowRate mdot_split = 1 "Flow to be splitted";
  Modelica.Blocks.Interfaces.RealInput flow_in annotation(
    Placement(visible = true, transformation(origin = {-110, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput flow_out_1 annotation(
    Placement(visible = true, transformation(origin = {106, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput flow_out_2 annotation(
    Placement(visible = true, transformation(origin = {106, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  flow_out_1 = if (flow_in - mdot_split) > 0 then (flow_in - mdot_split) else 0 "The one that goes to the HX";
  flow_out_2 = if (flow_in - mdot_split) > 0 then mdot_split else 0 "To burner";


end H2_splitter;