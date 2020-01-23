within SolarTherm.Models.Storage.PCM.DirectContact;

model SB_PCMStorage
  extends Interfaces.Models.StorageFluid4P;
  import Tables = Modelica.Blocks.Tables;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  //Package definition
  redeclare replaceable package Medium = SolarTherm.Media.Sodium.Sodium_dTX;
  replaceable package PCM_Package = SolarTherm.Media.Materials.NaCl;
  replaceable package HTF_Package = SolarTherm.Media.Materials.Sodium2P;
  replaceable package Tank_Package = SolarTherm.Media.Materials.Inconel625;
  replaceable package Tray_Package = SolarTherm.Media.Materials.SS316L;
  //-----------------------------------------------------------------------------------
  parameter String convection_file = "Convection.txt" "path of the convection properties data";
  //Free Parameters
  //Tank
  parameter SI.Length z_tank = 2.0 "Height of the tank (m)";
  parameter SI.Diameter d_tank = 2.0 "Diameter of the tank (m)";
  parameter SI.Length t_tank = 0.5e-2 "Tank wall thickness (m)";
  //Tray
  parameter SI.Length z_tray = 10e-2 "Height of the tray (m)";
  parameter SI.Diameter d_tray = 1.0 "Diameter of the tray (m)";
  parameter SI.Length t_tray = 0.5e-2 "Tray wall thickness (m)";
  parameter Integer N_tray = 100 "Number of trays";
  //PCM
  parameter SI.Length z_PCM = 7e-2 "Depth of PCM at 298.15K (m)";
  //HTF
  parameter SI.Mass m_HTF_start = 1000.0 "Mass of sodium in tank (kg)";
  //Numerical discretization
  parameter Integer n = 20 "Number of PCM control volumes";
  parameter Real growth_ratio = 1.1 "Mesh growth ratio";
  //Controls
  parameter SI.Temperature T_start = 1028.0 "Initial temperature of everything in the storage";
  parameter SI.Temperature T_min = 1028.0 "Minimum temperature of storage HTF";
  parameter SI.Temperature T_max = 1118.0 "Maximum temperature of storage HTF";
  //Insulation
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.5 "Overall heat transfer coefficient for tank thermal losses based on T_HTF - T_amb, W/m2K";
  //Misc
  parameter SI.HeatFlowRate Q_flow_ref_blk = 111e6 / 0.374 "Discharge Heat flow rate at design point";
  //-----------------------------------------------------------------------------------
  //Derived Parameters
  //Tank
  parameter SI.Volume V_tank = 0.25 * CN.pi * d_tank * d_tank * z_tank "Volume enclosed by the tank (m3)";
  parameter SI.Area A_surf_tank = CN.pi * (0.5 * d_tank * d_tank + d_tank * z_tank) "Surface area of tank used for heat loss and tank material costing (m2)";
  parameter SI.Density rho_tank = Tank_Package.rho_Tf(298.15, 0.0) "Density of tank material at 298.15 K (kg/m3)";
  parameter SI.Mass m_tank = A_surf_tank * t_tank * rho_tank "Mass of the tank material (kg)";
  parameter Real C_tank = m_tank * Tank_Package.cost "Total cost of the tank material (USD)";
  //Trays
  parameter SI.Mass m_tray = CN.pi * (0.25 * d_tray * d_tray + d_tray * z_tray) * t_tray * N_tray * Tray_Package.rho_Tf(298.15, 0.0) "Mass of tray material (kg)";
  parameter SI.Volume V_tray = CN.pi * (0.25 * d_tray * d_tray + d_tray * z_tray) * t_tray * N_tray "Volume of tray material (m3)";
  parameter Real C_tray = m_tray * Tray_Package.cost "Total cost of the tray material (USD)";
  //PCM
  parameter SI.Area A_PCM = 0.25 * CN.pi * d_tray * d_tray * N_tray "Cross sectional area of all trays combined (m2)";
  parameter SI.Mass m_PCM = A_PCM * z_PCM * PCM_Package.rho_Tf(298.15, 0.0) "Total mass of PCM (kg)";
  parameter SI.Density rho_PCM_ref = PCM_Package.rho_Tf(298.15, 0.0) "Density of PCM at reference state (298.15K)";
  parameter SI.Density rho_PCM_start = PCM_Package.rho_Tf(T_start, 0.0) "Density of PCM at starting condition";
  parameter SI.SpecificEnthalpy h_PCM_start = PCM_Package.h_Tf(T_start, 0.0) "Starting specific enthalpy of PCM";
  parameter SI.SpecificEnthalpy h_PCM_latent = PCM_Package.h_Tf(PCM_Package.T_melt, 1.0) - PCM_Package.h_Tf(PCM_Package.T_melt, 0.0) "Enthalpy of fusion";
  parameter SI.SpecificEnthalpy h_PCM_theoretical = PCM_Package.h_Tf(T_max, 1.0) - PCM_Package.h_Tf(T_min, 0.0) "Theoretical specific enthalpy difference between max and min temperatures";
  parameter Real C_PCM = m_PCM * PCM_Package.cost "Total cost of the PCM material (USD)";
  //HTF
  parameter Real C_HTF = m_HTF_start * HTF_Package.cost "Total cost of the HTF material (USD)";
  //Insulation
  parameter Real C_insulation = A_surf_tank * (39.89 / U_loss_tank - 0.0539);
  //Discretization
  parameter SI.Mass m_node[n] = CV_Mass(rho_PCM_ref * A_PCM * z_PCM, CV_Thickness(growth_ratio, z_PCM, n)) "Mass of Nodes does not change";
  //Misc Costs
  parameter Real C_misc = (m_tank + m_tray + m_HTF_start + m_PCM) * 0.1722 + 0.018615 * Q_flow_ref_blk + m_PCM * (h_PCM_theoretical / 3600.0e3) * 0.6471;
  //Overall Cost
  parameter Real C_Storage = C_tank + C_tray + C_PCM + C_HTF + C_insulation + C_misc "Total storage cost";
  //-----------------------------------------------------------------------------------
  //Variables
  //-----------------------------------------------------------------------
  //-----------------------------------------------------------------------
  //Variables
  //Storage Tank and Overall
  SI.Energy E_stored "Total energy stored in the system, J";
  SI.HeatFlowRate Q_flow_chg "Heat rate into storage system, J/s";
  SI.HeatFlowRate Q_flow_dis "Heat rate discharged from storage system, J/s";
  SI.HeatFlowRate Q_loss "Heat lost to surroundings, J/s";
  //SolarTherm convention provides heat loss as a negative term
  SI.Energy H_tank "Enthalpy change of the Tank material, J";
  SI.Energy H_tray "Enthalpy change of the Tray material, J";
  SI.Energy H_HTF "Energy stored by the HTF, J";
  SI.Energy E_tank(start = 0.0);
  SI.Energy E_tray(start = 0.0);
  //SI.Energy H_HTF_tray_tank "Enthalpy change of the HTF, Tray and Tank material, J";
  //SI.Energy E_HTF_tray_tank (start = 0) "Total energy stored in the HTF, Tray and Tank, J";
  SI.Energy E_HTF(start = 0.0) "Energy stored by the HTF, J";
  SI.Energy E_PCM(start = 0.0) "Energy stored by the PCM, J";
  SI.Energy E_sensible "Sensible portion of heat storage by PCM, J";
  SI.Energy E_latent "Latent heat portion of PCM, J";
  //HTF Properties
  parameter SI.Mass m_HTF = m_HTF_start;
  //SI.Enthalpy H_HTF "Combined enthalpy of both liquid and gas HTF, J";
  SI.SpecificVolume v_HTF "Combined specific volume of both liquid and gas HTF, m3/kg";
  //Specific volume of sodium liquid&vapor mixture constrained by the available space and mass
  Real x_HTF "Vapor quality of sodium HTF";
  //Optimisation throws out results where x_HTF < 0 (compressed liquid) and x_HTF > 1 (superheated vapor)
  SI.ThermodynamicTemperature T_HTF(start = T_start) "Temperature of HTF, K";
  Modelica.Blocks.Interfaces.RealOutput T_storage annotation(
    Placement(visible = true, transformation(origin = {108, 90}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {108, 90}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  SI.AbsolutePressure p_HTF "Absolute pressure of HTF, Pa";
  SI.SpecificVolume v_liq "Specific volume of sat. sodium liquid at current temperature, m3/kg";
  //SI.SpecificVolume v_gas "Specific volume of sat. sodium gas at current temperature, m3/kg";
  //SI.SpecificEnthalpy h_liq "Specific enthalpy of sat. sodium liquid at current temperature, J/kg";
  //SI.SpecificEnthalpy h_gas "Specific enthalpy of sat. sodium gas at current temperature, J/kg";
  //HTF-PCM Interface
  SI.HeatFlowRate Q_HTFPCM(start = 0.0) "Total heat rate from HTF to the PCM, J/s";
  SI.HeatFlowRate Q_HTFPCM_top(start = 0.0) "Heat rate from HTF to PCM from the top surface (condensation/boiling), J/s";
  SI.HeatFlowRate Q_HTFPCM_bot(start = 0.0) "Heat rate from HTF to PCM from the bottom surface (natural convection), J/s";
  //Convection
  SI.ThermalConductivity k_gas "Thermal conductivity of saturated sodium vapor";
  Real C_convection "Part of the Rayleigh number calculation";
  SI.CoefficientOfHeatTransfer h_convection "Average coefficient of condensation heat transfer at the bottom of trays";
  //Trapped HTF liquid calculation and PCM level
  SI.Length dz_liq "Maximum possible thickness of liquid HTF layer on top of PCM, m";
  SI.MassDefect m_trap "Maximum Possible Mass of liquid sodium trapped in the containers, kg";
  SI.Mass m_avail "Mass of liquid Na available for heat transfer at the receiver and power block in worst case scenario, kg";
  //PCM Discretization
  SI.ThermodynamicTemperature T[n] "Temperature array within PCM, K";
  SI.SpecificEnthalpy h[n](start = fill(h_PCM_start, n)) "Specific energy array within PCM, J/kg";
  SI.Length dz[n] "Thickness array of PCM elements, m";
  Real f[n] "Liquid fraction array of PCM elements";
  SI.Length z[n](start = CV_Location(CV_Thickness(growth_ratio, z_PCM, n))) "Location of node centes of PCM elements, m";
  SI.Length L_total "Total variable length, m";
  SI.Length L_combined "Total length of Sodium layer and salt, m";
  //Efficiency Calculations
  SI.Heat E_in(start = 0) "Total heat energy entering the System, J";
  SI.Heat E_out(start = 0) "Total heat energy leaving the System, J";
  SI.Heat X_in(start = 0) "Total exergy entering the system, J";
  SI.Heat X_out(start = 0) "Total exergy leaving the system, J";
  Real energy_efficiency;
  Real exergy_efficiency;
  //material State Models
  PCM_Package.State PCM_State[n];
  Medium.BaseProperties HTF_State;
  //Interfaces
  Medium.BaseProperties HTF_bp;
  Medium.BaseProperties HTF_br;
  //PCM_Package.State PCM_State_avg;
  //Tank_Package.State Tank_State;
  //Tray_Package.State Tray_State;
  Tables.CombiTable1Ds ConvTab(tableOnFile = true, tableName = "table_1D_1", columns = 2:3, fileName = convection_file);
  //Effectiveness
  /*Real effectiveness_chg;
      Real effectiveness_dischg;
      Real meltfraction;
      SI.Temperature T_PCM_avg;
      SI.ThermalConductivity k_PCM_avg;
      SI.Density rho_PCM_avg;
      SI.Length z_PCM_avg;*/
protected
  //PCM properties
  SI.Density rho[n];
  //(start = fill(Rho_NaCl(T_start,0.0),n)) "Node Density";
  SI.ThermalConductivity k[n];
  //(start = fill(K_NaCl(T_start,0.0),n)) "Node thermal Conductivity";
  SI.SpecificEnthalpy h_HTF;
  SI.Density d_HTF;
  //Tank and Tray properties
  //SI.SpecificEnthalpy h_tray (start = Tray_Package.h_Tf(T_start,0.0));
  //SI.SpecificEnthalpy h_tank (start = Tank_Package.h_Tf(T_start,0.0));
  parameter SI.SpecificHeatCapacity cp_tank = (Tank_Package.h_Tf(T_max, 0.0) - Tank_Package.h_Tf(T_min, 0.0)) / (T_max - T_min);
  parameter SI.HeatCapacity HCap_tank = m_tank * cp_tank;
  parameter SI.SpecificHeatCapacity cp_tray = (Tray_Package.h_Tf(T_max, 0.0) - Tray_Package.h_Tf(T_min, 0.0)) / (T_max - T_min);
  parameter SI.HeatCapacity HCap_tray = m_tray * cp_tray;
  //Heat lost to surroundings
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {0, 144}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {0, 78}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  //SI.ThermodynamicTemperature T_amb;
  //For pump calculations
  //SI.SpecificEnthalpy h_fg;
initial equation
  for i in 1:n loop
    h[i] = h_PCM_start;
//set all nodes to a constant starting specific enthalpy
  end for;
  T_HTF = T_start;
algorithm
  fluid_bp.m_flow := -1.0*fluid_ap.m_flow;
  fluid_br.m_flow := -1.0*fluid_ar.m_flow;
equation
  T_storage = T_HTF;
//HTF Properties
  HTF_State.d = d_HTF;
  HTF_State.h = h_HTF;
  T_HTF = HTF_State.T;
  x_HTF = HTF_State.x;
  p_HTF = HTF_State.p;
  v_liq = 1.0 / HTF_Package.rho_T(T_HTF);
//h_fg = HTF_Package.h_fg_T(T_HTF);
  d_HTF = m_HTF / (V_tank - V_tray - sum(dz) * A_PCM);
  v_HTF = 1.0 / d_HTF;
//Figure out the volume avaibale for the sodium mixture based on vessel volume and
//Tank and tray properties
//PCM Section
//Calculate properties of the NaCl
  for i in 1:n loop
    PCM_State[i].h = h[i];
    PCM_State[i].T = T[i];
    PCM_State[i].f = f[i];
    PCM_State[i].rho = rho[i];
    PCM_State[i].k = k[i];
    dz[i] * rho[i] * A_PCM = m_node[i];
  end for;
  z[1] = 0.5 * dz[1];
  for i in 2:n loop
    z[i] = sum(dz[1:i - 1]) + 0.5 * dz[i];
  end for;
//Heat transfer equations within the PCM
//Mid-node Equation
  for i in 2:n - 1 loop
    m_node[i] * der(h[i]) = A_PCM * (2.0 * (k[i + 1] * k[i] / (dz[i] * k[i + 1] + dz[i + 1] * k[i])) * (T[i + 1] - T[i]) - 2.0 * (k[i] * k[i - 1] / (dz[i] * k[i - 1] + dz[i - 1] * k[i])) * (T[i] - T[i - 1]));
  end for;
//Boundary Condition Equations
  m_node[n] * der(h[n]) = Q_HTFPCM_top - A_PCM * (2.0 * (k[n] * k[n - 1] / (dz[n - 1] * k[n] + dz[n] * k[n - 1])) * (T[n] - T[n - 1]));
//if this slice is hotter than bottom, heat flows out
  m_node[1] * der(h[1]) = Q_HTFPCM_bot + 2.0 * A_PCM * (k[2] * k[1] / (dz[1] * k[2] + dz[2] * k[1])) * (T[2] - T[1]);
//Interface Equations
  Q_HTFPCM_bot = Q_bot(T_HTF, T[1], A_PCM, dz[1], k[1], k_gas, C_convection, d_tray);
  Q_HTFPCM_top = Q_top(T_HTF, T[n], A_PCM, dz[n], k[n]);
  Q_HTFPCM = Q_HTFPCM_bot + Q_HTFPCM_top;
  der(E_PCM) = Q_HTFPCM;
//Convection Heat Transfer Equation
  ConvTab.u = T_HTF;
  ConvTab.y[1] = k_gas;
  ConvTab.y[2] = C_convection;
  h_convection = 2.08 * (k_gas / d_tray) * (C_convection * abs(T[1] - T_HTF) * d_tray ^ 3.0) ^ 0.2;
//Tracking energy
  E_latent = sum(f .* m_node) * h_PCM_latent;
//latent heat of fusion is 482390.5 J/kg
  E_sensible = E_PCM - E_latent;
//Mass of liquid sodium trapped
  L_total = sum(dz);
  dz_liq = z_tray - L_total;
//Empty Length available above the PCM surface
  m_trap = dz_liq * A_PCM / v_liq;
//Worst case mass of sodium liquid in trays
  m_avail = m_HTF * (1.0 - x_HTF) - m_trap;
  L_combined = sum(dz) + dz_liq;
//Analytical variables
  if time >= 10 * 3600 * 24 then
//start calculating efficiencies after day 10
    energy_efficiency = E_out / E_in;
    exergy_efficiency = X_out / X_in;
  else
    energy_efficiency = 0.0;
    exergy_efficiency = 0.0;
  end if;
//Energy Flow
//Heat Transfered to the Tank and energy tracking
//H_tank = HCap_tank*(T_HTF-T_start);
//H_tray = HCap_tray*(T_HTF-T_start);
//H_HTF_tray_tank = H_HTF + H_tank + H_tray;
  Q_loss = -1.0 * U_loss_tank * A_surf_tank * (T_HTF - T_amb);
//der(H_HTF_tray_tank) = Q_flow_chg - Q_flow_dis - Q_HTFPCM + Q_loss;
//der(E_stored) = Q_flow_chg - Q_flow_dis + Q_loss; //Rate of change of energy in the storage vessel
//der(E_HTF_tray_tank) = Q_flow_chg - Q_flow_dis - Q_HTFPCM + Q_loss;
//E_HTF = E_HTF_tray_tank - H_tank - H_tray;
//FluidPorts
  HTF_br.T = T_HTF;
//fluid flowing to receiver is at HTF temperatur
  HTF_bp.T = T_HTF;
  HTF_br.x = 0.0;
//zero vapor pumped to receiver
  HTF_bp.x = 1.0;
//complete vapor pumped to powerblock
  fluid_bp.h_outflow = HTF_bp.h;
  fluid_br.h_outflow = HTF_br.h;
  fluid_ar.h_outflow = 0.0;
//inStream(fluid_ar.h_outflow);//0.0;
  fluid_ap.h_outflow = 0.0;
//inStream(fluid_ap.h_outflow);//0.0;
  fluid_bp.p = HTF_State.p;
  fluid_br.p = HTF_State.p;
  fluid_ap.p = HTF_State.p;
  fluid_ar.p = HTF_State.p;
//HTF mass balance
//der(m_HTF) = fluid_bp.m_flow + fluid_ap.m_flow + fluid_br.m_flow + fluid_ar.m_flow;
//der(m_HTF) = 0.0;
  //fluid_bp.m_flow + fluid_ap.m_flow = 0.0;
  //fluid_br.m_flow + fluid_ar.m_flow = 0.0;
//HTF energy balance
  der(H_HTF) + der(H_tank) + der(H_tray) = Q_loss - Q_HTFPCM + fluid_ar.m_flow * inStream(fluid_ar.h_outflow) + fluid_br.m_flow * fluid_br.h_outflow - (fluid_ap.m_flow * inStream(fluid_ap.h_outflow) + fluid_bp.m_flow * fluid_bp.h_outflow);
//Define enthalpy
  H_HTF = m_HTF * h_HTF;
  H_tank = m_tank * cp_tank * (T_HTF - 298.15);
  H_tray = m_tray * cp_tray * (T_HTF - 298.15);
//Define energy tracked
  der(E_HTF) = der(H_HTF);
  der(E_tank) = der(H_tank);
  der(E_tray) = der(H_tray);
  der(E_in) = Q_flow_chg;
  der(E_out) = Q_flow_dis;
  der(X_in) = Q_flow_chg * (1.0 - 298.15 / T_HTF);
  der(X_out) = Q_flow_dis * (1.0 - 298.15 / T_HTF);
  der(E_stored) = Q_loss + fluid_ar.m_flow * inStream(fluid_ar.h_outflow) + fluid_br.m_flow * fluid_br.h_outflow - (fluid_ap.m_flow * inStream(fluid_ap.h_outflow) + fluid_bp.m_flow * fluid_bp.h_outflow);
  Q_flow_chg = fluid_ar.m_flow * inStream(fluid_ar.h_outflow) + fluid_br.m_flow * fluid_br.h_outflow;
  Q_flow_dis = -1.0 * (fluid_ap.m_flow * inStream(fluid_ap.h_outflow) + fluid_bp.m_flow * fluid_bp.h_outflow);
//fluid_bp.m_flow + fluid_ap.m_flow + fluid_br.m_flow + fluid_ar.m_flow = 0.0;
//der(m_HTF_dynamic) = fluid_bp.m_flow + fluid_ap.m_flow + fluid_br.m_flow + fluid_ar.m_flow;
//assert(m_trap >= 1.0e-12, "Invalid Mass", level = AssertionLevel.error);
  annotation(
    Icon(graphics = {Text(origin = {0, -5}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, extent = {{68, -41}, {-68, 41}}, textString = "PCM"), Text(origin = {-131, 69}, extent = {{-27, 11}, {27, -11}}, textString = "from recv"), Text(origin = {-133, -49}, extent = {{-23, 7}, {27, -11}}, textString = "to recv"), Text(origin = {129, 65}, extent = {{-27, 11}, {13, -3}}, textString = "to PB"), Text(origin = {129, -53}, extent = {{-27, 11}, {21, -7}}, textString = "from PB")}));
end SB_PCMStorage;