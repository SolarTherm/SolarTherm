within SolarTherm.Models.Fluid.HeatExchangers;
function Transient_HX
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  
  input SI.MassFlowRate m_flow_Na "Sodium mass flow rate";
  input SI.Temperature T_Na1 "Sodium Hot Fluid Temperature";
  input SI.Temperature T_MS1 "Molten Salt Cold Fluid Temperature";
  input SI.Temperature T_MS2 "Molten Salt Hot Fluid Temperature";
  input SI.Pressure p_Na1 "Sodium Inlet Pressure";
  input SI.Pressure p_MS1 "Molten Salt Inlet Pressure";
  input SI.Length d_o "Outer Tube diameter";
  input SI.Length t_tube "Tube thickness";
  input SI.ThermalConductivity k_wall "Tube Thermal Conductivity";
  input Integer N_p "Number of passes";
  input Integer layout "Tube layout";
  input Integer N_t "Number of tubes";
  input SI.Area A "Exchange Area";
  
  output SI.HeatFlowRate Q "Heat Flow Rate";
  output SI.MassFlowRate m_flow_MS "Molten Salt mass flow rate";
  output SI.Temperature T_Na2 "Sodium Cold Fluid Temperature";
  output SI.CoefficientOfHeatTransfer U "Heat tranfer coefficient";
  output SI.CoefficientOfHeatTransfer h_s "Shell-side Heat tranfer coefficient";
  output SI.CoefficientOfHeatTransfer h_t "Tube-side Heat tranfer coefficient";
  output Real F "Temperature correction factor";
  
  protected
  parameter SI.Temperature T_Na2_guess=700+273.15 "Guess Output Sodium Temperature";
  parameter SI.MassFlowRate m_flow_MS_guess=4 "Guess Molten Salt mass flow rate";
  parameter Real tol1=0.5 "Heat transfer coefficient tollerance";
  parameter Real tol2=0.5 "Heat transfer coefficient tollerance";
  Real condition1(start=10) "When condition";
  Real condition2(start=10) "When condition";
  
  //Fluid Properties
  SI.Temperature Tm_Na(start=988.15) "Mean Sodium Fluid Temperature";
  SI.Temperature Tm_MS(start=883.15) "Mean Molten Salts Fluid Temperature";
  SI.ThermalConductivity k_Na "Sodium Conductivity @mean temperature";
  SI.ThermalConductivity k_MS "Molten Salts Conductivity @mean temperature";
  SI.Density rho_Na "Sodium density @mean temperature";
  SI.Density rho_MS "Molten Salts density @mean temperature";
  SI.DynamicViscosity mu_Na "Sodium dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_MS "Molten Salts  dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_Na_wall "Sodium dynamic viscosity @wall temperature";
  SI.DynamicViscosity mu_MS_wall "Molten salts dynamic viscosity @wall temperature";
  SI.SpecificHeatCapacity cp_Na "Sodium specific heat capacity @mean temperature";
  SI.SpecificHeatCapacity cp_MS "Molten Salts specific heat capacity @mean temperature";
  Medium1.ThermodynamicState state_mean_Na;
  Medium1.ThermodynamicState state_input_Na;
  Medium1.ThermodynamicState state_output_Na;
  Medium2.ThermodynamicState state_mean_MS;
  Medium2.ThermodynamicState state_wall_MS;
  Medium2.ThermodynamicState state_input_MS;
  Medium2.ThermodynamicState state_output_MS;
  
  //Other Variables
  SI.TemperatureDifference DT1(start=20) "Sodium-Molten Salt temperature difference 1";
  SI.TemperatureDifference DT2(start=200) "Sodium-Molten Salt temperature difference 2";
  SI.TemperatureDifference LMTD(start=78.1730067425853) "Logarithmic mean temperature difference";
  SI.Temperature T_Na2_calc(start=973.15) "Sodium Cold Fluid Temperature";
  SI.Temperature T_Na2_calc_prev(start=973.15) "Sodium Cold Fluid Temperature";
  SI.MassFlowRate m_flow_MS_calc "Molten Salt mass flow rate";
  SI.MassFlowRate m_flow_MS_calc_prev "Molten Salt mass flow rate";
  
algorithm
  //Chloride Salt properties
  Tm_MS:=(T_MS1+T_MS2)/2;
  state_mean_MS:=Medium2.setState_pTX(Medium2.p_default, Tm_MS);
  state_input_MS:=Medium2.setState_pTX(p_Na1, T_MS1);
  state_output_MS:=Medium2.setState_pTX(p_Na1, T_MS2);
  rho_MS:=Medium2.density(state_mean_MS);
  cp_MS:=Medium2.specificHeatCapacityCp(state_mean_MS);
  mu_MS:=Medium2.dynamicViscosity(state_mean_MS);
  k_MS:=Medium2.thermalConductivity(state_mean_MS);
  
  T_Na2_calc_prev:=T_Na2_guess;
  condition1:=10;
  while noEvent(condition1>tol1) loop
    //Sodium properties
    Tm_Na:=(T_Na1+T_Na2_calc_prev)/2;
    state_mean_Na:=Medium1.setState_pTX(p_Na1, Tm_Na);
    state_input_Na:=Medium1.setState_pTX(p_Na1, T_Na1);
    state_output_Na:=Medium1.setState_pTX(p_Na1, T_Na2_calc_prev);
    rho_Na:=Medium1.density(state_mean_Na);
    cp_Na:=Medium1.specificHeatCapacityCp(state_mean_Na);
    mu_Na:=Medium1.dynamicViscosity(state_mean_Na);
    mu_Na_wall:=mu_Na;
    k_Na:=Medium1.thermalConductivity(state_mean_Na);
    state_wall_MS:=Medium2.setState_pTX(Medium2.p_default, Tm_Na);
    mu_MS_wall:=Medium2.dynamicViscosity(state_wall_MS);
    
    DT1:=T_Na1-T_MS2;
    DT2:=T_Na2_calc_prev-T_MS1;
    LMTD:=(DT1-DT2)/MA.log(DT1 / DT2);
    F:=TempCorrFactor(T_Na1=T_Na1, T_Na2=T_Na2_calc_prev, T_MS1=T_MS1, T_MS2=T_MS2);
    
    m_flow_MS_calc_prev:=m_flow_MS_guess;
    condition2:=10;
    while noEvent(condition2>tol2) loop
      (U, h_s, h_t):=HTCs(d_o=d_o, t_tube=t_tube, k_wall=k_wall, N_p=N_p, layout=layout, N_t=N_t, state_mean_Na=state_mean_Na, state_mean_MS=state_mean_MS, state_wall_MS=state_wall_MS, m_flow_Na=m_flow_Na, m_flow_MS=m_flow_MS_calc_prev);
      Q:=U*A*F*LMTD;
      m_flow_MS_calc:=Q/(cp_MS*(T_MS2 - T_MS1));
      condition2:=abs(m_flow_MS_calc-m_flow_MS_calc_prev)/m_flow_MS_calc_prev;
      m_flow_MS_calc_prev:=m_flow_MS_calc;
    end while;
    m_flow_MS:=m_flow_MS_calc;
    T_Na2_calc:=T_Na1-(Q/(m_flow_Na*cp_Na));
    condition1:=abs(T_Na2_calc-T_Na2_calc_prev)/T_Na2_calc_prev;
    T_Na2_calc_prev:=T_Na2_calc;
  end while;
  T_Na2:=T_Na2_calc;

end Transient_HX;