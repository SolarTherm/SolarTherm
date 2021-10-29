within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
	model testBis
		extends SolarTherm.Media.CO2.PropCO2;
		import CV = Modelica.SIunits.Conversions;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
		parameter MedPB.ThermodynamicState state_CO2_in_des(p.fixed = false, h.fixed = false);
		parameter Real m_choice = 82.8;
		parameter Real N_shaft =31000 * 0.10471975512;
		SourceFlow src32(p_out = 260 * 10 ^ 5, T_out = 700, use_m_parameter = false, m_flow = m_choice) annotation(
			Placement(visible = true, transformation(origin = {-66, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink32 annotation(
			Placement(visible = true, transformation(origin = {4, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
	//CompressorToDiscuss compressor40 (p_high_des=250*10^5, N_design=N_shaft);
		//SourceFlow src40 (p_out=90*10^5,T_out=50,use_m_parameter=true,m_flow=m_choice);
		//SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink40;
		Turbine turbine (N_shaft=N_shaft)annotation(
			Placement(visible = true, transformation(origin = {-32, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	initial equation
		state_CO2_in_des = MedPB.setState_pTX(250 * 10 ^ 5, 700 + 273.15);
		turbine.h_in_des = state_CO2_in_des.h;
		turbine.p_in_des = state_CO2_in_des.p;
		turbine.m_des = m_choice;
	
	equation
		connect(sink32.port_a, turbine.port_b) annotation(
			Line(points = {{-4, 4}, {-26, 4}, {-26, 8}, {-26, 8}, {-26, 10}}, color = {0, 127, 255}));
		connect(src32.port_b, turbine.port_a) annotation(
			Line(points = {{-58, 26}, {-36, 26}, {-36, 20}, {-36, 20}}, color = {0, 127, 255}));
	turbine.p_out=(75+time*10)*10^5;
	end testBis;

