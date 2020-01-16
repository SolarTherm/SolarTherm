within SolarTherm.Models.PowerBlocks.sCO2Cycle;

package OnDesign "On-design calculation of the components"
  package Cycles "Few different sCO2 cycles."
    model InterCoolHeat
      extends SolarTherm.Media.CO2.PropCO2;
      replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
      //Parameters
      parameter Modelica.SIunits.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
      parameter Modelica.SIunits.ThermodynamicTemperature T_high = 775 + 273.15 "inlet temperature of the turbine";
      parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 40 + 273.15 "ambiant  temperature";
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
      parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 30 + 273.15 "ambiant  temperature";
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
    <p>A calculation of the price is performed based on a cost estimation of the different components, from  Weiland et al.The uncertainty is between -30%/50%. Depending on the power block layout chosen, other correlations might have to be implemented (motor for the compressor, gearbox, ..). See the article for more informations.</p>
    <p> The currency is 2017$. The price of the exchanger is taken at 150$/kW_th because it is defined as the objective to reach for next-Gen CSP with particles</p>
    <p>An exergy analysis is implemented based on a class from Pr. Neveu (UPVD).</p>
    <p>N. T. Weiland, B. W. Lance, et S. R. Pidaparti, « SCO2 power cycle components cost correlations from DOE data spanning multiple scales and application », p. 17.</p>
    <p> Available at https://www.netl.doe.gov/projects/files/sCO2PowerCycleComponentCostCorrelationsfromDOEDataSpanningMultipleScalesandApplications_061819.pdf </p>
    <p>&nbsp;</p>
    		</html>"));
      annotation(
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
      parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 40 + 273.15 "ambiant  temperature";
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
      //  Real ex_d_percent_mainCompressor "MainCompressor exergy destruction";
      //  Real ex_d_percent_LTRecuperator "LTRecuperator exergy destruction";
      //  Real ex_d_percent_HTRecuperator "HTRecuperator exergy destruction";
      //  Real ex_d_percent_reCompressor "reCompressor exergy destruction";
      //  Real ex_d_percent_heater "heater exergy destruction";
      //  Real ex_d_percent_turbine "turbine exergy destruction";
      //  Real ex_d_percent_cooler "cooler exergy destruction";
      //  SolarTherm.Types.SpecificExergy ex_d_tot "Total exergy destruction";
      //  SolarTherm.Types.SpecificExergy ex_in "Inlet of exergy at the heater";
      //  Modelica.SIunits.Efficiency eta_ex "Exergetic efficiency = P_nom/ex_in";
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
//  ex_d_tot = mainCompressor.ex_d + LTRecuperator.ex_d + HTRecuperator1.ex_d + reCompressor.ex_d + heater.ex_d + turbine.ex_d + cooler.ex_d;
//  mainCompressor.ex_d * 100 / ex_d_tot = ex_d_percent_mainCompressor;
//  LTRecuperator.ex_d * 100 / ex_d_tot = ex_d_percent_LTRecuperator;
//  HTRecuperator1.ex_d * 100 / ex_d_tot = ex_d_percent_HTRecuperator;
//  reCompressor.ex_d * 100 / ex_d_tot = ex_d_percent_reCompressor;
//  heater.ex_d * 100 / ex_d_tot = ex_d_percent_heater;
//  turbine.ex_d * 100 / ex_d_tot = ex_d_percent_turbine;
//  cooler.ex_d * 100 / ex_d_tot = ex_d_percent_cooler;
//  ex_in = heater.Q_heater * (1 - T_amb / T_high);
//  eta_ex = 1 - ex_d_tot / ex_in;
//  eta_carnot = 1 - T_amb / T_high;
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
      parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 30 + 273.15 "ambiant  temperature";
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
//  UA_LTR = sum(LTRecuperator.UA_dis);
//  UA_HTR = sum(HTRecuperator1.UA_dis);
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

  model CompressorNVarying "Model 0D of a sCO2 compressor"
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {42, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter Real eta_comp = 0.87 "isentropic efficiency of the compressor";
    parameter Real PR = 2.313 "Pressure ratio";
    parameter Modelica.SIunits.AbsolutePressure p_out = 250 * 10 ^ 5 "outlet pressure";
    parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 273.15 + 40 "Outlet temperature in Kelvin";
    parameter Real flowGuess = 1000;
    MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
    MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
    MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
    Modelica.SIunits.Power W_comp "power used for compression";
    SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
    Modelica.SIunits.SpecificEntropy s_entrance "exergy at the entrance of the compressor";
    Real d_entrance;
    parameter Real phi_opt = 0.0297035;
    parameter Real psi_opt = 0.461819;
    Real diam_rotor;
    Real tipSpeed;
    Real N_compressor;
  protected
    Real mFlow(start = flowGuess);
  equation
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    s_entrance = MedPB.specificEntropy(state_a);
    state_isen = MedPB.setState_psX(p_out, s_entrance);
    state_b = MedPB.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) / eta_comp);
    port_b.p = state_b.p;
    port_b.h_outflow = state_b.h;
    mFlow = port_a.m_flow;
    W_comp = port_a.m_flow * (state_b.h - state_a.h);
    port_a.m_flow + port_b.m_flow = 0;
    ex_d = W_comp + port_a.m_flow * (state_a.h - T_amb * MedPB.specificEntropy(state_a)) + port_b.m_flow * (state_b.h - T_amb * MedPB.specificEntropy(state_b));
    d_entrance = MedPB.density(state_a);
    port_a.h_outflow = 0;
// Compressor on-design parameters to be calculated
    tipSpeed = diam_rotor * N_compressor / 2;
    phi_opt = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2);
    psi_opt = (state_isen.h - state_a.h) / tipSpeed ^ 2;
    annotation(
      Diagram(graphics = {Text(origin = {-20, 18}, extent = {{-28, 16}, {42, -46}}, textString = "COMPRESSOR"), Polygon(origin = {-12, 10}, points = {{-42, 40}, {-42, -44}, {42, -70}, {42, 70}, {-42, 40}, {-42, 40}})}, coordinateSystem(initialScale = 0.1)),
  Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-26, -2}, points = {{-40, 42}, {-42, -48}, {42, -78}, {42, 78}, {-40, 42}}), Text(origin = {-16, 11}, extent = {{-48, -31}, {24, 15}}, textString = "COMPRESSOR")}));
    annotation(
      Documentation(info = "<html>
  		<p>This compressor is supposed to run on another shaft than the turbine's one. This model is not really satisfying in the off-design calculations: the convergence on the N_compressor is complicated.</p>
  <p>The compressor model comes from the thesis of J. Dyreby.</p>
  <p>Phi corresponds to the adimensionned mass flow rate and psi to the adimensioned head. Because of the difference in the shaft speed regarding Dyreby's thesis, it is necessary to compensate in the off-design model by the on-design head.</p>
  <p>Parameters to integrate in the off-design PB model are:</p>
  <p>
  <ul>
  <li>The rotor diameter</li>
  <li>The actual head (psi_actual)</li>
  <li>The isentropic efficiency at design point (chosen) </li>
  <li>
  </ul>
  </p>
  <p>J. J. Dyreby, &laquo;&nbsp;Modeling the supercritical
  carbon dioxide Brayton cycle with recompression&nbsp;&raquo;, The University of
  Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  		</html>"));
  end CompressorNVarying;

  model Turbine
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    outer Modelica.Fluid.System system;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-32, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-38, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter Real eta_turb = 0.9 "isentropic efficiency of the turbine";
    parameter Real PR = 2.313 "Pressure ratio";
    parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 273.15 + 40 "Outlet temperature in Kelvin";
    parameter Boolean is_second_turbine = false;
    parameter Modelica.SIunits.MassFlowRate flowGuess=100;
    
    // This last parameter, when put to true, adds a mass_flow equality equation. Reason is, you need one and only one component in the cycle without mass flow or else you will have too much equation and circular equality issues. therefore, when adding turbines, this equation should be present (or when it's an open-cycle).
    MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
    MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic decompression";
    MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real decompresssion";
    Modelica.SIunits.Power W_turb "Outlet power";
    SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
    Modelica.SIunits.SpecificEntropy s_entrance " entropy at the entrance of the turbine";
    Modelica.SIunits.Area A_nozzle (start=10^(-3));
    parameter Real N_shaft = 75000 * 5 / 6 * 2 * 3.14159 / 60;
    Real d_outlet;
    Real C_spouting (start=500);
    Real diam_turb;
    Real tipSpeed (start=400);
  protected
    Modelica.SIunits.MassFlowRate mStart (start=flowGuess);
  equation
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    s_entrance = MedPB.specificEntropy(state_a);
    state_isen = MedPB.setState_psX(state_a.p / PR, s_entrance);
    state_b = MedPB.setState_phX(state_a.p / PR, state_a.h + (state_isen.h - state_a.h) * eta_turb);
    port_b.p = state_b.p;
    port_b.h_outflow = state_b.h;
    W_turb = port_a.m_flow * (state_b.h - state_a.h);
    port_a.m_flow + port_b.m_flow = 0;
    mStart= port_a.m_flow;
    ex_d = W_turb + port_a.m_flow * (state_a.h - T_amb * MedPB.specificEntropy(state_a)) + port_b.m_flow * (state_b.h - T_amb * MedPB.specificEntropy(state_b));
    d_outlet = MedPB.density(state_b);
    port_a.m_flow = C_spouting * A_nozzle * d_outlet;
    C_spouting ^ 2 = 2 * (state_a.h - state_isen.h);
    tipSpeed = N_shaft * diam_turb / 2;
    tipSpeed / C_spouting = 0.707;
    port_a.h_outflow = inStream(port_b.h_outflow);
    annotation(
      Diagram(graphics = {Text(origin = {-36, -28}, extent = {{18, 80}, {78, 16}}, textString = "TURBINE"), Polygon(origin = {15, 20}, points = {{-35, 44}, {-35, -52}, {35, -68}, {35, 68}, {-35, 44}, {35, 68}, {-35, 44}})}, coordinateSystem(initialScale = 0.1)),
  Icon(graphics = {Text(origin = {-10, 26}, extent = {{-10, 12}, {52, -34}}, textString = "TURBINE"), Ellipse(extent = {{56, 58}, {56, 58}}, endAngle = 360), Polygon(origin = {11, 17}, points = {{-37, 49}, {-37, -51}, {37, -71}, {37, 71}, {-37, 49}})}, coordinateSystem(initialScale = 0.1)));
    annotation(
      Documentation(info = "<html>
  		<p>&nbsp;</p>
  <div>0D Model of a sCO2 turbine.</div>
  <div>The model is based on the thesis of J. Dyreby. The diameter of the turbine is calculated in order to maximize the efficiency at the design point.</div>
  <div></div>
  <div>The on-design calculation of the cycle gives us as results to be integrated in the off-design power blocks:</div>
  <div>
  <ul>
  <li>Diameter of the turbine</li>
  <li>Area of the nozzle</li>
  </ul>
  </div>
  <p>J. J. Dyreby, &laquo;&nbsp;Modeling the supercritical
  carbon dioxide Brayton cycle with recompression&nbsp;&raquo;, The University of
  Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  <p>&nbsp;</p>
  		</html>"));
  end Turbine;

  model HeatRecuperatorDTAve "1D model of the heat recuperator. "
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    parameter Integer N_q = 15 "Number of discretisation of the heat exchanger";
    parameter Real flowGuess = 100 "guess value for the mass flow; given as Pnom/10^5 in the cycles";
    parameter Real pinchRecuperator = 5 "pinch of the recuperator. Imposed as a closing equation";
    parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 40 + 273.15;
    Modelica.Fluid.Interfaces.FluidPort_a from_comp_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a from_turb_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_comp_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_turb_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.SIunits.SpecificEnthalpy[N_q] h_from_turb(start = {500000 for i in 1:N_q});
    Modelica.SIunits.ThermodynamicTemperature[N_q] T_from_turb(start = {500 for i in 1:N_q});
    Modelica.SIunits.SpecificEnthalpy[N_q] h_from_comp(start = {500000 for i in 1:N_q});
    Modelica.SIunits.ThermodynamicTemperature[N_q] T_from_comp(start = {500 for i in 1:N_q});
    Real[N_q] deltaT "Temperature difference in the heat exchangers";
    SolarTherm.Types.Conductance UA_dis[N_q - 1] "Conductance per sub-heat exchanger";
    SolarTherm.Types.Conductance UA_HTR "Conductance of the overall HX";
    //Real deltaT_TLMD "overall logarithmic temperature difference for the price estiamtes";
    Modelica.SIunits.HeatFlowRate Q_HX_HTR;
    Modelica.SIunits.HeatFlowRate Q_HX_HTR_dis;
    // gives a start value to the mass flow, taken as P_nom/10⁵; allows easier convergence
    SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
  protected
    MedPB.ThermodynamicState[N_q] state_from_turb;
    MedPB.ThermodynamicState[N_q] state_from_comp;
    Real m_flowStart(start = flowGuess);
  equation
    for i in 1:N_q loop
      deltaT[i] = T_from_turb[i] - T_from_comp[i];
      state_from_turb[i] = MedPB.setState_phX(from_turb_port_b.p + (i - 1) / (N_q - 1) * (from_turb_port_a.p - from_turb_port_b.p), h_from_turb[i]);
      state_from_comp[i] = MedPB.setState_phX(from_comp_port_a.p + (i - 1) / (N_q - 1) * (from_comp_port_b.p - from_comp_port_a.p), h_from_comp[i]);
      T_from_turb[i] = MedPB.temperature(state_from_turb[i]);
      T_from_comp[i] = MedPB.temperature(state_from_comp[i]);
    end for;
    h_from_turb[N_q] = inStream(from_turb_port_a.h_outflow);
    h_from_comp[1] = inStream(from_comp_port_a.h_outflow);
    from_turb_port_b.h_outflow = h_from_turb[1];
    from_comp_port_b.h_outflow = h_from_comp[N_q];
    min(deltaT) = pinchRecuperator;
    Q_HX_HTR = Q_HX_HTR_dis * (N_q - 1);
    UA_HTR = sum(UA_dis);
    //deltaT_TLMD= if deltaT[1] * deltaT[N_q] <= 0 then (abs(deltaT[1]) ^ (1 / 3) * sign(deltaT[1]) / 2 + abs(deltaT[N_q]) ^ (1 / 3) * sign(deltaT[N_q]) / 2) ^ 3 else (deltaT[1] - deltaT[N_q]) / (Modelica.Math.log(deltaT[1] / deltaT[N_q]) + 0.0001);
    for i in 2:N_q loop
      Q_HX_HTR_dis = from_comp_port_a.m_flow * (h_from_comp[i] - h_from_comp[i - 1]);
      Q_HX_HTR_dis = UA_dis[i - 1] * (T_from_turb[i - 1] - T_from_comp[i - 1] + T_from_turb[i] - T_from_comp[i]) / 2;
      Q_HX_HTR_dis = from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]);
    end for;
    from_turb_port_b.m_flow + from_turb_port_a.m_flow = 0;
    from_comp_port_b.m_flow + from_comp_port_a.m_flow = 0;
    m_flowStart = from_turb_port_a.m_flow;
    from_comp_port_a.h_outflow = 0;
    from_turb_port_a.h_outflow = inStream(from_turb_port_b.h_outflow);
    from_turb_port_b.p = from_turb_port_a.p;
    from_comp_port_b.p = from_comp_port_a.p;
    ex_d = from_turb_port_a.m_flow * (state_from_turb[N_q].h - T_amb * MedPB.specificEntropy(state_from_turb[N_q])) + from_turb_port_b.m_flow * (state_from_turb[1].h - T_amb * MedPB.specificEntropy(state_from_turb[1])) + from_comp_port_b.m_flow * (state_from_comp[N_q].h - T_amb * MedPB.specificEntropy(state_from_comp[N_q])) + from_comp_port_a.m_flow * (state_from_comp[1].h - T_amb * MedPB.specificEntropy(state_from_comp[1]));
    annotation(
      Diagram(graphics = {Rectangle(origin = {1, 7}, extent = {{-61, 31}, {61, -31}}), Text(origin = {5, 1}, extent = {{-53, -17}, {53, 17}}, textString = "RECUPERATOR")}),
  Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-65, 33}, {65, -33}}), Text(origin = {-2, -5}, extent = {{-46, -15}, {46, 15}}, textString = "RECUPERATOR")}));
    annotation(
      Documentation(info = "<html>
  		<p>&nbsp;</p>
  		<p> The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation.</p>
  <p>This subdivision is based on the heat exchanged between both sides: it is even for all subdivision (Q_HX_HTR_dis).&nbsp;</p>
  <p>The closure equations are first the equality of the heat exchanged in every sub-HX and by imposing a pinch (of 5&deg;C in general).</p>
  <p> The conductance in each sub-HX is calculated with Q=UA*DTAverage, DTAverage being the average between the inlet and outlet delta T.
  <p>The parameters to integrate in the off-design PB are the UA_dis, which can be done with the CSV button.&nbsp;</p>
  <p>&nbsp;</p>
  		</html>"));
  end HeatRecuperatorDTAve;

  model Heater "Simple heater model"
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    parameter Modelica.SIunits.ThermodynamicTemperature T_high = 273.15 + 715 "Outlet temperature in Kelvin";
    parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 273.15 + 40 "Outlet temperature in Kelvin";
    Modelica.SIunits.HeatFlowRate Q_heater "heat transfer in the heater";
    MedPB.ThermodynamicState state_a "Thermodynamic State at the entrance";
    MedPB.ThermodynamicState state_b "Thermodynamic State at the outlet";
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-2, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
  equation
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    state_b = MedPB.setState_pTX(port_a.p, T_high);
    Q_heater = port_a.m_flow * (MedPB.specificEnthalpy(state_b) - MedPB.specificEnthalpy(state_a));
    //port_a.m_flow + port_b.m_flow = 0;
    port_b.p = port_a.p;
    port_b.h_outflow = MedPB.specificEnthalpy(state_b);
    port_a.h_outflow = inStream(port_b.h_outflow);
    ex_d = Q_heater * (1 - T_amb / T_high) + port_a.m_flow * (state_a.h - T_amb * MedPB.specificEntropy(state_a)) + port_b.m_flow * (state_b.h - T_amb * MedPB.specificEntropy(state_b));
    annotation(
      Documentation(info = "<html>
  		<p> This heater is useful to perform quicker on-design analysis of the cycles. </p>
  		</html>"));
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {0, -2}, extent = {{-48, 62}, {48, -62}}), Text(origin = {2, -2}, extent = {{-36, 12}, {36, -12}}, textString = "HEATER")}),
  Diagram(graphics = {Rectangle(origin = {2, 6}, extent = {{-44, 64}, {44, -64}}), Text(origin = {-30, 1}, extent = {{0, -1}, {64, 25}}, textString = "HEATER", fontSize = 15)}),
  __OpenModelica_commandLineOptions = "");
  end Heater;

  model Cooler "0D model of a dry-cooler"
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    outer Modelica.Fluid.System system;
    parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 313.15 "Outlet temperature in Kelvin";
    parameter Real deltaT_cooler = 15 "Approach difference of temperature at the outlet";
    parameter Modelica.SIunits.Power P_nom = 10 ^ 6;
    parameter Integer N_cool = 15 "Number of discretization of the cooler";
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-2, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Types.Conductance UA_dis[N_cool-1] "Conductance of the cooler per sub-HX";
    Modelica.SIunits.HeatFlowRate Q_dis (start=10^7/N_cool)"Heat flow rate dispatched per sub-HX in the cooler";
    Modelica.SIunits.ThermodynamicTemperature[N_cool] T_CO2;
    Modelica.SIunits.HeatFlowRate Q_cooler (start=10^7) "Heat flow rate in the cooler";
    SolarTherm.Types.Conductance UA_cooler "Overall conductance of the cooler";
    SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
    Real[N_cool-1] deltaT_lm "logarithmic temperature difference";
    Real[N_cool] deltaT "difference with the ambiant air at the inlet and outlet";
    Modelica.SIunits.Power P_cooling "Power used by the fans to cool the fluid";
    Real deltaT_ave "average difference of temperature with the ambiant";
  protected
  MedPB.ThermodynamicState[N_cool] state "Thermodynamic State at the i-th position";
  Modelica.SIunits.SpecificEnthalpy[N_cool] h_CO2;
  equation
    for i in 1:N_cool loop
      state[i]=MedPB.setState_pTX(port_a.p,T_CO2[i]);
      h_CO2[i]=state[i].h;
      deltaT[i]=T_CO2[i]-T_amb;
    end for;
    T_CO2[N_cool]=T_amb+deltaT_cooler;
    h_CO2[1]=inStream(port_a.h_outflow);
    for i in 1:(N_cool-1) loop
      Q_dis=port_a.m_flow*(h_CO2[i+1]-h_CO2[i]);
      Q_dis=-UA_dis[i]*deltaT_lm[i];
      deltaT_lm[i] = if deltaT[i+1] * deltaT[i] < 0 then (abs(deltaT[i]) ^ (1 / 3) * sign(deltaT[i]) / 2 + abs(deltaT[i+1]) ^ (1 / 3) * sign(deltaT[i+1]) / 2) ^ 3 else (deltaT[i] - deltaT[i+1]) / (Modelica.Math.log(deltaT[i] / deltaT[i+1]) + 0.0001);
    end for;
    UA_cooler=sum(UA_dis);
    Q_cooler = port_a.m_flow*(h_CO2[N_cool]-h_CO2[1]);
    
    port_a.m_flow + port_b.m_flow = 0;
    port_a.p = port_b.p;
    port_b.h_outflow = h_CO2[N_cool];
    port_a.h_outflow = inStream(port_b.h_outflow);
    ex_d = P_cooling + port_a.m_flow * (MedPB.specificEnthalpy(state[1])- T_amb * MedPB.specificEntropy(state[1])) + port_b.m_flow * (MedPB.specificEnthalpy(state[N_cool]) - T_amb * MedPB.specificEntropy(state[N_cool]));
    P_cooling * deltaT[N_cool] / (-Q_cooler) = 1.49*10^6*(35.7-30)/(136.6*10^6);
    deltaT_ave = (deltaT[1] + deltaT[N_cool]) / 2;
    
    annotation(
      Icon(graphics = {Rectangle(origin = {2, 1}, extent = {{-58, 65}, {58, -65}}), Text(origin = {0, -1}, extent = {{-40, -15}, {40, 15}}, textString = "COOLER")}),
  Diagram(graphics = {Rectangle(origin = {-4, 7}, extent = {{-64, 67}, {64, -67}}), Text(origin = {5, 14}, extent = {{-41, -12}, {41, 12}}, textString = "COOLER")}));
    annotation(
      Documentation(info = "<html>
  		<p> The overall conductance UA of the cooler is calculated with a logarithmic temperature difference. It is implemented in order to ensure convergence. </p>
  		<p>The Cp is varying from 4kJ/kg.K to 1.2 kJ/kg.K in this temperature/pressure range. It is therefore not very accurate but can be used for economical estimations. </p>
  		<p> The outlet temperature is fixed by the user. The electrical power necessary for the fans is estimated by  P_elec/(Q_cooler*deltaT_average)=constante, for any sCO2/air HX. P_elec is the power to run the fans, Q_cooler is the energy exchanged with outside and deltaT_average is the average of T_CO2-T_amb, the average is taken between the outlet and the inlet. </p>
  		<p> Reference values (but not model) come from: </p> <p>Sienicki, James J., Moisseytsev, Anton, and Lv, Qiuping. Dry Air Cooling and the sCO2 Brayton Cycle. Proceedings of the ASME Turbo Expo 2017: Turbomachinery Technical Conference and Exposition. Volume 9: Oil and Gas Applications; Supercritical CO2 Power Cycles; Wind Energy. Charlotte, North Carolina, USA. June 26–30, 2017. V009T38A015. ASME. https://doi.org/10.1115/GT2017-64042  </p>
          
  
  		</html>"));
  end Cooler;

  model FlowSplitter "Split the flow for the cycles with redirection"
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    parameter Real gamma;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b gamma_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {0, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b one_gamma_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    gamma_port_b.m_flow = -gamma * port_a.m_flow;
    one_gamma_port_b.m_flow = -(1 - gamma) * port_a.m_flow;
    gamma_port_b.p = port_a.p;
    one_gamma_port_b.p = port_a.p;
    gamma_port_b.h_outflow = inStream(port_a.h_outflow);
    one_gamma_port_b.h_outflow = inStream(port_a.h_outflow);
    port_a.h_outflow = inStream(one_gamma_port_b.h_outflow);
    annotation(
      Icon(graphics = {Text(origin = {0, 10}, extent = {{-56, -16}, {56, 16}}, textString = "SPLITTER")}),
      Diagram(graphics = {Text(origin = {7, 8}, extent = {{-49, -16}, {49, 16}}, textString = "SPLITTER")}));
  end FlowSplitter;

  model FlowMixer "Mixes the flows at the inlet. Thermodynamic values are calculated through a ponderation with the mass flows."
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    Modelica.Fluid.Interfaces.FluidPort_a first_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {0, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a second_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    port_b.m_flow = -(first_port_a.m_flow + second_port_a.m_flow);
    port_b.h_outflow = (first_port_a.m_flow * inStream(first_port_a.h_outflow) + second_port_a.m_flow * inStream(second_port_a.h_outflow)) / (first_port_a.m_flow + second_port_a.m_flow);
    port_b.p = (first_port_a.m_flow * first_port_a.p + second_port_a.m_flow * second_port_a.p) / (first_port_a.m_flow + second_port_a.m_flow);
    first_port_a.h_outflow = inStream(port_b.h_outflow);
    second_port_a.h_outflow = inStream(port_b.h_outflow);
    annotation(
      Diagram(graphics = {Text(origin = {3, 13}, extent = {{-39, -17}, {39, 17}}, textString = "MIXER")}),
      Icon(graphics = {Text(origin = {6, 14}, extent = {{-44, -28}, {44, 28}}, textString = "MIXER")}));
  end FlowMixer;

  model Exchanger "0D model of a heat exchanger between the HTF and the CO2"
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
    outer Modelica.Fluid.System system;
    parameter Real pinch = 10;
    parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 40 + 273.15;
    Modelica.Fluid.Interfaces.FluidPort_a HTF_port_a(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {60, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a CO2_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b HTF_port_b(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b CO2_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {58, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    MedPB.ThermodynamicState[2] state_CO2;
    MedRec.ThermodynamicState[2] state_HTF;
    Modelica.SIunits.SpecificEnthalpy[2] h_CO2 (start={1000000,1200000});
    Modelica.SIunits.SpecificEnthalpy[2] h_HTF;
    SolarTherm.Types.Conductance UA_TLMD "Conductance of the overall HX";
    Real[2] deltaT "Temperature difference in the heat exchangers";
    Real deltaT_lm;
    Modelica.SIunits.HeatFlowRate Q_HX_HTR;
    Modelica.SIunits.ThermodynamicTemperature T_CO2_out;
    Modelica.SIunits.ThermodynamicTemperature T_HTF_out;
    SolarTherm.Types.SpecificExergy ex_d;
  protected
  equation
    for i in 1:2 loop
      deltaT[i] = MedRec.temperature(state_HTF[i]) - MedPB.temperature(state_CO2[i]);
      state_CO2[i] = MedPB.setState_phX(CO2_port_a.p, h_CO2[i]);
      state_HTF[i] = MedRec.setState_phX(HTF_port_a.p, h_HTF[i]);
    end for;
    h_CO2[2] = CO2_port_b.h_outflow;
    h_HTF[2] = inStream(HTF_port_a.h_outflow);
    h_CO2[1] = inStream(CO2_port_a.h_outflow);
    h_HTF[1] = HTF_port_b.h_outflow;
    T_CO2_out = MedPB.temperature(state_CO2[2]);
    T_CO2_out=690+273.15;
    T_HTF_out = MedRec.temperature(state_HTF[1]);
    //min(deltaT) = pinch;
    deltaT_lm = if deltaT[2] * deltaT[1] < 0 then (abs(deltaT[1]) ^ (1 / 3) * sign(deltaT[1]) / 2 + abs(deltaT[2]) ^ (1 / 3) * sign(deltaT[2]) / 2) ^ 3 else (deltaT[1] - deltaT[2]) / (Modelica.Math.log(deltaT[1] / deltaT[2]) + 0.0001);
    Q_HX_HTR = CO2_port_a.m_flow * (h_CO2[2] - h_CO2[1]);
    Q_HX_HTR = UA_TLMD * deltaT_lm;
    Q_HX_HTR = HTF_port_a.m_flow * (h_HTF[2] - h_HTF[1]);
    CO2_port_a.p = CO2_port_b.p;
    HTF_port_a.p = HTF_port_b.p;
    CO2_port_a.h_outflow = inStream(CO2_port_b.h_outflow);
    HTF_port_a.h_outflow = inStream(HTF_port_b.h_outflow);
//Closure equation on the mass flow
    CO2_port_a.m_flow = HTF_port_a.m_flow*MedRec.specificHeatCapacityCp(state_HTF[2])/1270;
//CO2_port_a.m_flow+CO2_port_b.m_flow=0;
    HTF_port_a.m_flow + HTF_port_b.m_flow = 0;
    ex_d = HTF_port_a.m_flow * (MedRec.specificEnthalpy(state_HTF[2]) - T_amb * MedRec.specificEntropy(state_HTF[2])) + HTF_port_b.m_flow * (MedRec.specificEnthalpy(state_HTF[1]) - T_amb * MedRec.specificEntropy(state_HTF[1])) + CO2_port_b.m_flow * (MedPB.specificEnthalpy(state_CO2[2]) - T_amb * MedPB.specificEntropy(state_CO2[2])) + CO2_port_a.m_flow * (MedPB.specificEnthalpy(state_CO2[1]) - T_amb * MedPB.specificEntropy(state_CO2[1]));
    annotation(
      Documentation(info = "<html>
  		<p>The exchanger is not divided in sub-HX, as the Cp of the CO2 is almost constant in this area (high pressure, high T).&nbsp;</p>
  <p>Closure equations are based on the equality of the energy exchanged and by imposing a pinch.</p>
  <p>Parameter to integrate in the off-design PB is the UA_TLMD.</p>
  		</html>"));
    annotation(
      Diagram(graphics = {Rectangle(origin = {1, 4}, extent = {{-57, 40}, {57, -40}}), Text(origin = {-1, 8}, extent = {{-47, 16}, {47, -16}}, textString = "Exchanger")}),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
  Icon(graphics = {Rectangle(origin = {-8, -7}, extent = {{-62, 39}, {62, -39}}), Text(origin = {-6, -13}, extent = {{-48, 21}, {48, -21}}, textString = "Exchanger")}));
  end Exchanger;

  model HeatRecuperatorTLMD "The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation. The system of equation is closed by imposing a pinch. "
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    outer Modelica.Fluid.System system;
    parameter Integer N_q = 15 "Number of discretisation of the heat exchanger";
    parameter Real flowGuess = 100 "guess value for the mass flow; given as Pnom/10^5 in the cycles";
    parameter Real pinchRecuperator = 5 "pinch of the recuperator. Imposed as a closing equation";
    parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 40 + 273.15;
    Modelica.Fluid.Interfaces.FluidPort_a from_comp_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a from_turb_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_comp_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_turb_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.SIunits.SpecificEnthalpy[N_q] h_from_turb(start = {500000 for i in 1:N_q});
    Modelica.SIunits.ThermodynamicTemperature[N_q] T_from_turb(start = {500 for i in 1:N_q});
    Modelica.SIunits.SpecificEnthalpy[N_q] h_from_comp(start = {500000 for i in 1:N_q});
    Modelica.SIunits.ThermodynamicTemperature[N_q] T_from_comp(start = {500 for i in 1:N_q});
    Real[N_q] deltaT "Temperature difference in the heat exchangers";
    Real deltaT_lmBis "Overall logarithmic temperature difference";
    SolarTherm.Types.Conductance UA_HTR "Overall conductance from the overall LMTD";
    SolarTherm.Types.Conductance[N_q - 1] UA_dis "Conductance per sub-heat exchanger";
    Modelica.SIunits.HeatFlowRate Q_T_HTR "Overall exchanged energy";
    Modelica.SIunits.HeatFlowRate Q_HX_HTR_dis(start = flowGuess * 10 ^ 4) "Constant energy exchanged in each sub-heat exchanger";
    // gives a start value to the mass flow, taken as P_nom/10⁵; allows easier convergence
    SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
    Real[N_q - 1] deltaT_lm;
  protected
    MedPB.ThermodynamicState[N_q] state_from_turb;
    MedPB.ThermodynamicState[N_q] state_from_comp;
    Real m_flowStart(start = flowGuess);
  equation
    for i in 1:N_q loop
      deltaT[i] = T_from_turb[i] - T_from_comp[i];
      state_from_turb[i] = MedPB.setState_phX(from_turb_port_b.p, h_from_turb[i]);
      state_from_comp[i] = MedPB.setState_phX(from_comp_port_a.p, h_from_comp[i]);
      T_from_turb[i] = MedPB.temperature(state_from_turb[i]);
      T_from_comp[i] = MedPB.temperature(state_from_comp[i]);
    end for;
    h_from_turb[N_q] = inStream(from_turb_port_a.h_outflow);
    h_from_comp[1] = inStream(from_comp_port_a.h_outflow);
    from_turb_port_b.h_outflow = h_from_turb[1];
    from_comp_port_b.h_outflow = h_from_comp[N_q];
    min(deltaT) = pinchRecuperator;
    deltaT_lmBis * Modelica.Math.log((T_from_turb[1] - T_from_comp[1]) / (T_from_turb[N_q] - T_from_comp[N_q])) = T_from_turb[1] - T_from_comp[1] - (T_from_turb[N_q] - T_from_comp[N_q]);
    UA_HTR * deltaT_lmBis = Q_T_HTR;
    Q_HX_HTR_dis = Q_T_HTR / (N_q - 1);
    for i in 2:N_q loop
      deltaT_lm[i - 1] = if deltaT[i] * deltaT[i - 1] <= 0 then (abs(deltaT[i - 1]) ^ (1 / 3) * sign(deltaT[i - 1]) / 2 + abs(deltaT[i]) ^ (1 / 3) * sign(deltaT[i]) / 2) ^ 3 else (deltaT[i - 1] - deltaT[i]) / (Modelica.Math.log(deltaT[i - 1] / deltaT[i]) + 0.0001);
      Q_HX_HTR_dis = from_comp_port_a.m_flow * (h_from_comp[i] - h_from_comp[i - 1]);
      Q_HX_HTR_dis = UA_dis[i - 1] * deltaT_lm[i - 1];
      Q_HX_HTR_dis = from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]);
    end for;
    from_turb_port_a.h_outflow = inStream(from_turb_port_b.h_outflow);
    from_comp_port_a.h_outflow = inStream(from_comp_port_b.h_outflow);
    from_turb_port_b.m_flow + from_turb_port_a.m_flow = 0;
    from_comp_port_b.m_flow + from_comp_port_a.m_flow = 0;
    m_flowStart = from_turb_port_a.m_flow;
    from_turb_port_b.p = from_turb_port_a.p;
    from_comp_port_b.p = from_comp_port_a.p;
    ex_d = from_turb_port_a.m_flow * (state_from_turb[N_q].h - T_amb * MedPB.specificEntropy(state_from_turb[N_q])) + from_turb_port_b.m_flow * (state_from_turb[1].h - T_amb * MedPB.specificEntropy(state_from_turb[1])) + from_comp_port_b.m_flow * (state_from_comp[N_q].h - T_amb * MedPB.specificEntropy(state_from_comp[N_q])) + from_comp_port_a.m_flow * (state_from_comp[1].h - T_amb * MedPB.specificEntropy(state_from_comp[1]));
    annotation(
      Diagram(graphics = {Rectangle(origin = {1, 7}, extent = {{-61, 31}, {61, -31}}), Text(origin = {5, 1}, extent = {{-53, -17}, {53, 17}}, textString = "RECUPERATOR")}),
  Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-65, 33}, {65, -33}}), Text(origin = {-2, -5}, extent = {{-46, -15}, {46, 15}}, textString = "RECUPERATOR")}));
    annotation(
      Documentation(info = "<html>
  		<p>&nbsp;</p>
  		<p> The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation.</p>
  <p>This subdivision is based on the heat exchanged between both sides: it is even for all subdivision (Q_HX_HTR_dis).&nbsp;</p>
  <p>The closure equations are first the equality of the heat exchanged in every sub-HX and by imposing a pinch (of 5&deg;C in general).</p>
  <p> The conductance in each sub-HX is calculated with Q=UA*TLMD, TLMD being the logarithmic temperature difference. </p>
  <p>The parameters to integrate in the off-design PB are the UA_dis, which can be done with the CSV button.&nbsp;</p>
  <p>&nbsp;</p>
  		</html>"));
  end HeatRecuperatorTLMD;

  model CompressorOnShaft "Model 0D of a sCO2 compressor"
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {42, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter Real eta_comp = 0.87 "isentropic efficiency of the compressor";
    parameter Real PR = 2.313 "Pressure ratio";
    parameter Modelica.SIunits.AbsolutePressure p_out = 250 * 10 ^ 5 "outlet pressure";
    parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 273.15 + 40 "Outlet temperature in Kelvin";
    parameter Real flowGuess = 1000;
    MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
    MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
    MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
    Modelica.SIunits.Power W_comp "power used for compression";
    SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
    Modelica.SIunits.SpecificEntropy s_entrance "entropy at the entrance of the compressor";
    Real d_entrance;
    parameter Real phi_opt = 0.0297035;
    parameter Real psi_opt = 0.461819;
    Real diam_rotor (start=0.2);
    Real tipSpeed (start=400);
    Real psi_actual;
    parameter Real N_compressor = 6545;
  protected
    Real mFlow(start = flowGuess);
  equation
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    s_entrance = MedPB.specificEntropy(state_a);
    state_isen = MedPB.setState_psX(p_out, s_entrance);
    state_b = MedPB.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) / eta_comp);
    port_b.p = state_b.p;
    port_b.h_outflow = state_b.h;
    mFlow = port_a.m_flow;
    W_comp = port_a.m_flow * (state_b.h - state_a.h);
    port_a.m_flow + port_b.m_flow = 0;
    ex_d = W_comp + port_a.m_flow * (state_a.h - T_amb * MedPB.specificEntropy(state_a)) + port_b.m_flow * (state_b.h - T_amb * MedPB.specificEntropy(state_b));
    d_entrance = MedPB.density(state_a);
    port_a.h_outflow = 0;
// Compressor on-design parameters to be calculated
    tipSpeed = diam_rotor * N_compressor / 2;
    phi_opt = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2);
    psi_actual = (state_isen.h - state_a.h) / tipSpeed ^ 2;
    annotation(
      Documentation(info = "<html>
  		<p>This compressor is supposed to run on the same shaft as the turbine.</p>
  <p>The compressor model comes from the thesis of J. Dyreby.</p>
  <p>Phi corresponds to the adimensionned mass flow rate and psi to the adimensioned head. Because of the difference in the shaft speed regarding Dyreby's thesis, it is necessary to compensate in the off-design model by the on-design head.</p>
  <p>Parameters to integrate in the off-design PB model are:</p>
  <p>
  <ul>
  <li>The rotor diameter</li>
  <li>The actual head (psi_actual)</li>
  <li>The isentropic efficiency at design point (chosen) </li>
  </ul>
  </p>
  <p>J. J. Dyreby, &laquo;&nbsp;Modeling the supercritical
  carbon dioxide Brayton cycle with recompression&nbsp;&raquo;, The University of
  Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  		</html>"));
    annotation(
      Diagram(graphics = {Text(origin = {-20, 18}, extent = {{-28, 16}, {42, -46}}, textString = "COMPRESSOR"), Polygon(origin = {-12, 10}, points = {{-42, 40}, {-42, -44}, {42, -70}, {42, 70}, {-42, 40}, {-42, 40}})}, coordinateSystem(initialScale = 0.1)),
  Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-26, -2}, points = {{-40, 42}, {-42, -48}, {42, -78}, {42, 78}, {-40, 42}}), Text(origin = {-16, 11}, extent = {{-48, -31}, {24, 15}}, textString = "COMPRESSOR")}));
  end CompressorOnShaft;

  model testOn
    extends SolarTherm.Media.CO2.PropCO2;
    
    parameter Integer N_q = 15 "Number of discretization of the heat recuperators";
    parameter Real m_des=100;
  SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow srcTLMDt (p_out=250*10^5,T_out=600,m_flow=m_des) annotation(
      Placement(visible = true, transformation(origin = {46, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  SourceFlow srcTLMDc (p_out=80*10^5,T_out=100,m_flow=0.7*m_des) annotation(
      Placement(visible = true, transformation(origin = {-44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sinkTLMDt annotation(
      Placement(visible = true, transformation(origin = {-44, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sinkTLMDc annotation(
      Placement(visible = true, transformation(origin = {42, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  SourceFlow srcDTAvec (p_out=85*10^5,T_out=100,m_flow=0.7*m_des) annotation(
      Placement(visible = true, transformation(origin = {-42, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow srcDTAvet (p_out=250*10^5,T_out=600,m_flow=m_des) annotation(
      Placement(visible = true, transformation(origin = {46, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  SinkFlow sinkDTAvet annotation(
      Placement(visible = true, transformation(origin = {-42, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sinkDTAvec annotation(
      Placement(visible = true, transformation(origin = {46, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign.HeatRecuperatorDTAve TLMD (N_q=60) annotation(
      Placement(visible = true, transformation(origin = {0, -16}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  OnDesign.HeatRecuperatorDTAve DTAve (N_q=15) annotation(
      Placement(visible = true, transformation(origin = {-4, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  equation
    connect(DTAve.from_comp_port_b, sinkDTAvec.port_a) annotation(
      Line(points = {{6, 56}, {6, 56}, {6, 66}, {38, 66}, {38, 66}}, color = {0, 127, 255}));
    connect(srcDTAvec.port_b, DTAve.from_comp_port_a) annotation(
      Line(points = {{-34, 64}, {-16, 64}, {-16, 54}, {-16, 54}}, color = {0, 127, 255}));
    connect(DTAve.from_turb_port_b, sinkDTAvet.port_a) annotation(
      Line(points = {{-16, 38}, {-14, 38}, {-14, 30}, {-34, 30}, {-34, 30}}, color = {0, 127, 255}));
    connect(DTAve.from_turb_port_a, srcDTAvet.port_b) annotation(
      Line(points = {{6, 38}, {6, 38}, {6, 30}, {38, 30}, {38, 30}}, color = {0, 127, 255}));
    connect(TLMD.from_comp_port_a, srcTLMDc.port_b) annotation(
      Line(points = {{-14, -8}, {-16, -8}, {-16, 0}, {-36, 0}, {-36, 0}}, color = {0, 127, 255}));
    connect(TLMD.from_turb_port_b, sinkTLMDt.port_a) annotation(
      Line(points = {{-12, -26}, {-14, -26}, {-14, -30}, {-36, -30}, {-36, -30}}, color = {0, 127, 255}));
    connect(TLMD.from_turb_port_a, srcTLMDt.port_b) annotation(
      Line(points = {{12, -26}, {38, -26}, {38, -30}, {38, -30}}, color = {0, 127, 255}));
    connect(TLMD.from_comp_port_b, sinkTLMDc.port_a) annotation(
      Line(points = {{12, -8}, {12, -8}, {12, 0}, {34, 0}, {34, 0}}, color = {0, 127, 255}));
  end testOn;

  model testHX
    extends SolarTherm.Media.CO2.PropCO2;
    parameter Integer N_q = 15 "Number of discretization of the heat recuperators";
    parameter Real m_des = 100;
    parameter Real m_flow=90;
    SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow srcTLMDt(p_out = 230 * 10 ^ 5, T_out = 550, m_flow=m_flow) annotation(
      Placement(visible = true, transformation(origin = {46, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    SourceFlow srcTLMDc(p_out = 85 * 10 ^ 5, T_out = 120, m_flow = 0.7 * m_flow) annotation(
      Placement(visible = true, transformation(origin = {-44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sinkTLMDt annotation(
      Placement(visible = true, transformation(origin = {-44, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sinkTLMDc annotation(
      Placement(visible = true, transformation(origin = {42, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    SourceFlow srcDTAvec(p_out = 85 * 10 ^ 5, T_out = 120, m_flow = 0.7 * m_flow) annotation(
      Placement(visible = true, transformation(origin = {-42, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow srcDTAvet(p_out = 230 * 10 ^ 5, T_out = 550, m_flow = m_flow) annotation(
      Placement(visible = true, transformation(origin = {46, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    SinkFlow sinkDTAvet annotation(
      Placement(visible = true, transformation(origin = {-42, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sinkDTAvec annotation(
      Placement(visible = true, transformation(origin = {46, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve TLMD(N_q = 15,P_nom_des=10^7) annotation(
      Placement(visible = true, transformation(origin = {0, -16}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
    DirectDesign.HeatRecuperatorDTAve DTAve(N_q = 60,P_nom_des=10^7) annotation(
      Placement(visible = true, transformation(origin = {-4, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  
  initial equation
    DTAve.h_in_comp_des=500000;
    DTAve.h_in_turb_des=10^6;
    DTAve.p_in_comp_des=250*10^5;
    DTAve.p_in_turb_des=80*10^5;
    DTAve.m_comp_des=0.7*m_des;
    DTAve.m_turb_des=m_des;
    TLMD.h_in_comp_des=500000;
    TLMD.h_in_turb_des=10^6;
    TLMD.p_in_comp_des=250*10^5;
    TLMD.p_in_turb_des=85*10^5;
    TLMD.m_comp_des=0.7*m_des;
    TLMD.m_turb_des=m_des;
  equation
    connect(DTAve.from_comp_port_b, sinkDTAvec.port_a) annotation(
      Line(points = {{6, 56}, {6, 56}, {6, 66}, {38, 66}, {38, 66}}, color = {0, 127, 255}));
    connect(srcDTAvec.port_b, DTAve.from_comp_port_a) annotation(
      Line(points = {{-34, 64}, {-16, 64}, {-16, 54}, {-16, 54}}, color = {0, 127, 255}));
    connect(DTAve.from_turb_port_b, sinkDTAvet.port_a) annotation(
      Line(points = {{-16, 38}, {-14, 38}, {-14, 30}, {-34, 30}, {-34, 30}}, color = {0, 127, 255}));
    connect(DTAve.from_turb_port_a, srcDTAvet.port_b) annotation(
      Line(points = {{6, 38}, {6, 38}, {6, 30}, {38, 30}, {38, 30}}, color = {0, 127, 255}));
    connect(TLMD.from_comp_port_a, srcTLMDc.port_b) annotation(
      Line(points = {{-14, -8}, {-16, -8}, {-16, 0}, {-36, 0}, {-36, 0}}, color = {0, 127, 255}));
    connect(TLMD.from_turb_port_b, sinkTLMDt.port_a) annotation(
      Line(points = {{-12, -26}, {-14, -26}, {-14, -30}, {-36, -30}, {-36, -30}}, color = {0, 127, 255}));
    connect(TLMD.from_turb_port_a, srcTLMDt.port_b) annotation(
      Line(points = {{12, -26}, {38, -26}, {38, -30}, {38, -30}}, color = {0, 127, 255}));
    connect(TLMD.from_comp_port_b, sinkTLMDc.port_a) annotation(
      Line(points = {{12, -8}, {12, -8}, {12, 0}, {34, 0}, {34, 0}}, color = {0, 127, 255}));
  end testHX;
end OnDesign;