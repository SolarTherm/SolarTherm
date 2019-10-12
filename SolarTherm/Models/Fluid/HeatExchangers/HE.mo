within SolarTherm.Models.Fluid.HeatExchangers;
model HE
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import Modelica.Math;
  import SolarTherm.{Models,Media};
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
  SI.Area A_tot "Exchange Area";
  SI.CoefficientOfHeatTransfer U "Heat tranfer coefficient";
  Real N_t "Number of tubes";
  SI.Pressure Dp_tube "Tube-side pressure drop";
  SI.Pressure Dp_shell "Shell-side pressure drop";
  SI.Pressure Dp_tot "Total pressure drop";
  Real TAC(unit = "€/year") "Total Annualized Cost";
  SI.CoefficientOfHeatTransfer h_s "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t "Tube-side Heat tranfer coefficient";
  SI.Length D_s "Shell Diameter";
  SI.Velocity v_Na "Sodium velocity in tubes";
  SI.Velocity v_max_MS "Molten Salt velocity in shell";
  Real C_BEC(unit = "€") "Bare cost @2018";
  Real C_pump(unit = "€") "Annual pumping cost";
  Real Cap_Na;
  Real Cap_MS;
  
equation
  Q_d = m_flow_Na * cp_Na * (T_Na1 - T_Na2);
  Q_d = m_flow_MS * cp_MS * (T_MS2 - T_MS1);
  Q_d = UA * F * LMTD;
  DT1 = T_Na1 - T_MS2;
  DT2 = T_Na2 - T_MS1;
  LMTD = (DT1 - DT2) / Math.log(DT1 / DT2);
  P = (T_Na2 - T_Na1) / (T_MS1 - T_Na1);
  R = (T_MS1 - T_MS2) / (T_Na2 - T_Na1);
  AA = 2 / P - R - 1;
  BB = 2 / P * ((1 - P) * (1 - P * R)) ^ 0.5;
  F = (R ^ 2 + 1) ^ 0.5 / (2 * (R + 1)) * log((1 - P) / (1 - P * R)) / log((AA + BB + (R ^ 2 + 1) ^ 0.5) / (AA + BB - (R ^ 2 + 1) ^ 0.5));
  (N_t, U, A_tot, Dp_tube, Dp_shell, Dp_tot, TAC, h_s, h_t, D_s, v_Na, v_max_MS, C_BEC, C_pump) = Design_HX(d_o = 20 * 10 ^ (-3), L = 2, N_p = 4, layout = 1, P_shell = 101325, P_tubes = 101325, UA = UA, m_flow_Na = m_flow_Na, m_flow_MS = m_flow_MS, c_e = 0.13, r = 0.05, CEPCI_18 = 603.1, H_y = 4500, M_conv = 0.9175, k_wall = k_wall, k_Na = k_Na, k_MS = k_MS, rho_Na = rho_Na, rho_MS = rho_MS, mu_Na = mu_Na, mu_MS = mu_MS, mu_Na_wall = mu_Na_wall, mu_MS_wall = mu_MS_wall, cp_Na = cp_Na, cp_MS = cp_MS);
  Cap_Na=m_flow_Na*cp_Na;
  Cap_MS=m_flow_MS*cp_MS;
  
end HE;