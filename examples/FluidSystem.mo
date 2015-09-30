model FluidSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	replaceable package Med_Salt = Modelica.Media.Water.ConstantPropertyLiquidWater;
	replaceable package Med_Pwr = Modelica.Media.Water.ConstantPropertyLiquidWater;

	inner Modelica.Fluid.System system(
		energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
		allowFlowReversal=false
		);
	// Can provide details of modelling accuracy, assumptions and initialisation

	parameter String weaFile = "resources/weatherfile1.motab";

	parameter SI.Area A_con = 1;

	parameter SI.Area A_rec = 1;
	parameter SI.Energy E_max = 1*3600*1000;
	parameter SI.Mass m_rec = 50;
	parameter SI.SpecificHeatCapacity c_steel = 450;
	parameter Real em_steel = 0.85;
	parameter SI.CoefficientOfHeatTransfer h_th_rec = 10; // guess

	parameter SI.Temperature T_set = 310;

	SolarTherm.Utilities.Weather.WeatherSource wea(weaFile=weaFile);
	SolarTherm.Optics.IdealInc con(A_con=A_con, A_foc=A_rec, alt=0.0);
	SolarTherm.Receivers.Plate rec(
		redeclare package Medium=Med_Salt,
		A=A_rec, m=m_rec, c=c_steel, em=em_steel, h_th=h_th_rec);

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

	SolarTherm.Pumps.IdealPump pmp_blk(
		redeclare package Medium=Med_Pwr,
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
		T_start=300
		);
	Modelica.Fluid.Vessels.OpenTank htnk(
		redeclare package Medium=Med_Salt,
		height=1,
		crossArea=1,
		level_start=0.5,
		nPorts=2,
		portsData={port_dat, port_dat},
		use_T_start=true,
		T_start=300
		);

	SolarTherm.HeatExchangers.BasicHE hex(
		redeclare package Medium1=Med_Salt,
		redeclare package Medium2=Med_Pwr
		);

	Modelica.Fluid.Sources.Boundary_pT pblock_source(
		redeclare package Medium=Med_Pwr,
		nPorts=1,
		p=200000,
		T=300
		);

	SolarTherm.PowerBlocks.BasicPB pblk(
		redeclare package Medium=Med_Pwr,
		p_set_outlet=100000,
		T_set_outlet=300
		);

	SolarTherm.Storage.SinkInf pblock_sink(
		redeclare package Medium=Med_Pwr
		);

	SI.MassFlowRate m_flow;
	SI.Temperature error_over;
	//Modelica.Blocks.Continuous.PID pid(k=0.01, Ti=1e2, Td=0,
	//	initType=Modelica.Blocks.Types.InitPID.InitialState,
	//	xi_start=0,
	//	xd_start=0);
	// Derivative part causes problems, probably because input is not
	// differentiable.
equation
	connect(wea.wbus, con.wbus);
	connect(wea.wbus, rec.wbus);
	connect(con.R_foc, rec.R);
	connect(ctnk.ports[1], pmp_rec.port_a);
	connect(pmp_rec.port_b, rec.port_a);
	connect(rec.port_b, htnk.ports[1]);

	connect(htnk.ports[2], pmp_exc.port_a);
	connect(pmp_exc.port_b, hex.port_1a);
	connect(hex.port_1b, ctnk.ports[2]);

	connect(pblock_source.ports[1], pmp_blk.port_a);
	connect(pmp_blk.port_b, hex.port_2a);
	connect(hex.port_2b, pblk.port_a);
	connect(pblk.port_b, pblock_sink.port_a);

	connect(m_flow, pmp_rec.m_flow_in);
	pmp_exc.m_flow_in = 0.001;
	
	pmp_blk.m_flow_in = 0.001;

	con.track = true;

	// m_flow needs to be set as it provides an input to another model
	// Can't just add integrator here because it will continue to accumulate
	// when below set point.  Actually could modify input so that if it falls
	// below set point input is zero.
	error_over = max(rec.T - T_set, 0.0);
	//m_flow = 0.0;
	m_flow = 0.01*error_over;
	//pid.u = error_over;
	////pid.u = rec.T - T_set;
	//m_flow = max(pid.y, 0.0);
	// It latches on here, doesn't turn off when power goes below
	// Might need to build own controller integrator state limit
	// Actually that probably wouldn't work either

end FluidSystem;

