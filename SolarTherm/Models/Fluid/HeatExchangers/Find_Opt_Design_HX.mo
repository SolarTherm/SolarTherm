within SolarTherm.Models.Fluid.HeatExchangers;
function Find_Opt_Design_HX
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  
  input SI.HeatFlowRate Q_d_des "Design Heat Flow Rate";
  input SI.Temperature T_Na1_des "Desing Sodium Hot Fluid Temperature";
  input SI.Temperature T_MS1_des "Desing Molten Salt Cold Fluid Temperature";
  input SI.Temperature T_MS2_des "Desing Molten Salt Hot Fluid Temperature";
  input SI.Pressure p_Na1_des "Design Sodium Inlet Pressure";
  input SI.Pressure p_MS1_des "Design Molten Salt Inlet Pressure";
  
  output Real TAC_min(unit = "€/year") "Minimum Total Annualized Cost";
  output SI.Area A_tot_opt "Optimal Exchange Area";
  output SI.CoefficientOfHeatTransfer U_opt_des "Optimal Heat tranfer coefficient";
  output Integer N_t_opt "Optimal Number of tubes";
  output SI.Pressure Dp_tube_opt_des "Optimal Tube-side pressure drop";
  output SI.Pressure Dp_shell_opt_des "Optimal Shell-side pressure drop";
  output SI.CoefficientOfHeatTransfer h_s_opt_des "Optimal Shell-side Heat tranfer coefficient";
  output SI.CoefficientOfHeatTransfer h_t_opt_des "Optimal Tube-side Heat tranfer coefficient";
  output SI.Length D_s_opt "Optimal Shell Diameter";
  output SI.Velocity v_Na_opt_des "Optimal Sodium velocity in tubes";
  output SI.Velocity v_max_MS_opt_des "Optimal Molten Salt velocity in shell";
  output SI.Volume V_HX_opt_des "Optimal Heat-Exchanger Total Volume";
  output SI.Mass m_HX_opt_des "Optimal Heat-Exchanger Total Mass";
  output Real C_BEC_opt(unit = "€") "Optimal Bare cost @2018";
  output Real C_pump_opt_des(unit = "€/year") "Optimal Annual pumping cost";
  output SI.Length d_o_opt "Optimal Outer Tube Diameter";
  output SI.Length L_opt "Optimal Tube Length";
  output Integer N_p_opt "Optimal Tube passes number";
  output Integer layout_opt "Optimal Tube Layout";
  output SI.Temperature T_Na2_opt_des "Optimal outlet sodium temperature";
  output SI.MassFlowRate m_flow_Na_opt_des "Optimal Sodium mass flow rate";
  output SI.MassFlowRate m_flow_MS_opt_des "Optimal Molten-Salt mass flow rate";
  output Real F_opt_des "Optimal Temperature correction factor";
  output SI.ThermalConductance UA_opt_des "Optimal UA";
  output Real ex_eff_opt_des "Optimal HX Exergetic Efficiency";
  output Real en_eff_opt_des "Optimal HX Energetic Efficiency";

  protected
  //Sweep Parameters
  parameter SI.Length d_o[19] = {6.35e-3,9.53e-3,12.70e-3,15.88e-3,19.05e-3,22.23e-3,25.40e-3,28.58e-3,31.75e-3,34.93e-3,38.10e-3,41.28e-3,44.45e-3,47.63e-3,50.80e-3,53.98e-3,57.15e-3,60.33e-3,63.50e-3} "Outer Tube Diameter";
  parameter SI.Length L[11]={2,4,6,8,10,12,14,16,18,20,22} "Tube Length";
  parameter Integer N_p[2]={4,8} "Tube passes number";
  parameter Integer layout[2]={1,2} "Tube layout";
  //parameter SI.Temperature T_Na2_des[19] = {520+273.15, 530+273.15, 540+273.15, 550+273.15, 560+273.15, 570+273.15, 580+273.15, 590+273.15, 600+273.15, 610+273.15, 620+273.15, 630+273.15, 640+273.15, 650+273.15, 660+273.15, 670+273.15, 680+273.15, 690+273.15, 700+273.15} "Sodium Cold Fluid Temperature";
  parameter SI.Temperature T_Na2_des[11] = {630+273.15,640+273.15,650+273.15,660+273.15,670+273.15,680+273.15,690+273.15,700+273.15,710+273.15,720+273.15,730+273.15} "Sodium Cold Fluid Temperature";

  //Auxiliary parameters
  parameter Integer num_dim = 5;
  parameter Integer dim1 = size(d_o, 1);
  parameter Integer dim2 = size(L, 1);
  parameter Integer dim3 = size(N_p, 1);
  parameter Integer dim4 = size(layout, 1);
  parameter Integer dim5 = size(T_Na2_des, 1);
  parameter Integer dim_tot = dim1 * dim2 * dim3 * dim4 * dim5;
  Real vec[dim_tot, num_dim];
  Integer iter;
  Integer result; //Maybe it should be a variable
  
  //Design Parameters
  SI.MassFlowRate m_flow_Na_des[dim_tot](each fixed=false) "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS_des[dim_tot](each fixed=false) "Molten-Salt mass flow rate";
  Real F_des[dim_tot](each fixed=false) "Temperature correction factor";  
  SI.ThermalConductance UA_des[dim_tot](each fixed=false) "UA";
  SI.Area A_tot[dim_tot](each fixed=false) "Exchange Area";
  SI.CoefficientOfHeatTransfer U_des[dim_tot](each fixed=false) "Heat tranfer coefficient";
  Integer N_t[dim_tot](each fixed=false) "Number of tubes";
  SI.Pressure Dp_tube_des[dim_tot](each fixed=false) "Tube-side pressure drop";
  SI.Pressure Dp_shell_des[dim_tot](each fixed=false) "Shell-side pressure drop";
  SI.CoefficientOfHeatTransfer h_s_des[dim_tot](each fixed=false) "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t_des[dim_tot](each fixed=false) "Tube-side Heat tranfer coefficient";
  SI.Length D_s[dim_tot](each fixed=false) "Shell Diameter";
  SI.Velocity v_Na_des[dim_tot](each fixed=false) "Sodium velocity in tubes";
  SI.Velocity v_max_MS_des[dim_tot](each fixed=false) "Molten Salt velocity in shell";
  SI.Volume V_HX_des[dim_tot](each fixed=false) "Heat-Exchanger Total Volume";
  SI.Mass m_HX_des[dim_tot](each fixed=false) "Heat-Exchanger Total Mass";
  Real C_BEC[dim_tot](each fixed=false) "Bare cost @2018";
  Real C_pump_des[dim_tot](each fixed=false) "Annual pumping cost";
  Real TAC_des[dim_tot](each fixed=false) "Total Annualized Cost";
//  parameter Real C_BEC[dim_tot](unit = fill("€",dim_tot),each fixed=false) "Bare cost @2018";
//  parameter Real C_pump_des[dim_tot](unit = fill("€/year",dim_tot),each fixed=false) "Annual pumping cost";
//  parameter Real TAC_des[dim_tot](unit = fill("€/year",dim_tot),each fixed=false) "Total Annualized Cost";
  Real ex_eff_des[dim_tot](each fixed=false) "HX Exergetic Efficiency";
  Real en_eff_des[dim_tot](each fixed=false) "HX Energetic Efficiency";
  
algorithm
  iter := 1;
    for ll in 1:dim5 loop
      for ww in 1:dim4 loop
        for ii in 1:dim3 loop
          for jj in 1:dim2 loop
            for kk in 1:dim1 loop
              vec[iter, 1] := d_o[kk];
              vec[iter, 2] := L[jj];
              vec[iter, 3] := N_p[ii];
              vec[iter, 4] := layout[ww];
              vec[iter, 5] := T_Na2_des[ll];
              (m_flow_Na_des[iter], m_flow_MS_des[iter], F_des[iter], UA_des[iter], N_t[iter], U_des[iter], A_tot[iter], Dp_tube_des[iter], Dp_shell_des[iter], TAC_des[iter], h_s_des[iter], h_t_des[iter], D_s[iter], v_Na_des[iter], v_max_MS_des[iter], V_HX_des[iter], m_HX_des[iter], C_BEC[iter], C_pump_des[iter], ex_eff_des[iter], en_eff_des[iter]) := Design_HX(Q_d = Q_d_des, T_Na1 = T_Na1_des, T_MS1 = T_MS1_des, T_MS2 = T_MS2_des, d_o = d_o[kk], L = L[jj], N_p = N_p[ii], layout = layout[ww], T_Na2 = T_Na2_des[ll], p_MS1 = p_MS1_des, p_Na1 = p_Na1_des, c_e = 0.13, r = 0.05, H_y = 4500);
              iter := iter + 1;
            end for;
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
    v_Na_opt_des := v_Na_des[result];
    v_max_MS_opt_des := v_max_MS_des[result];
    V_HX_opt_des := V_HX_des[result];
    m_HX_opt_des := m_HX_des[result];
    C_BEC_opt := C_BEC[result];
    C_pump_opt_des := C_pump_des[result];
    d_o_opt := vec[result, 1];
    L_opt := vec[result, 2];
    N_p_opt := integer(vec[result, 3]);
    layout_opt := integer(vec[result, 4]);
    T_Na2_opt_des := vec[result, 5];
    m_flow_Na_opt_des := m_flow_Na_des[result];
    m_flow_MS_opt_des := m_flow_MS_des[result];
    F_opt_des := F_des[result];
    UA_opt_des := UA_des[result];
    ex_eff_opt_des := ex_eff_des[result];
    en_eff_opt_des := en_eff_des[result];


end Find_Opt_Design_HX;