within SolarTherm.Models.Fluid.HeatExchangers;

model HX_standalone_Final
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
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
  parameter Boolean optimize_and_run(fixed = false);
  parameter Real m_flow_min_frac = 0;
  parameter Real m_flow_max_frac = 1.1;
  parameter SI.MassFlowRate m_flow_Na_min_design(fixed = false) "Minimum Sodium mass flow rate";
  parameter SI.MassFlowRate m_flow_MS_min_design(fixed = false) "Minimum MS mass flow rate";
  parameter SI.MassFlowRate m_flow_min_Na(fixed = false) "Minimum Sodium mass flow rate";
  parameter SI.MassFlowRate m_flow_max_Na(fixed = false) "Maximum Sodium mass flow rate";
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
  SI.MassFlowRate m_flow_Na(min = 0, start = 17.1174, nominal = 17.1174) "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS(min = 0, start = 10.1462, nominal = 10.1462) "Molten Salt mass flow rate";
  SI.Temperature T_Na1(start = T_Na1_des, nominal = T_Na1_des) "Sodium Hot Fluid Temperature";
  SI.Temperature T_MS1(start = T_MS1_des, nominal = T_MS1_des) "Molten Salt Cold Fluid Temperature";
  SI.Temperature T_MS2(start = T_MS2_des, nominal = T_MS2_des) "Molten Salt Hot Fluid Temperature";
  SI.Temperature T_Na2(start = 628.252 + 273.15, nominal = 628.252 + 273.15) "Sodium Cold Fluid Temperature";
  SI.Pressure p_Na1(start = p_Na1_des, nominal = p_Na1_des) "Sodium Inlet Pressure";
  SI.Pressure p_MS1(start = p_MS1_des, nominal = p_MS1_des) "Molten Salt Inlet Pressure";
  SI.CoefficientOfHeatTransfer U(start = 234.407, nominal = 234.407) "Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_s(start = 235.936, nominal = 235.936) "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t(start = 8092.03, nominal = 8092.03) "Tube-side Heat tranfer coefficient";
  SI.HeatFlowRate Q(start = 2.39E+06, nominal = 2.39E+06) "Design Heat Flow Rate";
  Real F(start = 0.133385, nominal = 0.133385) "Temperature correction factor";
  SI.TemperatureDifference DT1(start = 20, nominal = 20) "Sodium-Molten Salt temperature difference 1";
  SI.TemperatureDifference DT2(start = 128.252, nominal = 128.252) "Sodium-Molten Salt temperature difference 2";
  SI.TemperatureDifference LMTD(start = 58.2543, nominal = 58.2543) "Logarithmic mean temperature difference";
  SI.Pressure Dp_tube "Tube-side pressure drop";
  SI.Pressure Dp_shell "Shell-side pressure drop";
  SI.Velocity v_Na "Sodium velocity in tubes";
  SI.Velocity v_max_MS "Molten Salt velocity in shell";
  Boolean low_flow;
  Boolean low_flow_up;
  Boolean low_flow_down;
  Boolean F_problem;
  //Fluid Properties
  SI.Temperature Tm_Na(start = 684.126 + 273.15, nominal = 684.126 + 273.15) "Mean Sodium Fluid Temperature";
  SI.Temperature Tm_MS(start = 610 + 273.15, nominal = 610 + 273.15) "Mean Molten Salts Fluid Temperature";
  SI.ThermalConductivity k_Na(start = 55.953) "Sodium Conductivity @mean temperature";
  SI.ThermalConductivity k_MS(start = 0.447185) "Molten Salts Conductivity @mean temperature";
  SI.Density rho_Na(start = 791.173) "Sodium density @mean temperature";
  SI.Density rho_MS(start = 1634.34) "Molten Salts density @mean temperature";
  SI.DynamicViscosity mu_Na(start = 0.000188682) "Sodium dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_MS(start = 0.00341597) "Molten Salts  dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_Na_wall(start = 0.000188682) "Sodium dynamic viscosity @wall temperature";
  SI.DynamicViscosity mu_MS_wall(start = 0.00283261) "Molten salts dynamic viscosity @wall temperature";
  SI.SpecificHeatCapacity cp_Na(start = 1251.42) "Sodium specific heat capacity @mean temperature";
  SI.SpecificHeatCapacity cp_MS(start = 1072.4) "Molten Salts specific heat capacity @mean temperature";
  //  //Variables
  //  SI.MassFlowRate m_flow_Na(min = 0, start = 13.8081, nominal = 13.8081) "Sodium mass flow rate";
  //  SI.MassFlowRate m_flow_MS(min = 0, start = 8.2236, nominal = 8.2236) "Molten Salt mass flow rate";
  //  SI.Temperature T_Na1(start = T_Na1_des, nominal = T_Na1_des) "Sodium Hot Fluid Temperature";
  //  SI.Temperature T_MS1(start = T_MS1_des, nominal = T_MS1_des) "Molten Salt Cold Fluid Temperature";
  //  SI.Temperature T_MS2(start = T_MS2_des, nominal = T_MS2_des) "Molten Salt Hot Fluid Temperature";
  //  SI.Temperature T_Na2(start = 627.719+273.15, nominal = 627.719+273.15) "Sodium Cold Fluid Temperature";
  //  SI.Pressure p_Na1(start = p_Na1_des, nominal = p_Na1_des) "Sodium Inlet Pressure";
  //  SI.Pressure p_MS1(start = p_MS1_des, nominal = p_MS1_des) "Molten Salt Inlet Pressure";
  //  SI.CoefficientOfHeatTransfer U(start = 207.055, nominal = 207.055) "Heat tranfer coefficient";
  //  SI.CoefficientOfHeatTransfer h_s(start = 223.486, nominal = 223.486) "Shell-side Heat tranfer coefficient";
  //  SI.CoefficientOfHeatTransfer h_t(start = 8003.99, nominal = 8003.99) "Tube-side Heat tranfer coefficient";
  //  SI.HeatFlowRate Q(start = 1.94E+06, nominal = 1.94E+06) "Design Heat Flow Rate";
  //  Real F(start = 0.122721, nominal = 0.122721) "Temperature correction factor";
  //  SI.TemperatureDifference DT1(start = 20, nominal = 20) "Sodium-Molten Salt temperature difference 1";
  //  SI.TemperatureDifference DT2(start = 127.719, nominal = 127.719) "Sodium-Molten Salt temperature difference 2";
  //  SI.TemperatureDifference LMTD(start=58.0979, nominal=58.0979) "Logarithmic mean temperature difference";
  //  //SI.Pressure Dp_tube "Tube-side pressure drop";
  //  //SI.Pressure Dp_shell "Shell-side pressure drop";
  //  //SI.Velocity v_Na "Sodium velocity in tubes";
  //  //SI.Velocity v_max_MS "Molten Salt velocity in shell";
  //  Boolean low_flow;
  //  Boolean low_flow_up;
  //  Boolean low_flow_down;
  //  Boolean F_problem;
  //  //Fluid Properties
  //  SI.Temperature Tm_Na(start = 683.86 + 273.15, nominal = (670 + 740) / 2 + 273.15) "Mean Sodium Fluid Temperature";
  //  SI.Temperature Tm_MS(start = 610 + 273.15, nominal = (500 + 720) / 2 + 273.15) "Mean Molten Salts Fluid Temperature";
  //  SI.ThermalConductivity k_Na(start=55.953) "Sodium Conductivity @mean temperature";
  //  SI.ThermalConductivity k_MS(start=0.447185) "Molten Salts Conductivity @mean temperature";
  //  SI.Density rho_Na(start=791.173) "Sodium density @mean temperature";
  //  SI.Density rho_MS(start=1634.34) "Molten Salts density @mean temperature";
  //  SI.DynamicViscosity mu_Na(start=0.000188682) "Sodium dynamic viscosity @mean temperature";
  //  SI.DynamicViscosity mu_MS(start=0.00341597) "Molten Salts  dynamic viscosity @mean temperature";
  //  SI.DynamicViscosity mu_Na_wall(start=0.000188682) "Sodium dynamic viscosity @wall temperature";
  //  SI.DynamicViscosity mu_MS_wall(start=0.00283261) "Molten salts dynamic viscosity @wall temperature";
  //  SI.SpecificHeatCapacity cp_Na(start=1251.42) "Sodium specific heat capacity @mean temperature";
  //  SI.SpecificHeatCapacity cp_MS(start=1072.4) "Molten Salts specific heat capacity @mean temperature";
  Medium1.ThermodynamicState state_mean_Na;
  Medium1.ThermodynamicState state_input_Na;
  Medium1.ThermodynamicState state_output_Na;
  Medium2.ThermodynamicState state_mean_MS;
  Medium2.ThermodynamicState state_wall_MS;
  Medium2.ThermodynamicState state_input_MS;
  Medium2.ThermodynamicState state_output_MS;
initial algorithm
  optimize_and_run := false;
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
  m_flow_Na_min_design := 0.03 * m_flow_Na_design;
  m_flow_MS_min_design := 0.04 * m_flow_MS_design;
  m_flow_min_Na := m_flow_min_frac * m_flow_Na_design;
//To remove in the HX real model
  m_flow_max_Na := 1.1 * m_flow_Na_design;
//To remove in the HX real model
equation
  p_MS1 = 101325;
//Substitute with inlet pressure
  p_Na1 = 101325;
//Substitute with inlet pressure
  T_Na1 = 740 + 273.15;
//Substitute with inlet temperature
  T_MS1 = 500 + 273.15;
//Substitute with inlet temperature
//m_flow_Na = (-(m_flow_max_Na - m_flow_min_Na) * time) + m_flow_max_Na; //Substitute with inlet flow rate
  m_flow_Na = m_flow_min_Na + (m_flow_max_Na - m_flow_min_Na) * time;
//Substitute with inlet flow rate
//m_flow_Na = 13.8;
//Molten Salt properties
  Tm_MS = (T_MS1 + T_MS2) / 2;
  state_mean_MS = Medium2.setState_pTX(p_MS1, Tm_MS);
  state_input_MS = Medium2.setState_pTX(p_MS1, T_MS1);
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
  state_input_Na = Medium1.setState_pTX(p_Na1, T_Na1);
  state_output_Na = Medium1.setState_pTX(p_Na1, T_Na2);
  rho_Na = Medium1.density(state_mean_Na);
  cp_Na = Medium1.specificHeatCapacityCp(state_mean_Na);
  mu_Na = Medium1.dynamicViscosity(state_mean_Na);
  mu_Na_wall = mu_Na;
  k_Na = Medium1.thermalConductivity(state_mean_Na);
//Problem
  if noEvent(m_flow_Na <= m_flow_Na_min_design) then
//or noEvent(m_flow_MS<=m_flow_MS_min_design) then
    if noEvent(m_flow_Na <= pre(m_flow_Na)) then
//or noEvent(m_flow_MS<pre(m_flow_MS))) then
      low_flow_down = true;
      low_flow_up = false;
    else
      low_flow_up = true;
      low_flow_down = false;
    end if;
  else
    if F_problem == true then
      if noEvent(m_flow_Na <= pre(m_flow_Na)) then
//or noEvent(m_flow_MS<pre(m_flow_MS))) then
        low_flow_down = true;
        low_flow_up = false;
      else
        low_flow_up = false;
        low_flow_down = false;
      end if;
    else
      low_flow_up = false;
      low_flow_down = false;
    end if;
  end if;
  low_flow = if low_flow_up == true or low_flow_down == true then true else false;
  if low_flow then
    T_MS2 = T_MS1_des;
    LMTD = 0;
    T_Na1 = T_Na2;
    m_flow_MS = 1e-6;
  else
    T_MS2 = min(T_MS2_des, T_Na1 - 15);
    LMTD = (DT1 - DT2) / MA.log(DT1 / DT2);
    T_Na2 = T_Na1 - Q / (m_flow_Na * cp_Na);
    m_flow_MS = Q / (cp_MS * (T_MS2 - T_MS1));
  end if;
  DT1 = T_Na1 - T_MS2;
  DT2 = T_Na2 - T_MS1;
  (F, F_problem) = TempCorrFactor_operating(T_Na1 = T_Na1, T_Na2 = T_Na2, T_MS1 = T_MS1, T_MS2 = T_MS2);
  (U, h_s, h_t) = HTCs(d_o = d_o, N_p = N_p, layout = layout, N_t = N_t, state_mean_Na = state_mean_Na, state_mean_MS = state_mean_MS, state_wall_MS = state_wall_MS, m_flow_Na = m_flow_Na, m_flow_MS = m_flow_MS);
  Q = U * A_HX * F * LMTD;
  (Dp_tube, Dp_shell, v_Na, v_max_MS) = Dp_losses(d_o = d_o, N_p = N_p, layout = layout, N_t = N_t, L = L, state_mean_Na = state_mean_Na, state_mean_MS = state_mean_MS, state_wall_MS = state_wall_MS, m_flow_Na = m_flow_Na, m_flow_MS = m_flow_MS);
end HX_standalone_Final;