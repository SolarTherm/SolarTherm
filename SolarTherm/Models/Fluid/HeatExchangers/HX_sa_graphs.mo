within SolarTherm.Models.Fluid.HeatExchangers;

model HX_sa_graphs
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  
  //Design Parameters
  parameter SI.HeatFlowRate Q_d_des = 70e6 "Design Heat Flow Rate";
  parameter SI.Temperature T_Na1_des = 740 + 273.15 "Desing Sodium Hot Fluid Temperature";
  parameter SI.Temperature T_MS1_des = 500 + 273.15 "Desing Molten Salt Cold Fluid Temperature";
  parameter SI.Temperature T_MS2_des = 720 + 273.15 "Desing Molten Salt Hot Fluid Temperature";
  parameter SI.Pressure p_Na1_des = 101325 "Design Sodium Inlet Pressure";
  parameter SI.Pressure p_MS1_des = 101325 "Design Molten Salt Inlet Pressure";
  
  //Auxiliary parameters
  parameter Boolean optimize_and_run(fixed = false);
  parameter SI.MassFlowRate m_flow_Na_min_design(fixed = false) "Minimum Sodium mass flow rate";
  
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

initial algorithm
  optimize_and_run := true;
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
  m_flow_Na_min_design := 0.05 * m_flow_Na_design;

end HX_sa_graphs;