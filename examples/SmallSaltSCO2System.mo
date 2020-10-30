within examples;
model SmallSaltSCO2System "High temperature salt-sCO2 system"
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

	// Input Parameters
	// *********************
	parameter Real power_fr = 2 "Fraction of 100 MWe case: 2 (50 MWe), 4 (25 MWe), 10 (10 MWe), etc.";
	parameter Real tower_fr = 1.25 "Fraction of initial tower value: 1 (100%), 1.25 (125%), 1.5 (150%), etc.";
	parameter Boolean match_sam = false "Configure to match SAM output";
	parameter Boolean fixed_field = false "true if the size of the solar field is fixed";

	replaceable package Medium = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph "Medium props for molten salt";

	parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
	parameter Currency currency = Currency.USD "Currency used for cost analysis";

	parameter Boolean const_dispatch = true "Constant dispatch of energy";
	parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not const_dispatch "Discharging schedule from a file";

	// Weather data
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Daggett_Ca_TMY32.motab");
	parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";

	parameter nSI.Angle_deg lon = -116.780 "Longitude (+ve East)";
	parameter nSI.Angle_deg lat = 34.850 "Latitude (+ve North)";
	parameter nSI.Time_hour t_zone = -8 "Local time zone (UCT=0)";
	parameter Integer year = 2008 "Meteorological year";

	// Field
	parameter String opt_file = "/home/arfontalvo/solartherm/SolarTherm/Data/Optics/dominic/"+ String(integer(tower_fr*100)) + "TH" + String(ceil(P_gross/1e6*0.9)) + "SM" + String(SM*10) + ".motab";
	parameter Real metadata_list[8] = metadata(opt_file);
	parameter Integer n_heliostat = integer(metadata_list[1]) "Number of heliostats";
	parameter SI.Height H_tower = metadata_list[6] "Number of heliostats";
	parameter SI.Height D_receiver = metadata_list[5] "Number of heliostats";
	parameter SI.Height H_receiver = metadata_list[4] "Number of heliostats";
	parameter Solar_angles angles = Solar_angles.ele_azi "Angles used in the lookup table file";
	parameter Real SM = 2.9 "Solar multiple";
	parameter Real land_mult = 6.281845377885782 "Land area multiplier";
	parameter SI.Area land_non_solar = 182108.7 "Non-solar field land area"; //45 acre. Based on NREL Gen3 SAM model v14.02.2020
	parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
	parameter SI.Area A_heliostat = 144.375 "Heliostat module reflective area";
//	parameter SI.Area A_heliostat = 75.1689 "Heliostat module reflective area";
	parameter Real he_av_design = 0.99 "Heliostats availability";
	parameter SI.Efficiency eff_opt = (2.7*111e6/0.51)/(1 - rec_fr)/(he_av_design*A_heliostat*dni_des*8134) "Field optical efficiency at design point";
	parameter SI.Irradiance dni_des = 950 "DNI at design point";
	parameter Real C = 534.0 "Concentration ratio";
	parameter Real gnd_cvge = A_field / ((175/0.154)^2/twr_ht_const*CN.pi*excl_fac) "Ground coverage";
	parameter Real excl_fac = 0.97 "Exclusion factor";
	parameter Real twr_ht_const = if polar then 2.25 else 1.25 "Constant for tower height calculation";

	// Receiver
	parameter Integer N_pa_rec = 16 "Number of panels in receiver";
	parameter SI.Thickness t_tb_rec = 1.2e-3 "Receiver tube wall thickness";
	parameter SI.Diameter D_tb_rec = 34.8e-3 "Receiver tube outer diameter";
	parameter Real ar_rec = 4/7 "Height to diameter aspect ratio of receiver aperture"; //Based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Efficiency ab_rec = 0.98 "Receiver coating absorptance";
	parameter SI.Efficiency em_rec = 0.91 "Receiver coating emissivity";
	parameter SI.RadiantPower R_des(fixed= if fixed_field then true else false) "Input power to receiver at design point";
	parameter Real rec_fr = 0.208 "Receiver loss fraction of radiance at design point";
	parameter SI.Temperature rec_T_amb_des = 298.15 "Ambient temperature at design point";

	// Storage
	parameter Integer n_tanks_parallel = 1 "Number of parallel tank pairs";
	parameter Real t_storage(fixed=true, unit = "h") = 4.0 "Hours of storage"; //Based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Temperature T_cold_set = CV.from_degC(500) "Cold tank target temperature"; //Based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Temperature T_hot_set = CV.from_degC(720) "Hot tank target temperature"; //Based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Temperature T_cold_start = CV.from_degC(500) "Cold tank starting temperature"; //Based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Temperature T_hot_start = CV.from_degC(720) "Hot tank starting temperature"; //Based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Temperature T_cold_aux_set = CV.from_degC(450) "Cold tank auxiliary heater set-point temperature"; //Based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Temperature T_hot_aux_set = CV.from_degC(575) "Hot tank auxiliary heater set-point temperature"; //Based on NREL Gen3 SAM model v14.02.2020
	parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
	parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold salt thermodynamic state at design";
	parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
	parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
	parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
	parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
	parameter SI.CoefficientOfHeatTransfer alpha = 0.35 "Tank constant heat transfer coefficient with ambient";
	parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold tank parasitic power coefficient";
	parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot tank parasitic power coefficient";
	parameter SI.Power W_heater_hot = 30e6 "Hot tank heater capacity";
	parameter SI.Power W_heater_cold = 15e6 "Cold tank heater capacity";
	parameter Real tank_ar = 9.2/60.1 "storage aspect ratio";

	// Power block
	replaceable model Cycle = Models.PowerBlocks.Correlation.sCO2 "sCO2 cycle regression model";
	parameter SI.Temperature T_comp_in = 318.15 "Compressor inlet temperature at design";
	replaceable model Cooling = Models.PowerBlocks.Cooling.DryCooling "PB cooling model";
	parameter SI.Power P_gross(fixed = if fixed_field then false else true) = 111e6/power_fr "Power block gross rating at design point";
	parameter SI.Efficiency eff_blk = 0.51 "Power block efficiency at design point";
	parameter Real par_fr = 0.099099099 "Parasitics fraction of power block rating at design point";
	parameter Real par_fix_fr = 0.0055 "Fixed parasitics as fraction of gross rating";
	parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";
	parameter Boolean external_parasities = true "true if there is external parasitic power losses";
	parameter Real nu_min_blk = 0.5 "minimum allowed part-load mass flow fraction to power block";
	parameter SI.Power W_base_blk = par_fix_fr * P_gross "Power consumed at all times in power block";
	parameter SI.AbsolutePressure p_blk = 10e6 "Power block operating pressure";
	parameter SI.Temperature blk_T_amb_des = from_degC(35) "Ambient temperature at design for power block";
	parameter SI.Temperature par_T_amb_des = from_degC(25) "Ambient temperature at design point";
	parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
	parameter SI.Temperature T_in_ref_blk = from_degC(720) "HTF inlet temperature to power block at design"; //Based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Temperature T_out_ref_blk = from_degC(500) "HTF outlet temperature to power block at design";

	// Control
	parameter SI.Time t_ramping = 1800 "Power block startup delay";
	parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
	parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
	parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
	parameter Real max_rec_op_fr = 1.2 "Maximum receiver operation fraction";
	parameter Real nu_start = 0.25 "Minimum energy start-up fraction to start the receiver"; //Based on NREL SAM model from 14.02.2020
	parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
	parameter Real nu_defocus = 1/(1 - rec_fr)/SM "Energy fraction of the receiver design output at defocus state";// This only works if const_dispatch=true. TODO for variable disptach Q_flow_defocus should be turned into an input variable to match the field production rate to the dispatch rate to the power block.
//	parameter Real nu_start = 0.6*330/294.18/SM "Minimum energy start-up fraction to start the receiver"; //Based on NREL SAM model from 14.02.2020
//	parameter Real nu_min_sf = 0.3*330/294.18/SM "Minimum turn-down energy fraction to stop the receiver";
//	parameter Real nu_defocus = 330/294.18/SM "Energy fraction of the receiver design output at defocus state";// This only works if const_dispatch=true. TODO for variable disptach Q_flow_defocus should be turned into an input variable to match the field production rate to the dispatch rate to the power block.
	parameter Real hot_tnk_empty_lb = 16 "Hot tank empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real hot_tnk_empty_ub = 20 "Hot tank empty trigger upper bound"; // Level (above which) to start disptach
	parameter Real hot_tnk_full_lb = 123 "Hot tank full trigger lower bound (L_df_off) Level to stop defocus";
	parameter Real hot_tnk_full_ub = 120 "Hot tank full trigger upper bound (L_df_on) Level of start defocus";
	parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound"; // Level (above which) to start disptach
	parameter Real cold_tnk_crit_lb = 0 "Cold tank critically empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound"; // Level (above which) to start disptach

	parameter Real Ti = 0.1 "Time constant for integral component of receiver control";
	parameter Real Kp = -1000 "Gain of proportional component in receiver control";

	// Calculated Parameters
	parameter SI.HeatFlowRate Q_rec_out = Q_flow_des * SM "Receiver thermal output at design point";

	parameter SI.HeatFlowRate Q_flow_des =
		if fixed_field then (if match_sam then R_des/((1 + rec_fr)*SM) else R_des*(1 - rec_fr) / SM)
			else P_gross/eff_blk "Heat to power block at design";

	parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";

	parameter SI.Area A_field = (R_des/eff_opt/he_av_design)/dni_des "Heliostat field reflective area";
//	parameter Integer n_heliostat = integer(ceil(A_field/A_heliostat)) "Number of heliostats";

	parameter SI.Area A_receiver = A_field/C "Receiver aperture area";
//	parameter SI.Diameter D_receiver = sqrt(A_receiver/(CN.pi*ar_rec)) "Receiver diameter";
//	parameter SI.Length H_receiver = D_receiver*ar_rec "Receiver height";

	parameter SI.Area A_land = land_mult*A_field + land_non_solar "Land area";

	parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";  
	parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";

	parameter SI.Density rho_cold_set = Medium.density(state_cold_set) "Cold salt density at design";
	parameter SI.Density rho_hot_set = Medium.density(state_hot_set) "Hot salt density at design";

	parameter SI.Mass m_max = E_max/(h_hot_set - h_cold_set) "Max salt mass in tanks";
	parameter SI.Volume V_max = m_max/((rho_hot_set + rho_cold_set)/2) "Max salt volume in tanks";//Based on NREL Gen3 SAM model v14.02.2020

	parameter SI.MassFlowRate m_flow_fac = SM*Q_flow_des/(h_hot_set - h_cold_set) "Mass flow rate to receiver at design point";
	parameter SI.MassFlowRate m_flow_rec_max = max_rec_op_fr * m_flow_fac "Maximum mass flow rate to receiver";
	parameter SI.MassFlowRate m_flow_rec_start = 0.81394780966 * m_flow_fac "Initial or guess value of mass flow rate to receiver in the feedback controller";
	parameter SI.MassFlowRate m_flow_blk = Q_flow_des/(h_hot_set - h_cold_set) "Mass flow rate to power block at design point";

	parameter SI.Power P_net = (1 - par_fr)*P_gross "Power block net rating at design point";
	parameter SI.Power P_name = P_net "Nameplate rating of power block";

	parameter SI.Length tank_min_l = 1.8 "Storage tank fluid minimum height"; //Based on NREL Gen3 SAM model v14.02.2020
//	parameter SI.Length H_storage = (4*V_max*tank_ar^2/CN.pi)^(1/3) + tank_min_l "Storage tank height"; //Adjusted to obtain a height of 11 m for 12 hours of storage based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Length H_storage = 11 "Storage tank height"; //Based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Diameter D_storage = (V_max/n_tanks_parallel/(H_storage - tank_min_l)*4/CN.pi)^0.5 "Storage tank diameter"; //Adjusted to obtain a diameter of 42.5m for 12 hours of storage based on NREL Gen3 SAM model v14.02.2020

//	parameter SI.Length H_tower = 0.154*(sqrt(twr_ht_const*(A_field/(gnd_cvge*excl_fac))/CN.pi)) "Tower height"; // A_field/(gnd_cvge*excl_fac) is the field gross area
	parameter SI.Diameter D_tower = D_receiver "Tower diameter"; // That's a fair estimate. An accurate H-to-D correlation may be used.

	// Cost data in USD (default) or AUD
	parameter Real r_disc = 0.044 "Real discount rate"; //Calculated to obtain a nominal discount rate of 0.0701, based on Downselect Criteria, Table 2
	parameter Real r_i = 0.025 "Inflation rate"; //Based on Downselect Criteria, Table 2
	parameter Integer t_life(unit = "year") = 30 "Lifetime of plant"; //Based on Downselect Criteria, Table 2
	parameter Integer t_cons(unit = "year") = 0 "Years of construction"; //Based on Downselect Criteria, Table 2 it should be 3, but for LCOE simple calculation is set to 0
	parameter Real r_cur = 0.71 "The currency rate from AUD to USD"; // Valid for 2019. See https://www.rba.gov.au/
	parameter Real f_Subs = 0 "Subsidies on initial investment costs";
	parameter FI.AreaPrice pri_field = if currency == Currency.USD then 75 else 75 / r_cur "Field cost per design aperture area";
	//Field cost per area set to the target value based on DOE 2020 SunShot target, Table 5-1 (https://www.energy.gov/sites/prod/files/2014/01/f7/47927_chapter5.pdf)
	parameter FI.AreaPrice pri_site = if currency == Currency.USD then 10 else 10 / r_cur "Site improvements cost per area";
	//Site improvements cost per area set to the target value based on DOE 2020 SunShot target, Table 5-1 (https://www.energy.gov/sites/prod/files/2014/01/f7/47927_chapter5.pdf)
	parameter FI.EnergyPrice pri_storage = if currency == Currency.USD then 40 / (1e3 * 3600) else 40 / (1e3 * 3600) / r_cur "Storage cost per energy capacity";
	//Storage cost per energy capacity $40/kWht estimate from Devon. The based on DOE 2020 SunShot target is $15/kWht (Table 5-1, https://www.energy.gov/sites/prod/files/2014/01/f7/47927_chapter5.pdf)
	parameter FI.PowerPrice pri_block = if currency == Currency.USD then 900 / 1e3 else 900 / r_cur "Power block cost per gross rated power";
	//Power block cost should be $600/kWe + Primary HX based on Downselection Criteria, page 8, paragraph 7. NREL uses $900/kWe for now to account for PHX.
	parameter FI.PowerPrice pri_bop = if currency == Currency.USD then 0*350 / 1e3 else 0*350 / 1e3 / r_cur "Balance of plant cost per gross rated power";
	// Balance of plant set to 350 based on SAM 2018 default costing data
	parameter FI.AreaPrice pri_land = if currency == Currency.USD then 10000 / 4046.86 else 10000 / 4046.86 / r_cur "Land cost per area";
	//Land cost set to $10k/acre based on Downselect Criteria, Table 2
	parameter Real pri_om_name(unit = "$/W/year") = if currency == Currency.USD then 40 / 1e3 else 40 / 1e3 / r_cur "Fixed O&M cost per nameplate per year";
	//Fixed O&M Costs set to the target value based on Downselect Criteria, Table 2
	parameter Real pri_om_prod(unit = "$/J/year") = if currency == Currency.USD then 3 / (1e6 * 3600) else 3 / (1e6 * 3600) / r_cur "Variable O&M cost per production per year";
	//Variable O&M Costs set to the target value based on Downselect Criteria, Table 2
	parameter FI.Money_USD C_receiver_ref = 119353799.788672 "Receiver reference Cost";
	//Receiver reference cost updated to match estimated total cost of $152.9M for a receiver aperture area of 2199.11m2 (H=20m, D=35m)
	parameter SI.Area A_receiver_ref = 1571 "Receiver reference area"; //Receiver reference area set to 1751m2 based on SAM default


	// Calculated costs
	parameter FI.Money_USD C_piping =  0 "Piping cost (Riser/Downcomer) including insulation"; //Based on Chad's last spreadsheet
	parameter FI.Money_USD C_pumps = 0 "Cold Salt pumps"; //Based on Chad's last spreadsheet
	parameter FI.Money_USD C_field = pri_field * A_field "Field cost";
	parameter FI.Money_USD C_site = pri_site * A_field "Site improvements cost";
	parameter FI.Money_USD C_tower(fixed = false) "Tower cost";
	parameter FI.Money_USD C_receiver = if currency == Currency.USD then C_receiver_ref * (A_receiver / A_receiver_ref) ^ 0.7 else C_receiver_ref * (A_receiver / A_receiver_ref) ^ 0.7 / r_cur "Receiver cost";
	parameter FI.Money_USD C_storage = pri_storage * E_max "Storage cost";
	parameter FI.Money_USD C_block = pri_block * P_gross "Power block cost";
	parameter FI.Money_USD C_bop = pri_bop * P_gross "Balance of plant cost";
	parameter FI.Money_USD C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop + C_piping + C_pumps) "Direct capital cost subtotal"; // i.e. purchased equipment costs
	parameter FI.Money_USD C_contingency = 0.1 * C_cap_dir_sub "Contingency costs"; //Based on Downselect Criteria, Table 2
	parameter FI.Money_USD C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
	parameter FI.Money_USD C_EPC = 0.09 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs"; //Based on Downselect Criteria, Table 2
	parameter FI.Money_USD C_land = pri_land * A_land "Land cost";
	parameter FI.Money_USD C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
	parameter FI.MoneyPerYear C_year = pri_om_name * P_name "Fixed O&M cost per year";
	parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Variable O&M cost per production per year";

	// System components
	// *********************

	//Weather data
	SolarTherm.Models.Sources.DataTable.DataTable data(
		lon = lon,
		lat = lat,
		t_zone = t_zone,
		year = year,
		file = wea_file) annotation(
											Placement(visible = true, transformation(extent = {{-132, -56}, {-102, -28}}, rotation = 0)));

	//DNI_input
	Modelica.Blocks.Sources.RealExpression DNI_input(
		y = data.DNI) annotation(
									Placement(transformation(extent = {{-140, 60}, {-120, 80}})));

	//Tamb_input
	Modelica.Blocks.Sources.RealExpression Tamb_input(
		y = data.Tdry) annotation(
									Placement(transformation(extent = {{140, 70}, {120, 90}})));

	//WindSpeed_input
	Modelica.Blocks.Sources.RealExpression Wspd_input(
		y = data.Wspd) annotation(
									Placement(transformation(extent = {{-140, 20}, {-114, 40}})));

	//pressure_input
	Modelica.Blocks.Sources.RealExpression Pres_input(
		y = data.Pres) annotation(
									Placement(transformation(extent = {{76, 18}, {56, 38}})));

	//parasitic inputs
	Modelica.Blocks.Sources.RealExpression parasities_input(
		y = heliostatsField.W_loss + pumpHot.W_loss + tankHot.W_loss + tankCold.W_loss + receiver.W_dot_pump + controlHot.W_loss) annotation(
																														Placement(transformation(extent = {{-13, -10}, {13, 10}}, rotation = -90, origin = {109, 60})));

	// Or block for defocusing
	Modelica.Blocks.Logical.Or or1 annotation(
												Placement(transformation(extent = {{-102, 4}, {-94, 12}})));

	//Sun
	SolarTherm.Models.Sources.SolarModel.Sun sun(
		lon = data.lon,
		lat = data.lat,
		t_zone = data.t_zone,
		year = data.year,
		redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
																										Placement(transformation(extent = {{-82, 60}, {-62, 80}})));

	// Solar field
//	SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(
	SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsFieldSAM heliostatsField(
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
		nu_defocus = nu_defocus,
		nu_min = nu_min_sf,
		nu_start = nu_start,
		Q_design = Q_rec_out,
		redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file)) annotation(
																																									Placement(transformation(extent = {{-88, 2}, {-56, 36}})));

	// Receiver
	SolarTherm.Models.CSP.CRS.Receivers.ChlorideSaltReceiver receiver(
		redeclare package Medium = Medium,
		em = em_rec,
		H_rcv = H_receiver,
		D_rcv = D_receiver,
		H_tower = H_tower,
		R_des = R_des,
		N_pa = N_pa_rec,
		t_tb = t_tb_rec,
		D_tb = D_tb_rec,
		ab = ab_rec,
		m_flow_rec_des = m_flow_fac,
		const_alpha = true) annotation(
								Placement(transformation(extent = {{-46, 4}, {-10, 40}})));

	// Hot tank
	SolarTherm.Models.Storage.Tank.Two_Tanks tankHot(
		redeclare package Medium = Medium,
		n_parallel_tanks = n_tanks_parallel,
		D = D_storage,
		H = H_storage,
		T_start = T_hot_start,
		L_start = (1 - split_cold)*100,
		alpha = alpha,
		use_p_top = tnk_use_p_top,
		enable_losses = tnk_enable_losses,
		use_L = true,
		W_max = W_heater_hot,
		T_set = T_hot_aux_set) annotation(
												Placement(transformation(extent = {{16, 54}, {36, 74}})));

	// Pump hot
	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(
		redeclare package Medium = Medium,
		k_loss = k_loss_hot) annotation(
																				Placement(transformation(extent = {{66, 38}, {78, 50}})));

	// Cold tank
	SolarTherm.Models.Storage.Tank.Two_Tanks tankCold(
		redeclare package Medium = Medium,
		n_parallel_tanks = n_tanks_parallel,
		D = D_storage,
		H = H_storage,
		T_start = T_cold_start,
		L_start = split_cold*100,
		alpha = alpha,
		use_p_top = tnk_use_p_top,
		enable_losses = tnk_enable_losses,
		use_L = true,
		W_max = W_heater_cold,
		T_set = T_cold_aux_set) annotation(
												Placement(transformation(extent = {{64, -28}, {44, -8}})));

	// Pump cold
	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(
		redeclare package Medium = Medium,
		k_loss = k_loss_cold) annotation(
										Placement(transformation(extent = {{10, -30}, {-2, -18}})));

	// PowerBlockControl
	SolarTherm.Models.Control.PowerBlockControl controlHot(
		k_loss = k_loss_hot,
		t_ramp_delay = t_ramping,
		m_flow_on = 0.982*m_flow_blk,
		L_on = hot_tnk_empty_ub,
		L_off = hot_tnk_empty_lb,
		L_df_on = hot_tnk_full_ub,
		L_df_off = hot_tnk_full_lb) annotation(
																								Placement(transformation(extent = {{48, 72}, {60, 58}})));

	// ReceiverControl
	SolarTherm.Models.Control.ReceiverControl controlCold(
		T_ref = T_hot_set,
		m_flow_max = m_flow_rec_max,
		y_start = m_flow_rec_start,
		L_df_on = cold_tnk_defocus_lb,
		L_df_off = cold_tnk_defocus_ub,
		L_off = cold_tnk_crit_lb,
		L_on = cold_tnk_crit_ub,
		Ti = Ti,
		Kp = Kp) annotation(
									Placement(transformation(extent = {{24, -10}, {10, 4}})));

	// Power block
	SolarTherm.Models.PowerBlocks.sCO2CycleNREL powerBlock(
		redeclare package Medium = Medium,
		W_des = P_gross,
		enable_losses = blk_enable_losses,
		nu_min = nu_min_blk,
		external_parasities = external_parasities,
		W_base = W_base_blk,
		p_bo = p_blk,
		T_des = blk_T_amb_des,
		nu_net = nu_net_blk,
		T_in_ref = T_in_ref_blk,
		T_out_ref = T_out_ref_blk,
		Q_flow_ref = Q_flow_des) annotation(
										Placement(transformation(extent = {{88, 4}, {124, 42}})));

	// Price
	SolarTherm.Models.Analysis.Market market(
		redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
																					Placement(visible = true, transformation(extent = {{128, 12}, {148, 32}}, rotation = 0)));

	// TODO Needs to be configured in instantiation if not const_dispatch. See SimpleResistiveStorage model
	SolarTherm.Models.Sources.Schedule.Scheduler sch if not const_dispatch;

	// Variables:
	SI.Power P_elec "Output power of power block";
	SI.Energy E_elec(start = 0, fixed = true, displayUnit="MW.h") "Generate electricity";
	FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";

initial equation
	if fixed_field then
		P_gross = Q_flow_des * eff_cyc;
	else
		R_des = if match_sam then SM*Q_flow_des*(1 + rec_fr) else SM*Q_flow_des/(1 - rec_fr);
	end if;

	if H_tower > 120 then // then use concrete tower

		C_tower = if currency == Currency.USD then 7612816.32266742 * exp(0.0113 * H_tower) else 7612816.32266742 * exp(0.0113 * H_tower) / r_cur "Tower cost"; 
		//"Tower cost fixed" updated to match estimated total cost of $55M from analysis of tower costs based on Abengoa report

	else // use Latticework steel tower

		C_tower = if currency == Currency.USD then  80816 * exp(0.00879 * H_tower) else 80816 * exp(0.00879 * H_tower) / r_cur "Tower cost";
		//"Tower cost fixed" updated to match estimated total cost of $125k for a 50 m tower where EPC & Owner costs are 11% of Direct Costs

	end if;

	equation
	//Connections from data
	connect(DNI_input.y, sun.dni) annotation(
												Line(points = {{-119, 70}, {-102, 70}, {-102, 69.8}, {-82.6, 69.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(Wspd_input.y, heliostatsField.Wspd) annotation(
																Line(points = {{-112.7, 30}, {-100, 30}, {-100, 29.54}, {-87.68, 29.54}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(Pres_input.y, tankCold.p_top) annotation(
														Line(points = {{55, 28}, {49.5, 28}, {49.5, 20}, {49.5, -8.3}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(Pres_input.y, tankHot.p_top) annotation(
														Line(points = {{55, 28}, {46, 28}, {8, 28}, {8, 78}, {30.5, 78}, {30.5, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(Tamb_input.y, powerBlock.T_amb) annotation(
															Line(points = {{119, 80}, {102.4, 80}, {102.4, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(Tamb_input.y, tankHot.T_amb) annotation(
														Line(points = {{119, 80}, {68, 80}, {21.9, 80}, {21.9, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(receiver.Tamb, tankHot.T_amb) annotation(
														Line(points = {{-28, 36.04}, {-28, 80}, {21.9, 80}, {21.9, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(tankCold.T_amb, powerBlock.T_amb) annotation(
															Line(points = {{58.1, -8.3}, {58.1, 20}, {90, 20}, {92, 20}, {92, 42}, {102.4, 42}, {102.4, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	// Fluid connections
	connect(pumpCold.fluid_a, tankCold.fluid_b) annotation(
																Line(points = {{10, -24.12}, {10, -24.12}, {10, -25}, {44, -25}}, color = {0, 127, 255}));
	connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
																Line(points = {{-24.4, 5.8}, {-14.2, 5.8}, {-14.2, -24}, {-2, -24}}, color = {0, 127, 255}));
	connect(receiver.fluid_b, tankHot.fluid_a) annotation(
																	Line(points = {{-21.88, 30.64}, {-21.88, 30}, {-20, 30}, {-16, 30}, {-16, 69}, {16, 69}}, color = {0, 127, 255}));
	connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(
															Line(points = {{36, 57}, {36, 52}, {36, 44}, {48, 44}, {48, 43.88}, {66, 43.88}}, color = {0, 127, 255}));
	connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
																Line(points = {{78, 44}, {86, 44}, {86, 29.46}, {98.08, 29.46}}, color = {0, 127, 255}));
	connect(powerBlock.fluid_b, tankCold.fluid_a) annotation(
																Line(points = {{95.56, 14.64}, {78, 14.64}, {78, -13}, {64, -13}}, color = {0, 127, 255}));

	// controlCold connections
	connect(receiver.T, controlCold.T_mea) annotation(
															Line(points = {{-22, 18}, {32, 18}, {32, 1.25}, {24, 1.25}, {24, 1.25}}, color = {0, 0, 127}));
	connect(tankCold.L, controlCold.L_mea) annotation(
															Line(points = {{24.56, -3}, {38, -3}, {38, -13.6}, {43.8, -13.6}}, color = {0, 0, 127}));
	connect(heliostatsField.on, controlCold.sf_on) annotation(
																	Line(points = {{-72, 2}, {-72, 2}, {-72, -36}, {28, -36}, {28, -6}, {24.7, -6}, {24.7, -7.2}}, color = {255, 0, 255}));
	connect(controlCold.m_flow, pumpCold.m_flow) annotation(
																Line(points = {{9.16, -3}, {4, -3}, {4, -18.84}}, color = {0, 0, 127}));
	connect(controlCold.defocus, or1.u2) annotation(
														Line(points = {{17, -10.98}, {17, -32}, {-106, -32}, {-106, 4.8}, {-102.8, 4.8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
	// controlHot connections
	connect(tankHot.L, controlHot.L_mea) annotation(
														Line(points = {{36.2, 68.4}, {40, 68.4}, {40, 68.5}, {47.52, 68.5}}, color = {0, 0, 127}));
	connect(pumpCold.m_flow, controlHot.m_flow_in) annotation(
																	Line(points = {{47.52, 61.5}, {39.52, 61.5}, {39.52, 30}, {4, 30}, {4, -18.84}}, color = {0, 0, 127}));
	connect(controlHot.m_flow, pumpHot.m_flow) annotation(
																Line(points = {{60.72, 65}, {72, 65}, {72, 49.16}}, color = {0, 0, 127}));
	connect(controlHot.PB_ramp_fraction, powerBlock.PB_ramp_fraction) annotation(
																Line(points = {{60, 68}, {96, 68}, {96, 22}, {96, 22}}, color = {0, 0, 127}));
	connect(controlHot.defocus, or1.u1) annotation(
														Line(points = {{54, 72.98}, {54, 72.98}, {54, 86}, {-106, 86}, {-106, 8}, {-102.8, 8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));

	//Solar field connections i.e. solar.heat port and control
	connect(sun.solar, heliostatsField.solar) annotation(
															Line(points = {{-72, 60}, {-72, 36}}, color = {255, 128, 0}));
	connect(heliostatsField.heat, receiver.heat) annotation(
																Line(points = {{-55.68, 27.5}, {-54.82, 27.5}, {-54.82, 27.4}, {-46, 27.4}}, color = {191, 0, 0}));
	connect(or1.y, heliostatsField.defocus) annotation(
															Line(points = {{-93.6, 8}, {-92, 8}, {-92, 8.8}, {-87.68, 8.8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));

	//PowerBlock connections
	connect(parasities_input.y, powerBlock.parasities) annotation(
																		Line(points = {{109, 45.7}, {109, 40.85}, {109.6, 40.85}, {109.6, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(powerBlock.W_net, market.W_net) annotation(
															Line(points = {{115.18, 22.05}, {119.59, 22.05}, {119.59, 22}, {128, 22}}, color = {0, 0, 127}));

	connect(heliostatsField.on, receiver.on) annotation(
		Line(points = {{-82, 2}, {-82, -20}, {-44, -20}, {-44, 5}, {-39, 5}}, color = {255, 0, 255}));

	P_elec = powerBlock.W_net;
	E_elec = powerBlock.E_net;
	R_spot = market.profit;

	annotation(
	Diagram(
		coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1),
		graphics = {
			Text(lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 9),
			Text(lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 9),
			Text(origin = {2, 2}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"),
			Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"),
			Text(origin = {4, -8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"),
			Text(origin = {-4, 2}, extent = {{0, 58}, {48, 38}}, textString = "Hot Tank", fontSize = 6, fontName = "CMU Serif"),
			Text(extent = {{30, -24}, {78, -44}}, textString = "Cold Tank", fontSize = 6, fontName = "CMU Serif"),
			Text(origin = {4, -2}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"),
			Text(origin = {6, 0}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"),
			Text(origin = {2, 4}, extent = {{-6, 20}, {42, 0}}, textString = "Receiver Control", fontSize = 6, fontName = "CMU Serif"),
			Text(origin = {2, 32}, extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 6, fontName = "CMU Serif"),
			Text(origin = {8, -26}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif")}),
	Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
	experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 300),
	__Dymola_experimentSetupOutput,
	Documentation(revisions = "<html>
	<ul>
	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released first version. </li>
	</ul>
	</html>"));
end SmallSaltSCO2System;
