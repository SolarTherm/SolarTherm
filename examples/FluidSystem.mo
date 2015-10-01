model FluidSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	replaceable package Med_Salt = Modelica.Media.Water.ConstantPropertyLiquidWater;

	inner Modelica.Fluid.System system(
		energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
		allowFlowReversal=false
		);
	// Can provide details of modelling accuracy, assumptions and initialisation

	parameter String weaFile = "resources/weatherfile1.motab";

	parameter SI.Area A_con = 1 "Concentrator area";
	parameter SI.Area A_rec = 1 "Receiver area";
	parameter Real em_steel = 0.85 "Emissivity of reciever";
	parameter SI.CoefficientOfHeatTransfer h_th_rec = 10; // guess
	parameter SI.Temperature T_cold_set = 300;
	parameter SI.Temperature T_cold_start = 300;
	parameter SI.Temperature T_hot_start = 350;

	SolarTherm.Utilities.Weather.WeatherSource wea(weaFile=weaFile);

	SolarTherm.Optics.IdealInc con(A_con=A_con, A_foc=A_rec, alt=0.0);

	SolarTherm.Receivers.Plate rec(
		redeclare package Medium=Med_Salt,
		A=A_rec, em=em_steel, h_th=h_th_rec);

	SolarTherm.Pumps.IdealPump pmp_rec(
		redeclare package Medium=Med_Salt,
		cont_m_flow=true,
		use_input=true
		);

	SolarTherm.Pumps.IdealPump pmp_exc(
		redeclare package Medium=Med_Salt,
		cont_m_flow=true,
		use_input=true
		);

	parameter Modelica.Fluid.Vessels.BaseClasses.VesselPortsData port_dat(
		diameter=0.1,
		height=0.0
		);
	Modelica.Fluid.Vessels.OpenTank ctnk(
		redeclare package Medium=Med_Salt,
		height=1,
		crossArea=1,
		level_start=0.5,
		nPorts=2,
		portsData={port_dat, port_dat},
		use_T_start=true,
		T_start=T_cold_start
		);
	Modelica.Fluid.Vessels.OpenTank htnk(
		redeclare package Medium=Med_Salt,
		height=1,
		crossArea=1,
		level_start=0.5,
		nPorts=2,
		portsData={port_dat, port_dat},
		use_T_start=true,
		T_start=T_hot_start
		);

	SolarTherm.HeatExchangers.Extractor ext(
		redeclare package Medium=Med_Salt,
		eff = 0.9,
		use_input=false,
		T_fixed=T_cold_set
		);

	SolarTherm.PowerBlocks.HeatGen pblk(
		eff_adj=0.6
		);
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

	pmp_rec.m_flow_set = 0.001;
	pmp_exc.m_flow_set = 0.001;

	con.track = true;
end FluidSystem;

