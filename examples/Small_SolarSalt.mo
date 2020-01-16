within examples;
model Small_SolarSalt "System level model presented in SolarPACES 2019 and APSRC 2019"

	import SolarTherm.{Models,Media};
	import Modelica.SIunits.Conversions.from_degC;
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Models.Analysis.Finances;
	import SolarTherm.Types.Solar_angles;
	import SolarTherm.Utilities.ReadHelNum;
	import Modelica.Utilities.Files;
	extends Modelica.Icons.Example;

	// Input Parameters
	//*********************

	// Plant Design
	parameter SI.Power P_name = 10e6 "Nameplate rating of power block";
	parameter Real SM = 1.4 "Solar multiple";
	parameter Real ratio_recD = 1.00;
	parameter Real ratio_recH = 1.00;
	parameter Real ratio_towH = 1.00;
	parameter Boolean ConcreteTower = false;

	parameter Boolean match_sam = false "Configure to match SAM output";
	replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph "Medium props for molten salt";

	// Weather data
	parameter String file_weather = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/apsrc/Alice2000.motab");
	parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)";
	parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)";
	parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
	parameter Integer year = 2000 "Meteorological year";

	// Power block
	parameter SI.Efficiency eff_blk = (2.4985*log(P_gross/1000000) + 29.941)/100 "Power block efficiency at design point";
	parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";
	parameter Boolean external_parasities = true "true if there is external parasitic power losses";
	parameter Real nu_min_blk = 0.5 "minimum allowed part-load mass flow fraction to power block";
	parameter SI.Power W_base_blk = 0.0055 * P_gross "Power consumed at all times in power block";
	parameter SI.AbsolutePressure p_blk = 10e6 "Power block operating pressure";
	parameter SI.Temperature blk_T_amb_des = 316.15 "Ambient temperature at design for power block";
	parameter Real nu_net_blk = 100/111 "Gross to net power conversion factor at the power block";
	parameter SI.Temperature T_in_ref_blk = from_degC(574) "HTF inlet temperature to power block at design";
	parameter SI.Temperature T_out_ref_blk = from_degC(290) "HTF outlet temperature to power block at design";

	// Field
	parameter Integer ind_hel = 5*(integer(P_name/10e6)-1) + integer(1 + (SM-1.4)/0.4);
	parameter String file_helios = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/apsrc/heliostat_list.txt");
	parameter String file_optics = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/apsrc/10SM14.motab");
	parameter Integer n_heliostat = ReadHelNum(ind_hel,file_helios);
	parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
	parameter Real he_av_design = 0.99 "Heliostats availability";
	parameter Real C = 1200 "Concentration ratio";
	parameter Real int_eff = 0.97;
	parameter Real att_eff = 0.95;
	parameter Real opt_eff = 0.74529;
	parameter Real ground_cov = 0.26382 "Ground coverage";
	parameter Real excl_factor = 0.97 "Exclusion factor";
	parameter SI.Irradiance I_des = 950 "DNI at design point";
	parameter SI.Area A_heliostat = 144.375 "Heliostat reflective area";
	parameter Solar_angles angles = Solar_angles.ele_azi "Angles used in the lookup table file";

	// Receiver
	parameter SI.Efficiency ab_rec = 0.94 "Receiver coating absorptance";
	parameter SI.Efficiency em_rec = 0.88 "Receiver coating emissivity";
	parameter SI.HeatFlux flux_max = 1e6 "Allowable receiver flux";
	parameter Real heat_distr = 0.53 "Receiver flux distribution factor";
	parameter Real rec_ar = 18.67/15 "Receiver aspect ratio";
	parameter SI.HeatFlux Loss_constant = 30e3 "Receiver losses coefficient";

	// Storage
	parameter Real t_storage(unit = "h") = 15 "Hours of storage";
	parameter SI.Temperature T_cold_start = CV.from_degC(290) "Cold tank starting temperature";
	parameter SI.Temperature T_hot_start = CV.from_degC(574) "Hot tank starting temperature";
	parameter SI.Temperature T_cold_aux_set = CV.from_degC(280) "Cold tank auxiliary heater set-point temperature";
	parameter SI.Temperature T_hot_aux_set = CV.from_degC(500) "Hot tank auxiliary heater set-point temperature";
	parameter SI.Temperature T_cold_set = CV.from_degC(290) "Cold tank target temperature";
	parameter SI.Temperature T_hot_set = CV.from_degC(574) "Hot tank target temperature";
	parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
	parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
	parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
	parameter SI.CoefficientOfHeatTransfer alpha = 0.4 "Tank constant heat transfer coefficient with ambient"; // was 3
	parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold tank parasitic power coefficient";
	parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot tank parasitic power coefficient";
	parameter SI.Density dens_in_ref = Medium.density(state_in_ref) "inlet Density at design point";
	parameter SI.Density dens_out_ref = Medium.density(state_out_ref) "outlet Density at design point";
	parameter SI.Height H_storage = ceil(100*storage_ar*D_storage_guess)/100 "Storage tank height"; 
	parameter SI.Diameter D_storage_guess = 19.15*(Q_flow_ref_blk/294.118e6*t_storage/4)^(1/3) "Storage tank diameter";
	parameter SI.Diameter D_storage = ceil(100*(4*((E_max/(h_in_ref - h_out_ref))/((dens_in_ref+dens_out_ref)/2))/(CN.pi*(H_storage-1)))^0.5)/100 "Storage tank diameter";
	parameter Real storage_ar = 20/19.15 "storage aspect ratio";
	parameter SI.Power W_heater_hot = 30e6 "Hot tank heater capacity";
	parameter SI.Power W_heater_cold = 15e6 "Cold tank heater capacity";

	// Control
	parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
	parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
	parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
	parameter SI.HeatFlowRate Q_flow_defocus = 330e6*Q_flow_ref_blk/294.118e6 "Solar field thermal power at defocused state";
	parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
	parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
	parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
	parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound";
	parameter Real hot_tnk_empty_ub = 10 "Hot tank empty trigger upper bound";
	parameter Real hot_tnk_full_lb = 90 "Hot tank full trigger lower bound";
	parameter Real hot_tnk_full_ub = 93 "Hot tank full trigger upper bound";
	parameter SI.MassFlowRate m_flow_rec_max = 1400 * Q_rec_des/529.4118e6 "Maximum mass flow rate to receiver"; //
	parameter SI.MassFlowRate m_flow_rec_start = 1000 * Q_rec_des/529.4118e6 "Initial or guess value of mass flow rate to receiver in the feedback controller";
	parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound";
	parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound";
	parameter Real cold_tnk_crit_lb = 0 "Cold tank critically empty trigger lower bound";
	parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound";
	parameter Real Ti = 0.1 "Time constant for integral component of receiver control";
	parameter Real Kp = -1000 *0.1* Q_rec_des/529.4118e6 "Gain of proportional component in receiver control";


	// Calculated Parameters
	// *********************
	//Field
	parameter SI.Area A_field = n_heliostat * A_heliostat "Solar field reflective area";
	parameter SI.Area A_land = 5.2178979428*A_field + 197434.207385281 "Land area";
	parameter SI.Length H_tower = floor(ratio_towH * 100 * 0.154 * sqrt(1.25 * R_area / (ground_cov * excl_factor * CN.pi))) / 100 "Tower height";

	//Receiver
	parameter SI.HeatFlowRate Q_rec_des = SM * P_gross / eff_blk "Heat absorbed by the receiver";
	parameter SI.Area A_receiver_test = Q_rec_des / (heat_distr * flux_max) "Receiver test area";
	parameter SI.Diameter D_receiver_test = sqrt(A_receiver_test / (CN.pi * rec_ar)) "Receiver diameter";
	parameter SI.Length H_receiver_test = D_receiver_test * rec_ar "Receiver height";
	parameter SI.HeatFlowRate Q_rec_loss = Loss_constant * A_receiver_test * ((574 + 273.15) / 800) ^ 2 "Heat absorbed by the receiver";
	parameter SI.Area R_area = (Q_rec_des + Q_rec_loss) / (int_eff * att_eff * ab_rec * opt_eff * I_des) "Reflective area";

	//Change in Receiver Diameter and Height
	parameter SI.Diameter D_receiver = D_receiver_test*ratio_recD "Receiver diameter";
	parameter SI.Length H_receiver = H_receiver_test*ratio_recH "Receiver height";
	parameter SI.Area A_receiver = CN.pi*D_receiver*H_receiver "Receiver area";

	//Powerblock
	parameter SI.Power P_gross = P_name * 111 / 100 "Power block gross rating at design point";
	parameter SI.HeatFlowRate Q_flow_ref_blk = P_gross / eff_blk "Thermal power to power block at design";
	parameter Medium.ThermodynamicState state_in_ref = Medium.setState_pTX(p_blk, T_in_ref_blk) "medium state: pressure,temperature,composition";
	parameter Medium.ThermodynamicState state_out_ref = Medium.setState_pTX(p_blk, T_out_ref_blk) "medium state: pressure,temperature,composition";	
	parameter SI.SpecificEnthalpy h_in_ref = Medium.specificEnthalpy(state_in_ref) "specific inlet enthalpy at design point";	
	parameter SI.SpecificEnthalpy h_out_ref = Medium.specificEnthalpy(state_out_ref) "specific outlet enthalpy at design point";
	parameter SI.MassFlowRate m_flow_blk = Q_flow_ref_blk / (h_in_ref - h_out_ref) "Mass flow rate to power block at design";

	//Storage
	parameter SI.Energy E_max = t_storage * 3600 * Q_flow_ref_blk "Maximum tank stored energy";

	// Cost data SAM 2018
	parameter Real r_disc = 0.07 "Discount rate";
	parameter Real r_i = 0.03 "Inflation rate";
	parameter Integer t_life(unit = "year") = 27 "Lifetime of plant";
	parameter Integer t_cons(unit = "year") = 3 "Years of construction";
	parameter Real f_Subs = 0 "Subsidies on initial investment costs";
	parameter FI.AreaPrice pri_field = 177*(603.1/525.4) "Field cost per design aperture area";
	parameter FI.AreaPrice pri_site = 16 "Site improvements cost per area";
	parameter FI.EnergyPrice pri_storage = 22 / (1e3 * 3600) "Storage cost per energy capacity";
	parameter FI.PowerPrice pri_block = 1040 / 1e3 "Power block cost per gross rated power";
	parameter FI.PowerPrice pri_bop = 290 / 1e3 "Balance of plant cost per gross rated power";
	parameter FI.AreaPrice pri_land = 10000 / 4046.86 "Land cost per area";
	parameter Real pri_om_name(unit = "$/W/year") = 66 / 1e3 "Fixed O&M cost per nameplate per year";	// It is 58 $/kW/year in Mehdi's report, but Andrew suggsted a more recent number
	parameter Real pri_om_prod(unit = "$/J/year") = 3.5 / (1e6 * 3600) "Variable O&M cost per production per year";	// It was 5.9656 $/MWh/year in Mehdi's report, but Andrew suggsted a more recent number
	parameter FI.Money C_field = pri_field * A_field "Field cost";
	parameter FI.Money C_site = pri_site * A_field "Site improvements cost";
	parameter FI.Money C_tower = if ConcreteTower == true then 3e6 * exp(0.0113 * H_tower) else 1.09025e6 * (603.1/318.4) * exp(0.00879 * H_tower) "Tower cost";
	parameter FI.Money C_receiver = 103e6 * (A_receiver / 1571) ^ 0.7 "Receiver cost";
	parameter FI.Money C_storage = pri_storage * E_max "Storage cost";
	parameter FI.Money C_block = pri_block * P_gross "Power block cost";
	parameter FI.Money C_bop = pri_bop * P_gross "Balance of plant cost";
	parameter FI.Money C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop) "Direct capital cost subtotal";	// i.e. purchased equipment costs
	parameter FI.Money C_contingency = 0.07 * C_cap_dir_sub "Contingency costs";
	parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
	parameter FI.Money C_EPC = 0.13 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
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
	file = file_weather) annotation(
		Placement(visible = true, transformation(extent = {{-132, -56}, {-102, -28}}, rotation = 0)));
	
	//DNI_input
	Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
		Placement(transformation(extent = {{-140, 60}, {-120, 80}})));
	
	//Tamb_input
	Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
		Placement(transformation(extent = {{140, 70}, {120, 90}})));
	
	//WindSpeed_input
	Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
		Placement(transformation(extent = {{-140, 20}, {-114, 40}})));
	
	//pressure_input
	Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
		Placement(transformation(extent = {{76, 18}, {56, 38}})));
 
	//parasitic inputs
	Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold.W_loss + tankHot.W_loss + tankCold.W_loss) annotation(
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
	redeclare function solarPosition = SolarTherm.Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
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
	redeclare model Optical = SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = file_optics)) annotation(
		Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
	
	// Receiver
	SolarTherm.Models.CSP.CRS.Receivers.ReceiverSimpleStress receiver(
	em = em_rec, 
	redeclare package Medium = Medium, 
	H_rcv = H_receiver, 
	D_rcv = D_receiver, 
	N_pa = 20, 
	t_tb = 1.651e-3, 
	D_tb = 33.4e-3, 
	ab = ab_rec) annotation(
		Placement(transformation(extent = {{-46, 4}, {-10, 40}})));
	
	// Hot tank
	SolarTherm.Models.Storage.Tank.Tank tankHot(
	redeclare package Medium = Medium, 
	D = D_storage,
	H = H_storage,
	T_start = T_hot_start, 
	L_start = (1 - split_cold) * 100, 
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
	
	// Pump cold
	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(
	redeclare package Medium = Medium, 
	k_loss = k_loss_cold) annotation(
		Placement(transformation(extent = {{10, -30}, {-2, -18}})));
	
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
	SolarTherm.Models.PowerBlocks.PowerBlockModel powerBlock(
	W_des = P_gross, 
	enable_losses = blk_enable_losses, 
	redeclare model Cycle = SolarTherm.Models.PowerBlocks.Correlation.Rankine, 
	nu_min = nu_min_blk, 
	external_parasities = external_parasities, 
	W_base = W_base_blk, 
	p_bo = p_blk, 
	T_des = blk_T_amb_des, 
	nu_net = nu_net_blk, 
	T_in_ref = T_in_ref_blk, 
	T_out_ref = T_out_ref_blk, 
	Q_flow_ref = Q_flow_ref_blk) annotation(
		Placement(transformation(extent = {{88, 4}, {124, 42}})));
	
	// Price
	SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
		Placement(visible = true, transformation(extent = {{128, 12}, {148, 32}}, rotation = 0)));
	
	// Variables:
	SI.Power P_elec "Output power of power block";
	SI.Energy E_elec(start = 0, fixed = true) "Generate electricity";
	FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
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
	connect(receiver.fluid_b, temperature.fluid_a) annotation(
		Line(points = {{-21.88, 30.64}, {-21.88, 30}, {-20, 30}, {-16, 30}, {-16, 69}, {-14, 69}}, color = {0, 127, 255}));
	connect(temperature.fluid_b, tankHot.fluid_a) annotation(
		Line(points = {{-4, 69}, {-4, 69}, {16, 69}}, color = {0, 127, 255}));
	connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(
		Line(points = {{36, 57}, {36, 52}, {36, 44}, {48, 44}, {48, 43.88}, {66, 43.88}}, color = {0, 127, 255}));
	connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
		Line(points = {{78, 44}, {86, 44}, {86, 29.46}, {98.08, 29.46}}, color = {0, 127, 255}));
	connect(powerBlock.fluid_b, tankCold.fluid_a) annotation(
		Line(points = {{95.56, 14.64}, {78, 14.64}, {78, -13}, {64, -13}}, color = {0, 127, 255}));
	
	// controlCold connections
	connect(temperature.T, controlCold.T_mea) annotation(
		Line(points = {{-9, 63.9}, {-10, 63.9}, {-10, 24}, {38, 24}, {38, 1.2}, {24.7, 1.2}}, color = {0, 0, 127}));
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
	E_elec = powerBlock.E_net;
	R_spot = market.profit;
	annotation(
		Diagram(coordinateSystem(
		extent = {{-140, -120}, {160, 140}}, 
		initialScale = 0.1), 
		graphics = {
		Text(lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 10, fontName = "CMU Serif"), 
		Text(lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 10, fontName = "CMU Serif"), 
		Text(origin = {2, 2}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 10, fontName = "CMU Serif"), 
		Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 10, fontName = "CMU Serif"), 
		Text(origin = {4, -8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 10, fontName = "CMU Serif"), 
		Text(origin = {-4, 2}, extent = {{0, 58}, {48, 38}}, textString = "Hot Tank", fontSize = 10, fontName = "CMU Serif"), 
		Text(origin = {2, 2}, extent = {{30, -24}, {78, -44}}, textString = "Cold Tank", fontSize = 10, fontName = "CMU Serif"), 
		Text(origin = {4, -2}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 10, fontName = "CMU Serif"), 
		Text(origin = {6, 0}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 10, fontName = "CMU Serif"), 
		Text(origin = {2, 4}, extent = {{-6, 20}, {42, 0}}, textString = "Receiver Control", fontSize = 10, fontName = "CMU Serif"), 
		Text(origin = {2, 32}, extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 10, fontName = "CMU Serif"), 
		Text(origin = {8, -26}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 10, fontName = "CMU Serif")
		}
		),
		Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
		experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60),__Dymola_experimentSetupOutput,
		Documentation(revisions = 
		"<html>
	<ul>
	<li>Alberto de la Calle:<br>Created Reference_1. </li>
	<li>Armando Fontalvo:<br>Included sizing equations for the receiver and the tank. </li>
	</ul>
	</html>"
	)
	);
end Small_SolarSalt;
