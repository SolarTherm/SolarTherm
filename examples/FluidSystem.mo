model FluidSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Analysis.Finances;
	//replaceable package MedRec = Modelica.Media.Water.ConstantPropertyLiquidWater;
	replaceable package MedRec = SolarTherm.Media.ConstSodium;
	//replaceable package MedRec = SolarTherm.Media.Sodium;

	inner Modelica.Fluid.System system(
		energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
		allowFlowReversal=false);
	// Can provide details of modelling accuracy, assumptions and initialisation

	parameter String weaFile = "resources/weather/Mildura_Real2010_Created20130430.motab";
	parameter String priFile = "resources/prices/aemo_vic_2014.motab";

	parameter SI.Power P_name = 100000 "Nameplate rating of power block";
	parameter SI.Efficiency eff_adj = 0.9 "Adjustment factor for power block efficiency";
	parameter SI.Efficiency eff_est = 0.48 "Estimate of overall power block efficiency";

	parameter SI.Area A_con = 700 "Concentrator area";

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
	parameter SI.RadiantPower R_go = 200*A_con "Receiver radiant power for running";
	parameter SI.MassFlowRate m_flow_fac = 1.2 "Mass flow factor for receiver";
	//parameter SI.MassFlowRate m_flow_blk = (1/eff_est)*P_name/
	//	(MedRec.cp_const*(T_hot_set - T_cold_set)) "Mass flow rate for power block";
		// only works with PartialSimpleMedium
	parameter SI.MassFlowRate m_flow_blk = (1/eff_est)*P_name/
		(1277*(T_hot_set - T_cold_set)) "Mass flow rate for power block";
	parameter SI.Mass m_up_warn = 0.85*m_max;
	parameter SI.Mass m_up_stop = 0.95*m_max;
	parameter Real split_cold = 0.95 "Starting fluid fraction in cold tank";

	parameter FI.Money C_cap =
			120*A_con // field cost
			+ 135*A_con // receiver cost
			//+ (30/(1e3*3600))*m_max*MedRec.cp_const*(T_hot_set - T_cold_set) // storage cost
			// only works with PartialSimpleMedium
			+ (30/(1e3*3600))*m_max*1277*(T_hot_set - T_cold_set) // storage cost
			+ (1440/1e3)*P_name // power block cost
			"Capital cost";
	parameter FI.MoneyPerYear C_year =
			10*A_con // field cleaning/maintenance
			"Cost per year";
	parameter Real C_prod(unit="$/W/year") = 0 "Cost per production per year";
	parameter Real r_disc = 0.05 "Discount rate";
	parameter Integer t_life(unit="year") = 20 "Lifetime of plant";
	parameter Integer t_cons(unit="year") = 1 "Years of construction";

	SolarTherm.Sources.Weather.WeatherSource wea(weaFile=weaFile);
	SolarTherm.Analysis.Finances.SpotPriceTable pri(fileName=priFile);

	SolarTherm.Collectors.SwitchedCL con(
		redeclare model OptEff=SolarTherm.Collectors.IdealIncOE(alt_fixed=45),
		A_con=A_con
		);

	SolarTherm.Receivers.Plate rec(
		redeclare package Medium=MedRec,
		A=A_rec, em=em_steel, h_th=h_th_rec);

	SolarTherm.Fluid.Pumps.IdealPump pmp_rec(
		redeclare package Medium=MedRec,
		cont_m_flow=true,
		use_input=true);
	SolarTherm.Fluid.Pumps.IdealPump pmp_ext(
		redeclare package Medium=MedRec,
		cont_m_flow=true,
		use_input=true);

	SolarTherm.Storage.FluidTank ctnk(
		redeclare package Medium=MedRec,
		m_max=m_max,
		m_start=m_max*split_cold,
		T_start=T_cold_start);
	SolarTherm.Storage.FluidTank htnk(
		redeclare package Medium=MedRec,
		m_max=m_max,
		m_start=m_max*(1 - split_cold),
		T_start=T_hot_start);

	SolarTherm.Fluid.HeatExchangers.Extractor ext(
		redeclare package Medium=MedRec,
		eff = eff_ext,
		use_input=false,
		T_fixed=T_cold_set);

	SolarTherm.PowerBlocks.HeatPB blk(
		redeclare package Medium=MedRec,
		P_rate=P_name,
		eff_adj=eff_adj);

	SolarTherm.Control.Trigger hf_trig(
		low=m_up_warn,
		up=m_up_stop,
		y_0=true);
	SolarTherm.Control.Trigger cf_trig(
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
	connect(wea.wbus, con.wbus);
	connect(wea.wbus, rec.wbus);
	connect(wea.wbus, blk.wbus);
	connect(con.R_foc, rec.R);
	connect(ctnk.port_b, pmp_rec.port_a);
	connect(pmp_rec.port_b, rec.port_a);
	connect(rec.port_b, htnk.port_a);

	connect(htnk.port_b, pmp_ext.port_a);
	connect(pmp_ext.port_b, ext.port_a);
	connect(ext.port_b, ctnk.port_a);

	connect(ext.Q_flow, blk.Q_flow);
	connect(ext.T, blk.T);

	connect(hf_trig.x, htnk.m);
	connect(cf_trig.x, ctnk.m);

	radiance_good = sum(rec.R) >= R_go;

	fill_htnk = not hf_trig.y;
	fill_ctnk = not cf_trig.y;

	rec.door_open = radiance_good and fill_htnk;
	pmp_rec.m_flow_set = if radiance_good and fill_htnk then
		m_flow_fac*sum(rec.R)/(A_con*1000) else 0;
	pmp_ext.m_flow_set = if fill_ctnk then m_flow_blk else 0;

	con.track = true;

	P_elec = blk.P;
	der(E_elec) = P_elec;
	der(R_spot) = P_elec*pri.price;
end FluidSystem;

