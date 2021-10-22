within examples;
model Simimport nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Models.Analysis.Finances;
	import SolarTherm.Types.Solar_angles;
	import SolarTherm.Types.Currency;

	extends Modelica.Icons.Example;

	//TODO: Update cost data based on SAM's latest version i.e. 2018 version
	//TODO: Change the initial port_b.h_outflow to h_0 at e.g. 30 degC in storage and reciever model (define state_0)
	//TODO: add ne_trig and nc_trig
	//TODO: add PB warmup delay, and heat-up feature if hot tanl level is less than 3 hours.
	//TODO: add max wind cut-off at solar field

	// Input Parameters
	// *********************
	parameter Boolean match_sam = false "Configure to match SAM output";
	parameter Boolean fixed_field = false "true if the size of the solar field is fixed";

	replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";

	inner Modelica.Fluid.System system(
		energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
		allowFlowReversal=false) "System props and default values";
	// Can provide details of modelling accuracy, assumptions and initialisation

	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/USA_CA_Daggett.Barstow-Daggett.AP.723815_TMY3.motab") "Weather data file";
	parameter Real wdelay[8] = {1800,1800,0,0,0,0,0,0} "Weather file delays";

	parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
	parameter Currency currency = Currency.USD "Currency used for cost analysis";

	parameter Boolean const_dispatch = true "Constant dispatch of energy";
	parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not const_dispatch "Discharging schedule from a file";

	// Field
	parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/g3p3_opt_eff_1.motab") "Optical efficiency file";
	parameter Solar_angles angles = Solar_angles.ele_azi "Angles used in the optical efficiency lookup table file";

	parameter SI.Efficiency eff_opt = 0.5 "Average annual field optical efficiency at design point";
	parameter SI.Irradiance dni_des = 788.8 "DNI at design point";
	parameter Real C = 1200 "Concentration ratio";

	parameter SI.Length H_tower = 258 "Tower height";
	parameter SI.Diameter D_tower = 30 "Tower diameter";

	parameter Real SM = 2.5 "Solar multiple";
	parameter Real land_mult = 0 "Land area multiplier";

	// Receiver
	parameter Real ar_rec = 1.0 "Height to width aspect ratio of receiver aperture";

	parameter Real em_particle = 0.86 "Emissivity of particles";
	parameter Real em_curtain = 0.86 "Emissivity of curtain";
	parameter Real ab_particle = 0.93 "Absorptivity of particles";
	parameter Real ab_curtain = 0.98 "Absorptivity of curtain";

	parameter SI.CoefficientOfHeatTransfer h_th_rec = 80 "Receiver heat tranfer coefficient"; //TODO back calc this based on rec_fr and knowing radiation losses at design. Note for convection you need to calc equivalent surface area not A_aper

	parameter SI.RadiantPower R_des(fixed= if fixed_field then true else false) "Input power to receiver at design point";

	parameter Real rec_fr = 0.165 "Receiver loss fraction of radiance at design point";
	parameter SI.Temperature rec_T_amb_des = 298.15 "Ambient temperature at design point";

	// Storage
	parameter Real t_storage(unit="h") = 14 "Hours of storage";

	parameter Medium.Temperature T_cold_set = CV.from_degC(580.3) "Target cold tank temperature";
	parameter Medium.Temperature T_hot_set = CV.from_degC(800) "Target hot tank temperature";

	parameter Medium.Temperature T_cold_start = CV.from_degC(580.3) "Cold tank starting temperature";
	parameter Medium.Temperature T_hot_start = CV.from_degC(800) "Hot tank starting temperature";

	parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
	parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";

	// Power block
	parameter SI.Power P_gro(fixed = if fixed_field then false else true) = 100.0e06 "Power block gross rating at design point"; //120.0e06

	parameter SI.Efficiency eff_adj = 0.9 "Adjustment factor for power block efficiency";
	parameter SI.Efficiency eff_cyc = 0.502 "Estimate of overall power block efficiency";

	parameter SI.Efficiency eff_ext = 0.98 "Extractor efficiency";

	parameter Real par_fr = 0 "Parasitics fraction of power block rating at design point"; // 0.166
	parameter Real par_fix_fr = 0 "Fixed parasitics as fraction of net rating"; //0.0055

	parameter SI.Temperature blk_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter SI.Temperature par_T_amb_des = 298.15 "Ambient temperature at design point";

	parameter Real par_cf[:] = {0.0636, 0.803, -1.58, 1.7134} "Power block parasitics coefficients"; //TODO: Update the values for a sCO2 cycle
	parameter Real par_ca[:] = {1, 0.0025} "Power block parasitics coefficients"; //TODO: Update the values for a sCO2 cycle

	// Calculated Parameters
	parameter SI.HeatFlowRate Q_flow_des = if fixed_field then (if match_sam then R_des/((1 + rec_fr)*SM) else R_des*(1 - rec_fr) / SM) else P_gro/eff_cyc "Heat to power block at design point";

	parameter SI.Energy E_max = t_storage*3600*Q_flow_des "Maximum tank stored energy";
	parameter SI.SpecificHeatCapacity cp_set =
		SolarTherm.Media.SolidParticles.CarboHSP_utilities.cp_T((T_cold_set + T_hot_set)/2)
		"Particles average specific heat capacity at design point";
	parameter SI.Mass m_max = E_max/(cp_set*(T_hot_set - T_cold_set)) "Max particle mass in tank";

	parameter SI.Area A_field = (R_des/eff_opt)/dni_des "Heliostat field reflective area";

	parameter SI.Area A_rec = 629.8 "Receiver aperture area";
	//parameter SI.Area A_rec = A_field/C "Receiver aperture area";

	parameter SI.Length H_rec_a = sqrt(A_rec * ar_rec) "Receiver aperture height";
	parameter SI.Length W_rec_a = A_rec / H_rec_a "Receiver aperture width";

	parameter SI.Area A_land = land_mult*A_field "Land area";

	parameter SI.Power P_net = (1 - par_fr)*P_gro "Power block net rating at design point";
	parameter SI.Power P_name = P_net "Nameplate rating of power block";

	parameter SI.Irradiance dni_start = 500 "DNI above which concentrator start";
	parameter SI.Irradiance dni_stop = 500 "DNI below which concentrator stops";

	parameter SI.Velocity wspd_stop = 7.0 "Wind speed above which concentrator stops";

	parameter SI.MassFlowRate m_flow_fac = SM*Q_flow_des/(cp_set*(T_hot_set - T_cold_set)) "Mass flow rate to receiver at design point";
	parameter SI.MassFlowRate m_flow_blk = Q_flow_des/(cp_set*(T_hot_set - T_cold_set)) "Mass flow rate to power block at design point";

	parameter SI.Mass tnk_full_lb = 0.9*m_max "Tanks full trigger lower bound";
	parameter SI.Mass tnk_full_ub = 0.95*m_max "Tanks full trigger upper bound";

	parameter SI.Mass tnk_empty_lb = 0.05*m_max "Hot tank empty trigger lower bound"; // 3 hours in EES
	parameter SI.Mass tnk_empty_ub = 0.07*m_max "Hot tank empty trigger upper bound";

	parameter Real split_cold = 0.95 "Starting fraction of particle mass in cold storage tank";

	parameter Real Kp = 1.0 "Proportional gain value";

	// Cost data
	parameter Real r_disc = 0.0439 "Real discount rate";
	parameter Real r_i = 0.025 "Inflation rate";

	parameter Integer t_life(unit="year") = 30 "Lifetime of plant";
	parameter Integer t_cons(unit="year") = 2 "Years of construction";

	parameter Real r_cur = 0.71 "The currency rate from AUD to USD"; // Valid for 2019. See https://www.rba.gov.au/ //TODO USD vs AUD not implemented
	parameter Real r_contg = 0.1 "Contingency rate";
	parameter Real r_indirect = 0.13 "Indirect capital costs rate";
	parameter Real r_cons = 0.06 "Construction cost rate";

	parameter FI.AreaPrice pri_field = 75 "Field cost per design aperture area";
	parameter FI.AreaPrice pri_site = 10 "Site improvements cost per area";
	parameter FI.AreaPrice pri_land = 10000/4046.86 "Land cost per area";
	parameter FI.Money pri_tower = 157.44 "Fixed tower cost";
	parameter Real idx_pri_tower = 1.9174 "Tower cost scaling index";
	parameter Real pri_lift = 58.37 "Lift cost per rated mass flow per height"; //TODO make a new Type for this cost unit i.e. $-s/m-kg
	parameter FI.AreaPrice pri_receiver = 37400 "Receiver cost per design aperture area";
	parameter FI.EnergyPrice pri_storage = (17.70/(1e3*3600)) "Storage cost per energy capacity";
	parameter FI.PowerPrice pri_extractor = (175.90/1e3) "Heat exchnager cost per energy capacity";
	parameter FI.PowerPrice pri_block = (600/1e3) "Power block cost per gross rated power";
	parameter FI.PowerPrice pri_bop = (340/1e3) "Balance of plant cost per gross rated power";

	parameter Real pri_om_name(unit="$/W/year") = 40/1e3
	"O&M cost per nameplate per year";
	parameter Real pri_om_prod(unit="$/J/year") = 3.5/(1e6*3600)
	"O&M cost per production per year";

	parameter FI.Money C_field = A_field * pri_field "Field cost";
	parameter FI.Money C_site = A_field * pri_site "Site improvements cost";
	parameter FI.Money C_tower = 0 "Tower cost"; //TODO: add the cost function i.e. C_tower = pri_tower * (H_tower ^ idx_pri_tower)
	parameter FI.Money C_lift = 0 "Lifts cost"; //TODO: add the cost function i.e. C_lift = pri_lift * height_des * m_flow_des
	parameter FI.Money C_receiver = 97.77 * ((SM*Q_flow_des)/1000.) "Receiver cost"; // NOTE: includes fpr, tower and receiver lift all together!
		//TODO: add the cost function i.e. C_receiver = pri_receiver * A_rec
	parameter FI.Money C_storage = (m_max*cp_set*(T_hot_set - T_cold_set)) * pri_storage "Storage cost"; //TODO: add the cost function based on Eq. 7 to iclude the cost of lift
	parameter FI.Money C_extractor = Q_flow_des * pri_extractor "Heat exchanger cost";
	parameter FI.Money C_block = P_gro * pri_block "Power block cost";
	parameter FI.Money C_bop = 0 "Balance of plant cost"; // TODO: to be replaced with (P_gro * pri_bop)
	parameter FI.Money C_land = A_land * pri_land "Land cost";

	parameter FI.Money C_cap = ((C_field + C_site + C_tower + C_lift + C_receiver + C_storage + C_extractor + C_block + C_bop) * (1+r_contg)) * (1+r_indirect) * (1+r_cons) + C_land "Capital costs";

	parameter FI.MoneyPerYear C_year = P_name * pri_om_name "Cost per year";
	parameter Real C_prod(unit="$/J/year") = 0 "Cost per production per year"; //TODO: to be replaced with pri_om_prod

	// System components
	// *********************
	SolarTherm.Models.Sources.Weather.WeatherSource wea(
		file=wea_file,
		delay=wdelay) "Weather data component";

	SolarTherm.Models.CSP.CRS.HeliostatsField.SwitchedCL_2 CL(
		//redeclare model OptEff=SolarTherm.Models.CSP.CRS.HeliostatsField.IdealIncOE(alt_fixed=45),
		redeclare model OptEff=SolarTherm.Models.CSP.CRS.HeliostatsField.FileOE(
			angles=angles, file=opt_file),
		orient_north=wea.orient_north,
		A=A_field,
		t_con_on_delay=0,
		t_con_off_delay=0,
		ramp_order=1,
		dni_start=dni_start,
		dni_stop=dni_stop
		) "Heliostat field";

	SolarTherm.Models.CSP.CRS.Receivers.PlateRC RC(
		redeclare package Medium=Medium,
		A=A_rec,
		em=em_curtain,
		ab=ab_curtain,
		h_th=h_th_rec) "Receiver"; // With all props representing solid particles, PlateRC can be an equivalent of a zero-D particle receiver model

	SolarTherm.Models.Fluid.Pumps.ParticleLift lift_rec(
		redeclare package Medium=Medium,
		cont_m_flow=true,
		use_input=true,
		dh=200,
		CF=0,
		eff=0.8) "Receiver lift";
	SolarTherm.Models.Fluid.Pumps.ParticleLift lift_ext(
		redeclare package Medium=Medium,
		cont_m_flow=true,
		use_input=true,
		dh=10,
		CF=0,
		eff=0.8) "Particle heat exchanger lift";

	SolarTherm.Models.Fluid.Pumps.ParticleLift lift_stc(
		redeclare package Medium=Medium,
		cont_m_flow=false,
		use_input=false,
		dh=50,
		CF=0,
		eff=0.8) "Cold storage tank lift";

	SolarTherm.Models.Storage.Tank.FluidST STC(
		redeclare package Medium=Medium,
		m_max=m_max,
		m_start=m_max*split_cold,
		T_start=T_cold_start) "Cold storage tank";

	SolarTherm.Models.Storage.Tank.FluidST STH(
		redeclare package Medium=Medium,
		m_max=m_max,
		m_start=m_max*(1 - split_cold),
		T_start=T_hot_start) "Hot storage tank";

	SolarTherm.Models.Fluid.HeatExchangers.Extractor ext(
		redeclare package Medium=Medium,
		eff = eff_ext,
		use_input=false,
		T_fixed=T_cold_set) "Particle heat exchanger";

	SolarTherm.Models.PowerBlocks.HeatPB PB(
		redeclare package Medium=Medium,
		P_rate=P_gro,
		eff_adj=eff_adj) "Power block";

	SolarTherm.Models.PowerBlocks.GenericParasitics par(
		P_par_des=par_fr*P_gro,
		P_gross_des=P_gro,
		T_amb_des=par_T_amb_des,
		cf=par_cf,
		ca=par_ca) "Power block parasitics calculator";

	SolarTherm.Models.Sources.Schedule.Scheduler sch(
		file = sch_file,
		ndaily = 8,
		wmap = {{7, 7, 7, 7, 7, 7, 7}},
		mmap = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}) if not const_dispatch "Fixed dispatch schedule"; // TODO The schedule file content needs to be updated for this plant accordingly.

	SolarTherm.Models.Analysis.Performance per(schedule = true, pri_file = pri_file) "Plant energy/revenue calculator";

	SolarTherm.Models.Control.Trigger hf_trig(
		low=tnk_full_lb,
		up=tnk_full_ub,
		y_0=true) "Hot storage tank full trigger";

	SolarTherm.Models.Control.Trigger cf_trig(
		low=tnk_full_lb,
		up=tnk_full_ub,
		y_0=true) "Cold storage tank full trigger";

	SolarTherm.Models.Control.Trigger hne_trig(
		low=tnk_empty_lb,
		up=tnk_empty_ub,
		y_0=false) "Hot storage tank not empty (nominal) trigger";

	Modelica.Blocks.Math.Gain P(k=Kp) "Proportional gain for receiver temperature";

	// Variables
	Boolean radiance_good "Adequate radiant power on receiver";
	Boolean fill_htnk "Hot tank can be filled if true";
	Boolean fill_ctnk "Cold tank can be filled if true";
	Boolean empty_htnk "True if hot tank empty";

	Real sched "Particle disptach flow fraction";
	SI.Power P_elec(displayUnit="MW") "Generated power";
	SI.Energy E_elec(displayUnit="MW.h") "Generated electricity";
	FI.Money R_spot "Spot market revenue";

initial equation
	if fixed_field then
		P_gro = Q_flow_des * eff_cyc;
	else
		R_des = if match_sam then SM*Q_flow_des*(1 + rec_fr) else SM*Q_flow_des/(1 - rec_fr);
	end if;

equation
	connect(wea.wbus, CL.wbus);
	connect(wea.wbus, RC.wbus);
	connect(wea.wbus, PB.wbus);
	connect(wea.wbus, par.wbus);

	connect(CL.R_foc, RC.R);
	connect(STC.port_b, lift_rec.port_a);
	connect(lift_rec.port_b, RC.port_a);
	connect(RC.port_b, STH.port_a);

	connect(STH.port_b, lift_ext.port_a);
	connect(lift_ext.port_b, ext.port_a);

	connect(ext.port_b, lift_stc.port_a);
	connect(lift_stc.port_b, STC.port_a);

	connect(ext.Q_flow, PB.Q_flow);
	connect(ext.T, PB.T);

	connect(PB.P, par.P_gen);

	connect(hf_trig.x, STH.m);
	connect(cf_trig.x, STC.m);
	connect(hne_trig.x, STH.m);

	radiance_good = wea.wbus.dni >= dni_start;

	fill_htnk = not hf_trig.y;
	fill_ctnk = not cf_trig.y;
	empty_htnk = not hne_trig.y;

	RC.door_open = radiance_good;

	P.u = m_flow_fac;

	if radiance_good and fill_htnk then
		lift_rec.m_flow_set = P.y*sum(RC.R)/R_des; // TODO: This proportional control should be replaced with a PID feedback controller
		CL.defocus = false;
		CL.R_dfc = 0;
	elseif radiance_good and not fill_htnk then
		lift_rec.m_flow_set = m_flow_blk;
		CL.defocus = true;
		CL.R_dfc = lift_rec.m_flow_set*cp_set*(T_hot_set - T_cold_set)*1.28; // assuming ~20% losses in the receiver
	else
		lift_rec.m_flow_set = 0;
		CL.defocus = false;
		CL.R_dfc = 0;
	end if;

	lift_ext.m_flow_set = if fill_ctnk and not empty_htnk then m_flow_blk else 0;

	CL.track = true;

	P_elec = PB.P - (par.P_par + par_fix_fr*P_net + lift_rec.W + lift_ext.W + lift_stc.W); //TODO: add parasitic losses in the heliostat field and tanks
	connect(P_elec, per.P_elec);
	per.P_sch = sched * P_name;
	connect(per.E_elec, E_elec);
	connect(per.R_spot, R_spot);

	if const_dispatch then
		sched = 1;
	else
		connect(wea.wbus, sch.wbus);
		sched = sch.v;
	end if;

	annotation(experiment(StartTime=0.0, StopTime=31536000.0, Interval=60, Tolerance=1e-0
