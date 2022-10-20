within SolarTherm.Models.UtilitiesComponent;

model CompressorTrainH2
/*This model is a compressor train to compress H2,including the air-intercooler*/
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

//The compressor train consists of three compressors (HP, MP, LP) and three air-cooled intercoolers.
parameter SI.Pressure p_in = 7e5 "Inlet pressure of H2 is 7 bar from the AEL";

parameter SI.Temperature T_in = 80 + 273.15 "Inlet temperature of H2 from AEL";

parameter SI.Temperature T_amb  = 25 + 273.15 "Ambient temperature of the air";

parameter Real rc1 = 3 "Ratio pressure of the first compressor";
parameter Real rc2 = 3 "Ratio pressure of the second compressor";

parameter SI.Efficiency eta_isen_c1 = 0.95 "Isentropic efficiency of the first compressor";
parameter SI.Efficiency eta_isen_c2 = 0.95 "Isentropic efficiency of the second compressor";
parameter SI.Efficiency eta_isen_c3 = 0.95 "Isentropic efficiency of the third compressor";

parameter SI.Pressure p_out_1 = p_in * rc1 "Outlet pressure from the last compressor before being stored in the storage tank";
parameter SI.Pressure p_out_2 = p_out_1 * rc2 "Outlet pressure from the last compressor before being stored in the storage tank";
parameter SI.Pressure p_out_3 = 100e5 "Outlet pressure from the last compressor before being stored in the storage tank";


//******************LP region
// Thermodynamic state of the inlet
parameter MedGas2.ThermodynamicState state_gas_in = MedGas2.setState_pTX(
        p=p_in, 
        T = T_in
) "Thermodynamic state of the gas at inlet";
parameter SI.SpecificEnthalpy h_in = MedGas2.specificEnthalpy(state_gas_in);
parameter SI.SpecificEntropy s_in = MedGas2.specificEntropy(state_gas_in);

// Thermodynamic state after the LPC
parameter MedGas2.ThermodynamicState state_gas_1s = MedGas2.setState_psX(
        p = p_out_1, 
        s = s_in
) "Isentropic thermodynamic state of the gas after LPC";
parameter SI.SpecificEnthalpy h_1s = MedGas2.specificEnthalpy(state_gas_1s);
parameter SI.SpecificEnthalpy h_1 = (h_1s-h_in)/eta_isen_c1 + h_in;


//******************MP region
parameter MedGas2.ThermodynamicState state_gas_1 = MedGas2.setState_phX(
        p = p_out_1, 
        h = h_1
) "Thermodynamic state of the gas after LPC"; 
parameter SI.Temperature T_1 = MedGas2.temperature(state_gas_1);

parameter MedGas2.ThermodynamicState state_gas_1q = MedGas2.setState_pTX(
        p = p_out_1, 
        T = T_in
) "Thermodynamic state of the gas after first intercooler"; 

// Designing the first intercooler
parameter SI.HeatFlowRate Q_1 = m_dot_H2_AEL_DP * (
    h_1 - MedGas2.specificEnthalpy(state_gas_1q)
);
parameter SI.SpecificHeatCapacity cp_air = 1000;
parameter SI.Temperature T_out_air_1 = Q_1/(m_dot_air_cooler * cp_air) + T_amb;
parameter SI.TemperatureDifference LMTD_1 = ((T_1-T_out_air_1)-(T_in-T_amb))/(log((T_1-T_out_air_1)/(T_in-T_amb)));
parameter SI.Area A_intercooler1 = Q_1 / (LMTD_1 * U_intercooler);

//Thermodynamic state after the first cooler
parameter MedGas2.ThermodynamicState state_gas_2 = MedGas2.setState_pTX(
        p = p_out_1, 
        T = T_in
) "Thermodynamic state of the gas entering MPC"; 
parameter SI.SpecificEnthalpy h_2 = MedGas2.specificEnthalpy(state_gas_2);

parameter MedGas2.ThermodynamicState state_gas_3s = MedGas2.setState_psX(
        p = p_out_2, 
        s = MedGas2.specificEntropy(state_gas_2)
) "Isentropic thermodynamic state of the gas after MPC"; 

parameter SI.SpecificEnthalpy h_3s = MedGas2.specificEnthalpy(state_gas_3s);
parameter SI.SpecificEnthalpy h_3 = (h_3s-h_2)/eta_isen_c2 + h_2;
parameter MedGas2.ThermodynamicState state_gas_3 = MedGas2.setState_phX(
        p = p_out_2, 
        h = h_3
) "Thermodynamic state of the gas after MPC"; 
parameter SI.Temperature T_3 = MedGas2.temperature(state_gas_3);

parameter MedGas2.ThermodynamicState state_gas_3q = MedGas2.setState_pTX(
        p = p_out_2, 
        T = T_in
) "Thermodynamic state of the gas after second intercooler"; 

// Desigining the second intercooler
parameter SI.HeatFlowRate Q_2 = m_dot_H2_AEL_DP * (
    h_3 - MedGas2.specificEnthalpy(state_gas_1q)
);
parameter SI.Temperature T_out_air_2 = Q_2/(m_dot_air_cooler * cp_air) + T_amb;
parameter SI.TemperatureDifference LMTD_2 = ((T_3-T_out_air_2)-(T_in-T_amb))/(log((T_3-T_out_air_2)/(T_in-T_amb)));
parameter SI.Area A_intercooler2 = Q_2 / (LMTD_2 * U_intercooler);

parameter MedGas2.ThermodynamicState state_gas_4 = MedGas2.setState_pTX(
        p = p_out_2, 
        T = T_in
) "Thermodynamic state of the gas entering HPC"; 
parameter SI.SpecificEnthalpy h_4 = MedGas2.specificEnthalpy(state_gas_4);

parameter MedGas2.ThermodynamicState state_gas_5s = MedGas2.setState_psX(
        p = p_out_3, 
        s = MedGas2.specificEntropy(state_gas_4)
) "Isentropic thermodynamic state of the gas after HPC"; 

parameter SI.SpecificEnthalpy h_5s = MedGas2.specificEnthalpy(state_gas_5s);
parameter SI.SpecificEnthalpy h_5 = (h_5s-h_4)/eta_isen_c3 + h_4;

parameter MedGas2.ThermodynamicState state_gas_5 = MedGas2.setState_phX(
        p = p_out_3, 
        h = h_5
) "Thermodynamic state of the gas after HPC"; 

parameter SI.Temperature T_5 = MedGas2.temperature(state_gas_5);

parameter MedGas2.ThermodynamicState state_gas_5q = MedGas2.setState_pTX(
        p = p_out_3, 
        T = T_in
) "Thermodynamic state of the gas after the third intercooler"; 

// Desigining the second intercooler
parameter SI.HeatFlowRate Q_3 = m_dot_H2_AEL_DP * (
    h_5 - MedGas2.specificEnthalpy(state_gas_5q)
);
parameter SI.Temperature T_out_air_3 = Q_3/(m_dot_air_cooler * cp_air) + T_amb;
parameter SI.TemperatureDifference LMTD_3 = ((T_5-T_out_air_3)-(T_in-T_amb))/(log((T_5-T_out_air_3)/(T_in-T_amb)));
parameter SI.Area A_intercooler3 = Q_3 / (LMTD_3 * U_intercooler);

parameter SI.Area A_total_intercooler = A_intercooler1 + A_intercooler2 + A_intercooler3;
parameter SI.Power W_comp_des1 = m_dot_H2_AEL_DP * (h_2 - h_1);
parameter SI.Power W_comp_des2 = m_dot_H2_AEL_DP * (h_3 - h_2);
parameter SI.Power W_comp_des3 = m_dot_H2_AEL_DP * (h_5 - h_4);

SI.Power W_comp_1; SI.Power W_comp_2; SI.Power W_comp_3; SI.Power W_comp_total;

  Modelica.Blocks.Interfaces.RealInput H2_in annotation(
    Placement(visible = true, transformation(origin = {-112, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput H2_out annotation(
    Placement(visible = true, transformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
H2_out = H2_in;
if H2_in > 1e-3 then
    W_comp_1 = W_comp_des1 * H2_in/m_dot_H2_AEL_DP;
    W_comp_2 = W_comp_des2 * H2_in/m_dot_H2_AEL_DP;
    W_comp_3 = W_comp_des3 * H2_in/m_dot_H2_AEL_DP;
else
    W_comp_1 = 0; W_comp_2 = 0; W_comp_3 = 0;
end if;

W_comp_total = W_comp_1 + W_comp_2 + W_comp_3;

annotation(
    Diagram(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {3, -1}, extent = {{-91, 45}, {91, -45}}, textString = "Compressor Train")}),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end CompressorTrainH2;