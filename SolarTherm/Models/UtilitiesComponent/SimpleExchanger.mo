within SolarTherm.Models.UtilitiesComponent;

model SimpleExchanger
  import SI = Modelica.SIunits;
  import MedGas = Modelica.Media.IdealGases.Common.Functions;
  parameter Modelica.Media.IdealGases.Common.DataRecord gas_data = Modelica.Media.IdealGases.Common.SingleGasesData.H2 "Used together with MedGas to calculate thermodynamic properties of H2";
    
  parameter SI.Temperature T_in_HTF = 700 + 273.15 "HTF temperature in"; 
  parameter SI.Temperature T_in_HTF_emergency = 100 "HTF temperature in when burner is on emergency";
  parameter SI.Temperature T_out_HTF_target = 800 "Target temperature of the HTF";
  parameter SI.MassFlowRate m_dot_HTF_recycle = 5 "Recycle H2";
  
  SI.Temperature T_out_HTF;
  SI.SpecificEnthalpy h_HTF_in;
  SI.SpecificEnthalpy h_HTF_out;
  SI.MassFlowRate m_dot_hot_HTF "Mass flow rate of the product";
  Boolean emergency_burner;
  
  Modelica.Blocks.Interfaces.RealInput HTF_in annotation(
    Placement(visible = true, transformation(origin = {-112, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput HTF_out annotation(
    Placement(visible = true, transformation(origin = {110, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_in annotation(
    Placement(visible = true, transformation(origin = {-2, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-2, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput HTF_rec annotation(
    Placement(visible = true, transformation(origin = {-110, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  if emergency_burner  then
    h_HTF_in = MedGas.h_T(gas_data, T_in_HTF_emergency);
  else
    h_HTF_in = MedGas.h_T(gas_data, T_in_HTF);
  end if;
  if HTF_in > 1e-4 then
    h_HTF_out = Q_in/HTF_in + h_HTF_in;
  else
    h_HTF_out = h_HTF_in;
  end if;
  
  HTF_out = HTF_in "Mass balance";
  h_HTF_out = MedGas.h_T(gas_data, T_out_HTF);
  
  /*if abs(T_out_HTF_target - T_out_HTF)>0 then
      m_dot_hot_HTF = HTF_out - m_dot_HTF_recycle;
  else
      m_dot_hot_HTF = 0;
  end if;
  */
  m_dot_hot_HTF = max(HTF_out - HTF_rec,0);



annotation(
    Icon(graphics = {Text(origin = {-4, 0}, extent = {{-70, 32}, {70, -32}}, textString = "Simple exchanger")}));
end SimpleExchanger;