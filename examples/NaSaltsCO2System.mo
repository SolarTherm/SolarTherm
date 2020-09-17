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
	extends Modelica.Icons.Example;

	//Media
	replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
	replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";

	// Input Parameters
	parameter Boolean match_sam = false "Configure to match SAM output";
	parameter Boolean fixed_field = true "true if the size of the solar field is fixed";
	parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
	parameter Currency currency = Currency.USD "Currency used for cost analysis";
	parameter Boolean const_dispatch = true "Constant dispatch of energy";
	parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not const_dispatch "Discharging schedule from a file";

	// Please specify a value for P_gross or a value for R_des
	parameter SI.Power P_gross(fixed = if fixed_field then false else true, start = 111e6) "Power block gross rating at design point";

	// Weather data
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Daggett_Ca_TMY32.motab");
	parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";
	parameter nSI.Angle_deg lon = -116.78 "Longitude (+ve East)";
	parameter nSI.Angle_deg lat = 34.85 "Latitude (+ve North)";
	parameter nSI.Time_hour t_zone = -8 "Local time zone (UCT=0)";
	parameter Integer year = 2008 "Meteorological year";	

	// Field
	parameter SI.RadiantPower R_des(fixed = if fixed_field then true else false,start = CEFF[7]) "Input power to receiver at design point";
	parameter SI.Length H_tower = CEFF[8] "Tower height";
	parameter Integer n_heliostat = integer(CEFF[9]) "Number of heliostats";
	parameter SI.Diameter D_receiver = CEFF[10] "Receiver diameter";
	parameter SI.Length H_receiver = CEFF[11] "Receiver height";
	parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/gen3liq_175_MWth_100_m.motab");
	parameter Real rec_fr = CEFF[12] "Receiver loss fraction of radiance at design point"; //Calculated based on a receiver efficiency of 0.876456728
	parameter Real SM = CEFF[13] "Solar multiple"; //Calculated based on a receiver output of 543203279.460279 W, an a power block heat input of (111MWe/0.51)
	parameter Real[13] CEFF = {203.80782459,-81.60009499,10.80334245,-0.47220328,0.00036635,-0.00483532,186864546,100,5511,10,13,0.1433871,2.941837694};

	parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
	parameter Real land_mult = 6.16783860571 "Land area multiplier";
	parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
	parameter SI.Area A_heliostat = 7.07*7.07 "Heliostat module reflective area";
	parameter Real he_av_design = 0.99 "Heliostats availability";

	// Receiver
	parameter Integer N_pa_rec = 10 "Number of panels in receiver";
	parameter SI.Thickness t_tb_rec = 1.25e-3 "Receiver tube wall thickness";
	parameter SI.Diameter D_tb_rec = 40e-3 "Receiver tube outer diameter";
	parameter Real ar_rec = 24 / 16 "Height to diameter aspect ratio of receiver aperture";
	parameter SI.Efficiency ab_rec = 0.94 "Receiver coating absorptance";
	parameter SI.Efficiency em_rec = 0.88 "Receiver coating emissivity";
	parameter SI.Temperature rec_T_amb_des = 298.15 "Ambient temperature at design point";

	// HX
	parameter SI.Temperature T_cold_set_Na = CV.from_degC(520) "Cold HX target temperature";
	parameter SI.Temperature T_hot_set_Na = CV.from_degC(740) "Hot Receiver target temperature";
	parameter Medium1.ThermodynamicState state_cold_set_Na = Medium1.setState_pTX(Medium1.p_default, T_cold_set_Na) "Cold Sodium thermodynamic state at design";
	parameter Medium1.ThermodynamicState state_hot_set_Na = Medium1.setState_pTX(Medium1.p_default, T_hot_set_Na) "Hot Sodium thermodynamic state at design";
	parameter SI.Temperature T_cold_set_CS = CV.from_degC(500) "Cold tank target temperature";
	parameter SI.Temperature T_hot_set_CS = CV.from_degC(720) "Hot tank target temperature";
	parameter Medium2.ThermodynamicState state_cold_set_CS = Medium2.setState_pTX(Medium2.p_default, T_cold_set_CS) "Cold salt thermodynamic state at design";
	parameter Medium2.ThermodynamicState state_hot_set_CS = Medium2.setState_pTX(Medium2.p_default, T_hot_set_CS) "Hold salt thermodynamic state at design";
	parameter SI.Temperature T_Na2_input = T_cold_set_Na "Outlet sodium temperature";
	//Use ratio_cond to constrain the design of the HX: if "true" the HX will be forced to have L/D_s aspect ratio<ratio_max.
	parameter Boolean ratio_cond = true "Activate ratio constraint";  //Default value = true
	parameter Real ratio_max = 10 "Maximum L/D_s ratio"; //If ratio_cond = true provide a value (default value = 10)
	//Use it to constrain the design of the HX: if "true" the HX will be forced to have L<L_max.
	parameter Boolean L_max_cond = false "Activate maximum HX length constraint"; //Default value = false
	parameter SI.Length L_max_input = 1 "Maximum HX length"; //If L_max_cond = true provide a value (default value = 10)    
	//If optimize_HX_design is "true", d_o, N_p and layout will be chosen as results of the optimization, otherwise provide the following input values:
	parameter Boolean optimize_HX_design=true; 
	parameter SI.Length d_o_input = 0.00635 "User defined outer tube diameter";
	parameter Integer N_p_input = 1 "User defined tube passes number";
	parameter Integer layout_input = 2 "User defined tube layout";

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
	parameter SI.SpecificEnergy k_loss_cold1 = 0.21e3/*4.35807e3*/ "Cold tank parasitic power coefficient";
	parameter SI.Power W_heater_hot = 30e6 "Hot tank heater capacity";
	parameter SI.Power W_heater_cold = 15e6 "Cold tank heater capacity";
	parameter Real tank_ar = 9.2/60.1 "storage aspect ratio"; //Updated to obtain a height of 11

	// Power block
	replaceable model Cycle = Models.PowerBlocks.Correlation.sCO2 "sCO2 cycle regression model";
	parameter SI.Temperature T_comp_in = 318.15 "Compressor inlet temperature at design";
	replaceable model Cooling = Models.PowerBlocks.Cooling.DryCooling "PB cooling model";
	parameter SI.Efficiency eff_blk = 0.51 "Power block efficiency at design point";
	parameter Real par_fr = 0.099099099 "Parasitics fraction of power block rating at design point";
	parameter Real par_fix_fr = 0.0055 "Fixed parasitics as fraction of gross rating";
	parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";
	parameter Boolean external_parasities = true "true if there is external parasitic power losses";
	parameter Real nu_min_blk = 0.5 "minimum allowed part-load mass flow fraction to power block";
	parameter SI.Power W_base_blk = par_fix_fr * P_gross "Power consumed at all times in power block";
	parameter SI.AbsolutePressure p_blk = 10e6 "Power block operating pressure";
	parameter SI.Temperature blk_T_amb_des = 316.15 "Ambient temperature at design for power block";
	parameter SI.Temperature par_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
	parameter SI.Temperature T_in_ref_blk = from_degC(720) "HTF inlet temperature to power block at design";
	parameter SI.Temperature T_out_ref_blk = from_degC(500) "HTF outlet temperature to power block at design";

	// Control
	parameter SI.Time t_ramping = 1800 "Power block startup delay";
	parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
	parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
	parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
	parameter SI.HeatFlowRate Q_flow_defocus = 274 / 217.647 * Q_flow_des "Solar field thermal power at defocused state"; // This only works if const_dispatch=true. TODO for variable disptach Q_flow_defocus should be turned into an input variable to match the field production rate to the dispatch rate to the power block.
	parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
	parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
	parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
	parameter Real hot_tnk_empty_lb = 180/11 "Hot tank empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real hot_tnk_empty_ub = 20 "Hot tank empty trigger upper bound"; // Level (above which) to start disptach
	parameter Real hot_tnk_full_lb = 123 "Hot tank full trigger lower bound";
	parameter Real hot_tnk_full_ub = 120 "Hot tank full trigger upper bound";
	parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound"; // Level (above which) to start disptach
	parameter Real cold_tnk_crit_lb = 0 "Cold tank critically empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound"; // Level (above which) to start disptach

	//Storage Calculated parameters
	parameter SI.HeatFlowRate Q_flow_des = if fixed_field then (if match_sam then R_des / ((1 + rec_fr) * SM) else R_des * (1 - rec_fr) / SM ) else P_gross / eff_blk "Heat to power block at design";
	parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
	parameter SI.SpecificEnthalpy h_cold_set_CS = Medium2.specificEnthalpy(state_cold_set_CS) "Cold salt specific enthalpy at design";
	parameter SI.SpecificEnthalpy h_hot_set_CS = Medium2.specificEnthalpy(state_hot_set_CS) "Hot salt specific enthalpy at design";
	parameter SI.Density rho_cold_set = Medium2.density(state_cold_set_CS) "Cold salt density at design";
	parameter SI.Density rho_hot_set = Medium2.density(state_hot_set_CS) "Hot salt density at design";
	parameter SI.Mass m_max = E_max / (h_hot_set_CS - h_cold_set_CS) "Max salt mass in tanks";
	parameter SI.Volume V_max = m_max / ((rho_hot_set + rho_cold_set) / 2) "Max salt volume in tanks";
	parameter SI.MassFlowRate m_flow_fac = SM * Q_flow_des / (h_hot_set_CS - h_cold_set_CS) "Mass flow rate to receiver at design point";
	parameter SI.MassFlowRate m_flow_max_CS = 2 * m_flow_fac "Maximum mass flow rate to receiver";
	parameter SI.MassFlowRate m_flow_start_CS = m_flow_fac "Initial or guess value of mass flow rate to receiver in the feedback controller";
	parameter SI.Length tank_min_l = 1.8 "Storage tank fluid minimum height"; //Based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Length H_storage = (4*V_max*tank_ar^2/CN.pi)^(1/3) + tank_min_l "Storage tank height"; //Adjusted to obtain a height of 11 m for 12 hours of storage based on NREL Gen3 SAM model v14.02.2020
	parameter SI.Diameter D_storage = (0.5*V_max/(H_storage - tank_min_l)*4/CN.pi)^0.5 "Storage tank diameter"; //Adjusted to obtain a diameter of 60.1 m for 12 hours of storage based on NREL Gen3 SAM model v14.02.2020

	//Receiver Calculated parameters
	parameter SI.HeatFlowRate Q_rec_out = Q_flow_des * SM "Heat to HX at design";
	parameter SI.SpecificEnthalpy h_cold_set_Na = Medium1.specificEnthalpy(state_cold_set_Na) "Cold Sodium specific enthalpy at design";
	parameter SI.SpecificEnthalpy h_hot_set_Na = Medium1.specificEnthalpy(state_hot_set_Na) "Hot Sodium specific enthalpy at design";
	parameter SI.MassFlowRate m_flow_rec = Q_rec_out / (h_hot_set_Na - h_cold_set_Na) "Mass flow rate to receiver at design point";
	parameter SI.MassFlowRate m_flow_max_Na = 2 * m_flow_rec "Maximum mass flow rate to receiver";
	parameter SI.MassFlowRate m_flow_start_Na = m_flow_rec "Initial or guess value of mass flow rate to receiver in the feedback controller";

	//SF Calculated Parameters
	parameter SI.Area A_field = n_heliostat * A_heliostat "Heliostat field reflective area";
	parameter SI.Area A_receiver = CN.pi*D_receiver*H_receiver "Receiver aperture area";
	parameter SI.Area A_land = land_mult * A_field + 197434.207385281 "Land area";
	parameter SI.Diameter D_tower = D_receiver "Tower diameter"; // That's a fair estimate. An accurate H-to-D correlation may be used.

	//Power Block Control and Calculated parameters
	parameter SI.MassFlowRate m_flow_blk = Q_flow_des / (h_hot_set_CS - h_cold_set_CS) "Mass flow rate to power block at design point";
	parameter SI.Power P_net = (1 - par_fr) * P_gross "Power block net rating at design point";
	parameter SI.Power P_name = P_net "Nameplate rating of power block";

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
	parameter FI.Money_USD C_receiver_ref = 105073717.298199 "Receiver reference Cost";
	//Receiver reference cost updated to match estimated total cost of $87.34M for a receiver aperture area of 1206.37m2 (H=24m, H=16m)
	parameter SI.Area A_receiver_ref = 1571 "Receiver reference area"; //Receiver reference area set to 1751m2 based on SAM default

	// Calculated costs
	parameter FI.Money_USD C_piping = 23614200 "Piping cost including insulation"; //Updated based on Felix last spreadsheet
	parameter FI.Money_USD C_pumps = 0 "Cold Salt pumps"; //Updated based on Felix last spreadsheet
	parameter FI.Money_USD C_field = pri_field * A_field "Field cost";
	parameter FI.Money_USD C_site = pri_site * A_field "Site improvements cost";
	parameter FI.Money_USD C_tower(fixed = false) "Tower cost";
	parameter FI.Money_USD C_receiver = if currency == Currency.USD then C_receiver_ref * (A_receiver / A_receiver_ref) ^ 0.7 else C_receiver_ref * (A_receiver / A_receiver_ref) ^ 0.7 / r_cur "Receiver cost";
	parameter FI.Money_USD C_hx = Shell_and_Tube_HX.C_BEC_HX "Heat Exchanger cost";
	parameter FI.Money_USD C_storage = pri_storage * E_max "Storage cost";
	parameter FI.Money_USD C_block = pri_block * P_gross "Power block cost";
	parameter FI.Money_USD C_bop = pri_bop * P_gross "Balance of plant cost";
	parameter FI.Money_USD C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_hx + C_storage + C_block + C_bop + C_piping + C_pumps) "Direct capital cost subtotal"; // i.e. purchased equipment costs
	parameter FI.Money_USD C_contingency = 0.1 * C_cap_dir_sub "Contingency costs"; //Based on Downselect Criteria, Table 2
	parameter FI.Money_USD C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
	parameter FI.Money_USD C_EPC = 0.09 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs"; //Based on Downselect Criteria, Table 2
	parameter FI.Money_USD C_land = pri_land * A_land "Land cost";
	parameter FI.Money_USD C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
	parameter FI.MoneyPerYear C_year = pri_om_name * P_name "Fixed O&M cost per year";
	parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Variable O&M cost per production per year";

	// ***************************************************************************
	// System components

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
		y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold1.W_loss + pumpCold2.W_loss + tankHot.W_loss + tankCold.W_loss) 
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
	SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(
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
		Q_design = Q_flow_defocus,
		nu_start = nu_start,
		redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file))
		annotation(Placement(visible = true, transformation(extent = {{-98, 2}, {-66, 36}}, rotation = 0)));

	// Receiver
	SolarTherm.Models.CSP.CRS.Receivers.SodiumReceiver_withOutput receiver(
		redeclare package Medium = Medium1,
		C = CEFF[1:6],
		H_rcv = H_receiver,
		D_rcv = D_receiver,
		N_pa = N_pa_rec,
		t_tb = t_tb_rec,
		D_tb = D_tb_rec,
		ab = ab_rec,
		em = em_rec,
		T_in_0 = T_cold_set_Na,
		T_out_0 = T_hot_set_Na)
		annotation(Placement(visible = true, transformation(extent = {{-54, 4}, {-18, 40}}, rotation = 0)));

	// Temperature sensor1
	SolarTherm.Models.Fluid.Sensors.Temperature temperature1(
		redeclare package Medium = Medium1) 
		annotation(Placement(visible = true, transformation(origin = {-27, -19}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));

	// Pump cold1
	SolarTherm.Models.Fluid.Pumps.Pump_PressureLosses pumpCold1(
		redeclare package Medium = Medium1,
		k_loss = k_loss_cold1)
		annotation(Placement(visible = true, transformation(extent = {{-10, -42}, {-22, -30}}, rotation = 0)));
	
	//HX Control
	SolarTherm.Models.Control.HX_Control_new hX_Control(
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
		Q_flow_rec = Q_rec_out)
		annotation(Placement(visible = true, transformation(origin = {40, -56}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));

	//HX
	SolarTherm.Models.Fluid.HeatExchangers.HX Shell_and_Tube_HX(
		replaceable package Medium1 = Medium1,
		replaceable package Medium2 = Medium2,
		T_Na2_input=T_Na2_input,
		Q_d_des = Q_rec_out,
		optimize_and_run=optimize_HX_design,
		d_o_input=d_o_input,
		N_p_input=N_p_input,
		layout_input=layout_input,
		ratio_cond=ratio_cond,
		ratio_max=ratio_max,
		L_max_cond=L_max_cond,
		L_max_input=L_max_input,
		Q_flow_rec = Q_rec_out)
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
	SolarTherm.Models.PowerBlocks.sCO2CycleNREL powerBlock(/*SolarTherm.Models.PowerBlocks.PowerBlockModel powerBlock(*/
		redeclare package Medium = Medium2,
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
		Q_flow_ref = Q_flow_des)
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

initial equation

	if fixed_field then
		P_gross = Q_flow_des * eff_blk;
	else
		R_des = if match_sam then SM * Q_flow_des * (1 + rec_fr) else SM * Q_flow_des / (1 - rec_fr);
	end if;

	if H_tower > 120 then // then use concrete tower

		C_tower = if currency == Currency.USD then 7612816.32266742 * exp(0.0113 * H_tower) else 7612816.32266742 * exp(0.0113 * H_tower) / r_cur "Tower cost"; 
		//"Tower cost fixed" updated to match estimated total cost of $55M from analysis of tower costs based on Abengoa report

	else // use Latticework steel tower

		C_tower = if currency == Currency.USD then  80816 * exp(0.00879 * H_tower) else 80816 * exp(0.00879 * H_tower) / r_cur "Tower cost";
		//"Tower cost fixed" updated to match estimated total cost of $125k for a 50 m tower where EPC & Owner costs are 11% of Direct Costs

	end if;

equation
	connect(Wspd_input.y,receiver.Wspd);
	connect(PressureLosses_CS_loop.y, pumpCold2.Dp_loss) annotation(
		Line(points = {{0, 62}, {38, 62}, {38, 4}, {60, 4}, {60, 8}, {60, 8}}, color = {0, 0, 127}));
	
	connect(PressureLosses_Na_loop.y, pumpCold1.Dp_loss) annotation(
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

	connect(temperature1.fluid_a, pumpCold1.fluid_b) annotation(
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

	connect(pumpCold1.fluid_a, SodiumBufferTank.fluid_b) annotation(
		Line(points = {{-10, -36}, {-1, -36}, {-1, -36.5}, {4, -36.5}}, color = {0, 127, 255}));

	connect(hX_Control.m_flow_rec, pumpCold1.m_flow) annotation(
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

	connect(controlHot.PB_ramp_fraction, powerBlock.PB_ramp_fraction) annotation(
		Line(points = {{112, 76}, {120, 76}, {120, 45}, {105, 45}, {105, 22}, {112, 22}}, color = {0, 0, 127}));

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
	P_elec = powerBlock.W_net;
	E_elec = powerBlock.E_net;
	R_spot = market.profit;

	annotation(
		Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 10, fontName = "CMU Serif"), Text(origin = {0, -18}, lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 10, fontName = "CMU Serif"), Text(origin = {-14, 50}, extent = {{-42, 0}, {-4, -12}}, textString = "Receiver", fontSize = 10, fontName = "CMU Serif"), Text(origin = {10, 0}, extent = {{-110, 4}, {-72, -16}}, textString = "Heliostats Field", fontSize = 10, fontName = "CMU Serif"), Text(origin = {-34, 14}, extent = {{-62, 76}, {-32, 66}}, textString = "Sun", fontSize = 10, fontName = "CMU Serif"), Text(origin = {28, 6}, extent = {{14, 46}, {48, 38}}, textString = "Hot Tank", fontSize = 10, fontName = "CMU Serif"), Text(origin = {44, -18}, extent = {{30, -24}, {62, -38}}, textString = "Cold Tank", fontSize = 10, fontName = "CMU Serif"), Text(origin = {22, 0}, extent = {{80, 12}, {116, -6}}, textString = "Power Block", fontSize = 10, fontName = "CMU Serif"), Text(origin = {4, 38}, extent = {{130, 6}, {160, -4}}, textString = "Market", fontSize = 10, fontName = "CMU Serif"), Text(origin = {30, -96}, extent = {{-6, 20}, {28, 2}}, textString = "HX Control", fontSize = 10, fontName = "CMU Serif"), Text(origin = {54, 38}, extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 10, fontName = "CMU Serif"), Text(origin = {14, -52}, extent = {{-146, -26}, {-106, -44}}, textString = "Data Source", fontSize = 10, fontName = "CMU Serif"), Text(origin = {48, 22}, extent = {{-52, 8}, {-4, -12}}, textString = "Heat Exchanger", fontSize = 10, fontName = "CMU Serif"), Text(origin = {-132, -44}, extent = {{124, 4}, {160, -4}}, textString = "Buffer Tank", fontSize = 10, fontName = "CMU Serif")}),
		Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
		experiment(StopTime = 3.1536e+7, StartTime = 0, Tolerance = 0.0001, Interval = 300),
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
	</ul>
	</html>"),
		__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end NaSaltsCO2System;
