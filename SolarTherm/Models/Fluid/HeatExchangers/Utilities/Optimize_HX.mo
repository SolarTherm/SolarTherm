within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function Optimize_HX
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
  input FI.MassPrice material_sc /*= 84*/ "Material HX Specific Cost";
  input Real ratio_max;
  input Boolean ratio_cond "Activate ratio constraint";
  input Boolean L_max_cond "Activate maximum HX length constraint";
  input SI.Length L_max_input "Maximum HX length";
  
  output SI.MassFlowRate m_flow_Na "Sodium mass flow rate";
  output SI.MassFlowRate m_flow_MS "Molten-Salt mass flow rate";
  output Real F(unit = "") "Temperature correction factor";
  output SI.ThermalConductance UA "UA";
  output SI.Area A_tot "Exchange Area";
  output SI.CoefficientOfHeatTransfer U "Heat tranfer coefficient";
  output Integer N_t "Number of tubes";
  output SI.Pressure Dp_tube "Tube-side pressure drop";
  output SI.Pressure Dp_shell "Shell-side pressure drop";
  output SI.CoefficientOfHeatTransfer h_s "Shell-side Heat tranfer coefficient";
  output SI.CoefficientOfHeatTransfer h_t "Tube-side Heat tranfer coefficient";
  output SI.Length D_s "Shell Diameter";
  output SI.Length D_s_out "Outer Shell Diameter";
  output Integer N_baffles "Number of baffles";
  output SI.Length l_b "Baffle spacing";
  output SI.Velocity v_Na "Sodium velocity in tubes";
  output SI.Velocity v_max_MS "Molten Salt velocity in shell";
  output SI.Volume V_HX "Heat-Exchanger Total Volume";
  output SI.Mass m_HX "Heat-Exchanger Total Mass";
  output SI.Mass m_material_HX "Heat-Exchanger Material Mass";
  output FI.Money_USD C_BEC "Bare cost @2018";
  output FI.MoneyPerYear C_pump "Annual pumping cost";
  output FI.MoneyPerYear TAC "Total Annualized Cost";
  output Real ex_eff(unit = "") "HX Exergetic Efficiency";
  output Real en_eff(unit = "") "HX Energetic Efficiency";
  output SI.Length L "Tube length";
  output Real ratio;
  output Real penalty;
  output SI.Length d_o_opt "Optimal Outer Tube Diameter";
  output Integer N_p_opt "Optimal Tube passes number";
  output Integer N_sp_opt "Optimal Shell passes number";
  output Integer layout_opt "Optimal Tube Layout";
  output Integer N_t_min "Minimum Number of tubes";
  output Integer N_t_max "Maximum Number of tubes";
  
protected
  //Sweep Parameters
  parameter SI.Length d_o[19] = {6.35e-3, 9.53e-3, 12.70e-3, 15.88e-3, 19.05e-3, 22.23e-3, 25.40e-3, 28.58e-3, 31.75e-3, 34.93e-3, 38.10e-3, 41.28e-3, 44.45e-3, 47.63e-3, 50.80e-3, 53.98e-3, 57.15e-3, 60.33e-3, 63.50e-3} "Outer Tube Diameter";
//  parameter SI.Length d_o[10] = {6.35e-3, 9.53e-3, 12.70e-3, 15.88e-3, 19.05e-3, 22.23e-3, 25.40e-3, 28.58e-3, 31.75e-3, 34.93e-3} "Outer Tube Diameter";
  parameter Integer N_p[2] = {1,2} "Tube passes number";
//  parameter Integer layout[2] = {1,2} "Tube layout";
  parameter Integer layout[1] = {2} "Tube layout";
  
  //Auxiliary parameters
  parameter Integer num_dim = 3;
  parameter Integer dim1 = size(d_o, 1);
  parameter Integer dim2 = size(N_p, 1);
  parameter Integer dim3 = size(layout, 1);
  parameter Integer dim_tot = dim1 * dim2 * dim3;
  Real vec[dim_tot, num_dim];
  Integer iter;
  Integer result;
  parameter Boolean N_t_input_on=false "Activate maximum HX length constraint";
  parameter Integer N_t_input=1 "Number of tubes";
 
  //Design Parameters
  SI.MassFlowRate m_flow_Na_vec[dim_tot] "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS_vec[dim_tot] "Molten-Salt mass flow rate";
  Real F_vec[dim_tot] "Temperature correction factor";
  SI.ThermalConductance UA_vec[dim_tot] "UA";
  SI.Area A_vec[dim_tot] "Exchange Area";
  SI.CoefficientOfHeatTransfer U_vec[dim_tot] "Heat tranfer coefficient";
  Integer N_t_vec[dim_tot] "Number of tubes";
  SI.Pressure Dp_tube_vec[dim_tot] "Tube-side pressure drop";
  SI.Pressure Dp_shell_vec[dim_tot] "Shell-side pressure drop";
  SI.CoefficientOfHeatTransfer h_s_vec[dim_tot] "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t_vec[dim_tot] "Tube-side Heat tranfer coefficient";
  SI.Length D_s_vec[dim_tot] "Shell Diameter";
  SI.Length D_s_out_vec[dim_tot] "Shell Diameter";
  Integer N_baffles_vec[dim_tot] "Number of baffles";
  SI.Length l_b_vec[dim_tot];
  SI.Velocity v_Na_vec[dim_tot] "Sodium velocity in tubes";
  SI.Velocity v_max_MS_vec[dim_tot] "Molten Salt velocity in shell";
  SI.Volume V_HX_vec[dim_tot] "Heat-Exchanger Total Volume";
  SI.Mass m_HX_vec[dim_tot] "Heat-Exchanger Total Mass";
  SI.Mass m_material_HX_vec[dim_tot] "Heat-Exchanger Material Mass";
  FI.Money_USD C_BEC_vec[dim_tot] "Bare cost @2018";
  FI.MoneyPerYear C_pump_vec[dim_tot] "Annual pumping cost";
  FI.MoneyPerYear TAC_vec[dim_tot] "Total Annualized Cost";
  Real ex_eff_vec[dim_tot] "HX Exergetic Efficiency";
  Real en_eff_vec[dim_tot] "HX Energetic Efficiency";
  SI.Length L_vec[dim_tot];
  Real ratio_vec[dim_tot];
  FI.MoneyPerYear penalty_vec[dim_tot] "penalty";   
  Integer N_t_min_vec[dim_tot] "Minimum Number of tubes";
  Integer N_t_max_vec[dim_tot] "Maximum Number of tubes";
  
algorithm
  iter := 1;
  for ww in 1:dim3 loop
    for ii in 1:dim2 loop
      for kk in 1:dim1 loop
        vec[iter, 1] := d_o[kk];
        vec[iter, 2] := N_p[ii];
        vec[iter, 3] := layout[ww];
        (m_flow_Na_vec[iter], m_flow_MS_vec[iter], F_vec[iter], UA_vec[iter], A_vec[iter], U_vec[iter], N_t_vec[iter], Dp_tube_vec[iter], Dp_shell_vec[iter], h_s_vec[iter], h_t_vec[iter], D_s_vec[iter], D_s_out_vec[iter], N_baffles_vec[iter], l_b_vec[iter], v_Na_vec[iter], v_max_MS_vec[iter], V_HX_vec[iter], m_HX_vec[iter], m_material_HX_vec[iter], C_BEC_vec[iter], C_pump_vec[iter], TAC_vec[iter], ex_eff_vec[iter], en_eff_vec[iter], L_vec[iter], ratio_vec[iter], penalty_vec[iter], N_t_min_vec[iter], N_t_max_vec[iter]) := Design_HX(Q_d = Q_d_des, T_Na1 = T_Na1_des, T_MS1 = T_MS1_des, T_MS2 = T_MS2_des, d_o = d_o[kk], N_p = N_p[ii], N_sp = N_p[ii], layout = layout[ww], T_Na2 = T_Na2_des, p_MS1 = p_MS1_des, p_Na1 = p_Na1_des, c_e = c_e, r = r, H_y = H_y, n = n, material_sc = material_sc, ratio_max=ratio_max, ratio_cond=ratio_cond, L_max_cond=L_max_cond, L_max_input=L_max_input, N_t_input_on=N_t_input_on, N_t_input=N_t_input);              
        iter := iter + 1;
      end for;
    end for;
  end for;
  
  TAC := min(TAC_vec);
  result := Vectors.find(TAC, TAC_vec);
  A_tot := A_vec[result];
  U := U_vec[result];
  N_t := N_t_vec[result];
  m_flow_Na := m_flow_Na_vec[result];
  m_flow_MS := m_flow_MS_vec[result];
  F := F_vec[result];
  UA := UA_vec[result];
  L:=L_vec[result];
  Dp_tube := Dp_tube_vec[result];
  Dp_shell := Dp_shell_vec[result];
  h_s := h_s_vec[result];
  h_t := h_t_vec[result];
  D_s := D_s_vec[result];
  D_s_out := D_s_out_vec[result];
  N_baffles := N_baffles_vec[result];
  l_b:=l_b_vec[result];
  v_Na := v_Na_vec[result];
  v_max_MS := v_max_MS_vec[result];
  V_HX := V_HX_vec[result];
  m_HX := m_HX_vec[result];
  m_material_HX := m_material_HX_vec[result];
  C_BEC := C_BEC_vec[result];
  C_pump := C_pump_vec[result];
  ex_eff:= ex_eff_vec[result];
  en_eff := en_eff_vec[result];
  ratio:= ratio_vec[result];
  penalty:=penalty_vec[result];
  d_o_opt := vec[result, 1];
  N_p_opt := integer(vec[result, 2]);
  N_sp_opt := integer(vec[result, 2]);
  layout_opt := integer(vec[result, 3]);
  N_t_min:=N_t_min_vec[result];
  N_t_max:=N_t_max_vec[result];
  
end Optimize_HX;
