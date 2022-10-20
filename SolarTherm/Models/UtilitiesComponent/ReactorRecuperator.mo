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
parameter SI.CoefficientOfHeatTransfer U_recup = 65 "gas to gas overall U value. source: Cao, Eduardo. 2010. “TYPICAL HEAT TRANSFER COEFFICIENTS.” Chap. G in Heat Transfer in Process Engineering. 1st ed. New York: . https://www.accessengineeringlibrary.com/content/book/9780071624084/back-matter/appendix7";

parameter SI.Pressure p_reactor = 7e5 "Reactor pressure [Pa]";
parameter SI.Temperature T_H2_from_expander = 20 + 273.15 "H2 temperature from the expander [K]";
parameter SI.MassFlowRate m_dot_H2_from_expander = 2.82558 * 6 "H2 mass flow rate from the expander [kg/s]";

parameter SI.Temperature T_condensation = 99 + 273.15 "Condensation of water at partial pressure";
parameter SI.MassFlowRate m_dot_excess_H2= 2.82558 * 6 "Excess H2O and H2 coming off the reactor";
parameter SI.MassFlowRate m_dot_excess_H2O= 3.832875 * 6 "Excess H2O and H2 coming off the reactor";
parameter SI.MassFlowRate m_dot_excess_H2_and_H2O = m_dot_excess_H2 + m_dot_excess_H2O "Excess H2O and H2 coming off the reactor";
parameter SI.Temperature T_hot = 600 + 273.15 "Reactor operating temperature [K]";
parameter SI.Temperature T_hot_out = 164.9 + 273.15 "After several iteration, I found that this is the closest temperature I can get to achieve energy balance in the recuperator";

parameter MedGas2.ThermodynamicState state_excess_H2_hot = MedGas2.setState_pTX(p=p_reactor, T=T_hot);
parameter MedGas2.ThermodynamicState state_excess_H2_cold = MedGas2.setState_pTX(p=p_reactor, T=T_condensation);
parameter MedWater.ThermodynamicState state_excess_H2O_hot = MedWater.setState_pTX(p=p_reactor , T=T_hot);
parameter MedWater.ThermodynamicState state_excess_H2O_cold = MedWater.setState_pTX(p=p_reactor , T=T_condensation);

parameter SI.MassFlowRate m_dot_H2_cold = m_dot_excess_H2 + m_dot_H2_from_expander "Mass flow rate of the cold H2 stream (excess + feedstock)";

/*Mixing of two H2 streams*/
parameter MedGas2.ThermodynamicState state_H2_after_condensation = MedGas2.setState_pTX(
    p = p_reactor,
    T = T_condensation
);
parameter MedGas2.ThermodynamicState state_H2_from_expander = MedGas2.setState_pTX(    p = p_reactor,
    T = T_H2_from_expander
);

parameter SI.SpecificEnthalpy h_H2_after_mixing = (m_dot_excess_H2 * MedGas2.specificEnthalpy(state_H2_after_condensation) + m_dot_H2_from_expander * MedGas2.specificEnthalpy(state_H2_from_expander)) / (m_dot_H2_cold);

parameter MedGas2.ThermodynamicState state_H2_cold_after_mixing = MedGas2.setState_phX(p=p_reactor, h=h_H2_after_mixing);
parameter SI.Temperature T_cold_in = MedGas2.temperature(state_H2_cold_after_mixing);

/*Designing the recuperator*/
parameter SI.HeatFlowRate Q_recup = m_dot_excess_H2 * (MedGas2.specificEnthalpy(state_excess_H2_hot) - MedGas2.specificEnthalpy(state_excess_H2_cold)) + m_dot_excess_H2O * (MedWater.specificEnthalpy(state_excess_H2O_hot) - MedWater.specificEnthalpy(state_excess_H2O_cold)) "Recuperator heat rating [W]";

parameter SI.SpecificEnthalpy h_H2_after_recup = Q_recup/m_dot_H2_cold + MedGas2.specificEnthalpy(state_H2_cold_after_mixing);
parameter MedGas2.ThermodynamicState state_H2_after_recup = MedGas2.setState_phX(p = p_reactor, h=h_H2_after_recup);
parameter SI.Temperature T_H2_after_recup(fixed=false);


parameter SI.TemperatureDifference LMTD_recup = ((T_hot-T_H2_after_recup)-(T_condensation-T_cold_in))/(log((T_hot-T_H2_after_recup)/(T_condensation-T_cold_in)));

parameter SI.Area A_recup(fixed=false); 

initial equation
T_H2_after_recup = MedGas2.temperature(state_H2_after_recup);
//FIXME: two phase flow then it the U_recup value has to be adjusted
A_recup = Q_recup / LMTD_recup / U_recup;
equation

end ReactorRecuperator;