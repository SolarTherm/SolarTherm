within SolarTherm.Systems.H2DRI_Applications;

model H2DRI_SolarHeated
  //This is the solar-heated option
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import SolarTherm.Types.Solar_angles;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  extends Modelica.Icons.Example;
  //---Timeseries Data---
  parameter String PV_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/PV_Pilbara_1MW.motab");
  parameter String Wind_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/Wind_Pilbara_320MW.motab");
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Pilbara_2019.motab") "Weather file";
  parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/DRI_reformed.motab") "Optical efficiency lookup table file";
  //---Medium Packages---
  replaceable package Medium_H2 = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package Medium_H2O = Modelica.Media.Water.WaterIF97_ph;
  replaceable package Medium_Fe2O3 = SolarTherm.Media.SolidParticles.Fe2O3_ph;
  replaceable package Medium_Ore_Hydroxylated = SolarTherm.Media.SolidParticles.Private.IOE_Hydroxylated_ph;
  replaceable package Medium_Ore_Dehydroxylated = SolarTherm.Media.SolidParticles.Private.IOE_Dehydroxylated_ph;
  //---Utilities Packages---
  replaceable package Utilities_Ore_Hydroxylated = SolarTherm.Media.SolidParticles.Private.IOE_Hydroxylated_utilities;
  replaceable package Utilities_Ore_Dehydroxylated = SolarTherm.Media.SolidParticles.Private.IOE_Dehydroxylated_utilities;
  replaceable package Utilities_Air = SolarTherm.Media.Air.Air_CoolProp_1bar_utilities;
  
  //Outputs
  Real lcop = LCOD_2021_AUD + penalty "Levelised cost of product (AUD_2021/tDRI)";
  Real capf = CapF_Process "Capacity factor (decimal)";
  Real srev = pri_DRI*m_DRI_produced "Revenue of plant (AUD_2021)";
  Real prod = m_DRI_produced/1000.0 "Production (tDRI)";
  
  Real penalty;

  //Price of DRI
  Real pri_DRI = 300.00*1e3 "Selling price of DRI (USD/kgDRI)";
  
  //---Free Parameters---
  //Optimisation Parameters
  parameter Real SM = 1.27 "Ratio of receiver output to process heat requirement";
  parameter SI.Time t_storage = 128440 "Seconds of storage (h)";

  parameter SI.CoefficientOfHeatTransfer U_loss_silo_cold = 1.77 "Overall heat loss coefficient of the cold silo (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_loss_silo_hot = 1.51 "Overall heat loss coefficient of the hot silo (W/m2K)";
  
  parameter Real eff_GGHX_des = 0.65 "Effectiveness of the GGHX (-)";
  parameter Real eff_PGHX1_des = 0.67 "Effectiveness of PGHX1 (-)";
  parameter Real eff_PGHX2_des = 0.64 "Effectiveness of PGHX2 (-)";
  
  //Silo Heat Loss parameters
  
  //Weather Data
  parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";
  parameter nSI.Angle_deg lon = 119.443359 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -24.166802 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 7.0 "Local time zone (UCT=0)";
  parameter Integer year = 2019 "Meteorological year";
  //Field and Receiver Parameters
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
  parameter SI.HeatFlux DNI_des = 1000.00;
  //1367.0*(0.7^((1.0/cos(latitude_rad))^0.678)) "DNI at the spring equinox (W/m2)";
  parameter Real he_av_des = 0.99 "Design heliostat availability";
  parameter Real eff_opt_des = 0.6261 "Design optical efficiency";
  parameter Integer N_helio = 1 "Number of heliostats";
  parameter SI.Area A_helio = A_field/N_helio "Reflective area per heliostat (m2)";
  parameter SI.Area A_field = Q_flow_helio_out_des / (eff_opt_des * he_av_des * DNI_des) "Required reflective area of the heliostat field (m2)";
  parameter SI.HeatFlowRate Q_flow_helio_out_des = Q_flow_recv_out_des/eff_recv_des; //DNI_des * A_field * eff_opt_des * he_av_des "Design output heatrate of the heliostat field into the receiver aperture (J/s)";
  parameter SI.Energy helio_E_start = 0.0 "Start-up energy of a single heliostat";
  parameter SI.Power helio_W_track = 0.0 "Tracking power for a single heliostat";
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
  parameter SI.MassFlowRate m_flow_recv_des = m_flow_OreD_TES_des*( Q_flow_recv_out_des/Q_flow_heater_curtail) "Receiver mass flow rate at design point (kg/s)";
  //parameter SI.Area A_recv = 164.76 "Receiver aperture area (m2)";
  //parameter SI.HeatFlowRate Q_flow_recv_in_des = Q_flow_helio_out_des * eff_abs_des;
  parameter SI.HeatFlowRate Q_flow_recv_out_des = SM*Q_flow_heater_curtail;
  
  
  //parameter Real eff_abs_des = 1.0 - recv_r(m_flow_recv_des) "Effective receiver absorptivity at design point (-)";
  parameter Real eff_recv_des = SolarTherm.Systems.H2DRI_Applications.recv_eff(1.0) "Design receiver efficiency of particle receiver (-)";
  //parameter Real eff_thermal_des =
  parameter SI.Length H_tower = 164.8 "Receiver Tower Height (m)";
  //parameter SI.Area A_collector = Q_flow_collector_des/DNI_des "Total heliostat mirror area (m2)";
  //Heater Sizing
  //Parameter Inputs
  //parameter Real RM = 1.2 "Renewable Multiple (pre-transmission oversizing)";
  //parameter Real HM = 1.4 "Heater Multiple";
  //---Plant Constants---
  parameter Real Plant_Scale = 1.0 "DRI output in Megatons per year (Mt/yr) which is inclusive of gangue";
  parameter Real eff_heater = 0.95 "Heater electrical to thermal efficiency";
  parameter Real eff_lifting = 0.90 "Lifting electrical to mechanical efficiency";
  parameter SI.Pressure p_des = 100000.0 "Design pressure of the plant (Pa)";
  parameter SI.Temperature T_amb_des = 25.0 + 273.15 "Design ambient temperature (K)";
  parameter SI.Temperature T_H2_feedstock_des = 25.0 + 273.15 "Design feedstock H2 temperature (K)";
  parameter SI.Temperature T_OreH_feedstock_des = 25.0 + 273.15 "Design feedstock hydroxylated ore temperature (K)";
  parameter Real ar_silo = 2.0 "H/D ratio of the TES silo (-)";
  parameter Real eps_packing = 0.20 "Packing void fraction of dehydroxylated iron ore in the TES silo (-)";
  parameter Real eps_material = 0.00 "Material porosity of the dehydroxylated iron ore (-)";
  parameter Real epsilon = eps_packing + eps_material - eps_packing * eps_material "Effective porosity of material in the TES silo (-)";
  parameter SI.SpecificEnthalpy h_ore_cold = Utilities_Ore_Dehydroxylated.h_T(T_cold_des);
  parameter SI.SpecificEnthalpy h_ore_hot = Utilities_Ore_Dehydroxylated.h_T(T_hot_des);
  //---Plant Sizing---
  //parameter SI.HeatFlowRate Q_flow_recv_out_des = SM*Q_flow_heater_curtail "Required heat output rate of the particle receiver (J/s)";
  //parameter SI.HeatFlowRate Q_flow_recv_in_des = Q_flow_recv_out_des/eff_recv_des "Required heat input rate to the particle receiver (J/s)";
  //parameter SI.HeatFlowRate Q_flow_collector_des = Q_flow_recv_in_des/eff_opt_des "Require heat input rate into the collector (J/s)";
  //parameter SI.Power P_renewable_des = RM * P_heater_des "Total of the renewable electrical source (W)";
  //parameter SI.HeatFlowRate Q_flow_heater_des = HM * Q_flow_heater_curtail "Required heat output rate of the electrical heater (J/s)";
  //parameter SI.Power P_heater_des = Q_flow_heater_des / eff_heater "Required max electrical input rate into the electrical heater (J/s)";
  //parameter SI.Power PV_ref_size = 1.0e6 "Reference size of the PV timeseries data (W)";
  //parameter SI.Power Wind_ref_size = 320.0e6 "Reference size of the Wind timeseries data (W)";
  //parameter Real LOF_PV = 1.300 "Loss oversize factor, applied to ensure we actually get the required power from the PV field (-)";
  //parameter Real LOF_Wind = 1.131 "Loss oversize factor, applied to ensure we actually get the required power from the Wind plant (-)";
  //parameter SI.Power P_wind_net = (1.0 - PV_fraction) * P_renewable_des "Design peak power output from the Wind power plant (W)";
  //parameter SI.Power P_PV_net = PV_fraction * P_renewable_des "Design peak power output from the Wind power plant (W)";
  //parameter SI.Power P_wind_gross = P_wind_net * LOF_Wind "Gross peak power output from the Wind power plant before losses, this is what is paid for (W)";
  //parameter SI.Power P_PV_gross = P_PV_net * LOF_PV "Gross peak power output from the PV power plant before losses, this is what is paid for (W)";
  //---Financial Constants---
  parameter Real CEPCI_year = 816.0 "CEPCI index of the year used in the study e.g. 816.0 for year 2022";
  parameter Real AUD_per_USD = 1.330849 "Currency conversion rate based on RP1.004/5 report (AUD/USD)";
  //---Cost constants---
  parameter Real pri_PV = 1.10725 "Cost per W_gross of PV plant, already including 3% contingency (USD_2022/W)";
  parameter Real pri_Wind = 1.50607 "Cost per W_gross of PV plant already including 3% contingency (USD_2022/W)";
  parameter Real pri_Heating = 0.1539 "Cost per W of heater (USD_2022/W)";
  parameter Real pri_H2 = 4.029 "Cost per kg of H2 (USD_2022/kg)";
  // 3.5*(816.0/708.8)
  parameter Real pri_Elec = 93.1 / 3600.0e6 "Cost of 100% reliable electricity (USD_2022/J)";
  //93.1 USD/MWhe
  //Calculated Mass and Molar flow Rates
  parameter SI.MassFlowRate m_flow_DRI_des = Plant_Scale * 1.0e9 / 31536000.0 "Design maximum mass flow rate output of DRI (kg/s)";
  parameter SI.MassFlowRate m_flow_OreD_reactor_des = m_flow_Fe2O3_des / f_mass_Fe2O3_D "Design required dehydroxylated iron ore flow rate into the reactor (kg/s)";
  parameter SI.MassFlowRate m_flow_OreH_PGHX1_des = m_flow_Fe2O3_des / (1.0 - f_mass_Gangue_H - f_mass_LOI_H) "Design flow rate of hydroxylated iron ore (kg/s)";
  parameter SI.MassFlowRate m_flow_Fe2O3_des = 1.4297448 * m_flow_Fe_des "Design required Fe2O3 flow rate (kg/s)";
  parameter SI.MassFlowRate m_flow_Fe_des = 0.8424 * m_flow_DRI_des "Design maximum mass flow rate output of pure Iron (kg/s)";
  parameter SI.MassFlowRate m_flow_OreD_TES_des = m_flow_OreD_reactor_des + m_flow_OreD_PGHX2 "Design mass flow into the cold TES and out of the hot TES when the plant is operating at design capacity (kg/s)";
  parameter SI.MolarFlowRate n_flow_Fe2O3_des = m_flow_Fe2O3_des / M_Fe2O3 "Design required molar Fe2O3 flow rate (mol/s)";
  parameter SI.MolarFlowRate n_flow_H2_stoi = 3.0 * n_flow_Fe2O3_des "Design stoichiometric molar flow rate of H2 consumed assuming 100% yield of iron, also required top-up moles (mol/s)";
  parameter SI.MolarFlowRate n_flow_H2O_stoi = n_flow_H2_stoi "Design molar flow rate of H2O produced in the reactor assuming 100% yield of iron (mol/s)";
  parameter SI.MassFlowRate m_flow_H2O_stoi = n_flow_H2O_stoi * M_H2O "Design mass flow rate of H2O produced in the reactor assuming 100% yield of iron (kg/s)";
  parameter SI.MassFlowRate m_flow_H2_stoi = n_flow_H2_stoi * M_H2 "Design stoichiometric mass flow rate of H2 consumed assuming 100% yield of iron, also required top-up mass flow (kg/s)";
  parameter SI.MolarFlowRate n_flow_H2_des = n_flow_Fe2O3_des * r_min_des "Design molar flow rate of H2 required to ensure 100% yield of iron (mol/s)";
  parameter SI.MassFlowRate m_flow_H2_des = n_flow_H2_des * M_H2 "Design mass flow rate of H2 required to ensure 100% yield of iron (kg/s)";
  parameter SI.MassFlowRate m_flow_H2_excess = m_flow_H2_des - m_flow_H2_stoi "Excess mass flow rate of H2 exiting the reactor (kg/s)";
  parameter SI.MolarFlowRate n_flow_H2_excess = n_flow_H2_des - n_flow_H2_stoi "Design molar flow rate of H2 exiting the reactor (mol/s)";
  //How much water is lost during dehydroxylation
  parameter SI.MassFlowRate m_flow_H2O_dehydroxy_des = m_flow_OreH_PGHX1_des * f_mass_LOI_H "Design mass loss rate of water leaving due to dehydroxylation (kg/s)";
  parameter SI.MolarFlowRate n_flow_H2O_dehydroxy_des = m_flow_H2O_dehydroxy_des / M_H2O "Design molar loss rate of water leaving due to dehydroxylation (mol/s)";
  //Calculated Feedstock Enthalpies
  parameter SI.SpecificEnthalpy h_H2_feedstock_des = Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_des, T_H2_feedstock_des) "Specific Enthalpy of feedstock H2 (J/kg)";
  parameter SI.SpecificEnthalpy h_OreH_feedstock_des = Utilities_Ore_Hydroxylated.h_T(T_OreH_feedstock_des) "Specific enthalpy of hydroxylated iron ore feedstock (J/kg)";
  //Estimated Temperature of the Hot TES Silo
  parameter SI.Temperature T_hot_des = T_hot_guess;
  //Reactor Design Equations
  parameter SI.Temperature T_products_des = 600.0 + 273.15 "Design product temperature (K)";
  parameter SI.Temperature T_reactants_des = 1.07548 * T_products_des + 54.666 "Design estimated reactant temperature (K)";
  parameter SI.Temperature T_inlet_des = T_reactants_des "Assuming no heat loss";
  parameter Real r_min_des = 6.377e1 + (-8.239e-2) * T_reactants_des + 3.131e-5 * T_reactants_des * T_reactants_des;
  //changed
  parameter SI.SpecificEnthalpy h_OreD_hot_des = Utilities_Ore_Dehydroxylated.h_T(T_hot_des);
  //changed to hot dehydroxylated ore
  //Heat loss is assumed to be zero in the RP1.004/5 fluidised bed models
  parameter SI.MolarEnthalpy Q_loss_per_mol_des = 0.0 "Design Heat loss per mole of Fe2O3 (J/mol) Note factor of 2.0 due to stoichiometry";
  //34.57e3
  parameter SI.MolarEnthalpy H_rxn_per_mol_des = 2.0 * SolarTherm.Models.Chemistry.H2DRI.Isothermal.Overall_Rxn_Enthalpy(T_reactants_des, p_des);
  parameter SI.HeatFlowRate Q_loss_des = n_flow_Fe2O3_des * Q_loss_per_mol_des;
  //Needs to be updated to be consistent with RP1.004;
  //---Thermodynamic Calculations---
  //-----Reference enthalpies
  parameter SI.SpecificEnthalpy h_H2_ref = Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(1.0e5, 298.15);
  parameter SI.SpecificEnthalpy h_H2O_ref = Modelica.Media.Water.IF97_Utilities.h_pT(1.0e5, 298.15);
  //H2O at 400C
  parameter SI.SpecificEnthalpy h_H2O_400C = Modelica.Media.Water.IF97_Utilities.h_pT(1.0e5, 273.15 + 400.0);
  //-----Condenser Calculations
  //Reactor Outlet Pressures
  parameter SI.Pressure p_H2_offgas_des = p_des * n_flow_H2_excess / (n_flow_H2_excess + n_flow_H2O_stoi) "Design partial pressure of H2 in the offgas (Pa)";
  parameter SI.Pressure p_H2O_offgas_des = p_des * n_flow_H2O_stoi / (n_flow_H2_excess + n_flow_H2O_stoi) "Design partial pressure of H2O in the offgas (Pa)";
  parameter SI.Temperature T_condenser_out_des = Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p_H2O_offgas_des) - 1.0 "Design outlet temperature of the condenser (K)";
  //One degree below the saturation temperature of water at the partial pressure of H2O in the off-gas.
  parameter SI.SpecificEnthalpy h_H2_condenser_out_des = Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_des, T_condenser_out_des) "Design specific enthalpy of H2 leaving the condenser (J/kg)";
  //-----Hydrogen Mixer Calculations
  parameter SI.SpecificEnthalpy h_H2_mix_des = (m_flow_H2_stoi * h_H2_feedstock_des + m_flow_H2_excess * h_H2_condenser_out_des) / (m_flow_H2_stoi + m_flow_H2_excess) "Design specific enthalpy of H2 entering the GGXH cold stream after being mixed with topup stream (J/kg)";
  parameter SI.Temperature T_H2_mix_des = Modelica.Media.IdealGases.SingleGases.H2.temperature_ph(p_des, h_H2_mix_des) "Design temperature of H2 entering the GGXH cold stream after being mixed with topup stream (J/kg)";
  //---Check Variables---
  SI.Temperature T_reactor_mix_actual "Check the actual mixing temperature of the reactor inlet streams";
  //-----Reactor Calculations
  //Design Reactor Inlet Mixed Enthalpies before losses
  parameter SI.SpecificEnthalpy h_H2_inlet_des = Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_des, T_inlet_des) "Design specific enthalpy of Hydrogen gas entering the reactor (J/kg)";
  parameter SI.SpecificEnthalpy h_OreD_inlet_des = Utilities_Ore_Dehydroxylated.h_T(T_inlet_des) "Design specific enthalpy of dehydroxylated iron ore entering the reactor (J/kg)";
  //Linear Guess of required hot oreD temperature to sustain reaction
  parameter SI.HeatFlowRate H_flow_inlet_des = m_flow_OreD_reactor_des * h_OreD_inlet_des + m_flow_H2_des * h_H2_inlet_des;
  parameter SI.Temperature T_hot_guess = (H_flow_inlet_des + m_flow_H2_des * (h_H2_pre1_des * eff_PGHX2_des - h_H2_pre1_des) + 293299.7 * m_flow_OreD_reactor_des + 762976.9 * m_flow_H2_des * eff_PGHX2_des) / (940.488 * m_flow_OreD_reactor_des + 15214.199 * m_flow_H2_des * eff_PGHX2_des);
  //-----PGHX1 Calculation, Dehydroxylation requirement
  //Enthalpy of dehydroxylated ore at 400C which is the temperature at which full dehydroxylation is obtained.
  parameter SI.SpecificEnthalpy h_OreD_400C = Utilities_Ore_Dehydroxylated.h_T(400.0 + 273.15) "Specific enthalpy of dehydroxylated iron ore at 400degC (J/kg)";
  //Heat Capacity Rates of the H2 and H2O components of off-gas
  parameter SI.SpecificHeatCapacity cp_Hot_H2O_PGHX1 = 0.5 * (Modelica.Media.Water.IF97_Utilities.cp_pT(p_H2O_offgas_des, T_products_des) + Modelica.Media.Water.IF97_Utilities.cp_pT(p_H2O_offgas_des, max(Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p_H2O_offgas_des) + 1.0, T_H2_mix_des))) "cp of the hot H2O gas entering the PGHX1 (J/kgK)";
  //Cannot condense
  parameter SI.SpecificHeatCapacity cp_Hot_H2_PGHX1 = (Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2_offgas_des, T_products_des) - Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2_offgas_des, T_OreH_feedstock_des)) / (T_products_des - T_H2_mix_des) "cp of the hot H2 entering the PGHX1 (J/kgK)";
  parameter SI.ThermalConductance C_H_PGHX1 = (1 - f_split_GGHX) * m_flow_H2_excess * cp_Hot_H2_PGHX1 + (1 - f_split_GGHX) * m_flow_H2O_stoi * cp_Hot_H2O_PGHX1 "Heat capacity rate of the hot off-gas entering PGHX1 (W/K)";
  parameter SI.SpecificHeatCapacity cp_H2H2O_PGHX1 = m_flow_H2_excess / (m_flow_H2_excess + m_flow_H2O_stoi) * cp_Hot_H2_PGHX1 + m_flow_H2O_stoi / (m_flow_H2_excess + m_flow_H2O_stoi) * cp_Hot_H2O_PGHX1 "Effective heat capacity of the H2 H2O off-gas mixture calculated based on off-gas composition (J/kgK)";
  //Heat requirement of the cold ore stream
  parameter SI.HeatFlowRate Q_dehydroxy_chem = n_flow_H2O_dehydroxy_des * (SolarTherm.Models.Chemistry.ChemTable.H2O.Hf0 + SolarTherm.Models.Chemistry.ChemTable.Fe2O3.Hf0 - SolarTherm.Models.Chemistry.ChemTable.Fe2O3H2O.Hf0) "Chemical component of dehydroxylation enthalpy requirement (J/s)";
  parameter SI.HeatFlowRate Q_dehydroxy_therm = m_flow_OreD_reactor_des * h_OreD_400C + m_flow_H2O_dehydroxy_des * (h_H2O_400C - h_H2O_ref) - m_flow_OreH_PGHX1_des * h_OreH_feedstock_des "Thermal component of dehydroxylation enthalpy requirement (J/s)";
  parameter SI.MassFlowRate m_flow_offgas_PGHX1 = Q_flow_PGHX1_req / (eff_PGHX1_des * cp_H2H2O_PGHX1 * (T_products_des - T_amb_des)) "Required total mass flow rate of H2 and H2O in PGHX1 (kg/s)";
  parameter SI.HeatFlowRate Q_flow_PGHX1_req = Q_dehydroxy_chem + Q_dehydroxy_therm "Total dehydroxylation enthalpy requirement (J/s)";
  //The heat capacity rate is effectively equal for both streams, here C_min = C_max = C_H_PGHX1;
  parameter SI.ThermalConductance C_min_PGHX1 = C_H_PGHX1;
  //The heat capacity ratio is 1.0
  parameter Real C_r_PGHX1 = 1.0;
  //Split of the off-gas stream directed to GGHX1. The complementary value is PGHX1
  parameter Real f_split_GGHX = 1.0 - m_flow_offgas_PGHX1 / (m_flow_H2_excess + m_flow_H2O_stoi);
  //-----GGHX Outlet design temperatures: Stage-1 Preheating of H2.
  //Specific Heat Capacity Rates
  parameter SI.SpecificHeatCapacity cp_Hot_H2O_GGHX = 0.5 * (Modelica.Media.Water.IF97_Utilities.cp_pT(p_H2O_offgas_des, T_products_des) + Modelica.Media.Water.IF97_Utilities.cp_pT(p_H2O_offgas_des, Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p_H2O_offgas_des) + 1.0)) "cp of the hot H2O entering the GGHX (J/kgK)";
  //H2O cannot be condensed in the GGHX
  parameter SI.SpecificHeatCapacity cp_Hot_H2_GGHX = (Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2_offgas_des, T_products_des) - Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2_offgas_des, T_H2_mix_des)) / (T_products_des - T_H2_mix_des) "cp of the hot H2 entering the GGHX (J/kgK)";
  parameter SI.SpecificHeatCapacity cp_Cold_H2_GGHX = (Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_des, T_products_des) - Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_des, T_H2_mix_des)) / (T_products_des - T_H2_mix_des) "cp of the cold H2 entering the GGHX (J/kgK)";
  parameter SI.ThermalConductance C_C_GGHX = m_flow_H2_des * cp_Cold_H2_GGHX "Heat capacity rate of the cold H2 stream entering the GGHX (W/K)";
  parameter SI.ThermalConductance C_H_GGHX = f_split_GGHX * m_flow_H2_excess * cp_Cold_H2_GGHX + f_split_GGHX * m_flow_H2O_stoi * cp_Hot_H2O_GGHX "Heat capacity rate of the hot offgas stream entering GGHX (W/K)";
  parameter SI.ThermalConductance C_min_GGHX_des = min(C_C_GGHX, C_H_GGHX) "Minimum heat capacity rate flow in GGHX (W/K)";
  //Actual heat transfer across GGHX
  parameter SI.HeatFlowRate Q_flow_GGHX_des = eff_GGHX_des * C_min_GGHX_des * (T_products_des - T_H2_mix_des) "Design actual heat transfer rate inside GGHX (J/s)";
  //GGHX Outlet design temperature
  parameter SI.SpecificEnthalpy h_H2_pre1_des = h_H2_mix_des + Q_flow_GGHX_des / m_flow_H2_des "Specific enthalpy of H2 after Stage1 preheating via the GGHX (J/kg)";
  parameter SI.Temperature T_H2_pre1_des = Modelica.Media.IdealGases.SingleGases.H2.temperature_ph(p_des, h_H2_pre1_des) "Design temperature of the H2 after Stage1 preheating via the GGHX (K)";
  //-----Condenser Equations, These have to be solved dynamically.
  SI.Temperature T_condenser2_in_des(start = 500.0) "Temperature of cooled offgas exiting GGHX and entering condenser2 (K)";
  SI.Temperature T_condenser1_in_des(start = 500.0) "Temperature of cooled offgas leaving PGHX1 and entering Condenser1 (K)";
  //-----PGHX2 Equations
  //Heat Capacity Rates of the hot dehydroxylated ore and hydrogen entering PGHX2
  parameter SI.SpecificHeatCapacity cp_OreD_PGHX2 = (Utilities_Ore_Dehydroxylated.h_T(T_hot_des) - Utilities_Ore_Dehydroxylated.h_T(T_H2_pre1_des)) / (T_hot_des - T_H2_pre1_des) "Specific heat capacity rate of hot dehydroxylated iron ore in PGHX2 (J/kg)";
  parameter SI.SpecificHeatCapacity cp_H2_PGHX2 = (Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_des, T_hot_des) - Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_des, T_H2_pre1_des)) / (T_hot_des - T_H2_pre1_des) "Specific heat capacity rate of cold H2 gas in PGHX2 (J/kg)";
  //parameter SI.ThermalConductance C_C_PGHX2 = m_flow_H2_des*cp_H2_PGHX2 "Heat Capacity Rate of the cold H2 gas in PGHX2 (W/K)";
  parameter SI.ThermalConductance C_H_PGHX2 = m_flow_OreD_PGHX2 * cp_OreD_PGHX2 "Heat Capacity Rate of the hot dehydroxylated iron ore in PGHX2 (W/K)";
  parameter SI.ThermalConductance C_C_PGHX2 = m_flow_H2_des * cp_H2_PGHX2 "Heat Capacity Rate of the cold H2 stream in PGHX2 (W/K)";
  parameter SI.ThermalConductance C_min_PGHX2 = min(C_C_PGHX2, C_H_PGHX2) "Minimum heat capacity rate stream in PGHX2 (W/K)";
  //The mass flow rate of Ore is adjusted accordingly
  parameter SI.MassFlowRate m_flow_OreD_PGHX2 = m_flow_H2_des * cp_H2_PGHX2 / cp_OreD_PGHX2 "Mass flow rate of hot ore required to match hot and cold heat capacity rates (kg/s)";
  //Design heat flow rate through PGHX2 and outlet temperatures
  parameter SI.HeatFlowRate Q_flow_PGHX2_des = eff_PGHX2_des * C_min_PGHX2 * (T_hot_des - T_H2_pre1_des) "Design heat flow rate through PGHX2 (J/s)";
  parameter SI.SpecificEnthalpy h_H2_pre2_des = h_H2_pre1_des + Q_flow_PGHX2_des / m_flow_H2_des "Design of H2 leaving the PGHX2 cold stream after considering HX effectiveness and assuming C_H2 is C_min (J/kg)";
  parameter SI.SpecificEnthalpy h_OreD_cold_in2_des = h_OreD_hot_des - Q_flow_PGHX2_des / m_flow_OreD_PGHX2 "Specific enthalpy of dehydroxylated iron ore leaving PGHX2 entering the cold TES silo (J/kg)";
  parameter SI.Temperature T_H2_pre2_des = Modelica.Media.IdealGases.SingleGases.H2.temperature_ph(p_des, h_H2_pre2_des) "Design temperature of the H2 leaving PGHX2 after considering PGHX2 effectiveness (K)";
  parameter SI.Temperature T_cold_in2_des = Utilities_Ore_Dehydroxylated.T_h(h_OreD_cold_in2_des) "Temperature of dehydroxylated iron ore leaving PGHX2 and entering the cold TES silo (K)";
  //---Design temperature of the cold silo
  //What is the expected temperature of materials entering the cold silo assuming they get mixed well?
  parameter SI.SpecificEnthalpy h_OreD_cold_des = ((1.0 - f_mass_LOI_H) * m_flow_OreH_PGHX1_des * h_OreD_400C + m_flow_OreD_PGHX2 * h_OreD_cold_in2_des) / ((1.0 - f_mass_LOI_H) * m_flow_OreH_PGHX1_des + m_flow_OreD_PGHX2) "Expected specific enthalpy of the cold TES silo after mixing the ore from PGHX1 and PGHX2 outlets (J/kg)";
  parameter SI.Temperature T_cold_des = Utilities_Ore_Dehydroxylated.T_h(h_OreD_cold_des) "Expected temperature of the cold ore TES silo (K)";
  //-----Costs (In Order of Report)-----
  //----Fixed-Size Equipment
  //---1) H2DRI Reactor
  parameter Real FOB_reactor = 0.0 "FOB cost is set to zero, as only FCI is provided by industry partner (USD_2022)";
  parameter Real FCI_reactor = Plant_Scale * CEPCI_year / 816.0 * 506546275.0 "Fixed Capital Investment cost of the fluidised bed H2DRI reactor provided by industry partner (USD_2022)";
  //---2) GGHX
  parameter SI.CoefficientOfHeatTransfer U_GGHX_des = 30.0 "Overall heat transfer coefficient in the GGHX (W/m2K)";
  parameter Real NTU_GGHX_des = eff_GGHX_des / (1.0 - eff_GGHX_des) "Design NTU of the GGHX (-)";
  parameter SI.ThermalConductance UA_GGHX_des = C_min_GGHX_des * NTU_GGHX_des "Design UA of the GGHX (W/K)";
  parameter SI.Area A_GGHX_des = UA_GGHX_des / U_GGHX_des "Design heat transfer area of the GGHX (m2)";
  parameter Real FOB_GGHX = div(A_GGHX_des, 185.8) * (CEPCI_year / 500.0) * 150945.38 + CEPCI_year / 500.0 * 6200.0 * (10.764 * rem(A_GGHX_des, 185.8)) ^ 0.42 "Free-on-board cost of the GGHX component, based on a Spiral-Plate HX (USD_2022)";
  parameter Real FCI_GGHX = FOB_GGHX * 1.05 * 3.5 * 0.7012 "Fixed capital investment cost of the GGHX (USD_2022)";
  //checked
  //---3) H2 Blower
  //H2 Blower cost, based on cast iron, 3psig (1.22 bar absolute)
  parameter SI.Density rho_H2_mix_des = Modelica.Media.IdealGases.SingleGases.H2.density_pT(p_des, T_H2_mix_des) "Density of H2 after the mixer (kg/m3)";
  parameter SI.VolumeFlowRate V_flow_H2_mix_des = m_flow_H2_des / rho_H2_mix_des "Volumetric flow rate of H2 in the blower fan (m3/s)";
  parameter SI.Power P_C_blower_H2 = 0.9855 * (1.41 / 0.41) * (V_flow_H2_mix_des * 1.0e5 / 0.75) * ((1.1 / 1.0) ^ (0.41 / 1.41) - 1.0) / 0.9 "Sizing power of the H2 blower (W)";
  parameter Real FOB_blower_H2 = CEPCI_year / 500.0 * 1.0 * exp(6.8929 + 0.79 * log(P_C_blower_H2 / 745.7)) "FOB cost of the blower in PGHX1 (USD_2022)";
  parameter Real FCI_blower_H2 = FOB_blower_H2 * 1.05 * 3.5 * 0.7012 "FCI cost of the blower in PGHX1 (USD_2022)";
  //---4 & 5) Condenser 1
  //Condenser Q_flow_cooling = U_condenser_des*A_condenser1*(T_condenser1_in_des-T_amb_des)
  parameter SI.CoefficientOfHeatTransfer U_condenser1_des = 700.0 "W/m2K";
  parameter SI.CoefficientOfHeatTransfer U_condenser2_des = 700.0 "W/m2K";
  SI.Area A_condenser1 = Q_flow_cooling_condenser1 / (U_condenser1_des * 0.8 * (T_condenser_out_des - T_amb_des)) "Required heat transfer area of air-cooled condenser (m2)";
  SI.Area A_condenser2 = Q_flow_cooling_condenser2 / (U_condenser2_des * 0.8 * (T_condenser_out_des - T_amb_des)) "Required heat transfer area of air-cooled condenser (m2)";
  Real FOB_condenser1 = CEPCI_year / 500.0 * 10000.0 * (10.764 * A_condenser1) ^ 0.40;
  Real FOB_condenser2 = CEPCI_year / 500.0 * 10000.0 * (10.764 * A_condenser2) ^ 0.40;
  Real FCI_condenser1 = FOB_condenser1 * 1.05 * 3.5 * 0.7012;
  Real FCI_condenser2 = FOB_condenser2 * 1.05 * 3.5 * 0.7012;
  //---6 & 7 & 8) PGHX1
  //PGHX1 Tubes
  parameter SI.HeatFlowRate Q_flow_PGHX1_des = Q_flow_PGHX1_req "Design heat transfer rate across PGHX1 (J/s)";
  parameter Real NTU_PGHX1_des = eff_PGHX1_des / (1.0 - eff_PGHX1_des) "Design NTU of the PGHX1 (-)";
  parameter SI.ThermalConductance U_PGHX1_des = 36.98 "Overall heat transfer coefficient of PGHX1 (W/K)";
  parameter SI.Area A_PGHX1_des = C_min_PGHX1 * NTU_PGHX1_des / U_PGHX1_des "Required heat transfer area of PGHX1 tubes (m2)";
  parameter Real FOB_PGHX1_tubes = CEPCI_year / 708.8 * (0.5 * 47.36 * U_PGHX1_des * A_PGHX1_des) "Free on board cost of PGHX1 tubing (USD_2022)"; //Factor of 0.5 for SS/Nickel = 2/4.
  parameter Real FCI_PGHX1_tubes = FOB_PGHX1_tubes * 1.05 * 3.5 * 0.7012 "Fixed capital investment cost of PGHX1 tubing (USD_2022)"; //Material adjustement factor is 0.7012 for SS = 2.0 material factor.
  //PGHX1 Recuperator
  parameter SI.HeatFlowRate Q_flow_recup_PGHX1 = 0.8 * m_flow_air_PGHX1 * (SolarTherm.Media.Air.Air_amb_p_utilities.h_T(673.15) - SolarTherm.Media.Air.Air_amb_p_utilities.h_T(T_amb_des)) "Heat recuperation rate from the air stream used to fluidise the bed in PGHX1 assuming an effectiveness of 0.80 (J/s)";
  //Dehydroxylation temperature is taken as 400degC or 673.15K
  parameter SI.ThermalConductance U_recup_PGHX1 = 30.0 "Gas-gas heat transfer coefficient assumed for PGHX1 (W/m2K)";
  parameter SI.Area A_recup_PGHX1 = Q_flow_recup_PGHX1 / (U_recup_PGHX1 * (673.15 - T_amb_des)) "Required gas-gas heat recuperator heat exchanger area of PGHX1 (m2)";
  parameter Real FOB_PGHX1_recup = div(A_recup_PGHX1, 185.8) * (CEPCI_year / 500.0) * 150945.38 + CEPCI_year / 500.0 * 6200.0 * (10.764 * rem(A_recup_PGHX1, 185.8)) ^ 0.42 "Free on board cost of PGHX1 recuperator (USD_2022)";
  parameter Real FCI_PGHX1_recup = FOB_PGHX1_recup * 1.05 * 3.5 * 0.7012 "Fixed capital investment cost of PGHX1 (USD_2022)";
  //PGHX1 Blower
  parameter SI.Area A_cs_PGHX1 = 2.0 * A_PGHX1_des / CN.pi "Min cross sectional area of the PGHX1 fluidised bed (m2)";
  parameter SI.Velocity u_air_mf_PGHX1 = 0.05256 "Minimum superficial fluidisation velocity of PGHX1 fluidised bed (m/s)";
  parameter SI.Velocity u_air_PGHX1 = 3.0 * u_air_mf_PGHX1 "Three times the min superficial fluidisation velocity of PGHX1 (m/s)";
  parameter SI.MassFlowRate m_flow_air_PGHX1 = SolarTherm.Media.Air.Air_amb_p_utilities.rho_T(0.5 * (T_OreH_feedstock_des + T_products_des)) * A_cs_PGHX1 * u_air_PGHX1 "Requried mass flow rate of air needed to fluidise PGHX1 (kg/s)";
  parameter SI.VolumeFlowRate V_flow_air_PGHX1_blower = m_flow_air_PGHX1 / SolarTherm.Media.Air.Air_amb_p_utilities.rho_T(T_amb_des) "Volumetric flow rate of ambient temp air in PGHX1 blower (m3/s)";
  parameter SI.Power P_C_PGHX1 = 0.9855 * (1.4 / 0.4) * (V_flow_air_PGHX1_blower * 1.0e5 / 0.75) * ((1.1 / 1.0) ^ (0.4 / 1.4) - 1.0) / 0.9 "Sizing power of blower of PGHX1 (W)";
  parameter Real FOB_PGHX1_blower = CEPCI_year / 500.0 * 1.0 * exp(6.8929 + 0.79 * log(P_C_PGHX1 / 745.7)) "FOB cost of the blower in PGHX1 (USD_2022)";
  parameter Real FCI_PGHX1_blower = FOB_PGHX1_blower * 1.05 * 3.5 * 0.7012 "FCI cost of the blower in PGHX1 (USD_2022)";
  //Total cost of PGHX1
  parameter Real FCI_PGHX1 = FCI_PGHX1_tubes + FCI_PGHX1_recup + FCI_PGHX1_blower "Total FCI cost of PGHX1 (USD_2022)";
  //---9 & 10 & 11) PGHX2
  //PGHX2 Tubes
  parameter SI.ThermalConductance U_PGHX2_des = 63.39 "Overall heat transfer coefficient of PGHX2 (W/K)";
  parameter Real NTU_PGHX2_des = eff_PGHX2_des / (1.0 - eff_PGHX2_des) "NTU of PGHX2, C_r is one";
  //PGHX1 assume C_r is 1.0
  parameter SI.Area A_PGHX2_des = C_H_PGHX2 * NTU_PGHX2_des / U_PGHX2_des "Required heat transfer area of tubes in PGHX2 (m2)";
  parameter Real FOB_PGHX2_tubes = CEPCI_year / 708.8 * (27.69 * U_PGHX2_des * A_PGHX2_des) "Free on board cost of PGHX2 tubing (USD_2022)";
  parameter Real FCI_PGHX2_tubes = FOB_PGHX2_tubes * 1.05 * 3.5 * 0.5340 "Fixed capital incestment cost of PGHX2 tubing (USD_2022)";
  //PGHX2 Blower
  parameter SI.Area A_cs_PGHX2 = 2.0 * A_PGHX2_des / CN.pi "Min cross sectional area of the PGHX2 fluidised bed (m2)";
  parameter SI.Area u_air_mf_PGHX2 = 0.04316 "Minimum superficial fluidisation velocity of PGHX1 fluidised bed (m/s)";
  parameter SI.Velocity u_air_PGHX2 = 3.0 * u_air_mf_PGHX2 "Three times the min superficial fluidisation velocity of PGHX2 (m/s)";
  parameter SI.MassFlowRate m_flow_air_PGHX2 = SolarTherm.Media.Air.Air_amb_p_utilities.rho_T(0.5 * (T_H2_pre1_des + T_hot_des)) * A_cs_PGHX2 * u_air_PGHX2 "Required mass flow rate of air in PGHX2 to fluidise the bed (kg/s)";
  parameter SI.VolumeFlowRate V_flow_air_PGHX2_blower = m_flow_air_PGHX2 / SolarTherm.Media.Air.Air_amb_p_utilities.rho_T(T_amb_des) "Volumetric flow rate of ambient temp air in PGHX2 blower (m3/s)";
  parameter SI.Power P_C_PGHX2 = 0.9855 * (1.4 / 0.4) * (V_flow_air_PGHX2_blower * 1.0e5 / 0.75) * ((1.1 / 1.0) ^ (0.4 / 1.4) - 1.0) / 0.9 "Sizing power of blower of PGHX2 (W)";
  parameter Real FOB_PGHX2_blower = CEPCI_year / 500.0 * 1.0 * exp(6.8929 + 0.79 * log(P_C_PGHX2 / 745.7)) "FOB cost of the blower in PGHX2 (USD_2022)";
  parameter Real FCI_PGHX2_blower = FOB_PGHX2_blower * 1.05 * 3.5 * 0.7012 "FCI cost of the blower in PGHX2 (USD_2022)";
  //PGHX2's max temp range is T_amb_des to T_OreD_hot_des effectiveness is assumed to be 0.80
  parameter SI.HeatFlowRate Q_flow_recup_PGHX2 = 0.8 * m_flow_air_PGHX2 * (SolarTherm.Media.Air.Air_amb_p_utilities.h_T(T_cold_in2_des) - SolarTherm.Media.Air.Air_amb_p_utilities.h_T(T_amb_des));
  parameter SI.ThermalConductance U_recup_PGHX2 = 30.0 "Gas-gas heat transfer coefficient (W/m2K)";
  parameter SI.Area A_recup_PGHX2 = Q_flow_recup_PGHX2 / (U_recup_PGHX2 * (T_cold_in2_des - T_amb_des)) "Required gas-gas heat recuperator heat exchanger area of PGHX2 (m2)";
  parameter Real FOB_PGHX2_recup = div(A_recup_PGHX2, 185.8) * (CEPCI_year / 500.0) * 150945.38 + CEPCI_year / 500.0 * 6200.0 * (10.764 * rem(A_recup_PGHX2, 185.8)) ^ 0.42;
  parameter Real FCI_PGHX2_recup = FOB_PGHX2_recup * 1.05 * 3.5 * 0.7012;
  //Total cost of PGHX2
  parameter Real FCI_PGHX2 = FCI_PGHX2_tubes + FCI_PGHX2_recup + FCI_PGHX2_blower "Total FCI cost of PGHX2 (USD_2022)";
  //---X) Crushing Capital Cost
  parameter Real FCI_Crushing = 50548009.0 * Plant_Scale / 1.0;
  //----Variable-Sized Equipment
  //---12) PV Plant
  parameter Real FCI_PV = 0.0;// pri_PV * P_PV_gross "Fixed capital investment cost of PV plant, already includes 3% contingency (USD_2022)";
  //---13) Wind Plant
  parameter Real FCI_Wind = 0.0;//pri_Wind * P_wind_gross "Fixed capital investment cost of Wind plant, already includes 3% contingency (USD_2022)";
  parameter Real FCI_CST = (CEPCI_year/816.0)*(1.0/1.330849)*(120.0/165.0)*Q_flow_recv_out_des*(1.0 + 0.25);
  //120 MAUD_2022 per 165 MW recv output, Add 25% EPC (% of direct cost) where contingency is already rolled in.
  parameter Real FCI_Lift = 0.0;
  //Lift is assumed to be part of CST
  //(CEPCI_year/607.5)*58.37*H_tower*m_flow_recv_des*(1.0 + 0.25);
  //58.37 USD_2019 per meter tower and per kg/s flow rate, add 25% EPC.
  //---14 & 15 & 16) FB Electrical Heater
  //Just the heating part first
  parameter SI.HeatFlowRate Q_flow_heater_curtail = m_flow_OreD_TES_des * (h_OreD_hot_des - h_OreD_cold_des) "Heating rate required during steady operation where the hot TES silo is full (J/s)";
  parameter SI.HeatFlowRate Q_flow_heater_max = SM * Q_flow_heater_curtail "Maximum heat output rate of the heater (J/s)";
  parameter SI.Power P_heater_curtail = Q_flow_heater_curtail / eff_heater "Heater power input when curtailed (W)";
  //parameter SI.Power P_heater_max = Q_flow_heater_max / eff_heater "Maximum heater power input (W)";
  //Cost and Sizing Parameters
  parameter Real FCI_heating_heater = 0.0;//pri_Heating * P_heater_des "FCI cost of the electrical heater portion of the heater subsystem (USD_2022)";
  //Recuperator HX for the heating subsystem
  parameter SI.HeatFlowRate Q_flow_heating_recup = 0.8 * m_flow_air_heating * (Utilities_Air.h_T(T_hot_des) - Utilities_Air.h_T(T_amb_des)) "Heat recovery rate of the recuperator portion of the heater subsystem assuming an effectiveness of 0.80 (J/s)";
  parameter SI.ThermalConductance U_recup_heating = 30.0 "Gas-gas heat transfer coefficient of the heating subsystem recuperator (W/m2K)";
  parameter SI.Area A_heating_recup = Q_flow_heating_recup / (0.80 * U_recup_heating * (T_hot_des - T_amb_des)) "Required gas-gas heat recuperator heat exchanger area of the heating subsystem (m2)";
  parameter Real FOB_heating_recup = div(A_heating_recup, 185.8) * (CEPCI_year / 500.0) * 150945.38 + CEPCI_year / 500.0 * 6200.0 * (10.764 * rem(A_heating_recup, 185.8)) ^ 0.42 "Free on board cost of the recuperator component of the heating subsystem (USD_2022)";
  parameter Real FCI_heating_recup = 0.0;//FOB_heating_recup * 1.05 * 3.5 * 0.7012 "FCI of the recuperator in the FB heater component (USD_2022)";
  //Blower component of the heating subsystem
  parameter SI.HeatFlux q_flow_heater_max = 60000.0 "Maximum radiant heat flux of the fluidised bed heater (W/m2)";
  //This basically sets a minimum cross sectional area of the fluidised bed of the heater subsystem
  parameter SI.Area A_cs_heating = Q_flow_recv_out_des / q_flow_heater_max "Minimum cross sectional area of the fluidised bed (m2)";
  parameter SI.Diameter d_p = 2.5e-4 "Assumed ore particle diameter (m)";
  //250 micrometres
  parameter SI.Density rho_p_heating = 0.5 * (Utilities_Ore_Dehydroxylated.rho_T(T_hot_des) + Utilities_Ore_Dehydroxylated.rho_T(T_cold_des)) "Averaged density of the iron ore in the heater subsystem (kg/m3)";
  parameter SI.Density rho_g_heating = 0.5 * (Utilities_Air.rho_T(T_hot_des) + Utilities_Air.rho_T(T_cold_des)) "Averaged density of air in the heater subsystem (kg/m3)";
  parameter SI.DynamicViscosity mu_g_heating = 0.5 * (Utilities_Air.mu_T(T_hot_des) + Utilities_Air.mu_T(T_cold_des)) "Averaged dynamic viscosity of air in the heater subsystem (Pa.s)";
  parameter SI.Velocity u_mf_heating = d_p * d_p * (rho_p_heating - rho_g_heating) * 9.81 / (1650.0 * mu_g_heating) "Minimum fluidisation velocity within the heater subsystem (m/s)";
  parameter SI.Velocity u_g_heating = 3.0 * u_mf_heating "Required air velocity is three times the minimum fluidisation velocity (m/s)";
  parameter SI.MassFlowRate m_flow_air_heating = rho_g_heating * A_cs_heating * u_g_heating "Mass flow rate through heating subsystem blower (kg/s)";
  parameter SI.VolumeFlowRate V_flow_air_heating = m_flow_air_heating / SolarTherm.Media.Air.Air_CoolProp_1bar_utilities.rho_T(298.15) "Volumetric flow rate of ambient temp air into heating subsystem blower (m3/s)";
  parameter SI.Power P_C_heating_blower = 0.9855 * (1.41 / 0.41) * (V_flow_air_heating * 1.0e5 / 0.75) * ((1.1 / 1.0) ^ (0.41 / 1.41) - 1.0) / 0.9 "Sizing power of blower of heating subsystem (W)";
  parameter Real FOB_heating_blower = CEPCI_year / 500.0 * 1.0 * exp(6.8929 + 0.79 * log(P_C_heating_blower / 745.7)) "FOB cost of the blower in the heating subsystem (USD_2022)";
  parameter Real FCI_heating_blower = 0.0;//FOB_heating_blower * 1.05 * 3.5 * 0.7012 "FCI cost of the blower in the heating subsystem (USD_2022)";
  //---17) Cold TES
  parameter SI.Length D_silo_max = (4.0 * 2832.0 / (CN.pi * ar_silo)) ^ (1.0 / 3.0) "Maximum TES silo diameter as per the cost equations (m3)";
  parameter SI.Density rho_OreD_cold = Utilities_Ore_Dehydroxylated.rho_T(T_cold_des) "Density of pure, dense Fe2O3 at the cold TES silo temperature (kg/m3)";
  parameter SI.Mass m_ore_silo_cold = m_flow_OreD_TES_des * t_storage "Maximum mass capacity of the cold TES silo (kg)";
  parameter SI.Volume V_silo_cold = m_ore_silo_cold / (rho_OreD_cold * (1.0 - epsilon));
  parameter SI.Length D_silo_cold = (4.0 * V_silo_cold / (CN.pi * ar_silo)) ^ (1.0 / 3.0);
  parameter SI.Length H_silo_cold = D_silo_cold * ar_silo;
  parameter Real N_quo_cold = div(V_silo_cold, 2832.0);
  parameter SI.Volume V_rem_cold = rem(V_silo_cold, 2832.0);
  parameter SI.Length D_rem_cold = (4.0 * V_rem_cold / (CN.pi * ar_silo)) ^ (1.0 / 3.0) "Remainder cold TES silo diameter (m3)";
  parameter SI.Area A_loss_cold_total = N_quo_cold * (CN.pi * D_silo_max * D_silo_max * ar_silo + 0.5 * CN.pi * D_silo_max * D_silo_max) + CN.pi * D_rem_cold * D_rem_cold * ar_silo + 0.5 * CN.pi * D_rem_cold * D_rem_cold;
  parameter Real FOB_silo_containment_cold = CEPCI_year / 500.0 * 1.0 * (N_quo_cold * 113736.27 + 570.0 * (35.315 * V_rem_cold) ^ 0.46) "FOB cost of the cold TES silo (USD_2022)";
  parameter Real FCI_silo_containment_cold = FOB_silo_containment_cold * 1.05 * 4.0 "FCI of the cold TES silo (USD_2022)";
  //Insulation
  parameter Real CpA_silo_insulation_cold = 764.0338 + 51.92411 / U_loss_silo_cold + 183.692 * 298.15 / (U_loss_silo_cold * T_cold_des) + 150.0738 * T_cold_des / (U_loss_silo_cold * 298.15) - 140.318 * T_cold_des / 298.15 "Cost per unit surface area of insulation for the cold TES silo (USD_2022/m2)";
  parameter Real FCI_silo_insulation_cold = CEPCI_year / 816.0 * A_loss_cold_total * CpA_silo_insulation_cold "Fixed capital investment cost of insulation for the cold TES silo (USD_2022)";
  //---18) Hot TES
  parameter SI.Density rho_OreD_hot = Utilities_Ore_Dehydroxylated.rho_T(T_hot_des) "Density of pure, dense Fe2O3 at the hot TES silo temperature (kg/m3)";
  parameter Real N_quo_hot = div(V_silo_hot, 2832.0);
  parameter SI.Volume V_rem_hot = rem(V_silo_hot, 2832.0);
  parameter SI.Length D_rem_hot = (4.0 * V_rem_hot / (CN.pi * ar_silo)) ^ (1.0 / 3.0) "Remainder hot TES silo diameter (m3)";
  parameter SI.Area A_loss_hot_total = N_quo_hot * (CN.pi * D_silo_max * D_silo_max * ar_silo + 0.5 * CN.pi * D_silo_max * D_silo_max) + CN.pi * D_rem_hot * D_rem_hot * ar_silo + 0.5 * CN.pi * D_rem_hot * D_rem_hot;
  parameter SI.Mass m_ore_silo_hot = m_flow_OreD_TES_des * t_storage "Maximum mass capacity of the hot TES silo (kg)";
  parameter SI.Volume V_silo_hot = m_ore_silo_hot / (rho_OreD_hot * (1.0 - epsilon));
  parameter SI.Length D_silo_hot = (4.0 * V_silo_hot / (CN.pi * ar_silo)) ^ (1.0 / 3.0);
  parameter SI.Length H_silo_hot = D_silo_hot * ar_silo;
  parameter Real FOB_silo_containment_hot = CEPCI_year / 500 * 2.1 * (N_quo_hot * 113736.27 + 570.0 * (35.315 * V_rem_hot) ^ 0.46) "FOB cost of the hot temp Fe2O3 storage silo (USD_2022)";
  parameter Real FCI_silo_containment_hot = FOB_silo_containment_hot * 1.05 * 2.744 "FCI of the hot TES silo (USD_2022)";
  //Insulation
  parameter Real CpA_silo_insulation_hot = 764.0338 + 51.92411 / U_loss_silo_hot + 183.692 * 298.15 / (U_loss_silo_hot * T_hot_des) + 150.0738 * T_hot_des / (U_loss_silo_hot * 298.15) - 140.318 * T_hot_des / 298.15 "Cost per unit surface area of insulation for the hot TES silo (USD_2022/m2)";
  parameter Real FCI_silo_insulation_hot = CEPCI_year / 816.0 * A_loss_hot_total * CpA_silo_insulation_hot "Fixed capital investment cost of insulation for the hot TES silo (USD_2022)";
  //Fixed Annual Costs
  //---19) Plant O&M
  Real AC_Plant = 0.04 * FCI_Plant "Annual cost due to plant O&M, 4% of Plant CAPEX excluding the PV and Wind plants (USD_2022/year)";
  //---20) Labour Cost
  parameter Real AC_Labour = 2.0 * ceil(Plant_Scale / 0.0365) * 120241.00 "Annual cost due to labour needed to run plant (USD_2022/year)";
  //AC_Labour = 6613253.0*Plant_Scale/1.0
  //---21) PV plant O&M Costs
  parameter Real AC_PV = 0.0;//0.01268 * P_PV_gross "Annual O&M costs for PV plant (USD_2022/year)";
  //---22) Wind Plant O&M Costs
  parameter Real AC_Wind = 0.0;//0.01868 * P_wind_gross "Annual O&M costs for Wind plant (USD_2022/year)";
  parameter Real AC_CST = 0.02*FCI_CST;
  parameter Real AC_Lift = 0.02*FCI_Lift;
  //Variable Annual Costs
  //---23) Mining Cost
  Real AC_Mining = 23254357.0 * CapF_Process * (Plant_Scale / 1.0) "Variable annual costs due to stoichiometric mining of iron ore (USD/yr)";
  //---24) Electricity Cost of processing iron ore
  Real AC_Electric = 4183700.0 * CapF_Process * (Plant_Scale / 1.0) "Variable annual costs due to electricity cost of processing iron ore (USD/yr)";
  //---25) Stoichiometric H2 Consumption
  Real AC_H2 = CapF_Process * m_flow_H2_stoi * 86400.0 * 365.0 * pri_H2 "Variable annual costs due to stoichiometric consumption of H2 (USD/yr)";
  //---26) Extra cost here
  Real AC_HeatLoss = pri_Elec * (W_heating_hot_silo + W_heating_cold_silo) "Variable annual costs due to electricity needed to compensate for TES heat losses (USD/yr)";
  
  Real AC_Elec_Lift = pri_Elec * (W_lifting);
  //-----Now Sum the Cost components
  //DRI Plant Capital Costs
  Real FCI_Plant = FCI_reactor + FCI_GGHX + FCI_blower_H2 + FCI_condenser1 + FCI_condenser2 + FCI_PGHX1_tubes + FCI_PGHX1_recup + FCI_PGHX1_blower + FCI_PGHX2_tubes + FCI_PGHX2_recup + FCI_PGHX2_blower + FCI_heating_heater + FCI_heating_blower + FCI_heating_recup + FCI_silo_containment_cold + FCI_silo_containment_hot + FCI_silo_containment_hot + FCI_silo_insulation_hot "Cost of the H2DRI plant, used to calculate annual plant O&M cost of 4% (USD)";
  Real C_capital = FCI_Plant + FCI_PV + FCI_Wind + FCI_Crushing + FCI_CST + FCI_Lift "Total capital costs (USD)";
  Real C_annual = AC_Plant + AC_Labour + AC_PV + AC_Wind + AC_CST + AC_Lift + AC_H2 + AC_Mining + AC_Electric + AC_HeatLoss + AC_Elec_Lift "Total annual costs (USD/yr)";
  //Financial Parameters
  parameter Real n = 30.0 "Plant lifetime (years)";
  parameter Real r_nom = 0.07 "Nominal discount rate (-)";
  parameter Real r_inf = 0.025 "Inflation rate (-)";
  parameter Real r = (1.0 + r_nom) / (1.0 + r_inf) - 1 "Real discount rate (-)";
  parameter Real f = r * (1.0 + r) ^ n / ((1.0 + r) ^ n - 1.0) "Annuity factor on LCOD calculation (-)";
  //These have to be calculated as variables...
  //-----Condenser1 Cooling Load
  SI.HeatFlowRate Q_flow_cooling_condenser1 = (1.0 - f_split_GGHX) * m_flow_H2_excess * (Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2_offgas_des, T_condenser1_in_des) - Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_des, T_condenser_out_des)) + (1.0 - f_split_GGHX) * m_flow_H2O_stoi * (Modelica.Media.Water.WaterIF97_pT.specificEnthalpy_pT(p_H2O_offgas_des, T_condenser1_in_des) - Modelica.Media.Water.WaterIF97_pT.specificEnthalpy_pT(p_H2O_offgas_des, T_condenser_out_des));
  //-----Condenser2 Cooling Load
  SI.HeatFlowRate Q_flow_cooling_condenser2 = f_split_GGHX * m_flow_H2_excess * (Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2_offgas_des, T_condenser2_in_des) - Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_des, T_condenser_out_des)) + f_split_GGHX * m_flow_H2O_stoi * (Modelica.Media.Water.WaterIF97_pT.specificEnthalpy_pT(p_H2O_offgas_des, T_condenser2_in_des) - Modelica.Media.Water.WaterIF97_pT.specificEnthalpy_pT(p_H2O_offgas_des, T_condenser_out_des));
  //-----Estimated heat loss
  SI.Energy W_lifting(start=0);
  SI.Energy W_heating_hot_silo(start = 0);
  SI.Energy W_heating_cold_silo(start = 0);
  SolarTherm.Models.Storage.Tank.Silo Cold_Tank(redeclare package Medium = Medium_Ore_Dehydroxylated, T_min = T_cold_des - 10.0, T_max = T_cold_des + 10.0, U_loss_tank = 0.0, T_start = T_cold_des, T_set = T_cold_des - 10.0, L_start = 0.50, epsilon = epsilon, H_tank = H_silo_cold, D_tank = D_silo_cold) annotation(
    Placement(visible = true, transformation(origin = {-32, -8}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  //redeclare package Filler_Package = Material_IOE_OreD,
  SolarTherm.Models.Storage.Tank.Silo Hot_Tank(redeclare package Medium = Medium_Ore_Dehydroxylated, T_min = T_hot_des - 10.0, T_max = T_hot_des + 10.0, U_loss_tank = 0.0, T_start = T_hot_des, T_set = T_hot_des - 10.0, L_start = 0.50, epsilon = epsilon, H_tank = H_silo_hot, D_tank = D_silo_hot) annotation(
    Placement(visible = true, transformation(origin = {40, -6}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  //redeclare package Filler_Package = Material_IOE_OreD,
  SolarTherm.Models.Fluid.Pumps.PumpSimple Heater_Lift(redeclare package Medium = Medium_Ore_Dehydroxylated) annotation(
    Placement(visible = true, transformation(origin = {-10, -14}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink2 Sink(redeclare package Medium = Medium_Ore_Dehydroxylated) annotation(
    Placement(visible = true, transformation(origin = {90, -12}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT OreD_source(redeclare package Medium = Medium_Ore_Dehydroxylated, T = T_cold_des, nPorts = 1, p = p_des, use_T_in = false) annotation(
    Placement(visible = true, transformation(origin = {-88, -12}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple Cold_Lift(redeclare package Medium = Medium_Ore_Dehydroxylated) annotation(
    Placement(visible = true, transformation(origin = {-56, -14}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure Reactor_Lift(redeclare package Medium = Medium_Ore_Dehydroxylated) annotation(
    Placement(visible = true, transformation(origin = {60, -12}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(origin = {-89, 55}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(visible = true, transformation(origin = {-88, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = SolarTherm.Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(visible = true, transformation(extent = {{-48, 46}, {-28, 66}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(redeclare model Optical = SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file), A_h = A_helio, E_start = helio_E_start, Q_design = A_helio * N_helio * eff_opt_des * he_av_des * 1000, W_track = helio_W_track, Wspd_max = 15.0, ele_min(displayUnit = "deg") = ele_min, he_av = he_av_des, lat = data.lat, lon = data.lon, n_h = N_helio, nu_defocus = Q_flow_helio_def / (1000 * A_helio * N_helio * eff_opt_des * he_av_des), nu_min = 0, nu_start = 0, use_defocus = true, use_on = true, use_wind = true) annotation(
    Placement(visible = true, transformation(origin = {-39, 15}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(origin = {-69, 56}, extent = {{-9, -10}, {9, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Receiver_Regression_Simplified Receiver(redeclare package Medium = Medium_Ore_Dehydroxylated, Q_flow_helio_max = Q_flow_helio_high, T_in_des = T_cold_des, T_out_des = T_hot_des, h_in_des = h_ore_cold, h_out_des = h_ore_hot, m_flow_des = m_flow_recv_des) annotation(
    Placement(visible = true, transformation(origin = {13, 13}, extent = {{-27, -27}, {27, 27}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression Defocus_signal(y = defocus) annotation(
    Placement(visible = true, transformation(origin = {-88, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Controller
  parameter SI.Time t_wait = 1.0 * 3600 "Waiting time between turning off process and being able to turn on";
  SI.Time t_threshold(start = 0.0) "if time passes this value, Process := true";
  Boolean Chg(start = true);
  Boolean Dis(start = true);
  Boolean Process(start = true);
  Integer State(start = 1);
  SI.Mass m_DRI_produced(start = 0);
  SI.Mass m_DRI_target(start = 0);
  Real CapF_Process(start = 0);
  //Real CapF_Heater(start = 0);
  //Boolean Defocus(start = false);
  //if Heater.Q_heater_raw <= 0.0 then
  //if Dis == true then
  //State = 4;
  //end if;
  //end if;
  //Energy Accounting
  //SI.Energy E_PV_out(start = 0);
  //SI.Energy E_Wind_out(start = 0);
  //SI.Energy E_renewable_raw(start = 0);
  //SI.Energy E_heater_raw(start = 0);
  //SI.Energy Q_heater_raw(start = 0);
  //SI.Energy Q_heater_out(start = 0);
  //SI.Energy Q_heater_target(start = 0);
  //maximum possible heater output at 100% operation
  //LCOD Calculation
  Real LCOD_2022 "Levelised cost per ton of DRI (USD_2022/tDRI)";
  Real LCOD_2021 = LCOD_2022 * (708.8 / 816.0) "Levelised cost per ton of DRI (USD_2021/tDRI)";
  Real LCOD_2021_AUD = LCOD_2021 * 1.330849 "Levelised cost per ton of DRI (AUD_2021/tDRI)";
  Real LCOD_2022_numerator = f * C_capital + C_annual "Numerator of the LCOD formula (USD/yr)";
  //These are annual costs
  Real LCOD_frac_Hydrogen = AC_H2 / LCOD_2022_numerator;
  Real LCOD_frac_Mining = AC_Mining / LCOD_2022_numerator;
  Real LCOD_frac_Electricity = AC_Electric / LCOD_2022_numerator;
  Real LCOD_frac_PlantOM = AC_Plant / LCOD_2022_numerator;
  Real LCOD_frac_Labour = AC_Labour / LCOD_2022_numerator;
  Real LCOD_frac_HeatLoss = AC_HeatLoss / LCOD_2022_numerator;
  //These are capital costs
  Real LCOD_frac_Plant = f * FCI_Plant / LCOD_2022_numerator;
  Real LCOD_frac_Crushing = f * FCI_Crushing / LCOD_2022_numerator;
  //These are a combination
  Real LCOD_frac_PV = (f * FCI_PV + AC_PV) / LCOD_2022_numerator;
  Real LCOD_frac_Wind = (f * FCI_Wind + AC_Wind) / LCOD_2022_numerator;
  Real LCOD_frac_CST = (f * FCI_CST + AC_CST) / LCOD_2022_numerator;
  Real LCOD_frac_Lift = (f * FCI_Lift + AC_Lift) / LCOD_2022_numerator;
  Real LCOD_frac_ElecLift = AC_Elec_Lift / LCOD_2022_numerator; 
  //Check if they sum to 1.0
  Real Sum_frac = LCOD_frac_Hydrogen + LCOD_frac_Mining + LCOD_frac_Electricity + LCOD_frac_PlantOM + LCOD_frac_Labour + LCOD_frac_Plant + LCOD_frac_PV + LCOD_frac_Wind + LCOD_frac_CST + LCOD_frac_Lift + LCOD_frac_Crushing + LCOD_frac_HeatLoss + LCOD_frac_ElecLift;
  //Guess mass flow rate
  //parameter SI.MassFlowRate m_flow_recv_des = 357.1 "Design receiver mass flow rate (kg/s)";
  parameter SI.MassFlowRate m_flow_recv_high = mu_recv_high * m_flow_recv_des;
  parameter SI.MassFlowRate m_flow_recv_def = m_flow_OreD_TES_des;
  parameter SI.MassFlowRate m_flow_recv_low = mu_recv_low * m_flow_recv_des;

  parameter Real mu_recv_high = 1.1; 
  parameter Real mu_recv_def = m_flow_recv_def/m_flow_recv_des;
  parameter Real mu_recv_low = 0.2;

  //Recv low and high mass flow rate conditions
  //Low mass flow rate
  parameter Real eff_recv_low = SolarTherm.Systems.H2DRI_Applications.recv_eff(mu_recv_low);
  //0.19912 + 2.29859*mu_recv_low - 3.83750*(mu_recv_low^2.0) + 3.09303*(mu_recv_low^3.0) - 0.95285*(mu_recv_low^4.0) "Receiver efficiency at the minimum receiver flow rate";
  parameter SI.HeatFlowRate Q_flow_helio_low = (Q_flow_heater_curtail*(m_flow_recv_low/m_flow_OreD_TES_des))/eff_recv_low "Required heliostat output heat rate at minimum receiver mass flow rate";
  //High mass flow rate
  parameter Real eff_recv_high = SolarTherm.Systems.H2DRI_Applications.recv_eff(mu_recv_high);
  //0.19912 + 2.29859*mu_recv_high - 3.83750*(mu_recv_high^2.0) + 3.09303*(mu_recv_high^3.0) - 0.95285*(mu_recv_high^4.0) "Receiver efficiency at the maximum receiver flow rate";
  parameter SI.HeatFlowRate Q_flow_helio_high = (Q_flow_heater_curtail*(m_flow_recv_high/m_flow_OreD_TES_des))/eff_recv_high "Required heliostat output heat rate at maximum receiver mass flow rate";
  //Curtailment mass flow rate, m_flow_recv_def = m_flow_ore_TES_des
  parameter Real eff_recv_def = SolarTherm.Systems.H2DRI_Applications.recv_eff(mu_recv_def);
  //0.19912 + 2.29859*mu_recv_def - 3.83750*(mu_recv_def^2.0) + 3.09303*(mu_recv_def^3.0) - 0.95285*(mu_recv_def^4.0) "Receiver efficiency at the maximum receiver flow rate";
  parameter SI.HeatFlowRate Q_flow_helio_def = Q_flow_heater_curtail/eff_recv_def;
  
  SI.HeatFlowRate Q_flow_helio_raw;
  SI.MassFlowRate m_flow_recv_raw;
  Real mu_recv_raw;
  Real eff_recv_raw;
  SI.HeatFlowRate Q_flow_recv_raw;
  //Instantaneous Regression variables

  Boolean defocus(start = false);
protected
  //---Ore and DRI Composition---
  //Hydroxylated Feedstock Ore
  parameter Real f_mass_Al2O3_H = 0.0327 "Mass fraction of Al2O3 in hydroxylated iron ore";
  parameter Real f_mass_SiO2_H = 0.0728 "Mass fraction of SiO2 in hydroxylated iron ore";
  parameter Real f_mass_Fe2O3H2O_H = 0.8680 "Mass fraction of Fe2O3.H2O (goethite) in hydroxylated iron ore";
  parameter Real f_mass_Fe2O3_H = 1.0 - f_mass_Al2O3_H - f_mass_SiO2_H - f_mass_Fe2O3H2O_H "Mass fraction of Fe2O3 (haematite) in hydroxylated iron ore";
  parameter Real f_mass_LOI_H = 0.0880 "Mass fraction of the hydroxylated iron ore that is lost due to removal of water";
  parameter Real f_mass_Gangue_H = f_mass_Al2O3_H + f_mass_SiO2_H "Mass fraction of hydroxylated iron ore that is due to gangue";
  //Iron Ore IOE Composition
  //Dehydroxylated Ore after being heated past 400C
  parameter Real f_mass_Al2O3_D = 0.0359 "Mass fraction of Al2O3 in dehydroxylated iron ore";
  parameter Real f_mass_SiO2_D = 0.0798 "Mass fraction of SiO2 in dehydroxylated iron ore";
  parameter Real f_mass_Fe2O3_D = 1.0 - f_mass_Al2O3_D - f_mass_SiO2_D "Mass fraction of Fe2O3 (haematite) in dehydroxylated iron ore";
  //DRI Composition
  parameter Real f_mass_Al2O3_DRI = 0.0489 "Mass fraction of Al2O3 in DRI";
  parameter Real f_mass_SiO2_DRI = 0.1087 "Mass fraction of SiO2 in DRI";
  parameter Real f_mass_Fe_DRI = 1.0 - f_mass_Al2O3_DRI - f_mass_SiO2_DRI "Mass fraction of Fe in DRI";
  //---Chemical Constants---
  parameter SI.MolarMass M_Fe2O3H2O = SolarTherm.Models.Chemistry.ChemTable.Fe2O3H2O.M;
  parameter SI.MolarMass M_Fe2O3 = SolarTherm.Models.Chemistry.ChemTable.Fe2O3.M;
  parameter SI.MolarMass M_Fe3O4 = SolarTherm.Models.Chemistry.ChemTable.Fe3O4.M;
  parameter SI.MolarMass M_FeO = SolarTherm.Models.Chemistry.ChemTable.FeO.M;
  parameter SI.MolarMass M_Fe = SolarTherm.Models.Chemistry.ChemTable.Fe.M;
  parameter SI.MolarMass M_H2O = SolarTherm.Models.Chemistry.ChemTable.H2O.M;
  parameter SI.MolarMass M_H2 = SolarTherm.Models.Chemistry.ChemTable.H2.M;
algorithm
//Boiler Timer Control
  when Reactor_Lift.m_flow < 0.01 * m_flow_OreD_TES_des then
    Process := false;
    t_threshold := time + t_wait;
  end when;
//take this as shutdown
//start the cooldown
  when time > t_threshold then
    Process := true;
  end when;
  when Hot_Tank.L > 0.98 then
    Chg := false;
  end when;
  when Hot_Tank.L < 0.95 then
    Chg := true;
  end when;
  when Hot_Tank.L < 0.02 then
    Dis := false;
  end when;
  when Hot_Tank.L > 0.05 then
    Dis := true;
  end when;
equation
//Design penalty
  if (T_hot_des > 1123.15) or (f_split_GGHX < 0.01) or (f_split_GGHX > 0.99) then
    penalty = 1000.0;
  else
    penalty = 0.0;
  end if;
//Hopefully this is enough to calculate m_flow_recv_raw
  Q_flow_helio_raw = max(0.0, min(heliostatsField.Q_raw, Q_flow_helio_high));
  m_flow_recv_raw = Q_flow_recv_raw / Q_flow_heater_curtail * m_flow_OreD_TES_des;
  mu_recv_raw = m_flow_recv_raw/m_flow_recv_des;
  //eff_recv_raw = max(eff_recv_low,min(eff_recv_high,0.19912 + 2.29859*mu_recv_raw - 3.83750*(mu_recv_raw^2.0) + 3.09303*(mu_recv_raw^3.0) - 0.95285*(mu_recv_raw^4.0)));
  eff_recv_raw = max(eff_recv_low,min(eff_recv_high,SolarTherm.Systems.H2DRI_Applications.recv_eff(mu_recv_raw)));
  Q_flow_recv_raw = eff_recv_raw * Q_flow_helio_raw;
  
  if time > 86400.0 * 10.0 then
//10 days initialisation has finished
//der(E_PV_out) = Grid_Sum.u1 / PV_ref_size * P_PV_gross;
//der(E_Wind_out) = Grid_Sum.u2 / Wind_ref_size * P_wind_gross;
//der(E_renewable_raw) = Grid_Sum.y;
//der(E_heater_raw) = Heater.P_heater_out;
//der(Q_heater_raw) = Heater.Q_heater_raw;
//der(Q_heater_out) = Heater.Q_out;
//der(Q_heater_target) = Q_flow_heater_des;
    der(m_DRI_target) = m_flow_DRI_des;
    der(m_DRI_produced) = Sink.port_a.m_flow / m_flow_OreD_TES_des * m_flow_DRI_des;
//Tank Heat Loss power consumption
    der(W_heating_hot_silo) = 1.0 / eff_heater * Hot_Tank.L * A_loss_hot_total * U_loss_silo_hot * (T_hot_des - 298.15);
    der(W_heating_cold_silo) = 1.0 / eff_heater * Cold_Tank.L * A_loss_cold_total * U_loss_silo_cold * (T_cold_des - 298.15);
    der(W_lifting) = ((Receiver.fluid_a.m_flow)*9.81*H_tower)/eff_lifting;
  else
//der(E_PV_out) = 0.0;
//der(E_Wind_out) = 0.0;
//der(E_renewable_raw) = 0.0;
//der(E_heater_raw) = 0.0;
//der(Q_heater_raw) = 0.0;
//der(Q_heater_out) = 0.0;
//der(Q_heater_target) = 0.0;
    der(m_DRI_target) = 0.0;
    der(m_DRI_produced) = 0.0;
    der(W_heating_hot_silo) = 0.0;
    der(W_heating_cold_silo) = 0.0;
    der(W_lifting) = 0.0;
  end if;
  if time < 10.0 + 86400.0 * 10.0 then
    CapF_Process = 0.0;
//CapF_Heater = 0.0;
    LCOD_2022 = 0.0;
  else
    CapF_Process = m_DRI_produced / m_DRI_target;
//CapF_Heater = Q_heater_out / Q_heater_target;
    LCOD_2022 = (f * C_capital + C_annual) / (1.0e-3 * m_DRI_produced);
  end if;
  if Q_flow_helio_raw < Q_flow_helio_low then
    if Dis == true then
      if Process == true then
        State = 4;
      else
        State = 6;
      end if;
    else
      State = 6;
    end if;
  elseif Q_flow_helio_raw > Q_flow_helio_def then
    if Process == true then
      if Chg == true then
        State = 1;
      else
        State = 3;
      end if;
    else
      if Chg == true then
        State = 5;
      else
        State = 6;
      end if;
    end if;
  else
    if Dis == true then
      if Process == true then
        State = 2;
      else
        State = 6;
      end if;
    else
      if Chg == true then
        State = 5;
      else
        State = 6;
      end if;
    end if;
  end if;
  if State == 1 then
    Heater_Lift.m_flow = m_flow_recv_raw;
    defocus = false;
//Receiver.Q_curtail = Q_process_des;
//Not used anyway
    Cold_Lift.m_flow = m_flow_OreD_TES_des;
    Reactor_Lift.m_flow = m_flow_OreD_TES_des;
  elseif State == 2 then
    Heater_Lift.m_flow = m_flow_recv_raw;
    defocus = false;
//Receiver.Q_curtail = Q_process_des;
//Not used anyway
    Cold_Lift.m_flow = m_flow_OreD_TES_des;
    Reactor_Lift.m_flow = m_flow_OreD_TES_des;
  elseif State == 3 then
    Heater_Lift.m_flow = m_flow_OreD_TES_des;
    defocus = true;
//Receiver.Q_curtail = Q_process_des;
//Curtailed
    Cold_Lift.m_flow = m_flow_OreD_TES_des;
    Reactor_Lift.m_flow = m_flow_OreD_TES_des;
  elseif State == 4 then
    Heater_Lift.m_flow = 1.0e-9;
    defocus = false;
//Receiver.Q_curtail = Q_process_des;
//Not used anyway
    Cold_Lift.m_flow = m_flow_OreD_TES_des;
    Reactor_Lift.m_flow = m_flow_OreD_TES_des;
  elseif State == 5 then
    Heater_Lift.m_flow = m_flow_recv_raw;
    defocus = false;
//Receiver.Q_curtail = Q_process_des;
//Not used anyway
    Cold_Lift.m_flow = 1.0e-9;
    Reactor_Lift.m_flow = 1.0e-9;
  else
    Heater_Lift.m_flow = 1.0e-9;
    defocus = false;
//Receiver.Q_curtail = Q_process_des;
//Not used anyway
    Cold_Lift.m_flow = 1.0e-9;
    Reactor_Lift.m_flow = 1.0e-9;
  end if;
  Cold_Tank.T_amb = T_amb_des;
  Hot_Tank.T_amb = T_amb_des;
  Cold_Tank.p = p_des;
  Hot_Tank.p = p_des;
  Receiver.curtail = false;
  Receiver.Q_curtail = Q_flow_heater_curtail;
//not used
  Receiver.T_amb = T_amb_des;
  connect(Cold_Lift.fluid_b, Cold_Tank.fluid_a) annotation(
    Line(points = {{-50, -14}, {-40, -14}, {-40, -4}}, color = {0, 127, 255}));
  connect(OreD_source.ports[1], Cold_Lift.fluid_a) annotation(
    Line(points = {{-80, -12}, {-62, -12}, {-62, -14}}, color = {0, 127, 255}));
  connect(Reactor_Lift.fluid_b, Sink.port_a) annotation(
    Line(points = {{66, -12}, {76, -12}}, color = {0, 127, 255}));
  connect(Hot_Tank.fluid_b, Reactor_Lift.fluid_a) annotation(
    Line(points = {{48, -12}, {54, -12}}, color = {0, 127, 255}));
  connect(Cold_Tank.fluid_b, Heater_Lift.fluid_a) annotation(
    Line(points = {{-24, -14}, {-16, -14}}, color = {0, 127, 255}));
//Check the actual mixing temperature of dehydroxylated ore and hydrogen gas entering the reactor (T_reactor_mix_actual)
  m_flow_OreD_reactor_des * h_OreD_hot_des + m_flow_H2_des * h_H2_pre2_des = m_flow_OreD_reactor_des * Utilities_Ore_Dehydroxylated.h_T(T_reactor_mix_actual) + m_flow_H2_des * Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(1.0e5, T_reactor_mix_actual);
//Calculate Temperature of H2 and H2O leaving PGHX1 and entering condenser 1:
  Q_flow_PGHX1_des = (1.0 - f_split_GGHX) * m_flow_H2_excess * (Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2_offgas_des, T_products_des) - Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2_offgas_des, T_condenser1_in_des)) + (1.0 - f_split_GGHX) * m_flow_H2O_stoi * (Modelica.Media.Water.WaterIF97_pT.specificEnthalpy_pT(p_H2O_offgas_des, T_products_des) - Modelica.Media.Water.WaterIF97_pT.specificEnthalpy_pT(p_H2O_offgas_des, T_condenser1_in_des));
//Calculate Temperature of H2 and H2O leaving GGHX and entering condenser 2
  Q_flow_GGHX_des = f_split_GGHX * m_flow_H2_excess * (Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2_offgas_des, T_products_des) - Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_H2_offgas_des, T_condenser2_in_des)) + f_split_GGHX * m_flow_H2O_stoi * (Modelica.Media.Water.WaterIF97_pT.specificEnthalpy_pT(p_H2O_offgas_des, T_products_des) - Modelica.Media.Water.WaterIF97_pT.specificEnthalpy_pT(p_H2O_offgas_des, T_condenser2_in_des));
  connect(Heater_Lift.fluid_b, Receiver.fluid_a) annotation(
    Line(points = {{-4, -14}, {2, -14}, {2, -22}, {18, -22}, {18, -11}}, color = {0, 127, 255}));
  connect(Receiver.fluid_b, Hot_Tank.fluid_a) annotation(
    Line(points = {{22, 26}, {22, 16.5}, {32, 16.5}, {32, -2}}, color = {0, 127, 255}));
  connect(heliostatsField.heat, Receiver.heat) annotation(
    Line(points = {{-28, 20}, {-21, 20}, {-21, 22}, {-14, 22}}, color = {191, 0, 0}));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-76, 32}, {-64, 32}, {-64, 22}, {-50, 22}}, color = {0, 0, 127}));
  connect(Defocus_signal.y, heliostatsField.defocus) annotation(
    Line(points = {{-76, 14}, {-66, 14}, {-66, 8}, {-50, 8}}, color = {255, 0, 255}));
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-38, 46}, {-38, 26}}, color = {0, 127, 255}));
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-60, 56}, {-48, 56}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-150, -100}, {150, 100}})),
    experiment(StopTime = 3.24e+07, StartTime = 0, Tolerance = 1.0e-5, Interval = 300, maxStepSize = 60, initialStepSize = 60),
    Icon(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)),
    Documentation(info = "<html><head></head><body>Assumed Composition of Iron Ore sample IOE (by mass):<br><br>Composition: 80.65% Fe2O3, 8.80% LOI (H2O), 3.01% Al2O3, 6.71% SiO2.<br><br>Hydroxylated Iron Ore: 86.80% Fe2O3.H2O, 2.65% Fe2O3, 3.27% Al2O3, 7.28% SiO2.<br><br>Dehydroxylated Iron Ore: 88.43% Fe2O3, 3.59% Al2O3, 7.98% SiO2.<br><br>DRI From IOE: 84.24% Fe, 4.89 Al2O3, 10.87% SiO2.<br><br>Mass flow rates per 1.0 kg of hydroxylated iron ore IOE:&nbsp;<br><br>1.0000 kg IOE_H -&gt; 0.9120 kg IOE_D -&gt; 0.6696 kg DRI&nbsp;<span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">-&gt; 0.5641 kg Fe</span><br><br><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">1.4934 kg IOE_H -&gt; 1.3620 kg IOE_D -&gt; 1.0000 kg DRI -&gt; 0.8424 kg Fe</span><br style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">1.7727 kg IOE_H -&gt; 1.6167 kg IOE_D -&gt; 1.1870 kg DRI -&gt; 1.0000 kg Fe</span><div><font face=\"DejaVu Sans Mono\"><br></font></div><div><font face=\"DejaVu Sans Mono\">Year - CEPCI</font></div><div><font face=\"DejaVu Sans Mono\">2015 - 556.8</font></div><div><font face=\"DejaVu Sans Mono\">2016 - 541.7</font></div><div><font face=\"DejaVu Sans Mono\">2017 - 567.5</font></div><div><font face=\"DejaVu Sans Mono\">2018 - 603.1</font></div><div><font face=\"DejaVu Sans Mono\">2019 - 607.5</font></div><div><font face=\"DejaVu Sans Mono\">2020 - 596.2</font></div><div><font face=\"DejaVu Sans Mono\">2021 - 708.8</font></div><div><font face=\"DejaVu Sans Mono\">2022 - 816.0</font></div><div><font face=\"DejaVu Sans Mono\">2023 - 797.9</font></div><div><font face=\"DejaVu Sans Mono\">2024 - 795.1 (Preliminary)<br></font><div><br><div><br><div><br></div><div><br><div><br></div><div><br><div><br></div><div><br></div></div></div></div></div></div></body></html>"));
end H2DRI_SolarHeated;