within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;

model RecompressionCycle
	extends Modelica.Icons.Example;
	import FI = SolarTherm.Models.Analysis.Finances;
	import Modelica.SIunits.Conversions.*;

	replaceable package MedPB = SolarTherm.Media.CarbonDioxide;
	replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;

	Modelica.SIunits.Power W_net "Net electric power output";

	// PB parameters
	parameter Real nu_min = 0.25 "Minimum turbine operation";

	Modelica.Blocks.Sources.RealExpression T_amb(y = from_degC(45));

	//Cycle parameters
	parameter Modelica.SIunits.AbsolutePressure p_high = 20e6 "high pressure of the cycle";
	parameter Modelica.SIunits.ThermodynamicTemperature T_high = from_degC(715) "inlet temperature of the turbine";
	parameter Modelica.SIunits.ThermodynamicTemperature T_amb_des = from_degC(30) "ambient temperature";
	parameter Modelica.SIunits.Efficiency PR = 2.5 "Pressure ratio";
	parameter Modelica.SIunits.Power P_gro = 100e6 "first guess of power outlet";
	parameter Modelica.SIunits.Power P_nom (fixed=false) "Electrical power at design point";
	parameter Modelica.SIunits.MassFlowRate m_HTF_des = 1000 "Mass flow rate at design point";
	parameter Modelica.SIunits.Efficiency gamma = 0.28 "Part of the mass flow going to the recompression directly";
	parameter Modelica.SIunits.AngularVelocity[4] choiceN = {75000,30000,10000,3600}*0.10471975512 ;
	parameter Modelica.SIunits.AngularVelocity N_shaft=(choiceN[integer(Modelica.Math.log(P_gro/1e6)/Modelica.Math.log(10))+2]);

	// main Compressor parameters
	parameter Modelica.SIunits.Efficiency eta_comp_main = 0.89 "Maximal isentropic efficiency of the compressors";

	// reCompressor parameters
	parameter Modelica.SIunits.Efficiency eta_comp_re = 0.89 "Maximal isentropic efficiency of the compressors";

	//Turbine parameters
	parameter Modelica.SIunits.Efficiency eta_turb = 0.93 "Maximal isentropic efficiency of the turbine";

	//HTR Heat recuperator parameters
	parameter Integer N_HTR = 15;

	//LTR Heat recuperator parameters
	parameter Integer N_LTR = 15;
	parameter Real ratio_m_des = 1 - gamma;

	//Cooler parameters
	parameter Modelica.SIunits.ThermodynamicTemperature T_low = from_degC(45) "Outlet temperature of the cooler";
	
	//Exchanger parameters
	parameter Modelica.SIunits.ThermodynamicTemperature T_HTF_in_des = from_degC(800);
	
	parameter Integer N_exch = 5;
	
	//Financial analysis
	parameter FI.Money C_HTR (fixed=false) "cost of the high temperature heat recuperator";
	parameter FI.Money C_LTR (fixed=false) "cost of the low temperature heat recuperator";
	parameter FI.Money C_turbine (fixed=false) "cost of the turbine";
	parameter FI.Money C_mainCompressor (fixed=false) "cost of the main compressor";
	parameter FI.Money C_reCompressor (fixed=false) "cost of the re compressor";
	parameter FI.Money C_exchanger (fixed=false) "cost of the exchanger";
	parameter FI.Money C_generator (fixed=false) "cost of the generator";
	parameter FI.Money C_cooler (fixed=false) "cost of the cooler";
	parameter FI.Money C_PB (fixed=false) "Overall cost of the power block";
	parameter FI.Money pri_exchanger = 150 "price of the primary exchanger in $/(kW_th). Objective for next-gen CSP with particles";
	
	//Results
	Modelica.SIunits.Efficiency eta_cycle;
	
	Modelica.SIunits.Energy E_net(final start=0, fixed=true, displayUnit="MW.h");
	Boolean m_sup "Disconnect the production of electricity when the outlet pressure of the turbine is close to the critical pressure";
	
	//Components instanciation
	SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.CompressorOnShaft mainCompressor(eta_design = eta_comp_main, N_design=N_shaft, P_nom_des=P_gro, p_high_des=p_high) annotation(
		Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
	
	SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.CompressorOnShaft reCompressor(N_design = N_shaft, P_nom_des = P_gro, p_high_des = p_high) annotation(
		Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
	
	SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Cooler cooler(T_low = T_low, P_nom_des=P_gro, T_amb_des=T_amb_des) annotation(
		Placement(visible = true, transformation(origin = {-105, -20}, extent = {{22, 22}, {-22, -22}}, rotation = 0)));
	
	SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Turbine turbine(PR = PR, T_amb = T_amb_des, N_shaft = N_shaft, eta_design = eta_turb) annotation(
		Placement(visible = true, transformation(origin = {60, 40}, extent = {{-15, 15}, {15, -15}}, rotation = 0)));
	
	SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Exchanger exchanger(redeclare package MedRec = MedRec, P_nom_des = P_gro, T_out_CO2_des = T_high, N_exch = N_exch, ratio_m_des=1) annotation(
		Placement(visible = true, transformation(origin = {64, 0}, extent = {{-22, 22}, {22, -22}}, rotation = 0)));
	
	SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve HTR(N_q = N_HTR, P_nom_des=P_gro, ratio_m_des=1) annotation(
		Placement(visible = true, transformation(origin = {45, -50}, extent = {{-16, 16}, {16, -16}}, rotation = 0)));
	
	SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve LTR(N_q = N_LTR, P_nom_des = P_gro, ratio_m_des=1-gamma) annotation(
		Placement(visible = true, transformation(origin = {0, -50}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
	
	SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.FlowMixer mixer annotation(
		Placement(visible = true, transformation(origin = {4, -80}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
	
	SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.FlowSplitter splitter(gamma = gamma) annotation(
		Placement(visible = true, transformation(origin = {-50, -45}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
	
	Modelica.Fluid.Sources.MassFlowSource_T source(replaceable package Medium = MedRec, nPorts=1, m_flow = 920, T = from_degC(720)) annotation(
		Placement(transformation(origin = {114, 11.5}, extent = {{14,-14}, {-14, 14}}, rotation = 0)));

	Modelica.Fluid.Sources.FixedBoundary sink(replaceable package Medium = MedRec, nPorts=1) annotation(
		Placement(transformation(origin = {114, -20}, extent = {{13, 13}, {-13, -13}}, rotation = 0)));

	parameter MedRec.ThermodynamicState state_HTF_in_des=MedRec.setState_pTX(1e5,T_HTF_in_des);
	
initial equation
	exchanger.h_in_HTF_des = MedRec.specificEnthalpy(state_HTF_in_des);
	exchanger.p_in_HTF_des = state_HTF_in_des.p;
	exchanger.m_HTF_des=m_HTF_des;
	P_nom = (-turbine.W_turb_des) - mainCompressor.W_comp_des -reCompressor.W_comp_des- cooler.P_cool_des;
	
	// enthalpy equalities
	//main loop
	exchanger.h_in_CO2_des = HTR.h_out_comp_des;
	turbine.h_in_des = exchanger.h_out_CO2_des;
	HTR.h_in_turb_des = turbine.h_out_des;
	LTR.h_in_turb_des=HTR.h_out_turb_des;
	cooler.h_in_des = LTR.h_out_turb_des;
	mainCompressor.h_in_des = cooler.h_out_des;
	LTR.h_in_comp_des = mainCompressor.h_out_des;
	
	// recompression loop
	reCompressor.h_in_des=LTR.h_out_turb_des;
	HTR.h_in_comp_des=ratio_m_des*LTR.h_out_comp_des+(1-ratio_m_des)*reCompressor.h_out_des;
	
	//pressure equalities
	//main loop
	exchanger.p_in_CO2_des = HTR.p_out_comp_des;
	turbine.p_in_des = exchanger.p_out_CO2_des;
	HTR.p_in_turb_des = turbine.p_out_des;
	LTR.p_in_turb_des=HTR.p_out_turb_des;
	cooler.p_in_des = LTR.p_out_turb_des;
	mainCompressor.p_in_des = cooler.p_out_des;
	LTR.p_in_comp_des=mainCompressor.p_out_des;
	
	//recompression loop
	reCompressor.p_in_des=LTR.p_out_turb_des;
	HTR.p_in_comp_des = ratio_m_des*LTR.p_out_comp_des+(1-ratio_m_des)*reCompressor.p_out_des;
	
	//mass flow equalities
	//main loop
	//exchanger.m_CO2_des = HTR.m_comp_des;
	turbine.m_des = exchanger.m_CO2_des;
	HTR.m_turb_des = turbine.m_des;
	LTR.m_turb_des=HTR.m_turb_des;
	cooler.m_des = LTR.m_turb_des*ratio_m_des;
	mainCompressor.m_des = cooler.m_des;
	LTR.m_comp_des=mainCompressor.m_des;
	
	//recompression loop
	HTR.m_comp_des = reCompressor.m_des+LTR.m_comp_des;
	reCompressor.m_des=gamma*LTR.m_turb_des;
	
	// Financial Analysis
	C_HTR= if HTR.T_turb_des[N_HTR]>= from_degC(550) then 49.45*HTR.UA_HTR^0.7544*(1+0.02141*(HTR.T_turb_des[N_HTR]-from_degC(550))) else 49.45*HTR.UA_HTR^0.7544;
	C_LTR=49.45*LTR.UA_HTR^0.7544;
	C_turbine= if exchanger.T_CO2_des[2]>= from_degC(550) then 406200*(-turbine.W_turb_des/1e6)^0.8*(1+1.137e-5*(exchanger.T_CO2_des[2]-from_degC(550))^2) else 406200*(-turbine.W_turb_des/1e6)^0.8;
	C_mainCompressor = 1230000*(mainCompressor.W_comp_des/1e6)^0.3392;
	C_reCompressor = 1230000*(reCompressor.W_comp_des/1e6)^0.3392;
	C_cooler = 32.88*cooler.UA_cooler^0.75;
	C_generator = 108900*(P_nom/1e6)^0.5463;
	C_exchanger = pri_exchanger*exchanger.Q_HX_des*m_HTF_des/1000;
	C_PB=(C_HTR+C_LTR+C_turbine+C_mainCompressor+C_reCompressor+C_generator+C_cooler+C_exchanger)*1.05; // 1.05 factor due to cost scaling to 2017 USD

equation
	connect(LTR.from_turb_port_b, splitter.port_a) annotation(Line(points={{-43, -44}, {-14, -44}}, color={0, 127, 255}));
	connect(LTR.from_turb_port_a, HTR.from_turb_port_b) annotation(Line(points={{14, -56}, {32, -56}}, color={0, 127, 255}));
	connect(LTR.from_comp_port_b, mixer.first_port_a) annotation(Line(points={{4, -65}, {4, -71}}, color={0, 127, 255}));
	connect(mixer.port_b, HTR.from_comp_port_a) annotation(Line(points={{13, -80}, {41,-80}, {41, -63}}, color={0, 127, 255}));
	connect(splitter.gamma_port_b, reCompressor.port_a) annotation(Line(points={{-50, -38}, {-50, -15}}, color={0, 127, 255}));
	connect(mainCompressor.port_b, LTR.from_comp_port_a) annotation(Line(points={{-70, 48}, {-4, 48}, {-4, -36}}, color={0, 127, 255}));
	connect(splitter.one_gamma_port_b, cooler.port_a) annotation(Line(points={{-58, -44}, {-91,-44}, {-91, -41}}, color={0, 127, 255}));
	connect(exchanger.port_c_in, HTR.from_comp_port_b) annotation(Line(points={{49.5, -36}, {49.5, -19}}, color={0, 127, 255}));
	connect(cooler.port_b, mainCompressor.port_a) annotation(Line(points={{-91, 1}, {-91, 25}}, color={0, 127, 255}));
	connect(exchanger.port_c_out, turbine.port_a) annotation(Line(points={{50, 19}, {50, 32}}, color={0, 127, 255}));
	connect(turbine.port_b, HTR.from_turb_port_a) annotation(Line(points={{70, 55}, {140, 55}, {140, -44}, {59, -44}}, color={0, 127, 255}));
	connect(reCompressor.port_b, mixer.second_port_a) annotation(Line(points={{-30, 8}, {-20, 8}, {-20, -80}, {-5, -80}}, color={0, 127, 255}));
	connect(source.ports[1], exchanger.port_h_in) annotation(Line(points={{88, 11.5}, {100, 11.5}}, color={0, 127, 255}));
	connect(sink.ports[1], exchanger.port_h_out) annotation(Line(points={{88, -11.5}, {88, -20}, {100, -20}}, color={0, 127, 255}));
	connect(cooler.T_amb, T_amb.y);
	connect(m_sup, exchanger.m_sup);
	connect(m_sup, cooler.m_sup);
	
	m_sup = exchanger.port_h_in.m_flow >= exchanger.m_HTF_des * nu_min;
	
	if m_sup then 
		turbine.p_out=mainCompressor.p_out/PR;
	else
		exchanger.port_c_in.m_flow = exchanger.m_CO2_des;
	end if;
	
	eta_cycle = W_net / exchanger.Q_HX;

	der(E_net) = W_net;

	W_net = if m_sup then (-turbine.W_turb) - mainCompressor.W_comp - reCompressor.W_comp - cooler.P_cooling else 0;

annotation(
	experiment(StartTime = 0, StopTime = 1, Tolerance = 0.001, Interval = 0.02),
	__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
	Diagram(coordinateSystem(initialScale = 1)),
	Icon(coordinateSystem(initialScale = 1)));

end RecompressionCycle;
