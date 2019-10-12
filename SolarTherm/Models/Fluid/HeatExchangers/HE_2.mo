within SolarTherm.Models.Fluid.HeatExchangers;

model HE_2
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  //import Modelica.Math.Vectors;
  
  //Parameters
  parameter SI.HeatFlowRate Q_d = 1e6 "Design Heat Flow Rate";
  parameter SI.Temperature T_Na1 = 740 + 273.15 "Desing Sodium Hot Fluid Temperature";
  parameter SI.Temperature T_MS1 = 500 + 273.15 "Desing Molten Salts Cold Fluid Temperature";
  parameter SI.Temperature T_MS2 = 720 + 273.15 "Desing Molten Salts Hot Fluid Temperature";
  parameter SI.TemperatureDifference DT_min = 200 "Pinch-point temperature difference";
  parameter SI.Temperature T_Na2 = T_MS1 + DT_min "Sodium Cold Fluid Temperature";
  parameter SI.Temperature Tm_Na = (T_Na1 + T_Na2) / 2 "Mean Sodium Fluid Temperature";
  parameter SI.Temperature Tm_MS = (T_MS1 + T_MS2) / 2 "Mean Molten Salts Fluid Temperature";
  
  //Fluid Properties
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  parameter Medium1.ThermodynamicState state_mean_Na = Medium1.setState_pTX(Medium1.p_default, Tm_Na);
  parameter SI.Density rho_Na = Medium1.density(state_mean_Na) "Sodium density @mean temperature";
  parameter SI.SpecificHeatCapacity cp_Na = Medium1.specificHeatCapacityCp(state_mean_Na) "Sodium specific     heat capacity @mean temperature";
  parameter SI.DynamicViscosity mu_Na = Medium1.dynamicViscosity(state_mean_Na) "Sodium dynamic viscosity @mean temperature";
  parameter SI.DynamicViscosity mu_Na_wall = mu_Na "Sodium dynamic viscosity @wall temperature";
  parameter SI.ThermalConductivity k_Na = Medium1.thermalConductivity(state_mean_Na) "Sodium Conductivity @mean temperature";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  parameter Medium2.ThermodynamicState state_mean_MS = Medium2.setState_pTX(Medium2.p_default, Tm_MS);
  parameter Medium2.ThermodynamicState state_wall_MS = Medium2.setState_pTX(Medium2.p_default, Tm_Na);
  parameter SI.Density rho_MS = Medium2.density(state_mean_MS) "Molten Salt density @mean temperature";
  parameter SI.SpecificHeatCapacity cp_MS = Medium2.specificHeatCapacityCp(state_mean_MS) "Molten Salt specific heat capacity @mean temperature";
  parameter SI.DynamicViscosity mu_MS = Medium2.dynamicViscosity(state_mean_MS) "Molten Salt dynamic viscosity @mean temperature";
  parameter SI.DynamicViscosity mu_MS_wall = Medium2.dynamicViscosity(state_wall_MS) "Molten Salt dynamic viscosity @wall temperature";
  parameter SI.ThermalConductivity k_MS = Medium2.thermalConductivity(state_mean_MS) "Molten Salt Conductivity @mean temperature";
  //parameter SI.Length d_o[18]={16e-3,18e-3,20e-3,22e-3,24e-3,26e-3,28e-3,30e-3,32e-3,34e-3,36e-3,38e-3,40e-3,42e-3,44e-3,46e-3,48e-3,50e-3};
  parameter SI.Length d_o[9]={20e-3,30e-3,40e-3,50e-3,60e-3,70e-3,80e-3,90e-3,100e-3};
  parameter SI.Length L[10]={2,4,6,8,10,12,14,16,18,20};
  parameter Integer N_p[1]={4};
  parameter Integer dim1=size(d_o,1);
  parameter Integer dim2=size(L,1);
  parameter Integer dim3=size(N_p,1);
  parameter Integer dim4=dim1*dim2*dim3;
  
  //Wall properties
  parameter SI.ThermalConductivity k_wall = 24 "Tube Thermal Conductivity";
  
  //Variables
  SI.MassFlowRate m_flow_Na "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS "Molten-Salt mass flow rate";
  //SI.VolumeFlowRate V_flow_MS "Molten-Salt volume flow rate";
  //SI.VolumeFlowRate V_flow_Na "Sodium volume flow rate";
  SI.TemperatureDifference DT1 "Sodium-Molten Salt temperature difference 1";
  SI.TemperatureDifference DT2 "Sodium-Molten Salt temperature difference 2";
  SI.TemperatureDifference LMTD "Logarithmic mean temperature difference";
  Real F(unit = "") "Temperature correction factor";
  Real P(unit = "") "Non-dimensional factor for F calculation";
  Real R(unit = "") "Non-dimensional factor for F calculation";
  Real AA(unit = "") "Non-dimensional factor for F calculation";
  Real BB(unit = "") "Non-dimensional factor for F calculation";
  SI.ThermalConductance UA "UA";

  SI.Area A_tot[dim4] "Exchange Area";
  SI.CoefficientOfHeatTransfer U[dim4] "Heat tranfer coefficient";
  Real N_t[dim4] "Number of tubes";
  SI.Pressure Dp_tube[dim4] "Tube-side pressure drop";
  SI.Pressure Dp_shell[dim4] "Shell-side pressure drop";
  SI.Pressure Dp_tot[dim4] "Total pressure drop";
  Real TAC[dim4](unit = "€/year") "Total Annualized Cost";
  SI.CoefficientOfHeatTransfer h_s[dim4] "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t[dim4] "Tube-side Heat tranfer coefficient";
  SI.Length D_s[dim4] "Shell Diameter";
  SI.Velocity v_Na[dim4] "Sodium velocity in tubes";
  SI.Velocity v_max_MS[dim4] "Molten Salt velocity in shell";
  Real C_BEC[dim4](unit = "€") "Bare cost @2018";
  Real C_pump[dim4](unit = "€") "Annual pumping cost";
  Real vec[dim4,3];
  Integer iter;
  Real TAC_min(unit = "€/year") "Total Annualized Cost";
  //Real result;
  
algorithm
  iter:=1;
  for ii in 1:dim3 loop
    for jj in 1:dim2 loop
      for kk in 1:dim1 loop
        vec[iter,1]:=d_o[kk];
        vec[iter,2]:=L[jj];
        vec[iter,3]:=N_p[ii];
        (N_t[iter], U[iter], A_tot[iter], Dp_tube[iter], Dp_shell[iter], Dp_tot[iter], TAC[iter], h_s[iter], h_t[iter], D_s[iter], v_Na[iter], v_max_MS[iter], C_BEC[iter], C_pump[iter]):= Design_HX(d_o=d_o[kk], L=L[jj], N_p=N_p[ii], layout = 1, P_shell = 101325, P_tubes = 101325, UA = UA, m_flow_Na = m_flow_Na, m_flow_MS = m_flow_MS, c_e = 0.13, r = 0.05, CEPCI_18 = 603.1, H_y = 4500, M_conv = 0.9175, k_wall = k_wall, k_Na = k_Na, k_MS = k_MS, rho_Na = rho_Na, rho_MS = rho_MS, mu_Na = mu_Na, mu_MS = mu_MS, mu_Na_wall = mu_Na_wall, mu_MS_wall = mu_MS_wall, cp_Na = cp_Na, cp_MS = cp_MS);
        iter:=iter+1;
      end for;
    end for;
  end for;
  TAC_min:=min(TAC);

equation
  Q_d = m_flow_Na * cp_Na * (T_Na1 - T_Na2);
  Q_d = m_flow_MS * cp_MS * (T_MS2 - T_MS1);
  Q_d = UA * F * LMTD;
  DT1 = T_Na1 - T_MS2;
  DT2 = T_Na2 - T_MS1;
  LMTD = (DT1 - DT2) / MA.log(DT1 / DT2);
  P = (T_Na2 - T_Na1) / (T_MS1 - T_Na1);
  R = (T_MS1 - T_MS2) / (T_Na2 - T_Na1);
  AA = 2 / P - R - 1;
  BB = 2 / P * ((1 - P) * (1 - P * R)) ^ 0.5;
  F = (R ^ 2 + 1) ^ 0.5 / (2 * (R + 1)) * log((1 - P) / (1 - P * R)) / log((AA + BB + (R ^ 2 + 1) ^ 0.5) / (AA + BB - (R ^ 2 + 1) ^ 0.5));
  
end HE_2;