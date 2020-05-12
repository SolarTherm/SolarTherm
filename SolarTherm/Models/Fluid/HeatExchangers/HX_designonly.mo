within SolarTherm.Models.Fluid.HeatExchangers;
model HX_designonly
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  import UF = SolarTherm.Models.Fluid.HeatExchangers.Utilities;
  import FI = SolarTherm.Models.Analysis.Finances;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  
  //Design Parameters
  parameter SI.HeatFlowRate Q_d_des = 536.246e6 "Design Heat Flow Rate";
  parameter SI.Temperature T_Na1_des = 740 + 273.15 "Desing Sodium Hot Fluid Temperature";
  parameter SI.Temperature T_MS1_des = 500 + 273.15 "Desing Molten Salt Cold Fluid Temperature";
  parameter SI.Temperature T_MS2_des = 720 + 273.15 "Desing Molten Salt Hot Fluid Temperature";
  parameter SI.Pressure p_Na1_des = 101325 "Design Sodium Inlet Pressure";
  parameter SI.Pressure p_MS1_des = 101325 "Design Molten Salt Inlet Pressure";
  
  //Input parameters
  parameter SI.Temperature T_Na2_input = 520 + 273.15 "Optimal outlet sodium temperature";
  //Use ratio_cond to constrain the design of the HX: if "true" the HX will be forced to have L/D_s aspect ratio<ratio_max.
  parameter Boolean ratio_cond = true "Activate ratio constraint";  //Default value = true
  parameter Real ratio_max = 10 "Maximum L/D_s ratio"; //If ratio_cond = true provide a value (default value = 10)
  //Use it to constrain the design of the HX: if "true" the HX will be forced to have L<L_max.
  parameter Boolean L_max_cond = false "Activate maximum HX length constraint"; //Default value = false
  parameter SI.Length L_max_input = 1 "Maximum HX length"; //If L_max_cond = true provide a value (default value = 10)
  //If optimize_and_run is "true", d_o, N_p and layout will be chosen as results of the optimization, otherwise provide the following input values:
  parameter Boolean optimize_and_run = true; 
  parameter SI.Length d_o_input = 0.00635 "Optimal Outer Tube Diameter";
  parameter Integer N_p_input = 1 "Optimal Tube passes number";
  parameter Integer layout_input = 2 "Optimal Tube Layout";
  
  /***************************************************************************************************************************/
  //Auxiliary parameters
  parameter FI.EnergyPrice_kWh c_e = 0.13 / 0.9175 "Power cost";
  parameter Real r = 0.05 "Real interest rate";
  parameter Real H_y(unit = "h") = 4500 "Operating hours";
  parameter Integer n(unit = "h") = 30 "Operating years";
  
  //Optimal Parameter Values
  parameter SI.MassFlowRate m_flow_Na_design(fixed = false)"Sodium mass flow rate";
  parameter SI.MassFlowRate m_flow_MS_design(fixed = false) "Molten-Salt mass flow rate";
  parameter Real F_design(fixed = false) "Temperature correction factor";
  parameter SI.ThermalConductance UA_design(fixed = false) "UA";
  parameter Integer N_t(fixed = false) "Number of tubes";
  parameter SI.CoefficientOfHeatTransfer U_design(fixed = false) "Heat tranfer coefficient";
  parameter SI.Area A_HX(fixed = false) "Exchange Area";
  parameter SI.Pressure Dp_tube_design(fixed = false) "Tube-side pressure drop";
  parameter SI.Pressure Dp_shell_design(fixed = false) "Shell-side pressure drop";
  parameter FI.MoneyPerYear TAC(fixed = false) "Total Annualized Cost";
  parameter SI.CoefficientOfHeatTransfer h_s_design(fixed = false) "Shell-side Heat tranfer coefficient";
  parameter SI.CoefficientOfHeatTransfer h_t_design(fixed = false) "Tube-side Heat tranfer coefficient";
  parameter SI.Length D_s(fixed = false) "Shell Diameter";
  parameter SI.Length D_s_out(fixed = false) "Outer Shell Diameter";
  parameter Integer N_baffles(fixed = false) "Number of baffles";
  parameter SI.Length l_b(fixed = false) "Baffle spacing";
  parameter SI.Velocity v_Na_design(fixed = false) "Sodium velocity in tubes";
  parameter SI.Velocity v_max_MS_design(fixed = false) "Molten Salt velocity in shell";
  parameter SI.Volume V_HX(fixed = false) "Heat-Exchanger Total Volume";
  parameter SI.Mass m_HX(fixed = false) "Heat-Exchanger Total Mass";
  parameter SI.Mass m_material_HX(fixed = false) "Heat-Exchanger Material Mass";
  parameter FI.Money_USD C_BEC_HX(fixed = false) "Bare cost @2018";
  parameter FI.MoneyPerYear C_pump_design(fixed = false) "Annual pumping cost";
  parameter Real ex_eff_design(fixed = false) "HX Exergetic Efficiency";
  parameter Real en_eff_design(fixed = false) "HX Energetic Efficiency";
  parameter SI.Length L(fixed = false) "Tube length";
  parameter Real ratio_HX(fixed = false) ;
  parameter Real penalty(fixed = false) ;
  
  parameter FI.AreaPrice sc_A(fixed = false) "HX Specific Cost - Area";
  parameter FI.MassPrice sc_m(fixed = false) "HX Specific Cost - Mass";
  parameter Real sc_cap(fixed = false) "HX Specific Cost - Capacity";
  parameter SI.Length d_o(fixed = false) "Optimal Outer Tube Diameter";
  parameter Integer N_p(fixed = false) "Optimal Tube passes number";
  parameter Integer N_sp(fixed = false) "Optimal Tube passes number";
  parameter Integer layout(fixed = false) "Optimal Tube Layout";
  parameter SI.Temperature T_Na2_design(fixed = false) "Optimal outlet sodium temperature";
  
initial algorithm
  if optimize_and_run == true then
    T_Na2_design := T_Na2_input;
    (m_flow_Na_design, m_flow_MS_design, F_design, UA_design, A_HX, U_design, N_t, Dp_tube_design, Dp_shell_design, h_s_design, h_t_design, D_s, D_s_out, N_baffles, l_b, v_Na_design, v_max_MS_design, V_HX, m_HX, m_material_HX, C_BEC_HX, C_pump_design, TAC, ex_eff_design, en_eff_design, L, ratio_HX, penalty, d_o, N_p, N_sp, layout):= UF.Optimize_HX(Q_d_des = Q_d_des, T_Na1_des = T_Na1_des, T_Na2_des = T_Na2_design, T_MS1_des = T_MS1_des, T_MS2_des = T_MS2_des, p_Na1_des = p_Na1_des, p_MS1_des = p_MS1_des, c_e = c_e, r = r, H_y = H_y, n = n, ratio_max=ratio_max, ratio_cond=ratio_cond, L_max_cond=L_max_cond, L_max_input=L_max_input);
    sc_A := C_BEC_HX / A_HX;
    sc_m := C_BEC_HX / m_material_HX;
    sc_cap := C_BEC_HX / Q_d_des * 10 ^ 3;
  else
    d_o:=d_o_input;
    N_p:=N_p_input;
    N_sp:=N_p_input;
    layout:=layout_input;
    T_Na2_design := T_Na2_input;
    (m_flow_Na_design, m_flow_MS_design, F_design, UA_design, A_HX, U_design, N_t, Dp_tube_design, Dp_shell_design, h_s_design, h_t_design, D_s, D_s_out, N_baffles, l_b, v_Na_design, v_max_MS_design, V_HX, m_HX, m_material_HX, C_BEC_HX, C_pump_design, TAC, ex_eff_design, en_eff_design, L, ratio_HX, penalty):= UF.Design_HX(Q_d = Q_d_des, T_Na1 = T_Na1_des, T_MS1 = T_MS1_des, T_MS2 = T_MS2_des, d_o = d_o, N_p = N_p, N_sp = N_sp, layout = layout, T_Na2 = T_Na2_design, p_MS1 = p_MS1_des, p_Na1 = p_Na1_des, c_e = c_e, r = r, H_y = H_y, n = n, ratio_max=ratio_max, ratio_cond=ratio_cond, L_max_cond=L_max_cond, L_max_input=L_max_input);            
    sc_A := C_BEC_HX / A_HX;
    sc_m := C_BEC_HX / m_material_HX;
    sc_cap := C_BEC_HX / Q_d_des * 10 ^ 3;    
  end if;

end HX_designonly;