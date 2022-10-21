within SolarTherm.Models.UtilitiesComponent;

model ReactorRecuperator
/*Model to separate the H2 and H2O*/

import SI = Modelica.SIunits;
import CN = Modelica.Constants;
import MedGas = Modelica.Media.IdealGases.Common.Functions;
replaceable package MedGas2 = Modelica.Media.IdealGases.Common.SingleGasNasa(
      data = Modelica.Media.IdealGases.Common.SingleGasesData.H2, 
      mediumName = "Hydrogen", fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2}
); 
replaceable package MedWater = Modelica.Media.Water.StandardWater;
  
parameter Modelica.Media.IdealGases.Common.DataRecord gas_data = Modelica.Media.IdealGases.Common.SingleGasesData.H2;
parameter SI.CoefficientOfHeatTransfer U_recup1 = 120 "gas to gas overall U value. source: Cao, Eduardo. 2010. “TYPICAL HEAT TRANSFER COEFFICIENTS.” Chap. G in Heat Transfer in Process Engineering. 1st ed. New York: . https://www.accessengineeringlibrary.com/content/book/9780071624084/back-matter/appendix7";

//*************************** FIXME: two phase flow then it the U_recup value has to be adjusted
parameter SI.CoefficientOfHeatTransfer U_recup2 = 709.7829 "Water to H2 typical U value (Based on Product and Process Design Principles Seider et al 2008 page 489)";

/*Mass flow rates*/
parameter SI.MassFlowRate m_dot_excess_H2 = 2.82558 * 6 "Excess H2O and H2 coming off the reactor";
parameter SI.MassFlowRate m_dot_excess_H2O= 3.832875 * 6 "Excess H2O and H2 coming off the reactor";
parameter SI.MassFlowRate m_dot_excess_H2_and_H2O = m_dot_excess_H2 + m_dot_excess_H2O "Excess H2O and H2 coming off the reactor";
parameter SI.MassFlowRate m_dot_H2_from_expander = 2.82558  "H2 mass flow rate from the expander [kg/s]";
parameter SI.MassFlowRate m_dot_H2_cold = m_dot_excess_H2 + m_dot_H2_from_expander "Mass flow rate of the cold H2 stream (excess + feedstock)";

/*Pressures*/
parameter SI.Pressure p_reactor = 7e5 "Reactor pressure [Pa]";

/*Temperatures*/
parameter SI.Temperature T1 = 600 + 273.15 "Reactor operating temperature [K]";
parameter SI.Temperature T2 = 170 + 273.15 "Temperature after recup 1 (iterated manually) s.t. no temperature lines are crossed";
parameter SI.Temperature T3 = 165 + 273.15 "Temperature after recup 2 (iterated manually s.t. no temperature lines are crossed";
parameter SI.Temperature T4 = 99 + 273.15 "Condensation of water at partial pressure";
parameter SI.Temperature T5 = 20 + 273.15 "H2 temperature from the expander [K]";

/*Known thermodynamic states*/
parameter MedGas2.ThermodynamicState state_H2_1 = MedGas2.setState_pTX(p=p_reactor, T=T1);
parameter MedGas2.ThermodynamicState state_H2_2 = MedGas2.setState_pTX(p=p_reactor, T=T2);
parameter MedGas2.ThermodynamicState state_H2_3 = MedGas2.setState_pTX(p=p_reactor, T=T3);
parameter MedGas2.ThermodynamicState state_H2_4 = MedGas2.setState_pTX(p=p_reactor, T=T4);
parameter MedGas2.ThermodynamicState state_H2_5 = MedGas2.setState_pTX(p=p_reactor, T=T5);

parameter MedWater.ThermodynamicState state_H2O_1 = MedWater.setState_pTX(p=p_reactor, T=T1);
parameter MedWater.ThermodynamicState state_H2O_2 = MedWater.setState_pTX(p=p_reactor, T=T2);
parameter MedWater.ThermodynamicState state_H2O_3 = MedWater.setState_pTX(p=p_reactor, T=T3);

parameter SI.HeatFlowRate Q_recup1 = m_dot_excess_H2 * (MedGas2.specificEnthalpy(state_H2_1) - MedGas2.specificEnthalpy(state_H2_2)) + m_dot_excess_H2O * (MedWater.specificEnthalpy(state_H2O_1) - MedWater.specificEnthalpy(state_H2O_2)) "Recuperator 1 heat rating [W]";

/*Mixing of H2 (between state 4 and 5)*/
parameter SI.SpecificEnthalpy h_H2_6 = (m_dot_excess_H2 * MedGas2.specificEnthalpy(state_H2_4) + m_dot_H2_from_expander * MedGas2.specificEnthalpy(state_H2_5)) / m_dot_H2_cold;

parameter MedGas2.ThermodynamicState state_H2_6 = MedGas2.setState_phX(p=p_reactor, h=h_H2_6);
parameter SI.Temperature T6 = MedGas2.temperature(state_H2_6);

/*Recup 2*/
parameter SI.HeatFlowRate Q_recup2 = m_dot_excess_H2 * (MedGas2.specificEnthalpy(state_H2_2) - MedGas2.specificEnthalpy(state_H2_3)) + m_dot_excess_H2O * (MedWater.specificEnthalpy(state_H2O_2) - MedWater.specificEnthalpy(state_H2O_3)) "Recuperator 2 heat rating [W]";

parameter SI.SpecificEnthalpy h_H2_7 = Q_recup2/m_dot_H2_cold + h_H2_6;
parameter MedGas2.ThermodynamicState state_H2_7 = MedGas2.setState_phX(p=p_reactor, h=h_H2_7);
parameter SI.Temperature T7 = MedGas2.temperature(state_H2_7);

/*Designing the recuperator*/
parameter SI.SpecificEnthalpy h_H2_8 = Q_recup1/m_dot_H2_cold + h_H2_7;
parameter MedGas2.ThermodynamicState state_H2_8 = MedGas2.setState_phX(p = p_reactor, h=h_H2_8);
parameter SI.Temperature T8(fixed=false);


parameter SI.TemperatureDifference T_LMTD_recup1 = ((T1-T8)-(T2-T7))/(log((T1-T8)/(T2-T7)));
parameter SI.TemperatureDifference T_LMTD_recup2 = ((T2-T7)-(T3-T6))/(log((T2-T7)/(T3-T6)));

parameter SI.Area A_recup1(fixed=false); 
parameter SI.Area A_recup2(fixed=false); 
parameter SI.Area A_recup_total(fixed=false);

initial equation
  T8 = MedGas2.temperature(state_H2_8);
  
  A_recup1 = Q_recup1 / (T_LMTD_recup1 * U_recup1);
  A_recup2 = Q_recup2 / (T_LMTD_recup2 * U_recup2);
  A_recup_total = A_recup1 + A_recup2;
equation

end ReactorRecuperator;