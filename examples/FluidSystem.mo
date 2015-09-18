model FluidSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

	inner Modelica.Fluid.System system(
		energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);

	parameter String weaFile = "resources/weatherfile1.motab";

	parameter SI.Area A_con = 1;

	parameter SI.Area A_rec = 1;
	parameter SI.Energy E_max = 1*3600*1000;
	parameter SI.Mass m_rec = 50;
	parameter SI.SpecificHeatCapacity c_steel = 450;
	parameter Real em_steel = 0.85;
	parameter SI.CoefficientOfHeatTransfer h_th_rec = 10; // guess

	parameter SI.Temperature T_cold = 300;

	parameter SI.Temperature T_set = 310;

	SolarTherm.Utilities.Weather.WeatherSource wea(weaFile=weaFile);
	SolarTherm.Optics.IdealAzi con(A_con=A_con, A_foc=A_rec, alt=45*CN.pi/180);
	SolarTherm.Receivers.Plate rec(
		redeclare package Medium=Medium,
		A=A_rec, m=m_rec, c=c_steel, em=em_steel, h_th=h_th_rec);
	Modelica.Fluid.Sources.MassFlowSource_T cold_source(
		redeclare package Medium=Medium,
		nPorts=1,
		use_m_flow_in=true, // set flow rate from input
		T=T_cold);
	SolarTherm.Storage.SinkInf sink;

	//SolarTherm.Receivers.Energy.FixedEff rec(A=A_rec, eff=0.8);
	//SolarTherm.Valves.Energy.Splitter spl;
	//SolarTherm.Storage.Energy.Infinite inf;
	//SolarTherm.Storage.Energy.Tank tnk(E_max=E_max, E_0=0.1*E_max);
	//SolarTherm.Pumps.Energy.Pump pmp(P_max=0.7*gen.P_max);
	//SolarTherm.PowerBlocks.Energy.Generator gen(eff=0.9, P_max=500);
	//SolarTherm.Control.Trigger ltrig(low=0.1*tnk.E_max, up=0.2*tnk.E_max);
	//SolarTherm.Control.Trigger utrig(low=0.8*tnk.E_max, up=0.9*tnk.E_max);
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
	connect(cold_source.ports[1], rec.port_a);
	connect(rec.port_b, sink.port_a);
	connect(cold_source.m_flow_in, m_flow);
	cold_source.ports[1].p = system.p_ambient;

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

	//connect(rec.p, spl.p_i);
	//connect(spl.p_o1, tnk.p);
	//connect(spl.p_o2, inf.p);
	//connect(tnk.p, pmp.p_i);
	//connect(pmp.p_o, gen.p);

	//connect(ltrig.x, tnk.E);
	//connect(utrig.x, tnk.E);
	//spl.frac = if utrig.y then 0.0 else 1.0; // Dump energy if hit top of tank
	//pmp.frac = if ltrig.y then 1.0 else 0.0; // Turn off gen when tank low
end FluidSystem;

