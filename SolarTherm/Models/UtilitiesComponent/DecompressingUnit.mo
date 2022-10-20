within SolarTherm.Models.UtilitiesComponent;

model DecompressingUnit
/*This model is the decompressing unit model through which the pressurised H2 from the tank is de-pressurised, and heated*/

import SI = Modelica.SIunits;
import CN = Modelica.Constants;
import MedGas = Modelica.Media.IdealGases.Common.Functions;
replaceable package MedGas2 = Modelica.Media.IdealGases.Common.SingleGasNasa(
      data = Modelica.Media.IdealGases.Common.SingleGasesData.O2, 
      mediumName = "Hydrogen", fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2}
); 
  
parameter Modelica.Media.IdealGases.Common.DataRecord gas_data = Modelica.Media.IdealGases.Common.SingleGasesData.H2;

parameter SI.CoefficientOfHeatTransfer U_intercooler = 65 "gas to gas overall U value. source: Cao, Eduardo. 2010. “TYPICAL HEAT TRANSFER COEFFICIENTS.” Chap. G in Heat Transfer in Process Engineering. 1st ed. New York: . https://www.accessengineeringlibrary.com/content/book/9780071624084/back-matter/appendix7";

parameter SI.MassFlowRate m_dot_H2_AEL_DP = 20 "Mass flow rate of the H2 from AEL";
parameter SI.MassFlowRate m_dot_air_cooler = m_dot_H2_AEL_DP "Mass flow rate of the air in the intercooler";

parameter SI.Pressure p_tank = 100e5 "Tank pressure [Pa]";
parameter SI.Temperature T_tank = 80 + 273.15 "Tank temperature [K]";
parameter SI.Temperature T_amb = 25 + 273.15 "Ambient temperature of the air";
parameter SI.Temperature T_out_intercooler_target = T_amb - 5 "Temperature target for H2 heated in the intercooler [K]";

parameter Real re1 = 3 "Ratio pressure of the first compressor";
parameter Real re2 = 3 "Ratio pressure of the second compressor";

parameter SI.Pressure p_1 = p_tank/re1 "Pressure after first expander [Pa]";
parameter SI.Pressure p_2 = p_1/re2 "Pressure after the second expander [Pa]";
parameter SI.Pressure p_reactor = 7e5 "Reactor pressure [Pa] --> target";


parameter SI.Efficiency eta_isen_e1 = 0.95 "Isentropic efficiency of the first compressor";
parameter SI.Efficiency eta_isen_e2 = 0.95 "Isentropic efficiency of the second compressor";
parameter SI.Efficiency eta_isen_e3 = 0.95 "Isentropic efficiency of the third compressor";

parameter MedGas2.ThermodynamicState state_gas_in = MedGas2.setState_pTX(
        p=p_tank, 
        T = T_tank
) "Thermodynamic state of the gas at inlet";

parameter SI.SpecificEnthalpy h_in = MedGas2.specificEnthalpy(state_gas_in);

parameter SI.Efficiency eta_isen_expander = 0.95 "Expander isentropic eff.";
parameter SI.SpecificEntropy s1s = MedGas2.specificEntropy(state_gas_in);

//FIXME: make multistage expansion

//First Expander
parameter MedGas2.ThermodynamicState state_gas_1s = MedGas2.setState_psX(
        p= p_1, 
        s = s1s
) "Isentropic thermodynamic state of the gas at inlet";
parameter SI.SpecificEnthalpy h_1s = MedGas2.specificEnthalpy(state_gas_1s);
parameter SI.SpecificEnthalpy h_1 =  h_in - eta_isen_expander*(h_in - h_1s);

//Heating by air - interheater 1
parameter MedGas2.ThermodynamicState state_gas_1 = MedGas2.setState_phX(
        p = p_1, 
        h = h_1
) "Isentropic thermodynamic state of the gas at inlet";
parameter SI.Temperature T_1 = MedGas2.temperature(state_gas_1);

parameter MedGas2.ThermodynamicState state_gas_1q = MedGas2.setState_pTX(
        p = p_1, 
        T = T_out_intercooler_target
) "Thermodynamic state of the gas after first interheater"; 

parameter SI.HeatFlowRate Q_1 = m_dot_H2_AEL_DP * (
    MedGas2.specificEnthalpy(state_gas_1q) - h_1
);
parameter SI.SpecificHeatCapacity cp_air = 1000;
parameter SI.Temperature T_out_air_1 = Q_1/(m_dot_air_cooler * cp_air) + T_amb;
parameter SI.TemperatureDifference LMTD_1 = ((T_amb-T_out_intercooler_target)-(T_out_air_1-T_1))/(log((T_amb-T_out_intercooler_target)/(T_out_air_1-T_1)));
parameter SI.Area A_intercooler1 = Q_1 / (LMTD_1 * U_intercooler);

//Designing expansion unit 2
parameter MedGas2.ThermodynamicState state_gas_2 = state_gas_1q;
parameter SI.SpecificEnthalpy h_2 = MedGas2.specificEnthalpy(state_gas_2);
parameter MedGas2.ThermodynamicState state_gas_3s = MedGas2.setState_psX(
    p = p_2,
    s = MedGas2.specificEntropy(state_gas_2)
);
parameter SI.SpecificEnthalpy h_3s = MedGas2.specificEnthalpy(state_gas_3s);
parameter SI.SpecificEnthalpy h_3 =  h_2 - eta_isen_expander*(h_2 - h_3s);
parameter MedGas2.ThermodynamicState state_gas_3 = MedGas2.setState_phX(
    p = p_2,
    h = h_3
);

parameter SI.Temperature T_3 = MedGas2.temperature(state_gas_3);

parameter MedGas2.ThermodynamicState state_gas_3q = MedGas2.setState_pTX(
        p = p_2, 
        T = T_out_intercooler_target
) "Thermodynamic state of the gas after the second interheater"; 

//Designing the second interheater
parameter SI.HeatFlowRate Q_2 = m_dot_H2_AEL_DP * (
    MedGas2.specificEnthalpy(state_gas_3q) - h_3
);
parameter SI.Temperature T_out_air_2 = Q_2/(m_dot_air_cooler * cp_air) + T_amb;
parameter SI.TemperatureDifference LMTD_2 = ((T_amb-T_out_intercooler_target)-(T_out_air_2-T_3))/(log((T_amb-T_out_intercooler_target)/(T_out_air_2-T_3)));
parameter SI.Area A_intercooler2 = Q_2 / (LMTD_2 * U_intercooler);

//Designing the third expansion
parameter MedGas2.ThermodynamicState state_gas_4 = state_gas_3q;
parameter SI.SpecificEnthalpy h_4 = MedGas2.specificEnthalpy(state_gas_4);
parameter MedGas2.ThermodynamicState state_gas_5s = MedGas2.setState_psX(
    p = p_reactor,
    s = MedGas2.specificEntropy(state_gas_4)
);
parameter SI.SpecificEnthalpy h_5s = MedGas2.specificEnthalpy(state_gas_5s);
parameter SI.SpecificEnthalpy h_5 =  h_4 - eta_isen_expander*(h_4 - h_5s);
parameter MedGas2.ThermodynamicState state_gas_5 = MedGas2.setState_phX(
    p = p_reactor,
    h = h_5
);

parameter SI.Temperature T_5 = MedGas2.temperature(state_gas_5);

parameter MedGas2.ThermodynamicState state_gas_5q = MedGas2.setState_pTX(
        p = p_reactor, 
        T = T_out_intercooler_target
) "Thermodynamic state of the gas after the second interheater"; 

//Designing the third interheater
parameter SI.HeatFlowRate Q_3 = m_dot_H2_AEL_DP * (
    MedGas2.specificEnthalpy(state_gas_5q) - h_5
);
parameter SI.Temperature T_out_air_3 = Q_3/(m_dot_air_cooler * cp_air) + T_amb;
parameter SI.TemperatureDifference LMTD_3 = ((T_amb-T_out_intercooler_target)-(T_out_air_3-T_5))/(log((T_amb-T_out_intercooler_target)/(T_out_air_3-T_5)));
parameter SI.Area A_intercooler3 = Q_3 / (LMTD_3 * U_intercooler);

parameter SI.Area A_total_intercooler = A_intercooler1 + A_intercooler2 + A_intercooler3;
parameter SI.Power W_exp_des1 = m_dot_H2_AEL_DP * (h_2 - h_1);
parameter SI.Power W_exp_des2 = m_dot_H2_AEL_DP * (h_3 - h_2);
parameter SI.Power W_exp_des3 = m_dot_H2_AEL_DP * (h_5 - h_4);

SI.Power W_exp_1; SI.Power W_exp_2; SI.Power W_exp_3; SI.Power W_exp_total;

  Modelica.Blocks.Interfaces.RealInput H2_in annotation(
    Placement(visible = true, transformation(origin = {-112, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput H2_out annotation(
    Placement(visible = true, transformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
H2_out = H2_in;
if H2_in > 1e-3 then
    W_exp_1 = W_exp_des1 * H2_in/m_dot_H2_AEL_DP;
    W_exp_2 = W_exp_des2 * H2_in/m_dot_H2_AEL_DP;
    W_exp_3 = W_exp_des3 * H2_in/m_dot_H2_AEL_DP;
else
    W_exp_1 = 0; W_exp_2 = 0; W_exp_3 = 0;
end if;

W_exp_total = W_exp_1 + W_exp_2 + W_exp_3;

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end DecompressingUnit;