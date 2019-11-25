within SolarTherm.Models.Fluid.HeatExchangers;

model HX_sa_graphs_Q
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  
  //Design Parameters
  parameter SI.HeatFlowRate Q_d_des[25] = {1e6, 2e6, 3e6, 4e6, 5e6, 10e6, 20e6, 30e6, 40e6, 50e6, 60e6, 70e6, 80e6, 90e6, 100e6, 110e6, 120e6, 130e6, 140e6, 150e6, 160e6, 170e6, 180e6, 190e6, 200e6} "Design Heat Flow Rate";
  parameter SI.Temperature T_Na1_des = 740 + 273.15 "Desing Sodium Hot Fluid Temperature";
  parameter SI.Temperature T_MS1_des = 500 + 273.15 "Desing Molten Salt Cold Fluid Temperature";
  parameter SI.Temperature T_MS2_des = 720 + 273.15 "Desing Molten Salt Hot Fluid Temperature";
  parameter SI.Pressure p_Na1_des = 101325 "Design Sodium Inlet Pressure";
  parameter SI.Pressure p_MS1_des = 101325 "Design Molten Salt Inlet Pressure";
  
  //Auxiliary parameters
//  parameter Boolean optimize_and_run(fixed = false);
//  parameter SI.MassFlowRate m_flow_Na_min_design(fixed = false) "Minimum Sodium mass flow rate";
  parameter Integer dimQ = size(Q_d_des, 1);
  parameter Integer dim_tot = dimQ;
  
//  //Input parameters
//  parameter SI.Length d_o_input = 0.04128 "Optimal Outer Tube Diameter";
//  parameter SI.Length L_input = 8 "Optimal Tube Length";
//  parameter Integer N_p_input = 4 "Optimal Tube passes number";
//  parameter Integer layout_input = 2 "Optimal Tube Layout";
//  parameter SI.Temperature T_Na2_input = 670 + 273.15 "Optimal outlet sodium temperature";
  
//  //Optimal Parameter Values
//  parameter Real TAC(unit = "€/year", fixed = false) "Minimum Total Annualized Cost";
//  parameter SI.Area A_HX(fixed = false) "Optimal Exchange Area";
//  parameter SI.CoefficientOfHeatTransfer U_design(fixed = false) "Optimal Heat tranfer coefficient";
//  parameter Integer N_t(fixed = false) "Optimal Number of tubes";
//  parameter SI.Pressure Dp_tube_design(fixed = false) "Optimal Tube-side pressure drop";
//  parameter SI.Pressure Dp_shell_design(fixed = false) "Optimal Shell-side pressure drop";
//  parameter SI.CoefficientOfHeatTransfer h_s_design(fixed = false) "Optimal Shell-side Heat tranfer coefficient";
//  parameter SI.CoefficientOfHeatTransfer h_t_design(fixed = false) "Optimal Tube-side Heat tranfer coefficient";
//  parameter SI.Length D_s(fixed = false) "Optimal Shell Diameter";
//  parameter SI.Velocity v_Na_design(fixed = false) "Optimal Sodium velocity in tubes";
//  parameter SI.Velocity v_max_MS_design(fixed = false) "Optimal Molten Salt velocity in shell";
//  parameter SI.Volume V_HX(fixed = false) "Optimal Heat-Exchanger Total Volume";
//  parameter SI.Mass m_HX(fixed = false) "Optimal Heat-Exchanger Total Mass";
//  parameter Real C_BEC_HX(unit = "€", fixed = false) "Optimal Bare cost @2018";
//  parameter Real C_pump_design(unit = "€/year", fixed = false) "Optimal Annual pumping cost";
//  parameter SI.Length d_o(fixed = false) "Optimal Outer Tube Diameter";
//  parameter SI.Length L(fixed = false) "Optimal Tube Length";
//  parameter Integer N_p(fixed = false) "Optimal Tube passes number";
//  parameter Integer layout(fixed = false) "Optimal Tube Layout";
//  parameter SI.Temperature T_Na2_design(fixed = false) "Optimal outlet sodium temperature";
//  parameter SI.MassFlowRate m_flow_Na_design(fixed = false) "Optimal Sodium mass flow rate";
//  parameter SI.MassFlowRate m_flow_MS_design(fixed = false) "Optimal Molten-Salt mass flow rate";
//  parameter Real F_design(fixed = false) "Optimal Temperature correction factor";
//  parameter SI.ThermalConductance UA_design(fixed = false) "Optimal UA";
//  parameter Real ex_eff_design(fixed = false) "Optimal HX Exergetic Efficiency";
//  parameter Real en_eff_design(fixed = false) "Optimal HX Energetic Efficiency";
  
  //Optimal Parameter Values
  parameter Real TAC[dim_tot](each fixed=false) "Total Annualized Cost";
  parameter SI.Area A_HX[dim_tot](each fixed=false) "Exchange Area";
  parameter SI.CoefficientOfHeatTransfer U_design[dim_tot](each fixed=false) "Heat tranfer coefficient";
  parameter Integer N_t[dim_tot](each fixed=false) "Number of tubes";
  parameter SI.Pressure Dp_tube_design[dim_tot](each fixed=false) "Tube-side pressure drop";
  parameter SI.Pressure Dp_shell_design[dim_tot](each fixed=false) "Shell-side pressure drop";
  parameter SI.CoefficientOfHeatTransfer h_s_design[dim_tot](each fixed=false) "Shell-side Heat tranfer coefficient";
  parameter SI.CoefficientOfHeatTransfer h_t_design[dim_tot](each fixed=false) "Tube-side Heat tranfer coefficient";
  parameter SI.Length D_s[dim_tot](each fixed=false) "Shell Diameter";
  parameter SI.Velocity v_Na_design[dim_tot](each fixed=false) "Sodium velocity in tubes";
  parameter SI.Velocity v_max_MS_design[dim_tot](each fixed=false) "Molten Salt velocity in shell";
  parameter SI.Volume V_HX[dim_tot](each fixed=false) "Heat-Exchanger Total Volume";
  parameter SI.Mass m_HX[dim_tot](each fixed=false) "Heat-Exchanger Total Mass";
  parameter Real C_BEC_HX[dim_tot](each fixed=false) "Bare cost @2018";
  parameter Real C_pump_design[dim_tot](each fixed=false) "Annual pumping cost";
  parameter SI.Length d_o[dim_tot](each fixed=false) "Optimal Outer Tube Diameter";
  parameter SI.Length L[dim_tot](each fixed=false) "Optimal Tube Length";
  parameter Integer N_p[dim_tot](each fixed=false) "Optimal Tube passes number";
  parameter Integer layout[dim_tot](each fixed=false) "Optimal Tube Layout";
  parameter SI.Temperature T_Na2_design[dim_tot](each fixed=false) "Optimal outlet sodium temperature";
  parameter SI.MassFlowRate m_flow_Na_design[dim_tot](each fixed=false) "Sodium mass flow rate";
  parameter SI.MassFlowRate m_flow_MS_design[dim_tot](each fixed=false) "Molten-Salt mass flow rate";
  parameter Real F_design[dim_tot](each fixed=false) "Temperature correction factor";  
  parameter SI.ThermalConductance UA_design[dim_tot](each fixed=false) "UA";
  parameter Real ex_eff_design[dim_tot](each fixed=false) "HX Exergetic Efficiency";
  parameter Real en_eff_design[dim_tot](each fixed=false) "HX Energetic Efficiency";
  parameter Real ratio[dim_tot](each fixed=false) "HX Energetic Efficiency";
  
initial algorithm
  for ii in 1:dimQ loop
    (TAC[ii], A_HX[ii], U_design[ii], N_t[ii], Dp_tube_design[ii], Dp_shell_design[ii], h_s_design[ii], h_t_design[ii], D_s[ii], v_Na_design[ii], v_max_MS_design[ii], V_HX[ii], m_HX[ii], C_BEC_HX[ii], C_pump_design[ii], d_o[ii], L[ii], N_p[ii], layout[ii], T_Na2_design[ii], m_flow_Na_design[ii], m_flow_MS_design[ii], F_design[ii], UA_design[ii], ex_eff_design[ii], en_eff_design[ii]) := Find_Opt_Design_HX(Q_d_des = Q_d_des[ii], T_Na1_des = T_Na1_des, T_MS1_des = T_MS1_des, T_MS2_des = T_MS2_des, p_Na1_des = p_Na1_des, p_MS1_des = p_MS1_des);
  ratio[ii]:=L[ii]/D_s[ii];
  end for;
end HX_sa_graphs_Q;