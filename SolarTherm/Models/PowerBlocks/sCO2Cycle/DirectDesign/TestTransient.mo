within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
	model TestTransient
		import FI = SolarTherm.Models.Analysis.Finances;
		import SI = Modelica.SIunits;
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
	
		//Cycle parameters
		parameter SI.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
		parameter SI.ThermodynamicTemperature T_high = 800 + 273.15 "inlet temperature of the turbine";
		parameter SI.ThermodynamicTemperature T_amb = 40 + 273.15 "ambiant temperature";
		parameter Real PR = 3.125 "Pressure ratio";
		parameter SI.Power P_gro = 10 ^ 6 "first guess of power outlet";
		parameter SI.Power P_nom(fixed = false) "Electrical power at design point";
		parameter SI.MassFlowRate m_HTF_des = 45 "Mass flow rate at design point";
		// Compressor parameters
		parameter SI.Efficiency eta_comp = 0.89 "Maximal isentropic efficiency of the compressors";
		parameter SI.AngularVelocity[4] choiceN = {75000, 30000, 10000, 3600} * 0.10471975512;
		parameter SI.AngularVelocity N_shaft = choiceN[integer(Modelica.Math.log(P_gro / 10 ^ 6) / Modelica.Math.log(10)) + 2];
		//Turbine parameters
		parameter SI.Efficiency eta_turb = 0.93 "Maximal isentropic efficiency of the turbine";
		//Heat recuperator parameters
		parameter Integer N_q = 15;
		//Cooler parameters
		parameter SI.ThermodynamicTemperature T_low = 55 + 273.15 "Outlet temperature of the cooler";
		//Financial analysis
		parameter FI.Money C_HTR(fixed = false) "cost of the heat recuperator";
		parameter FI.Money C_turbine(fixed = false) "cost of the turbine";
		parameter FI.Money C_compressor(fixed = false) "cost of the compressor";
		parameter FI.Money C_exchanger(fixed = false) "cost of the exchanger";
		parameter FI.Money C_generator(fixed = false) "cost of the generator";
		parameter FI.Money C_cooler(fixed = false) "cost of the cooler";
		parameter FI.Money C_PB(fixed = false) "Overall cost of the power block";
		parameter FI.Money pri_exchanger = 150 "price of the primary exchanger in $/(kW_th). Objective for next-gen CSP with particles";
		//Results
		SI.Efficiency eta_cycle;
		SI.Power P_elec;
		Boolean m_sup "Disconnect the production of electricity when the outlet pressure of the turbine is close to the critical pressure";
		//Components instanciation
		SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve HTR(N_q = N_q, P_nom_des = P_nom, pinchRecuperator = 1.4) annotation(
			Placement(visible = true, transformation(origin = {-38, -16}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.CompressorToDiscuss compressor(N_design = N_shaft, eta_design = eta_comp,	PR = PR) annotation(
			Placement(visible = true, transformation(origin = {-74, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Cooler cooler(T_low = T_low, P_nom_des = P_nom, T_amb_des = T_amb) annotation(
			Placement(visible = true, transformation(origin = {-78, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Turbine turbine(PR = PR, T_amb = T_amb, N_shaft = N_shaft, eta_design = eta_turb) annotation(
			Placement(visible = true, transformation(origin = {16, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Exchanger exchanger(P_nom_des = P_nom) annotation(
			Placement(visible = true, transformation(origin = {-4, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
				SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow src(T_out = T_high, p_out = 10 ^ 5, redeclare package MedPB = MedRec, use_m_parameter = true, m_flow=turbine.m_des) annotation(
					Placement(visible = true, transformation(origin = {34, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
				SinkFlow sink annotation(
					Placement(visible = true, transformation(origin = {-36, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Real tempTest;
		parameter MedRec.ThermodynamicState state_HTF_in_des(p.fixed = false, h.fixed = false);
	initial equation
		state_HTF_in_des = MedRec.setState_pTX(10 ^ 5, T_high);
		exchanger.h_in_HTF_des = MedRec.specificEnthalpy(state_HTF_in_des);
		exchanger.p_in_HTF_des = 10 ^ 5;
		exchanger.m_HTF_des = m_HTF_des;
		P_nom = (-turbine.W_turb_des) - compressor.W_comp_des - cooler.P_cool_des;
		// enthalpy equalities
		HTR.h_in_comp_des = compressor.h_out_des;
		exchanger.h_in_CO2_des = HTR.h_out_comp_des;
		turbine.h_in_des = exchanger.h_out_CO2_des;
		turbine.h_out_des = HTR.h_in_turb_des;
		cooler.h_in_des = HTR.h_out_turb_des;
		compressor.h_in_des = cooler.h_out_des;
		//pressure equalities
		HTR.p_in_comp_des = compressor.p_out_des;
		exchanger.p_in_CO2_des = HTR.p_out_comp_des;
		turbine.p_in_des = exchanger.p_out_CO2_des;
		HTR.p_in_turb_des = turbine.p_out_des;
		cooler.p_in_des = HTR.p_out_turb_des;
		compressor.p_in_des = cooler.p_out_des;
		//mass flow equalities
		turbine.m_des = exchanger.m_CO2_des;
		HTR.m_comp_des = compressor.m_des;
		HTR.m_turb_des = turbine.m_des;
		cooler.m_des = HTR.m_turb_des;
		compressor.m_des = cooler.m_des;
		// Financial Analysis
		C_HTR = if HTR.T_turb_des[N_q] >= 550 + 273.15 then 49.45 * HTR.UA_HTR ^ 0.7544 * (1 + 0.02141 * (HTR.T_turb_des[N_q] - 550 - 273.15)) else 49.45 * HTR.UA_HTR ^ 0.7544;
		C_turbine = if exchanger.T_CO2_des[2] >= 550 + 273.15 then 406200 * (-turbine.W_turb_des / 10 ^ 6) ^ 0.8 * (1 + 1.137 * 10 ^ (-5) * (exchanger.T_CO2_des[2] - 550 - 273.15) ^ 2) else 406200 * (-turbine.W_turb_des / 10 ^ 6) ^ 0.8;
		C_compressor = 1230000 * (compressor.W_comp_des / 10 ^ 6) ^ 0.3392;
		C_cooler = 32.88 * cooler.UA_cooler ^ 0.75;
		C_generator = 108900 * (P_nom / 10 ^ 6) ^ 0.5463;
		C_exchanger = pri_exchanger * exchanger.Q_HX_des / 1000;
		C_PB = (C_HTR + C_turbine + C_compressor + C_generator + C_cooler + C_exchanger) * 1.05;
		// 1.05 corresponds to inflation from 2017, as correlations are in 2017' dollars.
	
	equation
	
	connect(sink.port_a, exchanger.HTF_port_b) annotation(
	Line(points = {{-28, 20}, {-12, 20}, {-12, 16}, {-12, 16}}, color = {0, 127, 255}));
	connect(src.port_b, exchanger.HTF_port_a) annotation(
	Line(points = {{26, 22}, {2, 22}, {2, 16}, {2, 16}}, color = {0, 127, 255}));
		connect(exchanger.CO2_port_b, turbine.port_a) annotation(
			Line(points = {{2, 6}, {14, 6}, {14, -18}, {12, -18}, {12, -20}}, color = {0, 127, 255}));
		connect(exchanger.CO2_port_a, HTR.from_comp_port_b) annotation(
			Line(points = {{-12, 6}, {-28, 6}, {-28, -8}, {-28, -8}}, color = {0, 127, 255}));
		connect(cooler.port_b, compressor.port_a) annotation(
			Line(points = {{-78, -46}, {-88, -46}, {-88, -6}, {-82, -6}, {-82, -6}}, color = {0, 127, 255}));
		connect(HTR.from_turb_port_b, cooler.port_a) annotation(
			Line(points = {{-49.52, -25.28}, {-49.52, -25.28}, {-49.52, -61.28}, {-77.52, -61.28}, {-77.52, -61.28}}, color = {0, 127, 255}));
		connect(compressor.port_b, HTR.from_comp_port_a) annotation(
			Line(points = {{-71, -17.4}, {-59, -17.4}, {-59, -9.4}, {-51, -9.4}, {-51, -9.4}}, color = {0, 127, 255}));
		connect(turbine.port_b, HTR.from_turb_port_a) annotation(
			Line(points = {{22, -30}, {-28, -30}, {-28, -25}}, color = {0, 127, 255}));
		connect(cooler.T_amb, tempTest);
		connect(cooler.m_sup,m_sup);
		tempTest = 40+273.15;
		m_sup = true;
		connect(m_sup, exchanger.m_sup);
	
		turbine.p_out = compressor.p_out/PR;
		compressor.N_compressor = 100+N_shaft*time;
		turbine.N_turb=compressor.N_compressor;
	
		//P_elec=P_nom;
		eta_cycle = P_elec / exchanger.Q_HX;
		P_elec = if m_sup then (-turbine.W_turb) - compressor.W_comp else 0;
		annotation(
			experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
			__OpenModelica_simulationFlags(lv = "LOG_NLS_V,LOG_STATS", outputFormat = "mat", s = "dassl"));
	end TestTransient;
