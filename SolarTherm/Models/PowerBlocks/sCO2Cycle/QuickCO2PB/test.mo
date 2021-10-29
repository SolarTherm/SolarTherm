within SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB;
	model test
		extends SolarTherm.Media.CO2.PropCO2;
		import CV = Modelica.SIunits.Conversions;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
	SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.interpolSimplePB PB annotation(
			Placement(visible = true, transformation(origin = {38, 38}, extent = {{-46, -46}, {46, 46}}, rotation = 0)));
	SourceFlow src (T_out = 800+273.15, p_out = 10 ^ 5, m_flow = PB.m_des, redeclare package MedPB = SolarTherm.Media.SolidParticles.CarboHSP_ph, use_m_parameter = true) annotation(
			Placement(visible = true, transformation(origin = {-28, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	SinkFlow sink annotation(
			Placement(visible = true, transformation(origin = {-26, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	initial equation

	equation
		connect(sink.port_a, PB.fluid_b) annotation(
			Line(points = {{-18, 12}, {10, 12}, {10, 18}, {12, 18}}, color = {0, 127, 255}));
		connect(src.port_b, PB.fluid_a) annotation(
			Line(points = {{-20, 54}, {18, 54}, {18, 54}, {18, 54}}, color = {0, 127, 255}));
		PB.T_amb=273.15;
	annotation(
			experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
			__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end test;
