within SolarTherm.Models.Fluid.HeatExchangers;
model HE
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
  parameter SI.Temperature T_Na2 = T_MS1 + 200 "Sodium Cold Fluid Temperature";
  parameter SI.Pressure p_Na1 = 101325 "Sodium Inlet Pressure";
  parameter SI.Pressure p_MS1 = 101325 "Molten Salt Inlet Pressure";
 

  //Fluid Properties
  parameter SI.Temperature Tm_Na = (T_Na1 + T_Na2) / 2 "Mean Sodium Fluid Temperature";
  parameter SI.Temperature Tm_MS = (T_MS1 + T_MS2) / 2 "Mean Molten Salts Fluid Temperature";
  
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  parameter Medium1.ThermodynamicState state_mean_Na = Medium1.setState_pTX(p_Na1, Tm_Na);
  parameter Medium1.ThermodynamicState state_input_Na = Medium1.setState_pTX(p_Na1, T_Na1);
  parameter Medium1.ThermodynamicState state_output_Na = Medium1.setState_pTX(p_Na1, T_Na2);
  parameter SI.Density rho_Na = Medium1.density(state_mean_Na) "Sodium density @mean temperature";
  parameter SI.SpecificHeatCapacity cp_Na = Medium1.specificHeatCapacityCp(state_mean_Na) "Sodium specific heat capacity @mean temperature";
  parameter SI.DynamicViscosity mu_Na = Medium1.dynamicViscosity(state_mean_Na) "Sodium dynamic viscosity @mean temperature";
  parameter SI.DynamicViscosity mu_Na_wall = mu_Na "Sodium dynamic viscosity @wall temperature";
  parameter SI.ThermalConductivity k_Na = Medium1.thermalConductivity(state_mean_Na) "Sodium Conductivity @mean temperature";
  parameter SI.SpecificEnthalpy h_Na1 = Medium1.specificEnthalpy(state_input_Na) "Sodium specific enthalpy @inlet temperature";
  parameter SI.SpecificEnthalpy h_Na2 = Medium1.specificEnthalpy(state_output_Na) "Sodium specific enthalpy @outlet temperature";
  parameter SI.SpecificEntropy s_Na1 = Medium1.specificEntropy(state_input_Na) "Sodium specific entropy @inlet temperature";
  parameter SI.SpecificEntropy s_Na2 = Medium1.specificEntropy(state_output_Na) "Sodium specific entropy @outlet temperature";
  
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  parameter Medium2.ThermodynamicState state_mean_MS = Medium2.setState_pTX(Medium2.p_default, Tm_MS);
  parameter Medium2.ThermodynamicState state_wall_MS = Medium2.setState_pTX(Medium2.p_default, Tm_Na);
  parameter Medium2.ThermodynamicState state_input_MS = Medium2.setState_pTX(p_Na1, T_MS1);
  parameter Medium2.ThermodynamicState state_output_MS = Medium2.setState_pTX(p_Na1, T_MS2);
  parameter SI.Density rho_MS = Medium2.density(state_mean_MS) "Molten Salt density @mean temperature";
  parameter SI.SpecificHeatCapacity cp_MS = Medium2.specificHeatCapacityCp(state_mean_MS) "Molten Salt specific heat capacity @mean temperature";
  parameter SI.DynamicViscosity mu_MS = Medium2.dynamicViscosity(state_mean_MS) "Molten Salt dynamic viscosity @mean temperature";
  parameter SI.DynamicViscosity mu_MS_wall = Medium2.dynamicViscosity(state_wall_MS) "Molten Salt dynamic viscosity @wall temperature";
  parameter SI.ThermalConductivity k_MS = Medium2.thermalConductivity(state_mean_MS) "Molten Salt Conductivity @mean temperature";
  parameter SI.SpecificEnthalpy h_MS1 = Medium2.specificEnthalpy(state_input_MS) "Molten Salt specific enthalpy @inlet temperature";
  parameter SI.SpecificEnthalpy h_MS2 = Medium2.specificEnthalpy(state_output_MS) "Molten Salt specific enthalpy @outlet temperature";
  parameter SI.SpecificEntropy s_MS1 = Medium2.specificEntropy(state_input_MS) "Molten Salt specific entropy @inlet temperature";
  parameter SI.SpecificEntropy s_MS2 = Medium2.specificEntropy(state_output_MS) "Molten Salt specific entropy @outlet temperature";
  
  //Sweep Parameters
  parameter SI.Length d_o[10]={6.35e-3,9.53e-3,12.7e-3,15.88e-3,19.05e-3,22.23e-3,25.4e-3,31.75e-3,38.10e-3,50.8e-3}"Outer Tube Diameter";
  //parameter SI.Length d_o[1]={50.8e-3}"Outer Tube Diameter";
  parameter SI.Length L[10]={2,4,6,8,10,12,14,16,18,20} "Tube Length";
  //parameter SI.Length L[1]={8} "Tube Length";
  parameter Integer N_p[1]={4} "Tube passes number";
  parameter Integer layout[2]={1,2} "Tube layout";
  parameter Integer num_dim=4;
  parameter Integer dim1=size(d_o,1);
  parameter Integer dim2=size(L,1);
  parameter Integer dim3=size(N_p,1);
  parameter Integer dim4=size(layout,1);
  parameter Integer dim_tot=dim1*dim2*dim3*dim4;
  
  //Variables
  SI.MassFlowRate m_flow_Na "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS "Molten-Salt mass flow rate";
  SI.TemperatureDifference DT1 "Sodium-Molten Salt temperature difference 1";
  SI.TemperatureDifference DT2 "Sodium-Molten Salt temperature difference 2";
  SI.TemperatureDifference LMTD "Logarithmic mean temperature difference";
  Real F(unit = "") "Temperature correction factor";  
  SI.ThermalConductance UA "UA";
  Real vec[dim_tot,num_dim];
  Integer iter;
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
  Real ex_eff(unit="") "HX Exergetic Efficiency";
  Real en_eff(unit="") "HX Energetic Efficiency";
  Integer result;
  
  //Optimal Values
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
  
equation
  Q_d = m_flow_Na * cp_Na * (T_Na1 - T_Na2);
  Q_d = m_flow_MS * cp_MS * (T_MS2 - T_MS1);
  Q_d = UA * F * LMTD;
  DT1 = T_Na1 - T_MS2;
  DT2 = T_Na2 - T_MS1;
  LMTD = (DT1 - DT2) / MA.log(DT1 / DT2);
  F=TempCorrFactor(T_Na1=T_Na1, T_Na2=T_Na2, T_MS1=T_MS1, T_MS2=T_MS2);
  ex_eff=(m_flow_MS*((h_MS2-h_MS1)-(25+273.15)*cp_MS*(MA.log(T_MS2/T_MS1))))/(m_flow_Na*((h_Na1-h_Na2)-(25+273.15)*cp_Na*(MA.log(T_Na1/T_Na2))));
  if (cp_Na*m_flow_Na)>(cp_MS*m_flow_MS) then
    en_eff=(T_MS2-T_MS1)./(T_Na1-T_MS1);
    else
    en_eff=(T_Na1-T_Na2)./(T_Na1-T_MS1);
  end if;
  
algorithm
  iter:=1;
  for ww in 1:dim4 loop
    for ii in 1:dim3 loop
      for jj in 1:dim2 loop
        for kk in 1:dim1 loop
        vec[iter,1]:=d_o[kk];
        vec[iter,2]:=L[jj];
        vec[iter,3]:=N_p[ii];
        vec[iter,4]:=layout[ww];
        (N_t[iter], U[iter], A_tot[iter], Dp_tube[iter], Dp_shell[iter], TAC[iter], h_s[iter], h_t[iter], D_s[iter], v_Na[iter], v_max_MS[iter], C_BEC[iter], C_pump[iter]):= Design_HX(d_o=d_o[kk], L=L[jj], N_p=N_p[ii], layout = layout[ww], P_shell = p_MS1, P_tubes = p_Na1, UA = UA, m_flow_Na = m_flow_Na, m_flow_MS = m_flow_MS, c_e = 0.13, r = 0.05, CEPCI_18 = 603.1, H_y = 4500, M_conv = 0.9175, k_Na = k_Na, k_MS = k_MS, rho_Na = rho_Na, rho_MS = rho_MS, mu_Na = mu_Na, mu_MS = mu_MS, mu_Na_wall = mu_Na_wall, mu_MS_wall = mu_MS_wall, cp_Na = cp_Na, cp_MS = cp_MS);
        iter:=iter+1;
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
  
end HE;
