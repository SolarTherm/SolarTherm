within SolarTherm.Models.Fluid.HeatExchangers;
model HX_wi
  extends SolarTherm.Interfaces.Models.HeatExchangerFluid;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  
  //Media
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  
  //Design Parameters
  parameter SI.HeatFlowRate Q_d_des = 50e6 "Design Heat Flow Rate";
  parameter SI.Temperature T_Na1_des = 740 + 273.15 "Desing Sodium Hot Fluid Temperature";
  parameter SI.Temperature T_MS1_des = 500 + 273.15 "Desing Molten Salt Cold Fluid Temperature";
  parameter SI.Temperature T_MS2_des = 720 + 273.15 "Desing Molten Salt Hot Fluid Temperature";
  parameter SI.Pressure p_Na1_des = 101325 "Design Sodium Inlet Pressure";
  parameter SI.Pressure p_MS1_des = 101325 "Design Molten Salt Inlet Pressure";
  
  //Auxiliary parameters
  parameter Boolean optimize_and_run = true;
  parameter SI.MassFlowRate m_flow_Na_min_des(fixed = false);
  parameter SI.MassFlowRate m_flow_MS_min_des(fixed = false);
  
  //Input parameters
  parameter SI.Length d_o_input = 0.04128 "Optimal Outer Tube Diameter";
  parameter SI.Length L_input = 8 "Optimal Tube Length";
  parameter Integer N_p_input = 4 "Optimal Tube passes number";
  parameter Integer layout_input = 2 "Optimal Tube Layout";
  parameter SI.Temperature T_Na2_input = 670 + 273.15 "Optimal outlet sodium temperature";
  
  //Optimal Parameter Values
  parameter Real TAC(unit = "€/year", fixed = false) "Minimum Total Annualized Cost";
  parameter SI.Area A_HX(fixed = false) "Optimal Exchange Area";
  parameter SI.CoefficientOfHeatTransfer U_design(fixed = false) "Optimal Heat tranfer coefficient";
  parameter Integer N_t(fixed = false) "Optimal Number of tubes";
  parameter SI.Pressure Dp_tube_design(fixed = false) "Optimal Tube-side pressure drop";
  parameter SI.Pressure Dp_shell_design(fixed = false) "Optimal Shell-side pressure drop";
  parameter SI.CoefficientOfHeatTransfer h_s_design(fixed = false) "Optimal Shell-side Heat tranfer coefficient";
  parameter SI.CoefficientOfHeatTransfer h_t_design(fixed = false) "Optimal Tube-side Heat tranfer coefficient";
  parameter SI.Length D_s(fixed = false) "Optimal Shell Diameter";
  parameter SI.Velocity v_Na_design(fixed = false) "Optimal Sodium velocity in tubes";
  parameter SI.Velocity v_max_MS_design(fixed = false) "Optimal Molten Salt velocity in shell";
  parameter SI.Volume V_HX(fixed = false) "Optimal Heat-Exchanger Total Volume";
  parameter SI.Mass m_HX(fixed = false) "Optimal Heat-Exchanger Total Mass";
  parameter Real C_BEC_HX(unit = "€", fixed = false) "Optimal Bare cost @2018";
  parameter Real C_pump_design(unit = "€/year", fixed = false) "Optimal Annual pumping cost";
  parameter SI.Length d_o(fixed = false) "Optimal Outer Tube Diameter";
  parameter SI.Length L(fixed = false) "Optimal Tube Length";
  parameter Integer N_p(fixed = false) "Optimal Tube passes number";
  parameter Integer layout(fixed = false) "Optimal Tube Layout";
  parameter SI.Temperature T_Na2_design(fixed = false) "Optimal outlet sodium temperature";
  parameter SI.MassFlowRate m_flow_Na_design(fixed = false) "Optimal Sodium mass flow rate";
  parameter SI.MassFlowRate m_flow_MS_design(fixed = false) "Optimal Molten-Salt mass flow rate";
  parameter Real F_design(fixed = false) "Optimal Temperature correction factor";
  parameter SI.ThermalConductance UA_design(fixed = false) "Optimal UA";
  parameter Real ex_eff_design(fixed = false) "Optimal HX Exergetic Efficiency";
  parameter Real en_eff_design(fixed = false) "Optimal HX Energetic Efficiency";
  
  //Variables
  SI.MassFlowRate m_flow_Na(min = 0, start=17.1174, nominal = 570.581) "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS(min = 0, start=12.9471, nominal=212.598) "Molten Salt mass flow rate";
  parameter SI.Temperature T_Na1_0=1013.15;
  SI.Temperature T_Na1(start = T_Na1_0, nominal = T_Na1_0) "Sodium Hot Fluid Temperature";
  parameter SI.Temperature T_MS1_0=773.15;
  SI.Temperature T_MS1(start=T_MS1_0, nominal = 773.15) "Molten Salt Cold Fluid Temperature";
  parameter SI.Temperature T_MS2_0=993.15;
  SI.Temperature T_MS2(start=T_MS2_0, nominal = 993.15) "Molten Salt Hot Fluid Temperature";
  parameter SI.Temperature T_Na2_0=902.282;
  SI.Temperature T_Na2(start=T_Na2_0, nominal = 942.939) "Sodium Cold Fluid Temperature";
  SI.Pressure p_Na1(start = p_Na1_des, nominal = p_Na1_des) "Sodium Inlet Pressure";
  SI.Pressure p_MS1(start = p_MS1_des, nominal = p_MS1_des) "Molten Salt Inlet Pressure";
  SI.Pressure p_Na2 "Sodium Outlet Pressure";
  SI.Pressure p_MS2 "Molten Salt Outlet Pressure";
  SI.CoefficientOfHeatTransfer U(start = 269.998, nominal = 1257.39) "Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_s(start = 298.267, nominal = 1785.35) "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t(start = 8233.79, nominal = 46553.1) "Tube-side Heat tranfer coefficient";
  SI.HeatFlowRate Q(start = 3.05E+06, nominal =	5.02E+07) "Design Heat Flow Rate";
  Real F(start = 0.1471, nominal = 0.43335) "Temperature correction factor";
  SI.TemperatureDifference DT1(start=20.0068, nominal = 20.0068) "Sodium-Molten Salt temperature difference 1";
  SI.TemperatureDifference DT2(start=129.132, nominal = 169.789) "Sodium-Molten Salt temperature difference 2";
  SI.TemperatureDifference LMTD(start = 58.5195, nominal = 70.0413) "Logarithmic mean temperature difference";
  SI.Pressure Dp_tube(start=80.9775, nominal = 50004.1) "Tube-side pressure drop";
  SI.Pressure Dp_shell(start=84.5984, nominal =	9690.88) "Shell-side pressure drop";
  SI.Velocity v_Na(start=0.0677583, nominal = 2.27265) "Sodium velocity in tubes";
  SI.Velocity v_max_MS(start=0.0309792, nominal = 0.508695) "Molten Salt velocity in shell";
  parameter SI.Temperature T_Na2_min_0=902.282;
  SI.Temperature T_Na2_min(start=T_Na2_min_0, nominal=902.282) "Optimal outlet sodium temperature";
  Boolean low_flow_ON(start=false);
  Boolean low_flow(start=false);
  Boolean up(start=false);
  Boolean down(start=false);
  
  //Fluid Properties
  parameter SI.Temperature Tm_Na_0=957.719;
  SI.Temperature Tm_Na(start = Tm_Na_0, nominal = 978.048) "Mean Sodium Fluid Temperature";
  parameter SI.Temperature Tm_MS_0=883.15;
  SI.Temperature Tm_MS(start = 883.15, nominal = 883.15) "Mean Molten Salts Fluid Temperature";
  SI.ThermalConductivity k_Na "Sodium Conductivity @mean temperature";
  SI.ThermalConductivity k_MS "Molten Salts Conductivity @mean temperature";
  SI.Density rho_Na "Sodium density @mean temperature";
  SI.Density rho_MS "Molten Salts density @mean temperature";
  SI.DynamicViscosity mu_Na "Sodium dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_MS "Molten Salts  dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_Na_wall "Sodium dynamic viscosity @wall temperature";
  SI.DynamicViscosity mu_MS_wall "Molten salts dynamic viscosity @wall temperature";
  SI.SpecificHeatCapacity cp_Na "Sodium specific heat capacity @mean temperature";
  SI.SpecificHeatCapacity cp_MS "Molten Salts specific heat capacity @mean temperature";
  parameter Medium1.ThermodynamicState state_mean_Na_0=Medium1.setState_pTX(p_Na1_des, Tm_Na_0);
  parameter Medium1.ThermodynamicState state_input_Na_0=Medium1.setState_pTX(p_Na1_des, T_Na1_0);
  parameter Medium1.ThermodynamicState state_output_Na_0=Medium1.setState_pTX(p_Na1_des, T_Na2_0);
  parameter Medium1.ThermodynamicState state_min_F_0=Medium1.setState_pTX(p_Na1_des, T_Na2_min_0);
  Medium1.ThermodynamicState state_input_Na;/*(start=state_input_Na_0);*/
  Medium1.ThermodynamicState state_output_Na;/*(start=state_output_Na_0);*/
  Medium1.ThermodynamicState state_mean_Na;/*(start=state_mean_Na_0);*/
  Medium1.ThermodynamicState state_min_F;/*(start=state_min_F_0);*/
  parameter Medium2.ThermodynamicState state_mean_MS_0=Medium2.setState_pTX(p_MS1_des, Tm_MS_0);
  parameter Medium2.ThermodynamicState state_input_MS_0=Medium2.setState_pTX(p_MS1_des, T_MS1_0);
  parameter Medium2.ThermodynamicState state_output_MS_0=Medium2.setState_pTX(p_MS1_des, T_MS2_0);
  parameter Medium2.ThermodynamicState state_wall_MS_0=Medium2.setState_pTX(p_MS1_des, Tm_Na_0);
  Medium2.ThermodynamicState state_mean_MS;/*(start=state_mean_MS_0);*/
  Medium2.ThermodynamicState state_wall_MS;/*(start=state_wall_MS_0);*/
  Medium2.ThermodynamicState state_input_MS;/*(start=state_input_MS_0);*/
  Medium2.ThermodynamicState state_output_MS;/*(start=state_output_MS_0);*/
  //Ports Variables
  SI.SpecificEnthalpy h_Na_in(start=931512, nominal=931512);
  SI.SpecificEnthalpy h_MS_in(start=596541, nominal=596541);
  //Real Input
  Modelica.Blocks.Interfaces.BooleanInput HF_on(start=true) annotation(
    Placement(visible = true, transformation(origin = {26, 46}, extent = {{-6, -6}, {6, 6}}, rotation = -90), iconTransformation(origin = {26, 46}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));

initial algorithm
  if optimize_and_run == true then
    (TAC, A_HX, U_design, N_t, Dp_tube_design, Dp_shell_design, h_s_design, h_t_design, D_s, v_Na_design, v_max_MS_design, V_HX, m_HX, C_BEC_HX, C_pump_design, d_o, L, N_p, layout, T_Na2_design, m_flow_Na_design, m_flow_MS_design, F_design, UA_design, ex_eff_design, en_eff_design) := Find_Opt_Design_HX(Q_d_des = Q_d_des, T_Na1_des = T_Na1_des, T_MS1_des = T_MS1_des, T_MS2_des = T_MS2_des, p_Na1_des = p_Na1_des, p_MS1_des = p_MS1_des);
  else
    d_o := d_o_input;
    L := L_input;
    N_p := N_p_input;
    layout := layout_input;
    T_Na2_design := T_Na2_input;
    (m_flow_Na_design, m_flow_MS_design, F_design, UA_design, N_t, U_design, A_HX, Dp_tube_design, Dp_shell_design, TAC, h_s_design, h_t_design, D_s, v_Na_design, v_max_MS_design, V_HX, m_HX, C_BEC_HX, C_pump_design, ex_eff_design, en_eff_design) := Design_HX(Q_d = Q_d_des, T_Na1 = T_Na1_des, T_MS1 = T_MS1_des, T_MS2 = T_MS2_des, d_o = d_o, L = L, N_p = N_p, layout = layout, T_Na2 = T_Na2_design, p_MS1 = p_MS1_des, p_Na1 = p_Na1_des, c_e = 0.13, r = 0.05, H_y = 4500);
  end if;
  m_flow_Na_min_des := 0.0001 * m_flow_Na_design;
  m_flow_MS_min_des := 0.01 * m_flow_MS_design;
//  T_Na2_min:=627.35+273.15;

algorithm
  if HF_on then
    if m_flow_Na > 0 then
      if m_flow_Na <= m_flow_Na_min_des then
        low_flow := true;
        low_flow_ON := false;
      else
        low_flow := false;
        low_flow_ON := false;
      end if;
//    else
//      low_flow_ON := true;
//      low_flow := false;
    end if;
  else
    low_flow_ON := true;
    low_flow := false;
  end if;
    
equation
  up = if m_flow_Na > pre(m_flow_Na) and low_flow == true then true else false;
  down = if m_flow_Na < pre(m_flow_Na) and low_flow == true then true else false;
//Mass conservation equations
  port_a_in.m_flow + port_a_out.m_flow = 0;
  port_b_in.m_flow + port_b_out.m_flow = 0;
  m_flow_Na = port_a_in.m_flow;
  m_flow_MS = port_b_in.m_flow;
//Fluids Enthalpies
  port_b_out.h_outflow = Medium2.specificEnthalpy(state_output_MS);
  port_a_out.h_outflow = Medium1.specificEnthalpy(state_output_Na);
  h_Na_in = inStream(port_a_in.h_outflow);
  h_MS_in = inStream(port_b_in.h_outflow);
//Shouldn't have reverse flows
  port_a_in.h_outflow = 0.0;
  port_b_in.h_outflow = 0.0;
//Other ports equations
  port_a_out.Xi_outflow = inStream(port_a_in.Xi_outflow);
  port_a_in.Xi_outflow = inStream(port_a_out.Xi_outflow);
  port_b_out.Xi_outflow = inStream(port_b_in.Xi_outflow);
  port_b_in.Xi_outflow = inStream(port_b_out.Xi_outflow);
  port_a_out.C_outflow = inStream(port_a_in.C_outflow);
  port_a_in.C_outflow = inStream(port_a_out.C_outflow);
  port_b_out.C_outflow = inStream(port_b_in.C_outflow);
  port_b_in.C_outflow = inStream(port_b_out.C_outflow);
//Fluid temperatures and pressures
  T_Na1 = Medium1.temperature(state_input_Na);
  T_MS1 = Medium2.temperature(state_input_MS);
  p_Na1 = port_a_in.p;
  p_MS1 = port_b_in.p;
  p_Na2 = port_a_out.p;
  p_MS2 = port_b_out.p;
  p_Na2 = p_Na1;
//-Dp_tube;
  p_MS2 = p_MS1;
//-Dp_shell;
//Molten Salt properties
  Tm_MS = (T_MS1 + T_MS2) / 2;
  state_mean_MS = Medium2.setState_pTX(p_MS1, Tm_MS);
  state_input_MS = Medium2.setState_phX(p_MS1, h_MS_in);
  state_output_MS = Medium2.setState_pTX(p_MS1, T_MS2);
  state_wall_MS = Medium2.setState_pTX(p_MS1, Tm_Na);
  rho_MS = Medium2.density(state_mean_MS);
  cp_MS = Medium2.specificHeatCapacityCp(state_mean_MS);
  mu_MS = Medium2.dynamicViscosity(state_mean_MS);
  k_MS = Medium2.thermalConductivity(state_mean_MS);
  mu_MS_wall = Medium2.dynamicViscosity(state_wall_MS);
//Sodium properties
  Tm_Na = (T_Na1 + T_Na2) / 2;
  state_mean_Na = Medium1.setState_pTX(p_Na1, Tm_Na);
  state_input_Na = Medium1.setState_phX(p_Na1, h_Na_in);
  state_output_Na = Medium1.setState_pTX(p_Na1, T_Na2);
  state_min_F = Medium1.setState_pTX(p_Na1, T_Na2_min);
  rho_Na = Medium1.density(state_mean_Na);
  cp_Na = Medium1.specificHeatCapacityCp(state_mean_Na);
  mu_Na = Medium1.dynamicViscosity(state_mean_Na);
  mu_Na_wall = mu_Na;
  k_Na = Medium1.thermalConductivity(state_mean_Na);
//Problem
  T_Na2_min = if low_flow_ON then T_Na2 else Find_min_TNa2(T_Na1 = T_Na1, T_MS1 = T_MS1, T_MS2 = T_MS2);
  //T_MS2 = if low_flow_ON then T_MS1 else min(T_MS2_des, T_Na1 - 15);
//Imposed value with tollerance
  port_a_out.h_outflow = if low_flow_ON then h_Na_in else max(Medium1.specificEnthalpy(state_min_F), h_Na_in - Q / m_flow_Na);
  m_flow_MS = if low_flow_ON then 0 else if low_flow then max(m_flow_MS_min_des, Q / (port_b_out.h_outflow - h_MS_in)) else Q / (port_b_out.h_outflow - h_MS_in);
  DT1 = T_Na1 - T_MS2;
  DT2 = T_Na2 - T_MS1;
  LMTD = if low_flow_ON then 0 else if noEvent(DT1 / DT2 <= 0) then 0 else (DT1 - DT2) / MA.log(DT1 / DT2);
  F = TempCorrFactor_operating(T_Na1 = T_Na1, T_Na2 = T_Na2, T_MS1 = T_MS1, T_MS2 = T_MS2);
  (U, h_s, h_t) = HTCs(d_o = d_o, N_p = N_p, layout = layout, N_t = N_t, state_mean_Na = state_mean_Na, state_mean_MS = state_mean_MS, state_wall_MS = state_wall_MS, m_flow_Na = m_flow_Na, m_flow_MS = m_flow_MS);
  Q = U * A_HX * F * LMTD;
  (Dp_tube, Dp_shell, v_Na, v_max_MS) = Dp_losses(d_o = d_o, N_p = N_p, layout = layout, N_t = N_t, L = L, state_mean_Na = state_mean_Na, state_mean_MS = state_mean_MS, state_wall_MS = state_wall_MS, m_flow_Na = m_flow_Na, m_flow_MS = m_flow_MS);
end HX_wi;