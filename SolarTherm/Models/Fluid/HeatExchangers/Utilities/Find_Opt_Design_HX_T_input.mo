within SolarTherm.Models.Fluid.HeatExchangers.Utilities;

function Find_Opt_Design_HX_T_input
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  import FI = SolarTherm.Models.Analysis.Finances;
  
  input SI.HeatFlowRate Q_d_des "Design Heat Flow Rate";
  input SI.Temperature T_Na1_des "Desing Sodium Hot Fluid Temperature";
  input SI.Temperature T_Na2_des "Desing Sodium Cold Fluid Temperature";
  input SI.Temperature T_MS1_des "Desing Molten Salt Cold Fluid Temperature";
  input SI.Temperature T_MS2_des "Desing Molten Salt Hot Fluid Temperature";
  input SI.Pressure p_Na1_des "Design Sodium Inlet Pressure";
  input SI.Pressure p_MS1_des "Design Molten Salt Inlet Pressure";
  input FI.EnergyPrice_kWh c_e "Power cost";
  input Real r "Real interest rate";
  input Real H_y(unit = "h") "Operating hours";
  input Integer n(unit = "years") "Operating years";
  
  output FI.MoneyPerYear TAC_min "Minimum Total Annualized Cost";
  output SI.Area A_tot_opt "Optimal Exchange Area";
  output SI.CoefficientOfHeatTransfer U_opt_des "Optimal Heat tranfer coefficient";
  output Integer N_t_opt "Optimal Number of tubes";
  output SI.Pressure Dp_tube_opt_des "Optimal Tube-side pressure drop";
  output SI.Pressure Dp_shell_opt_des "Optimal Shell-side pressure drop";
  output SI.CoefficientOfHeatTransfer h_s_opt_des "Optimal Shell-side Heat tranfer coefficient";
  output SI.CoefficientOfHeatTransfer h_t_opt_des "Optimal Tube-side Heat tranfer coefficient";
  output SI.Length D_s_opt "Optimal Shell Diameter";
  output Integer N_baffles_opt "Number of Baffles";
  output SI.Velocity v_Na_opt_des "Optimal Sodium velocity in tubes";
  output SI.Velocity v_max_MS_opt_des "Optimal Molten Salt velocity in shell";
  output SI.Volume V_HX_opt_des "Optimal Heat-Exchanger Total Volume";
  output SI.Mass m_HX_opt_des "Optimal Heat-Exchanger Total Mass";
  output SI.Mass m_material_HX_opt_des "Heat-Exchanger Total Mass";
  output FI.Money_USD C_BEC_opt "Optimal Bare cost @2018";
  output FI.MoneyPerYear C_pump_opt_des "Optimal Annual pumping cost";
  output SI.Length d_o_opt "Optimal Outer Tube Diameter";
  output SI.Length L_opt "Optimal Tube Length";
  output Integer N_p_opt "Optimal Tube passes number";
  output Integer layout_opt "Optimal Tube Layout";
  output SI.MassFlowRate m_flow_Na_opt_des "Optimal Sodium mass flow rate";
  output SI.MassFlowRate m_flow_MS_opt_des "Optimal Molten-Salt mass flow rate";
  output Real F_opt_des "Optimal Temperature correction factor";
  output SI.ThermalConductance UA_opt_des "Optimal UA";
  output Real ex_eff_opt_des "Optimal HX Exergetic Efficiency";
  output Real en_eff_opt_des "Optimal HX Energetic Efficiency";
  
protected
  //Sweep Parameters
  parameter SI.Length d_o[19] = {6.35e-3, 9.53e-3, 12.70e-3, 15.88e-3, 19.05e-3, 22.23e-3, 25.40e-3, 28.58e-3, 31.75e-3, 34.93e-3, 38.10e-3, 41.28e-3, 44.45e-3, 47.63e-3, 50.80e-3, 53.98e-3, 57.15e-3, 60.33e-3, 63.50e-3} "Outer Tube Diameter";
  parameter SI.Length L[70] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70} "Tube Length";
  parameter Integer N_p[2] = {1, 2} "Tube passes number";
  parameter Integer layout[2] = {1, 2} "Tube layout";
  
  //Auxiliary parameters
  parameter Integer num_dim = 5;
  parameter Integer dim1 = size(d_o, 1);
  parameter Integer dim2 = size(L, 1);
  parameter Integer dim3 = size(N_p, 1);
  parameter Integer dim4 = size(layout, 1);
  parameter Integer dim_tot = dim1 * dim2 * dim3 * dim4;
  Real vec[dim_tot, num_dim];
  Integer iter;
  Integer result;
  
  //Design Parameters
  SI.MassFlowRate m_flow_Na_des[dim_tot](each fixed = false) "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS_des[dim_tot](each fixed = false) "Molten-Salt mass flow rate";
  Real F_des[dim_tot](each fixed = false) "Temperature correction factor";
  SI.ThermalConductance UA_des[dim_tot](each fixed = false) "UA";
  SI.Area A_tot[dim_tot](each fixed = false) "Exchange Area";
  SI.CoefficientOfHeatTransfer U_des[dim_tot](each fixed = false) "Heat tranfer coefficient";
  Integer N_t[dim_tot](each fixed = false) "Number of tubes";
  SI.Pressure Dp_tube_des[dim_tot](each fixed = false) "Tube-side pressure drop";
  SI.Pressure Dp_shell_des[dim_tot](each fixed = false) "Shell-side pressure drop";
  SI.CoefficientOfHeatTransfer h_s_des[dim_tot](each fixed = false) "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t_des[dim_tot](each fixed = false) "Tube-side Heat tranfer coefficient";
  SI.Length D_s[dim_tot](each fixed = false) "Shell Diameter";
  Integer N_baffles[dim_tot](each fixed = false) "Number of baffles";
  SI.Velocity v_Na_des[dim_tot](each fixed = false) "Sodium velocity in tubes";
  SI.Velocity v_max_MS_des[dim_tot](each fixed = false) "Molten Salt velocity in shell";
  SI.Volume V_HX_des[dim_tot](each fixed = false) "Heat-Exchanger Total Volume";
  SI.Mass m_HX_des[dim_tot](each fixed = false) "Heat-Exchanger Total Mass";
  SI.Mass m_material_HX_des[dim_tot](each fixed = false) "Heat-Exchanger Material Mass";
  FI.Money_USD C_BEC[dim_tot](each fixed = false) "Bare cost @2018";
  FI.MoneyPerYear C_pump_des[dim_tot](each fixed = false) "Annual pumping cost";
  FI.MoneyPerYear TAC_des[dim_tot](each fixed = false) "Total Annualized Cost";
  Real ex_eff_des[dim_tot](each fixed = false) "HX Exergetic Efficiency";
  Real en_eff_des[dim_tot](each fixed = false) "HX Energetic Efficiency";
  
algorithm
  iter := 1;
  for ww in 1:dim4 loop
    for ii in 1:dim3 loop
      for jj in 1:dim2 loop
        for kk in 1:dim1 loop
          vec[iter, 1] := d_o[kk];
          vec[iter, 2] := L[jj];
          vec[iter, 3] := N_p[ii];
          vec[iter, 4] := layout[ww];
          (m_flow_Na_des[iter], m_flow_MS_des[iter], F_des[iter], UA_des[iter], N_t[iter], U_des[iter], A_tot[iter], Dp_tube_des[iter], Dp_shell_des[iter], TAC_des[iter], h_s_des[iter], h_t_des[iter], D_s[iter], N_baffles[iter], v_Na_des[iter], v_max_MS_des[iter], V_HX_des[iter], m_HX_des[iter], m_material_HX_des[iter], C_BEC[iter], C_pump_des[iter], ex_eff_des[iter], en_eff_des[iter]) := Design_HX_noF(Q_d = Q_d_des, T_Na1 = T_Na1_des, T_MS1 = T_MS1_des, T_MS2 = T_MS2_des, d_o = d_o[kk], L = L[jj], N_p = N_p[ii], N_sp = N_p[ii], layout = layout[ww], T_Na2 = T_Na2_des, p_MS1 = p_MS1_des, p_Na1 = p_Na1_des, c_e = c_e, r = r, H_y = H_y, n = n);
          iter := iter + 1;
        end for;
      end for;
    end for;
  end for;
  TAC_min := min(TAC_des);
  result := Vectors.find(TAC_min, TAC_des);
  A_tot_opt := A_tot[result];
  U_opt_des := U_des[result];
  N_t_opt := N_t[result];
  Dp_tube_opt_des := Dp_tube_des[result];
  Dp_shell_opt_des := Dp_shell_des[result];
  h_s_opt_des := h_s_des[result];
  h_t_opt_des := h_t_des[result];
  D_s_opt := D_s[result];
  N_baffles_opt := N_baffles[result];
  v_Na_opt_des := v_Na_des[result];
  v_max_MS_opt_des := v_max_MS_des[result];
  V_HX_opt_des := V_HX_des[result];
  m_HX_opt_des := m_HX_des[result];
  m_material_HX_opt_des := m_material_HX_des[result];
  C_BEC_opt := C_BEC[result];
  C_pump_opt_des := C_pump_des[result];
  d_o_opt := vec[result, 1];
  L_opt := vec[result, 2];
  N_p_opt := integer(vec[result, 3]);
  layout_opt := integer(vec[result, 4]);
  m_flow_Na_opt_des := m_flow_Na_des[result];
  m_flow_MS_opt_des := m_flow_MS_des[result];
  F_opt_des := F_des[result];
  UA_opt_des := UA_des[result];
  ex_eff_opt_des := ex_eff_des[result];
  en_eff_opt_des := en_eff_des[result];
end Find_Opt_Design_HX_T_input;