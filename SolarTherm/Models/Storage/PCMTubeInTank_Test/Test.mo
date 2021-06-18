within SolarTherm.Models.Storage.PCMTubeInTank_Test;

model Test
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;
  //Materials used
  replaceable package Fluid = SolarTherm.Media.Materials.Sodium constrainedby SolarTherm.Media.Materials.PartialMaterial "Fluid Package";
  replaceable package PCM = SolarTherm.Media.Materials.CaO constrainedby SolarTherm.Media.Materials.PartialMaterial "PCM Package";
  replaceable package Wall = SolarTherm.Media.Materials.SS316L constrainedby SolarTherm.Media.Materials.PartialMaterial "Wall Package";
  Fluid.State fluid[N_p](each h_start = h_f_min) "Fluid object array";
  Fluid.State fluid_top "Model which calculates properties at top of the section";
  Fluid.State fluid_bot "Model which calculates properties at bottom of the section";
  Wall.State wall[N_p] "Wall object array";
  PCM.State pcm[N_p] "PCM object array";
  //Design parameters
  parameter SI.Energy E_max = 144e9 "Design storage capacity, J";
  parameter SI.Time t_charge = 6 * 3600 "charging time, s";
  parameter SI.Time t_discharge = 10 * 3600 "discharging time, s";
  parameter SI.Temperature T_min = CV.from_degC(540) "Design cold Temperature of everything in the tank, K";
  parameter SI.Temperature T_max = CV.from_degC(750) "Design hot Temperature of everything in the tank, K";
  parameter SI.Length L = 10 "Length of PCM tank, m";
  parameter SI.Length r_tube_in = 0.006265 "Tube inner radius, m";
  parameter SI.Length r_tube_out = 0.008575 "Tube outer radius, m";
  parameter SI.Length r_shell = 0.03 "Shell radius, m";
  parameter Integer N_sec = 1 "Number of mesh elements in fluid, wall and PCM regions";
  parameter Integer N_p = N_sec + 1 "Number of node";
  parameter SI.Length dL = L / N_sec "Length step in HTF flow direction";
  parameter SI.Length z_f[N_p] = Z_position(L, N_sec);
  parameter SI.Area A_HTF = CN.pi * r_tube_in ^ 2;
  parameter SI.Area A_Wall = CN.pi * (r_tube_out ^ 2 - r_tube_in ^ 2);
  parameter SI.Area A_PCM = CN.pi * (r_shell ^ 2 - r_tube_out ^ 2);
  parameter SI.Length r_PCM = ((r_shell ^ 2 + r_tube_out ^ 2) / 2) ^ 0.5 "Radius from PCM volume center";
  parameter SI.Length r_Wall = ((r_tube_out ^ 2 + r_tube_in ^ 2) / 2) ^ 0.5 "Radius from Wall volume center";
  parameter SI.Temperature T_f_start[N_p] = fill(T_min, N_p) "setting up initial temperature of HTF";
  parameter SI.Temperature T_w_start[N_p] = fill(T_min, N_p) "setting up initial temperature of wall";
  parameter SI.Temperature T_p_start[N_p] = fill(T_min, N_p) "setting up initial temperature of PCM";
  parameter SI.SpecificEnthalpy h_f_start[N_p] = fill(h_f_min, N_p) "setting up initial specific enthalpy of HTF";
  parameter SI.SpecificEnthalpy h_w_start[N_p] = fill(h_w_min, N_p) "setting up initial specific enthalpy of PCM";
  parameter SI.SpecificEnthalpy h_p_start[N_p] = fill(h_p_min, N_p) "setting up initial specific enthalpy of PCM";
  
  //Property bounds
  //HTF
  parameter SI.SpecificEnthalpy h_f_min = Fluid.h_Tf(T_min,1) "Starting enthalpy of the HTF";
  parameter SI.SpecificEnthalpy h_f_max = Fluid.h_Tf(T_max,1) "Starting enthalpy of the HTF";
  parameter SI.Density rho_f_min = Fluid.rho_Tf(T_min,1);
  parameter SI.Density rho_f_max = Fluid.rho_Tf(T_max,1);
  parameter SI.Density rho_f_avg = (rho_f_min + rho_f_max) / 2;
  //Wall
  parameter SI.SpecificEnthalpy h_w_min = Wall.h_Tf(T_min,0) "Starting enthalpy of the Wall";
  parameter SI.SpecificEnthalpy h_w_max = Wall.h_Tf(T_max,0) "Starting enthalpy of the Wall";
  parameter SI.Density rho_w_min = Wall.rho_Tf(T_min,0);
  parameter SI.Density rho_w_max = Wall.rho_Tf(T_max,0);
  parameter SI.Density rho_w_avg = (rho_w_min + rho_w_max) / 2;
  parameter SI.SpecificHeatCapacity cp_w[N_p] = fill(400, N_p) "J/kgK";
  parameter SI.ThermalConductivity k_w[N_p] = fill(15, N_p) "W/mK";  
  //PCM
  parameter SI.SpecificEnthalpy h_p_min = PCM.h_Tf(T_min,0) "Starting enthalpy of the PCM";
  parameter SI.SpecificEnthalpy h_p_max = PCM.h_Tf(T_max,1) "Starting enthalpy of the PCM";
  parameter SI.Density rho_p_min = PCM.rho_Tf(T_min,0);
  parameter SI.Density rho_p_max = PCM.rho_Tf(T_max,1);
  parameter SI.Density rho_p_avg = (rho_p_min + rho_p_max) / 2;
  parameter SI.SpecificHeatCapacity cp_p[N_p] = fill(1500, N_p) "J/kgK";
  parameter SI.ThermalConductivity k_p[N_p] = fill(0.5, N_p) "W/mK";
    
  //Property and initialization of HTF
  SI.SpecificEnthalpy h_f[N_p](start = h_f_start) "J/kg";
  SI.Temperature T_f[N_p];//(start = T_f_start);"initialization is not in Thermocline_Section2"
  SI.ThermalConductivity k_f[N_p] "W/mK";
  SI.DynamicViscosity mu_f[N_p] "Pa.s";
  SI.SpecificHeatCapacity cp_f[N_p] "J/kgK";
  //  SI.Denstity rho_f[N_p] "kg/m3";
  parameter SI.Mass m_f[N_p] = HTFSection_Mass(r_tube_in, L, rho_f_avg, N_sec) "Masses of each HTF element";
  //Convection Properties
  Real Re[N_p] "Reynolds";
  Real Pr[N_p] "Prandtl";
  Real Nu[N_p] "Nusselt";
  Real h_v[N_p] "heat transfer coefficient (W/m2K)";
  // Convection parameters
  Real Xplus[N_p] "Dimensionless distance";
  //Operational Controls
  Integer State(start = 2) "operational state 2=standby, 3=discharge, 1=charge";
  //Inlet and Outlet
  SI.SpecificEnthalpy h_top(start = h_f_start[1]) "J/kg";
  SI.SpecificEnthalpy h_bot(start = h_f_start[N_p]) "J/kg";
  SI.MassFlowRate m_flow(start=0.0) "kg/s";
  //Boundary Conditions
  SI.Temperature T_top(start = T_min) "Temperature at the top";
  SI.Temperature T_bot(start = T_min) "Temperature at the bottom";
  SI.Velocity u_flow "m/s";
  //Analyiics
  SI.Energy E_stored(start = 0.0) "Make sure the tank starts from T_min)";
  Real Level(start = 0.0) "Tank charging level (0-1)";
    
  //Initialize wall
  SI.Temperature T_w[N_p](start = T_w_start) "Temperature of wall element";
  //Initialize PCM
  SI.Temperature T_p[N_p](start = T_p_start) "Temperature of PCM element";  
  
  //Thermal Losses
  parameter SI.Temperature T_amb = 298.15;
  parameter SI.Area A_loss_tank = 2 * CN.pi * r_shell * r_shell + 2 * CN.pi * r_shell * L;
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.0 "tank heat loss coeff (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_wall = 0.0 "Wall heat loss coeff (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_top = 0.0 "Wall heat loss coeff (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_bot = 0.0 "Wall heat loss coeff (W/m2K)";
  SI.HeatFlowRate Q_loss_wall[N_p] "Heat loss from the wall";
  SI.HeatFlowRate Q_loss_top "Heat loss from the top";
  SI.HeatFlowRate Q_loss_bot "Heat loss from the bottom";
  SI.HeatFlowRate Q_loss_total "Heat loss from the entire surface area";  
  //Pumping losses
    
  // Costs
    
protected 
  
  // Property of Wall
  SI.SpecificEnthalpy h_w[N_p](start = h_w_start) "J/kg";
  //SI.ThermalConductivity k_w[N_p] "W/mK";
  //SI.SpecificHeatCapacity cp_w[N_p] "J/kgK";
  //SI.Denstity rho_w[N_p] "kg/m3";
  //SI.ThermalConductance U_w_in[N_p] "K/W";
  //SI.ThermalConductance U_w_out[N_p] "K/W";
  parameter SI.Mass m_w[N_p] = WallSection_Mass(r_tube_out, r_tube_in, L, rho_w_avg, N_sec) "Masses of each wall element";

  //Property of PCM
  SI.SpecificEnthalpy h_p[N_p](start = h_p_start) "J/kg";
  //SI.ThermalConductivity k_p[N_p] "W/mK";
  // SI.SpecificHeatCapacity cp_p[N_p] "J/kgK";
  //  SI.Denstity rho_p[N_p] "kg/m3";
  parameter SI.Mass m_p[N_p] = PCMSection_Mass(r_tube_out, r_shell, L, rho_p_avg, N_sec) "Masses of each PCM element";
  
algorithm
//Operational state 1=charging, 2=standby, 3=discharging
//Operational State logic based on an imposed mass flow rate
initial equation
  for i in 1:N_p loop
    fluid[i].h = h_f_start[i];
  end for;
equation
  if m_flow <= (-1.0e-12) then
    State = 1;
  elseif m_flow >= 1.0e-12 then
    State = 3;
  else
    State = 2;
  end if;
//mass is flowing downwards so charging
//mass is flowing upwards so discharging
//Standby
  u_flow = m_flow / (rho_f_avg * A_HTF);
  
//Analyics
  der(E_stored) = m_flow * (h_bot - h_top);
  Level = E_stored / E_max;
//Fluid inlet and outlet properties
  fluid_top.h = h_top;
  fluid_bot.h = h_bot;
  fluid_top.T = T_top;
  fluid_bot.T = T_bot;
//HTF Equation
  if State == 1 then
//Charging: HTF is flowing downwards
//Top charging HTF node (node 1)
    m_f[1] * der(h_f[1]) = abs(m_flow) * (h_top - T_f[1]) + CN.pi * dL * (T_w[1] - T_f[1]) / (log(r_Wall / r_tube_in) / k_w[1] + 1 / (h_v[1] * r_tube_in)) + k_f[1] * A_HTF * (T_f[2] - T_f[1]) / dL;
//End top charging HTF node (node 1)
//Middle charging HTF nodes (nodes 2 - N_p-1)
    for i in 2:N_p-1 loop
      m_f[i] * der(h_f[i]) = abs(m_flow) * (h_f[i - 1] - h_f[i]) + 2 * CN.pi * dL * (T_w[i] - T_f[i]) / (log(r_Wall / r_tube_in) / k_w[i] + 1 / (h_v[i] * r_tube_in)) + k_f[i] * A_HTF * (T_f[i + 1] - T_f[i]) / dL + k_f[i] * A_HTF * (T_f[i - 1] - T_f[i]) / dL;
    end for;
//End middle charging HTF nodes (nodes 2 - N_p-1)
//Bottom charging HTF node (node N_p)
    m_f[N_p] * der(h_f[N_p]) = abs(m_flow) / 2 * (h_f[N_p-1] - h_f[N_p]) + CN.pi * dL * (T_w[N_p] - T_f[N_p]) / (log(r_Wall / r_tube_in) / k_w[N_p] + 1 / (h_v[N_p] * r_tube_in)) + k_f[N_p] * A_HTF * (T_f[N_p-1] - T_f[N_p]) / dL;
    h_bot = h_f[N_p];
//End bottom charging HTF node (node N_p)
  elseif State == 2 then
//Standby
//Top standby HTF node (node 1)
    m_f[1] * der(h_f[1]) = CN.pi * dL * (T_w[1] - T_f[1]) / (log(r_Wall / r_tube_in) / k_w[1] + 1 / (h_v[1] * r_tube_in)) + k_f[1] * A_HTF * (T_f[2] - T_f[1]) / dL;
//End top standby HTF node (node 1)
//Middle standby HTF nodes (nodes 2 - N_p-1)
    for i in 2:N_p-1 loop
      m_f[i] * der(h_f[i]) = 2 * CN.pi * dL * (T_w[i] - T_f[i]) / (log(r_Wall / r_tube_in) / k_w[i] + 1 / (h_v[i] * r_tube_in)) + k_f[i] * A_HTF * (T_f[i + 1] - T_f[i]) / dL + k_f[i] * A_HTF * (T_f[i - 1] - T_f[i]) / dL;
    end for;
//End middle standby HTF nodes (nodes 2 - N_p-1)
//Bottom standby HTF node (node N_p)
    m_f[N_p] * der(h_f[N_p]) = CN.pi * dL * (T_w[N_p] - T_f[N_p]) / (log(r_Wall / r_tube_in) / k_w[N_p] + 1 / (h_v[N_p] * r_tube_in)) + k_f[N_p] * A_HTF * (T_f[N_p-1] - T_f[N_p]) / dL;
    h_bot = h_f[N_p];
//End bottom standby HTF node (node N_p)
  else
//Discharging: HTF is flowing upwards
//Top discharging HTF node (node 1)
    m_f[1] * der(h_f[1]) = abs(m_flow) * (h_f[1] - h_f[2]) + CN.pi * dL * (T_w[1] - T_f[1]) / (log(r_Wall / r_tube_in) / k_w[1] + 1 / (h_v[1] * r_tube_in)) + k_f[1] * A_HTF * (T_f[2] - T_f[1]) / dL;
    h_top = h_f[1];
//End top discharging HTF node (node 1)
//Middle discharging HTF nodes (nodes 2 - N_p-1)
    for i in 2:N_p-1 loop
      m_f[i] * der(h_f[i]) = abs(m_flow) * (h_f[i] - h_f[i + 1]) + 2 * CN.pi * dL * (T_w[i] - T_f[i]) / (log(r_Wall / r_tube_in) / k_w[i] + 1 / (h_v[i] * r_tube_in)) + k_f[i] * A_HTF * (T_f[i + 1] - T_f[i]) / dL + k_f[i] * A_HTF * (T_f[i - 1] - T_f[i]) / dL;
    end for;
//End middle discharging HTF nodes (nodes 2 - N_p-1)
//Bottom discharging HTF node (node N_p)
    m_f[N_p] * der(h_f[N_p]) = abs(m_flow) / 2 * (h_f[N_p] - h_bot) + CN.pi * dL * (T_w[N_p] - T_f[N_p]) / (log(r_Wall / r_tube_in) / k_w[N_p] + 1 / (h_v[N_p] * r_tube_in)) + k_f[N_p] * A_HTF * (T_f[N_p-1] - T_f[N_p]) / dL;
//End bottom discharging HTF node (node N_p)
  end if;
  
  //Fluid Property evaluation
  for i in 1:N_p loop
    h_f[i] = fluid[i].h;
    T_f[i] = fluid[i].T;
    cp_f[i] = fluid[i].cp;
    k_f[i] = fluid[i].k;    
    mu_f[i] = fluid[i].mu;
  end for;
  //Wall Property evaluation
  for i in 1:N_p loop
    h_w[i] = wall[i].h;
    //k_w[i] = wall[i].k;
    T_w[i] = wall[i].T;
    //cp_w[i] = wall[i].cp;
  end for;
  //PCM Property evaluation
  for i in 1:N_p loop
    h_p[i] = pcm[i].h;
    //k_p[i] = pcm[i].k;
    T_p[i] = pcm[i].T;
    //cp_p[i] = PCM[i].cp;
  end for;
  //Convective heat transfer coefficient calculation
  for i in 1:N_p loop
    if abs(u_flow) > 1e-12 then
      Re[i] = rho_f_avg * 2 * r_tube_in * abs(u_flow) / mu_f[i];
      Pr[i] = cp_f[i] * mu_f[i] / k_f[i];
      Xplus[i] = z_f[i] / r_tube_in / Re[i] / Pr[i];
      if Re[i] < 2300 then
        if Xplus[i] < 0.02 then
          Nu[i] = 1.356 * Xplus[i] ^ (-0.3333) - 0.7;
        else
          Nu[i] = 3.657 + 9.641 * (1000 * Xplus[i]) ^ (-0.488) * exp(-28.6 * Xplus[i]);
        end if;
      elseif Re[i] < 10000 then
        Nu[i] = 4.36 + 0.0053 * Re[i] * Pr[i];
      else
        Nu[i] = 4.8 + 0.0167 * Re[i] ^ 0.85 * Pr[i] ^ 0.93;
      end if;
    else
      Re[i] = 0;
      Pr[i] = 0;
      Nu[i] = 2.0;
    end if;
    h_v[i] = Nu[i] * k_f[i] / r_tube_in / 2;
  end for;
  
//Wall Equation
  m_w[1] * der(h_w[1]) = CN.pi * dL * (T_p[1] - T_w[1]) / (log(r_tube_out / r_Wall) / k_w[1] + log(r_PCM / r_tube_out) / k_p[1]) + CN.pi * dL * (T_f[1] - T_w[1]) / (log(r_Wall / r_tube_in) / k_w[1] + 1 / (h_v[1] * r_tube_in)) + k_w[1] * A_Wall * (T_w[2] - T_w[1]) / dL;
  for i in 2:N_p-1 loop
    m_w[i] * der(h_w[i]) = 2 * CN.pi * dL * (T_p[i] - T_w[i]) / (log(r_tube_out / r_Wall) / k_w[i] + log(r_PCM / r_tube_out) / k_p[i]) + 2 * CN.pi * dL * (T_f[i] - T_w[i]) / (log(r_Wall / r_tube_in) / k_w[i] + 1 / (h_v[i] * r_tube_in)) + k_w[i] * A_Wall * (T_w[i + 1] + T_w[i - 1] - 2 * T_w[i]) / dL;
  end for;
  m_w[N_p] * der(h_w[N_p]) = CN.pi * dL * (T_p[N_p] - T_w[N_p]) / (log(r_tube_out / r_Wall) / k_w[N_p] + log(r_PCM / r_tube_out) / k_p[N_p]) + CN.pi * dL * (T_f[N_p] - T_w[N_p]) / (log(r_Wall / r_tube_in) / k_w[N_p] + 1 / (h_v[N_p] * r_tube_in)) + k_w[N_p] * A_Wall * (T_w[N_p-1] - T_w[N_p]) / dL;
  
//PCM Equation
  m_p[1] * der(h_p[1]) = CN.pi * dL * (T_w[1] - T_p[1]) / (log(r_tube_out / r_Wall) / k_w[1] + log(r_PCM / r_tube_out) / k_p[1]) + 2 * A_PCM * (T_p[2] - T_p[1]) / dL / (1 / k_p[1] + 1 / k_p[2]);
  for i in 2:N_p-1 loop
    m_p[i] * der(h_p[i]) = 2 * CN.pi * dL * (T_w[i] - T_p[i]) / (log(r_tube_out / r_Wall) / k_w[i] + log(r_PCM / r_tube_out) / k_p[i]) + 2 * A_PCM * (T_p[i + 1] - T_p[i]) / dL / (1 / k_p[i] + 1 / k_p[i + 1]) + 2 * A_PCM * (T_p[i - 1] - T_p[i]) / dL / (1 / k_p[i] + 1 / k_p[i - 1]);
  end for;
  m_p[N_p] * der(h_p[N_p]) = CN.pi * dL * (T_w[N_p] - T_p[N_p]) / (log(r_tube_out / r_Wall) / k_w[N_p] + log(r_PCM / r_tube_out) / k_p[N_p]) + 2 * A_PCM * (T_p[N_p-1] - T_p[N_p]) / dL / (1 / k_p[N_p-1] + 1 / k_p[N_p]);
  
//Heat loss calculations, different form than the equations above as they were in terms of rho*dh/dt not m*dh/dt
  Q_loss_top = U_top * CN.pi * r_shell * r_shell * (T_p[1] - T_amb);
  Q_loss_bot = U_bot * CN.pi * r_shell * r_shell * (T_p[N_p] - T_amb);
  for i in 1:N_p loop
    Q_loss_wall[i] = U_wall * 2 * CN.pi * r_shell * (T_p[i] - T_amb) * dL;
  end for;
  Q_loss_total = Q_loss_top + sum(Q_loss_wall) + Q_loss_bot;
//End heat loss calculations
  
//Pumping losses
    
  annotation (Documentation(revisions ="<html>
  		<p>By Ming Liu on 20/08/2020</p>
  		</html>"));    
end Test;
