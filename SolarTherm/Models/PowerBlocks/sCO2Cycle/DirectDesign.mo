within SolarTherm.Models.PowerBlocks.sCO2Cycle;

package DirectDesign
  model simpleRecupPB
    import FI = SolarTherm.Models.Analysis.Finances;
    import SI = Modelica.SIunits;
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
    input SolarTherm.Interfaces.Connectors.WeatherBus wbus;
    //Cycle parameters
    parameter SI.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
    parameter SI.ThermodynamicTemperature T_high = 800 + 273.15 "inlet temperature of the turbine";
    parameter SI.ThermodynamicTemperature T_amb = 40 + 273.15 "ambiant temperature";
    parameter Real PR = 3.125 "Pressure ratio";
    parameter SI.Power P_gro = 100 * 10 ^ 6 "first guess of power outlet";
    parameter SI.Power P_nom(fixed = false) "Electrical power at design point";
    parameter SI.MassFlowRate m_HTF_des = 766 "Mass flow rate at design point";
    // Compressor parameters
    parameter SI.Efficiency eta_comp = 0.89 "Maximal isentropic efficiency of the compressors";
    parameter SI.AngularVelocity[4] choiceN = {75000, 30000, 10000, 3600} * 0.10471975512;
    parameter SI.AngularVelocity N_shaft = choiceN[integer(Modelica.Math.log(P_gro / 10 ^ 6) / Modelica.Math.log(10)) + 2];
    //Turbine parameters
    parameter SI.Efficiency eta_turb = 0.93 "Maximal isentropic efficiency of the turbine";
    //Heat recuperator parameters
    parameter Integer N_q = 15;
    //Cooler parameters
    parameter SI.ThermodynamicTemperature T_low = 45 + 273.15 "Outlet temperature of the cooler";
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
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve HTR(N_q = N_q, P_nom_des = P_nom, pinchRecuperator = 5) annotation(
      Placement(visible = true, transformation(origin = {-38, -16}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.CompressorOnShaft compressor(N_design = N_shaft, eta_design = eta_comp, P_nom_des = P_nom, PR = PR) annotation(
      Placement(visible = true, transformation(origin = {-74, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Cooler cooler(T_low = T_low, P_nom_des = P_nom, T_amb_des = T_amb) annotation(
      Placement(visible = true, transformation(origin = {-78, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Turbine turbine(PR = PR, T_amb = T_amb, N_shaft = N_shaft, eta_design = eta_turb) annotation(
      Placement(visible = true, transformation(origin = {16, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Exchanger exchanger(P_nom_des = P_nom) annotation(
      Placement(visible = true, transformation(origin = {-4, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow src(T_out = T_high, p_out = 10 ^ 5, redeclare package MedPB = MedRec, use_m_parameter = true, m_flow = turbine.m_des) annotation(
      Placement(visible = true, transformation(origin = {34, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink annotation(
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
    connect(cooler.m_sup, m_sup);
    tempTest = wbus.Tdry;
    m_sup = if exchanger.HTF_port_a.m_flow >= 0.8 * exchanger.m_HTF_des then true else false;
    connect(m_sup, exchanger.m_sup);
    if m_sup then
      turbine.p_out = compressor.p_out / PR;
    else
      exchanger.CO2_port_a.m_flow = exchanger.m_CO2_des;
    end if;
//P_elec=P_nom;
    eta_cycle = P_elec / exchanger.Q_HX;
    P_elec = if m_sup then (-turbine.W_turb) - compressor.W_comp else 0;
    annotation(
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
      __OpenModelica_simulationFlags(lv = "LOG_NLS_V,LOG_STATS", outputFormat = "mat", s = "dassl"));
  end simpleRecupPB;

  model Turbine "OD model of a turbine"
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    import SI = Modelica.SIunits;
  
    parameter SI.Efficiency eta_design = 0.9 "isentropic efficiency of the turbine";
    parameter SI.Efficiency PR = 3 "Pressure ratio";
    parameter SI.ThermodynamicTemperature T_amb = 273.15 + 40 "Outlet temperature in Kelvin";
    parameter Modelica.SIunits.Area A_nozzle(fixed = false);
    parameter SI.AngularVelocity N_shaft = 3358;
    parameter SI.Diameter diam_turb(fixed = false);
    parameter SI.Velocity tipSpeed_des(fixed = false);
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    SI.Efficiency eta_turb "efficiency of the turbine";
    SI.Density d_outlet;
    SI.Velocity C_spouting(start = C_spouting_des);
    MedPB.ThermodynamicState state_a(h.start = h_in_des) "thermodynamic state at the entrance";
    MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic decompression";
    MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real decompresssion";
    SI.Power W_turb "Outlet power";
    SI.AbsolutePressure p_out(start = p_out_des);
    SI.SpecificEntropy s_entrance " entropy at the entrance of the turbine";
    parameter MedPB.ThermodynamicState state_in_des(p.fixed = false, h.fixed = false, h.start = 1.2 * 10 ^ 6), state_isen_des(p.fixed = false, h.fixed = false), state_out_des(p.fixed = false, h.fixed = false, h.start = 900000);
    parameter SI.SpecificEnthalpy h_in_des(fixed = false), h_out_des(fixed = false);
    parameter SI.AbsolutePressure p_in_des(fixed = false), p_out_des(fixed = false, start = 80 * 10 ^ 5);
    parameter SI.Velocity C_spouting_des(fixed = false, start = 500);
    parameter SI.MassFlowRate m_des(fixed = false);
    parameter SI.Power W_turb_des(fixed = false);
    
  initial equation
    state_in_des = MedPB.setState_phX(p_in_des, h_in_des);
    state_isen_des = MedPB.setState_psX(p_in_des / PR, MedPB.specificEntropy(state_in_des));
    h_out_des = state_in_des.h + (state_isen_des.h - state_in_des.h) * eta_design;
    p_out_des = p_in_des / PR;
    state_out_des.p = p_out_des;
    state_out_des.h = h_out_des;
    C_spouting_des ^ 2 = 2 * (state_in_des.h - state_isen_des.h);
    m_des = C_spouting_des * A_nozzle * MedPB.density(state_out_des);
    W_turb_des = m_des * (h_out_des - state_in_des.h);
    tipSpeed_des = N_shaft * diam_turb / 2;
    tipSpeed_des / C_spouting_des = 0.707;
  equation
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    s_entrance = MedPB.specificEntropy(state_a);
    state_isen = MedPB.setState_psX(p_out, s_entrance);
    state_b = MedPB.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) * eta_turb);
    port_b.p = state_b.p;
    port_a.h_outflow = inStream(port_b.h_outflow);
    port_b.h_outflow = state_b.h;
    W_turb = port_a.m_flow * (state_b.h - state_a.h);
    port_a.m_flow + port_b.m_flow = 0;
    d_outlet = MedPB.density(state_b);
    port_a.m_flow = C_spouting * A_nozzle * d_outlet;
    C_spouting ^ 2 = 2 * (state_a.h - state_isen.h);
    eta_turb = eta_design * 2 * (tipSpeed_des / C_spouting) * sqrt(1 - (tipSpeed_des / C_spouting) ^ 2);
    annotation(
      Documentation(info = "<html>
  		<p>This turbine's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
  <p>The isentropic efficiency is calculated as a function of the tip speed ration between the tip speed of the rotor and the spouting velocity. It is said to be functionnal for any size.</p>
  <p>The outlet pressure goes beyond the critical pressure for a mass flow too small. The cycle calculation should therefore not be performed below this pressure.</p>
  <p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  		</html>"),
      Diagram(graphics = {Text(origin = {-48, -48}, extent = {{18, 80}, {78, 16}}, textString = "TURBINE"), Polygon(origin = {0, -10}, points = {{-40, 40}, {-40, -20}, {40, -50}, {40, 70}, {-40, 40}, {-40, 40}}), Line(origin = {-50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {50.111, -40.1649}, points = {{-10, 0}, {10, 0}, {10, 0}})}, coordinateSystem(initialScale = 0.1)),
      Icon(graphics = {Text(origin = {-20, 12}, extent = {{-10, 12}, {52, -34}}, textString = "TURBINE"), Ellipse(extent = {{56, 58}, {56, 58}}, endAngle = 360), Polygon(origin = {11, 7}, points = {{-51, 23}, {-51, -37}, {29, -67}, {29, 53}, {-51, 23}}), Line(origin = {-50, 20}, points = {{10, 0}, {-10, 0}, {-10, 0}}), Line(origin = {50, -39.8501}, points = {{-10, 0}, {10, 0}, {10, 0}})}, coordinateSystem(initialScale = 0.1)));
  end Turbine;

  model Exchanger
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
    import SI = Modelica.SIunits;
    parameter SI.ThermodynamicTemperature T_out_CO2_des = 700 + 273.15;
    parameter SI.Power P_nom_des = 164000;
    input Boolean m_sup "when m_sup=false, m_HTF=m_HTF_design and P_elec=0 -> allows switching off the PB";
    parameter Real ratio_m_des = 1 "ratio of m_CO2_des/m_HTF_des at design point";
    parameter Integer N_exch = 8;
    Modelica.Fluid.Interfaces.FluidPort_a HTF_port_a(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a CO2_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b HTF_port_b(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b CO2_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    MedPB.ThermodynamicState[N_exch] state_CO2, state_HTF;
    SI.SpecificEnthalpy[N_exch] h_CO2(start = {990000 + i / N_exch * 200000 for i in 1:N_exch}), h_HTF(start = {600000 + i / N_exch * 200000 for i in 1:N_exch});
    Real[N_exch] deltaT "Temperature difference in the heat exchangers";
    SI.HeatFlowRate Q_HX;
    SI.ThermodynamicTemperature T_CO2_out, T_HTF_out;
    //Real deltaT_lm;
    Real deltaTAve;
    SI.MassFlowRate m_HTF_bis(start = P_nom_des / 10 ^ 5);
    parameter SI.HeatFlowRate Q_HX_des(fixed = false);
    parameter SI.MassFlowRate m_CO2_des(fixed = false), m_HTF_des(fixed = false);
    parameter SolarTherm.Types.Conductance UA_HX(fixed = false) "on-design conductance of the overall exchanger";
    parameter SolarTherm.Types.Conductance[N_exch - 1] UA_HX_dis(each fixed = false) "on-design conductance of the exchanger";
    parameter SI.SpecificEnthalpy h_in_HTF_des(fixed = false, start = 855000), h_out_HTF_des(fixed = false), h_in_CO2_des(fixed = false, start = 900000), h_out_CO2_des(fixed = false, start = 1.2 * 10 ^ 6);
    parameter Real[N_exch] deltaT_des(each fixed = false, each start = 75);
    parameter SI.AbsolutePressure p_in_CO2_des(fixed = false), p_out_CO2_des(fixed = false);
    parameter SI.AbsolutePressure p_in_HTF_des(fixed = false), p_out_HTF_des(fixed = false);
    parameter SI.ThermodynamicTemperature[N_exch] T_CO2_des(each fixed = false, start = {600 + 273.15 + 120 * (i / N_exch) for i in 1:N_exch}), T_HTF_des(each fixed = false, start = {650 + 273.15 + 120 * (i / N_exch) for i in 1:N_exch});
    parameter MedPB.ThermodynamicState[N_exch] state_CO2_des(each p.fixed = false, each h.fixed = false, each p.start = 250 * 10 ^ 5, each h.start = 10 ^ 6), state_HTF_des(each p.fixed = false, each h.fixed = false, each p.start = 10 ^ 5, each h.start = 855004);
  initial equation
    for i in 1:N_exch loop
      deltaT_des[i] = MedRec.temperature(state_HTF_des[i]) - MedPB.temperature(state_CO2_des[i]);
      state_CO2_des[i] = MedPB.setState_pTX(p_in_CO2_des, T_CO2_des[i]);
      state_HTF_des[i] = MedRec.setState_pTX(p_in_HTF_des, T_HTF_des[i]);
    end for;
    T_CO2_des[N_exch] = T_out_CO2_des;
    for i in 1:N_exch - 1 loop
      Q_HX_des = ratio_m_des * (state_CO2_des[i + 1].h - state_CO2_des[i].h);
      Q_HX_des = state_HTF_des[i + 1].h - state_HTF_des[i].h;
      m_HTF_des * Q_HX_des = UA_HX_dis[i] * (deltaT_des[i] + deltaT_des[i + 1]) / 2;
    end for;
    UA_HX = sum(UA_HX_dis);
    p_in_CO2_des = p_out_CO2_des;
    p_in_HTF_des = p_out_HTF_des;
    h_in_HTF_des = MedRec.specificEnthalpy(state_HTF_des[N_exch]);
    h_out_HTF_des = MedRec.specificEnthalpy(state_HTF_des[1]);
    h_in_CO2_des = state_CO2_des[1].h;
    h_out_CO2_des = state_CO2_des[N_exch].h;
    m_CO2_des = ratio_m_des * m_HTF_des;
    
  equation
    for i in 1:N_exch loop
      deltaT[i] = if m_sup then MedRec.temperature(state_HTF[i]) - MedPB.temperature(state_CO2[i]) else deltaT_des[i];
      state_CO2[i] = MedPB.setState_phX(CO2_port_a.p, h_CO2[i]);
      state_HTF[i] = MedRec.setState_phX(HTF_port_a.p, h_HTF[i]);
    end for;
    T_CO2_out = MedPB.temperature(state_CO2[N_exch]);
    T_HTF_out = MedRec.temperature(state_HTF[1]);
//deltaT_lm = if deltaT[2] * deltaT[1] < 0 then (abs(deltaT[1]) ^ (1 / 3) * sign(deltaT[1]) / 2 + abs(deltaT[2]) ^ (1 / 3) * sign(deltaT[2]) / 2) ^ 3 else (deltaT[1] - deltaT[2]) / (Modelica.Math.log(deltaT[1] / deltaT[2]) + 0.0001);
    deltaTAve = (deltaT[1] + deltaT[N_exch]) / 2;
    h_CO2[N_exch] = CO2_port_b.h_outflow;
    h_HTF[N_exch] = if m_sup then inStream(HTF_port_a.h_outflow) else h_in_HTF_des;
    h_CO2[1] = inStream(CO2_port_a.h_outflow);
    HTF_port_b.h_outflow = if m_sup then h_HTF[1] else inStream(HTF_port_a.h_outflow);
    m_HTF_bis = if m_sup then HTF_port_a.m_flow else m_HTF_des;
    Q_HX = CO2_port_a.m_flow * (h_CO2[N_exch] - h_CO2[1]);
    for i in 1:N_exch - 1 loop
      m_HTF_bis * (h_HTF[i + 1] - h_HTF[i]) = CO2_port_a.m_flow * (h_CO2[i + 1] - h_CO2[i]);
      CO2_port_a.m_flow * (h_CO2[i + 1] - h_CO2[i]) = UA_HX_dis[i] * (1 / 2 * abs(m_HTF_bis / m_HTF_des + CO2_port_a.m_flow / m_CO2_des)) ^ 0.8 * (deltaT[i] + deltaT[i + 1]) / 2;
    end for;
    HTF_port_a.h_outflow = inStream(HTF_port_b.h_outflow);
    CO2_port_a.h_outflow = inStream(CO2_port_b.h_outflow);
//It is necessary to have one equation in a cycle that doesn't imply a circular equality on the mass flow rates
//CO2_port_b.m_flow + CO2_port_a.m_flow = 0;
    HTF_port_a.m_flow + HTF_port_b.m_flow = 0;
//CO2_port_a.m_flow = if m_sup then HTF_port_a.m_flow else m_CO2_des * 0.8;
// Pressure equality
    CO2_port_b.p = CO2_port_a.p;
    HTF_port_a.p = HTF_port_b.p;
    annotation(
      Diagram(graphics = {Rectangle(origin = {1, 4}, extent = {{-61, 56}, {59, -64}}), Text(origin = {-1, 8}, extent = {{-47, 16}, {47, -16}}, textString = "Exchanger"), Line(origin = {0, 40}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -40}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {-1, 40}, points = {{5, 6}, {5, -6}, {-5, 0}, {5, 6}, {5, 6}}), Polygon(origin = {-1, 40}, points = {{5, 6}, {5, -6}, {-5, 0}, {5, 6}, {5, 6}}), Polygon(origin = {-9, -40}, points = {{5, 6}, {5, -6}, {15, 0}, {5, 6}, {5, 6}})}, coordinateSystem(initialScale = 0.1)),
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
      Documentation(info = "<html>
  		<p>The exchanger is a heat exchanger between the HTF and the CO2. It is a counterflow HX, based on a TLMD. The conductance UA has to be specified from the on-design.</p>
  <p>The conductance in off-design varies as UA_Off=UA_on*(m_flow/m_design)^0.8.&nbsp;<span >The average between the two mass flows is taken.</span></p>
  <p>A.T. Louis et T. Neises, analysis and optimization for Off-design performance of the recompression s-CO2 cycles for high temperature CSP applications, in The 5th International Symposium-Supercritical CO2 Power Cycles, 2016</p>
  <p>&nbsp;</p>
  		</html>"),
      Icon(graphics = {Rectangle(extent = {{-60, 60}, {60, -60}}), Line(origin = {0, 40}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -40}, points = {{-70, 0}, {70, 0}}), Polygon(origin = {0, -39}, points = {{-4, 5}, {-4, -7}, {4, -1}, {4, -1}, {-4, 5}}), Polygon(origin = {0, -39}, points = {{-4, 5}, {-4, -7}, {4, -1}, {4, -1}, {-4, 5}}), Polygon(origin = {-2, 40}, points = {{4, 6}, {4, -6}, {-4, 0}, {4, 6}, {4, 6}}), Text(origin = {-3, 10}, extent = {{-31, 10}, {41, -34}}, textString = "HX"), Text(origin = {0, 52}, extent = {{-34, 4}, {34, -4}}, textString = "HTF"), Text(origin = {0, -52}, extent = {{-28, 4}, {28, -4}}, textString = "sCO2")}));
  end Exchanger;

  model Cooler
    extends SolarTherm.Media.CO2.PropCO2;
    import SI = Modelica.SIunits;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    input Boolean m_sup;
    input SI.ThermodynamicTemperature T_amb "Ambiant temperature in Kelvin";
    parameter SI.ThermodynamicTemperature T_amb_des = 40 + 273.15 "Ambiant temperature in Kelvin at design point";
    parameter SolarTherm.Types.Conductance UA_cooler(fixed = false) "Conductance of the cooler in W/K";
    parameter SI.ThermodynamicTemperature T_low = 55 + 273.15;
    parameter SI.Power P_nom_des = 164000;
    parameter Integer N_cool = 15;
    parameter Real deltaT_design = 15 "Difference between ambient and outlet CO2 temperature";
    MedPB.ThermodynamicState state_a "Thermodynamic State at the entrance";
    MedPB.ThermodynamicState state_b "Thermodynamic State at the outlet";
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB, m_flow.start = P_nom_des / 10 ^ 5) annotation(
      Placement(visible = true, transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-2.22045e-16, -70}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-2.22045e-16, 70}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Real[2] deltaT;
    SI.HeatFlowRate Q_cooler;
    SI.Power P_cooling;
    parameter SolarTherm.Types.Conductance UA_dis[N_cool - 1](each fixed = false) "Conductance of the cooler per sub-HX";
    parameter SI.Power P_cool_des(fixed = false, start = 0.01 * P_nom_des) "power necessary to cool down at design point";
    parameter SI.SpecificEnthalpy h_in_des(fixed = false), h_out_des(fixed = false);
    parameter SI.AbsolutePressure p_in_des(fixed = false);
    parameter SI.AbsolutePressure p_out_des(fixed = false);
    parameter SI.MassFlowRate m_des(fixed = false);
    parameter SI.HeatFlowRate Q_cooler_des(fixed = false, start = 10 ^ 6);
    parameter MedPB.ThermodynamicState[N_cool] state_des(each p.fixed = false, each h.fixed = false) "Thermodynamic State at the i-th position";
    parameter SI.SpecificEnthalpy[N_cool] h_CO2_des(each fixed = false, start = {600000 - i / N_cool * 150000 for i in 1:N_cool});
    //parameter Real[N_cool-1] deltaT_lm_des (each fixed=false)"logarithmic temperature difference";
    parameter Real[N_cool] deltaT_des(each fixed = false, each start = 25) "difference with the ambiant air at the inlet and outlet";
    parameter SI.HeatFlowRate Q_dis_des(fixed = false, start = 10 ^ 5) "Heat flow rate dispatched per sub-HX in the cooler";
    parameter SI.ThermodynamicTemperature[N_cool] T_CO2_des(each fixed = false, each start = 273.15 + 75);
  initial equation
    p_out_des = p_in_des;
    
    for i in 1:N_cool loop
      state_des[i] = MedPB.setState_pTX(p_in_des, T_CO2_des[i]);
      h_CO2_des[i] = MedPB.specificEnthalpy(state_des[i]);
      deltaT_des[i] = T_CO2_des[i] - T_amb_des;
    end for;
    
    T_CO2_des[N_cool] = T_low;
    h_CO2_des[1] = h_in_des;
    h_CO2_des[N_cool] = h_out_des;  
    
    for i in 1:N_cool - 1 loop
      Q_dis_des = h_CO2_des[i + 1] - h_CO2_des[i];
      m_des * Q_dis_des = -UA_dis[i] * (deltaT_des[i] + deltaT_des[i + 1]) / 2;
//deltaT_lm_des[i] = if deltaT_des[i+1] * deltaT_des[i] < 0 then (abs(deltaT_des[i]) ^ (1 / 3) * sign(deltaT_des[i]) / 2 + abs(deltaT_des[i+1]) ^ (1 / 3) * sign(deltaT_des[i+1]) / 2) ^ 3 else (deltaT_des[i] - deltaT_des[i+1]) / (Modelica.Math.log(deltaT_des[i] / deltaT_des[i+1]) + 0.0001);
    end for;
    UA_cooler = abs(Q_cooler) / (T_CO2_des[1] - T_amb_des) / (T_CO2_des[N_cool] - T_amb_des) / Modelica.Math.log((T_CO2_des[1] - T_amb_des) / (T_CO2_des[N_cool] - T_amb_des));
    Q_cooler_des = (N_cool - 1) * Q_dis_des * m_des;
//P_cool_des * deltaT_des[N_cool]/(-Q_cooler_des)= 1.49*10^6*(35.7-30)/(136.6*10^6);
    P_cool_des = 0.01 * P_nom_des;
  equation
    deltaT = {MedPB.temperature(state_a) - T_amb, MedPB.temperature(state_b) - T_amb};
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    state_b = MedPB.setState_pTX(port_a.p, max(T_amb + 3, T_low));
//P_cooling = P_cool_des* (deltaT_design / deltaT[2]) ^ (3 / 0.805)*(Q_cooler/Q_cooler_des);
    P_cooling = 0;
    Q_cooler = port_a.m_flow * (state_b.h - state_a.h);
    port_a.m_flow + port_b.m_flow = 0;
    port_a.p = port_b.p;
    port_b.h_outflow = state_b.h;
    port_a.h_outflow = inStream(port_b.h_outflow);
    annotation(
      Documentation(info = "<html>
  		<p>The cooler is thought to be a dry-air cooling device. The outlet temperature of the CO2 is imposed as max(T_low_cycle,T_amb+3). The variation of the ambiant temperature is taken into account in the estimation of the electricity demand for the fans, such as: P_cooling*deltaT/Q_cooler is a constant, deltaT being the average of the temperature of the CO2 and the ambiant, and Q_cooler the energy to withdraw.</p>
  		</html>"),
      Icon(graphics = {Rectangle(origin = {2, 1}, extent = {{-62, 59}, {58, -61}}), Text(origin = {8, 5}, extent = {{-40, -15}, {26, 5}}, textString = "COOLER"), Line(origin = {0, 65}, points = {{0, 5}, {0, -5}, {0, -5}}), Line(origin = {0, -65}, points = {{0, 5}, {0, -5}, {0, -5}})}, coordinateSystem(initialScale = 0.1)),
      Diagram(graphics = {Rectangle(origin = {-4, 7}, extent = {{-56, 53}, {64, -67}}), Text(origin = {-5, -2}, extent = {{-29, -8}, {41, 12}}, textString = "COOLER"), Line(origin = {0, 65}, points = {{0, 5}, {0, -5}, {0, -5}}), Line(origin = {0, -65}, points = {{0, 5}, {0, -5}, {0, -5}})}, coordinateSystem(initialScale = 0.1)));
  end Cooler;

  model HeatRecuperatorDTAve "The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation."
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    import SI = Modelica.SIunits;
    parameter Integer N_q = 15 "Number of subdivision of the HX";
    parameter Real ratio_m_des = 1 "ratio of m_comp_des/m_turb_des; we suppose m_turb_des=1, and then scale-up";
    parameter Real pinchRecuperator = 5 "pinch of the recuperator. Imposed as a closing equation for on-design";
    Modelica.Fluid.Interfaces.FluidPort_a from_comp_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a from_turb_port_a(redeclare package Medium = MedPB, m_flow.start = P_nom_des / 10 ^ 5) annotation(
      Placement(visible = true, transformation(origin = {70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, -30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_comp_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_turb_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
    SI.SpecificEnthalpy[N_q] h_from_turb(start = {500000 + (i - 1) / N_q * 200000 for i in 1:N_q});
    MedPB.Temperature[N_q] T_from_turb(start = {350 + (i - 1) / N_q * 150 for i in 1:N_q});
    SI.SpecificEnthalpy[N_q] h_from_comp(start = {480000 + (i - 1) / N_q * 200000 for i in 1:N_q});
    MedPB.Temperature[N_q] T_from_comp(start = {320 + (i - 1) / N_q * 150 for i in 1:N_q});
    Real[N_q] deltaT(start = {150 for i in 1:N_q});
    SI.HeatFlowRate Q_HX;
    parameter SolarTherm.Types.Conductance UA_HTR(fixed = false) "Conductance of the overall HX";
    parameter SI.Power P_nom_des = 10 ^ 5;
    parameter SolarTherm.Types.Conductance UA_dis[N_q - 1](each fixed = false, each start = 0.04 * P_nom_des) "on-design conductance of the heat recuperator";
    parameter MedPB.ThermodynamicState[N_q] state_turb_des(each p.fixed = false, each h.fixed = false, h.start = {530000 + i / N_q * 500000 for i in 1:N_q}), state_comp_des(each p.fixed = false, each h.fixed = false, h.start = {500000 + i / N_q * 500000 for i in 1:N_q});
    parameter MedPB.Temperature[N_q] T_turb_des(each fixed = false, start = {140 + 273.15 + i / N_q * 300 for i in 1:N_q});
    parameter MedPB.Temperature[N_q] T_comp_des(each fixed = false, start = {120 + 273.15 + i / N_q * 300 for i in 1:N_q});
    parameter SI.TemperatureDifference[N_q] deltaT_des(each fixed = false, each start = 25);
    parameter SI.MassFlowRate m_comp_des(fixed = false, start = P_nom_des / 10 ^ 5), m_turb_des(fixed = false, start = P_nom_des / 10 ^ 5) "on-design mass flow from the compressor, turbine";
    parameter SI.HeatFlowRate Q_HX_des(fixed = false);
    parameter SI.HeatFlowRate Q_dis_des(fixed = false, start = 18600);
    parameter SI.SpecificEnthalpy h_in_turb_des(fixed = false), h_out_turb_des(fixed = false, start = 550000);
    parameter SI.SpecificEnthalpy h_in_comp_des(fixed = false), h_out_comp_des(fixed = false, start = 800000);
    parameter SI.AbsolutePressure p_in_turb_des(fixed = false, start = 80 * 10 ^ 5), p_out_turb_des(fixed = false, start = 80 * 10 ^ 5);
    parameter SI.AbsolutePressure p_in_comp_des(fixed = false, start = 220 * 10 ^ 5), p_out_comp_des(fixed = false, start = 220 * 10 ^ 5);
  protected
    MedPB.ThermodynamicState[N_q] state_from_turb, state_from_comp;
  initial equation
    for i in 1:N_q loop
      deltaT_des[i] = T_turb_des[i] - T_comp_des[i];
      state_turb_des[i] = MedPB.setState_pTX(p_in_turb_des, T_turb_des[i]);
      state_comp_des[i] = MedPB.setState_pTX(p_in_comp_des, T_comp_des[i]);
    end for;
    min(deltaT_des) = pinchRecuperator;
    state_turb_des[N_q].h = h_in_turb_des;
    state_turb_des[1].h = h_out_turb_des;
    state_comp_des[1].h = h_in_comp_des;
    state_comp_des[N_q].h = h_out_comp_des;
    p_out_comp_des = p_in_comp_des;
    p_out_turb_des = p_in_turb_des;
    Q_HX_des = m_turb_des * Q_dis_des * (N_q - 1);
    UA_HTR = sum(UA_dis);
    for i in 1:N_q - 1 loop
      Q_dis_des = ratio_m_des * (state_comp_des[i + 1].h - state_comp_des[i].h);
      m_turb_des * Q_dis_des = UA_dis[i] * (deltaT_des[i + 1] + deltaT_des[i]) / 2;
      Q_dis_des = state_turb_des[i + 1].h - state_turb_des[i].h;
    end for;
  equation
    for i in 1:N_q loop
      deltaT[i] = T_from_turb[i] - T_from_comp[i];
      state_from_turb[i] = MedPB.setState_phX(from_turb_port_a.p, h_from_turb[i]);
      state_from_comp[i] = MedPB.setState_phX(from_comp_port_a.p, h_from_comp[i]);
      T_from_turb[i] = MedPB.temperature(state_from_turb[i]);
      T_from_comp[i] = MedPB.temperature(state_from_comp[i]);
    end for;
    h_from_turb[N_q] = inStream(from_turb_port_a.h_outflow);
    h_from_comp[1] = inStream(from_comp_port_a.h_outflow);
    from_turb_port_b.h_outflow = h_from_turb[1];
    from_comp_port_b.h_outflow = h_from_comp[N_q];
    Q_HX = from_turb_port_a.m_flow * (h_from_turb[N_q] - h_from_turb[1]);
    for i in 2:N_q loop
      from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = from_comp_port_a.m_flow * (h_from_comp[i] - h_from_comp[i - 1]);
      from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = UA_dis[i - 1] * abs(from_comp_port_a.m_flow / m_comp_des + from_turb_port_a.m_flow / m_turb_des) ^ 0.8 / 2 ^ 0.8 * (T_from_turb[i - 1] - T_from_comp[i - 1] + T_from_turb[i] - T_from_comp[i]) / 2;
    end for;
    from_turb_port_b.m_flow + from_turb_port_a.m_flow = 0;
    from_comp_port_b.m_flow + from_comp_port_a.m_flow = 0;
    from_turb_port_b.p = from_turb_port_a.p;
    from_comp_port_b.p = from_comp_port_a.p;
    from_turb_port_a.h_outflow = inStream(from_turb_port_b.h_outflow);
    from_comp_port_a.h_outflow = inStream(from_comp_port_b.h_outflow);
    annotation(
      Diagram(graphics = {Rectangle(origin = {-1, 9}, extent = {{-59, 31}, {61, -49}}), Text(origin = {1, 1}, extent = {{-53, -17}, {51, 17}}, textString = "RECUPERATOR"), Line(origin = {0, -30}, points = {{70, 0}, {-70, 0}, {-70, 0}}), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {0, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
      Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-57, 49}, {63, -31}}), Text(origin = {0, 1}, extent = {{-48, -15}, {48, 15}}, textString = "RECUPERATOR"), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {-2, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
      Documentation(info = "<html>
  		<p>This heat recuperator is a counter-flow HX. Closure equations are based on the equality of m_flow*delta_H for both sides and m_flow*delta_H= UA_i*DTAve_i, DTAve being the average of the temperature difference between the inlet and the outlet of the sub-HX.</p>
  <p>The UA_i must be given as parameters from the on-design analysis.&nbsp;</p>
  		
  		</html>"));
  end HeatRecuperatorDTAve;

  model CompressorOnShaft "0D model of a compressor on the same shaft as the turbine"
    extends SolarTherm.Media.CO2.PropCO2;
    import SI = Modelica.SIunits;
    import CV = Modelica.SIunits.Conversions;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    parameter Real eta_design = 0.89 "Maximal isentropic efficiency of the compressor";
    parameter SI.Diameter diam_rotor(fixed = false) "on-design diameter of the rotor";
    parameter SI.AngularVelocity N_design = 40000 * 0.104 "Design rotationnal speed in rad/s";
    parameter Real psi_des(fixed = false) "on-design adimensionned head";
    parameter Real PR = 3 "pressure ratio chosen";
    parameter SI.Power P_nom_des "nominal power at design point";
    parameter SI.ThermodynamicTemperature T_in_des = CV.from_degC(45) "chosen inlet temperature of the compressor at design point";
    parameter SI.AbsolutePressure p_high_des = CV.from_bar(250);
    parameter Real phi_opt = 0.0297035 "optimal adimensionned mass flow";
    parameter SI.AngularVelocity tipSpeed(fixed = false, start = 500) "tip Speed of the rotor";
    SI.AbsolutePressure p_out(start = p_out_des) "outlet pressure";
    MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
    MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
    MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
    SI.Power W_comp "power used for compression";
    SI.SpecificEntropy s_entrance "entropy at the entrance of the compressor";
    Real phi "adimensionned mass flow rate";
    Real psi "adimensionned head";
    SI.Density d_entrance(start = 267) "density at the inlet";
    SI.Efficiency eta_comp(start = eta_design) "isentropic efficiency of the compressor";
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    parameter SI.SpecificEnthalpy h_out_des(fixed = false), h_in_des(fixed = false) "enthalpy at the outlet of the compressor";
    parameter MedPB.ThermodynamicState state_in_des(p.fixed = false, h.fixed = false, h.start = 550000);
    parameter MedPB.ThermodynamicState state_isen_des(p.fixed = false, h.fixed = false);
    parameter SI.AbsolutePressure p_in_des(fixed = false), p_out_des(fixed = false);
    parameter SI.Power W_comp_des(fixed = false);
    parameter SI.MassFlowRate m_des(fixed = false, start = 3) "design mass flow rate in kg/s";
  initial equation
    2 * m_des = phi_opt * MedPB.density(state_in_des) * N_design * diam_rotor ^ 3;
    psi_des = (state_isen_des.h - state_in_des.h) / tipSpeed ^ 2;
    W_comp_des = m_des * (h_out_des - state_in_des.h);
    state_in_des = MedPB.setState_phX(p_in_des, h_in_des);
    p_out_des = p_high_des;
    state_isen_des = MedPB.setState_psX(p_out_des, MedPB.specificEntropy(state_in_des));
    tipSpeed = diam_rotor * N_design / 2;
    h_out_des = state_in_des.h + (state_isen_des.h - state_in_des.h) / eta_design;
  equation
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    s_entrance = MedPB.specificEntropy(state_a);
    state_isen = MedPB.setState_psX(p_out, s_entrance);
    state_b = MedPB.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) / eta_comp);
    port_b.p = state_b.p;
    port_b.h_outflow = state_b.h;
    W_comp = port_a.m_flow * (state_b.h - state_a.h);
    port_a.h_outflow = 0;
    d_entrance = MedPB.density(state_a);
    port_a.m_flow + port_b.m_flow = 0;
    phi = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2);
    psi = (state_isen.h - state_a.h) / tipSpeed ^ 2;
    psi = (0.04049 + 54.7 * phi - 2505 * phi ^ 2 + 53224 * phi ^ 3 - 498626 * phi ^ 4) * psi_des / 0.46181921979961293;
    eta_comp = eta_design / 0.677837 * ((-0.7069) + 168.6 * phi - 8089 * phi ^ 2 + 182725 * phi ^ 3 - 1.638 * 10 ^ 6 * phi ^ 4);
    annotation(
      Diagram(graphics = {Text(origin = {-8, 16}, extent = {{-28, 16}, {42, -46}}, textString = "Compressor"), Polygon(origin = {-2, 10}, rotation = 180, points = {{-42, 40}, {-42, -20}, {38, -50}, {38, 70}, {-42, 40}, {-42, 40}}), Line(origin = {50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {-50, -40.1649}, points = {{10, 0}, {-10, 0}, {-10, 0}})}, coordinateSystem(initialScale = 0.1)),
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {0, 2}, rotation = 180, points = {{-40, 32}, {-40, -28}, {40, -58}, {40, 62}, {-40, 32}}), Text(origin = {22, 17}, extent = {{-48, -31}, {4, -3}}, textString = "COMPRES"), Line(origin = {50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {-50, -40.1649}, points = {{10, 0}, {-10, 0}, {-10, 0}})}),
      Documentation(info = "<html>
  		<p>This compressor's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
  <p>The performance maps comes from the Sandia National Laboratory first compressor. It should be updated. The performance maps is compressed in three correlations, expressing the adimensionned head and the efficiency as functions of the adimensionned mass flow.&nbsp;</p>
  <p>The same correlations are used; only the maximal values are changed.</p>
  <p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  		
  		</html>"));
  end CompressorOnShaft;

  model test
    extends SolarTherm.Media.CO2.PropCO2;
    import CV = Modelica.SIunits.Conversions;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
    //  parameter MedPB.ThermodynamicState state_CO2_in_des (p.fixed=false,h.fixed=false);
    //  parameter Real m_choice = 800;
    //  parameter Real N_shaft=3600*0.10471975512;
    //  CompressorToDiscuss compressor32 (p_high_des=250*10^5, N_design=N_shaft) annotation(
    //    Placement(visible = true, transformation(origin = {-22, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //SourceFlow src32 (p_out=90*10^5,T_out=40,use_m_parameter=true,m_flow=m_choice) annotation(
    //    Placement(visible = true, transformation(origin = {-66, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink32 annotation(
    //    Placement(visible = true, transformation(origin = {4, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    Real test;
  initial equation
// state_CO2_in_des=MedPB.setState_pTX(90*10^5,50+273.15);
// compressor32.h_in_des=state_CO2_in_des.h;
// compressor32.p_in_des=state_CO2_in_des.p;
// compressor32.m_des=m_choice;
  equation
//  connect(compressor32.port_b, sink32.port_a) annotation(
//    Line(points = {{-18, 12}, {-4, 12}, {-4, 4}, {-4, 4}}, color = {0, 127, 255}));
//  connect(src32.port_b, compressor32.port_a) annotation(
//    Line(points = {{-58, 26}, {-30, 26}, {-30, 24}, {-30, 24}}, color = {0, 127, 255}));
//  compressor32.N_compressor=N_shaft;
    test = MedPB.ToutTurb(715 + 273.15, 250 * 10 ^ 5, 80 * 10 ^ 5, 0.93);
  end test;

  model CompressorToDiscuss
    extends SolarTherm.Media.CO2.PropCO2;
    import SI = Modelica.SIunits;
    import CV = Modelica.SIunits.Conversions;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {42, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter Real eta_design = 0.87 "Maximal isentropic efficiency of the compressor";
    parameter Real PR = 2.313 "Pressure ratio";
    parameter SI.AbsolutePressure p_high_des = 250 * 10 ^ 5 "outlet pressure";
    parameter Real phi_opt = 0.0297035 "optimal adimensionned mass flow";
    MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
    MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
    MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
    SI.Power W_comp "power used for compression";
    SI.AbsolutePressure p_out(start = p_out_des);
    SI.SpecificEntropy s_entrance "exergy at the entrance of the compressor";
    Real phi;
    Real psi;
    SI.Velocity tipSpeed(start = tipSpeed_des);
    parameter SI.AngularVelocity N_design(fixed = false);
    parameter SI.Velocity tipSpeed_des(fixed = false);
    SI.AngularVelocity N_compressor(start = N_design);
    Real d_entrance(start = 344);
    Real eta_comp(start = eta_design);
    parameter SI.SpecificEnthalpy h_out_des(fixed = false), h_in_des(fixed = false) "enthalpy at the outlet of the compressor";
    parameter MedPB.ThermodynamicState state_in_des(p.fixed = false, h.fixed = false);
    parameter MedPB.ThermodynamicState state_isen_des(p.fixed = false, h.fixed = false);
    parameter SI.AbsolutePressure p_in_des(fixed = false), p_out_des(fixed = false);
    parameter SI.Power W_comp_des(fixed = false);
    parameter SI.MassFlowRate m_des(fixed = false, start = 3) "design mass flow rate in kg/s";
    parameter Real psi_des(fixed = false) "on-design adimensionned head";
    parameter SI.Diameter diam_rotor(fixed = false) "on-design diameter of the rotor";
    Real Nratio;
    Real deltaHi;
    parameter Real deltaHi_des(fixed = false);
  protected
  initial equation
    2 * m_des = phi_opt * MedPB.density(state_in_des) * N_design * diam_rotor ^ 3;
    psi_des = (state_isen_des.h - state_in_des.h) / tipSpeed_des ^ 2;
    W_comp_des = m_des * (h_out_des - state_in_des.h);
    state_in_des = MedPB.setState_phX(p_in_des, h_in_des);
    p_out_des = p_high_des;
    tipSpeed_des = diam_rotor * N_design / 2;
    state_isen_des = MedPB.setState_psX(p_out_des, MedPB.specificEntropy(state_in_des));
    h_out_des = state_in_des.h + (state_isen_des.h - state_in_des.h) / eta_design;
    deltaHi_des = state_isen_des.h - state_in_des.h;
  equation
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    s_entrance = MedPB.specificEntropy(state_a);
    state_isen = MedPB.setState_psX(p_out, s_entrance);
    state_b = MedPB.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) / eta_comp);
    port_b.p = state_b.p;
    port_b.h_outflow = state_b.h;
    port_a.h_outflow = 0;
    W_comp = port_a.m_flow * (state_b.h - state_a.h);
    port_a.m_flow + port_b.m_flow = 0;
    d_entrance = MedPB.density(state_a);
// Compressor on-design parameters to be calculated
    tipSpeed = diam_rotor * N_compressor / 2;
    phi = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2) * (N_compressor / N_design) ^ (1 / 5);
    psi = (state_isen.h - state_a.h) * (N_compressor / N_design) ^ ((20 * phi) ^ 3) / tipSpeed ^ 2;
    Nratio = N_compressor / N_design;
    deltaHi = psi * tipSpeed ^ 2 / (N_compressor / N_design) ^ ((20 * phi) ^ 3);
    psi = (0.04049 + 54.7 * phi - 2505 * phi ^ 2 + 53224 * phi ^ 3 - 498626 * phi ^ 4) * psi_des / 0.46181921979961293;
    eta_comp = eta_design / 0.677837 * abs((-0.7069) + 168.6 * phi - 8089 * phi ^ 2 + 182725 * phi ^ 3 - 1.638 * 10 ^ 6 * phi ^ 4) * (N_compressor / N_design) ^ ((20 * phi) ^ 5);
    annotation(
      Diagram(graphics = {Text(origin = {-20, 18}, extent = {{-28, 16}, {42, -46}}, textString = "COMPRESSOR"), Polygon(origin = {-12, 10}, points = {{-42, 40}, {-42, -44}, {42, -70}, {42, 70}, {-42, 40}, {-42, 40}})}, coordinateSystem(initialScale = 0.1)),
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-26, -2}, points = {{-40, 42}, {-42, -48}, {42, -78}, {42, 78}, {-40, 42}}), Text(origin = {-16, 11}, extent = {{-48, -31}, {24, 15}}, textString = "COMPRESSOR")}));
  end CompressorToDiscuss;

  model testBis
    extends SolarTherm.Media.CO2.PropCO2;
    import CV = Modelica.SIunits.Conversions;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
    parameter MedPB.ThermodynamicState state_CO2_in_des(p.fixed = false, h.fixed = false);
    parameter Real m_choice = 82.8;
    parameter Real N_shaft = 31000 * 0.10471975512;
    SourceFlow src32(p_out = 260 * 10 ^ 5, T_out = 700, use_m_parameter = false, m_flow = m_choice) annotation(
      Placement(visible = true, transformation(origin = {-66, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink32 annotation(
      Placement(visible = true, transformation(origin = {4, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    //CompressorToDiscuss compressor40 (p_high_des=250*10^5, N_design=N_shaft);
    //SourceFlow src40 (p_out=90*10^5,T_out=50,use_m_parameter=true,m_flow=m_choice);
    //SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink40;
    Turbine turbine(N_shaft = N_shaft) annotation(
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
    turbine.p_out = (75 + time * 10) * 10 ^ 5;
  end testBis;

  model recompPB
    extends SolarTherm.Media.CO2.PropCO2;
    import SI = Modelica.SIunits;
    import FI = SolarTherm.Models.Analysis.Finances;
    replaceable package MedPB = SolarTherm.Media.CarbonDioxide_ph;
    replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
    //input SolarTherm.Interfaces.Connectors.WeatherBus wbus;
    extends Icons.PowerBlock;
    Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {-74, 52}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(extent = {{-48, 30}, {-40, 38}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {-90, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(extent = {{-62, -48}, {-54, -40}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput W_net(quantity = "Power", unit = "W", displayUnit = "MW") "Net electric power output" annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(extent = {{46, -10}, {56, 0}}, rotation = 0)));
    // PB parameters
    parameter Boolean external_parasities = false "= true enable parasities as an input";
    parameter Real nu_min = 0.25 "Minimum turbine operation";
    Modelica.Blocks.Interfaces.RealInput parasities if external_parasities annotation(
      Placement(visible = true, transformation(origin = {82, 80}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {20, 60}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput T_amb annotation(
      Placement(visible = true, transformation(origin = {10, 80}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {-20, 60}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
    //Cycle parameters
    parameter Real f_fixed_load = 0.0055 "fixed load consumed by power cycle kw/kw";
    parameter SI.AbsolutePressure p_high = 250 * 10 ^ 5 "high pressure of the cycle";
    parameter SI.ThermodynamicTemperature T_high = 700 + 273.15 "inlet temperature of the turbine";
    parameter SI.ThermodynamicTemperature T_amb_des = 30 + 273.15 "ambiant temperature";
    //parameter Real PR = 25/9.17 "Pressure ratio";
    parameter Real PR = 2.5 "Pressure ratio";
    parameter SI.Power P_gro = 100 * 10 ^ 6 "first guess of power outlet";
    parameter SI.Power P_nom(fixed = false) "Electrical power at design point";
    parameter SI.MassFlowRate m_HTF_des = 1000 "Mass flow rate at design point";
    parameter Real gamma = 0.33 "Part of the mass flow going to the recompression directly";
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
    parameter SI.ThermodynamicTemperature T_low = 41 + 273.15 "Outlet temperature of the cooler";
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
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve HTR(N_q = N_HTR, P_nom_des = P_gro, ratio_m_des = 1, pinchRecuperator = 15) annotation(
      Placement(visible = true, transformation(origin = {26, -20}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.CompressorOnShaft mainCompressor(eta_design = eta_comp_main, N_design = N_shaft, P_nom_des = P_gro, p_high_des = p_high) annotation(
      Placement(visible = true, transformation(origin = {-81, -3}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Cooler cooler(T_low = T_low, P_nom_des = P_gro, T_amb_des = T_amb_des) annotation(
      Placement(visible = true, transformation(origin = {-83, -51}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Turbine turbine(PR = PR, T_amb = T_amb_des, N_shaft = N_shaft, eta_design = eta_turb) annotation(
      Placement(visible = true, transformation(origin = {72, -2}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Exchanger exchanger(redeclare package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph, P_nom_des = P_gro, T_out_CO2_des = T_high, N_exch = N_exch, ratio_m_des = 1) annotation(
      Placement(visible = true, transformation(origin = {48, 34}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.CompressorOnShaft reCompressor(N_design = N_shaft, P_nom_des = P_gro, p_high_des = p_high) annotation(
      Placement(visible = true, transformation(origin = {-47, 23}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve LTR(N_q = N_LTR, P_nom_des = P_gro, ratio_m_des = 1 - gamma, pinchRecuperator = 15) annotation(
      Placement(visible = true, transformation(origin = {-28, -44}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.FlowMixer mixer annotation(
      Placement(visible = true, transformation(origin = {-3, -15}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.FlowSplitter splitter(gamma = gamma) annotation(
      Placement(visible = true, transformation(origin = {-58, -44}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    parameter MedRec.ThermodynamicState state_HTF_in_des = MedRec.setState_pTX(1.0325 * 10 ^ 5, T_HTF_in_des);
    //   SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow src(T_out = 800+273.15, p_out = 10 ^ 5, m_flow = exchanger.m_HTF_des, redeclare package MedPB = SolarTherm.Media.SolidParticles.CarboHSP_ph, use_m_parameter = true) annotation(
    //      Placement(visible = true, transformation(origin = {-52, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    //    SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink annotation(
    //      Placement(visible = true, transformation(origin = {-50, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //Modelica.Blocks.Interfaces.RealInput parasities_internal;
    Modelica.Blocks.Interfaces.BooleanInput ramping annotation(
      Placement(visible = true, transformation(origin = {-68, 80}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {-2.22045e-16, 60}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
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
    C_HTR = 5.2 * HTR.UA_HTR ^ 0.8933;
    C_LTR = 5.2 * LTR.UA_HTR ^ 0.8933;
    C_turbine = 9923.7 * (-turbine.W_turb_des / 10 ^ 3) ^ 0.5886;
    C_mainCompressor = 643.15 * (mainCompressor.W_comp_des / 10 ^ 3) ^ 0.9142;
    C_reCompressor = 643.15 * (reCompressor.W_comp_des / 10 ^ 3) ^ 0.9142;
    C_cooler = 76.25 * cooler.UA_cooler ^ 0.8919;
    C_generator = 108900 * (P_nom / 10 ^ 6) ^ 0.5463;
    C_exchanger = pri_exchanger * exchanger.Q_HX_des * m_HTF_des / 1000;
    C_PB = (C_HTR + C_LTR + C_turbine + C_mainCompressor + C_reCompressor + C_generator + C_cooler + C_exchanger) * 1.05;
  // 1.05 corresponds to inflation from 2017, as correlations are in 2017' dollars.
  equation
    connect(fluid_b, exchanger.HTF_port_b) annotation(
      Line(points = {{-90, 40}, {38, 40}}, color = {0, 127, 255}));
  //  connect(src.port_b, fluid_a) annotation(
  //    Line(points = {{-60, 64}, {-72, 64}, {-72, 30}, {-42, 30}, {-42, 32}, {-44, 32}}, color = {0, 127, 255}));
  //  connect(sink.port_a, fluid_b) annotation(
  //    Line(points = {{-42, -78}, {-64, -78}, {-64, -54}, {-64, -54}, {-64, -50}}, color = {0, 127, 255}));
  //if external_parasities then
  //    connect(parasities_internal,parasities);
  //  else
  //    parasities_internal=0;
  //  end if;
    connect(LTR.from_turb_port_b, splitter.port_a) annotation(
      Line(points = {{-39, -49}, {-43, -49}, {-43, -44}, {-45, -44}}, color = {0, 127, 255}));
    connect(LTR.from_turb_port_a, HTR.from_turb_port_b) annotation(
      Line(points = {{-17, -49}, {15, -49}, {15, -25}}, color = {0, 127, 255}));
    connect(LTR.from_comp_port_b, mixer.first_port_a) annotation(
      Line(points = {{-17, -39}, {-17, -15}}, color = {0, 127, 255}));
    connect(mixer.port_b, HTR.from_comp_port_a) annotation(
      Line(points = {{11, -15}, {15, -15}}, color = {0, 127, 255}));
    connect(splitter.gamma_port_b, reCompressor.port_a) annotation(
      Line(points = {{-58, -34}, {-58, 15}}, color = {0, 127, 255}));
    connect(mainCompressor.port_b, LTR.from_comp_port_a) annotation(
      Line(points = {{-70, 1}, {-39, 1}, {-39, -39}}, color = {0, 127, 255}));
    connect(splitter.one_gamma_port_b, cooler.port_a) annotation(
      Line(points = {{-71, -44}, {-71, -60}, {-83, -60}}, color = {0, 127, 255}));
    connect(exchanger.CO2_port_a, HTR.from_comp_port_b) annotation(
      Line(points = {{38, 28}, {37, 28}, {37, -15}}, color = {0, 127, 255}));
    connect(cooler.port_b, mainCompressor.port_a) annotation(
      Line(points = {{-83, -42}, {-92, -42}, {-92, -11}}, color = {0, 127, 255}));
    connect(cooler.T_amb, T_amb) annotation(
      Line);
    connect(m_sup, exchanger.m_sup) annotation(
      Line);
    connect(m_sup, cooler.m_sup) annotation(
      Line);
    if exchanger.HTF_port_a.m_flow >= exchanger.m_HTF_des * nu_min then
      m_sup = true;
    elseif exchanger.HTF_port_a.m_flow < exchanger.m_HTF_des * nu_min - 0.01 * exchanger.m_HTF_des*nu_min then
      m_sup = false;
    else
      m_sup = false;
    end if;
    if m_sup then
      turbine.p_out = mainCompressor.p_out / PR;
    else
      exchanger.CO2_port_a.m_flow = exchanger.m_CO2_des;
    end if;
    eta_cycle = W_net / exchanger.Q_HX;
    der(E_net) = W_net;
    if ramping then
      W_net = 0;
    else 
      W_net = if m_sup then ((-turbine.W_turb) - mainCompressor.W_comp - reCompressor.W_comp - cooler.P_cooling) * (1 - f_fixed_load) * 0.90 else 0;
    end if;
  connect(exchanger.CO2_port_b, turbine.port_a) annotation(
      Line(points = {{58, 28}, {62, 28}, {62, 2}, {61, 2}}, color = {0, 127, 255}));
  connect(turbine.port_b, HTR.from_turb_port_a) annotation(
      Line(points = {{83, -9}, {90, -9}, {90, -48}, {37, -48}, {37, -25}}, color = {0, 127, 255}));
    connect(exchanger.HTF_port_a, fluid_a) annotation(
      Line(points = {{58, 40}, {62, 40}, {62, 52}, {-74, 52}}, color = {0, 127, 255}));
    connect(reCompressor.port_b, mixer.second_port_a) annotation(
      Line(points = {{-36, 27}, {-3, 27}, {-3, -5}}, color = {0, 127, 255}));
    annotation(
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
      __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
      Diagram);
  end recompPB;

  model FlowSplitter
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedRec = SolarTherm.Media.CO2.CO2_ph;
    parameter Real gamma;
    Real gamma_var;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b gamma_port_b(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 60}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b one_gamma_port_b(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  equation
    gamma_var = gamma;
    gamma_port_b.m_flow = -gamma_var * port_a.m_flow;
    one_gamma_port_b.m_flow = -(1 - gamma_var) * port_a.m_flow;
    gamma_port_b.p = port_a.p;
    one_gamma_port_b.p = port_a.p;
    gamma_port_b.h_outflow = inStream(port_a.h_outflow);
    one_gamma_port_b.h_outflow = inStream(port_a.h_outflow);
    port_a.h_outflow = inStream(gamma_port_b.h_outflow);
    annotation(
      Icon(graphics = {Text(origin = {16, -12}, extent = {{-56, -16}, {24, 0}}, textString = "SPLITTER"), Rectangle(origin = {-2, 27}, extent = {{-58, 13}, {62, -67}}), Line(points = {{-80, 0}, {80, 0}, {80, 0}}), Line(origin = {0, 30}, points = {{0, 30}, {0, -30}, {0, -30}}), Polygon(origin = {0, 30}, points = {{-4, -4}, {4, -4}, {0, 4}, {-4, -4}, {-4, -4}}), Polygon(origin = {-32, 0}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}}), Polygon(origin = {28, 0}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
      Diagram(graphics = {Text(origin = {15, -14}, extent = {{-49, -16}, {21, 2}}, textString = "SPLITTER"), Rectangle(origin = {0, 10}, extent = {{-60, 30}, {60, -50}}), Line(points = {{80, 0}, {-80, 0}, {-80, 0}}), Line(origin = {0, 30}, points = {{0, -30}, {0, 30}, {0, 30}}), Polygon(origin = {0, 28}, points = {{-4, -4}, {4, -4}, {0, 4}, {0, 4}, {-4, -4}}), Polygon(origin = {-22, 0}, points = {{-4, 4}, {-4, -4}, {-12, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {38, 0}, points = {{-4, 4}, {-4, -4}, {-12, 0}, {-4, 4}, {-4, 4}}), Text(origin = {13, 28}, extent = {{-7, 6}, {7, -6}}, textString = "gamma"), Text(origin = {-25, 10}, extent = {{-17, 6}, {7, -6}}, textString = "1 - gamma")}, coordinateSystem(initialScale = 0.1)));
  end FlowSplitter;

  model FlowMixer "This model is useful for the recompression cycle cycle, as it allows to mix two different fluid. The pressure in both should entrance should be the same; in case it is not, we ponderated it by the mass flows: as it is the same molar mass, the resulting pressure should look like that."
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedRec = SolarTherm.Media.CO2.CO2_ph;
    Modelica.Fluid.Interfaces.FluidPort_a first_port_a(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a second_port_a(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {4.44089e-16, 60}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, -8.88178e-16}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  equation
    port_b.m_flow = -(first_port_a.m_flow + second_port_a.m_flow);
    port_b.h_outflow = (first_port_a.m_flow * inStream(first_port_a.h_outflow) + second_port_a.m_flow * inStream(second_port_a.h_outflow)) / (first_port_a.m_flow + second_port_a.m_flow);
    port_b.p = (first_port_a.m_flow * first_port_a.p + second_port_a.m_flow * second_port_a.p) / (first_port_a.m_flow + second_port_a.m_flow);
    first_port_a.h_outflow = inStream(port_b.h_outflow);
    second_port_a.h_outflow = inStream(port_b.h_outflow);
    annotation(
      Diagram(graphics = {Text(origin = {11, -13}, extent = {{-39, -17}, {19, 3}}, textString = "MIXER"), Rectangle(origin = {1, 10}, extent = {{-61, 30}, {59, -50}}), Line(origin = {0, 30}, points = {{0, 30}, {0, -30}, {0, -30}}), Line(points = {{-80, 0}, {80, 0}, {80, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {4, 4}, {0, -4}, {-4, 4}, {-4, 4}}), Polygon(origin = {-30, 0}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {30, -1}, points = {{-4, 5}, {-4, -3}, {4, 1}, {4, 1}, {-4, 5}})}, coordinateSystem(initialScale = 0.1)),
      Icon(graphics = {Text(origin = {-4, -14}, extent = {{-22, -16}, {30, 4}}, textString = "MIXER"), Rectangle(extent = {{-60, 40}, {60, -40}}), Line(points = {{-80, 0}, {80, 0}, {80, 0}}), Line(origin = {0, 30}, points = {{0, 30}, {0, -30}, {0, -30}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {4, 4}, {0, -4}, {-4, 4}, {-4, 4}}), Polygon(origin = {-30, 0}, points = {{-4, 4}, {-4, -4}, {4, 0}, {4, 0}, {-4, 4}}), Polygon(origin = {30, 0}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}})}, coordinateSystem(initialScale = 0.1)));
  end FlowMixer;

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
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.CompressorToDiscuss compressor(N_design = N_shaft, eta_design = eta_comp, PR = PR) annotation(
      Placement(visible = true, transformation(origin = {-74, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Cooler cooler(T_low = T_low, P_nom_des = P_nom, T_amb_des = T_amb) annotation(
      Placement(visible = true, transformation(origin = {-78, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Turbine turbine(PR = PR, T_amb = T_amb, N_shaft = N_shaft, eta_design = eta_turb) annotation(
      Placement(visible = true, transformation(origin = {16, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Exchanger exchanger(P_nom_des = P_nom) annotation(
      Placement(visible = true, transformation(origin = {-4, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow src(T_out = T_high, p_out = 10 ^ 5, redeclare package MedPB = MedRec, use_m_parameter = true, m_flow = turbine.m_des) annotation(
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
    connect(cooler.m_sup, m_sup);
    tempTest = 40 + 273.15;
    m_sup = true;
    connect(m_sup, exchanger.m_sup);
    turbine.p_out = compressor.p_out / PR;
    compressor.N_compressor = 100 + N_shaft * time;
    turbine.N_turb = compressor.N_compressor;
//P_elec=P_nom;
    eta_cycle = P_elec / exchanger.Q_HX;
    P_elec = if m_sup then (-turbine.W_turb) - compressor.W_comp else 0;
    annotation(
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
      __OpenModelica_simulationFlags(lv = "LOG_NLS_V,LOG_STATS", outputFormat = "mat", s = "dassl"));
  end TestTransient;
end DirectDesign;