within SolarTherm.Models.UtilitiesComponent;

model IdealRecuperator
  import SI = Modelica.SIunits;
  import MedGas = Modelica.Media.IdealGases.Common.Functions;
  parameter SI.Temperature T_out = 595 + 273.15;
  parameter SI.Temperature T_in = 80 + 273.15;
  parameter SI.HeatFlowRate Q_recup(fixed=false);
  parameter SI.MassFlowRate m_dot_HTF = 1;
  parameter Modelica.Media.IdealGases.Common.DataRecord gas_data = Modelica.Media.IdealGases.Common.SingleGasesData.H2 "Used together with MedGas to calculate thermodynamic properties of H2";
  Modelica.Blocks.Interfaces.RealInput HTF_in annotation(
    Placement(visible = true, transformation(origin = {-112, 8}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, 8}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput HTF_out annotation(
    Placement(visible = true, transformation(origin = {100, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial equation
  Q_recup = m_dot_HTF * (
        MedGas.h_T(gas_data, T_out) - MedGas.h_T(gas_data, T_in)
  ) ;
equation
  HTF  = HTF_in;
  

end IdealRecuperator;