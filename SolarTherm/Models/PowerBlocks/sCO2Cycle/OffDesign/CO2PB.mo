within SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign;
	model CO2PB
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
		//Cycle parameters
		parameter Modelica.SIunits.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
		parameter Modelica.SIunits.ThermodynamicTemperature T_high = 600 + 273.15 "inlet temperature of the turbine";
		parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 30 + 273.15 "ambiant temperature";
		parameter Real PR = 3 "Pressure ratio";
		parameter Modelica.SIunits.Power P_nom = 164000 "Nominal electrical power";
		parameter Modelica.SIunits.MassFlowRate m_flow_design = 1.48 "Design mass flow rate in kg/s";
		// Compressor parameters
		parameter Modelica.SIunits.Efficiency eta_comp = 0.87 "Maximal isentropic efficiency of the compressors";
		parameter Real diam_rotor = 0.039 "On-design diameter of the compressor's rotor";
		parameter Real N_design = 6545 "On-design rotationnal speed in rad/s";
		parameter Real psi_des = 2.73 "On-design adimensionned head";
		//Turbine parameters
		parameter Modelica.SIunits.Efficiency eta_turb = 0.93 "Maximal isentropic efficiency of the turbine";
		parameter Modelica.SIunits.Area A_nozzle = 4.420 * 10 ^ (-5) "Nozzle area of the turbine, in m2";
		parameter Real N_shaft = 6545 "On-design rotationnal speed in rad/s";
		parameter Real diam_turb = 0.129 "On-design diameter of the turbine's rotor";
		//Heat recuperator parameters
		//parameter Integer N_q = 40 "Number of discretization of the heat recuperators";
		//parameter SolarTherm.Types.Conductance UA_dis[N_q-1]={2317.31,1602.02,1227.35,998.003,843.919,733.841,651.637,588.14,537.786,497.038,463.489,435.471,411.781,391.529,374.072,358.888,345.606,333.899,323.526,314.311,306.059,298.627,291.93,285.879,280.373,275.365,270.776,266.572,262.709,259.167,255.894,252.856,250.055,247.456,245.04,242.78,240.681,238.699,236.859};
		parameter Integer N_q = 15;
		parameter SolarTherm.Types.Conductance[N_q - 1] UA_dis = {5201.28, 2519.91, 1731.07, 1360.73, 1150.91, 1018.64, 929.279, 865.836, 818.941, 783.311, 755.569, 733.446, 715.599, 700.851};
		parameter Modelica.SIunits.MassFlowRate m_des_comp = 1.48;
		parameter Modelica.SIunits.MassFlowRate m_des_turb = 1.48;
		//Exchanger parameters
		parameter SolarTherm.Types.Conductance UA_exch = 58694 "Conductance per sub-heat exchanger";
		parameter Modelica.SIunits.SpecificEnthalpy h_HTF_design = 293902 "Inlet enthalpy of the HTF. For convergence when m_flow too low";
		parameter Modelica.SIunits.MassFlowRate m_des_CO2 = 1.48;
		parameter Modelica.SIunits.MassFlowRate m_des_HTF = 1.48;
		//Cooler parameters
		parameter SolarTherm.Types.Conductance UA_cooler = 4745 "Conductance of the cooler in W/K";
		parameter Modelica.SIunits.ThermodynamicTemperature T_low = 45 + 273.15 "Outlet temperature of the cooler";
		//Results
		Modelica.SIunits.Efficiency eta_cycle;
		Modelica.SIunits.Power P_elec;
		Boolean m_sup "Disconnect the production of electricity when the outlet pressure of the turbine is close to the critical pressure";
		//Components instanciation
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign.HeatRecuperatorTLMD recuperator(N_q = N_q, UA_dis = UA_dis, m_des_comp = m_des_comp, m_des_turb = m_des_turb) annotation(
			Placement(visible = true, transformation(origin = {-38, -16}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign.CompressorOnShaft compressor(diam_rotor = diam_rotor, N_design = N_design, eta_design = eta_comp, psi_des = psi_des) annotation(
			Placement(visible = true, transformation(origin = {-74, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign.Cooler cooler(UA_cooler = UA_cooler, T_low = T_low) annotation(
			Placement(visible = true, transformation(origin = {-78, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign.Turbine turbine(PR = PR, T_amb = T_amb, N_shaft = N_shaft, diam_turb = diam_turb, A_nozzle = A_nozzle, eta_design = eta_turb) annotation(
			Placement(visible = true, transformation(origin = {16, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign.Exchanger exchanger(UA_HTR = UA_exch, m_des_CO2 = m_des_CO2, m_des_HTF = m_des_HTF, h_HTF_design = h_HTF_design) annotation(
			Placement(visible = true, transformation(origin = {-4, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow src(T_out = 600, p_out = 10 ^ 5, m_flow = m_flow_design, redeclare package MedPB = MedRec, use_m_parameter = true) annotation(
			Placement(visible = true, transformation(origin = {34, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
		SinkFlow sink annotation(
			Placement(visible = true, transformation(origin = {-36, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Real tempTest;
	equation
		connect(sink.port_a, exchanger.HTF_port_b) annotation(
			Line(points = {{-28, 20}, {-12, 20}, {-12, 16}, {-12, 16}}, color = {0, 127, 255}));
		connect(src.port_b, exchanger.HTF_port_a) annotation(
			Line(points = {{26, 22}, {2, 22}, {2, 16}, {2, 16}}, color = {0, 127, 255}));
		connect(exchanger.CO2_port_b, turbine.port_a) annotation(
			Line(points = {{2, 6}, {14, 6}, {14, -18}, {12, -18}, {12, -20}}, color = {0, 127, 255}));
		connect(exchanger.CO2_port_a, recuperator.from_comp_port_b) annotation(
			Line(points = {{-12, 6}, {-28, 6}, {-28, -8}, {-28, -8}}, color = {0, 127, 255}));
		connect(cooler.port_b, compressor.port_a) annotation(
			Line(points = {{-78, -46}, {-88, -46}, {-88, -6}, {-82, -6}, {-82, -6}}, color = {0, 127, 255}));
		connect(recuperator.from_turb_port_b, cooler.port_a) annotation(
			Line(points = {{-49.52, -25.28}, {-49.52, -25.28}, {-49.52, -61.28}, {-77.52, -61.28}, {-77.52, -61.28}}, color = {0, 127, 255}));
		connect(compressor.port_b, recuperator.from_comp_port_a) annotation(
			Line(points = {{-71, -17.4}, {-59, -17.4}, {-59, -9.4}, {-51, -9.4}, {-51, -9.4}}, color = {0, 127, 255}));
		connect(turbine.port_b, recuperator.from_turb_port_a) annotation(
			Line(points = {{22, -30}, {-28, -30}, {-28, -25}}, color = {0, 127, 255}));
		connect(cooler.T_amb, tempTest);
		m_sup = exchanger.HTF_port_a.m_flow >= m_des_HTF * 0.8;
		connect(m_sup, exchanger.m_sup);
		tempTest = 55 + 273.15;
		eta_cycle = P_elec / exchanger.Q_HX_HTR;
		P_elec = if m_sup then (-turbine.W_turb) - compressor.W_comp - cooler.P_cooling else 0;
		annotation(
			experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
	end CO2PB;

