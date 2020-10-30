within SolarTherm.Models.Control;
model m_flow_calculations_simple_2
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";

  parameter SI.HeatFlowRate Q_rec_out;
  parameter SI.MassFlowRate m_flow_max_CS=1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min_CS=0 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_start_CS=0 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_max_Na=1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min_Na=0 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_start_Na=0 "Mass flow rate when control off";
  
  parameter SI.Length d_o=1 "Outer Tube diameter";
  parameter Integer N_p=1 "Number of tube-passes";
  parameter Integer N_sp=1 "Number of shell-passes";
  parameter Integer layout=1 "Tube layout";
  parameter Integer N_t=1 "Number of tubes";
  parameter SI.Length L=1 "Tube length";  
  
  Modelica.Blocks.Interfaces.RealInput T_input_rec 
    annotation(
    Placement(visible = true, transformation(extent = {{-140, 40}, {-100, 80}}, rotation = 0), iconTransformation(extent = {{-140, 40}, {-100, 80}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.BooleanInput sf_on 
    annotation(
    Placement(visible = true, transformation(extent = {{-132, 72}, {-92, 112}}, rotation = 0), iconTransformation(extent = {{-132, 72}, {-92, 112}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealInput T_output_cs
    annotation (
    Placement(visible = true, transformation(extent = {{-140, -80}, {-100, -40}}, rotation = 0), iconTransformation(extent = {{-140, -80}, {-100, -40}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput T_out_rec_ref 
    annotation(
    Placement(visible = true, transformation(extent = {{-140, 0}, {-100, 40}}, rotation = 0), iconTransformation(extent = {{-140, 0}, {-100, 40}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealInput T_input_hs
    annotation (
    Placement(visible = true, transformation(extent = {{-140, -40}, {-100, 0}}, rotation = 0), iconTransformation(extent = {{-140, -40}, {-100, 0}}, rotation = 0)));
    
  
  Modelica.Blocks.Interfaces.RealInput Q_out_rec(start=Q_rec_out)
    annotation (
    Placement(visible = true, transformation(origin = {0, 110},extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 110},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  
  Modelica.Blocks.Interfaces.RealOutput m_flow_rec(start=m_flow_start_Na)
    annotation (
    Placement(visible = true, transformation(extent = {{100, -68}, {136, -32}}, rotation = 0), iconTransformation(extent = {{100, -68}, {136, -32}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealOutput m_flow_hs
    annotation (
    Placement(visible = true, transformation(extent = {{100, 30}, {136, 66}}, rotation = 0), iconTransformation(extent = {{100, 30}, {136, 66}}, rotation = 0)));
  
  Medium1.ThermodynamicState state_Na1;
  Medium1.ThermodynamicState state_Na2;
  Medium1.ThermodynamicState state_mean_Na;
  Medium2.ThermodynamicState state_CS1;
  Medium2.ThermodynamicState state_CS2;
  Medium2.ThermodynamicState state_wall_CS;
  Medium2.ThermodynamicState state_mean_CS;
  SI.SpecificEnthalpy h_Na1;
  SI.SpecificEnthalpy h_Na2;
  SI.SpecificEnthalpy h_CS1;
  SI.SpecificEnthalpy h_CS2;
  SI.MassFlowRate m_flow_rec_internal(start=m_flow_start_Na);
  SI.MassFlowRate m_flow_hs_internal;
  
  SI.CoefficientOfHeatTransfer U "Heat tranfer coefficient";  
  SI.TemperatureDifference DT1 "Sodium-Molten Salt temperature difference 1";
  SI.TemperatureDifference DT2 "Sodium-Molten Salt temperature difference 2";
  SI.TemperatureDifference LMTD "Logarithmic mean temperature difference";
  SI.Area A "Optimal Exchange Area";
  SI.Temperature Tm_CS;
  SI.Temperature Tm_Na;
  SI.HeatFlowRate Q_calc "Design Heat Flow Rate";

equation
  Tm_Na = (T_input_rec+T_out_rec_ref)/2;
  Tm_CS = (T_output_cs+T_input_hs)/2;
  state_mean_Na = Medium1.setState_pTX(Medium1.p_default, Tm_Na);
  state_mean_CS = Medium2.setState_pTX(Medium2.p_default, Tm_CS);
  state_wall_CS = Medium2.setState_pTX(Medium2.p_default, Tm_Na);
  state_Na1= Medium1.setState_pTX(Medium1.p_default, T_out_rec_ref);
  state_Na2= Medium1.setState_pTX(Medium1.p_default, T_input_rec);
  state_CS1= Medium2.setState_pTX(Medium2.p_default, T_output_cs);
  state_CS2= Medium2.setState_pTX(Medium2.p_default, T_input_hs);
  h_Na1= Medium1.specificEnthalpy(state_Na1);
  h_Na2= Medium1.specificEnthalpy(state_Na2);
  h_CS1= Medium2.specificEnthalpy(state_CS1);
  h_CS2= Medium2.specificEnthalpy(state_CS2);

  A = CN.pi*d_o*L*N_t;
  DT1 = T_out_rec_ref - T_input_hs;
  DT2 = T_input_rec - T_output_cs;
  LMTD = if noEvent(DT1 / DT2 <= 0 or abs(DT1 - DT2)<1e-3) then 0 else (DT1 - DT2) / MA.log(DT1 / DT2);
  U = SolarTherm.Models.Fluid.HeatExchangers.HTCs(d_o=d_o, N_p=N_p, N_sp=N_sp, layout=layout, N_t=N_t, state_mean_Na=state_mean_Na, state_mean_MS=state_mean_CS, state_wall_MS=state_wall_CS, m_flow_Na=m_flow_rec_internal, m_flow_MS=m_flow_hs_internal, L=L);
  Q_out_rec=m_flow_rec_internal*(h_Na1-h_Na2);
  Q_calc=U*A*LMTD;
  Q_calc=m_flow_hs_internal*(h_CS2-h_CS1);
  

  m_flow_rec=m_flow_rec_internal;
  m_flow_hs=m_flow_hs_internal;
  
end m_flow_calculations_simple_2;