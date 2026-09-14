within SolarTherm.Models.Fluid.HeatExchangers.BoilerHX_Calculations;

model Set_Inlet_Outlet
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  
  replaceable package Medium = SolarTherm.Media.DowthermA.DowthermA_ph; //Secondary Fluid (used to heat up the primary fluid)
  //Ambient conditions
  parameter SI.Temperature T_amb = 298.15 "Ambient temperature (25 degC)";
  parameter SI.Pressure p_amb = 1.0 * 1.0e5 "Ambient pressure (default 1 bar)";


  //Input Parameters (expected to vary with system)
  //--System Parameters
  parameter Real f_blowdown = 0.05;
  parameter Real eff_boiler = 0.90;
  parameter Real eff_pump = 0.80;
  
  //--Outlet Steam Conditions
  parameter SI.MassFlowRate m_flow_H2O_out = 210.0 * 1.0e3 / 3600.0 "Mass Flow Rate of required steam to digestion (kg/s)";
  parameter SI.Temperature T_H2O_out = 340.0 + 273.15 "Return cold condensate temperature (K)";
  parameter SI.Pressure p_H2O_out = 105.0 * 1.0e5 "Return cold condensate pressure (Pa)";

  //--Condensate Return Conditions
  parameter SI.Temperature T_H2O_return = 85.0 + 273.15 "Return cold condensate temperature (K)";
  parameter SI.Pressure p_H2O_return = 1.40 * 1.0e5 "Return cold condensate pressure (Pa)";
  
  //--Secondary Fluid Hot Inlet Conditions (HTF e.g. molten salt, thermal oil)
  parameter SI.Temperature T_fluid_in = 380.0 + 273.15 "Hot inlet secondary fluid temperature (K)";
  
  //--Secondary Fluid Cold Outlet Conditions
  parameter SI.Temperature T_fluid_out = 296.97 + 273.15 "Hot inlet secondary fluid temperature (K)";
  
  
  //Displayed Outlet Parameters
  //Stream_Temperatures
  //Required Mass flow
  parameter SI.MassFlowRate m_flow_fluid = Q_flow_duty_total/(h_fluid_in-h_fluid_out);
  parameter SI.Temperature T_primary_array[4] = {T_H2O_econ_in,T_H2O_evap_in,T_H2O_suph_in,T_H2O_out};
  parameter SI.Temperature T_secondary_array[4] = {T_fluid_out,T_fluid_econ_in,T_fluid_evap_in,T_fluid_in};
  parameter SI.TemperatureDifference T_approach_min = min(T_secondary_array .- T_primary_array);
  parameter SI.HeatFlowRate Q_flow_duty_total = (Q_flow_fluid_econ + Q_flow_fluid_evap + Q_flow_fluid_suph);
  
protected
  //Calculated Parameters (Don't vary any of this normally)
  //Outlet Steam Conditions
  parameter SI.SpecificEnthalpy h_H2O_out = Modelica.Media.Water.IF97_Utilities.h_pT(p_H2O_out,T_H2O_out) "Specific enthalpy of hot steam leaving the HX (J/kg)";
  
  //Condensate Return Conditions
  parameter SI.SpecificEnthalpy h_H2O_return = Modelica.Media.Water.IF97_Utilities.h_pT(p_H2O_return,T_H2O_return) "Specific enthalpy of condensate returning from an indutrial process (J/kg)";
  
  //Feedwater (topup) conditions
  parameter SI.MassFlowRate m_flow_H2O_feed = (f_blowdown/(1.0-f_blowdown))*m_flow_H2O_out "Topup feedwater mass flow rate (kg/s)";
  parameter SI.Temperature T_H2O_feed = T_amb "Topup feedwater temperature (K)";
  parameter SI.Pressure p_H2O_feed = p_amb "Topup feedwater pressure (Pa)";
  parameter SI.SpecificEnthalpy h_H2O_feed = Modelica.Media.Water.IF97_Utilities.h_pT(p_H2O_in,T_H2O_feed) "Topup feedwater specific enthalpy (J/kg)";
  
  //Economiser(Preheater), Evaporator and Superheater Conditions
  //H2O inlet Conditions (right before a pressurising pump)
  parameter SI.Pressure p_H2O_in = if (f_blowdown <= 0.0) then p_H2O_return else min(p_H2O_return,p_H2O_feed);
  parameter SI.MassFlowRate m_flow_H2O_in = m_flow_H2O_out*(1.0/(1.0-f_blowdown));
  parameter SI.SpecificEnthalpy h_H2O_in = (m_flow_H2O_out*h_H2O_return + m_flow_H2O_feed*h_H2O_feed)/m_flow_H2O_in; 
  parameter SI.Temperature T_H2O_in = Modelica.Media.Water.IF97_Utilities.T_ph(p_H2O_in,h_H2O_in);
  parameter SI.SpecificEntropy s_H2O_in = Modelica.Media.Water.IF97_Utilities.s_pT(p_H2O_in,T_H2O_in);

  
  //Economiser(Preheater) H2O inlet conditions (Basically pressurised to the required steam outlet pressure)
  parameter SI.SpecificEnthalpy h_H2O_econ_in = Modelica.Media.Water.IF97_Utilities.h_ps(p_H2O_out,s_H2O_in) "Specific enthalpy of pressurised fluid entering the economiser (J/kg)";
  parameter SI.Temperature T_H2O_econ_in = Modelica.Media.Water.IF97_Utilities.T_ps(p_H2O_out,s_H2O_in);
  parameter SI.MassFlowRate m_flow_H2O_econ = m_flow_H2O_in;
  
  //Evaporator H2O inlet conditions (Water is heated to the saturation temperature at the required steam outlet pressure, but x = 0.0) a blowdown fraction of the saturated liquid from the economiser has been dumped
  parameter SI.SpecificEnthalpy h_H2O_evap_in = Modelica.Media.Water.IF97_Utilities.hl_p(p_H2O_out) "Specific enthalpy of saturated liquid water at the required steam outlet pressure (Jkg)";
  parameter SI.Temperature T_H2O_evap_in = Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p_H2O_out) "Saturation temperature of steam at the required steam outlet pressure (K)";
  parameter SI.MassFlowRate m_flow_H2O_evap = m_flow_H2O_out;
  
  //Superheater H2O inlet condititions (Water has been completely evaporated into saturated vapour at the saturation temperature set by the required steam pressure), 
  parameter SI.SpecificEnthalpy h_H2O_suph_in = Modelica.Media.Water.IF97_Utilities.hv_p(p_H2O_out) "Specific enthalpy of saturated water vapour at the required steam outlet pressure (Jkg)";
  parameter SI.Temperature T_H2O_suph_in = Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p_H2O_out) "Saturation temperature of steam at the required steam outlet pressure (K)";
  parameter SI.MassFlowRate m_flow_H2O_suph = m_flow_H2O_out;
  
  //Now Calculate the heat/power into the H2O stream
  parameter SI.Power P_pump = (m_flow_H2O_in*(h_H2O_econ_in-h_H2O_in))/eff_pump;
  parameter SI.HeatFlowRate Q_flow_H2O_econ = m_flow_H2O_econ*(h_H2O_evap_in-h_H2O_econ_in);
  parameter SI.HeatFlowRate Q_flow_H2O_evap = m_flow_H2O_evap*(h_H2O_suph_in-h_H2O_evap_in);
  parameter SI.HeatFlowRate Q_flow_H2O_suph = m_flow_H2O_suph*(h_H2O_out-h_H2O_suph_in);
  
  //Now Calculate the heat duty from the fluid stream (with losses)
  parameter SI.HeatFlowRate Q_flow_fluid_econ = Q_flow_H2O_econ/eff_boiler;
  parameter SI.HeatFlowRate Q_flow_fluid_evap = Q_flow_H2O_evap/eff_boiler;
  parameter SI.HeatFlowRate Q_flow_fluid_suph = Q_flow_H2O_suph/eff_boiler;
  
  
  //Now Calculate the secondary stream
  //Endpoints
  parameter Medium.ThermodynamicState state_fluid_in = Medium.setState_pTX(p_amb, T_fluid_in);
  parameter Medium.ThermodynamicState state_fluid_out = Medium.setState_pTX(p_amb, T_fluid_out);
  
  parameter SI.SpecificEnthalpy h_fluid_in = Medium.specificEnthalpy(state_fluid_in);
  parameter SI.SpecificEnthalpy h_fluid_out = Medium.specificEnthalpy(state_fluid_out);
  
  
  
  //Enthalpy of secondary stream at each section inlet
  parameter SI.SpecificEnthalpy h_fluid_evap_in = h_fluid_in - (Q_flow_fluid_suph/m_flow_fluid);  
  parameter SI.SpecificEnthalpy h_fluid_econ_in = h_fluid_in - (Q_flow_fluid_evap/m_flow_fluid);
  

  parameter Medium.ThermodynamicState state_fluid_evap_in = Medium.setState_phX(p_amb, h_fluid_evap_in);
  parameter Medium.ThermodynamicState state_fluid_econ_in = Medium.setState_phX(p_amb, h_fluid_econ_in);
  
  parameter SI.Temperature T_fluid_evap_in = Medium.temperature(state_fluid_evap_in);
  parameter SI.Temperature T_fluid_econ_in = Medium.temperature(state_fluid_econ_in);
  //parameter SI.SpecificEnthalpy h_HTF_suph_in = Medium.setState_phX(Medium.p_default, h_fluid_econ_in)
  
  
equation

end Set_Inlet_Outlet;