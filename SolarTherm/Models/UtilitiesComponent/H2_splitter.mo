within SolarTherm.Models.UtilitiesComponent;

model H2_splitter
  import SI = Modelica.SIunits;
  import MedGas = Modelica.Media.IdealGases.Common.Functions;
  
  parameter SI.MassFlowRate mdot_split = 1 "Flow to be splitted";  
  parameter SI.MassFlowRate mdot_split_emergency = 1 "Flow to be splitted";
  parameter SI.MassFlowRate mdot_recycle = 1;
  parameter SI.MassFlowRate m_dot_HX = 1;
  
  Boolean emergency_burner;
  
  Modelica.Blocks.Interfaces.RealInput flow_in annotation(
    Placement(visible = true, transformation(origin = {-110, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput flow_out_1 annotation(
    Placement(visible = true, transformation(origin = {106, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput flow_out_2 annotation(
    Placement(visible = true, transformation(origin = {106, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput mdot_h2_burner annotation(
    Placement(visible = true, transformation(origin = {-16, 94}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-16, 94}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
equation
//if emergency_burner then
      if flow_in > 0.1  then
          flow_out_1 = flow_in - mdot_h2_burner "The one that goes to the HX";
          flow_out_2 = mdot_h2_burner "To burner";
      else
          flow_out_1 = 0 "The one that goes to the HX";
          flow_out_2 = 0 "To burner";
      end if;
      
/*else
      if flow_in > 0.1  then
          flow_out_1 = flow_in - mdot_h2_burner "The one that goes to the HX";
          flow_out_2 = 0 "To burner";
      else
          flow_out_1 = 0 "The one that goes to the HX";
          flow_out_2 = 0 "To burner";
      end if;
end if;*/

end H2_splitter;