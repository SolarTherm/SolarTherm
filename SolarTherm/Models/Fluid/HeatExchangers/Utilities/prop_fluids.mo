within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function prop_fluids
  
  input SI.Temperature T_Na1 "Desing Sodium Hot Fluid Temperature";
  input SI.Temperature T_Na2 "Desing Sodium Hot Fluid Temperature";
  input SI.Temperature T_MS1 "Desing Molten Salt Cold Fluid Temperature";
  input SI.Temperature T_MS2 "Desing Molten Salt Hot Fluid Temperature";
  input SI.Pressure p_Na1 "Design Sodium Inlet Pressure";
  input SI.Pressure p_MS1 "Design Molten Salt Inlet Pressure";
  
  output SI.ThermalConductivity k_Na "Sodium Conductivity @mean temperature";
  output SI.Density rho_Na "Sodium density @mean temperature";
  output SI.DynamicViscosity mu_Na "Sodium dynamic viscosity @mean temperature";
  output SI.DynamicViscosity mu_Na_wall "Sodium dynamic viscosity @wall temperature";
  output SI.SpecificHeatCapacity cp_Na "Sodium specific heat capacity @mean temperature";
  output SI.SpecificEnthalpy h_Na1 "Sodium specific enthalpy @inlet temperature";
  output SI.SpecificEnthalpy h_Na2 "Sodium specific enthalpy @outlet temperature";
  output SI.SpecificEntropy s_Na1 "Sodium specific entropy @inlet temperature";
  output SI.SpecificEntropy s_Na2 "Sodium specific entropy @outlet temperature";
  
  output SI.ThermalConductivity k_MS "Molten Salts Conductivity @mean temperature";
  output SI.Density rho_MS "Molten Salts density @mean temperature";
  output SI.DynamicViscosity mu_MS "Molten Salts  dynamic viscosity @mean temperature";
  output SI.DynamicViscosity mu_MS_wall "Molten salts dynamic viscosity @wall temperature";
  output SI.SpecificHeatCapacity cp_MS "Molten Salts specific heat capacity @mean temperature";
  output SI.SpecificEnthalpy h_MS1 "Molten Salt specific enthalpy @inlet temperature";
  output SI.SpecificEnthalpy h_MS2 "Molten Salt specific enthalpy @outlet temperature";
  output SI.SpecificEntropy s_MS1 "Molten Salt specific entropy @inlet temperature";
  output SI.SpecificEntropy s_MS2 "Molten Salt specific entropy @outlet temperature";
  
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  protected
  Medium1.ThermodynamicState state_mean_Na;
  Medium1.ThermodynamicState state_input_Na;
  Medium1.ThermodynamicState state_output_Na;
  Medium2.ThermodynamicState state_mean_MS;
  Medium2.ThermodynamicState state_wall_MS;
  Medium2.ThermodynamicState state_input_MS;
  Medium2.ThermodynamicState state_output_MS;
  SI.Temperature Tm_Na "Mean Sodium Fluid Temperature";
  SI.Temperature Tm_MS "Mean Molten Salts Fluid Temperature";
  
algorithm
  Tm_Na:=(T_Na1+T_Na2)/2;
  Tm_MS:=(T_MS1+T_MS2)/2;
  
  //Sodium properties
  state_mean_Na:=Medium1.setState_pTX(p_Na1, Tm_Na);
  state_input_Na:=Medium1.setState_pTX(p_Na1, T_Na1);
  state_output_Na:=Medium1.setState_pTX(p_Na1, T_Na2);
  rho_Na:=Medium1.density(state_mean_Na);
  cp_Na:=Medium1.specificHeatCapacityCp(state_mean_Na);
  mu_Na:=Medium1.dynamicViscosity(state_mean_Na);
  mu_Na_wall:=mu_Na;
  k_Na:=Medium1.thermalConductivity(state_mean_Na);
  h_Na1:=Medium1.specificEnthalpy(state_input_Na);
  h_Na2:=Medium1.specificEnthalpy(state_output_Na);
  s_Na1:=Medium1.specificEntropy(state_input_Na);
  s_Na2:=Medium1.specificEntropy(state_output_Na);
  
  //Chloride Salt properties
  state_mean_MS:=Medium2.setState_pTX(Medium2.p_default, Tm_MS);
  state_wall_MS:=Medium2.setState_pTX(Medium2.p_default, Tm_Na);
  state_input_MS:=Medium2.setState_pTX(p_Na1, T_MS1);
  state_output_MS:=Medium2.setState_pTX(p_Na1, T_MS2);
  rho_MS:=Medium2.density(state_mean_MS);
  cp_MS:=Medium2.specificHeatCapacityCp(state_mean_MS);
  mu_MS:=Medium2.dynamicViscosity(state_mean_MS);
  mu_MS_wall:=Medium2.dynamicViscosity(state_wall_MS);
  k_MS:=Medium2.thermalConductivity(state_mean_MS);
  h_MS1:=Medium2.specificEnthalpy(state_input_MS);
  h_MS2:=Medium2.specificEnthalpy(state_output_MS);
  s_MS1:=Medium2.specificEntropy(state_input_MS);
  s_MS2:=Medium2.specificEntropy(state_output_MS);
  
end prop_fluids;