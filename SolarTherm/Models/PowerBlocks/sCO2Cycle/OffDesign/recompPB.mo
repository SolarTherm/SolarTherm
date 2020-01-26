within SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign;
	model recompPB
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		replaceable package MedRec = SolarTherm.Media.Sodium.ConstSodium;
		input SolarTherm.Interfaces.Connectors.WeatherBus wbus;
		
		//Cycle parameters
		parameter Modelica.SIunits.AbsolutePressure p_high = 200 * 10 ^ 5 "high pressure of the cycle";
		parameter Modelica.SIunits.ThermodynamicTemperature T_high = 715 + 273.15 "inlet temperature of the turbine";
		parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 30 + 273.15 "ambiant temperature";
		parameter Real PR = 2.5 "Pressure ratio";
		parameter Modelica.SIunits.Power P_nom = 100 * 10 ^ 6 "Nominal electrical power";
		parameter Modelica.SIunits.MassFlowRate m_flow_design = 747.5 "Design mass flow rate in kg/s";
		parameter Real gamma = 0.28 "Part of the mass flow going to the recompression directly";
		// main Compressor parameters
		parameter Modelica.SIunits.Efficiency eta_comp_main = 0.89 "Maximal isentropic efficiency of the compressors";
		parameter Real diam_comp_main = 0.78 "On-design diameter of the compressor's rotor";
		parameter Real N_shaft_main = 314 "On-design rotationnal speed in rad/s";
		parameter Real psi_des_main = 2.41 "On-design adimensionned head";
		// reCompressor parameters
		parameter Modelica.SIunits.Efficiency eta_comp_re = 0.89 "Maximal isentropic efficiency of the compressors";
		parameter Real diam_comp_re = 0.707 "On-design diameter of the compressor's rotor";
		parameter Real N_shaft_re = 314 "On-design rotationnal speed in rad/s";
		parameter Real psi_des_re = 5.338 "On-design adimensionned head";
		//Turbine parameters
		parameter Modelica.SIunits.Efficiency eta_turb = 0.93 "Maximal isentropic efficiency of the turbine";
		parameter Modelica.SIunits.Area A_nozzle = 0.026683 "Nozzle area of the turbine, in m2";
		parameter Real N_shaft = 314 "On-design rotationnal speed in rad/s";
		parameter Real diam_turb = 2.564 "On-design diameter of the turbine's rotor";
		//HTR Heat recuperator parameters
		parameter Integer N_HTR = 15;
		parameter SolarTherm.Types.Conductance[N_HTR - 1] UA_HTR = {3236960, 2150140, 1676220, 1413500, 1247490, 1134060, 1052000, 990283, 942490, 904248, 873103, 847405, 825941, 807725};
		parameter Modelica.SIunits.MassFlowRate m_des_comp_HTR = 737.48;
		parameter Modelica.SIunits.MassFlowRate m_des_turb_HTR = 737.48;
		//LTR Heat recuperator parameters
		parameter Integer N_LTR = 15;
		parameter SolarTherm.Types.Conductance[N_LTR - 1] UA_LTR = {743598, 670176, 621226, 589684, 571589, 564709, 568161, 581906, 606949, 645701, 702309, 784284, 905788, 1095910};
		parameter Modelica.SIunits.MassFlowRate m_des_comp_LTR = 530.986;
		parameter Modelica.SIunits.MassFlowRate m_des_turb_LTR = 737.48;
		//Exchanger parameters
		parameter SolarTherm.Types.Conductance UA_exch = 1694670 "Conductance per sub-heat exchanger";
		parameter Modelica.SIunits.SpecificEnthalpy h_HTF_design = 995164 "Inlet enthalpy of the HTF. For convergence when m_flow too low";
		parameter Modelica.SIunits.MassFlowRate m_des_CO2 = 737.48;
		parameter Modelica.SIunits.MassFlowRate m_des_HTF = 730;
		//Cooler parameters
		parameter SolarTherm.Types.Conductance UA_cooler = 1584500 "Conductance of the cooler in W/K";
		parameter Modelica.SIunits.ThermodynamicTemperature T_low = 45 + 273.15 "Outlet temperature of the cooler";
		parameter Modelica.SIunits.Power P_cool_design = 10^6 "electricity needed for cooling";
		//Results
		Modelica.SIunits.Efficiency eta_cycle;
		Modelica.SIunits.Power P_elec;
		Boolean m_sup "Disconnect the production of electricity when the outlet pressure of the turbine is close to the critical pressure";
		//Components instanciation
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign.HeatRecuperatorDTAve HTR(N_q = N_HTR, UA_dis = UA_HTR, m_des_comp = m_des_comp_HTR, m_des_turb = m_des_turb_HTR) annotation(
			Placement(visible = true, transformation(origin = {12, -22}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign.CompressorOnShaft compressor(diam_rotor = diam_comp_main, N_design = N_shaft_main, eta_design = eta_comp_main, psi_des = psi_des_main) annotation(
			Placement(visible = true, transformation(origin = {-74, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign.Cooler cooler(UA_cooler = UA_cooler, T_low = T_low, P_cool_design=P_cool_design) annotation(
			Placement(visible = true, transformation(origin = {-78, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign.Turbine turbine(PR = PR, T_amb = T_amb, N_shaft = N_shaft, diam_turb = diam_turb, A_nozzle = A_nozzle, eta_design = eta_turb) annotation(
			Placement(visible = true, transformation(origin = {66, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign.Exchanger exchanger(UA_HTR = UA_exch, m_des_CO2 = m_des_CO2, m_des_HTF = m_des_HTF, h_HTF_design = h_HTF_design, redeclare package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph) annotation(
			Placement(visible = true, transformation(origin = {46, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	//	SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow src(T_out = 800, p_out = 10 ^ 5, m_flow = 986, redeclare package MedPB = SolarTherm.Media.SolidParticles.CarboHSP_ph, use_m_parameter = true) annotation(
	//		Placement(visible = true, transformation(origin = {84, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
	//	SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink annotation(
	//		Placement(visible = true, transformation(origin = {14, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Real tempTest;
		Real tempTest2;
		Real eta_Tse;
		SolarTherm.Models.PowerBlocks.sCO2Cycle.FlowMixer mixer annotation(
			Placement(visible = true, transformation(origin = {-20, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		HeatRecuperatorDTAve LTR(N_q = N_LTR, UA_dis = UA_LTR, m_des_comp = m_des_comp_LTR, m_des_turb = m_des_turb_LTR) annotation(
			Placement(visible = true, transformation(origin = {-42, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		FlowSplitter splitter(gamma = gamma) annotation(
			Placement(visible = true, transformation(origin = {-62, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		CompressorOnShaft recompressor(diam_rotor = diam_comp_re, N_design = N_shaft_re, eta_design = eta_comp_re, psi_des = psi_des_re) annotation(
			Placement(visible = true, transformation(origin = {-54, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	equation
		connect(LTR.from_turb_port_b, splitter.port_a) annotation(
			Line(points = {{-50, -34}, {-54, -34}, {-54, -36}, {-54, -36}}, color = {0, 127, 255}));
		connect(LTR.from_turb_port_a, HTR.from_turb_port_b) annotation(
			Line(points = {{-36, -34}, {0, -34}, {0, -32}, {0, -32}}, color = {0, 127, 255}));
		connect(recompressor.port_b, mixer.second_port_a) annotation(
			Line(points = {{-50, -4}, {-20, -4}, {-20, -10}, {-20, -10}}, color = {0, 127, 255}));
		connect(LTR.from_comp_port_b, mixer.first_port_a) annotation(
			Line(points = {{-36, -24}, {-28, -24}, {-28, -18}, {-28, -18}}, color = {0, 127, 255}));
		connect(mixer.port_b, HTR.from_comp_port_a) annotation(
			Line(points = {{-12, -18}, {-4, -18}, {-4, -16}, {0, -16}}, color = {0, 127, 255}));
		connect(splitter.gamma_port_b, recompressor.port_a) annotation(
			Line(points = {{-62, -28}, {-62, -28}, {-62, 8}, {-62, 8}}, color = {0, 127, 255}));
		connect(compressor.port_b, LTR.from_comp_port_a) annotation(
			Line(points = {{-70, -18}, {-50, -18}, {-50, -24}, {-50, -24}}, color = {0, 127, 255}));
		connect(splitter.one_gamma_port_b, cooler.port_a) annotation(
			Line(points = {{-70, -36}, {-70, -36}, {-70, -62}, {-78, -62}, {-78, -62}}, color = {0, 127, 255}));
	//	connect(sink.port_a, exchanger.HTF_port_b) annotation(
	//		Line(points = {{21.4, 14}, {37.4, 14}, {37.4, 10}, {37.4, 10}}, color = {0, 127, 255}));
	//	connect(src.port_b, exchanger.HTF_port_a) annotation(
	//		Line(points = {{76, 16}, {52, 16}, {52, 10}, {52, 10}, {52, 10}, {52, 10}}, color = {0, 127, 255}));
		connect(m_sup, exchanger.m_sup) annotation(
			Line);
		connect(exchanger.CO2_port_a, HTR.from_comp_port_b) annotation(
			Line(points = {{38.8, 0.4}, {30.8, 0.4}, {30.8, 0.4}, {22.8, 0.4}, {22.8, -13.6}, {21.8, -13.6}, {21.8, -13.6}, {22.8, -13.6}}, color = {0, 127, 255}));
		connect(exchanger.CO2_port_b, turbine.port_a) annotation(
			Line(points = {{52.2, 0.2}, {59.2, 0.2}, {59.2, 0.2}, {64.2, 0.2}, {64.2, -23.8}, {62.2, -23.8}, {62.2, -24.8}, {62.2, -24.8}, {62.2, -25.8}}, color = {0, 127, 255}));
		connect(turbine.port_b, HTR.from_turb_port_a) annotation(
			Line(points = {{72, -36.6}, {48, -36.6}, {48, -34.6}, {22, -34.6}, {22, -34.1}, {22, -34.1}, {22, -31.6}}, color = {0, 127, 255}));
		connect(cooler.port_b, compressor.port_a) annotation(
			Line(points = {{-78, -46}, {-88, -46}, {-88, -6}, {-82, -6}, {-82, -6}}, color = {0, 127, 255}));
		connect(cooler.T_amb, wbus.Tdry);
		tempTest=30+273.15;
		tempTest2=wbus.Tdry;
		m_sup = exchanger.HTF_port_a.m_flow >= m_des_HTF * 0.8;
		eta_cycle = P_elec / exchanger.Q_HX_HTR;
		eta_Tse = eta_cycle / 0.504;
		P_elec = if m_sup then (-turbine.W_turb) - compressor.W_comp - recompressor.W_comp - cooler.P_cooling else 0;
		annotation(
			experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
			__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
	end recompPB;
