within examples;
model SaltSCO2System "High temperature salt-sCO2 system"
	import SolarTherm.{Models,Media};
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import Modelica.Constants.*;
	import Modelica.SIunits.Conversions.*;
	import FI = SolarTherm.Models.Analysis.Finances;
	import SolarTherm.Types.Solar_angles;
	import SolarTherm.Types.Currency;
	import Modelica.Math;
	extends SolarTherm.Media.CO2.PropCO2;

	extends Modelica.Icons.Example;

	// Input Parameters
	// *********************
	parameter Boolean match_sam = false "Configure to match SAM output";
	parameter Boolean fixed_field = false "true if the size of the solar field is fixed";

//	replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
	replaceable package Medium = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph "Medium props for Chloride Salt";
	replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph "Medium props for sCO2";

	parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
	parameter Currency currency = Currency.USD "Currency used for cost analysis";

	parameter Boolean const_dispatch = true "Constant dispatch of energy";
	parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not const_dispatch "Discharging schedule from a file";

	// Weather data
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/gen3p3_Daggett_TMY3.motab");
	parameter Real wdelay[8] = {1800, 1800, 0, 0, 0, 0, 0, 0} "Weather file delays";

	parameter nSI.Angle_deg lon = -116.800 "Longitude (+ve East)";
	parameter nSI.Angle_deg lat = 34.850 "Latitude (+ve North)";
	parameter nSI.Time_hour t_zone = -8 "Local time zone (UCT=0)";
	parameter Integer year = 1996 "Meteorological year";

	// Field
	parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/g3p3_opt_eff_1_azim_sud.motab");
	parameter Solar_angles angles = Solar_angles.ele_azi "Angles used in the lookup table file";

	parameter Real SM = 2.5 "Solar multiple";
	parameter Real land_mult = 6.16783860571 "Land area multiplier";

	parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
	parameter SI.Area A_heliostat = 100 "Heliostat module reflective area";
	parameter Real he_av_design = 0.99 "Helisotats availability";

	parameter SI.Efficiency eff_opt = 0.6389 "Field optical efficiency at design point";
	parameter SI.Irradiance dni_des = 950 "DNI at design point";
	parameter Real C = 1046.460400794 "Concentration ratio";

	parameter Real gnd_cvge = 0.3126 "Ground coverage";
	parameter Real excl_fac = 0.97 "Exclusion factor";
	parameter Real twr_ht_const = if polar then 2.25 else 1.25 "Constant for tower height calculation";

	// Receiver
	parameter Integer N_pa_rec = 20 "Number of panels in receiver";
	parameter SI.Thickness t_tb_rec = 1.25e-3 "Receiver tube wall thickness";
	parameter SI.Diameter D_tb_rec = 40e-3 "Receiver tube outer diameter";

	parameter Real ar_rec = 1 "Height to diameter aspect ratio of receiver aperture";

	parameter SI.Efficiency ab_rec = 0.94 "Receiver coating absorptance";
	parameter SI.Efficiency em_rec = 0.86 "Receiver coating emissivity";

	parameter SI.RadiantPower R_des(fixed = if fixed_field then true else false) "Input power to receiver at design point";

	parameter Real rec_fr = (1.0 - 0.9569597659257708) "Receiver loss fraction of radiance at design point";
	parameter SI.Temperature rec_T_amb_des = from_degC(25) "Ambient temperature at design point";

	parameter Real f_loss = 0.000001 "Fraction of particles flow lost in receiver";

	// Storage
	parameter Real t_storage(unit = "h") = 14 "Hours of storage";

	parameter SI.Temperature T_cold_set (fixed=false) "Cold tank target temperature";
	parameter SI.Temperature T_hot_set = from_degC(735) "Hot tank target temperature";

	parameter SI.Temperature T_cold_start = T_cold_set "Cold tank starting temperature";
	parameter SI.Temperature T_hot_start = from_degC(735) "Hot tank starting temperature";

	parameter SI.Temperature T_cold_aux_set = from_degC(500) "Cold tank auxiliary heater set-point temperature";
	parameter SI.Temperature T_hot_aux_set = from_degC(715) "Hot tank auxiliary heater set-point temperature";

	parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold partilces thermodynamic state at design";
	parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hot partilces thermodynamic state at design";

	parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
	parameter SI.Temperature tnk_T_amb_des = from_degC(25) "Ambient temperature at design point";

	parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";

	parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
	parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";

	parameter SI.CoefficientOfHeatTransfer alpha = 3 "Tank constant heat transfer coefficient with ambient";

	parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Hot tank parasitic power coefficient";
	parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot tank parasitic power coefficient";

	parameter SI.Power W_heater_hot = 30e8 "Hot tank heater capacity";
	parameter SI.Power W_heater_cold = 30e8 "Cold tank heater capacity";

	parameter Real tank_ar = 20/18.667 "storage aspect ratio";

	// Power block
	replaceable model Cycle = Models.PowerBlocks.Correlation.sCO2 "sCO2 cycle regression model";
	parameter SI.Temperature T_comp_in = from_degC(45) "Compressor inlet temperature at design";
	replaceable model Cooling = Models.PowerBlocks.Cooling.DryCooling "PB cooling model";

	parameter SI.Power P_gross(fixed = if fixed_field then false else true) = 111e6 "Power block gross rating at design point";

	parameter SI.Efficiency eff_blk = 0.502 "Power block efficiency at design point";

	parameter Real par_fr = 0.099099099 "Parasitics fraction of power block rating at design point";
	parameter Real par_fix_fr = 0.0055 "Fixed parasitics as fraction of gross rating";

	parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";

	parameter Boolean external_parasities = false "True if there is external parasitic power losses";
	
	parameter Real nu_min_blk = 0.5 "Minimum allowed part-load mass flow fraction to power block";
	parameter SI.Power W_base_blk = par_fix_fr * P_gross "Power consumed at all times in power block";
	parameter SI.AbsolutePressure p_blk = 25e6 "high pressure of the cycle";

	parameter SI.Temperature blk_T_amb_des = from_degC(43) "Ambient temperature at design for power block";
	parameter SI.Temperature par_T_amb_des = 298.15 "Ambient temperature at design point";

	parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
	parameter SI.Temperature T_in_ref_blk = from_degC(735) "Particle inlet temperature to particle heat exchanger at design";
	parameter SI.Temperature T_out_ref_blk (fixed=false) "Particle outlet temperature from particle heat exchanger at design";

	// Control
	parameter SI.Angle ele_min = from_deg(8) "Heliostat stow deploy angle";
	parameter Boolean use_wind = true "True if using wind stopping strategy in the solar field";
	parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";

	parameter SI.HeatFlowRate Q_flow_defocus = if match_sam then Q_flow_des*(1 + rec_fr) else Q_flow_des/(1 - rec_fr) "Solar field thermal power at defocused state";

	parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
	parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
	parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";

	parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real hot_tnk_empty_ub = 50 "Hot tank empty trigger upper bound"; // Level (above which) to start disptach

	parameter Real hot_tnk_full_lb = 93 "Hot tank full trigger lower bound";
	parameter Real hot_tnk_full_ub = 95 "Hot tank full trigger upper bound";

	parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound"; // Level (above which) to start disptach

	parameter Real cold_tnk_crit_lb = 1 "Cold tank critically empty trigger lower bound"; // Level (below which) to stop disptach
	parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound"; // Level (above which) to start disptach

	parameter Real Ti = 0.1 "Time constant for integral component of receiver control";
	parameter Real Kp = -1000 "Gain of proportional component in receiver control";

	// Calculated Parameters
	parameter SI.HeatFlowRate Q_flow_des =
			if fixed_field then if match_sam then R_des/((1 + rec_fr)*SM) else R_des*(1 - rec_fr)/SM
			else P_gross/eff_blk "Heat to power block at design";

	parameter SI.Energy E_max = t_storage*3600*Q_flow_des "Maximum tank stored energy";

	parameter SI.Area A_field = R_des/eff_opt/he_av_design/dni_des "Heliostat field reflective area";
	parameter Integer n_heliostat = integer(ceil(A_field/A_heliostat)) "Number of heliostats";

	parameter SI.Area A_receiver = A_field/C "Receiver aperture area";
	parameter SI.Length D_receiver = sqrt(A_receiver/(pi*ar_rec)) "Receiver diameter";
	parameter SI.Length H_receiver = D_receiver*ar_rec "Receiver aperture height";

	parameter SI.Area A_land = land_mult*A_field + 197434.207385281 "Land area";

	parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold particles specific enthalpy at design";
	parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot particles specific enthalpy at design";

	parameter SI.Density rho_cold_set = Medium.density(state_cold_set) "Cold particles density at design";
	parameter SI.Density rho_hot_set = Medium.density(state_hot_set) "Hot particles density at design";

	parameter SI.Mass m_max = E_max/(h_hot_set - h_cold_set) "Max particles mass in tanks";
	parameter SI.Volume V_max = m_max/((rho_hot_set + rho_cold_set)/2) "Max particles volume in tanks";

	parameter SI.MassFlowRate m_flow_fac = SM*Q_flow_des/(h_hot_set - h_cold_set) "Mass flow rate to receiver at design point";
	parameter SI.MassFlowRate m_flow_rec_max = 1.3*m_flow_fac "Maximum mass flow rate to receiver"; //1.13952693353*m_flow_fac
	parameter SI.MassFlowRate m_flow_rec_start = 0.8*m_flow_fac "Initial or guess value of mass flow rate to receiver in the feedback controller"; //0.81394780966*m_flow_fac
	parameter SI.MassFlowRate m_flow_blk = Q_flow_des/(h_hot_set - h_cold_set) "Mass flow rate to power block at design point";

	parameter SI.Power P_net = (1 - par_fr)*P_gross "Power block net rating at design point";
	parameter SI.Power P_name = P_net "Nameplate rating of power block";

	parameter SI.Length H_storage = ceil((4*V_max*tank_ar^2/pi)^(1/3)) "Storage tank height";
	parameter SI.Diameter D_storage = H_storage/tank_ar "Storage tank diameter";

	parameter SI.Length H_tower = 0.154*sqrt(twr_ht_const*(A_field/(gnd_cvge*excl_fac))/pi) "Tower height"; // A_field/(gnd_cvge*excl_fac) is the field gross area
	parameter SI.Diameter D_tower = D_receiver "Tower diameter"; // That's a fair estimate. An accurate H-to-D correlation may be used.

	// Cost data in USD (default) or AUD
	parameter Real r_disc = 0.0439 "Real discount rate";
	parameter Real r_i = 0.025 "Inflation rate";

	parameter Integer t_life(unit = "year") = 30 "Lifetime of plant";
	parameter Integer t_cons(unit = "year") = 2 "Years of construction";

	parameter Real r_cur = 0.71 "The currency rate from AUD to USD"; // Valid for 2019. See https://www.rba.gov.au/
	parameter Real f_Subs = 0 "Subsidies on initial investment costs";

	parameter Real r_contg = 0.1 "Contingency rate";
	parameter Real r_indirect = 0.13 "Indirect capital costs rate";
	parameter Real r_cons = 0.06 "Construction cost rate";

	parameter FI.AreaPrice pri_field = if currency==Currency.USD then 180 else 180/r_cur "Field cost per design aperture area";
	parameter FI.AreaPrice pri_site = if currency==Currency.USD then 20 else 20/r_cur "Site improvements cost per area";
	parameter FI.AreaPrice pri_land = if currency==Currency.USD then 10000 / 4046.86 else (10000 / 4046.86)/r_cur "Land cost per area";

	parameter FI.EnergyPrice pri_storage = if currency==Currency.USD then 37 / (1e3 * 3600) else (37 / (1e3 * 3600))/r_cur "Storage cost per energy capacity";

	parameter FI.PowerPrice pri_block = if currency==Currency.USD then 1000 / 1e3 else 1000/r_cur "Power block cost per gross rated power";

	parameter FI.PowerPrice pri_bop = if currency==Currency.USD then 350 / 1e3 else (350 / 1e3)/r_cur "Balance of plant cost per gross rated power";

	parameter Real pri_om_name(unit="$/W/year")=if currency==Currency.USD then 40/1e3 else 40/1e3/r_cur "Fixed O&M cost per nameplate per year";
	parameter Real pri_om_prod(unit="$/J/year")=if currency==Currency.USD then 3.5*0/(1e6*3600) else 3.5*0/(1e6*3600)/r_cur "Variable O&M cost per production per year"; // Based on downselection criteria
	
	parameter FI.Money pri_tower = if currency == Currency.USD then 157.44 else 157.44/r_cur "Fixed tower cost";
	parameter Real idx_pri_tower = 1.9174 "Tower cost scaling index";

	parameter FI.AreaPrice pri_receiver = if currency == Currency.USD then 37400 else 37400/r_cur "Falling particle receiver cost per design aperture area";

	parameter FI.PowerPrice pri_hx = if currency == Currency.USD then 175.90/1e3 else 175.90/1e3/r_cur "Heat exchnager cost per energy capacity";

	parameter FI.Money C_field = A_field*pri_field "Field cost";
	parameter FI.Money C_site = A_field*pri_site "Site improvements cost";
	parameter FI.Money C_tower = pri_tower*H_tower^idx_pri_tower "Tower cost";
	parameter FI.Money C_receiver = if currency==Currency.USD then 71708855 * (A_receiver / 879.8) ^ 0.7 else (71708855 * (A_receiver / 879.8) ^ 0.7)/r_cur "Receiver cost";
	parameter FI.Money C_storage = pri_storage * E_max "Storage cost";
	parameter FI.Money C_block (fixed=false) "Power block cost"; // TODO Check sCO2 power block model to check PB cost equation
	parameter FI.Money C_bop = P_gross*pri_bop "Balance of plant cost";

	parameter FI.Money C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop) "Direct capital cost subtotal";

	parameter FI.Money C_contingency = 0.07 * C_cap_dir_sub "Contingency costs";
	parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";	
	parameter FI.Money C_EPC = 0.11 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
	
	parameter FI.Money C_land = A_land*pri_land "Land cost";
	parameter FI.Money C_cap (fixed=false) "Capital costs";

	parameter FI.MoneyPerYear C_year = P_name*pri_om_name "Fixed O&M cost per year";
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
		y = heliostatsField.W_loss + tankHot.W_loss + tankCold.W_loss) annotation(
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
		redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file)) annotation(
		Placement(transformation(extent = {{-88, 2}, {-56, 36}})));

	// Receiver
	SolarTherm.Models.CSP.CRS.Receivers.ChlorideSaltReceiver receiver(
		redeclare package Medium = Medium,
		em = em_rec,
		ab = ab_rec,
		H_rcv = H_receiver,
		D_rcv = D_receiver,
		const_alpha = true) annotation(
		Placement(transformation(extent = {{-46, 4}, {-10, 40}})));

	// Hot tank
	SolarTherm.Models.Storage.Tank.Tank tankHot(
		redeclare package Medium = Medium,
		D = D_storage,
		H = H_storage,
		T_start = T_hot_start,
		L_start = (1 - split_cold) * 100, alpha = alpha,
		use_p_top = tnk_use_p_top,
		enable_losses = tnk_enable_losses,
		use_L = true,
		W_max = W_heater_hot,
		T_set = T_hot_aux_set) annotation(
		Placement(transformation(extent = {{16, 54}, {36, 74}})));

	// Cold tank
	SolarTherm.Models.Storage.Tank.Tank tankCold(
		redeclare package Medium = Medium,
		D = D_storage,
		H = H_storage,
		T_start = T_cold_start,
		L_start = split_cold * 100,
		alpha = alpha,
		use_p_top = tnk_use_p_top,
		enable_losses = tnk_enable_losses,
		use_L = true,
		W_max = W_heater_cold,
		T_set = T_cold_aux_set) annotation(
		Placement(transformation(extent = {{64, -28}, {44, -8}})));

	// Receiver lift
	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(
		redeclare package Medium = Medium,
		k_loss = k_loss_hot) annotation(
		Placement(visible = true, transformation(origin = {-7, -31}, extent = {{0, 0}, {12, 12}}, rotation = 0)));

	// Pump Hot
	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(
		redeclare package Medium = Medium,
		k_loss = k_loss_hot) annotation(
		Placement(transformation(origin = {74, 44}, extent = {{0, 0}, {12, 12}})));

	// Temperature sensor
	SolarTherm.Models.Fluid.Sensors.Temperature temperature(
		redeclare package Medium = Medium) annotation(
		Placement(transformation(extent = {{-14, 74}, {-4, 64}})));

	// PowerBlockControl
	SolarTherm.Models.Control.PowerBlockControl controlHot(
		m_flow_on = m_flow_blk,
		L_on = hot_tnk_empty_ub,
		L_off = hot_tnk_empty_lb,
		L_df_on = hot_tnk_full_ub,
		L_df_off = hot_tnk_full_lb) annotation(
		Placement(transformation(extent = {{48, 72}, {60, 58}})));

	// ReceiverControl
	SolarTherm.Models.Control.ReceiverControl controlCold(T_ref = T_hot_set,
		m_flow_min = 0,
		m_flow_max = m_flow_rec_max,
		y_start = m_flow_rec_start,
		L_df_on = cold_tnk_defocus_lb,
		L_df_off = cold_tnk_defocus_ub,
		L_off = cold_tnk_crit_lb,
		L_on = cold_tnk_crit_ub,
		Ti = Ti, Kp = Kp) annotation(
		Placement(transformation(extent = {{24, -10}, {10, 4}})));

	// Power block
	SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.recompPB powerBlock(
		redeclare package MedRec = Medium,
		P_gro = P_gross,
		T_HTF_in_des = T_in_ref_blk,
		T_amb_des = blk_T_amb_des,
		T_low = T_comp_in,
		m_HTF_des = m_flow_blk,
		external_parasities = external_parasities,
		nu_min = nu_min_blk) annotation(
		Placement(transformation(extent = {{88, 4}, {124, 42}})));

	// Price
	SolarTherm.Models.Analysis.Market market(
		redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
		Placement(visible = true, transformation(extent = {{128, 12}, {148, 32}}, rotation = 0)));

	SolarTherm.Models.Sources.Schedule.Scheduler sch if not const_dispatch;

	// Variables:
	SI.Power P_elec "Output power of power block";
	SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
	FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";

initial equation
	if fixed_field then
		P_gross = Q_flow_des * eff_cyc;
	else
		R_des = if match_sam then SM * Q_flow_des * (1 + rec_fr) else SM * Q_flow_des / (1 - rec_fr);
	end if;

	T_cold_set = powerBlock.exchanger.T_HTF_des[1];
	T_cold_set = T_out_ref_blk;
	C_block = powerBlock.C_PB;
	C_cap	= (C_field + C_site + C_receiver + C_storage + C_block + C_bop) * (1 + r_contg) * (1 + r_indirect) * (1 + r_cons) + C_land;

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
	connect(tankCold.T_amb, Tamb_input.y) annotation(
		Line(points = {{58.1, -8.3}, {58.1, 20}, {90, 20}, {92, 20}, {92, 42}, {102.4, 42}, {102.4, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	// Fluid connections
	connect(pumpCold.fluid_a, tankCold.fluid_b) annotation(
		Line(points = {{5, -25}, {44, -25}}, color = {0, 127, 255}));
	connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
		Line(points = {{-8, -25}, {-18, -25}, {-18, 6}, {-24, 6}}, color = {0, 127, 255}));
	connect(receiver.fluid_b, temperature.fluid_a) annotation(
		Line(points = {{-21.88, 30.64}, {-21.88, 30}, {-20, 30}, {-16, 30}, {-16, 69}, {-14, 69}}, color = {0, 127, 255}));
	connect(temperature.fluid_b, tankHot.fluid_a) annotation(
		Line(points = {{-4, 69}, {-4, 69}, {16, 69}}, color = {0, 127, 255}));
	connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(
		Line(points = {{36, 57}, {36, 50},{74, 50}}, color = {0, 127, 255}));
	connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
		Line(points = {{78, 50}, {86, 50}, {86, 29.46}, {98.08, 29.46}}, color = {0, 127, 255}));
	connect(powerBlock.fluid_b, tankCold.fluid_a) annotation(
		Line(points = {{95.56, 14.64}, {78, 14.64}, {78, -13}, {64, -13}}, color = {0, 127, 255}));

	// controlCold connections
	connect(temperature.T, controlCold.T_mea) annotation(
		Line(points = {{-9, 63.9}, {-10, 63.9}, {-10, 24}, {38, 24}, {38, 1.2}, {24.7, 1.2}}, color = {0, 0, 127}));
	connect(tankCold.L, controlCold.L_mea) annotation(
		Line(points = {{24.56, -3}, {38, -3}, {38, -13.6}, {43.8, -13.6}}, color = {0, 0, 127}));
	connect(heliostatsField.on, controlCold.sf_on) annotation(
		Line(points = {{-72, 2}, {-72, 2}, {-72, -36}, {28, -36}, {28, -6}, {24.7, -6}, {24.7, -7.2}}, color = {255, 0, 255}));
//	connect(heliostatsField.on, receiver.on) annotation(
//		Line(points = {{-31.24, 5.44}, {-44, 5.44}, {-44, -18}, {-72, -18}, {-72, -36}, {28, -36}, {28, -6}, {24.7, -6}, {24.7, -7.2}}, color = {255, 0, 255}));
	connect(controlCold.m_flow, pumpCold.m_flow) annotation(
		Line(points = {{10, -3}, {-1, -3}, {-1, -19}}, color = {0, 0, 127}));
	connect(controlCold.defocus, or1.u2) annotation(
		Line(points = {{17, -10.98}, {17, -32}, {-106, -32}, {-106, 4.8}, {-102.8, 4.8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));

	// controlHot connections
	connect(tankHot.L, controlHot.L_mea) annotation(
		Line(points = {{36.2, 68.4}, {40, 68.4}, {40, 68.5}, {47.52, 68.5}}, color = {0, 0, 127}));
	connect(pumpCold.m_flow, controlHot.m_flow_in) annotation(
		Line(points = {{-1, -19}, {-1, 40}, {44, 40}, {44, 62}, {48, 62}}, color = {0, 0, 127}));
	connect(controlHot.m_flow, pumpHot.m_flow) annotation(
		Line(points = {{60.72, 65}, {80, 65}, {80, 56}}, color = {0, 0, 127}));
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

	P_elec = powerBlock.W_net;
	der(E_elec) = P_elec;
	R_spot = market.profit;

	annotation(
		Diagram(
		coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1),
		graphics = {
			Text(lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 9, fontName = "CMU Serif"),
			Text(lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 9, fontName = "CMU Serif"),
			Text(origin = {-16, 10}, extent = {{-24, -8}, {-4, -12}}, textString = "Receiver", fontSize = 10, fontName = "CMU Serif"),
			Text(origin = {20, -4}, extent = {{-110, 4}, {-76, -2}}, textString = "Heliostats Field", fontSize = 10, fontName = "CMU Serif"),
			Text(origin = {-14, 2}, extent = {{-44, 70}, {-34, 66}}, textString = "Sun", fontSize = 10, fontName = "CMU Serif"),
			Text(origin = {-14, 10}, extent = {{26, 44}, {48, 38}}, textString = "Hot Tank", fontSize = 10, fontName = "CMU Serif"),
			Text(origin = {-12, 8}, extent = {{54, -40}, {78, -44}}, textString = "Cold Tank", fontSize = 10, fontName = "CMU Serif"),
			Text(origin = {-8, 10}, extent = {{100, -4}, {128, -8}}, textString = "Power Block", fontSize = 10, fontName = "CMU Serif"),
			Text(origin = {18, -6}, extent = {{112, 16}, {128, 8}}, textString = "Market", fontSize = 10, fontName = "CMU Serif"),
			Text(origin = {6, -8}, extent = {{-6, 20}, {28, 14}}, textString = "Receiver Control", fontSize = 10, fontName = "CMU Serif"),
			Text(origin = {2, 32}, extent = {{38, 48}, {78, 42}}, textString = "Power Block Control", fontSize = 10, fontName = "CMU Serif"),
			Text(origin = {-6, -18}, extent = {{-124, -40}, {-98, -46}}, textString = "Data Source", fontSize = 10, fontName = "CMU Serif"),
			Text(origin = {-18, -22}, extent = {{-10, 8}, {12, 2}}, textString = "PumpCold", fontSize = 10, fontName = "CMU Serif"),
			Text(origin = {81, 67}, extent = {{1, -5}, {19, -11}}, textString = "PumpHot", fontSize = 10, fontName = "CMU Serif")}),
		Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
		experiment(StopTime = 31536000, StartTime = 0, Tolerance = 0.0001, Interval = 1800),		
		__Dymola_experimentSetupOutput,
		Documentation(info = "<html>
	<p>
		<b>SaltSCO2System</b> models the system-level interactions of a two-tank CSP system using Chloride Salt.
	</p>
	</html>", 
	revisions="<html>
	<ul>
		<li><i>Jun 2019</i> by Ali Shirazi and <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		Created.</li>
		<li><i>Jan 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		Integration of the sCO2 power block modelica model developed by Simon Kamerling at INES (Institut National de l’Énergie Solaire) in France.</li>
	</ul>
	</html>"),
		__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end SaltSCO2System;
