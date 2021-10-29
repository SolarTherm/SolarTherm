within SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB;
	model recompPB
		extends SolarTherm.Media.CO2.PropCO2;
		import SI = Modelica.SIunits;
		import FI = SolarTherm.Models.Analysis.Finances;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
		//input SolarTherm.Interfaces.Connectors.WeatherBus wbus;
		extends Icons.PowerBlock;
		//	Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = MedRec) annotation(
		//		Placement(visible = true,transformation(extent = {{-54, 22}, {-34, 42}}, rotation = 0), iconTransformation(extent = {{-48, 28}, {-40, 36}}, rotation = 0)));
		//	Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = MedRec) annotation(
		//		Placement(transformation(extent = {{-74, -60}, {-54, -40}}), iconTransformation(extent = {{-62, -48}, {-54, -40}})));
		Modelica.Blocks.Interfaces.RealOutput W_net(quantity = "Power", unit = "W", displayUnit = "W") "Net electric power output" annotation(
			Placement(visible = true, transformation(extent = {{78, -22}, {98, -2}}, rotation = 0), iconTransformation(extent = {{48, -12}, {58, -2}}, rotation = 0)));
		// PB parameters
		parameter Boolean external_parasities = false "= true enable parasities as an input";
		parameter Real nu_min = 0.25 "Minimum turbine operation";
		Modelica.Blocks.Interfaces.RealInput parasities if external_parasities annotation(
			Placement(transformation(extent = {{-12, -12}, {12, 12}}, rotation = -90, origin = {1.77636e-015, 80}), iconTransformation(extent = {{-6, -6}, {6, 6}}, rotation = -90, origin = {20, 60})));
		input SI.ThermodynamicTemperature T_amb;
		//Cycle parameters
		parameter SI.AbsolutePressure p_high = 200 * 10 ^ 5 "high pressure of the cycle";
		parameter SI.ThermodynamicTemperature T_high = 715 + 273.15 "inlet temperature of the turbine";
		parameter SI.ThermodynamicTemperature T_amb_des = 30 + 273.15 "ambiant temperature";
		parameter Real PR = 2.5 "Pressure ratio";
		parameter SI.Power P_gro = 100 * 10 ^ 6 "first guess of power outlet";
		parameter SI.Power P_nom(fixed = false) "Electrical power at design point";
		parameter SI.MassFlowRate m_HTF_des = 1000 "Mass flow rate at design point";
		parameter Real gamma = 0.28 "Part of the mass flow going to the recompression directly";
		parameter SI.AngularVelocity[4] choiceN = {75000, 30000, 10000, 3600} * 0.10471975512;
		parameter SI.AngularVelocity N_shaft = choiceN[integer(Modelica.Math.log(P_gro / 10 ^ 6) / Modelica.Math.log(10)) + 2];
		// main Compressor parameters
		parameter SI.Efficiency eta_comp_main = 0.89 "Maximal isentropic efficiency of the compressors";
		// reCompressor parameters
		parameter SI.Efficiency eta_comp_re = 0.89 "Maximal isentropic efficiency of the compressors";
		//Turbine parameters
		parameter SI.Efficiency eta_turb = 0.93 "Maximal isentropic efficiency of the turbine";
		//HTR Heat recuperator parameters
		parameter Integer N_HTR = 15;
		//LTR Heat recuperator parameters
		parameter Integer N_LTR = 15;
		parameter Real ratio_m_des = 1 - gamma;
		//Cooler parameters
		parameter SI.ThermodynamicTemperature T_low = 45 + 273.15 "Outlet temperature of the cooler";
		//Exchanger parameters
		parameter SI.ThermodynamicTemperature T_HTF_in_des = 800 + 273.15;
		parameter Integer N_exch = 5;
		//Financial analysis
		parameter FI.Money C_HTR(fixed = false) "cost of the high temperature heat recuperator";
		parameter FI.Money C_LTR(fixed = false) "cost of the low temperature heat recuperator";
		parameter FI.Money C_turbine(fixed = false) "cost of the turbine";
		parameter FI.Money C_mainCompressor(fixed = false) "cost of the main compressor";
		parameter FI.Money C_reCompressor(fixed = false) "cost of the re compressor";
		parameter FI.Money C_exchanger(fixed = false) "cost of the exchanger";
		parameter FI.Money C_generator(fixed = false) "cost of the generator";
		parameter FI.Money C_cooler(fixed = false) "cost of the cooler";
		parameter FI.Money C_PB(fixed = false) "Overall cost of the power block";
		parameter FI.Money pri_exchanger = 150 "price of the primary exchanger in $/(kW_th). Objective for next-gen CSP with particles";
		//Results
		SI.Efficiency eta_cycle;
		SI.Energy E_net(final start = 0, fixed = true, displayUnit = "MW.h");
		Boolean m_sup "Disconnect the production of electricity when the outlet pressure of the turbine is close to the critical pressure";
		//Components instanciation
		SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.HeatRecuperatorDTAve HTR(N_q = N_HTR, P_nom_des = P_gro, ratio_m_des = 1) annotation(
			Placement(visible = true, transformation(origin = {12, -22}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.CompressorOnShaft mainCompressor(eta_design = eta_comp_main, N_design = N_shaft, P_nom_des = P_gro, p_high_des = p_high) annotation(
			Placement(visible = true, transformation(origin = {-74, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.Cooler cooler(T_low = T_low, P_nom_des = P_gro, T_amb_des = T_amb_des) annotation(
			Placement(visible = true, transformation(origin = {-78, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.Turbine turbine(PR = PR, N_shaft = N_shaft, eta_design = eta_turb) annotation(
			Placement(visible = true, transformation(origin = {66, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.Exchanger exchanger(redeclare package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph, P_nom_des = P_gro, T_out_CO2_des = T_high, N_exch = N_exch, ratio_m_des = 1) annotation(
			Placement(visible = true, transformation(extent = {{34, -8}, {54, 12}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.CompressorOnShaft reCompressor(N_design = N_shaft, P_nom_des = P_gro, p_high_des = p_high) annotation(
			Placement(visible = true, transformation(origin = {-54, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.HeatRecuperatorDTAve LTR(N_q = N_LTR, P_nom_des = P_gro, ratio_m_des = 1 - gamma) annotation(
			Placement(visible = true, transformation(origin = {-42, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.FlowMixer mixer annotation(
			Placement(visible = true, transformation(origin = {-20, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.FlowSplitter splitter(gamma = gamma) annotation(
			Placement(visible = true, transformation(origin = {-62, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		parameter MedRec.ThermodynamicState state_HTF_in_des = MedRec.setState_pTX(1.0325 * 10 ^ 5, T_HTF_in_des);
		//		 SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow src(T_out = 800+273.15, p_out = 10 ^ 5, m_flow = exchanger.m_HTF_des, redeclare package MedPB = SolarTherm.Media.SolidParticles.CarboHSP_ph, use_m_parameter = true) annotation(
		//				Placement(visible = true, transformation(origin = {-52, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
		//			SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink annotation(
		//				Placement(visible = true, transformation(origin = {-50, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		// Modelica.Blocks.Interfaces.RealInput parasities_internal;
	protected
	initial equation
		exchanger.h_in_HTF_des = MedRec.specificEnthalpy(state_HTF_in_des);
		exchanger.p_in_HTF_des = state_HTF_in_des.p;
		exchanger.m_HTF_des = m_HTF_des;
		P_nom = (-turbine.W_turb_des) - mainCompressor.W_comp_des - reCompressor.W_comp_des - cooler.P_cool_des;
// enthalpy equalities
//main loop
		exchanger.h_in_CO2_des = HTR.h_out_comp_des;
		turbine.h_in_des = exchanger.h_out_CO2_des;
		HTR.h_in_turb_des = turbine.h_out_des;
		LTR.h_in_turb_des = HTR.h_out_turb_des;
		cooler.h_in_des = LTR.h_out_turb_des;
		mainCompressor.h_in_des = cooler.h_out_des;
		LTR.h_in_comp_des = mainCompressor.h_out_des;
// recompression loop
		reCompressor.h_in_des = LTR.h_out_turb_des;
		HTR.h_in_comp_des = ratio_m_des * LTR.h_out_comp_des + (1 - ratio_m_des) * reCompressor.h_out_des;
//pressure equalities
//main loop
		exchanger.p_in_CO2_des = HTR.p_out_comp_des;
		turbine.p_in_des = exchanger.p_out_CO2_des;
		HTR.p_in_turb_des = turbine.p_out_des;
		LTR.p_in_turb_des = HTR.p_out_turb_des;
		cooler.p_in_des = LTR.p_out_turb_des;
		mainCompressor.p_in_des = cooler.p_out_des;
		LTR.p_in_comp_des = mainCompressor.p_out_des;
//recompression loop
		reCompressor.p_in_des = LTR.p_out_turb_des;
		HTR.p_in_comp_des = ratio_m_des * LTR.p_out_comp_des + (1 - ratio_m_des) * reCompressor.p_out_des;
//mass flow equalities
//main loop
//exchanger.m_CO2_des = HTR.m_comp_des;
		turbine.m_des = exchanger.m_CO2_des;
		HTR.m_turb_des = turbine.m_des;
		LTR.m_turb_des = HTR.m_turb_des;
		cooler.m_des = LTR.m_turb_des * ratio_m_des;
		mainCompressor.m_des = cooler.m_des;
		LTR.m_comp_des = mainCompressor.m_des;
//recompression loop
		HTR.m_comp_des = reCompressor.m_des + LTR.m_comp_des;
		reCompressor.m_des = gamma * LTR.m_turb_des;
// Financial Analysis
		C_HTR = if HTR.T_turb_des[N_HTR] >= 550 + 273.15 then 49.45 * HTR.UA_HTR ^ 0.7544 * (1 + 0.02141 * (HTR.T_turb_des[N_HTR] - 550 - 273.15)) else 49.45 * HTR.UA_HTR ^ 0.7544;
		C_LTR = 49.45 * LTR.UA_HTR ^ 0.7544;
		C_turbine = if exchanger.T_CO2_des[2] >= 550 + 273.15 then 406200 * (-turbine.W_turb_des / 10 ^ 6) ^ 0.8 * (1 + 1.137 * 10 ^ (-5) * (exchanger.T_CO2_des[2] - 550 - 273.15) ^ 2) else 406200 * (-turbine.W_turb_des / 10 ^ 6) ^ 0.8;
		C_mainCompressor = 1230000 * (mainCompressor.W_comp_des / 10 ^ 6) ^ 0.3392;
		C_reCompressor = 1230000 * (reCompressor.W_comp_des / 10 ^ 6) ^ 0.3392;
		C_cooler = 32.88 * cooler.UA_cooler ^ 0.75;
		C_generator = 108900 * (P_nom / 10 ^ 6) ^ 0.5463;
		C_exchanger = pri_exchanger * exchanger.Q_HX_des * m_HTF_des / 1000;
		C_PB = (C_HTR + C_LTR + C_turbine + C_mainCompressor + C_reCompressor + C_generator + C_cooler + C_exchanger) * 1.05;
// 1.05 corresponds to inflation from 2017, as correlations are in 2017' dollars.
	equation
		connect(m_sup, exchanger.m_sup) annotation(
			Line);
		connect(exchanger.CO2_port_b, turbine.port_a) annotation(
			Line(points = {{50, -4}, {64.2, -4}, {64.2, -23.8}, {62.2, -23.8}, {62.2, -25.8}}, color = {0, 127, 255}));
		connect(exchanger.CO2_port_a, HTR.from_comp_port_b) annotation(
			Line(points = {{37, -4}, {22.8, -4}, {22.8, -13.6}}, color = {0, 127, 255}));
//	connect(fluid_b, exchanger.HTF_port_b) annotation(
//		Line(points = {{-64, -50}, {12, -50}, {12, 10}, {38, 10}, {38, 10}}, color = {0, 127, 255}));
//	connect(fluid_a, exchanger.HTF_port_a) annotation(
//		Line(points = {{-44, 32}, {54, 32}, {54, 10}, {52, 10}, {52, 10}}, color = {0, 127, 255}));
//connect(src.port_b, fluid_a) annotation(
//	Line(points = {{-60, 64}, {-72, 64}, {-72, 30}, {-42, 30}, {-42, 32}, {-44, 32}}, color = {0, 127, 255}));
//connect(sink.port_a, fluid_b) annotation(
//	Line(points = {{-42, -78}, {-64, -78}, {-64, -54}, {-64, -54}, {-64, -50}}, color = {0, 127, 255}));
//if external_parasities then
//		connect(parasities_internal,parasities);
//	else
//		parasities_internal=0;
//	end if;
		connect(LTR.from_turb_port_b, splitter.port_a) annotation(
			Line(points = {{-50, -34}, {-54, -34}, {-54, -36}, {-54, -36}}, color = {0, 127, 255}));
		connect(LTR.from_turb_port_a, HTR.from_turb_port_b) annotation(
			Line(points = {{-36, -34}, {0, -34}, {0, -32}, {0, -32}}, color = {0, 127, 255}));
		connect(reCompressor.port_b, mixer.second_port_a) annotation(
			Line(points = {{-50, -4}, {-20, -4}, {-20, -10}, {-20, -10}}, color = {0, 127, 255}));
		connect(LTR.from_comp_port_b, mixer.first_port_a) annotation(
			Line(points = {{-36, -24}, {-28, -24}, {-28, -18}, {-28, -18}}, color = {0, 127, 255}));
		connect(mixer.port_b, HTR.from_comp_port_a) annotation(
			Line(points = {{-12, -18}, {-4, -18}, {-4, -16}, {0, -16}}, color = {0, 127, 255}));
		connect(splitter.gamma_port_b, reCompressor.port_a) annotation(
			Line(points = {{-62, -28}, {-62, -28}, {-62, 8}, {-62, 8}}, color = {0, 127, 255}));
		connect(mainCompressor.port_b, LTR.from_comp_port_a) annotation(
			Line(points = {{-70, -18}, {-50, -18}, {-50, -24}, {-50, -24}}, color = {0, 127, 255}));
		connect(splitter.one_gamma_port_b, cooler.port_a) annotation(
			Line(points = {{-70, -36}, {-70, -36}, {-70, -62}, {-78, -62}, {-78, -62}}, color = {0, 127, 255}));
		connect(turbine.port_b, HTR.from_turb_port_a) annotation(
			Line(points = {{72, -36.6}, {48, -36.6}, {48, -34.6}, {22, -34.6}, {22, -34.1}, {22, -34.1}, {22, -31.6}}, color = {0, 127, 255}));
		connect(cooler.port_b, mainCompressor.port_a) annotation(
			Line(points = {{-78, -46}, {-88, -46}, {-88, -6}, {-82, -6}, {-82, -6}}, color = {0, 127, 255}));
		connect(cooler.T_amb, T_amb);
		connect(m_sup, cooler.m_sup);
//	exchanger.HTF_port_b.m_flow=fluid_b.m_flow;
//	-fluid_a.m_flow+exchanger.HTF_port_a.m_flow=0;
//	exchanger.HTF_port_b.p=fluid_b.p;
//	exchanger.HTF_port_a.p=fluid_a.p;
//	exchanger.HTF_port_a.h_outflow=fluid_a.h_outflow;
//	fluid_b.h_outflow=exchanger.HTF_port_b.h_outflow;
//m_sup = true;
		m_sup = exchanger.HTF_port_a.m_flow >= exchanger.m_HTF_des * nu_min;
		exchanger.CO2_port_a.m_flow = exchanger.m_CO2_des;
		eta_cycle = W_net / exchanger.Q_HX;
		der(E_net) = W_net;
		W_net = if m_sup then (-turbine.W_turb) - mainCompressor.W_comp - reCompressor.W_comp - cooler.P_cooling else 0;
		annotation(
			experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
			__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
	end recompPB;


