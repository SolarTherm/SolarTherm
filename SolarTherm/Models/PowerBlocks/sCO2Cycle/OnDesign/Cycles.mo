within SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign;
package Cycles "Few different sCO2 cycles."
	model InterCoolHeat
	extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		//Parameters
		parameter Modelica.SIunits.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
		parameter Modelica.SIunits.ThermodynamicTemperature T_high = 775 + 273.15 "inlet temperature of the turbine";
		parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 40 + 273.15 "ambiant	temperature";
		parameter Real PR = 2.313 "Pressure ratio";
		parameter Modelica.SIunits.Power P_nom = 10 ^ 8 "Nominal electrical power";
		parameter Modelica.SIunits.Efficiency eta_comp = 0.87 "Isentropic efficiency of the compressors";
		parameter Modelica.SIunits.Efficiency eta_turb = 0.9 "Isentropic efficiency of the turbine";
		parameter Real gamma = 0.2 "Part of the mass flow going to the recompression directly";
		parameter Integer N_q = 15 "Number of discretization of the heat recuperators";
		// Variables to investigate the cycle and its simulation.
		Modelica.SIunits.Efficiency efficiencyCycle "Efficiency of the cycle";
		Real E_bal_check;
		SolarTherm.Types.SpecificWork W_out "Specific Work of the cycle";
		// Instanciation of the components
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.CompressorOnShaft comprCool(PR = 1.6, eta_comp = eta_comp, p_out = p_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-28, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Cooler interCooler(T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-50, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Cooler mainCooler(T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-74, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.FlowSplitter splitter(gamma = gamma) annotation(
		Placement(visible = true, transformation(origin = {-2, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.CompressorOnShaft comprRecomp(PR = PR, eta_comp = eta_comp, p_out = p_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {2, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.HeatRecuperatorDTAve LTRecuperator(N_q = N_q, flowGuess = P_nom / 10 ^ 5, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {32, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.FlowMixer mixer annotation(
		Placement(visible = true, transformation(origin = {60, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.HeatRecuperatorDTAve HTRecuperator(N_q = N_q, flowGuess = P_nom / 10 ^ 5, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {88, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Heater mainHeater(T_high = T_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {34, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Turbine mainTurbine(PR = PR / 1.6, eta_turb = eta_turb, T_amb = T_amb, is_second_turbine = true) annotation(
		Placement(visible = true, transformation(origin = {38, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Turbine reHeatTurbine(PR = 1.6, eta_turb = eta_turb, T_amb = T_amb, is_second_turbine = true) annotation(
		Placement(visible = true, transformation(origin = {74, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Heater reHeater(T_high = T_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {58, -44}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.CompressorOnShaft mainCompr(PR = PR / 1.6, eta_comp = eta_comp, p_out = p_high / PR * 1.6, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-74, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	equation
		efficiencyCycle * (mainHeater.Q_heater + reHeater.Q_heater) = P_nom;
		E_bal_check = mainTurbine.W_turb + reHeatTurbine.W_turb + mainCompr.W_comp + comprRecomp.W_comp + comprCool.W_comp + mainHeater.Q_heater + mainCooler.Q_cooler + reHeater.Q_heater + interCooler.Q_cooler;
		W_out = P_nom / mainTurbine.port_a.m_flow;
		P_nom = (-mainTurbine.W_turb) - reHeatTurbine.W_turb - mainCompr.W_comp - comprRecomp.W_comp - comprCool.W_comp;
		connect(mainCompr.port_b, interCooler.port_a) annotation(
		Line(points = {{-70, -44}, {-60, -44}, {-60, -22}, {-58, -22}, {-58, -22}}, color = {0, 127, 255}));
		connect(mainCooler.port_b, mainCompr.port_a) annotation(
		Line(points = {{-74, -10}, {-80, -10}, {-80, -32}, {-82, -32}, {-82, -32}}, color = {0, 127, 255}));
		connect(reHeatTurbine.port_b, HTRecuperator.from_turb_port_a) annotation(
		Line(points = {{80, -74}, {92, -74}, {92, -2}, {94, -2}, {94, -2}}, color = {0, 127, 255}));
		connect(reHeater.port_b, reHeatTurbine.port_a) annotation(
		Line(points = {{66, -44}, {72, -44}, {72, -64}, {70, -64}, {70, -64}}, color = {0, 127, 255}));
		connect(mainTurbine.port_b, reHeater.port_a) annotation(
		Line(points = {{44, -74}, {50, -74}, {50, -44}}, color = {0, 127, 255}));
		connect(mainHeater.port_b, mainTurbine.port_a) annotation(
		Line(points = {{34, -46}, {34, -46}, {34, -64}, {34, -64}}, color = {0, 127, 255}));
		connect(HTRecuperator.from_comp_port_b, mainHeater.port_a) annotation(
		Line(points = {{94, 8}, {34, 8}, {34, -30}}, color = {0, 127, 255}));
		connect(mixer.port_b, HTRecuperator.from_comp_port_a) annotation(
		Line(points = {{60, 4}, {80, 4}, {80, 8}, {80, 8}}, color = {0, 127, 255}));
		connect(LTRecuperator.from_comp_port_a, comprCool.port_b) annotation(
		Line(points = {{24, 26}, {-22, 26}, {-22, -50}, {-24, -50}, {-24, -50}}, color = {0, 127, 255}));
		connect(LTRecuperator.from_turb_port_b, splitter.port_a) annotation(
		Line(points = {{24, 16}, {6, 16}, {6, 2}, {6, 2}}, color = {0, 127, 255}));
		connect(HTRecuperator.from_turb_port_b, LTRecuperator.from_turb_port_a) annotation(
		Line(points = {{80, -2}, {72, -2}, {72, 16}, {38, 16}, {38, 16}}, color = {0, 127, 255}));
		connect(LTRecuperator.from_comp_port_b, mixer.second_port_a) annotation(
		Line(points = {{38, 26}, {52, 26}, {52, -4}, {52, -4}, {52, -4}}, color = {0, 127, 255}));
		connect(mixer.first_port_a, comprRecomp.port_b) annotation(
		Line(points = {{60, -12}, {60, -12}, {60, -24}, {4, -24}, {4, -52}, {6, -52}}, color = {0, 127, 255}));
		connect(splitter.one_gamma_port_b, mainCooler.port_a) annotation(
		Line(points = {{-10, 2}, {-60, 2}, {-60, 6}, {-74, 6}, {-74, 6}}, color = {0, 127, 255}));
		connect(splitter.gamma_port_b, comprRecomp.port_a) annotation(
		Line(points = {{-2, 10}, {-6, 10}, {-6, -40}, {-6, -40}}, color = {0, 127, 255}));
		connect(interCooler.port_b, comprCool.port_a) annotation(
		Line(points = {{-42, -22}, {-34, -22}, {-34, -38}, {-36, -38}, {-36, -38}}, color = {0, 127, 255}));
	
		annotation(
		experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
	end InterCoolHeat;

	model RecompCycleExchanger "On-design calculation of the sCO2 recompression cycle."
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		
		inner Modelica.Fluid.System system(
		energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
	allowFlowReversal=false);
	
		
		//Parameters
		parameter Modelica.SIunits.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
		parameter Modelica.SIunits.ThermodynamicTemperature T_high = 800 + 273.15 "inlet temperature of the turbine";
		parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 30 + 273.15 "ambiant	temperature";
		parameter Real PR = 2.77 "Pressure ratio";
		parameter Modelica.SIunits.Power P_nom =10*10^6 "Nominal electrical power";
		
		parameter Modelica.SIunits.Efficiency eta_comp = 0.89 "Isentropic efficiency of the compressors";
		parameter Modelica.SIunits.Efficiency eta_turb = 0.93 "Isentropic efficiency of the turbine";
		parameter Real gamma = 0.18 "Part of the mass flow going to the recompression directly";
		parameter Integer N_q = 15 "Number of discretization of the heat recuperators";
		parameter Real pinchRecuperator = 5;
		parameter Real[4] choiceN = {75000,30000,10000,3600}*5/6*0.10471975512 ;
		//parameter Real N_shaft=(choiceN[integer(Modelica.Math.log(P_nom/10^6)/Modelica.Math.log(10))+2]);
		parameter Real N_shaft=3600*0.10471975512;
		// Financial prices
		
	 
		parameter SolarTherm.Models.Analysis.Finances.Money pri_exchanger = 150 "price of the primary exchanger in $/(kW_th). Objective for next-gen CSP with particles";
		 
		// Instanciation of the components
		
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Turbine turbine(PR = PR, eta_turb = eta_turb, T_amb = T_amb,N_shaft=N_shaft) annotation(
		Placement(visible = true, transformation(origin = {74, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.CompressorOnShaft mainCompressor(PR = PR, eta_comp = eta_comp, p_out = p_high, T_amb = T_amb,N_compressor=N_shaft) annotation(
		Placement(visible = true, transformation(origin = {-60, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Cooler cooler(T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-66, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.CompressorOnShaft reCompressor(PR = PR, eta_comp = eta_comp, p_out = p_high, T_amb = T_amb,N_compressor=33294*0.10471975512) annotation(
		Placement(visible = true, transformation(origin = {-24, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.HeatRecuperatorDTAve LTR(N_q = N_q, flowGuess = 700, T_amb = T_amb, pinchRecuperator = pinchRecuperator) annotation(
		Placement(visible = true, transformation(origin = {-26, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.HeatRecuperatorDTAve HTR(N_q = N_q, flowGuess = 700, T_amb = T_amb, pinchRecuperator = pinchRecuperator) annotation(
		Placement(visible = true, transformation(origin = {26, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.FlowSplitter splitter(gamma = gamma) annotation(
		Placement(visible = true, transformation(origin = {-50, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.FlowMixer mixer annotation(
		Placement(visible = true, transformation(origin = {-2, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		
		// Variables to investigate the cycle and its simulation.
		
		Modelica.SIunits.Efficiency efficiencyCycle "Efficiency of the cycle";
		Real E_bal_check;
		SolarTherm.Types.SpecificWork W_out "Specific Work of the cycle";
		SolarTherm.Models.Analysis.Finances.Money C_LTR "cost of the low-temperature recuperator";
		SolarTherm.Models.Analysis.Finances.Money C_HTR "cost of the high-temperature recuperator";
		SolarTherm.Models.Analysis.Finances.Money C_turbine "cost of the turbine";
		SolarTherm.Models.Analysis.Finances.Money C_mainCompressor "cost of the compressor";
		SolarTherm.Models.Analysis.Finances.Money C_reCompressor "cost of the reCompressor";
		SolarTherm.Models.Analysis.Finances.Money C_exchanger "cost of the exchanger";
		SolarTherm.Models.Analysis.Finances.Money C_generator "cost of the generator";
		SolarTherm.Models.Analysis.Finances.Money C_cooler "cost of the cooler";
		SolarTherm.Models.Analysis.Finances.Money C_PB "Overall cost of the power block";
	
		Modelica.SIunits.Efficiency eta_carnot;
		// Exergy analysis
		Real ex_d_percent_mainCompressor "MainCompressor exergy destruction";
		Real ex_d_percent_LTR "LTR exergy destruction";
		Real ex_d_percent_HTRecuperator "HTRecuperator exergy destruction";
		Real ex_d_percent_reCompressor "reCompressor exergy destruction";
		Real ex_d_percent_exchanger "heater exergy destruction";
		Real ex_d_percent_turbine "turbine exergy destruction";
		Real ex_d_percent_cooler "cooler exergy destruction";
		SolarTherm.Types.SpecificExergy ex_d_tot "Total exergy destruction";
		SolarTherm.Types.SpecificExergy ex_in "Inlet of exergy at the heater";
		Modelica.SIunits.Efficiency eta_ex "Exergetic efficiency = P_nom/ex_in";
		Exchanger exchanger (T_amb=T_amb, redeclare package MedRec=SolarTherm.Media.SolidParticles.CarboHSP_ph) annotation(
		Placement(visible = true, transformation(origin = {46, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow src(T_out = T_high - 273.15, use_m_parameter = false, m_flow =730, p_out = 10 ^ 5, redeclare package MedPB = SolarTherm.Media.SolidParticles.CarboHSP_ph) annotation(
		Placement(visible = true, transformation(origin = {74, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
		SinkFlow sink annotation(
		Placement(visible = true, transformation(origin = {22, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	equation
		connect(src.port_b, exchanger.HTF_port_a) annotation(
		Line(points = {{66, 30}, {52, 30}, {52, 26}, {52, 26}}, color = {0, 127, 255}));
		connect(sink.port_a, exchanger.HTF_port_b) annotation(
		Line(points = {{30, 28}, {38, 28}, {38, 26}, {38, 26}}, color = {0, 127, 255}));
		connect(exchanger.CO2_port_b, turbine.port_a) annotation(
		Line(points = {{52, 16}, {70, 16}, {70, 14}, {70, 14}}, color = {0, 127, 255}));
		connect(HTR.from_comp_port_b, exchanger.CO2_port_a) annotation(
		Line(points = {{32, -8}, {38, -8}, {38, 16}, {38, 16}}, color = {0, 127, 255}));
// Connectors
		connect(splitter.one_gamma_port_b, cooler.port_a) annotation(
		Line(points = {{-58, -18}, {-58, -18}, {-58, -22}, {-66, -22}, {-66, -22}}, color = {0, 127, 255}));
		connect(splitter.port_a, LTR.from_turb_port_b) annotation(
		Line(points = {{-42, -18}, {-34, -18}, {-34, -18}, {-34, -18}}, color = {0, 127, 255}));
		connect(splitter.gamma_port_b, reCompressor.port_a) annotation(
		Line(points = {{-50, -10}, {-48, -10}, {-48, 20}, {-32, 20}, {-32, 20}}, color = {0, 127, 255}));
		connect(mainCompressor.port_b, LTR.from_comp_port_a) annotation(
		Line(points = {{-56, 10}, {-34, 10}, {-34, -8}, {-34, -8}, {-34, -8}}, color = {0, 127, 255}));
		connect(HTR.from_turb_port_b, LTR.from_turb_port_a) annotation(
		Line(points = {{18, -18}, {-20, -18}, {-20, -18}, {-20, -18}}, color = {0, 127, 255}));
		connect(LTR.from_comp_port_b, mixer.first_port_a) annotation(
		Line(points = {{-20, -8}, {-10, -8}, {-10, -8}, {-10, -8}}, color = {0, 127, 255}));
		connect(reCompressor.port_b, mixer.second_port_a) annotation(
		Line(points = {{-20, 8}, {0, 8}, {0, 0}, {-2, 0}, {-2, 0}}, color = {0, 127, 255}));
		connect(HTR.from_comp_port_a, mixer.port_b) annotation(
		Line(points = {{18, -8}, {6, -8}, {6, -8}, {6, -8}}, color = {0, 127, 255}));
		
		connect(turbine.port_b, HTR.from_turb_port_a) annotation(
		Line(points = {{80, 4}, {80, 4}, {80, -18}, {32, -18}, {32, -18}}, color = {0, 127, 255}));
		connect(cooler.port_b, mainCompressor.port_a) annotation(
		Line(points = {{-66, -6}, {-80, -6}, {-80, 22}, {-68, 22}, {-68, 22}, {-68, 22}}, color = {0, 127, 255}));
	 

// Cycle efficiency. Mass flow is imposed by the power equation.
		P_nom = (-turbine.W_turb) - (mainCompressor.W_comp + reCompressor.W_comp)-cooler.P_cooling;
		//P_nom=10^5+100*10^6*time;
		efficiencyCycle * exchanger.Q_HX_HTR = P_nom;
		E_bal_check = turbine.W_turb + mainCompressor.W_comp + reCompressor.W_comp + exchanger.Q_HX_HTR + cooler.Q_cooler;
		W_out = P_nom / turbine.port_a.m_flow;

	// Financial analysis
	
		C_LTR = 49.45*LTR.UA_HTR^0.7544;
		C_HTR= if HTR.T_from_turb[N_q]>=550+273.15 then 49.45*HTR.UA_HTR^0.7544*(1+0.02141*(HTR.T_from_turb[N_q]-550-273.15)) else 49.45*HTR.UA_HTR^0.7544;
		C_turbine= if T_high>= 550+273.15 then 406200*(-turbine.W_turb/10^6)^0.8*(1+1.137*10^(-5)*(T_high-550-273.15)^2) else 406200*(-turbine.W_turb/10^6)^0.8;
		C_mainCompressor = 1230000*(mainCompressor.W_comp/10^6)^0.3392;
		C_reCompressor = 1230000*(reCompressor.W_comp/10^6)^0.3392;
		C_cooler = 32.88*cooler.UA_cooler^0.75;
		C_generator = 108900*(P_nom/10^6)^0.5463;
		C_exchanger = pri_exchanger*exchanger.Q_HX_HTR/1000;
		C_PB=C_HTR+C_LTR+C_turbine+C_mainCompressor+C_reCompressor+C_generator+C_cooler+C_exchanger;
		
	// Exergy analysis
	
		ex_d_tot = mainCompressor.ex_d + LTR.ex_d + HTR.ex_d + reCompressor.ex_d + exchanger.ex_d + turbine.ex_d + cooler.ex_d;
		mainCompressor.ex_d * 100 / ex_d_tot = ex_d_percent_mainCompressor;
		LTR.ex_d * 100 / ex_d_tot = ex_d_percent_LTR;
		HTR.ex_d * 100 / ex_d_tot = ex_d_percent_HTRecuperator;
		reCompressor.ex_d * 100 / ex_d_tot = ex_d_percent_reCompressor;
		exchanger.ex_d * 100 / ex_d_tot = ex_d_percent_exchanger;
		turbine.ex_d * 100 / ex_d_tot = ex_d_percent_turbine;
		cooler.ex_d * 100 / ex_d_tot = ex_d_percent_cooler;
		ex_in = exchanger.Q_HX_HTR * (1 - T_amb / T_high);
		eta_ex = 1 - ex_d_tot / ex_in;
		eta_carnot = 1 - T_amb / T_high;
		annotation(
			Documentation(info = "<html>
				<p>On-design model of a recompression sCO2 cycle with exchanger. The number of discretization of the heat recuperators has to be discussed.</p>
				<p>The mass flow is either imposed by the nominal power or by the HTF mass flow rate.</p>
				<p>A calculation of the price is performed based on a cost estimation of the different components, from	Weiland et al.The uncertainty is between -30%/50%. Depending on the power block layout chosen, other correlations might have to be implemented (motor for the compressor, gearbox, ..). See the article for more informations.</p>
				<p> The currency is 2017$. The price of the exchanger is taken at 150$/kW_th because it is defined as the objective to reach for next-Gen CSP with particles</p>
				<p>An exergy analysis is implemented based on a class from Pr. Neveu (UPVD).</p>
				<p>N. T. Weiland, B. W. Lance, et S. R. Pidaparti, « SCO2 power cycle components cost correlations from DOE data spanning multiple scales and application », p. 17.</p>
				<p> Available at https://www.netl.doe.gov/projects/files/sCO2PowerCycleComponentCostCorrelationsfromDOEDataSpanningMultipleScalesandApplications_061819.pdf </p>
				<p>&nbsp;</p>
				</html>"),
			Icon,
			experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
			__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
	end RecompCycleExchanger;

	model IntercoolingCycle
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		//Parameters
		parameter Real deltaT_cooler = 15 "Approach difference of temperature at the outlet of the cooler";
		parameter Modelica.SIunits.AbsolutePressure p_high = 200 * 10 ^ 5 "high pressure of the cycle";
		parameter Modelica.SIunits.ThermodynamicTemperature T_high = 715 + 273.15 "inlet temperature of the turbine";
		parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 40 + 273.15 "ambiant temperature";
		parameter Real PR = 2.371 "Pressure ratio";
		parameter Modelica.SIunits.Power P_nom = 10 ^ 8 "Nominal electrical power";
		parameter Modelica.SIunits.Efficiency eta_comp = 0.87 "Isentropic efficiency of the compressors";
		parameter Modelica.SIunits.Efficiency eta_turb = 0.9 "Isentropic efficiency of the turbine";
		parameter Real gamma = 0.3 "Part of the mass flow going to the recompression directly";
		parameter Integer N_q = 15 "Number of discretization of the heat recuperators";
		// Instanciation of the components
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Heater heater(T_high = T_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {32, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Turbine turbine(PR = PR, eta_turb = eta_turb, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {74, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Compressor compressor1(PR = 1.5, eta_comp = eta_comp, p_out = p_high / PR * 1.5, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-66, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Compressor compressor2(PR = PR / 1.5, eta_comp = eta_comp, p_out = p_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-14, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Cooler cooler1(T_amb = T_amb, deltaT_cooler = deltaT_cooler) annotation(
		Placement(visible = true, transformation(origin = {-62, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Cooler cooler2(T_amb = T_amb, deltaT_cooler = deltaT_cooler) annotation(
		Placement(visible = true, transformation(origin = {-40, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.HeatRecuperator HTRecuperator(N_q = N_q, flowGuess = P_nom / 10 ^ 5, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-2, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		// Variables to investigate the cycle and its simulation.
		Modelica.SIunits.Efficiency efficiencyCycle;
		Real E_bal_check;
		//Exergy analysis
		Real ex_d_percent_compressor1 "First compressor exergy destruction";
		Real ex_d_percent_compressor2 "Second compressor exergy destruction";
		Real ex_d_percent_HTRecuperator "Recuperator exergy destruction";
		Real ex_d_percent_heater "heater exergy destruction";
		Real ex_d_percent_turbine "turbine exergy destruction";
		Real ex_d_percent_cooler1 "First cooler exergy destruction";
		Real ex_d_percent_cooler2 "Second cooler exergy destruction";
		SolarTherm.Types.SpecificExergy ex_d_tot "Total exergy destruction";
		SolarTherm.Types.SpecificExergy ex_in;
		Modelica.SIunits.Efficiency eta_ex "Exergetic efficiency";
	equation
//Connectors
		connect(compressor2.port_b, HTRecuperator.from_comp_port_a) annotation(
		Line(points = {{-10, 14}, {-10, 14}, {-10, -4}, {-10, -4}}, color = {0, 127, 255}));
		connect(cooler2.port_b, compressor2.port_a) annotation(
		Line(points = {{-40, 30}, {-22, 30}, {-22, 26}, {-22, 26}, {-22, 26}}, color = {0, 127, 255}));
		connect(compressor1.port_b, cooler2.port_a) annotation(
		Line(points = {{-62, 14}, {-40, 14}, {-40, 14}, {-40, 14}}, color = {0, 127, 255}));
		connect(cooler1.port_b, compressor1.port_a) annotation(
		Line(points = {{-62, 0}, {-82, 0}, {-82, 26}, {-74, 26}, {-74, 26}, {-74, 26}}, color = {0, 127, 255}));
		connect(HTRecuperator.from_turb_port_b, cooler1.port_a) annotation(
		Line(points = {{-10, -14}, {-10, -14}, {-10, -16}, {-62, -16}, {-62, -16}}, color = {0, 127, 255}));
		connect(HTRecuperator.from_turb_port_a, turbine.port_b) annotation(
		Line(points = {{4, -14}, {80, -14}, {80, 4}}, color = {0, 127, 255}));
		connect(HTRecuperator.from_comp_port_b, heater.port_a) annotation(
		Line(points = {{4, -4}, {4, 7}, {32, 7}, {32, 20}}, color = {0, 127, 255}));
		connect(heater.port_b, turbine.port_a) annotation(
		Line(points = {{32, 36}, {70, 36}, {70, 14}, {70, 14}}, color = {0, 127, 255}));
// cycle efficiency; mass flow is imposed with the Power equation.
		P_nom = (-turbine.W_turb) - compressor1.W_comp - compressor2.W_comp;
		efficiencyCycle * heater.Q_heater = P_nom;
		E_bal_check = turbine.W_turb + compressor1.W_comp + compressor2.W_comp + heater.Q_heater + cooler1.Q_cooler + cooler2.Q_cooler;
// Exergy analysis
		ex_d_tot = compressor1.ex_d + compressor2.ex_d + HTRecuperator.ex_d + heater.ex_d + turbine.ex_d + cooler1.ex_d + cooler2.ex_d;
		compressor1.ex_d * 100 / ex_d_tot = ex_d_percent_compressor1;
		compressor2.ex_d * 100 / ex_d_tot = ex_d_percent_compressor2;
		HTRecuperator.ex_d * 100 / ex_d_tot = ex_d_percent_HTRecuperator;
		heater.ex_d * 100 / ex_d_tot = ex_d_percent_heater;
		turbine.ex_d * 100 / ex_d_tot = ex_d_percent_turbine;
		cooler1.ex_d * 100 / ex_d_tot = ex_d_percent_cooler1;
		cooler2.ex_d * 100 / ex_d_tot = ex_d_percent_cooler2;
		ex_in = heater.Q_heater * (1 - T_amb / T_high);
		eta_ex = ((-turbine.W_turb) - compressor1.W_comp - compressor2.W_comp) / ex_in;
	end IntercoolingCycle;

	model simpleRecupCycleExchanger "Simple recuperation cycle with an exchanger"
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		//Parameters
		parameter Modelica.SIunits.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
		parameter Modelica.SIunits.ThermodynamicTemperature T_high = 800 + 273.15 "inlet temperature of the HTF";
		parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 30 + 273.15 "ambiant temperature";
		parameter Real PR = 2.5 "Pressure ratio";
		parameter Modelica.SIunits.Power P_nom = 100*10^6 "Nominal electrical power";
		parameter Modelica.SIunits.Efficiency eta_comp = 0.89 "Isentropic efficiency of the compressors";
		parameter Modelica.SIunits.Efficiency eta_turb = 0.93 "Isentropic efficiency of the turbine";
		parameter Integer N_q = 15 "Number of discretization of the heat recuperators";
		parameter SolarTherm.Models.Analysis.Finances.Money pri_turbomachinery = 1000 "price of the turbomachinery in $/kWe";
		parameter SolarTherm.Models.Analysis.Finances.Money pri_recuperators = 2500 "price of the heat recuperators in $/(kW_th/K) ";
		parameter SolarTherm.Models.Analysis.Finances.Money pri_exchanger = 5000 "price of the primary exchanger in $/(kW_th/K)";
		parameter SolarTherm.Models.Analysis.Finances.Money pri_cooler = 1700 "price of the cooler in $/(kW_th/K)";
		// Instanciation of the components
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Turbine turbine(PR = PR, eta_turb = eta_turb, T_amb = T_amb, is_second_turbine = true) annotation(
		Placement(visible = true, transformation(origin = {74, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.CompressorOnShaft mainCompressor(PR = PR, eta_comp = eta_comp, p_out = p_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-60, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Cooler cooler(T_amb = T_amb, P_nom = P_nom) annotation(
		Placement(visible = true, transformation(origin = {-66, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.HeatRecuperatorDTAve HTR(N_q = N_q, flowGuess = 120, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-2, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Exchanger exchanger(pinch = 5, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {36, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		//equivalent to T_Sodium = 700K
		SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sinkMS annotation(
		Placement(visible = true, transformation(origin = {-2, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		// Variables to investigate the cycle and its simulation.
		Modelica.SIunits.Efficiency efficiencyCycle;
		Real E_bal_check;
		SolarTherm.Models.Analysis.Finances.Money C_recuperators "cost of the recuperators";
		SolarTherm.Models.Analysis.Finances.Money C_turbomachinery "cost of the turbomachinery";
		SolarTherm.Models.Analysis.Finances.Money C_exchanger "cost of the exchanger";
		SolarTherm.Models.Analysis.Finances.Money C_cooler "cost of the cooler";
		SolarTherm.Models.Analysis.Finances.Money C_PB "Overall cost of the power block";
		//Exergy analysis
		Real ex_d_percent_Compressor "Compressor exergy destruction";
		Real ex_d_percent_HTR "Recuperator exergy destruction";
		Real ex_d_percent_exchanger "heater exergy destruction";
		Real ex_d_percent_turbine "turbine exergy destruction";
		Real ex_d_percent_cooler "cooler exergy destruction";
		SolarTherm.Types.SpecificExergy ex_d_tot "Total exergy destruction";
		SolarTherm.Types.SpecificExergy ex_in;
		Modelica.SIunits.Efficiency eta_ex "Exergetic efficiency";
		SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow srcMS(T_out = T_high - 273.15, use_m_parameter = false, m_flow = 1.48, p_out = 10 ^ 5, redeclare package MedPB = SolarTherm.Media.Sodium.ConstSodium) annotation(
		Placement(visible = true, transformation(origin = {60, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
	equation
		connect(srcMS.port_b, exchanger.HTF_port_a) annotation(
		Line(points = {{52, 40}, {40, 40}, {40, 16}, {42, 16}, {42, 16}}, color = {0, 127, 255}));
		connect(sinkMS.port_a, exchanger.HTF_port_b) annotation(
		Line(points = {{6, 30}, {28, 30}, {28, 16}, {28, 16}, {28, 16}}, color = {0, 127, 255}));
//Connections
		connect(exchanger.CO2_port_b, turbine.port_a) annotation(
		Line(points = {{42, 6}, {58, 6}, {58, 14}, {70, 14}, {70, 14}}, color = {0, 127, 255}));
		connect(HTR.from_comp_port_b, exchanger.CO2_port_a) annotation(
		Line(points = {{4, -4}, {28, -4}, {28, 6}, {28, 6}, {28, 6}}, color = {0, 127, 255}));
		connect(mainCompressor.port_b, HTR.from_comp_port_a) annotation(
		Line(points = {{-56, 10}, {-10, 10}, {-10, -4}}, color = {0, 127, 255}));
		connect(HTR.from_turb_port_b, cooler.port_a) annotation(
		Line(points = {{-9, -14}, {-9, -22}, {-66, -22}}, color = {0, 127, 255}));
		connect(HTR.from_turb_port_a, turbine.port_b) annotation(
		Line(points = {{4, -14}, {80, -14}, {80, 4}}, color = {0, 127, 255}));
		connect(cooler.port_b, mainCompressor.port_a) annotation(
		Line(points = {{-66, -6}, {-80, -6}, {-80, 22}, {-68, 22}, {-68, 22}, {-68, 22}}, color = {0, 127, 255}));
//fixes the mass flow
	P_nom = (-turbine.W_turb) - mainCompressor.W_comp-cooler.P_cooling;
//Calculates the energetic efficiency of the cycle
		efficiencyCycle * exchanger.Q_HX_HTR = P_nom;
//check the 1st law of thermodynamics
		E_bal_check = turbine.W_turb + mainCompressor.W_comp + exchanger.Q_HX_HTR + cooler.Q_cooler;
		
		//Financial analysis
		C_recuperators = pri_recuperators*(HTR.UA_HTR)/1000;
		C_turbomachinery = pri_turbomachinery*P_nom/1000;
		C_cooler = pri_cooler*cooler.UA_cooler/1000;
		C_exchanger = pri_exchanger*exchanger.UA_TLMD/1000;
		C_PB=C_recuperators+C_turbomachinery+C_cooler+C_exchanger;
		
// Exergy analysis
		ex_d_tot = mainCompressor.ex_d + HTR.ex_d + exchanger.ex_d + turbine.ex_d + cooler.ex_d;
		mainCompressor.ex_d * 100 / ex_d_tot = ex_d_percent_Compressor;
		HTR.ex_d * 100 / ex_d_tot = ex_d_percent_HTR;
		exchanger.ex_d * 100 / ex_d_tot = ex_d_percent_exchanger;
		turbine.ex_d * 100 / ex_d_tot = ex_d_percent_turbine;
		cooler.ex_d * 100 / ex_d_tot = ex_d_percent_cooler;
		ex_in = exchanger.Q_HX_HTR * (1 - T_amb / T_high);
		eta_ex = ((-turbine.W_turb) - mainCompressor.W_comp) / ex_in;
		annotation(
		__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
		experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
		Documentation(info = "<html>
		<p>On-design model of a simple recuperation cycle with an exchanger HTF/sCO2.&nbsp;</p>
	<p>The number of discretization of the recuperators ought to be discussed, as the Cp is not a constant and therefore the TLMD is not totally pertinent. The heat recuperator DTAve can be used as well. Results are very close. The discussion is more on the number N_q of elements (N_q=15 vs 40: 2°C difference at the outlet).</p>
	<p >Some attention has to be given to the source model (temperature, etc.).</p>
	<p >The mass flow is imposed by the electrical power output given as a parameter. The relation between mass flow of the HTF and CO2 is determined relatively to the Cp of each fluid.&nbsp;</p>
	<p>A financial analysis is performed based on estimation of the different costs, from Brun et al.</p>
	<p>An exergy analysis is implemented based on a class from Pr. Neveu (UPVD).</p>
	<p>K. Brun, P. Fredman, et R.Dennis, Fundamentals and applications of S-CO2 based power cycles. Book, 2017</p>
	<p>&nbsp;</p>
		</html>"));
	end simpleRecupCycleExchanger;

	model ModifiedRecompCycle "Model of the sCO2 recompression cycle. Convergence can get hard with higher power (interpolation + min(h_from_turb) as closing equation are probably the issues). This was overpassed by specifying a starting value for the mass flow"
		extends SolarTherm.Media.CO2.PropCO2;
		//Parameters
		parameter Modelica.SIunits.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
		parameter Modelica.SIunits.ThermodynamicTemperature T_high = 715 + 273.15 "inlet temperature of the turbine";
		parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 40 + 273.15 "ambiant	temperature";
		parameter Real PR = 2.371 "Pressure ratio";
		parameter Modelica.SIunits.Power P_nom = 10 ^ 8 "Nominal electrical power";
		parameter Modelica.SIunits.Efficiency eta_comp = 0.87 "Isentropic efficiency of the compressors";
		parameter Modelica.SIunits.Efficiency eta_turb = 0.9 "Isentropic efficiency of the turbine";
		parameter Real gamma = 0.7 "Part of the mass flow going to the recompression directly";
		parameter Integer N_q = 15 "Number of discretization of the heat recuperators";
		// Instanciation of the components
		SolarTherm.Models.PowerBlocks.sCO2Cycle.Heater heater(T_high = T_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {32, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.Turbine turbine(PR = PR, eta_turb = eta_turb, T_amb = T_amb, is_second_turbine = false) annotation(
		Placement(visible = true, transformation(origin = {74, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.Cooler cooler(T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-66, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.Compressor reCompressor(PR = PR, eta_comp = eta_comp, p_out = p_high, T_amb = T_amb, flowGuess = P_nom / 10 ^ 5 * (1 - gamma)) annotation(
		Placement(visible = true, transformation(origin = {2, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.HeatRecuperator LTRecuperator(N_q = N_q, flowGuess = P_nom / 10 ^ 5, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-26, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.HeatRecuperator HTRecuperator1(N_q = N_q, flowGuess = P_nom / 10 ^ 5, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {26, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.FlowMixer mixer annotation(
		Placement(visible = true, transformation(origin = {-2, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		// Variables to investigate the cycle and its simulation.
		Modelica.SIunits.Efficiency efficiencyCycle "Efficiency of the cycle";
		Real E_bal_check;
		SolarTherm.Types.SpecificWork W_out "Specific Work of the cycle";
		SolarTherm.Types.Conductance UA_LTR(start = 2 * 10 ^ 6);
		SolarTherm.Types.Conductance UA_HTR(start = 2 * 10 ^ 6);
		//Modelica.SIunits.Efficiency eta_carnot;
		// Exergy analysis
		//	Real ex_d_percent_mainCompressor "MainCompressor exergy destruction";
		//	Real ex_d_percent_LTRecuperator "LTRecuperator exergy destruction";
		//	Real ex_d_percent_HTRecuperator "HTRecuperator exergy destruction";
		//	Real ex_d_percent_reCompressor "reCompressor exergy destruction";
		//	Real ex_d_percent_heater "heater exergy destruction";
		//	Real ex_d_percent_turbine "turbine exergy destruction";
		//	Real ex_d_percent_cooler "cooler exergy destruction";
		//	SolarTherm.Types.SpecificExergy ex_d_tot "Total exergy destruction";
		//	SolarTherm.Types.SpecificExergy ex_in "Inlet of exergy at the heater";
		//	Modelica.SIunits.Efficiency eta_ex "Exergetic efficiency = P_nom/ex_in";
		SolarTherm.Models.PowerBlocks.sCO2Cycle.Compressor firstCompressor(PR = PR, eta_comp = eta_comp, p_out = p_high, flowGuess = P_nom / 10 ^ 5, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-66, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.FlowSplitter splitter(gamma = gamma) annotation(
		Placement(visible = true, transformation(origin = {-48, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.Cooler secondCooler annotation(
		Placement(visible = true, transformation(origin = {-34, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
		Compressor secondCompressor annotation(
		Placement(visible = true, transformation(origin = {-34, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	equation
		connect(secondCompressor.port_b, LTRecuperator.from_comp_port_a) annotation(
		Line(points = {{-30, 0}, {-34, 0}, {-34, -8}, {-34, -8}}, color = {0, 127, 255}));
		connect(secondCooler.port_b, secondCompressor.port_a) annotation(
		Line(points = {{-34, 20}, {-42, 20}, {-42, 12}, {-42, 12}, {-42, 12}}, color = {0, 127, 255}));
		connect(splitter.one_gamma_port_b, reCompressor.port_a) annotation(
		Line(points = {{-40, 48}, {-6, 48}, {-6, 24}, {-6, 24}, {-6, 24}}, color = {0, 127, 255}));
		connect(splitter.gamma_port_b, secondCooler.port_a) annotation(
		Line(points = {{-48, 40}, {-34, 40}, {-34, 36}, {-34, 36}, {-34, 36}}, color = {0, 127, 255}));
		connect(firstCompressor.port_b, splitter.port_a) annotation(
		Line(points = {{-58, 18}, {-58, 18}, {-58, 48}, {-56, 48}, {-56, 48}}, color = {0, 127, 255}));
		connect(cooler.port_b, firstCompressor.port_a) annotation(
		Line(points = {{-66, -6}, {-70, -6}, {-70, 6}, {-70, 6}, {-70, 6}}, color = {0, 127, 255}));
		connect(LTRecuperator.from_turb_port_b, cooler.port_a) annotation(
		Line(points = {{-34, -18}, {-34, -18}, {-34, -22}, {-66, -22}, {-66, -22}}, color = {0, 127, 255}));
		connect(reCompressor.port_b, mixer.second_port_a) annotation(
		Line(points = {{5, 13}, {0, 13}, {0, 0}, {-2, 0}}, color = {0, 127, 255}));
		connect(HTRecuperator1.from_turb_port_b, LTRecuperator.from_turb_port_a) annotation(
		Line(points = {{18, -18}, {-20, -18}, {-20, -18}, {-20, -18}}, color = {0, 127, 255}));
		connect(LTRecuperator.from_comp_port_b, mixer.first_port_a) annotation(
		Line(points = {{-20, -8}, {-10, -8}, {-10, -8}, {-10, -8}}, color = {0, 127, 255}));
		connect(HTRecuperator1.from_comp_port_a, mixer.port_b) annotation(
		Line(points = {{18, -8}, {6, -8}, {6, -8}, {6, -8}}, color = {0, 127, 255}));
		connect(heater.port_a, HTRecuperator1.from_comp_port_b) annotation(
		Line(points = {{32, 20}, {32, 20}, {32, -8}, {32, -8}}, color = {0, 127, 255}));
		connect(turbine.port_b, HTRecuperator1.from_turb_port_a) annotation(
		Line(points = {{80, 4}, {80, 4}, {80, -18}, {32, -18}, {32, -18}}, color = {0, 127, 255}));
		connect(heater.port_b, turbine.port_a) annotation(
		Line(points = {{32, 36}, {70, 36}, {70, 14}, {70, 14}}, color = {0, 127, 255}));
//Modelica doesn't instantiate those equations by itself.
		secondCompressor.port_b.h_outflow = LTRecuperator.from_comp_port_a.h_outflow;
		secondCooler.port_b.h_outflow = secondCompressor.port_a.h_outflow;
		splitter.one_gamma_port_b.h_outflow = reCompressor.port_a.h_outflow;
		splitter.gamma_port_b.h_outflow = secondCooler.port_a.h_outflow;
		firstCompressor.port_b.h_outflow = splitter.port_a.h_outflow;
		cooler.port_b.h_outflow = firstCompressor.port_a.h_outflow;
		LTRecuperator.from_turb_port_b.h_outflow = cooler.port_a.h_outflow;
		reCompressor.port_b.h_outflow = mixer.second_port_a.h_outflow;
		HTRecuperator1.from_turb_port_b.h_outflow = LTRecuperator.from_turb_port_a.h_outflow;
		LTRecuperator.from_comp_port_b.h_outflow = mixer.first_port_a.h_outflow;
		HTRecuperator1.from_comp_port_a.h_outflow = mixer.port_b.h_outflow;
		heater.port_a.h_outflow = HTRecuperator1.from_comp_port_b.h_outflow;
		turbine.port_b.h_outflow = HTRecuperator1.from_turb_port_a.h_outflow;
		heater.port_b.h_outflow = turbine.port_a.h_outflow;
// Overall equations
		P_nom = (-turbine.W_turb) - firstCompressor.W_comp - reCompressor.W_comp - secondCompressor.W_comp;
		efficiencyCycle * heater.Q_heater = P_nom;
		E_bal_check = turbine.W_turb + firstCompressor.W_comp + reCompressor.W_comp + secondCompressor.W_comp + heater.Q_heater + cooler.Q_cooler + secondCooler.Q_cooler;
		W_out = P_nom / turbine.port_a.m_flow;
		UA_LTR = sum(LTRecuperator.UA_dis);
		UA_HTR = sum(HTRecuperator1.UA_dis);
// Exergy analysis
//	ex_d_tot = mainCompressor.ex_d + LTRecuperator.ex_d + HTRecuperator1.ex_d + reCompressor.ex_d + heater.ex_d + turbine.ex_d + cooler.ex_d;
//	mainCompressor.ex_d * 100 / ex_d_tot = ex_d_percent_mainCompressor;
//	LTRecuperator.ex_d * 100 / ex_d_tot = ex_d_percent_LTRecuperator;
//	HTRecuperator1.ex_d * 100 / ex_d_tot = ex_d_percent_HTRecuperator;
//	reCompressor.ex_d * 100 / ex_d_tot = ex_d_percent_reCompressor;
//	heater.ex_d * 100 / ex_d_tot = ex_d_percent_heater;
//	turbine.ex_d * 100 / ex_d_tot = ex_d_percent_turbine;
//	cooler.ex_d * 100 / ex_d_tot = ex_d_percent_cooler;
//	ex_in = heater.Q_heater * (1 - T_amb / T_high);
//	eta_ex = 1 - ex_d_tot / ex_in;
//	eta_carnot = 1 - T_amb / T_high;
		annotation(
		Icon);
	end ModifiedRecompCycle;

	model simpleRecupCycleHeater
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		//Parameters
		parameter Modelica.SIunits.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
		parameter Modelica.SIunits.ThermodynamicTemperature T_high = 600 + 273.15 "inlet temperature of the turbine";
		parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 30 + 273.15 "ambiant temperature";
		parameter Real PR = 3 "Pressure ratio";
		parameter Modelica.SIunits.Power P_nom = 57000 "Nominal electrical power";
		parameter Modelica.SIunits.Efficiency eta_comp = 0.89 "Isentropic efficiency of the compressors";
		parameter Modelica.SIunits.Efficiency eta_turb = 0.93 "Isentropic efficiency of the turbine";
		parameter Integer N_q = 15 "Number of discretization of the heat recuperators";
		// Instanciation of the components
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Turbine turbine(PR = PR, eta_turb = eta_turb, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {74, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Compressor mainCompressor(PR = PR, eta_comp = eta_comp, p_out = p_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-60, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Cooler cooler(T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-66, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.HeatRecuperator HTRecuperator(N_q = N_q, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-2, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Heater heater(T_high = T_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {30, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		// Variables to investigate the cycle and its simulation.
		Modelica.SIunits.Efficiency efficiencyCycle;
		Real E_bal_check;
		//Exergy analysis
		Real ex_d_percent_Compressor "Compressor exergy destruction";
		Real ex_d_percent_HTRecuperator "Recuperator exergy destruction";
		Real ex_d_percent_heater "heater exergy destruction";
		Real ex_d_percent_turbine "turbine exergy destruction";
		Real ex_d_percent_cooler "cooler exergy destruction";
		SolarTherm.Types.SpecificExergy ex_d_tot "Total exergy destruction";
		SolarTherm.Types.SpecificExergy ex_in;
		Modelica.SIunits.Efficiency eta_ex "Exergetic efficiency";
	equation
//Connections
		connect(heater.port_b, turbine.port_a) annotation(
		Line(points = {{30, 14}, {70, 14}, {70, 14}, {70, 14}}, color = {0, 127, 255}));
		connect(HTRecuperator.from_comp_port_b, heater.port_a) annotation(
		Line(points = {{4, -4}, {30, -4}, {30, -2}, {30, -2}}, color = {0, 127, 255}));
		connect(mainCompressor.port_b, HTRecuperator.from_comp_port_a) annotation(
		Line(points = {{-56, 10}, {-10, 10}, {-10, -4}}, color = {0, 127, 255}));
		connect(HTRecuperator.from_turb_port_b, cooler.port_a) annotation(
		Line(points = {{-9, -14}, {-9, -22}, {-66, -22}}, color = {0, 127, 255}));
		connect(HTRecuperator.from_turb_port_a, turbine.port_b) annotation(
		Line(points = {{4, -14}, {80, -14}, {80, 4}}, color = {0, 127, 255}));
		connect(cooler.port_b, mainCompressor.port_a) annotation(
		Line(points = {{-66, -6}, {-80, -6}, {-80, 22}, {-68, 22}, {-68, 22}, {-68, 22}}, color = {0, 127, 255}));
//fixes the mass flow
		P_nom = (-turbine.W_turb) - mainCompressor.W_comp;
//Calculates the energetic efficiency of the cycle
		efficiencyCycle * heater.Q_heater = P_nom;
//check the 1st law of thermodynamics
		E_bal_check = turbine.W_turb + mainCompressor.W_comp + heater.Q_heater + cooler.Q_cooler;
// Exergy analysis
		ex_d_tot = mainCompressor.ex_d + HTRecuperator.ex_d + heater.ex_d + turbine.ex_d + cooler.ex_d;
		mainCompressor.ex_d * 100 / ex_d_tot = ex_d_percent_Compressor;
		HTRecuperator.ex_d * 100 / ex_d_tot = ex_d_percent_HTRecuperator;
		heater.ex_d * 100 / ex_d_tot = ex_d_percent_heater;
		turbine.ex_d * 100 / ex_d_tot = ex_d_percent_turbine;
		cooler.ex_d * 100 / ex_d_tot = ex_d_percent_cooler;
		ex_in = heater.Q_heater * (1 - T_amb / T_high);
		eta_ex = ((-turbine.W_turb) - mainCompressor.W_comp) / ex_in;
		annotation(
		__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
		experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
	end simpleRecupCycleHeater;

	model RecompCycleHeater "Model of the sCO2 recompression cycle. Convergence can get hard with higher power (interpolation + min(h_from_turb) as closing equation are probably the issues). This was overpassed by specifying a starting value for the mass flow"
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		//Parameters
		parameter Modelica.SIunits.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
		parameter Modelica.SIunits.ThermodynamicTemperature T_high = 690 + 273.15 "inlet temperature of the turbine";
		parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 30 + 273.15 "ambiant	temperature";
		parameter Real PR = 2.777 "Pressure ratio";
		parameter Modelica.SIunits.Power P_nom = 10 * 10 ^ 6 "Nominal electrical power";
		parameter Modelica.SIunits.Efficiency eta_comp = 0.89 "Isentropic efficiency of the compressors";
		parameter Modelica.SIunits.Efficiency eta_turb = 0.93 "Isentropic efficiency of the turbine";
		parameter Real gamma = 0.284 "Part of the mass flow going to the recompression directly";
		parameter Integer N_q = 40 "Number of discretization of the heat recuperators";
		parameter Real pinchRecuperator = 5;
		// Instanciation of the components
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Heater heater(T_high = T_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {32, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Turbine turbine(PR = PR, eta_turb = eta_turb, T_amb = T_amb, is_second_turbine = false) annotation(
		Placement(visible = true, transformation(origin = {74, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Compressor mainCompressor(PR = PR, eta_comp = eta_comp, p_out = p_high, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-60, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Cooler cooler(T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-66, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.Compressor reCompressor(PR = PR, eta_comp = 0.87, p_out = 257.51 * 10 ^ 5, T_amb = T_amb) annotation(
		Placement(visible = true, transformation(origin = {-24, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.HeatRecuperator LTRecuperator(N_q = N_q, flowGuess = P_nom / 10 ^ 5, T_amb = T_amb, pinchRecuperator = pinchRecuperator) annotation(
		Placement(visible = true, transformation(origin = {-26, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.HeatRecuperator HTRecuperator1(N_q = N_q, flowGuess = P_nom / 10 ^ 5, T_amb = T_amb, pinchRecuperator = pinchRecuperator) annotation(
		Placement(visible = true, transformation(origin = {26, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.FlowSplitter splitter(gamma = gamma) annotation(
		Placement(visible = true, transformation(origin = {-50, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		SolarTherm.Models.PowerBlocks.sCO2Cycle.FlowMixer mixer annotation(
		Placement(visible = true, transformation(origin = {-2, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		// Variables to investigate the cycle and its simulation.
		Modelica.SIunits.Efficiency efficiencyCycle "Efficiency of the cycle";
		Real E_bal_check;
		SolarTherm.Types.SpecificWork W_out "Specific Work of the cycle";
		//SolarTherm.Types.Conductance UA_LTR(start = 2 * 10 ^ 6);
		//SolarTherm.Types.Conductance UA_HTR(start = 2 * 10 ^ 6);
		Modelica.SIunits.Efficiency eta_carnot;
		// Exergy analysis
		Real ex_d_percent_mainCompressor "MainCompressor exergy destruction";
		Real ex_d_percent_LTRecuperator "LTRecuperator exergy destruction";
		Real ex_d_percent_HTRecuperator "HTRecuperator exergy destruction";
		Real ex_d_percent_reCompressor "reCompressor exergy destruction";
		Real ex_d_percent_heater "heater exergy destruction";
		Real ex_d_percent_turbine "turbine exergy destruction";
		Real ex_d_percent_cooler "cooler exergy destruction";
		SolarTherm.Types.SpecificExergy ex_d_tot "Total exergy destruction";
		SolarTherm.Types.SpecificExergy ex_in "Inlet of exergy at the heater";
		Modelica.SIunits.Efficiency eta_ex "Exergetic efficiency = P_nom/ex_in";
	equation
// Connectors
		connect(splitter.one_gamma_port_b, cooler.port_a) annotation(
		Line(points = {{-58, -18}, {-58, -18}, {-58, -22}, {-66, -22}, {-66, -22}}, color = {0, 127, 255}));
		connect(splitter.port_a, LTRecuperator.from_turb_port_b) annotation(
		Line(points = {{-42, -18}, {-34, -18}, {-34, -18}, {-34, -18}}, color = {0, 127, 255}));
		connect(splitter.gamma_port_b, reCompressor.port_a) annotation(
		Line(points = {{-50, -10}, {-48, -10}, {-48, 20}, {-32, 20}, {-32, 20}}, color = {0, 127, 255}));
		connect(mainCompressor.port_b, LTRecuperator.from_comp_port_a) annotation(
		Line(points = {{-56, 10}, {-34, 10}, {-34, -8}, {-34, -8}, {-34, -8}}, color = {0, 127, 255}));
		connect(HTRecuperator1.from_turb_port_b, LTRecuperator.from_turb_port_a) annotation(
		Line(points = {{18, -18}, {-20, -18}, {-20, -18}, {-20, -18}}, color = {0, 127, 255}));
		connect(LTRecuperator.from_comp_port_b, mixer.first_port_a) annotation(
		Line(points = {{-20, -8}, {-10, -8}, {-10, -8}, {-10, -8}}, color = {0, 127, 255}));
		connect(reCompressor.port_b, mixer.second_port_a) annotation(
		Line(points = {{-20, 8}, {0, 8}, {0, 0}, {-2, 0}, {-2, 0}}, color = {0, 127, 255}));
		connect(HTRecuperator1.from_comp_port_a, mixer.port_b) annotation(
		Line(points = {{18, -8}, {6, -8}, {6, -8}, {6, -8}}, color = {0, 127, 255}));
		connect(heater.port_a, HTRecuperator1.from_comp_port_b) annotation(
		Line(points = {{32, 20}, {32, 20}, {32, -8}, {32, -8}}, color = {0, 127, 255}));
		connect(turbine.port_b, HTRecuperator1.from_turb_port_a) annotation(
		Line(points = {{80, 4}, {80, 4}, {80, -18}, {32, -18}, {32, -18}}, color = {0, 127, 255}));
		connect(cooler.port_b, mainCompressor.port_a) annotation(
		Line(points = {{-66, -6}, {-80, -6}, {-80, 22}, {-68, 22}, {-68, 22}, {-68, 22}}, color = {0, 127, 255}));
		connect(heater.port_b, turbine.port_a) annotation(
		Line(points = {{32, 36}, {70, 36}, {70, 14}, {70, 14}}, color = {0, 127, 255}));
//Modelica doesn't instantiate those equations by itself.
// Cycle efficiency. Mass flow is imposed by the power equation.
		P_nom = (-turbine.W_turb) - (mainCompressor.W_comp + reCompressor.W_comp);
		efficiencyCycle * heater.Q_heater = P_nom;
		E_bal_check = turbine.W_turb + mainCompressor.W_comp + reCompressor.W_comp + heater.Q_heater + cooler.Q_cooler;
		W_out = P_nom / turbine.port_a.m_flow;
//	UA_LTR = sum(LTRecuperator.UA_dis);
//	UA_HTR = sum(HTRecuperator1.UA_dis);
// Exergy analysis
		ex_d_tot = mainCompressor.ex_d + LTRecuperator.ex_d + HTRecuperator1.ex_d + reCompressor.ex_d + heater.ex_d + turbine.ex_d + cooler.ex_d;
		mainCompressor.ex_d * 100 / ex_d_tot = ex_d_percent_mainCompressor;
		LTRecuperator.ex_d * 100 / ex_d_tot = ex_d_percent_LTRecuperator;
		HTRecuperator1.ex_d * 100 / ex_d_tot = ex_d_percent_HTRecuperator;
		reCompressor.ex_d * 100 / ex_d_tot = ex_d_percent_reCompressor;
		heater.ex_d * 100 / ex_d_tot = ex_d_percent_heater;
		turbine.ex_d * 100 / ex_d_tot = ex_d_percent_turbine;
		cooler.ex_d * 100 / ex_d_tot = ex_d_percent_cooler;
		ex_in = heater.Q_heater * (1 - T_amb / T_high);
		eta_ex = 1 - ex_d_tot / ex_in;
		eta_carnot = 1 - T_amb / T_high;
		annotation(
		Icon);
	end RecompCycleHeater;
end Cycles;
