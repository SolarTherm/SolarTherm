within SolarTherm.Models.Fluid.HeatExchangers;

model ParticleGasHXCalculator
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  /*HTF properties*/
  replaceable package PCL = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  replaceable package AIR = Modelica.Media.Air.ReferenceAir.Air_Utilities;
  
  replaceable package Med_PCL = SolarTherm.Media.SolidParticles.CarboHSP_ph;
  replaceable package Med_AIR = Modelica.Media.Air.ReferenceAir.Air_ph;
    
  /*Particle thermophysical properties*/
  parameter SI.Length D_particle = 0.00035 "Particle diameter in m";
  parameter SI.Efficiency eta_particle = 0.403 * (D_particle * 100)^0.14 "Particle volume fraction as a function of DP (source: P45 report)";
  parameter SI.Volume V_particle = 4/3 * CN.pi * (D_particle/2) ^3 "Particle volume m3";
  parameter SI.Volume A_particle = 4 * CN.pi * (D_particle/2) ^2 "Particle surface area m2";
  
  /*On-design parameters*/
  parameter Integer num_seg = 6 "Segmentation of heat exchanger";
  parameter SI.Pressure p_working = 1e5 "Working pressure in Pa";
  
  parameter SI.Length W_HX = 6.4942578200676 "Heat exchanger air manifold width in m";
  parameter SI.Length H_HX = 6.4942578200676 "Heat exchanger air manifold height in m";
  parameter SI.Temperature T_in_AIR_DP = 25 + 273.15 "Air inlet temperature at design point (K)";
  parameter SI.Temperature T_out_AIR_DP = 828.505745884826 "Air outlet temperature at design point (K)";
  parameter SI.MassFlowRate m_dot_AIR_DP = 1860.71496128477 "Desired mass flow rate of air at design point (kg/s)";
  parameter SI.Temperature T_in_PCL_DP = 1153.25160972278 "Particles inlet temperature at design point (K)";
  parameter SI.Temperature T_out_PCL_DP = 950.658597989703 "Particles outlet temperature at design point (K). Equals to the cold tank target temperature";
  
  /*Calculated parameters*/
  parameter SI.Power Q_HX_DP(fixed=false) "HX thermal rating (W)";
  parameter SI.MassFlowRate m_dot_PCL_DP(fixed=false) "Particles mass flow rate at design point (kg/s)";
    
  parameter SI.Temperature[num_seg+1] T_AIR_DP(
      each fixed=false
  ) "Temperature of the air across the HX at design point";
  
  parameter SI.Temperature[num_seg+1] T_PCL_DP(
      each fixed=false
  ) "Temperature of the particles across the HX at design point";
  
  parameter SI.Area A_HX(fixed=false, min = 1) "Heat exchanger area (m^2)";
  
  parameter SI.SpecificEnthalpy[num_seg+1] h_PCL_DP(
      each fixed=false,
      start = linspace(PCL.h_T(T_in_PCL_DP), PCL.h_T(T_out_PCL_DP), num_seg+1),
      min = fill(0, num_seg+1)    
  );
  parameter SI.SpecificEnthalpy[num_seg+1] h_AIR_DP(
      each fixed=false,
      start = linspace(AIR.h_pT(p_working,T_out_AIR_DP), AIR.h_pT(p_working,T_in_AIR_DP), num_seg+1),
      min = fill(0, num_seg+1)
  );
  
  parameter SI.Area[num_seg] A_HX_dis(each fixed=false) "Heat exchanger segment area in m2";
  parameter Real[num_seg] Nu_DP(each fixed=false) "Nusselt number at each HX segment";
  parameter Real[num_seg] Pr_DP(each fixed=false) "Prandtl number at each HX segment";
  parameter Real[num_seg] Re_DP(each fixed=false) "Reynolds number at each HX segment";
  parameter SI.Density[num_seg] rho_air_DP(each fixed=false) "Air density at each HX segment kg/m3";
  parameter SI.Velocity[num_seg] U_air_DP(each fixed=false) "Air velocity in m/s";
  parameter SI.DynamicViscosity[num_seg] mu_air_DP(each fixed=false) "Air DynamicViscosity at each HX segment Pa.s";
  parameter SI.SpecificHeatCapacity[num_seg] cp_air_DP(each fixed=false) "Air specific heat at each HX segment J/kg.K";
  parameter SI.ThermalConductivity[num_seg] k_air_DP(each fixed=false) "Air thermal conductivity W/m.K";
  parameter SI.CoefficientOfHeatTransfer[num_seg] U_HX_DP(each fixed=false) "Coefficient of heat transfer U-value in W m^-2 K^-1";


initial equation
/*
  DESIGN POINT CALCULATION
*/

initial equation

Q_HX_DP = m_dot_AIR_DP * (
    AIR.h_pT(p_working, T_out_AIR_DP) - AIR.h_pT(p_working, T_in_AIR_DP)
);

m_dot_PCL_DP = Q_HX_DP / (
    PCL.h_T(T_in_PCL_DP) - PCL.h_T(T_out_PCL_DP)
);


/*Boundary condition*/
h_PCL_DP[1] = PCL.h_T(T_in_PCL_DP);
h_PCL_DP[num_seg+1] = PCL.h_T(T_out_PCL_DP);

h_AIR_DP[1] = AIR.h_pT(p_working, T_out_AIR_DP);
h_AIR_DP[num_seg+1] = AIR.h_pT(p_working, T_in_AIR_DP);

T_PCL_DP[1] = T_in_PCL_DP;
T_PCL_DP[num_seg+1] = T_out_PCL_DP;

T_AIR_DP[1] = T_out_AIR_DP;
T_AIR_DP[num_seg+1] = T_in_AIR_DP;

/*Find the enthalpy and temperature*/
for i in 1: num_seg loop
    h_PCL_DP[i] - h_PCL_DP[i+1] =  Q_HX_DP/num_seg/m_dot_PCL_DP;
    h_AIR_DP[i] - h_AIR_DP[i+1] =  Q_HX_DP/num_seg/m_dot_AIR_DP;
end for;

for i in 2: num_seg loop
    T_PCL_DP[i] = PCL.T_h(h_PCL_DP[i]);
    T_AIR_DP[i] = AIR.T_ph(p_working, h_AIR_DP[i]);
end for;

//Loop over each HX segment -  index 1 is at the particle inlet port (air outlet port)
for i in 1:num_seg loop
    U_air_DP[i] = m_dot_AIR_DP/(
        AIR.rho_pT(p_working, 0.5 * (T_AIR_DP[i] + T_AIR_DP[i+1])) * W_HX * H_HX
    );
    //Let's calculate the U_air_DP[i] -- all air properties are evaluated at the average temperature
    rho_air_DP[i] = AIR.rho_pT(p_working, 0.5 * (T_AIR_DP[i] + T_AIR_DP[i+1]));
    
    mu_air_DP[i] = AIR.Transport.eta_dT(
        rho_air_DP[i],
        0.5 * (T_AIR_DP[i] + T_AIR_DP[i+1])
    );
    cp_air_DP[i] = AIR.cp_dT(
        rho_air_DP[i],
        0.5 * (T_AIR_DP[i] + T_AIR_DP[i+1])
    );
    
    k_air_DP[i] = AIR.Transport.lambda_dT(
        rho_air_DP[i],
        0.5 * (T_AIR_DP[i] + T_AIR_DP[i+1])      
    );
    
    Re_DP[i] =  rho_air_DP[i]* U_air_DP[i] * V_particle / ((1-eta_particle) * A_particle * mu_air_DP[i]);
    
    Pr_DP[i] = cp_air_DP[i] * mu_air_DP[i] / k_air_DP[i];
    
    Nu_DP[i] = 8.74 + 9.34 * (
        6 * (1-eta_particle)^0.2 * Re_DP[i]^0.2 * Pr_DP[i]^(1/3)
    );
    
    U_HX_DP[i] = Nu_DP[i] * k_air_DP[i] / D_particle;
    
    m_dot_AIR_DP * (h_AIR_DP[i]- h_AIR_DP[i+1]) = m_dot_PCL_DP * (h_PCL_DP[i] - h_PCL_DP[i+1]) "Energy balance";
    
    //A_HX_dis[i] = (Q_HX_DP / num_seg) / (U_HX_DP[i] * 0.5 * ((T_PCL_DP[i] - T_AIR_DP[i]) + (T_PCL_DP[i+1] - T_AIR_DP[i+1])));   
    
    m_dot_AIR_DP * (h_AIR_DP[i]- h_AIR_DP[i+1]) = U_HX_DP[i] * A_HX_dis[i] * 0.5 * ((T_PCL_DP[i] - T_AIR_DP[i]) + (T_PCL_DP[i+1] - T_AIR_DP[i+1]));
    
    /*Calculate the required area*/
    //A_HX_dis[i] = (Q_HX_DP / num_seg) / (U_HX_DP[i] * 0.5 * ((T_PCL_DP[i] - T_AIR_DP[i]) + (T_PCL_DP[i+1] - T_AIR_DP[i+1]))) "Simmon Kamerling said that LMTD gives the same result as average delta temp";
end for;

A_HX = sum(A_HX_dis);




end ParticleGasHXCalculator;