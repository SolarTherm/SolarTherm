model FluidSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import Modelica.Math.cos;
	//replaceable package MedRec = Modelica.Media.Water.ConstantPropertyLiquidWater;
	replaceable package MedRec = SolarTherm.Media.Sodium;

	inner Modelica.Fluid.System system(
		energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
		allowFlowReversal=false
		);
	// Can provide details of modelling accuracy, assumptions and initialisation

	parameter String weaFile = "resources/weatherfile1.motab";
	parameter String priFile = "resources/aemo_vic_2014.motab";

	parameter SI.Power P_rate = 20e3 "Rating of power block";
	parameter SI.Efficiency eff_adj = 0.80 "Adjustment factor for power block efficiency";
	parameter SI.Efficiency eff_est = 0.40 "Estimate of overall power block efficiency";

	parameter SI.Area A_con = 500 "Concentrator area";

	parameter SI.Area A_rec = 1 "Receiver area";
	parameter Real em_steel = 0.85 "Emissivity of reciever";
	parameter SI.CoefficientOfHeatTransfer h_th_rec = 10 "Receiver heat tran coeff";

	parameter Real t_storage(unit="hour") = 5 "Hours of storage";
	parameter SI.Mass m_max = (1/eff_est)*P_rate*t_storage*3600/ // only works with PartialSimpleMedium
		(MedRec.cp_const*(T_hot_set - T_cold_set)) "Max mass in tanks";
	parameter MedRec.Temperature T_cold_set = CV.from_degC(290) "Target cold tank T";
	parameter MedRec.Temperature T_hot_set = CV.from_degC(565) "Target hot tank T";
	parameter MedRec.Temperature T_cold_start = CV.from_degC(290) "Cold tank starting T";
	parameter MedRec.Temperature T_hot_start = CV.from_degC(565) "Hot tank starting T";
	parameter SI.RadiantPower R_go = 200*A_con "Receiver radiant power for running";
	parameter SI.MassFlowRate m_flow_fac = 1.2 "Mass flow factor for receiver";
	parameter SI.MassFlowRate m_flow_pblk = (1/eff_est)*P_rate/
		(MedRec.cp_const*(T_hot_set - T_cold_set)) "Mass flow rate for power block";
	parameter SI.Mass m_up_warn = 0.85*m_max;
	parameter SI.Mass m_up_stop = 0.95*m_max;
	parameter Real split_cold = 0.95 "Starting fluid fraction in cold tank";

	parameter SolarTherm.Utilities.Finances.Money C_cap =
		120*A_con // field cost
		+ 135*A_con // receiver cost
		+ (30/(1e3*3600))*m_max*MedRec.cp_const*(T_hot_set - T_cold_set) // storage cost
		+ (1440/1e3)*P_rate // power block cost
		;
	parameter SolarTherm.Utilities.Finances.MoneyPerYear C_main =
		10*A_con // field cleaning/maintenance
		;
	parameter Real r_disc = 0.05;
	parameter Integer t_life(unit="year") = 20;

	SolarTherm.Utilities.Weather.WeatherSource wea(weaFile=weaFile);
	SolarTherm.Utilities.Finances.SpotPriceTable pri(fileName=priFile);

	SolarTherm.Optics.IdealInc con(A_con=A_con, A_foc=A_rec);

	SolarTherm.Receivers.Plate rec(
		redeclare package Medium=MedRec,
		A=A_rec, em=em_steel, h_th=h_th_rec);

	SolarTherm.Pumps.IdealPump pmp_rec(
		redeclare package Medium=MedRec,
		cont_m_flow=true,
		use_input=true
		);

	SolarTherm.Pumps.IdealPump pmp_exc(
		redeclare package Medium=MedRec,
		cont_m_flow=true,
		use_input=true
		);

	SolarTherm.Storage.FluidTank ctnk(
		redeclare package Medium=MedRec,
		m_max=m_max,
		m_start=m_max*split_cold,
		T_start=T_cold_start
		);
	SolarTherm.Storage.FluidTank htnk(
		redeclare package Medium=MedRec,
		m_max=m_max,
		m_start=m_max*(1 - split_cold),
		T_start=T_hot_start
		);

	SolarTherm.HeatExchangers.Extractor ext(
		redeclare package Medium=MedRec,
		eff = 0.9,
		use_input=false,
		T_fixed=T_cold_set
		);

	SolarTherm.PowerBlocks.HeatGen pblk(
		P_rate=P_rate,
		eff_adj=eff_adj
		);

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
	SolarTherm.Utilities.Finances.Money R_spot(start=0, fixed=true)
		"Spot market revenue";
	SI.Energy E_elec(start=0, fixed=true) "Generate electricity";
equation
	connect(wea.wbus, con.wbus);
	connect(wea.wbus, rec.wbus);
	connect(wea.wbus, pblk.wbus);
	connect(con.R_foc, rec.R);
	connect(ctnk.port_b, pmp_rec.port_a);
	connect(pmp_rec.port_b, rec.port_a);
	connect(rec.port_b, htnk.port_a);

	connect(htnk.port_b, pmp_exc.port_a);
	connect(pmp_exc.port_b, ext.port_a);
	connect(ext.port_b, ctnk.port_a);

	connect(ext.Q_flow, pblk.Q_flow);
	connect(ext.T, pblk.T);

	connect(hf_trig.x, htnk.m);
	connect(cf_trig.x, ctnk.m);

	radiance_good = rec.R >= R_go;

	fill_htnk = not hf_trig.y;
	fill_ctnk = not cf_trig.y;

	rec.door_open = radiance_good and fill_htnk;
	pmp_rec.m_flow_set = if radiance_good and fill_htnk then m_flow_fac*rec.R/(A_con*1000) else 0;
	pmp_exc.m_flow_set = if fill_ctnk then m_flow_pblk else 0;

	con.track = true;

	P_elec = pblk.P_elec;
	der(E_elec) = P_elec;
	der(R_spot) = P_elec*pri.price;
end FluidSystem;

