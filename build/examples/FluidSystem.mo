within examples;
model FluidSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Models.Analysis.Finances;

	extends Modelica.Icons.Example;
	//replaceable package MedRec = Modelica.Media.Water.ConstantPropertyLiquidWater;
	replaceable package MedRec = SolarTherm.Media.Sodium.ConstSodium;
	//replaceable package MedRec = SolarTherm.Media.Sodium;

	inner Modelica.Fluid.System system(
		energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
		allowFlowReversal=false);
	// Can provide details of modelling accuracy, assumptions and initialisation

	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Mildura_Real2010_Created20130430.motab");
	parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab");
	
	parameter SI.Power P_name = 100000 "Nameplate rating of power block";
	parameter SI.Efficiency eff_adj = 0.9 "Adjustment factor for power block efficiency";
	parameter SI.Efficiency eff_est = 0.48 "Estimate of overall power block efficiency";

	parameter SI.Area A_col = 700 "Collector area";

	parameter SI.Area A_rec = 1 "Receiver area";
	parameter Real em_steel = 0.85 "Emissivity of reciever";
	parameter SI.CoefficientOfHeatTransfer h_th_rec = 10 "Receiver heat tran coeff";

	parameter SI.Efficiency eff_ext = 0.9 "Extractor efficiency";

	parameter Real t_storage(unit="h") = 5 "Hours of storage";
	//parameter SI.Mass m_max = (1/eff_est)*P_name*t_storage*3600/
	//	(MedRec.cp_const*(T_hot_set - T_cold_set)) "Max mass in tanks";
		// only works with PartialSimpleMedium
	parameter SI.Mass m_max = (1/eff_est)*P_name*t_storage*3600/
		(1277*(T_hot_set - T_cold_set)) "Max mass in tanks";
	parameter MedRec.Temperature T_cold_set = CV.from_degC(290) "Target cold tank T";
	parameter MedRec.Temperature T_hot_set = CV.from_degC(565) "Target hot tank T";
	parameter MedRec.Temperature T_cold_start = CV.from_degC(290) "Cold tank starting T";
	parameter MedRec.Temperature T_hot_start = CV.from_degC(565) "Hot tank starting T";
	parameter SI.RadiantPower R_go = 200*A_col "Receiver radiant power for running";
	parameter SI.MassFlowRate m_flow_fac = 1.2 "Mass flow factor for receiver";
	//parameter SI.MassFlowRate m_flow_blk = (1/eff_est)*P_name/
	//	(MedRec.cp_const*(T_hot_set - T_cold_set)) "Mass flow rate for power block";
		// only works with PartialSimpleMedium
	parameter SI.MassFlowRate m_flow_blk = (1/eff_est)*P_name/
		(1277*(T_hot_set - T_cold_set)) "Mass flow rate for power block";
	parameter SI.Mass m_up_warn = 0.85*m_max;
	parameter SI.Mass m_up_stop = 0.95*m_max;
	parameter Real split_cold = 0.95 "Starting fluid fraction in cold tank";

	parameter FI.Money C_field = 120*A_col "Field cost";
	parameter FI.Money C_site = 0 "Site improvements cost";
	parameter FI.Money C_tower = 0 "Tower cost";
	parameter FI.Money C_receiver = 135*A_col "Receiver cost";
	parameter FI.Money C_storage = (30/(1e3*3600))*m_max*1277*(T_hot_set - T_cold_set) "Storage cost";
	//parameter FI.Money C_storage = (30/(1e3*3600))*m_max*MedRec.cp_const*(T_hot_set - T_cold_set) "Storage cost"; // only works with PartialSimpleMedium
	parameter FI.Money C_block = (1440/1e3)*P_name "Power block cost";
	parameter FI.Money C_bop = 0 "Balance of plant cost";
	parameter FI.Money C_land = 0 "Land cost";
	parameter FI.Money C_cap = C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop + C_land "Capital costs";

	parameter FI.MoneyPerYear C_year =
			10*A_col // field cleaning/maintenance
			"Cost per year";
	parameter Real C_prod(unit="$/J/year") = 0 "Cost per production per year";
	parameter Real r_disc = 0.05 "Discount rate";
	parameter Integer t_life(unit="year") = 20 "Lifetime of plant";
	parameter Integer t_cons(unit="year") = 1 "Years of construction";

	SolarTherm.Models.Sources.Weather.WeatherSource wea(file=wea_file);
	SolarTherm.Models.Analysis.Finances.SpotPriceTable pri(file=pri_file);

	SolarTherm.Models.CSP.CRS.HeliostatsField.SwitchedCL CL(
		redeclare model OptEff=SolarTherm.Models.CSP.CRS.HeliostatsField.IdealIncOE(alt_fixed=45),
		orient_north=wea.orient_north,
		A=A_col
		);

	SolarTherm.Models.CSP.CRS.Receivers.PlateRC RC(
		redeclare package Medium=MedRec,
		A=A_rec, em=em_steel, ab=em_steel, h_th=h_th_rec); // (em used for absorptivity)

	SolarTherm.Models.Fluid.Pumps.IdealPump pmp_rec(
		redeclare package Medium=MedRec,
		cont_m_flow=true,
		use_input=true);
	SolarTherm.Models.Fluid.Pumps.IdealPump pmp_ext(
		redeclare package Medium=MedRec,
		cont_m_flow=true,
		use_input=true);

	SolarTherm.Models.Storage.Tank.FluidST STC(
		redeclare package Medium=MedRec,
		m_max=m_max,
		m_start=m_max*split_cold,
		T_start=T_cold_start);

	SolarTherm.Models.Storage.Tank.FluidST STH(
		redeclare package Medium=MedRec,
		m_max=m_max,
		m_start=m_max*(1 - split_cold),
		T_start=T_hot_start);

	SolarTherm.Models.Fluid.HeatExchangers.Extractor ext(
		redeclare package Medium=MedRec,
		eff = eff_ext,
		use_input=false,
		T_fixed=T_cold_set);

	SolarTherm.Models.PowerBlocks.HeatPB PB(
		redeclare package Medium=MedRec,
		P_rate=P_name,
		eff_adj=eff_adj);

	SolarTherm.Models.Control.Trigger hf_trig(
		low=m_up_warn,
		up=m_up_stop,
		y_0=true);
	SolarTherm.Models.Control.Trigger cf_trig(
		low=m_up_warn,
		up=m_up_stop,
		y_0=true);

	Boolean radiance_good "Adequate radiant power on receiver";
	Boolean fill_htnk "Hot tank can be filled";
	Boolean fill_ctnk "Cold tank can be filled";

	SI.Power P_elec;
	FI.Money R_spot(start=0, fixed=true) "Spot market revenue";
	SI.Energy E_elec(start=0, fixed=true) "Generate electricity";
equation
	connect(wea.wbus, CL.wbus);
	connect(wea.wbus, RC.wbus);
	connect(wea.wbus, PB.wbus);
	connect(CL.R_foc, RC.R);
	connect(STC.port_b, pmp_rec.port_a);
	connect(pmp_rec.port_b, RC.port_a);
	connect(RC.port_b, STH.port_a);

	connect(STH.port_b, pmp_ext.port_a);
	connect(pmp_ext.port_b, ext.port_a);
	connect(ext.port_b, STC.port_a);

	connect(ext.Q_flow, PB.Q_flow);
	connect(ext.T, PB.T);

	connect(hf_trig.x, STH.m);
	connect(cf_trig.x, STC.m);

	radiance_good = sum(RC.R) >= R_go;

	fill_htnk = not hf_trig.y;
	fill_ctnk = not cf_trig.y;

	RC.door_open = radiance_good and fill_htnk;
	pmp_rec.m_flow_set = if radiance_good and fill_htnk then
		m_flow_fac*sum(RC.R)/(A_col*1000) else 0;
	pmp_ext.m_flow_set = if fill_ctnk then m_flow_blk else 0;

	CL.track = true;

	P_elec = PB.P;
	der(E_elec) = P_elec;
	der(R_spot) = P_elec*pri.price;
	annotation(experiment(StartTime=0.0, StopTime=31536000.0, Interval=60, Tolerance=1e-06));
end FluidSystem;

