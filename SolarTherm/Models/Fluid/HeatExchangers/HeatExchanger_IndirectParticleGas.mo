within SolarTherm.Models.Fluid.HeatExchangers;

model HeatExchanger_IndirectParticleGas
/*Indirect heat exchanger for particle to gas. Based on https://doi.org/10.1016/j.solener.2018.11.065*/

import SI = Modelica.SIunits;
import MedParticle = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
//import MedGas = SolarTherm.Media.CO2.CO2_utilities;
import MedGas = Modelica.Media.IdealGases.Common.Functions;

//replaceable package MedGas2 = SolarTherm.Media.CO2.CO2_ph;
replaceable package MedGas2 = Modelica.Media.IdealGases.Common.SingleGasNasa(
  data=Modelica.Media.IdealGases.Common.SingleGasesData.H2,
  mediumName="Hydrogen",
  fluidConstants={Modelica.Media.IdealGases.Common.FluidData.H2}
);

/*
replaceable package MedGas2 = Modelica.Media.IdealGases.Common.SingleGasNasa(
  data=Modelica.Media.IdealGases.Common.SingleGasesData.O2,
  mediumName="Hydrogen",
  fluidConstants={Modelica.Media.IdealGases.Common.FluidData.O2}
);
*/
//replaceable package H2_data = Modelica.Media.IdealGases.SingleGases.H2;
parameter Modelica.Media.IdealGases.Common.DataRecord gas_data = Modelica.Media.IdealGases.Common.SingleGasesData.H2;
//parameter Modelica.Media.IdealGases.Common.DataRecord gas_data = Modelica.Media.IdealGases.Common.SingleGasesData.O2;

parameter Modelica.Blocks.Types.ExternalCombiTable2D tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D(
        tableName = "Enthalpy",fileName= Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/CO2/Props_from_P_T.txt"),table=fill(0.0, 0, 2),smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments);
        
parameter Modelica.Blocks.Types.ExternalCombiTable2D tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D(tableName = "Density", fileName = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/CO2/Props_from_P_H.txt"), table = fill(0.0, 0, 2), smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments);

/*Thermophysical properties of the particle*/
parameter Real e_s = 0.4 "Void fraction";
parameter SI.Length d_pcl = 350e-6 "Diameter of the particle [m]";


/*Pre-determined parameters*/
parameter SI.Temperature T_in_gas_DP = 550+273.15 "Inlet gas temperature at design point [K]";
parameter SI.Temperature T_out_gas_DP = 700+273.15 "Outlet gas temperature at design point [K]";
parameter SI.MassFlowRate m_dot_gas_DP = 0.46;// 0.0238 / 0.0155826 * 0.02 "Mass flow rate of the gas at design point [kg/s]";
parameter SI.MassFlowRate p_gas_DP = 7e5 "Pressure of the gas at design point [Pa]";

parameter SI.Temperature T_in_pcl_DP = 800 + 273.15 "Inlet particle temperature at design point [K]";
parameter SI.Temperature T_out_pcl_DP = 550+273.15 "Outlet particle temperature at design point [K]";

parameter SI.Length d_gas_pipe = 0.5e-3 "Gas channel diameter";
parameter SI.Length w_ch = 6e-3 "Particle channel width (gap between plates)";
parameter SI.Length th_wall = 1e-3 "Heat exchanger thickness";
parameter SI.Area A_plate = 0.1 "Plate area [m2]";
parameter Real ratio = 0.5 "H/L ratio of the plate. See https://doi.org/10.1016/j.solener.2018.11.065";
parameter SI.Length l_gas_pipe = (A_plate/ratio)^0.5;
parameter SI.ThermalConductivity k_HX = 23 "Thermal conductivity of the HX https://doi.org/10.1115/1.4041546";

/*Calculated parameters*/
//parameter SI.SpecificEnthalpy h_in_gas_DP = MedGas.h_p_T(tableID = tableIDh_p_T, T = T_in_gas_DP, p = p_gas_DP) "Inlet specific enthalpy of the gas [J/kg]";
//parameter SI.SpecificEnthalpy h_out_gas_DP = MedGas.h_p_T(tableID = tableIDh_p_T, T = T_out_gas_DP, p = p_gas_DP) "Outlet specific enthalpy of the gas [J/kg]";
parameter SI.SpecificEnthalpy h_in_gas_DP = MedGas.h_T(gas_data, T_in_gas_DP) "Inlet specific enthalpy of the gas [J/kg]";
parameter SI.SpecificEnthalpy h_out_gas_DP = MedGas.h_T(gas_data, T_out_gas_DP) "Outlet specific enthalpy of the gas [J/kg]";

parameter SI.SpecificEnthalpy h_in_pcl_DP = MedParticle.h_T(T_in_pcl_DP) "Inlet specific enthalpy of the pcl [J/kg]";
parameter SI.SpecificEnthalpy h_out_pcl_DP = MedParticle.h_T(T_out_pcl_DP) "Outlet specific enthalpy of the pcl [J/kg]";

parameter SI.Power Q_rating_HX = m_dot_gas_DP * (h_out_gas_DP - h_in_gas_DP) "Design rating of the heat exchanger [Wth]";
parameter SI.MassFlowRate m_dot_pcl_DP = Q_rating_HX / (h_in_pcl_DP-h_out_pcl_DP) "Mass flow rate of the pcl at design point [kg/s]";

/*Discretise the HX*/
parameter Integer N_disc = 50 "Discretisations of the temperatures";

parameter MedGas2.ThermodynamicState[N_disc-1] state_gas_DP(each p.fixed = false, each T.fixed = false);
parameter SI.Power Q_dot_disc[N_disc-1](each fixed=false, each min=0)"Thermal power for each HX module";
parameter SI.ThermalConductance UA_DP[N_disc-1](each fixed = false) "UA value [W/K] for each HX module at design point";
parameter SI.TemperatureDifference LMTD_DP[N_disc-1](each fixed = false, each min=0) "LMTD [K] at design point";
parameter SI.CoefficientOfHeatTransfer U_DP[N_disc-1](each fixed=false) "U value [W/m2.K] for each module";
parameter SI.Area A[N_disc-1](each fixed=false) "Area of each HX module [m2]";

parameter SI.Density rho_gas_DP[N_disc-1](each fixed=false) "Gas density at design point";
parameter SI.Velocity u_gas_DP[N_disc-1](each fixed=false) "Gas velocity at design point";
parameter Real Re_gas_DP[N_disc-1](each fixed=false, each min=0) "Reynolds number at design point";
parameter Real Pr_gas_DP[N_disc-1](each fixed=false, each min=0) "Prandtl number at design point";
parameter Real Gz_gas_DP[N_disc-1](each fixed=false, each min=0) "Graez number at design point";
parameter Real inv_Gz_gas_DP[N_disc-1](each fixed=false) "Inv. Graez number at design point";
parameter Real Nu_plate_DP[N_disc-1](each fixed=false) "Nusselt number between plates at design point";
parameter Real Nu_gas_DP[N_disc-1](each fixed=false) "Nusselt number of the gas at design point";
parameter SI.CoefficientOfHeatTransfer h_sw_DP[N_disc-1](each fixed=false) "Particle-wall cnvection coefficient at DP [W/m2-K]";
parameter SI.CoefficientOfHeatTransfer h_gas_DP[N_disc-1](each fixed=false) "Gas convection coefficient at DP [W/m2-K]";
parameter Real K_DP[N_disc-1](each fixed=false) "Thermal conductivity ratio of the particle and gas";
parameter SI.Efficiency psi_w_DP[N_disc-1](each fixed=false) "Effective thickness of the fluid film at DP";
parameter SI.ThermalResistance R_double_prime_DP[N_disc-1](each fixed=false) "Thermal resistance of the near wall region";

parameter SI.Efficiency e_HX_DP[N_disc-1](each fixed=false, each min=0, each max=1) "Effectiveness of the HX";
parameter SI.Efficiency Cr_DP[N_disc-1](each fixed=false, each min=0, each max=1) "capacitance ratio";
parameter SI.Efficiency NTU_DP[N_disc-1](each fixed=false) "NTU";
parameter SI.Power Q_HX_max_DP[N_disc-1](each fixed=false) "Max heat can be transferred";
parameter SI.HeatCapacity C_max_DP[N_disc-1](each fixed=false) "Max heat capacity";
parameter SI.HeatCapacity C_min_DP[N_disc-1](each fixed=false) "Max heat capacity";


parameter Real num_gas_pipe = ceil(l_gas_pipe/(d_gas_pipe+w_ch)) "Number of gas pipe";
parameter Real num_pcl_channel = ceil(ratio*l_gas_pipe/(d_gas_pipe+th_wall+w_ch)) "Number of pcl channel";

parameter SI.ThermalConductivity k_pcl_DP[N_disc-1](each fixed=false) "Effective  bulk thermal conductivity at desing point [W/mK]";
parameter SI.ThermalConductivity k_pcl_nw_DP[N_disc-1](each fixed=false) "Particle near-wall thermal conductivity at design point [W/mK]";
parameter SI.Efficiency ew_DP[N_disc-1](each fixed=false) "Near-wall voidage at design point";

parameter SI.Temperature T_pcl_DP[N_disc](
    each fixed=false, start=fill(linspace(T_in_pcl_DP,T_out_pcl_DP,N_disc)), each min=298.15
) "Particle temperature distribution at design point";
parameter SI.Temperature T_gas_DP[N_disc](
    each fixed=false, start=fill(linspace(T_out_gas_DP,T_in_gas_DP,N_disc))
) "Gas temperature distribution at design point";

parameter SI.Area A_HX(fixed=false);

/*Off-design variables*/
parameter SI.MassFlowRate m_dot_pcl_off = 0.46 "Mass flow rate of the pcl at off-design condition";
parameter SI.MassFlowRate m_dot_gas_off = 0.46;//0.0238 / 0.0155826 * 0.02 "Mass flow rate of the g at off-design condition";
parameter SI.Temperature T_in_pcl_off = 790 + 273.15 "Off design inlet temperature of the particle";
parameter SI.Temperature T_in_gas_off = 500 + 273.15 "Off design inlet temperature of the gas";
SI.Temperature T_out_pcl_off (start= T_in_gas_off + 50) "Off design outlet temperature of the particle";
SI.Temperature T_out_gas_off (start= T_in_pcl_off - 50) "Off design outlet temperature of the particle";

SI.Temperature T_pcl[N_disc](
    start = linspace(T_in_pcl_off, T_in_gas_off+50 ,N_disc)
);
SI.Temperature T_gas[N_disc](
    start = linspace(T_in_pcl_off-50, T_in_gas_off ,N_disc)
);

MedGas2.ThermodynamicState[N_disc-1] state_gas;
SI.Power Q_dot[N_disc-1]"Thermal power for each HX module";
SI.ThermalConductance UA[N_disc-1] "UA value [W/K] for each HX module at design point";
Real LMTD[N_disc-1](each min = 0) "LMTD [K] at design point";
SI.CoefficientOfHeatTransfer U[N_disc-1] "U value [W/m2.K] for each module";

SI.Density rho_gas[N_disc-1] "Gas density at off-design point";
SI.Velocity u_gas[N_disc-1] "Gas velocity at off-design point";
Real Re_gas[N_disc-1] "Reynolds number at off-design point";
Real Pr_gas[N_disc-1] "Prandtl number at off-design point";
Real Gz_gas[N_disc-1] "Graez number at off-design point";
Real Nu_plate[N_disc-1] "Nusselt number between plates at off-design point";
Real Nu_gas[N_disc-1] "Nusselt number of the gas at off-design point";
SI.CoefficientOfHeatTransfer h_sw[N_disc-1] "Particle-wall convection coefficient at off-design [W/m2-K]";
SI.CoefficientOfHeatTransfer h_gas[N_disc-1] "Gas convection coefficient at off-design [W/m2-K]";
Real K[N_disc-1] "Thermal conductivity ratio of the particle and gas off-design";
SI.Efficiency psi_w[N_disc-1] "Effective thickness of the fluid film at off-design";
SI.ThermalResistance R_double_prime[N_disc-1] "Thermal resistance of the near wall region off-design";

SI.ThermalConductivity k_pcl[N_disc-1](each fixed=false) "Effective  bulk thermal conductivity at off-desing point [W/mK]";
SI.ThermalConductivity k_pcl_nw[N_disc-1](each fixed=false) "Particle near-wall thermal conductivity at off design point [W/mK]";
SI.Efficiency ew[N_disc-1](each fixed=false) "Near-wall voidage at off-design point";

initial equation
Q_dot_disc = fill(Q_rating_HX/(N_disc-1), N_disc-1);

/*Assign the inlet amd outlet  temperature*/
T_pcl_DP[1] = T_in_pcl_DP;
T_gas_DP[N_disc] = T_in_gas_DP;

for i in 1:N_disc-1 loop
    Q_dot_disc[i] = m_dot_pcl_DP *(
        MedParticle.h_T(T_pcl_DP[i]) - MedParticle.h_T(T_pcl_DP[i+1]) 
    ) "Using energy balance, calculate temperature of particle at each module";
    
    
    Q_dot_disc[i] = m_dot_gas_DP * (
       MedGas.h_T(gas_data, T_gas_DP[i]) - MedGas.h_T(gas_data, T_gas_DP[i+1])
    );
    
    //Q_dot_disc[i] = m_dot_gas_DP * (
    //   MedGas.h_p_T(tableID = tableIDh_p_T, T = T_gas_DP[i], p = p_gas_DP) - MedGas.h_p_T(tableID = tableIDh_p_T, T = T_gas_DP[i+1], p = p_gas_DP)
    // "Using energy balance, calculate temperature of gas at each module";
    /*Start implementing Ho's model
    
    Q_HX_max_DP[i] = m_dot_pcl_DP/num_pcl_channel * (T_pcl_DP[i] - T_gas_DP[i+1]);
    C_max_DP[i] = m_dot_pcl_DP/num_pcl_channel * MedParticle.cp_T(T_pcl[i]);
    C_min_DP[i] = m_dot_gas_DP/num_gas_pipe * MedGas2.heatCapacity_cp(state_gas_DP[i]);
    Cr_DP[i] = C_min_DP[i]/C_max_DP[i];
    NTU_DP[i] = UA_DP[i]/C_min_DP[i];
    e_HX_DP[i] = 1 - exp(
        (NTU_DP[i]^0.22/Cr_DP[i]) * ((exp(Cr_DP[i]*(-1) * NTU_DP[i]^0.78))-1)
    );
    Q_dot_disc[i] = e_HX_DP[i] * Q_HX_max_DP[i];*/
    
    state_gas_DP[i] = MedGas2.setState_pTX(
        p=p_gas_DP, 
        T = (T_gas_DP[i] + T_gas_DP[i+1])/2
    ) "Thermodynamic state of the gas at DP (at average temperature)";
    /*
    LMTD_DP[i] = (
        (T_pcl_DP[i] - T_gas_DP[i]) - (T_pcl_DP[i+1] - T_gas_DP[i+1])
    ) / (
        log((T_pcl_DP[i] - T_gas_DP[i])/(T_pcl_DP[i+1] - T_gas_DP[i+1]))
    ) "LMTD for each module";
    */
    LMTD_DP[i] = ((T_pcl_DP[i] - T_gas_DP[i]) + (T_pcl_DP[i+1] - T_gas_DP[i+1]))/2 "Average dT";
    
    UA_DP[i] = Q_dot_disc[i]/LMTD_DP[i] "UA value [W/K] for each module";
    
    rho_gas_DP[i] = MedGas2.density(state_gas_DP[i]);
    u_gas_DP[i] = (m_dot_gas_DP/num_gas_pipe)/ (rho_gas_DP[i] * 0.25 * 3.14 * d_gas_pipe^2);
    Re_gas_DP[i] = rho_gas_DP[i] * u_gas_DP[i] * d_gas_pipe / MedGas2.dynamicViscosity(state_gas_DP[i]);
    Pr_gas_DP[i] = MedGas2.specificHeatCapacityCp(state_gas_DP[i]) * MedGas2.dynamicViscosity(state_gas_DP[i])/MedGas2.thermalConductivity(state_gas_DP[i]);
    Gz_gas_DP[i] = d_gas_pipe/l_gas_pipe*Re_gas_DP[i] * Pr_gas_DP[i];
    inv_Gz_gas_DP[i] = 1/Gz_gas_DP[i];
    Nu_plate_DP[i] = (
        (
            (2*0.886/(1/Gz_gas_DP[i])^0.5)^(12/5) + 12^(12/5)
        )
    )^(5/12);
    k_pcl_DP[i] = 0.000266763101628 * ((T_pcl_DP[i] + T_pcl_DP[i+1])/2) + 0.201815957816402 "Regression of bulk k as a function of average T particle Based on https://doi.org/10.1016/j.solener.2018.11.065 particle diameter is 350 micro meter";
    ew_DP[i]= 1 - (1 - e_s) * (0.7293 + 0.5139 * 0) "0 because of flat plate";
    K_DP[i] = k_pcl_DP[i]/MedGas2.thermalConductivity(state_gas_DP[i]) "https://doi.org/10.1016/0009-2509(78)80011-6";
    
    psi_w_DP[i] = 0.25 * (
        ((K_DP[i]-1)/K_DP[i])^2/(log(K_DP[i]) - (K_DP[i]-1)/K_DP[i])
    ) - 1/(3*K_DP[i]) "Equation based on https://doi.org/10.1016/0009-2509(78)80011-6";
    
    k_pcl_nw_DP[i] = MedGas2.thermalConductivity(state_gas_DP[i]) * (
        ew_DP[i] + (1-ew_DP[i])/(2/3 * (MedGas2.thermalConductivity(state_gas_DP[i])/k_pcl_DP[i]) + 2 * psi_w_DP[i])
    );
    R_double_prime_DP[i] = d_pcl / (2* k_pcl_nw_DP[i]);
    h_sw_DP[i] = Nu_plate_DP[i] * k_pcl_DP[i] / (2*w_ch) "Based on https://doi.org/10.1016/j.solener.2018.11.065";
    
    Nu_gas_DP[i] = 0.023 * Re_gas_DP[i]^0.8 * Pr_gas_DP[i]^0.4 "Dittus Boetler equation https://doi.org/10.1016/j.icheatmasstransfer.2020.104819 p.1";
    h_gas_DP[i] = Nu_gas_DP[i] * MedGas2.thermalConductivity(state_gas_DP[i]) / d_gas_pipe;
    U_DP[i] = (1/h_gas_DP[i] + th_wall/k_HX + R_double_prime_DP[i] + 1/h_sw_DP[i])^(-1);
    A[i] = UA_DP[i]/U_DP[i];
end for;
A_HX = sum(A);



equation
T_pcl[1] = T_in_pcl_off;
T_pcl[N_disc] = T_out_pcl_off;
T_gas[N_disc] = T_in_gas_off;
T_gas[1] = T_out_gas_off;

for i in 1:N_disc-1 loop
    /*m_dot_pcl_off * (MedParticle.h_T(T_pcl[i]) - MedParticle.h_T(T_pcl[i+1])) = 
        m_dot_gas_off * (
            MedGas.h_p_T(tableID = tableIDh_p_T, T = T_gas[i], p = p_gas_DP) - 
            MedGas.h_p_T(tableID = tableIDh_p_T, T = T_gas[i+1], p = p_gas_DP)
    ) "Energy balance between two streams";*/
    
    m_dot_pcl_off * (MedParticle.h_T(T_pcl[i]) - MedParticle.h_T(T_pcl[i+1])) = 
        m_dot_gas_off * (
            MedGas.h_T(gas_data, T_gas[i]) - 
            MedGas.h_T(gas_data, T_gas[i+1])
    ) "Energy balance between two streams";
    
    Q_dot[i] = m_dot_pcl_off * (MedParticle.h_T(T_pcl[i]) - MedParticle.h_T(T_pcl[i+1])) "Calculating heat transfered at each module";
    LMTD[i] = ((T_pcl[i] - T_gas[i]) + (T_pcl[i+1] - T_gas[i+1]))/2 "Average dT";
    
    UA[i] = U[i] * A[i] "UA value [W/K] for each module, using A from the design point";
    
    m_dot_pcl_off * (
        MedParticle.h_T(T_pcl[i]) - MedParticle.h_T(T_pcl[i+1]) 
    ) = UA[i] * LMTD[i] "Energy balance using UA LMTD";
    
    state_gas[i] = MedGas2.setState_pTX(
        p=p_gas_DP, 
        T = (T_gas[i] + T_gas[i+1])/2
    ) "Thermodynamic state of the gas at DP (at average temperature)";
    
    rho_gas[i] = MedGas2.density(state_gas[i]);
    u_gas[i] = (m_dot_gas_off/num_gas_pipe)/ (rho_gas[i] * 0.25 * 3.14 * d_gas_pipe^2);
    Re_gas[i] = rho_gas[i] * u_gas[i] * d_gas_pipe / MedGas2.dynamicViscosity(state_gas[i]);
    Pr_gas[i] = MedGas2.specificHeatCapacityCp(state_gas[i]) * MedGas2.dynamicViscosity(state_gas[i])/MedGas2.thermalConductivity(state_gas[i]);
    Gz_gas[i] = d_gas_pipe/l_gas_pipe*Re_gas[i] * Pr_gas[i];
    Nu_plate[i] = (
        (
            (2*0.886/(1/Gz_gas[i])^0.5)^(12/5) + 12^(12/5)
        )
    )^(5/12);
    k_pcl[i] = 0.000266763101628 * ((T_pcl[i] + T_pcl[i+1])/2) + 0.201815957816402 "Regression of bulk k as a function of average T particle Based on https://doi.org/10.1016/j.solener.2018.11.065 particle diameter is 350 micro meter";
    ew[i]= 1 - (1 - e_s) * (0.7293 + 0.5139 * 0) "0 because of flat plate";
    K[i] = k_pcl[i]/MedGas2.thermalConductivity(state_gas[i]) "https://doi.org/10.1016/0009-2509(78)80011-6";
    
    psi_w[i] = 0.25 * (
        ((K[i]-1)/K[i])^2/(log(K[i]) - (K[i]-1)/K[i])
    ) - 1/(3*K[i]) "Equation based on https://doi.org/10.1016/0009-2509(78)80011-6";
    
    k_pcl_nw[i] = MedGas2.thermalConductivity(state_gas[i]) * (
        ew[i] + (1-ew[i])/(2/3 * (MedGas2.thermalConductivity(state_gas[i])/k_pcl[i]) + 2 * psi_w[i])
    );
    R_double_prime[i] = d_pcl / (2* k_pcl_nw[i]);
    h_sw[i] = Nu_plate[i] * k_pcl[i] / (2*w_ch) "Based on https://doi.org/10.1016/j.solener.2018.11.065";
    
    Nu_gas[i] = 0.023 * Re_gas[i]^0.8 * Pr_gas[i]^0.4 "Dittus Boetler equation https://doi.org/10.1016/j.icheatmasstransfer.2020.104819 p.1";
    h_gas[i] = Nu_gas[i] * MedGas2.thermalConductivity(state_gas[i]) / d_gas_pipe;
    U[i] = (1/h_gas[i] + th_wall/k_HX + R_double_prime[i] + 1/h_sw[i])^(-1);
end for;

end HeatExchanger_IndirectParticleGas;
