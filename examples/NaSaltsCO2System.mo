within examples;
model NaSaltsCO2System "High temperature Sodium-sCO2 system"
	import SolarTherm.{Models,Media};
	import Modelica.SIunits.Conversions.from_degC;
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Models.Analysis.Finances;
	import SolarTherm.Types.Solar_angles;
	import SolarTherm.Types.Currency;
	import metadata = SolarTherm.Utilities.Metadata_Optics;
	extends Modelica.Icons.Example;

	//Media
	replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
	replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";

	// Input Parameters
	parameter Integer n_modules = 2 "Number of parallel CSP systems";
	parameter Boolean match_sam = false "Configure to match SAM output";
	parameter Boolean fixed_field = true "true if the size of the solar field is fixed";
	parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
	parameter Currency currency = Currency.USD "Currency used for cost analysis";
	parameter Boolean const_dispatch = true "Constant dispatch of energy";
	parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not const_dispatch "Discharging schedule from a file";

	// Weather data
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Daggett_Ca_TMY32.motab");
	parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";
	parameter nSI.Angle_deg lon = -116.78 "Longitude (+ve East)";
	parameter nSI.Angle_deg lat = 34.85 "Latitude (+ve North)";
	parameter nSI.Time_hour t_zone = -8 "Local time zone (UCT=0)";
	parameter Integer year = 2008 "Meteorological year";

	// Field
	parameter String opt_file_wspd1 = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/gen3liq_350_MWth_150_m_1.5mrad.motab");
	parameter String opt_file_wspd2 = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/gen3liq_350_MWth_150_m_2.0mrad.motab");
	parameter Real metadata_list[23] = metadata(opt_file_wspd1);
	parameter SI.Irradiance dni_des = 980 "DNI at design point";
	parameter Integer n_heliostat = integer(metadata_list[1]) "Number of heliostats";
	parameter SI.Area A_heliostat = metadata_list[2] "Heliostat module reflective area";
	parameter SI.Length H_heliostat = A_heliostat^0.5 "Heliostat height";
	parameter SI.Efficiency eff_opt = metadata_list[3] "Field optical efficiency at design point";
	parameter SI.Length H_tower = metadata_list[6] "Tower height (ground to base of receiver)";
	parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
	parameter Real land_mult = 6.16783860571 "Land area multiplier";
	parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
	parameter Real he_av_design = 0.99 "Heliostats availability";
	parameter SI.Power W_track=0.055e3 "Tracking power for a single heliostat";
	parameter SI.Power W_tracking = n_heliostat*W_track*he_av_design "Tracking power consumed at design point";

	// Receiver
	parameter SI.RadiantPower R_des = Q_rec_out_des/(1 - rec_fr) "Input power to receiver at design point";
	parameter SI.Diameter D_receiver = metadata_list[4] "Receiver diameter";
	parameter SI.Length H_receiver = metadata_list[5] "Receiver height";
	parameter Integer N_pa_rec = 12 "Number of panels in receiver";
	parameter SI.Thickness t_tb_rec = 1.25e-3 "Receiver tube wall thickness";
	parameter SI.Diameter D_tb_rec = 40e-3 "Receiver tube outer diameter";
	parameter SI.Efficiency ab_rec = 0.98 "Receiver coating absorptance";
	parameter SI.Efficiency em_rec = 0.91 "Receiver coating emissivity";
	parameter Real[4] CL = {metadata_list[8],metadata_list[9],metadata_list[10],metadata_list[11]};
	parameter Real[4] C4L = {metadata_list[12],metadata_list[13],metadata_list[14],metadata_list[15]};
	parameter Real[5] CH = {metadata_list[16],metadata_list[17],metadata_list[18],metadata_list[19],metadata_list[20]};
	parameter Real rec_fr = 1 - metadata_list[7] "Receiver loss fraction of radiance at design point";
	parameter SI.Efficiency eff_ab = metadata_list[21] "Receiver effective coating absorptance";
	parameter SI.Efficiency eff_em = metadata_list[22] "Receiver effective coating emissivity";
	parameter Real F_mult=2.6 "Piping length multiplier";
	parameter Real C_pip(unit="W/m") = 10200 "Piping loss coeficient";
	parameter SI.Efficiency eta_pump = 0.85 "Design point efficiency of the tower/receiver pump";
	parameter Real SM = metadata_list[23] "Solar multiple";

	// HX
	parameter SI.HeatFlowRate Q_hx_design = Q_rec_out_des * hx_to_rec_factor "HX design power";
	parameter SI.Temperature T_cold_set_Na = CV.from_degC(520) "Cold HX target temperature";
	parameter SI.Temperature T_hot_set_Na = CV.from_degC(740) "Hot Receiver target temperature";
	parameter Medium1.ThermodynamicState state_cold_set_Na = Medium1.setState_pTX(Medium1.p_default, T_cold_set_Na) "Cold Sodium thermodynamic state at design";
	parameter Medium1.ThermodynamicState state_hot_set_Na = Medium1.setState_pTX(Medium1.p_default, T_hot_set_Na) "Hot Sodium thermodynamic state at design";
	parameter SI.Density rho_cold_set_Na = Medium1.density(state_cold_set_Na) "Cold salt density at design";
	parameter SI.Density rho_hot_set_Na = Medium1.density(state_hot_set_Na) "Cold salt density at design";
	parameter SI.Temperature T_cold_set_CS = CV.from_degC(500) "Cold tank target temperature";
	parameter SI.Temperature T_hot_set_CS = CV.from_degC(720) "Hot tank target temperature";
	parameter Medium2.ThermodynamicState state_cold_set_CS = Medium2.setState_pTX(Medium2.p_default, T_cold_set_CS) "Cold salt thermodynamic state at design";
	parameter Medium2.ThermodynamicState state_hot_set_CS = Medium2.setState_pTX(Medium2.p_default, T_hot_set_CS) "Hold salt thermodynamic state at design";
	parameter SI.Temperature T_Na2_input = T_cold_set_Na "Outlet asodium temperature";
	parameter FI.MassPrice material_sc = 80 "Material HX Specific Cost"; // UNS 06230
	parameter Real hx_to_rec_factor = 1; //Use ratio_cond to constrain the design of the HX: if "true" the HX will be forced to have L/D_s aspect ratio<ratio_max.
	parameter Boolean ratio_cond = true "Activate ratio constraint"; //Default value = true
	parameter Real ratio_max = 10 "Maximum L/D_s ratio"; //If ratio_cond = true provide a value (default value = 10) Use it to constrain the design of the HX: if "true" the HX will be forced to have L<L_max.
	parameter Boolean L_max_cond = false "Activate maximum HX length constraint"; //Default value = false
	parameter SI.Length L_max_input = 1 "Maximum HX length"; //If L_max_cond = true provide a value (default value = 10) If optimize_HX_design is "true", d_o, N_p and layout will be chosen as results of the optimization, otherwise provide the following input values:
	parameter Boolean optimize_HX_design = false;
	parameter SI.Length d_o_input = 0.01905 "User defined outer tube diameter";
	parameter Integer N_p_input = 1 "User defined tube passes number";
	parameter Integer layout_input = 2 "User defined tube layout";
	parameter Boolean N_t_input_on = true "Activate fixed number of tubes";
	parameter Integer N_t_input = 23559 "User defined number of tubes"; //If the input value is smaller then the minimum or higher then then maximum acceptable, it will be replaced!

	// Storage
	parameter Real t_storage(fixed = true, unit = "h") = 12.0 "Hours of storage"; // NREL updated the base case storage to 12 hours
	parameter SI.Temperature T_cold_start_CS = CV.from_degC(500) "Cold tank starting temperature";
	parameter SI.Temperature T_hot_start_CS = CV.from_degC(720) "Hot tank starting temperature";
	parameter SI.Temperature T_cold_aux_set = CV.from_degC(450) "Cold tank auxiliary heater set-point temperature";
	parameter SI.Temperature T_hot_aux_set = CV.from_degC(575) "Hot tank auxiliary heater set-point temperature";
	parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
	parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
	parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
	parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
	parameter SI.CoefficientOfHeatTransfer alpha = 0.4 "Tank constant heat transfer coefficient with ambient";
	parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold tank parasitic power coefficient";
	parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot tank parasitic power coefficient";
	parameter SI.SpecificEnergy k_loss_cold_sodium = 0.022e3 "Sodium pump parasitic power coefficient";
	parameter SI.Power W_heater_hot = 30e6 "Hot tank heater capacity";
	parameter SI.Power W_heater_cold = 15e6 "Cold tank heater capacity";

	// Power block
	//*** Surrogate Power Block Parameters
	parameter String base_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include") "Base path that points to which folder the C program located";
	parameter String SolarTherm_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm") "Base path that points to which folder SolarTherm libs are located";
	parameter Integer inputsize_PB = 3;
	parameter Integer outputsize_PB = 2;
	parameter Real tolerance_kriging = 6e-3 "Mean Absolute Error";
	parameter Real tolerance_ANN = 6e-3 "Mean Absolute Error";
	parameter Integer which_surrogate = 2 "1 for Kriging, 2 for ANN";
	parameter Real eta_net_base = 0.48 "Net thermal-to-electric cycle efficiency after power cycle parasitic loads";
	parameter Real eta_Q_base(fixed = false) "By product of PB initialisation, regardless which PB model is chosen e.g CEA or SAM";
	parameter SI.HeatFlowRate Q_flow_des(fixed = false) "Heat to power block at design, By product of PB initialisation, regardless which PB model is chosen e.g CEA or SAM";
	parameter SI.MassFlowRate m_flow_blk(fixed = false) "Mass flow rate to power block at design point, By product of PB initialisation, regardless which PB model is chosen e.g CEA or SAM";
	//*** NREL SAM PB Parameters
	parameter SI.Temperature T_low = from_degC(41) "Inlet temperature of the compressor";
	parameter Integer N_HTR = 15 "Discretisation of high temperature recuperator";
	parameter Integer N_LTR_parameter = 15 "Discretisation of low temperature recuperator";
	parameter SI.Temperature T_high = from_degC(700) "inlet temperature of the turbine";
	parameter Real gamma = 0.28 "Part of the mass flow going to the recompression directly";
	parameter Real par_fr = 0.1 "Parasitics fraction of power block rating at design point";
	parameter Real par_fr_des (fixed = false) "Verification of parasitics fraction of power block rating at design point";
	parameter SI.Power P_net = 50e6 "Power block net rating at design point";
	parameter SI.Power P_gross = P_net / (1 - par_fr);
	parameter SI.Pressure p_high = 25e6 "high pressure of the cycle in Pa";
	parameter SI.Temperature blk_T_amb_des = from_degC(35) "Ambient temperature at design for power block";
	parameter Integer htf_choice = 50 "Choice for fluid properties in SAM SIMULATION CORE (SSC)";
	parameter SI.TemperatureDifference dT_PHX_hot_approach(fixed = false) "Temp. difference between hot HTF and TIT";
	parameter SI.TemperatureDifference dT_PHX_cold_approach = 15 "Temp. difference between cold HTF and cold CO2 PHX inlet";
	parameter SI.Efficiency eta_comp_main = 0.89 "Main compressor isentropic efficiency";
	parameter SI.Efficiency eta_comp_re = 0.89 "Re-compressor isentropic efficiency";
	parameter SI.Efficiency eta_turb = if P_gross > 3e7 then 0.93 else 0.85 "Turbine isentropic efficiency";
	parameter SI.TemperatureDifference dT_mc_approach = 6.0 "Temp. difference between main compressor CO2 inlet and ambient";
	parameter Integer which_PB_model = 1 "Choice of the Expensive PB model: 0 is for CEA power block, 1 is for NREL-SAM power block";
	parameter String HTF_name = "ChlorideSalt";
	parameter Real NREL_PB_configurations[13](each fixed = false) if which_PB_model == 1 "array to store design point sizing result";
	parameter SI.Efficiency eff_blk = 0.51 "Power block efficiency at design point";
	parameter Real par_fix_fr = 0.0055 "Fixed parasitics as fraction of gross rating";
	parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";
	parameter Boolean external_parasities = true "true if there is external parasitic power losses";
	parameter Real nu_min_blk = 0.5 "minimum allowed part-load mass flow fraction to power block";
	parameter SI.Power W_base_blk = par_fix_fr * P_gross "Power consumed at all times in power block";
	parameter SI.Power W_cooling_des = 0.02*P_gross "Fraction of gross power consumed by cooling system";
	parameter SI.Power W_pump_pb(fixed = false) "PB pump parasitic losses at design";
	parameter SI.Power W_pump_rec(fixed = false) "Receiver pump parasitic losses at design";
	parameter SI.Power W_pump_tk(fixed = false) "Cold tank pump parasitic losses at design";
	parameter SI.AbsolutePressure p_blk = 10e6 "Power block operating pressure";
	parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
	parameter SI.Temperature T_in_ref_blk = from_degC(720) "HTF inlet temperature to power block at design";
	parameter SI.Temperature T_out_ref_blk = from_degC(500) "HTF outlet temperature to power block at design";

	// Control
	parameter SI.Time t_ramping = 1800 "Power block startup delay";
	parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
	parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
	parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
	parameter Real nu_start = 0.20 "Minimum energy start-up fraction to start the receiver";
	parameter Real nu_min_sf = 0.20 "Minimum turn-down energy fraction to stop the receiver";
	parameter Real hot_tnk_empty_lb = 10 "Hot tank empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real hot_tnk_empty_ub = 12 "Hot tank empty trigger upper bound"; // Level (above which) to start disptach
	parameter Real hot_tnk_full_lb = 120 "Hot tank full trigger lower bound";
	parameter Real hot_tnk_full_ub = 123 "Hot tank full trigger upper bound";
	parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound"; // Level (above which) to start disptach
	parameter Real cold_tnk_crit_lb = 0 "Cold tank critically empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound"; // Level (above which) to start disptach

	//Storage Calculated parameters
	parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
	parameter SI.SpecificEnthalpy h_cold_set_CS = Medium2.specificEnthalpy(state_cold_set_CS) "Cold salt specific enthalpy at design";
	parameter SI.SpecificEnthalpy h_hot_set_CS = Medium2.specificEnthalpy(state_hot_set_CS) "Hot salt specific enthalpy at design";
	parameter SI.Density rho_cold_set = Medium2.density(state_cold_set_CS) "Cold salt density at design";
	parameter SI.Density rho_hot_set = Medium2.density(state_hot_set_CS) "Hot salt density at design";
	parameter SI.Mass m_max = E_max / (h_hot_set_CS - h_cold_set_CS) "Max salt mass in tanks";
	parameter SI.Volume V_max = m_max / ((rho_hot_set + rho_cold_set) / 2) "Max salt volume in tanks";
	parameter SI.MassFlowRate m_flow_fac = Q_hx_design / (h_hot_set_CS - h_cold_set_CS) "Mass flow rate to receiver at design point";
	parameter Real CS_velocity_factor=Shell_and_Tube_HX.v_max_MS_lim_max/Shell_and_Tube_HX.v_max_MS_design;
	parameter SI.MassFlowRate m_flow_max_CS = CS_velocity_factor * m_flow_fac "Maximum mass flow rate to receiver";
	parameter SI.MassFlowRate m_flow_start_CS = m_flow_fac "Initial or guess value of mass flow rate to receiver in the feedback controller";
	parameter SI.Length H_storage = 10.9 "Storage tank height";
	parameter SI.Diameter D_storage = 45 "Storage tank diameter";
	//parameter SI.Pressure Dp_tube_design
	//parameter SI.Pressure Dp_shell_design


	//Receiver Calculated parameters
	parameter SI.HeatFlowRate Q_rec_out_des = Q_flow_des * SM "Heat from receiver at design";
	parameter SI.SpecificEnthalpy h_cold_set_Na = Medium1.specificEnthalpy(state_cold_set_Na) "Cold Sodium specific enthalpy at design";
	parameter SI.SpecificEnthalpy h_hot_set_Na = Medium1.specificEnthalpy(state_hot_set_Na) "Hot Sodium specific enthalpy at design";
	parameter SI.MassFlowRate m_flow_rec = Q_hx_design / (h_hot_set_Na - h_cold_set_Na) "Mass flow rate to receiver at design point";
	parameter Real Na_velocity_factor=Shell_and_Tube_HX.v_Na_lim_max/Shell_and_Tube_HX.v_Na_design; /*1.54*/	
	parameter SI.MassFlowRate m_flow_max_Na = Na_velocity_factor * m_flow_rec "Maximum mass flow rate to receiver";
	parameter SI.MassFlowRate m_flow_start_Na = m_flow_rec "Initial or guess value of mass flow rate to receiver in the feedback controller";

	//SF Calculated Parameters
	parameter SI.Area A_field = n_heliostat * A_heliostat "Heliostat field reflective area";
	parameter SI.Area A_receiver = CN.pi*D_receiver*H_receiver "Receiver aperture area";
	parameter SI.Area A_land = n_modules*land_mult * A_field + 197434.207385281 "Land area";

	//Power Block Control and Calculated parameters
	parameter SI.Power P_name = P_net "Nameplate rating of power block";

	// Cost data in USD (default) or AUD
	parameter Real r_disc = 0.044 "Real discount rate";
	parameter Real r_i = 0.025 "Inflation rate";
	parameter Integer t_life(unit = "year") = 30 "Lifetime of plant";
	parameter Integer t_cons(unit = "year") = 0 "Years of construction";
	parameter Real f_Subs = 0 "Subsidies on initial investment costs";
	parameter FI.AreaPrice pri_field = 75 "Field cost per design aperture area ($/m2)";
	parameter FI.AreaPrice pri_site = 10 "Site improvements cost per area ($/m2)";
	parameter FI.EnergyPrice pri_storage = 39.47 "Storage cost per energy capacity ($/MWh)";
	parameter FI.PowerPrice pri_bop = 0 "Balance of plant cost per gross rated power";
	parameter FI.AreaPrice pri_land = 10000 "Land cost per area ($/acre)";
	parameter Real pri_om_name(unit = "$/kWe/year") = 40 "Fixed O&M cost per nameplate per year";
	parameter Real pri_om_prod(unit = "$/MWh/year") = 3 "Variable O&M cost per production per year";

	// Receiver cost
	parameter FI.Money_USD C_rec_fix = 4780420 "Receiver fixed Cost";
	parameter FI.Money_USD C_rec_ref = 35400613 "Receiver reference Cost";
	parameter SI.Diameter D_receiver_ref = 20 "Receiver reference diameter";
	parameter SI.Height H_receiver_ref = 18.4 "Receiver reference height";
	parameter Real rec_exp = 0.6 "Receiver reference height";

	// Riser and downcomer cost
	parameter SI.Length L_horiz = 10 "Additional horizontal length of riser and downcomer to the HEX";
	parameter Real lm_r = 1.43 "Length multiplier for expansion loops on riser";
	parameter Real lm_d = 1.45 "Length multiplier for expansion loops on downcomer";
	parameter SI.Length L_riser = lm_r*(H_tower + L_horiz) "Riser length (including expansion loops)";
	parameter SI.Length L_downcomer = lm_d*(H_tower + L_horiz) "Downcomer length (including expansion loops)";

	parameter SI.Diameter D_r = 0.66 "Riser outer diameter";
	parameter SI.Diameter D_d = 0.66 "Downcomer outer diameter";

	parameter SI.Thickness t_r = 0.007925 "Riser wall thickness";
	parameter SI.Thickness t_d = 0.007925 "Downcomer wall thickness";

	parameter SI.Density rho_r = 8.03 "Riser material density (g/cm3)"; //UNS S34709
	parameter SI.Density rho_d = 8.97 "Downcomer material density (g/cm3)"; //UNS 06230

	parameter Real mass_pm_r(unit="kg/m") = (D_r^2-(D_r-2*t_r)^2)*CN.pi/4*rho_r*1000 "Riser piping mass per meter";
	parameter Real mass_pm_d(unit="kg/m") = (D_d^2-(D_d-2*t_d)^2)*CN.pi/4*rho_d*1000 "Downcomer piping mass per meter";

	parameter SI.Diameter D_r_ref = 0.7112 "Riser reference diameter";
	parameter SI.Diameter D_d_ref = 0.7112 "Downcomer reference diameter";

	parameter Real C_r_m(unit = "$/kg") = 8 "Riser material cost per kg";
	parameter Real C_d_m(unit = "$/kg") = 80 "Downcomer material cost per kg";

	parameter Real C_r_mat_pm(unit = "$/m") = C_r_m*mass_pm_r "Riser material cost per m";
	parameter Real C_d_mat_pm(unit = "$/m") = C_d_m*mass_pm_d "Downcomer material cost per m";

	parameter Real C_r_ref(unit = "$/m") = 5192 "Riser reference cost without material";
	parameter Real C_d_ref(unit = "$/m") = 8056 "Riser reference cost without material";

	parameter FI.Money_USD C_riser = C_r_ref*(D_r/D_r_ref)*L_riser + C_r_mat_pm*L_riser "Riser cost";
	parameter FI.Money_USD C_downcomer = C_d_ref*(D_d/D_d_ref)*L_downcomer + C_d_mat_pm*L_downcomer "Downcomer cost";

	// Sodium loop cost
	parameter FI.Money_USD C_pip_na_ref =  2000000 "Sodium piping reference cost";
	parameter FI.Money_USD C_ic_na_ref = 417000 "Valves and I&C reference cost";
	parameter FI.Money_USD C_valve_na_ref = 1269000 "Sodium valves reference cost";
	parameter FI.Money_USD C_tank_na_ref = 2073640 "Sump tank reference cost";
	parameter FI.Money_USD C_vessel_na_ref = 361522 "Inlet vessel reference cost";
	parameter FI.Money_USD C_skid_na_ref = 494309 "Purification skid reference cost";
	parameter FI.Money_USD C_pump_na_ref = 5475248 "Sodium pumps reference cost";
	parameter FI.Money_USD C_argon_na_ref = 136210 "Argon system reference cost";

	parameter Real pip_na_exp = 0.7 "Sodium piping scaling exponent";
	parameter Real ic_na_exp = 0.5 "Valves and I&C scaling exponent";
	parameter Real valve_na_exp = 0.7 "Sodium valves scaling exponent";
	parameter Real tank_na_exp = 0.7 "Sump tank scaling exponent";
	parameter Real vessel_na_exp = 0.7 "Inlet vessel scaling exponent";
	parameter Real skid_na_exp = 0.7 "Purification skid scaling exponent";
	parameter Real pump_na_exp = 0.7 "Sodium pumps scaling exponent";
	parameter Real argon_na_exp = 0.5 "Argon system scaling exponent";

	parameter SI.HeatFlowRate Q_rec_ASTRI_ref = 543e6 "Receiver thermal output reference size";
	parameter SI.HeatFlowRate Q_rec_CMI_ref = 720e6 "Receiver thermal output reference size";
	parameter SI.HeatFlowRate Q_rec_NREL_ref = 590e6 "Receiver thermal output reference size";
	parameter SI.HeatFlowRate Q_rec_APOLLO_ref = 565e6 "Receiver thermal output reference size";

	parameter FI.Money_USD C_pip_na = C_pip_na_ref*(Q_rec_out_des/Q_rec_CMI_ref)^pip_na_exp "Sodium piping cost";
	parameter FI.Money_USD C_ic_na = C_ic_na_ref*(Q_rec_out_des/Q_rec_APOLLO_ref)^ic_na_exp "Valves and I&C reference cost";
	parameter FI.Money_USD C_valve_na = C_valve_na_ref*(Q_rec_out_des/Q_rec_APOLLO_ref)^valve_na_exp "Sodium valves cost";
	parameter FI.Money_USD C_tank_na = C_tank_na_ref*(Q_rec_out_des/Q_rec_CMI_ref)^tank_na_exp "Sump tank cost";
	parameter FI.Money_USD C_vessel_na = C_vessel_na_ref*(Q_rec_out_des/Q_rec_CMI_ref)^vessel_na_exp "Inlet vessel cost";
	parameter FI.Money_USD C_skid_na = C_skid_na_ref*(Q_rec_out_des/Q_rec_CMI_ref)^skid_na_exp "Purification skid cost";
	parameter FI.Money_USD C_pump_na = C_pump_na_ref*(Q_rec_out_des/Q_rec_NREL_ref)^pump_na_exp "Sodium pump cost";
	parameter FI.Money_USD C_argon_na = C_argon_na_ref*(Q_rec_out_des/Q_rec_CMI_ref)^argon_na_exp "Argon system cost";

	//Cold and hot salt pump cost
	parameter FI.Money_USD C_salt_pump_cold_ref =  3994270 "Cold salt pump reference cost";
	parameter FI.Money_USD C_salt_pump_hot_ref =  2995703 "Hot salt pump reference cost";
	parameter Real pump_salt_exp = 0.7 "Cold and hot salt pump cost scaling exponent";
	parameter FI.Money_USD C_salt_pump_cold = C_salt_pump_cold_ref*(Q_rec_out_des/Q_rec_NREL_ref)^pump_salt_exp "Cold salt pump cost";
	parameter FI.Money_USD C_salt_pump_hot = C_salt_pump_hot_ref*(Q_rec_out_des/Q_rec_NREL_ref)^pump_salt_exp "Hot salt pump cost";

	// Power block cost
	parameter SI.Power P_gross_ref = 111e6 "Power block reference size";
	parameter SI.HeatFlowRate Q_flow_des_ref = 100000000 "Salt-CO2 primary heat exchanger reference size";	
	parameter Real pri_block_ref(unit="$/kWe") = 600 "Power block reference unit price";
	parameter Real pri_hex_salt_co2_ref(unit="$/kWth") = 229 "Salt-CO2 primary heat exchanger reference unit price";
	parameter Real power_block_exp = 0.7 "Power block scaling exponent";
	parameter Real hex_salt_co2_exp = 1.0 "Salt-CO2 primary heat exchanger scaling exponent";

	// Sodium-Salt heat exchanger cost
	parameter Real pri_hex_na_salt_ref(unit="$/m2") = 1833.99 "Sodium-salt hex reference unit price";
	parameter SI.Area A_hx_na_salt_ref = 10e3 "Sodium-salt hex reference area";
	parameter Real hex_na_salt_exp = 0.7 "Sodium-salt hex scaling exponent";
	parameter Real pri_hex_na_salt(unit="$/m2") = pri_hex_na_salt_ref*(Shell_and_Tube_HX.A_HX/A_hx_na_salt_ref)^hex_na_salt_exp "Sodium-salt hex unit price";

	// Salt piping and valves
	parameter SI.Length L_salt_na_cold = 20 "Length of cold salt charge piping (exc. expansion loops)";
	parameter SI.Length L_salt_na_hot = 20 "Length of hot salt charge piping (exc. expansion loops)";

	parameter SI.Length L_salt_co2_cold = 10 "Length of cold salt discharge piping (exc. expansion loops)";
	parameter SI.Length L_salt_co2_hot = 10 "Length of hot salt discharge piping (exc. expansion loops)";

	parameter SI.Diameter D_salt_na_cold = 0.508 "Cold salt charge piping diameter";
	parameter SI.Diameter D_salt_na_hot = 0.508 "Hot salt charge piping diameter";

	parameter SI.Diameter D_salt_co2_cold = 0.3556 "Cold salt discharge piping diameter";
	parameter SI.Diameter D_salt_co2_hot = 0.3556 "Hot salt discharge piping diameter";

	parameter SI.Thickness t_salt_na_cold = 0.00635 "Cold salt charge piping wall thickness";
	parameter SI.Thickness t_salt_na_hot = 0.00635 "Hot salt charge piping wall thickness";

	parameter SI.Thickness t_salt_co2_cold = 0.00635 "Cold salt discharge piping wall thickness";
	parameter SI.Thickness t_salt_co2_hot = 0.00635 "Hot salt discharge piping wall thickness";

	parameter SI.Density rho_sc = 8.03 "Cold salt piping material density (g/cm3)"; //UNS S34709
	parameter SI.Density rho_sh = 8.97 "Hot salt piping material density (g/cm3)"; //UNS 06230

	parameter Real mass_pm_salt_na_cold(unit="kg/m") = (D_salt_na_cold^2-(D_salt_na_cold-2*t_salt_na_cold)^2)*CN.pi/4*rho_sc*1000 "Cold salt piping mass per meter";
	parameter Real mass_pm_salt_na_hot(unit="kg/m") = (D_salt_na_hot^2-(D_salt_na_hot-2*t_salt_na_hot)^2)*CN.pi/4*rho_sh*1000 "Hot salt piping mass per meter";

	parameter Real mass_pm_salt_co2_cold(unit="kg/m") = (D_salt_co2_cold^2-(D_salt_co2_cold-2*t_salt_co2_cold)^2)*CN.pi/4*rho_sc*1000 "Cold salt piping mass per meter";
	parameter Real mass_pm_salt_co2_hot(unit="kg/m") = (D_salt_co2_hot^2-(D_salt_co2_hot-2*t_salt_co2_hot)^2)*CN.pi/4*rho_sh*1000 "Hot salt piping mass per meter";

	parameter Real lm_sc = 1.43 "Length multiplier for expansion loops on cold salt piping";
	parameter Real lm_sh = 1.45 "Length multiplier for expansion loops on hot salt piping";

	parameter SI.Diameter D_sc_ref = 0.7112 "Cold salt piping reference diameter";
	parameter SI.Diameter D_sh_ref = 0.7112 "Hot salt piping reference diameter";

	parameter Real C_sc_m(unit="$/kg") = 8 "Cold salt piping material cost"; //UNS S34709
	parameter Real C_sh_m(unit="$/kg") = 80 "Hot salt piping material cost"; //UNS 06230

	parameter Real C_salt_na_cold_mat_pm(unit = "$/m") = C_sc_m*mass_pm_salt_na_cold "Cold salt piping material cost per m";
	parameter Real C_salt_na_hot_mat_pm(unit = "$/m") = C_sh_m*mass_pm_salt_na_hot "Hot salt piping material cost per m";

	parameter Real C_salt_co2_cold_mat_pm(unit = "$/m") = C_sc_m*mass_pm_salt_na_cold "Cold salt piping material cost per m";
	parameter Real C_salt_co2_hot_mat_pm(unit = "$/m") = C_sh_m*mass_pm_salt_na_hot "Hot salt piping material cost per m";

	parameter Real C_sc_ref(unit="$/m") = 5192 "Cold salt reference cost (excluding pipe material)";
	parameter Real C_sh_ref(unit="$/m") = 8056 "Hot saltreference cost (excluding pipe material";

	parameter FI.Money_USD C_piping_cold_salt_na = C_sc_ref*(D_salt_na_cold/D_sc_ref)*lm_sc*L_salt_na_cold + C_salt_na_cold_mat_pm*lm_sc*L_salt_na_cold "Cold salt charge piping cost";
	parameter FI.Money_USD C_piping_hot_salt_na = C_sh_ref*(D_salt_na_hot/D_sh_ref)*lm_sh*L_salt_na_hot + C_salt_na_hot_mat_pm*lm_sh*L_salt_na_hot "Hot salt charge piping cost";

	parameter FI.Money_USD C_piping_cold_salt_co2 = C_sc_ref*(D_salt_co2_cold/D_sc_ref)*lm_sc*L_salt_co2_cold + C_salt_co2_cold_mat_pm*lm_sc*L_salt_co2_cold "Cold salt discharge piping cost";
	parameter FI.Money_USD C_piping_hot_salt_co2 = C_sh_ref*(D_salt_co2_hot/D_sh_ref)*lm_sh*L_salt_co2_hot + C_salt_co2_hot_mat_pm*lm_sh*L_salt_co2_hot "Hot salt discharge piping cost";

	parameter FI.Money_USD C_piping_cold_salt = C_piping_cold_salt_na + C_piping_cold_salt_co2 "Cold salt piping cost";
	parameter FI.Money_USD C_piping_hot_salt = C_piping_hot_salt_na + C_piping_hot_salt_co2 "Hot salt piping cost";

	parameter FI.Money_USD C_salt_valves = 1890000 "Cost of salt valves";

	// Purchase equipment costs
	parameter FI.Money_USD C_receiver = C_rec_fix + C_rec_ref * (D_receiver / D_receiver_ref) * (H_receiver/H_receiver_ref)^rec_exp "Receiver cost";
	parameter FI.Money_USD C_tower = 16339938 "Tower cost";
	parameter FI.Money_USD C_rd = C_riser + C_downcomer "Riser and downcomer cost";
	parameter FI.Money_USD C_loop_na = C_pip_na + C_ic_na + C_valve_na + C_tank_na + C_vessel_na + C_skid_na + C_argon_na + C_pump_na "Sodium loop cost";
	parameter FI.Money_USD C_salt_pumps = C_salt_pump_cold + C_salt_pump_hot "Salt pump cost";
	parameter FI.Money_USD C_salt_piping = C_piping_cold_salt + C_piping_hot_salt "Salt piping and valves cost";
	parameter FI.Money_USD C_hx = pri_hex_na_salt*Shell_and_Tube_HX.A_HX "Heat Exchanger cost";
	parameter FI.Money_USD C_storage = pri_storage * E_max / (1e3 * 3600) "Storage cost";
	parameter FI.Money_USD C_block = P_gross_ref/1000*pri_block_ref*(P_gross/P_gross_ref)^power_block_exp "Power block cost";
	parameter FI.Money_USD C_hex_salt_co2 = Q_flow_des_ref/1000*pri_hex_salt_co2_ref*(Q_flow_des/Q_flow_des_ref)^hex_salt_co2_exp "Salt-CO2 HEX cost";
	parameter FI.Money_USD C_field = pri_field * A_field "Field cost";
	parameter FI.Money_USD C_site = pri_site * A_field "Site improvements cost";
	parameter FI.Money_USD C_bop = pri_bop * P_gross / 1e3 "Balance of plant cost";
	parameter FI.Money_USD C_salt_ullage = 2860000 "Cost of nitrogen ullage gas system";

	// Direct capital costs (subtotal)
	parameter Real f_contingency = 0.1 "Contingency factor";
	parameter FI.Money_USD C_cap_dir_sub = (1 - f_Subs) * n_modules*(C_receiver + C_loop_na + C_tower + C_rd + C_salt_pumps + C_salt_piping + C_salt_valves + C_hx + C_storage + C_block + C_hex_salt_co2 + C_field + C_site + C_salt_ullage) "Direct capital cost subtotal"; // i.e. purchased equipment costs
	parameter FI.Money_USD C_contingency = f_contingency * C_cap_dir_sub "Contingency costs";

	// Total direct capital cost
	parameter FI.Money_USD C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
	parameter FI.Money_USD C_EPC = 0.09 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs"; //Based on Downselect Criteria, Table 2
	parameter FI.Money_USD C_land = pri_land * A_land / 4046.86 "Land cost";

	// Total capital investment
	parameter FI.Money_USD C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";

	// Operation and maintenance cost
	parameter FI.MoneyPerYear C_year = pri_om_name * n_modules * P_name / 1e3 "Fixed O&M cost per year";
	parameter Real C_prod(unit = "$/J/year") = pri_om_prod / (1e6 * 3600) "Variable O&M cost per production per year";

	// ************************************* System components **************************************

	//Weather data
	SolarTherm.Models.Sources.DataTable.DataTable data(
		lon = lon,
		lat = lat,
		t_zone = t_zone,
		year = year,
		file = wea_file)
		annotation(Placement(visible = true, transformation(extent = {{-128, -82}, {-98, -54}}, rotation = 0)));

	//DNI_input
	Modelica.Blocks.Sources.RealExpression DNI_input(
		y = data.DNI)
		annotation(Placement(visible = true, transformation(extent = {{-136, 58}, {-116, 78}}, rotation = 0)));

	//Tamb_input
	Modelica.Blocks.Sources.RealExpression Tamb_input(
		y = data.Tdry)
		annotation(Placement(visible = true, transformation(extent = {{178, 90}, {158, 110}}, rotation = 0)));

	//WindSpeed_input
	Modelica.Blocks.Sources.RealExpression Wspd_input(
		y = data.Wspd) 
		annotation(Placement(visible = true, transformation(extent = {{-136, 20}, {-110, 40}}, rotation = 0)));
	
	//Pressure_input
	Modelica.Blocks.Sources.RealExpression Pres_input(
		y = data.Pres) 
		annotation(Placement(visible = true, transformation(extent = {{140, -22}, {120, -2}}, rotation = 0)));
	
	//Parasitic inputs
	Modelica.Blocks.Sources.RealExpression parasities_input(
		y = heliostatsField.W_loss + pumpHot.W_loss + pumpSodium.W_loss + pumpCold2.W_loss + tankHot.W_loss + tankCold.W_loss + receiver.W_dot_pump) 
		annotation(Placement(visible = true, transformation(origin = {149, 64}, extent = {{-13, -10}, {13, 10}}, rotation = -90)));

	//Sodium loop Pressure Losses
	Modelica.Blocks.Sources.RealExpression PressureLosses_Na_loop(
		y = Shell_and_Tube_HX.Dp_tube) 
		annotation(Placement(visible = true, transformation(extent = {{-132, -50}, {-112, -30}}, rotation = 0)));

	//ChlorideSalt loop Pressure Losses
	Modelica.Blocks.Sources.RealExpression PressureLosses_CS_loop(
		y = Shell_and_Tube_HX.Dp_shell)
		annotation(Placement(visible = true, transformation(extent = {{-22, 52}, {-2, 72}}, rotation = 0)));

	// Or block for defocusing
	Modelica.Blocks.Logical.Or or1
		annotation(Placement(visible = true, transformation(extent = {{-116, 2}, {-108, 10}}, rotation = 0)));

	//Sun
	SolarTherm.Models.Sources.SolarModel.Sun sun(
		lon = data.lon,
		lat = data.lat,
		t_zone = data.t_zone,
		year = data.year,
		redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm)
		annotation(Placement(visible = true, transformation(extent = {{-92, 58}, {-72, 78}}, rotation = 0)));

	// Solar field
	SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatFieldWindSpeed heliostatsField(
		n_h = n_heliostat,
		lon = data.lon,
		lat = data.lat,
		ele_min(displayUnit = "deg") = ele_min,
		use_wind = use_wind,
		Wspd_max = Wspd_max,
		he_av = he_av_design,
		use_on = true,
		use_defocus = true,
		A_h = A_heliostat,
		nu_min = nu_min_sf,
		Q_design = R_des,
		nu_start = nu_start,
		angles = angles,
		opt_file1 = opt_file_wspd1,
		opt_file2 = opt_file_wspd2)
		annotation(Placement(visible = true, transformation(extent = {{-98, 2}, {-66, 36}}, rotation = 0)));

	// Receiver
	SolarTherm.Models.CSP.CRS.Receivers.SodiumReceiver_withOutput receiver(
		redeclare package Medium = Medium1,
		CL = CL,
		C4L = C4L,
		CH = CH,
		m_flow_rec = m_flow_rec,
		F_mult = F_mult,
		C_pip = C_pip,
		H_rcv = H_receiver,
		D_rcv = D_receiver,
		N_pa = N_pa_rec,
		t_tb = t_tb_rec,
		D_tb = D_tb_rec,
		ab = eff_ab,
		em = eff_em,
		T_in_0 = T_cold_set_Na,
		T_out_0 = T_hot_set_Na)
		annotation(Placement(visible = true, transformation(extent = {{-54, 4}, {-18, 40}}, rotation = 0)));

	// Temperature sensor1
	SolarTherm.Models.Fluid.Sensors.Temperature temperature1(
		redeclare package Medium = Medium1) 
		annotation(Placement(visible = true, transformation(origin = {-27, -19}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));

	// Pump cold1
	SolarTherm.Models.Fluid.Pumps.Pump_PressureLosses pumpSodium(
		redeclare package Medium = Medium1,
		k_loss = k_loss_cold_sodium)
		annotation(Placement(visible = true, transformation(extent = {{-10, -42}, {-22, -30}}, rotation = 0)));	

	//HX Control
	SolarTherm.Models.Control.HXControl hX_Control(
		T_ref_rec = T_hot_set_Na,
		L_df_on = cold_tnk_defocus_lb,
		L_df_off = cold_tnk_defocus_ub,
		L_off = cold_tnk_crit_lb,
		L_on = cold_tnk_crit_ub,
		T_ref_hs = T_hot_set_CS,
		m_flow_max_Na = m_flow_max_Na,
		m_flow_max_CS = m_flow_max_CS,
		m_flow_start_Na = m_flow_start_Na,
		m_flow_start_CS = m_flow_start_CS,
		Q_flow_rec = Q_hx_design)
		annotation(Placement(visible = true, transformation(origin = {40, -56}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));

	//HX
	SolarTherm.Models.Fluid.HeatExchangers.HX Shell_and_Tube_HX(
		replaceable package Medium1 = Medium1,
		replaceable package Medium2 = Medium2,
		T_Na2_input=T_Na2_input,
		Q_d_des = Q_hx_design,
		optimize_and_run=optimize_HX_design,
		material_sc = material_sc,
		d_o_input=d_o_input,
		N_p_input=N_p_input,
		layout_input=layout_input,
		ratio_cond=ratio_cond,
		ratio_max=ratio_max,
		L_max_cond=L_max_cond,
		L_max_input=L_max_input,
		N_t_input_on = N_t_input_on,
		N_t_input = N_t_input)
		annotation(Placement(visible = true, transformation(origin = {23, -1}, extent = {{21, -21}, {-21, 21}}, rotation = 90)));

	SolarTherm.Models.Storage.Tank.BufferTank SodiumBufferTank(
		replaceable package Medium = Medium1,
		T_start = T_cold_set_Na,
		D = 1,
		H = 1) annotation(
		Placement(visible = true, transformation(origin = {9, -33}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));

	// Hot tank
	SolarTherm.Models.Storage.Tank.Two_Tanks tankHot(
		redeclare package Medium = Medium2,
		D = D_storage,
		H = H_storage,
		n_parallel_tanks = 1,
		T_start = T_hot_start_CS,
		L_start = (1 - split_cold) * 100,
		alpha = alpha, use_p_top = tnk_use_p_top,
		enable_losses = tnk_enable_losses,
		use_L = true,
		W_max = W_heater_hot,
		T_set = T_hot_aux_set)
		annotation(Placement(visible = true, transformation(extent = {{48, 54}, {68, 74}}, rotation = 0)));

	// Pump hot
	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(
		redeclare package Medium = Medium2,
		k_loss = k_loss_hot)
		annotation(Placement(visible = true, transformation(extent = {{78, 42}, {90, 54}}, rotation = 0)));

	// Cold tank
	SolarTherm.Models.Storage.Tank.Two_Tanks tankCold(
		redeclare package Medium = Medium2,
		D = D_storage,
		H = H_storage,
		n_parallel_tanks = 1,
		T_start = T_cold_start_CS,
		L_start = split_cold * 100,
		alpha = alpha,
		use_p_top = tnk_use_p_top,
		enable_losses = tnk_enable_losses,
		use_L = true,
		W_max = W_heater_cold,
		T_set = T_cold_aux_set)
		annotation(Placement(visible = true, transformation(extent = {{98, -42}, {78, -22}}, rotation = 0)));

	// Pump cold 2NaS
	SolarTherm.Models.Fluid.Pumps.Pump_PressureLosses pumpCold2(
		redeclare package Medium = Medium2, 
		k_loss = k_loss_cold) 
		annotation(Placement(visible = true, transformation(extent = {{66, 8}, {54, 20}}, rotation = 0)));
	
	// Temperature sensor 2
	SolarTherm.Models.Fluid.Sensors.Temperature temperature2(
		redeclare package Medium = Medium2)
		annotation(Placement(visible = true, transformation(origin = {73, -1}, extent = {{5, 5}, {-5, -5}}, rotation = -90)));

	// PowerBlockControl
	SolarTherm.Models.Control.PowerBlockControl controlHot(
		m_flow_on = m_flow_blk,
		t_ramp_delay = t_ramping,
		L_on = hot_tnk_empty_ub,
		L_off = hot_tnk_empty_lb,
		L_df_on = hot_tnk_full_ub,
		L_df_off = hot_tnk_full_lb)
		annotation(Placement(visible = true, transformation(extent = {{98, 80}, {110, 66}}, rotation = 0)));

	// Power block
	SolarTherm.Models.PowerBlocks.SurrogatesCO2PB_OTF powerBlock(
		redeclare package MedRec = Medium2,
		P_gross = P_gross, 
		T_in_ref_blk = T_in_ref_blk, 
		p_high = p_high, 
		PR = -1, 
		pinch_PHX = -1, 
		dTemp_HTF_PHX = -1, 
		T_amb_base = blk_T_amb_des, 
		htf_choice = 50, 
		dT_PHX_hot_approach = 70.817253,//dT_PHX_hot_approach, 
		dT_PHX_cold_approach = 15.000000,//dT_PHX_cold_approach, 
		eta_isen_mc = eta_comp_main, 
		eta_isen_rc = eta_comp_re, 
		eta_isen_t = eta_turb, 
		dT_mc_approach = dT_mc_approach, 
		which_PB_model = 1, 
		load_base = 1, 
		eta_net_base = eta_net_base, 
		eta_Q_base = eta_Q_base, 
		Q_HX_des = Q_flow_des, 
		m_HTF_des = m_flow_blk, 
		base_path = base_path, 
		SolarTherm_path = SolarTherm_path, 
		inputsize = inputsize_PB, 
		outputsize = outputsize_PB, 
		tolerance_kriging = tolerance_kriging, 
		tolerance_ANN = tolerance_ANN, 
		which_surrogate = which_surrogate, 
		test_mode = false, 
		eta_motor = 1, 
		f_fixed_load = par_fix_fr, 
		external_parasities = external_parasities, 
		HTF_name=HTF_name) 
	annotation(Placement(visible = true, transformation(extent = {{102, 4}, {138, 42}}, rotation = 0)));

	// Price
	SolarTherm.Models.Analysis.Market market(
		redeclare model Price = Models.Analysis.EnergyPrice.Constant)
		annotation(Placement(visible = true, transformation(extent = {{140, 12}, {160, 32}}, rotation = 0)));

	// TODO Needs to be configured in instantiation if not const_dispatch. See SimpleResistiveStorage model

	SolarTherm.Models.Sources.Schedule.Scheduler sch if not const_dispatch;

	//Other Variables:

	SI.Power P_elec "Output power of power block";
	SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
	FI.Money_USD R_spot(start = 0, fixed = true) "Spot market revenue";

	Modelica.Blocks.Sources.BooleanExpression PB_ramping annotation(
		Placement(visible = true, transformation(origin = {128, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial equation

	//***NREL PB Design Point Initialisation
	NREL_PB_configurations = SolarTherm.Utilities.designNRELPB(
		P_gross,
		T_in_ref_blk,
		p_high,
		dT_PHX_cold_approach,
		eta_comp_main,
		eta_comp_re,
		eta_turb,
		dT_mc_approach,
		blk_T_amb_des,
		HTF_name,
		50,
		SolarTherm_path,
		T_cold_set_CS);

	Q_flow_des = NREL_PB_configurations[10] "Heat transfer of the PHX at the design point";
	eta_Q_base = NREL_PB_configurations[12];
	m_flow_blk = NREL_PB_configurations[9] "HTF mass flow rate at the design point";
	
	W_pump_pb = k_loss_hot*m_flow_blk;
	W_pump_rec = k_loss_cold_sodium*m_flow_rec + m_flow_rec*((Shell_and_Tube_HX.Dp_tube_design + receiver.dP_net_des)/((rho_hot_set_Na + rho_cold_set_Na) / 2)/eta_pump);
	W_pump_tk = k_loss_cold*m_flow_fac + m_flow_fac*(Shell_and_Tube_HX.Dp_shell_design/((rho_hot_set + rho_cold_set) / 2)/eta_pump);

	par_fr_des = (1/P_gross)*(W_base_blk + W_cooling_des + W_tracking + W_pump_pb + W_pump_rec + W_pump_tk);

equation
	//***Equation for Surrogate Power Block
	powerBlock.raw_input[1] = powerBlock.load;
	powerBlock.raw_input[2] = tankHot.medium.T;
	powerBlock.raw_input[3] = data.Tdry;

	if heliostatsField.Q_raw > heliostatsField.Q_start then
		Q_rec_out_des = heliostatsField.Q_dump_field*receiver.eta_rec;
	else
		Q_rec_out_des = heliostatsField.Q_dump_field;
	end if;

	if heliostatsField.defocus_internal and heliostatsField.on_internal then
		powerBlock.Q_HX = heliostatsField.Q_defocus*receiver.eta_rec;
	else
		Q_flow_des = heliostatsField.Q_defocus;
	end if;

	connect(Wspd_input.y, receiver.Wspd);
	connect(PressureLosses_CS_loop.y, pumpCold2.Dp_loss) annotation(
		Line(points = {{0, 62}, {38, 62}, {38, 4}, {60, 4}, {60, 8}, {60, 8}}, color = {0, 0, 127}));
	
	connect(PressureLosses_Na_loop.y, pumpSodium.Dp_loss) annotation(
		Line(points = {{-110, -40}, {-70, -40}, {-70, -48}, {-16, -48}, {-16, -42}, {-16, -42}}, color = {0, 0, 127}));
	
	connect(Tamb_input.y, powerBlock.T_amb) annotation(
		Line(points = {{157, 100}, {116, 100}, {116, 34}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	connect(parasities_input.y, powerBlock.parasities) annotation(
		Line(points = {{149, 50}, {149, 40.85}, {124, 40.85}, {124, 34}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
		Line(points = {{90, 48}, {102, 48}, {102, 30}, {112, 30}, {112, 30}, {112, 30}, {112, 30}}, color = {0, 127, 255}));

	connect(powerBlock.W_net, market.W_net) annotation(
		Line(points = {{129, 22}, {140, 22}}, color = {0, 0, 127}));

	connect(tankCold.fluid_a, powerBlock.fluid_b) annotation(
		Line(points = {{98, -27}, {104, -27}, {104, 14}, {110, 14}}, color = {0, 127, 255}));

	connect(temperature2.T, hX_Control.T_output_cs) annotation(
		Line(points = {{68, 0}, {58, 0}, {58, -72}, {44, -72}, {44, -66}, {44, -66}}, color = {0, 0, 127}));

	connect(temperature2.fluid_a, tankCold.fluid_b) annotation(
		Line(points = {{74, -6}, {74, -6}, {74, -40}, {78, -40}, {78, -38}}, color = {0, 127, 255}));

	connect(pumpCold2.fluid_a, temperature2.fluid_b) annotation(
		Line(points = {{66, 14}, {72, 14}, {72, 4}, {74, 4}}, color = {0, 127, 255}));

	connect(temperature1.T, hX_Control.T_input_rec) annotation(
		Line(points = {{-32, -18}, {-34, -18}, {-34, -80}, {50, -80}, {50, -68}, {50, -68}}, color = {0, 0, 127}));

	connect(receiver.fluid_a, temperature1.fluid_b) annotation(
		Line(points = {{-32, 6}, {-28, 6}, {-28, -14}, {-27, -14}}, color = {0, 127, 255}));

	connect(temperature1.fluid_a, pumpSodium.fluid_b) annotation(
		Line(points = {{-27, -24}, {-27, -36}, {-22, -36}}, color = {0, 127, 255}));

	connect(Shell_and_Tube_HX.port_b_out, tankHot.fluid_a) annotation(
		Line(points = {{14, 6}, {6, 6}, {6, 68}, {48, 68}, {48, 70}}, color = {0, 127, 255}));

	connect(Shell_and_Tube_HX.port_a_in, receiver.fluid_b) annotation(
		Line(points = {{18, 12}, {18, 12}, {18, 30}, {-30, 30}, {-30, 30}}, color = {0, 127, 255}));

	connect(receiver.Q_out, hX_Control.Q_out_rec) annotation(
		Line(points = {{-30, 18}, {-24, 18}, {-24, -72}, {64, -72}, {64, -56}, {52, -56}, {52, -56}}, color = {0, 0, 127}));

	connect(heliostatsField.on, receiver.on) annotation(
		Line(points = {{-82, 2}, {-82, -20}, {-44, -20}, {-44, 5}, {-39, 5}}, color = {255, 0, 255}));

	connect(heliostatsField.heat, receiver.heat) annotation(
		Line(points = {{-66, 27.5}, {-54.82, 27.5}, {-54.82, 27}, {-54, 27}}, color = {191, 0, 0}));

	connect(receiver.Tamb, tankHot.T_amb) annotation(
		Line(points = {{-36, 36}, {-36, 80}, {54, 80}, {54, 74}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	connect(pumpSodium.fluid_a, SodiumBufferTank.fluid_b) annotation(
		Line(points = {{-10, -36}, {-1, -36}, {-1, -36.5}, {4, -36.5}}, color = {0, 127, 255}));

	connect(hX_Control.m_flow_rec, pumpSodium.m_flow) annotation(
		Line(points = {{35, -44}, {34, -44}, {34, -22}, {-16, -22}, {-16, -31}}, color = {0, 0, 127}));

	connect(hX_Control.m_flow_hs, controlHot.m_flow_in) annotation(
		Line(points = {{44, -44}, {44, -44}, {44, -16}, {78, -16}, {78, 36}, {94, 36}, {94, 70}, {98, 70}, {98, 70}}, color = {0, 0, 127}));

	connect(hX_Control.m_flow_hs, pumpCold2.m_flow) annotation(
		Line(points = {{44, -44}, {44, -44}, {44, -16}, {78, -16}, {78, 26}, {60, 26}, {60, 20}, {60, 20}}, color = {0, 0, 127}));

	connect(Tamb_input.y, tankHot.T_amb) annotation(
		Line(points = {{157, 100}, {54, 100}, {54, 74}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	connect(Tamb_input.y, tankCold.T_amb) annotation(
		Line(points = {{157, 100}, {116, 100}, {116, 42}, {108, 42}, {108, 20}, {92, 20}, {92, -22}}, color = {0, 0, 127}));

	connect(Pres_input.y, tankHot.p_top) annotation(
		Line(points = {{119, -12}, {42, -12}, {42, 84}, {62, 84}, {62, 74}}, color = {0, 0, 127}));

	connect(Pres_input.y, tankCold.p_top) annotation(
		Line(points = {{119, -12}, {84, -12}, {84, -22}}, color = {0, 0, 127}));

	connect(Pres_input.y, SodiumBufferTank.p_top) annotation(
		Line(points = {{119, -12}, {42, -12}, {42, -26}, {7, -26}, {7, -28}}, color = {0, 0, 127}));

	//controlHot connections
	connect(controlHot.defocus, or1.u1) annotation(
		Line(points = {{104, 81}, {104, 86}, {-126, 86}, {-126, 6}, {-117, 6}}, color = {255, 0, 255}, pattern = LinePattern.Dash));

	connect(tankHot.L, controlHot.L_mea) annotation(
		Line(points = {{68, 68}, {72, 68}, {72, 76.5}, {98, 76.5}}, color = {0, 0, 127}));

	connect(controlHot.m_flow, pumpHot.m_flow) annotation(
		Line(points = {{111, 73}, {112, 73}, {112, 58}, {84, 58}, {84, 54}}, color = {0, 0, 127}));

	//connect(controlHot.PB_ramp_fraction, powerBlock.PB_ramp_fraction) annotation(Line(points = {{112, 76}, {120, 76}, {120, 45}, {105, 45}, {105, 22}, {112, 22}}, color = {0, 0, 127}));

	//Connections from data
	connect(Wspd_input.y, heliostatsField.Wspd) annotation(
		Line(points = {{-109, 30}, {-98, 30}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	connect(DNI_input.y, sun.dni) annotation(
		Line(points = {{-115, 68}, {-93, 68}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	//HX_control connections
	connect(hX_Control.L_mea, tankCold.L) annotation(
		Line(points = {{38, -66}, {38, -66}, {38, -74}, {70, -74}, {70, -28}, {78, -28}, {78, -28}}, color = {0, 0, 127}));

	connect(or1.u2, hX_Control.defocus) annotation(
		Line(points = {{-117, 3}, {-126, 3}, {-126, -54}, {27, -54}, {27, -56}}, color = {255, 0, 255}));

	connect(heliostatsField.on, hX_Control.sf_on) annotation(
		Line(points = {{-82, 2}, {-82, -20}, {-44, -20}, {-44, -74}, {34, -74}, {34, -67}, {33, -67}}, color = {255, 0, 255}));

	//Solar field connections i.e. solar.heat port and control
	connect(heliostatsField.on, Shell_and_Tube_HX.HF_on) annotation(
		Line(points = {{-82, 2}, {-82, -20}, {-44, -20}, {-44, -6}, {13, -6}}, color = {255, 0, 255}));

	connect(sun.solar, heliostatsField.solar) annotation(
		Line(points = {{-82, 58}, {-82, 36}}, color = {255, 128, 0}));

	connect(or1.y, heliostatsField.defocus) annotation(
		Line(points = {{-108, 6}, {-98, 6}, {-98, 9}}, color = {255, 0, 255}, pattern = LinePattern.Dash));

	//Fluid connections
	connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(
		Line(points = {{68, 58}, {72, 58}, {72, 48}, {78, 48}, {78, 48}}, color = {0, 127, 255}));

	connect(Shell_and_Tube_HX.port_a_out, SodiumBufferTank.fluid_a) annotation(
		Line(points = {{24, -14}, {24, -30.5}, {14, -30.5}}, color = {0, 127, 255}));

	connect(pumpCold2.fluid_b, Shell_and_Tube_HX.port_b_in) annotation(
		Line(points = {{54, 14}, {34, 14}, {34, -7}, {29, -7}}, color = {0, 127, 255}));

	connect(receiver.Q_out, Shell_and_Tube_HX.Q_out_rec) annotation(
		Line(points = {{-31, 18}, {-9, 18}, {-9, 0}, {12, 0}}, color = {0, 127, 255}));
	//PowerBlock connections
	P_elec = powerBlock.W_net*n_modules;
	E_elec = powerBlock.E_net*n_modules;
	R_spot = market.profit*n_modules;

	connect(PB_ramping.y, powerBlock.ramping) annotation(
		Line(points = {{140, 58}, {120, 58}, {120, 34}, {120, 34}}, color = {255, 0, 255}));
	annotation(
		Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 10, fontName = "CMU Serif"), Text(origin = {0, -18}, lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 10, fontName = "CMU Serif"), Text(origin = {-14, 50}, extent = {{-42, 0}, {-4, -12}}, textString = "Receiver", fontSize = 10, fontName = "CMU Serif"), Text(origin = {10, 0}, extent = {{-110, 4}, {-72, -16}}, textString = "Heliostats Field", fontSize = 10, fontName = "CMU Serif"), Text(origin = {-34, 14}, extent = {{-62, 76}, {-32, 66}}, textString = "Sun", fontSize = 10, fontName = "CMU Serif"), Text(origin = {28, 6}, extent = {{14, 46}, {48, 38}}, textString = "Hot Tank", fontSize = 10, fontName = "CMU Serif"), Text(origin = {44, -18}, extent = {{30, -24}, {62, -38}}, textString = "Cold Tank", fontSize = 10, fontName = "CMU Serif"), Text(origin = {22, 0}, extent = {{80, 12}, {116, -6}}, textString = "Power Block", fontSize = 10, fontName = "CMU Serif"), Text(origin = {4, 38}, extent = {{130, 6}, {160, -4}}, textString = "Market", fontSize = 10, fontName = "CMU Serif"), Text(origin = {30, -96}, extent = {{-6, 20}, {28, 2}}, textString = "HX Control", fontSize = 10, fontName = "CMU Serif"), Text(origin = {54, 38}, extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 10, fontName = "CMU Serif"), Text(origin = {14, -52}, extent = {{-146, -26}, {-106, -44}}, textString = "Data Source", fontSize = 10, fontName = "CMU Serif"), Text(origin = {48, 22}, extent = {{-52, 8}, {-4, -12}}, textString = "Heat Exchanger", fontSize = 10, fontName = "CMU Serif"), Text(origin = {-132, -44}, extent = {{124, 4}, {160, -4}}, textString = "Buffer Tank", fontSize = 10, fontName = "CMU Serif")}),
		Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
		experiment(StopTime = 3.1536e+7, 
		StartTime = 0, 
		Tolerance = 0.0001, 
		Interval = 300),
		__Dymola_experimentSetupOutput,
		Documentation(info = "<html>
	<p>
		<b>NaSaltsCO2System</b> models the system-level interactions of a CSP System using a Sodium Receiver and two-tank storage system using Chloride Salt.
	</p>
	</html>", revisions = "<html>
	<ul>
		<li><i>Jan 2020</i> by Salvatore Guccione:<br>
		Released first version.</li>
		<li><i>Feb 2020</i> by Armando Fontalvo:<br>
		Power block model updated to a sCO2 cycle using SAM/NREL data.</li>
		<li><i>Nov 2020</i> by Armando Fontalvo and Shuang Wang:<br>
		Receiver model modified to calculate convective and radiation losses based on the loss analysis method.
		<li><i>Dec 2020</i> by Armando Fontalvo and Philipe Gunawan:<br>
		Power block model updated to an on the fly surrogate sCO2 recompression Brayton power cycle model using Kriging interpolation method.</li>
	</ul>
	</html>"),
		__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end NaSaltsCO2System;
