within SolarTherm.Models.Fluid.HeatExchangers;
model HE_2
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  
  //Design Parameters
  parameter SI.HeatFlowRate Q_d = 1e6 "Design Heat Flow Rate";
  parameter SI.Temperature T_Na1 = 740 + 273.15 "Desing Sodium Hot Fluid Temperature";
  parameter SI.Temperature T_MS1 = 500 + 273.15 "Desing Molten Salt Cold Fluid Temperature";
  parameter SI.Temperature T_MS2 = 720 + 273.15 "Desing Molten Salt Hot Fluid Temperature";
  parameter SI.Pressure p_Na1 = 101325 "Design Sodium Inlet Pressure";
  parameter SI.Pressure p_MS1 = 101325 "Design Molten Salt Inlet Pressure";
  
  //Sweep Parameters
  //parameter SI.Length d_o[10]={6.35e-3,9.53e-3,12.7e-3,15.88e-3,19.05e-3,22.23e-3,25.4e-3,31.75e-3,38.10e-3,50.8e-3} "Outer Tube Diameter";
  //parameter SI.Length L[10]={2,4,6,8,10,12,14,16,18,20} "Tube Length";
  //parameter Integer N_p[2]={4,8} "Tube passes number";
  //parameter Integer layout[2]={1,2} "Tube layout";
  //parameter SI.Temperature T_Na2[11] = {630+273.15,640+273.15,650+273.15,660+273.15,670+273.15,680+273.15,690+273.15,700+273.15,710+273.15,720+273.15,730+273.15} "Sodium Cold Fluid Temperature";
  parameter SI.Length d_o[4]={25.4e-3,31.75e-3,38.10e-3,50.8e-3} "Outer Tube Diameter";
  parameter SI.Length L[4]={4,6,8,10} "Tube Length";
  parameter Integer N_p[1]={4} "Tube passes number";
  parameter Integer layout[1]={2} "Tube layout";
  parameter SI.Temperature T_Na2[9] = {650+273.15,660+273.15,670+273.15,680+273.15,690+273.15,700+273.15,710+273.15,720+273.15,730+273.15} "Sodium Cold Fluid Temperature";
  
  //Auxiliary parameters
  parameter Integer num_dim=5;
  parameter Integer dim1=size(d_o,1);
  parameter Integer dim2=size(L,1);
  parameter Integer dim3=size(N_p,1);
  parameter Integer dim4=size(layout,1);
  parameter Integer dim5=size(T_Na2,1);
  parameter Integer dim_tot=dim1*dim2*dim3*dim4*dim5;
  
  //Auxiliary variables
  Real vec[dim_tot,num_dim];
  Integer iter;
  
  //Variables
  SI.MassFlowRate m_flow_Na[dim_tot] "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS[dim_tot] "Molten-Salt mass flow rate";
  Real F[dim_tot] "Temperature correction factor";  
  SI.ThermalConductance UA[dim_tot] "UA";
  SI.Area A_tot[dim_tot] "Exchange Area";
  SI.CoefficientOfHeatTransfer U[dim_tot] "Heat tranfer coefficient";
  Real N_t[dim_tot] "Number of tubes";
  SI.Pressure Dp_tube[dim_tot] "Tube-side pressure drop";
  SI.Pressure Dp_shell[dim_tot] "Shell-side pressure drop";
  SI.CoefficientOfHeatTransfer h_s[dim_tot] "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t[dim_tot] "Tube-side Heat tranfer coefficient";
  SI.Length D_s[dim_tot] "Shell Diameter";
  SI.Velocity v_Na[dim_tot] "Sodium velocity in tubes";
  SI.Velocity v_max_MS[dim_tot] "Molten Salt velocity in shell";
  Real C_BEC[dim_tot](unit = fill("€",dim_tot)) "Bare cost @2018";
  Real C_pump[dim_tot](unit = fill("€/year",dim_tot)) "Annual pumping cost";
  Real TAC[dim_tot](unit = fill("€/year",dim_tot)) "Total Annualized Cost";
  Real ex_eff[dim_tot] "HX Exergetic Efficiency";
  Real en_eff[dim_tot] "HX Energetic Efficiency";
  
  //Optimal Values
  Integer result;
  Real TAC_min(unit = "€/year") "Minimum Total Annualized Cost";
  SI.Area A_tot_opt "Optimal Exchange Area";
  SI.CoefficientOfHeatTransfer U_opt "Optimal Heat tranfer coefficient";
  Real N_t_opt "Optimal Number of tubes";
  SI.Pressure Dp_tube_opt "Optimal Tube-side pressure drop";
  SI.Pressure Dp_shell_opt "Optimal Shell-side pressure drop";
  SI.CoefficientOfHeatTransfer h_s_opt "Optimal Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t_opt "Optimal Tube-side Heat tranfer coefficient";
  SI.Length D_s_opt "Optimal Shell Diameter";
  SI.Velocity v_Na_opt "Optimal Sodium velocity in tubes";
  SI.Velocity v_max_MS_opt "Optimal Molten Salt velocity in shell";
  Real C_BEC_opt(unit = "€") "Optimal Bare cost @2018";
  Real C_pump_opt(unit = "€/year") "Optimal Annual pumping cost";
  SI.Length d_o_opt "Optimal Outer Tube Diameter";
  SI.Length L_opt "Optimal Tube Length";
  Integer N_p_opt "Optimal Tube passes number";
  Integer layout_opt "Optimal Tube Layout";
  SI.Temperature T_Na2_opt "Optimal outlet sodium temperature";
  SI.MassFlowRate m_flow_Na_opt "Optimal Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS_opt "Optimal Molten-Salt mass flow rate";
  Real F_opt "Optimal Temperature correction factor";  
  SI.ThermalConductance UA_opt "Optimal UA";
  Real ex_eff_opt "Optimal HX Exergetic Efficiency";
  Real en_eff_opt "Optimal HX Energetic Efficiency";
  
algorithm
  iter:=1;
  for ll in 1:dim5 loop
    for ww in 1:dim4 loop
      for ii in 1:dim3 loop
        for jj in 1:dim2 loop
          for kk in 1:dim1 loop
          vec[iter,1]:=d_o[kk];
          vec[iter,2]:=L[jj];
          vec[iter,3]:=N_p[ii];
          vec[iter,4]:=layout[ww];
          vec[iter,5]:=T_Na2[ll];
          (m_flow_Na[iter], m_flow_MS[iter], F[iter], UA[iter], N_t[iter], U[iter], A_tot[iter], Dp_tube[iter], Dp_shell[iter], TAC[iter], h_s[iter], h_t[iter], D_s[iter], v_Na[iter], v_max_MS[iter], C_BEC[iter], C_pump[iter], ex_eff[iter], en_eff[iter]):= Design_HX_2(Q_d=Q_d, T_Na1=T_Na1, T_MS1=T_MS1, T_MS2=T_MS2, d_o=d_o[kk], L=L[jj], N_p=N_p[ii], layout = layout[ww], T_Na2=T_Na2[ll], p_MS1 = p_MS1, p_Na1 = p_Na1, c_e = 0.13, r = 0.05, H_y = 4500);
          iter:=iter+1;
          end for;
        end for;
      end for;
    end for;
  end for;
  
  TAC_min:=min(TAC);
  result:=Vectors.find(TAC_min,TAC);
  A_tot_opt:=A_tot[result];
  U_opt:=U[result];
  N_t_opt:=N_t[result];
  Dp_tube_opt:=Dp_tube[result];
  Dp_shell_opt:=Dp_shell[result];
  h_s_opt:=h_s[result];
  h_t_opt:=h_t[result];
  D_s_opt:=D_s[result];
  v_Na_opt:=v_Na[result];
  v_max_MS_opt:=v_max_MS[result];
  C_BEC_opt:=C_BEC[result];
  C_pump_opt:=C_pump[result];
  d_o_opt:=vec[result,1];
  L_opt:=vec[result,2];
  N_p_opt:=integer(vec[result,3]);
  layout_opt:=integer(vec[result,4]);
  T_Na2_opt:=vec[result,5];
  m_flow_Na_opt:=m_flow_Na[result];
  m_flow_MS_opt:=m_flow_MS[result];
  F_opt:=F[result];
  UA_opt:=UA[result];
  ex_eff_opt:=ex_eff[result];
  en_eff_opt:=en_eff[result];
  
end HE_2;