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

	// When heat fluid is removed from cold tank (none entering), the temperature
	// creeps up.  It seems link this might be a numerical error as the specific
	// internal energy is calculated from the total internal energy of the tank.
	// The latter can be a huge numerical value.
	// The change in total internal energy is calculated from the mass flows
	// in and out of the tank.  If there is some mismatch between the total mass
	// and the flow mass then a sizeable temperature creep (5deg) can occur...

	parameter String weaFile = "resources/weatherfile1.motab";

	parameter SI.Area A_con = 500 "Concentrator area";
	parameter SI.Area A_rec = 1 "Receiver area";
	parameter Real em_steel = 0.85 "Emissivity of reciever";
	parameter SI.CoefficientOfHeatTransfer h_th_rec = 10; // guess
	parameter SI.Time t_storage = 0; // need to calc values below based on this
	parameter SI.Area A_tnk = 10;
	parameter SI.Length L_tnk = 5;
	parameter Real split_cold = 0.8; // level split in cold tank
	parameter MedRec.Temperature T_cold_set = CV.from_degC(290);
	parameter MedRec.Temperature T_cold_start = CV.from_degC(290);
	parameter MedRec.Temperature T_hot_start = CV.from_degC(565);
	parameter SI.RadiantPower R_go = 200*A_con;

	SolarTherm.Utilities.Weather.WeatherSource wea(weaFile=weaFile);

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

	//parameter Modelica.Fluid.Vessels.BaseClasses.VesselPortsData port_dat(
	//	diameter=0.1,
	//	height=0.0
	//	);
	Modelica.Fluid.Vessels.OpenTank ctnk(
		redeclare package Medium=MedRec,
		height=L_tnk,
		crossArea=A_tnk,
		level_start=L_tnk*split_cold,
		nPorts=2,
		use_T_start=true,
		T_start=T_cold_start,
		use_HeatTransfer=false,
		use_portsData=false
		//portsData={port_dat, port_dat}
		);
	Modelica.Fluid.Vessels.OpenTank htnk(
		redeclare package Medium=MedRec,
		height=L_tnk,
		crossArea=A_tnk,
		level_start=L_tnk*(1 - split_cold),
		nPorts=2,
		use_T_start=true,
		T_start=T_hot_start,
		use_HeatTransfer=false,
		use_portsData=false
		//portsData={port_dat, port_dat}
		);

	SolarTherm.HeatExchangers.Extractor ext(
		redeclare package Medium=MedRec,
		eff = 0.9,
		use_input=false,
		T_fixed=T_cold_set
		);

	SolarTherm.PowerBlocks.HeatGen pblk(
		eff_adj=0.6
		);

	SolarTherm.Control.Trigger hf_trig(low=0.8*L_tnk, up=0.9*L_tnk);
	SolarTherm.Control.Trigger cf_trig(low=0.8*L_tnk, up=0.9*L_tnk);

	Boolean radiance_good "Adequate radiant power on receiver";
	Boolean fill_htnk "Hot tank can be filled";
	Boolean fill_ctnk "Cold tank can be filled";
equation
	connect(wea.wbus, con.wbus);
	connect(wea.wbus, rec.wbus);
	connect(wea.wbus, pblk.wbus);
	connect(con.R_foc, rec.R);
	connect(ctnk.ports[1], pmp_rec.port_a);
	connect(pmp_rec.port_b, rec.port_a);
	connect(rec.port_b, htnk.ports[1]);

	//connect(htnk.ports[2], pmp_exc.port_a);
	//connect(pmp_exc.port_b, ctnk.ports[2]);

	connect(htnk.ports[2], pmp_exc.port_a);
	connect(pmp_exc.port_b, ext.port_a);
	connect(ext.port_b, ctnk.ports[2]);

	connect(ext.Q_flow, pblk.Q_flow);
	connect(ext.T, pblk.T);

	radiance_good = rec.R >= R_go;
	connect(hf_trig.x, htnk.level);
	connect(cf_trig.x, ctnk.level);

	fill_htnk = not hf_trig.y;
	fill_ctnk = not cf_trig.y;

	rec.door_open = radiance_good and fill_htnk;
	pmp_rec.m_flow_set = if radiance_good and fill_htnk then 1.2*rec.R/(A_con*1000) else 0;
	pmp_exc.m_flow_set = if fill_ctnk then 0.3 else 0;

	con.track = true;
end FluidSystem;

