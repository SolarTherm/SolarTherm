within examples;
model Sodium_MS_System "Medium temperature sodium-nitrate salt system"
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
	parameter Boolean match_sam = false "Configure to match SAM output";
	parameter Boolean fixed_field = false "true if the size of the solar field is fixed";

	replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph "Medium props for molten salt";

	replaceable package liquidSodium = SolarTherm.Media.Sodium.Sodium_pT "Medium props for liquid sodium";
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
	parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/case_H230_Sodium_290_565.motab");
	parameter Real metadata_list[23] = metadata(opt_file);
	parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";

	parameter Real SM = R_des*eta_rec/Q_flow_des "Solar multiple";
	parameter Real land_mult = 6.281845377885782 "Land area multiplier";

	parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
	parameter SI.Area A_heliostat = metadata_list[2] "Heliostat module reflective area";
	parameter Real he_av_design = 0.99 "Helisotats availability";

	parameter SI.Efficiency eff_opt = metadata_list[3] "Field optical efficiency at design point";
	parameter SI.Irradiance dni_des = 980 "DNI at design point";


	// Receiver
	parameter Integer N_pa_rec = 16 "Number of panels in receiver";
	parameter SI.Thickness t_tb_rec = 1.2e-3 "Receiver tube wall thickness";
	parameter SI.Diameter D_tb_rec = 34.8e-3 "Receiver tube outer diameter";

	parameter Real ar_rec = 4/7 "Height to diameter aspect ratio of receiver aperture"; //Based on NREL Gen3 SAM model v14.02.2020

	parameter SI.Efficiency ab_rec = 0.94 "Receiver coating absorptance";
	parameter SI.Efficiency em_rec = 0.88 "Receiver coating emissivity";

	parameter SI.RadiantPower R_des = he_av_design*dni_des*A_field*eff_opt "Input power to receiver at design point";
	parameter SI.Efficiency eta_rec = metadata_list[7] "Receiver efficiency at design";

	parameter Real rec_fr = 1 - metadata_list[7] "Receiver loss fraction of radiance at design point";
	parameter SI.Temperature rec_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter Real[4] CL = {metadata_list[8],metadata_list[9],metadata_list[10],metadata_list[11]};
	parameter Real[4] C4L = {metadata_list[12],metadata_list[13],metadata_list[14],metadata_list[15]};
	parameter Real[5] CH = {metadata_list[16],metadata_list[17],metadata_list[18],metadata_list[19],metadata_list[20]};

	parameter SI.Temperature T_hot_set_na = CV.from_degC(594) "Hot tank target temperature";
	parameter SI.Temperature T_cold_set_na = CV.from_degC(310) "Hot tank target temperature";

	// Storage
	parameter Real t_storage(unit = "h") = 12 "Hours of storage";

	parameter SI.Temperature T_cold_set = CV.from_degC(290) "Cold tank target temperature";
	parameter SI.Temperature T_hot_set = CV.from_degC(574) "Hot tank target temperature";

	parameter SI.Temperature T_cold_start = CV.from_degC(290) "Cold tank starting temperature";
	parameter SI.Temperature T_hot_start = CV.from_degC(574) "Hot tank starting temperature";

	parameter SI.Temperature T_cold_aux_set = CV.from_degC(280) "Cold tank auxiliary heater set-point temperature";
	parameter SI.Temperature T_hot_aux_set = CV.from_degC(500) "Hot tank auxiliary heater set-point temperature";

	parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
	parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold salt thermodynamic state at design";

	parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
	parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";

	parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";

	parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
	parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";

	parameter SI.CoefficientOfHeatTransfer alpha = 3 "Tank constant heat transfer coefficient with ambient";

	parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold pump parasitic power coefficient";
	parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot pump parasitic power coefficient";

	parameter SI.Power W_heater_hot = 30e6 "Hot tank heater capacity";
	parameter SI.Power W_heater_cold = 15e6 "Cold tank heater capacity";

	parameter Real tank_ar = 20/18.667 "storage aspect ratio";

	// Power block
	replaceable model Cycle = Models.PowerBlocks.Correlation.Rankine "Rankine cycle regression model";
	replaceable model Cooling = Models.PowerBlocks.Cooling.SAM "PB cooling model";

	parameter SI.Power P_gross = 111e6 "Power block gross rating at design point";

	parameter SI.Efficiency eff_blk = 0.3774 "Power block efficiency at design point";

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
	parameter SI.Temperature T_in_ref_blk = from_degC(574) "HTF inlet temperature to power block at design";
	parameter SI.Temperature T_out_ref_blk = from_degC(290) "HTF outlet temperature to power block at design";

	// Control
	parameter SI.Time t_ramping = 1800 "Power block startup delay";
	parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
	parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
	parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";

	parameter SI.HeatFlowRate Q_flow_defocus = (330/294.18)*Q_flow_des "Solar field thermal power at defocused state"; // This only works if const_dispatch=true. TODO for variable disptach Q_flow_defocus should be turned into an input variable to match the field production rate to the dispatch rate to the power block.

	parameter Real nu_start=0.6 "Minimum energy start-up fraction to start the receiver";
	parameter Real nu_min_sf=0.3 "Minimum turn-down energy fraction to stop the receiver";
	parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";

	parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real hot_tnk_empty_ub = 10 "Hot tank empty trigger upper bound"; // Level (above which) to start disptach

	parameter Real hot_tnk_full_lb = 123 "Hot tank full trigger lower bound";
	parameter Real hot_tnk_full_ub = 120 "Hot tank full trigger upper bound";

	parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound"; // Level (above which) to start disptach

	parameter Real cold_tnk_crit_lb = 0 "Cold tank critically empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound"; // Level (above which) to start disptach

	parameter Real Ti = 0.1 "Time constant for integral component of receiver control";
	parameter Real Kp = -1000 "Gain of proportional component in receiver control";

	// Calculated Parameters
	parameter SI.HeatFlowRate Q_rec_out = Q_flow_des * SM "Receiver thermal output at design point";

	parameter SI.HeatFlowRate Q_flow_des = P_gross/eff_blk "Heat to power block at design";

	parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";

	parameter SI.Area A_field = n_heliostat*A_heliostat "Heliostat field reflective area";
	parameter Integer n_heliostat = integer(metadata_list[1]) "Number of heliostats";

	parameter SI.Area A_receiver = Modelica.Constants.pi*D_receiver*H_receiver "Receiver aperture area";
	parameter SI.Diameter D_receiver = metadata_list[4] "Receiver diameter";
	parameter SI.Length H_receiver = metadata_list[5] "Receiver height";

	parameter SI.Area A_land = land_mult*A_field + 182108.7 "Land area";

	parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";  
	parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";

	parameter SI.Density rho_cold_set = Medium.density(state_cold_set) "Cold salt density at design";
	parameter SI.Density rho_hot_set = Medium.density(state_hot_set) "Hot salt density at design";

	parameter SI.Mass m_max = E_max/(h_hot_set - h_cold_set) "Max salt mass in tanks";
	parameter SI.Volume V_max = m_max/((rho_hot_set + rho_cold_set)/2) "Max salt volume in tanks";

	parameter SI.MassFlowRate m_flow_fac = SM*Q_flow_des/(h_hot_set - h_cold_set) "Mass flow rate to receiver at design point";
	parameter SI.MassFlowRate m_flow_rec_max = 1.13952693353 * m_flow_fac "Maximum mass flow rate to receiver";
	parameter SI.MassFlowRate m_flow_rec_start = 0.81394780966 * m_flow_fac "Initial or guess value of mass flow rate to receiver in the feedback controller";
	parameter SI.MassFlowRate m_flow_blk = Q_flow_des/(h_hot_set - h_cold_set) "Mass flow rate to power block at design point";

	parameter SI.Power P_net = (1 - par_fr)*P_gross "Power block net rating at design point";
	parameter SI.Power P_name = P_net "Nameplate rating of power block";

	parameter SI.Length H_storage = ceil(((4*V_max*(tank_ar^2))/(CN.pi))^(1/3)) "Storage tank height";
	parameter SI.Diameter D_storage = H_storage/tank_ar "Storage tank diameter";

	parameter SI.Length H_tower = metadata_list[6] "Tower height (ground to base of receiver)";
	parameter SI.Diameter D_tower = D_receiver "Tower diameter"; // That's a fair estimate. An accurate H-to-D correlation may be used.

	// Cost data in USD (default) or AUD
	parameter Real r_disc = 0.07 "Real discount rate";
	parameter Real r_i = 0.03 "Inflation rate";

	parameter Integer t_life = 27 "Lifetime of plant in years";
	parameter Integer t_cons = 3 "Years of construction";

	parameter Real r_cur = 0.71 "The currency rate from AUD to USD"; // Valid for 2019. See https://www.rba.gov.au/
	parameter Real f_Subs = 0 "Subsidies on initial investment costs";

	parameter FI.AreaPrice pri_field = if currency==Currency.USD then 180 else 180/r_cur "Field cost per design aperture area";
		// SAM 2018 cost data: 177*(603.1/525.4) in USD. Note that (603.1/525.4) is CEPCI index from 2007 to 2018
	parameter FI.AreaPrice pri_site = if currency==Currency.USD then 20 else 20/r_cur "Site improvements cost per area";
		// SAM 2018 cost data: 16
	parameter FI.EnergyPrice pri_storage = if currency==Currency.USD then 37 / (1e3 * 3600) else (37 / (1e3 * 3600))/r_cur "Storage cost per energy capacity";
		// SAM 2018 cost data: 22 / (1e3 * 3600)
	parameter FI.PowerPrice pri_block = if currency==Currency.USD then 1000 / 1e3 else 1000/r_cur "Power block cost per gross rated power";
		// SAM 2018 cost data: 1040
	parameter FI.PowerPrice pri_bop = if currency==Currency.USD then 350 / 1e3 else (350 / 1e3)/r_cur "Balance of plant cost per gross rated power";
		//SAM 2018 cost data: 290
	parameter FI.AreaPrice pri_land = if currency==Currency.USD then 10000 / 4046.86 else (10000 / 4046.86)/r_cur "Land cost per area";

	parameter Real pri_om_name(unit = "$/W/year") = if currency==Currency.USD then 56.715 / 1e3 else (56.715 / 1e3)/r_cur "Fixed O&M cost per nameplate per year";
		//SAM 2018 cost data: 66
	parameter Real pri_om_prod(unit = "$/J/year") = if currency==Currency.USD then 5.7320752 / (1e6 * 3600) else (5.7320752 / (1e6 * 3600))/r_cur "Variable O&M cost per production per year";
		//SAM 2018 cost data: 3.5

	parameter FI.Money C_field = pri_field * A_field "Field cost";
	parameter FI.Money C_site = pri_site * A_field "Site improvements cost";
	parameter FI.Money C_tower(fixed = false) "Tower cost";
	parameter FI.Money C_receiver = if currency==Currency.USD then 71708855 * (A_receiver / 879.8) ^ 0.7 else (71708855 * (A_receiver / 879.8) ^ 0.7)/r_cur "Receiver cost";
		// SAM 2018 cost data: 103e6 * (A_receiver / 1571) ^ 0.7
	parameter FI.Money C_storage = pri_storage * E_max "Storage cost";
	parameter FI.Money C_block = pri_block * P_gross "Power block cost";
	parameter FI.Money C_bop = pri_bop * P_gross "Balance of plant cost";

	parameter FI.Money C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop) "Direct capital cost subtotal";
		// i.e. purchased equipment costs
	parameter FI.Money C_contingency = 0.07 * C_cap_dir_sub "Contingency costs";
	parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
	parameter FI.Money C_EPC = 0.11 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
		// SAM 2018 cost data: 0.13
	parameter FI.Money C_land = pri_land * A_land "Land cost";
	parameter FI.Money C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";

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
			Placement(visible = true, transformation(origin = {-170, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	//DNI_input
	Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
		Placement(visible = true, transformation(extent = {{-180, 56}, {-160, 76}}, rotation = 0)));

	//Tamb_input
	Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
		Placement(visible = true, transformation(extent = {{194, 66}, {174, 86}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression T_amb_rec(y = data.Tdry) annotation(
		Placement(visible = true, transformation(origin = {-82, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression T_amb_tk(y = data.Tdry) annotation(
		Placement(visible = true, transformation(extent = {{120, 14}, {100, 34}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression T_amb_hot_tk(y = data.Tdry) annotation(
		Placement(visible = true, transformation(extent = {{120, 110}, {100, 130}}, rotation = 0)));

	//WindSpeed_input
	Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
		Placement(visible = true, transformation(origin = {-170, 25.54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	//pressure_input
	Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
		Placement(visible = true, transformation(extent = {{120, 90}, {100, 110}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression p_buffer(y = data.Pres) annotation(
		Placement(visible = true, transformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression p_cold_tk(y = data.Pres) annotation(
		Placement(visible = true, transformation(origin = {50, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	//parasitic inputs
	Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatField.W_loss + pumpHot.W_loss + pumpCold.W_loss + tankHot.W_loss + tankCold.W_loss) annotation(
		Placement(visible = true, transformation(origin = {181, 56}, extent = {{-13, 10}, {13, -10}}, rotation = 180)));

	//parasitic inputs
	Modelica.Blocks.Sources.RealExpression Q_rcv(y = receiver.Q_rec_out) annotation(
		Placement(visible = true, transformation(origin = {130, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	//parasitic inputs
	Modelica.Blocks.Sources.RealExpression T_in_cold(y = HX.T_c_in) annotation(
		Placement(visible = true, transformation(origin = {130, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	// Or block for defocusing
	Modelica.Blocks.Logical.Or or1 annotation(
		Placement(visible = true, transformation(extent = {{-144, 0}, {-136, 8}}, rotation = 0)));

	//Sun
	SolarTherm.Models.Sources.SolarModel.Sun sun(
		lon = data.lon,
		lat = data.lat,
		t_zone = data.t_zone,
		year = data.year,
		redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
			Placement(visible = true, transformation(extent = {{-122, 56}, {-102, 76}}, rotation = 0)));

	// Solar field
	SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatField(
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
		redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file)) annotation(
			Placement(visible = true, transformation(extent = {{-128, -2}, {-96, 32}}, rotation = 0)));

	// Receiver
	SolarTherm.Models.CSP.CRS.Receivers.SodiumReceiver receiver(
		em = em_rec,
		redeclare package Medium = liquidSodium,
		H_rcv = H_receiver,
		D_rcv = D_receiver,
		N_pa = N_pa_rec,
		t_tb = t_tb_rec,
		D_tb = D_tb_rec,
		ab = ab_rec,
		CL = CL,
		C4L = C4L,
		CH = CH) annotation(
			Placement(visible = true, transformation(extent = {{-82, 0}, {-46, 36}}, rotation = 0)));

	// Sodium/salt heat exchanger
	SolarTherm.Models.Fluid.HeatExchangers.SimpleHeatExchanger HX(
		redeclare package Medium_h = liquidSodium,
		redeclare package Medium_c = Medium,
		Q_flow_des = Q_rec_out,
		T_c_in_des = T_cold_set,
		T_c_out_des = T_hot_set,
		T_h_in_des = T_hot_set_na,
		T_h_out_des = T_cold_set_na) annotation(
			Placement(visible = true, transformation(origin = {1, 19}, extent = {{13, 13}, {-13, -13}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression T_in_hot(y = receiver.T) annotation(
		Placement(visible = true, transformation(origin = {130, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSodium(
		redeclare package Medium = liquidSodium,
		k_loss = k_loss_cold) annotation(
			Placement(visible = true, transformation(extent = {{-40, -36}, {-52, -24}}, rotation = 0)));

	SolarTherm.Models.Storage.Tank.BufferTank2 buffer(
		redeclare package Medium = liquidSodium,
		D = D_storage,
		H = H_storage,
		T_start = T_cold_set_na) annotation(
			Placement(visible = true, transformation(origin = {-25, -24}, extent = {{9, -8}, {-9, 8}}, rotation = 0)));

	// Hot tank
	SolarTherm.Models.Storage.Tank.Tank tankHot(
		redeclare package Medium = Medium,
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
			Placement(visible = true, transformation(extent = {{40, 64}, {60, 84}}, rotation = 0)));

	// Pump hot
	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(
		redeclare package Medium = Medium,
		k_loss = k_loss_hot) annotation(
			Placement(visible = true, transformation(extent = {{128, 34}, {140, 46}}, rotation = 0)));

	// Cold tank
	SolarTherm.Models.Storage.Tank.Tank tankCold(
		redeclare package Medium = Medium,
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
			Placement(visible = true, transformation(extent = {{92, -32}, {72, -12}}, rotation = 0)));

	// Pump cold
	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(
		redeclare package Medium = Medium,
		k_loss = k_loss_cold) annotation(
			Placement(visible = true, transformation(origin = {20, -29}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));

	// PowerBlockControl
	SolarTherm.Models.Control.PowerBlockControl controlHot(
		m_flow_on = m_flow_blk,
		L_on = hot_tnk_empty_ub,
		L_off = hot_tnk_empty_lb,
		L_df_on = hot_tnk_full_ub,
		L_df_off = hot_tnk_full_lb) annotation(
			Placement(visible = true, transformation(extent = {{94, 70}, {114, 50}}, rotation = 0)));

	// ReceiverControl
	SolarTherm.Models.Control.ReceiverControlDual controlCold(
		L_df_off = cold_tnk_defocus_ub,
		L_df_on = cold_tnk_defocus_lb,
		L_off = cold_tnk_crit_lb,
		L_on = cold_tnk_crit_ub,
		T_out_cold_set = T_hot_set,
		T_out_hot_set = T_hot_set_na,
		m_flow_max = m_flow_rec_max) annotation(
			Placement(visible = true, transformation(origin = {48, -8}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	// Power block
	SolarTherm.Models.PowerBlocks.PowerBlockModel powerBlock(
		W_des = P_gross,
		enable_losses = blk_enable_losses,
		redeclare model Cycle = Cycle(p_bo = p_blk),
		nu_min = nu_min_blk,
		external_parasities = external_parasities,
		W_base = W_base_blk,
		p_bo = p_blk,
		T_des = blk_T_amb_des,
		nu_net = nu_net_blk,
		T_in_ref = T_in_ref_blk,
		T_out_ref = T_out_ref_blk,
		Q_flow_ref = Q_flow_des,
		redeclare model Cooling = Cooling(T_des = blk_T_amb_des)) annotation(
			Placement(visible = true, transformation(extent = {{134, 0}, {170, 38}}, rotation = 0)));

	// Price
	SolarTherm.Models.Analysis.Market market(
		redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
			Placement(visible = true, transformation(extent = {{178, 8}, {198, 28}}, rotation = 0)));

	// TODO Needs to be configured in instantiation if not const_dispatch. See SimpleResistiveStorage model
	// SolarTherm.Models.Sources.Schedule.Scheduler sch if not const_dispatch;

	// Variables:
	SI.Power P_elec "Output power of power block";
	SI.Energy E_elec(start = 0, fixed = true, displayUnit="MW.h") "Generate electricity";
	FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";

initial equation
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
		Line(points = {{-159, 66}, {-142, 66}, {-142, 65.8}, {-122.6, 65.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(Wspd_input.y, heliostatField.Wspd) annotation(
		Line(points = {{-159, 25.54}, {-142.84, 25.54}, {-142.84, 26}, {-127, 26}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(Wspd_input.y, receiver.Wspd) annotation(
		Line(points = {{-159, 25.54}, {-139, 25.54}, {-139, 36}, {-67, 36}, {-67, 32}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(T_amb_rec.y, receiver.Tamb) annotation(
		Line(points = {{-71, 60}, {-64, 60}, {-64, 32}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(p_buffer.y, buffer.p_top) annotation(
		Line(points = {{-39, 70}, {-29, 70}, {-29, -16}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(p_cold_tk.y, tankCold.p_top) annotation(
		Line(points = {{61, 24}, {78, 24}, {78, -12}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(T_amb_tk.y, tankCold.T_amb) annotation(
		Line(points = {{99, 24}, {86, 24}, {86, -12}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(T_amb_hot_tk.y, tankHot.T_amb) annotation(
		Line(points = {{99, 120}, {46, 120}, {46, 84}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(Pres_input.y, tankHot.p_top) annotation(
		Line(points = {{99, 100}, {54.5, 100}, {54.5, 84}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	// Fluid connections
	connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(
		Line(points = {{60, 67}, {70, 67}, {70, 40}, {128, 40}}, color = {0, 127, 255}));
	connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
		Line(points = {{140, 40}, {144, 40}, {144, 25}}, color = {0, 127, 255}));
	connect(powerBlock.fluid_b, tankCold.fluid_a) annotation(
		Line(points = {{142, 11}, {92, 11}, {92, -17}}, color = {0, 127, 255}));
	connect(tankCold.fluid_b, pumpCold.fluid_a) annotation(
		Line(points = {{72, -29}, {26, -29}}, color = {0, 127, 255}));
	connect(pumpSodium.fluid_b, receiver.fluid_a) annotation(
		Line(points = {{-52, -30}, {-60, -30}, {-60, 2}}, color = {0, 127, 255}));
	connect(pumpSodium.fluid_a, buffer.fluid_b) annotation(
		Line(points = {{-40, -30}, {-34, -30}}, color = {0, 127, 255}));
	connect(receiver.fluid_b, HX.port_h_in) annotation(
		Line(points = {{-58, 26}, {-13, 26}}, color = {0, 127, 255}));
	connect(buffer.fluid_a, HX.port_h_out) annotation(
		Line(points = {{-16, -20}, {-13, -20}, {-13, 12}}, color = {0, 127, 255}));
	connect(pumpCold.fluid_b, HX.port_c_in) annotation(
		Line(points = {{14, -29}, {9, -29}, {9, 8}}, color = {0, 127, 255}));
	connect(HX.port_c_out, tankHot.fluid_a) annotation(
		Line(points = {{9, 30}, {9, 79}, {40, 79}}, color = {0, 127, 255}));

	// controlCold connections
	connect(controlCold.defocus, or1.u2) annotation(
		Line(points = {{48, -19}, {48, -60}, {-152, -60}, {-152, 1}, {-145, 1}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
	connect(controlCold.m_cold, pumpCold.m_flow) annotation(
		Line(points = {{37, -14}, {20, -14}, {20, -23}}, color = {0, 0, 127}));
	connect(controlCold.m_hot, pumpSodium.m_flow) annotation(
		Line(points = {{37, -2}, {-46, -2}, {-46, -25}}, color = {0, 0, 127}));
	connect(heliostatField.on, controlCold.sf_on) annotation(
		Line(points = {{-112, -2}, {-112, -40}, {63, -40}, {63, -16}, {59, -16}}, color = {255, 0, 255}));
	connect(tankCold.L, controlCold.L_mea) annotation(
		Line(points = {{72, -18}, {66, -18}, {66, -12}, {59, -12}}, color = {0, 0, 127}));
	connect(T_in_hot.y, controlCold.T_in_hot) annotation(
		Line(points = {{119, -70}, {100, -70}, {100, -8}, {59, -8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(T_in_cold.y, controlCold.T_in_cold) annotation(
		Line(points = {{119, -50}, {106, -50}, {106, -4}, {59, -4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(Q_rcv.y, controlCold.Q_rec_out) annotation(
		Line(points = {{119, -30}, {110, -30}, {110, 0}, {59, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	// controlHot connections
	connect(controlCold.m_cold, controlHot.m_flow_in) annotation(
		Line(points = {{37, -14}, {20, -14}, {20, 55}, {93, 55}}, color = {0, 0, 127}));
	connect(controlHot.m_flow, pumpHot.m_flow) annotation(
		Line(points = {{115, 60}, {134, 60}, {134, 45}}, color = {0, 0, 127}));
	connect(controlHot.defocus, or1.u1) annotation(
		Line(points = {{104, 71}, {104, 88.4}, {-152, 88.4}, {-152, 4}, {-145, 4}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
	connect(tankHot.L, controlHot.L_mea) annotation(
		Line(points = {{60, 78}, {85, 78}, {85, 65}, {93, 65}}, color = {0, 0, 127}));

	//Solar field connections i.e. solar.heat port and control
	connect(sun.solar, heliostatField.solar) annotation(
		Line(points = {{-112, 56}, {-112, 32}}, color = {255, 128, 0}));
	connect(heliostatField.heat, receiver.heat) annotation(
		Line(points = {{-95.68, 23.5}, {-94.5, 23.5}, {-94.5, 23}, {-81.68, 23}}, color = {191, 0, 0}));
	connect(or1.y, heliostatField.defocus) annotation(
		Line(points = {{-136, 4}, {-128, 4}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
	connect(heliostatField.on, receiver.on);

	//PowerBlock connections
	connect(parasities_input.y, powerBlock.parasities) annotation(
		Line(points = {{166.7, 56}, {156, 56}, {156, 30}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(powerBlock.W_net, market.W_net) annotation(
		Line(points = {{161, 18}, {178, 18}}, color = {0, 0, 127}));
	connect(Tamb_input.y, powerBlock.T_amb) annotation(
		Line(points = {{173, 76}, {148, 76}, {148, 30}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	P_elec = powerBlock.W_net;
	E_elec = powerBlock.E_net;
	R_spot = market.profit;

annotation(
		Diagram(coordinateSystem(extent = {{-200, -80}, {200, 140}}, initialScale = 0.1)),
		Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
		experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 1800),
		__Dymola_experimentSetupOutput,
		Documentation(revisions = "<html>
	<ul>
	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released first version. </li>
	</ul>

	</html>"));
end Sodium_MS_System;
