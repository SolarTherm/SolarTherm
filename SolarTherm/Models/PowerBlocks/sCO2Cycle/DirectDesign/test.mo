within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
	model test
		extends SolarTherm.Media.CO2.PropCO2;
		import CV = Modelica.SIunits.Conversions;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
		
	//	parameter MedPB.ThermodynamicState state_CO2_in_des (p.fixed=false,h.fixed=false);
	//	parameter Real m_choice = 800;
	//	parameter Real N_shaft=3600*0.10471975512;
	//	CompressorToDiscuss compressor32 (p_high_des=250*10^5, N_design=N_shaft) annotation(
	//		Placement(visible = true, transformation(origin = {-22, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	//SourceFlow src32 (p_out=90*10^5,T_out=40,use_m_parameter=true,m_flow=m_choice) annotation(
	//		Placement(visible = true, transformation(origin = {-66, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	//SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink32 annotation(
	//		Placement(visible = true, transformation(origin = {4, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
		Real test;
	initial equation
	// state_CO2_in_des=MedPB.setState_pTX(90*10^5,50+273.15);
	// compressor32.h_in_des=state_CO2_in_des.h;
	// compressor32.p_in_des=state_CO2_in_des.p;
	// compressor32.m_des=m_choice;
	
	equation
	//	connect(compressor32.port_b, sink32.port_a) annotation(
	//		Line(points = {{-18, 12}, {-4, 12}, {-4, 4}, {-4, 4}}, color = {0, 127, 255}));
	//	connect(src32.port_b, compressor32.port_a) annotation(
	//		Line(points = {{-58, 26}, {-30, 26}, {-30, 24}, {-30, 24}}, color = {0, 127, 255}));
	//	compressor32.N_compressor=N_shaft;
		test=MedPB.ToutTurb(715+273.15,250*10^5,80*10^5,0.93);
	end test;
