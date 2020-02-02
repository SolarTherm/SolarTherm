within SolarTherm.Models.PowerBlocks.sCO2Cycle;

package OffDesign
  model HeatRecuperatorTLMD "The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation. "
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    parameter Integer N_q = 15;
    parameter Modelica.SIunits.MassFlowRate m_des_comp = 1.5 "on-design mass flow from the compressor";
    parameter Modelica.SIunits.MassFlowRate m_des_turb = 1.5 "on-design mass-flow from the turbine";
    parameter SolarTherm.Types.Conductance[N_q - 1] UA_dis = {835.068, 541.013, 401.981, 321.684, 269.787, 233.732, 207.392, 187.424, 171.843, 159.408, 149.301, 140.953, 133.968, 128.056};
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
    Modelica.SIunits.ThermodynamicTemperature[N_q] T_from_comp(start = {350 for i in 1:N_q});
    Real[N_q] deltaT(start = {150 for i in 1:N_q});
    SolarTherm.Types.Conductance UA_HTR;
    Real[N_q - 1] deltaT_lm;
  protected
    MedPB.ThermodynamicState[N_q] state_from_turb;
    MedPB.ThermodynamicState[N_q] state_from_comp;
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
    for i in 2:N_q loop
      from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = from_comp_port_a.m_flow * (h_from_comp[i] - h_from_comp[i - 1]);
      from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = UA_dis[i - 1] * abs(from_comp_port_a.m_flow / m_des_comp + from_turb_port_a.m_flow / m_des_turb) ^ 0.8 / 2 ^ 0.8 * deltaT_lm[i - 1];
// This implementation allows easy convergence
      deltaT_lm[i - 1] = if deltaT[i] * deltaT[i - 1] < 0 then (abs(deltaT[i - 1]) ^ (1 / 3) * sign(deltaT[i - 1]) / 2 + abs(deltaT[i]) ^ (1 / 3) * sign(deltaT[i]) / 2) ^ 3 else (deltaT[i - 1] - deltaT[i]) / (Modelica.Math.log(abs(deltaT[i - 1] / deltaT[i])) + 0.0001);
    end for;
    UA_HTR = sum(UA_dis);
    from_turb_port_b.m_flow + from_turb_port_a.m_flow = 0;
    from_comp_port_b.m_flow + from_comp_port_a.m_flow = 0;
    from_turb_port_b.p = from_turb_port_a.p;
    from_comp_port_b.p = from_comp_port_a.p;
    from_turb_port_a.h_outflow = inStream(from_turb_port_b.h_outflow);
    from_comp_port_a.h_outflow = inStream(from_comp_port_b.h_outflow);
    annotation(
      Diagram(graphics = {Rectangle(origin = {1, 7}, extent = {{-61, 31}, {61, -31}}), Text(origin = {5, 1}, extent = {{-53, -17}, {53, 17}}, textString = "RECUPERATOR")}),
      Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-65, 33}, {65, -33}}), Text(origin = {-2, -5}, extent = {{-46, -15}, {46, 15}}, textString = "RECUPERATOR")}));
    annotation(
      Documentation(info = "<html>
  		<p>This heat recuperator is a counter-flow HX. Closure equations are based on the equality of m_flow*delta_H for both sides and m_flow*delta_H= UA_i*TLMD_i, TLMD being the logarithmic temperature difference.</p>
  <p>The UA_i must be given as parameters from the on-design analysis.&nbsp;</p>
  		
  		</html>"));
  end HeatRecuperatorTLMD;

  model CompressorToDiscuss
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {42, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter Real eta_design = 0.87 "Maximal isentropic efficiency of the compressor";
    parameter Real PR = 2.313 "Pressure ratio";
    parameter Modelica.SIunits.AbsolutePressure p_out = 250 * 10 ^ 5 "outlet pressure";
    parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 273.15 + 40 "Outlet temperature in Kelvin";
    parameter Real flowGuess = 1000;
    MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
    MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
    MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
    Modelica.SIunits.Power W_comp "power used for compression";
    //SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
    Modelica.SIunits.SpecificEntropy s_entrance "exergy at the entrance of the compressor";
    //  Real phi;
    //  Real psi;
    parameter Real diam_rotor = 0.18;
    parameter Real N_design = 3358;
    //  Real tipSpeed;
    //  Real N_compressor(start = 3358);
    //  Real d_entrance(start = 344);
    Real eta_comp(start = eta_design);
  protected
    Real mFlow(start = flowGuess);
  equation
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    s_entrance = MedPB.specificEntropy(state_a);
    state_isen = MedPB.setState_psX(p_out, s_entrance);
    state_b = MedPB.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) / eta_comp);
    port_b.p = state_b.p;
    port_b.h_outflow = state_b.h;
    port_a.h_outflow = 0;
    mFlow = port_a.m_flow;
    W_comp = port_a.m_flow * (state_b.h - state_a.h);
//port_a.m_flow + port_b.m_flow = 0;
//port_a.m_flow = 123.5*(1-time/2);
//ex_d =W_comp + port_a.m_flow*(state_a.h-T_amb*MedPB.specificEntropy(state_a))+port_b.m_flow*(state_b.h-T_amb*MedPB.specificEntropy(state_b));
//d_entrance = MedPB.density(state_a);
// Compressor on-design parameters to be calculated
//tipSpeed = diam_rotor * N_compressor / 2;
    eta_comp = eta_design;
//N_compressor=4000*(1-time/1.5);
//  phi = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2) * (N_compressor / N_design) ^ (1 / 5);
//  psi = (state_isen.h - state_a.h) / tipSpeed ^ 2 * (N_design / N_compressor) ^ ((20 * phi) ^ 3);
//  //phi = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2);
//  //psi = (state_isen.h - state_a.h) / tipSpeed ^ 2;
//  psi = 0.04049 + 54.7 * phi - 2505 * phi ^ 2 + 53224 * phi ^ 3 - 498626 * phi ^ 4;
//  eta_comp = eta_design / 0.677837 * (abs((-0.7069) + 168.6 * phi - 8089 * phi ^ 2 + 182725 * phi ^ 3 - 1.638 * 10 ^ 6 * phi ^ 4)) * (N_design / N_compressor) ^ ((20 * phi) ^ 5);
//  //eta_comp = eta_design / 0.677837 * ((-0.7069) + 168.6 * phi - 8089 * phi ^ 2 + 182725 * phi ^ 3 - 1.638 * 10 ^ 6 * phi ^ 4);
    annotation(
      Diagram(graphics = {Text(origin = {-20, 18}, extent = {{-28, 16}, {42, -46}}, textString = "COMPRESSOR"), Polygon(origin = {-12, 10}, points = {{-42, 40}, {-42, -44}, {42, -70}, {42, 70}, {-42, 40}, {-42, 40}})}, coordinateSystem(initialScale = 0.1)),
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-26, -2}, points = {{-40, 42}, {-42, -48}, {42, -78}, {42, 78}, {-40, 42}}), Text(origin = {-16, 11}, extent = {{-48, -31}, {24, 15}}, textString = "COMPRESSOR")}));
  end CompressorToDiscuss;

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

  model Turbine "OD model of a turbine"
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-32, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-38, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter Real eta_design = 0.9 "isentropic efficiency of the turbine";
    parameter Real PR = 2.313 "Pressure ratio";
    parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 273.15 + 40 "Outlet temperature in Kelvin";
    MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
    MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic decompression";
    MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real decompresssion";
    Modelica.SIunits.Power W_turb "Outlet power";
    Modelica.SIunits.AbsolutePressure p_out(start = 83.3 * 10 ^ 5);
    //SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
    Modelica.SIunits.SpecificEntropy s_entrance " entropy at the entrance of the turbine";
    parameter Modelica.SIunits.Area A_nozzle = 0.00257;
    parameter Real N_shaft = 10000 * 5 / 6 * 2 * 3.14159 / 60;
    Real d_outlet;
    Real C_spouting(start = 577);
    parameter Real diam_turb = 0.9;
    Real tipSpeed(start = 440);
    Real eta_turb;
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
    tipSpeed = N_shaft * diam_turb / 2;
    eta_turb = eta_design * 2 * (tipSpeed / C_spouting) * sqrt(abs(1 - (tipSpeed / C_spouting) ^ 2));
    annotation(
      Documentation(info = "<html>
  		<p>This turbine's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
  <p>The isentropic efficiency is calculated as a function of the tip speed ration between the tip speed of the rotor and the spouting velocity. It is said to be functionnal for any size.</p>
  <p>The outlet pressure goes beyond the critical pressure for a mass flow too small. The cycle calculation should therefore not be performed below this pressure.</p>
  <p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  		</html>"));
    annotation(
      Diagram(graphics = {Text(origin = {-36, -28}, extent = {{18, 80}, {78, 16}}, textString = "TURBINE"), Polygon(origin = {15, 20}, points = {{-35, 44}, {-35, -52}, {35, -68}, {35, 68}, {-35, 44}, {35, 68}, {-35, 44}})}, coordinateSystem(initialScale = 0.1)),
      Icon(graphics = {Text(origin = {-10, 26}, extent = {{-10, 12}, {52, -34}}, textString = "TURBINE"), Ellipse(extent = {{56, 58}, {56, 58}}, endAngle = 360), Polygon(origin = {11, 17}, points = {{-37, 49}, {-37, -51}, {37, -71}, {37, 71}, {-37, 49}})}, coordinateSystem(initialScale = 0.1)));
  end Turbine;

  model Exchanger
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    replaceable package MedRec = SolarTherm.Media.Sodium.ConstSodium;
    parameter Modelica.SIunits.MassFlowRate m_des_CO2 = 1.56;
    parameter Modelica.SIunits.MassFlowRate m_des_HTF = 1.56;
    parameter SolarTherm.Types.Conductance UA_HTR = 30000 "on-design conductance of the exchanger";
    parameter Modelica.SIunits.SpecificEnthalpy h_HTF_design = 272193;
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
    Modelica.SIunits.SpecificEnthalpy[2] h_CO2(start = {990000, 1100000});
    Modelica.SIunits.SpecificEnthalpy[2] h_HTF;
    Real[2] deltaT "Temperature difference in the heat exchangers";
    Modelica.SIunits.HeatFlowRate Q_HX_HTR;
    Modelica.SIunits.ThermodynamicTemperature T_CO2_out;
    Modelica.SIunits.ThermodynamicTemperature T_HTF_out;
    input Boolean m_sup;
    //Real deltaT_lm;
    Real deltaTAve;
    Modelica.SIunits.MassFlowRate m_HTF_bis;
  equation
    for i in 1:2 loop
      deltaT[i] = if m_sup then MedRec.temperature(state_HTF[i]) - MedPB.temperature(state_CO2[i]) else 80 + i;
      state_CO2[i] = MedPB.setState_phX(CO2_port_a.p, h_CO2[i]);
      state_HTF[i] = MedRec.setState_phX(HTF_port_a.p, h_HTF[i]);
    end for;
    T_CO2_out = MedPB.temperature(state_CO2[2]);
    T_HTF_out = MedRec.temperature(state_HTF[1]);
    //deltaT_lm = if deltaT[2] * deltaT[1] < 0 then (abs(deltaT[1]) ^ (1 / 3) * sign(deltaT[1]) / 2 + abs(deltaT[2]) ^ (1 / 3) * sign(deltaT[2]) / 2) ^ 3 else (deltaT[1] - deltaT[2]) / (Modelica.Math.log(deltaT[1] / deltaT[2]) + 0.0001);
    deltaTAve = (deltaT[1]+deltaT[2])/2;
    h_CO2[2] = CO2_port_b.h_outflow;
    h_HTF[2] = if m_sup then inStream(HTF_port_a.h_outflow) else h_HTF_design;
    h_CO2[1] = inStream(CO2_port_a.h_outflow);
    HTF_port_b.h_outflow = if m_sup then h_HTF[1] else inStream(HTF_port_a.h_outflow);
    m_HTF_bis = if m_sup then HTF_port_a.m_flow else m_des_HTF * 0.8;
    Q_HX_HTR = CO2_port_a.m_flow * (h_CO2[2] - h_CO2[1]);
    Q_HX_HTR = UA_HTR * deltaTAve * (1 / 2 * abs(m_HTF_bis / m_des_HTF + CO2_port_a.m_flow / m_des_CO2)) ^ 0.8;
    Q_HX_HTR = m_HTF_bis * (h_HTF[2] - h_HTF[1]);
    HTF_port_a.h_outflow = inStream(HTF_port_b.h_outflow);
    CO2_port_a.h_outflow = inStream(CO2_port_b.h_outflow);
//It is necessary to have one equation in a cycle that doesn't imply a circular equality on the mass flow rates
//CO2_port_b.m_flow + CO2_port_a.m_flow = 0;
    HTF_port_a.m_flow + HTF_port_b.m_flow = 0;
    CO2_port_a.m_flow = if m_sup then HTF_port_a.m_flow * MedRec.specificHeatCapacityCp(state_HTF[2]) / 1270 else m_des_CO2 * 0.8;
// Pressure equality
    CO2_port_b.p = CO2_port_a.p;
    HTF_port_a.p = HTF_port_b.p;
    annotation(
      Diagram(graphics = {Rectangle(origin = {1, 4}, extent = {{-57, 40}, {57, -40}}), Text(origin = {-1, 8}, extent = {{-47, 16}, {47, -16}}, textString = "Exchanger")}),
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
    annotation(
      Documentation(info = "<html>
  		<p>The exchanger is a heat exchanger between the HTF and the CO2. It is a counterflow HX, based on a TLMD. The conductance UA has to be specified from the on-design.</p>
  <p>The conductance in off-design varies as UA_Off=UA_on*(m_flow/m_design)^0.8.&nbsp;<span >The average between the two mass flows is taken.</span></p>
  <p>A.T. Louis et T. Neises, analysis and optimization for Off-design performance of the recompression s-CO2 cycles for high temperature CSP applications, in The 5th International Symposium-Supercritical CO2 Power Cycles, 2016</p>
  <p>&nbsp;</p>
  		</html>"));
  end Exchanger;

  model Cooler
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    input Modelica.SIunits.ThermodynamicTemperature T_amb "Ambiant temperature in Kelvin";
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-2, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter SolarTherm.Types.Conductance UA_cooler "Conductance of the cooler in W/K";
    parameter Modelica.SIunits.ThermodynamicTemperature T_low = 55 + 273.15;
    parameter Modelica.SIunits.Power P_cool_design = 1.49*10^6 "power necessary to cool down at design point";
    parameter Real deltaT_design = 15 "Difference between ambient and outlet CO2 temperature";
    MedPB.ThermodynamicState state_a "Thermodynamic State at the entrance";
    MedPB.ThermodynamicState state_b "Thermodynamic State at the outlet";
    Real[2] deltaT;
    Modelica.SIunits.HeatFlowRate Q_cooler;
    Modelica.SIunits.Power P_cooling;
    Real deltaT_ave "average difference of temperature with the ambiant";
  equation
    deltaT = {MedPB.temperature(state_a) - T_amb, MedPB.temperature(state_b) - T_amb};
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    state_b = MedPB.setState_pTX(port_a.p, max(T_amb+3,T_low));
    P_cooling = P_cool_design * (deltaT_design/deltaT[2])^(3/0.805);
    deltaT_ave = (deltaT[1] + deltaT[2]) / 2;
    Q_cooler = port_a.m_flow * (state_b.h - state_a.h);
    port_a.m_flow + port_b.m_flow = 0;
    port_a.p = port_b.p;
    port_b.h_outflow = state_b.h;
    port_a.h_outflow = inStream(port_b.h_outflow);
    annotation(
      Documentation(info = "<html>
  		<p>The cooler is thought to be a dry-air cooling device. The outlet temperature of the CO2 is imposed as max(T_low_cycle,T_amb+3). The variation of the ambiant temperature is taken into account in the estimation of the electricity demand for the fans, such as: P_cooling*deltaT/Q_cooler is a constant, deltaT being the average of the temperature of the CO2 and the ambiant, and Q_cooler the energy to withdraw.</p>
  		</html>"));
    annotation(
      Icon(graphics = {Rectangle(origin = {2, 1}, extent = {{-58, 65}, {58, -65}}), Text(origin = {0, -1}, extent = {{-40, -15}, {40, 15}}, textString = "COOLER")}),
      Diagram(graphics = {Rectangle(origin = {-4, 7}, extent = {{-64, 67}, {64, -67}}), Text(origin = {5, 14}, extent = {{-41, -12}, {41, 12}}, textString = "COOLER")}));
  end Cooler;

  model HeatRecuperatorDTAve "The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation."
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    parameter Integer N_q = 15 "Number of subdivision of the HX";
    parameter Modelica.SIunits.MassFlowRate m_des_comp = 1.5 "on-design mass flow from the compressor";
    parameter Modelica.SIunits.MassFlowRate m_des_turb = 1.5 "on-design mass-flow from the turbine";
    parameter SolarTherm.Types.Conductance UA_dis[N_q - 1] "on-design conductance of the heat recuperator";
    Modelica.Fluid.Interfaces.FluidPort_a from_comp_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a from_turb_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_comp_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_turb_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.SIunits.SpecificEnthalpy[N_q] h_from_turb(start = {500000 + (i - 1) / N_q * 200000 for i in 1:N_q});
    Modelica.SIunits.ThermodynamicTemperature[N_q] T_from_turb(start = {350 + (i - 1) / N_q * 150 for i in 1:N_q});
    Modelica.SIunits.SpecificEnthalpy[N_q] h_from_comp(start = {480000 + (i - 1) / N_q * 200000 for i in 1:N_q});
    Modelica.SIunits.ThermodynamicTemperature[N_q] T_from_comp(start = {320 + (i - 1) / N_q * 150 for i in 1:N_q});
    Real[N_q] deltaT(start = {150 for i in 1:N_q});
  protected
    MedPB.ThermodynamicState[N_q] state_from_turb;
    MedPB.ThermodynamicState[N_q] state_from_comp;
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
    for i in 2:N_q loop
      from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = from_comp_port_a.m_flow * (h_from_comp[i] - h_from_comp[i - 1]);
      from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = UA_dis[i - 1] * abs(from_comp_port_a.m_flow / m_des_comp + from_turb_port_a.m_flow / m_des_turb) ^ 0.8 / 2 ^ 0.8 * (T_from_turb[i - 1] - T_from_comp[i - 1] + T_from_turb[i] - T_from_comp[i]) / 2;
    end for;
    from_turb_port_b.m_flow + from_turb_port_a.m_flow = 0;
    from_comp_port_b.m_flow + from_comp_port_a.m_flow = 0;
    from_turb_port_b.p = from_turb_port_a.p;
    from_comp_port_b.p = from_comp_port_a.p;
    from_turb_port_a.h_outflow = inStream(from_turb_port_b.h_outflow);
    from_comp_port_a.h_outflow = inStream(from_comp_port_b.h_outflow);
    annotation(
      Diagram(graphics = {Rectangle(origin = {1, 7}, extent = {{-61, 31}, {61, -31}}), Text(origin = {5, 1}, extent = {{-53, -17}, {53, 17}}, textString = "RECUPERATOR")}),
      Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-65, 33}, {65, -33}}), Text(origin = {-2, -5}, extent = {{-46, -15}, {46, 15}}, textString = "RECUPERATOR")}));
    annotation(
      Documentation(info = "<html>
  		<p>This heat recuperator is a counter-flow HX. Closure equations are based on the equality of m_flow*delta_H for both sides and m_flow*delta_H= UA_i*DTAve_i, DTAve being the average of the temperature difference between the inlet and the outlet of the sub-HX.</p>
  <p>The UA_i must be given as parameters from the on-design analysis.&nbsp;</p>
  		
  		</html>"));
  end HeatRecuperatorDTAve;

  model test
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedRec=SolarTherm.Media.SolidParticles.CarboHSP_ph;
    MedRec.ThermodynamicState trial;
    Real bis;
  equation
    trial=MedRec.setState_pTX(10^5,800+273.15);
    bis=MedRec.specificHeatCapacityCp(trial);
  end test;

  model Heater
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
    Modelica.SIunits.ThermodynamicTemperature T_real;
  equation
    T_real = T_high;
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    state_b = MedPB.setState_pTX(port_a.p, T_real);
    Q_heater = port_a.m_flow * (MedPB.specificEnthalpy(state_b) - MedPB.specificEnthalpy(state_a));
    port_a.m_flow + port_b.m_flow = 0;
    port_b.p = port_a.p;
    port_b.h_outflow = MedPB.specificEnthalpy(state_b);
    port_a.h_outflow = inStream(port_b.h_outflow);
    ex_d = Q_heater * (1 - T_amb / T_real) + port_a.m_flow * (state_a.h - T_amb * MedPB.specificEntropy(state_a)) + port_b.m_flow * (state_b.h - T_amb * MedPB.specificEntropy(state_b));
    annotation(
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {0, -2}, extent = {{-48, 62}, {48, -62}}), Text(origin = {2, -2}, extent = {{-36, 12}, {36, -12}}, textString = "HEATER")}),
      Diagram(graphics = {Rectangle(origin = {2, 6}, extent = {{-44, 64}, {44, -64}}), Text(origin = {-30, 1}, extent = {{0, -1}, {64, 25}}, textString = "HEATER", fontSize = 15)}),
      __OpenModelica_commandLineOptions = "");
  end Heater;

  model CompressorOnShaft "0D model of a compressor on the same shaft as the turbine"
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {42, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter Real eta_design = 0.87 "Maximal isentropic efficiency of the compressor";
    parameter Real diam_rotor = 0.18 "on-design diameter of the rotor";
    parameter Real N_design = 3358 "Design rotationnal speed in rad/s";
    parameter Real psi_des = 2.63 "on-design adimensionned head";
    Modelica.SIunits.AbsolutePressure p_out(start = 250 * 10 ^ 5) "outlet pressure";
    MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
    MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
    MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
    Modelica.SIunits.Power W_comp "power used for compression";
    Modelica.SIunits.SpecificEntropy s_entrance "entropy at the entrance of the compressor";
    Real phi "adimensionned mass flow rate";
    Real psi "adimensionned head";
    Real tipSpeed "tip Speed of the rotor";
    Real d_entrance(start = 267) "desity at the inlet";
    Modelica.SIunits.Efficiency eta_comp(start = eta_design) "isentropic efficiency of the compressor";
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
    tipSpeed = diam_rotor * N_design / 2;
    phi = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2);
    psi = (state_isen.h - state_a.h) / tipSpeed ^ 2;
    psi = (0.04049 + 54.7 * phi - 2505 * phi ^ 2 + 53224 * phi ^ 3 - 498626 * phi ^ 4) * psi_des / 0.46;
    eta_comp = eta_design / 0.677837 * ((-0.7069) + 168.6 * phi - 8089 * phi ^ 2 + 182725 * phi ^ 3 - 1.638 * 10 ^ 6 * phi ^ 4);
    annotation(
      Documentation(info = "<html>
  		<p>This compressor's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
  <p>The performance maps comes from the Sandia National Laboratory first compressor. It should be updated. The performance maps is compressed in three correlations, expressing the adimensionned head and the efficiency as functions of the adimensionned mass flow.&nbsp;</p>
  <p>The same correlations are used; only the maximal values are changed.</p>
  <p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  		
  		</html>"));
    annotation(
      Diagram(graphics = {Text(origin = {-20, 18}, extent = {{-28, 16}, {42, -46}}, textString = "COMPRESSOR"), Polygon(origin = {-12, 10}, points = {{-42, 40}, {-42, -44}, {42, -70}, {42, 70}, {-42, 40}, {-42, 40}})}, coordinateSystem(initialScale = 0.1)),
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-26, -2}, points = {{-40, 42}, {-42, -48}, {42, -78}, {42, 78}, {-40, 42}}), Text(origin = {-16, 11}, extent = {{-48, -31}, {24, 15}}, textString = "COMPRESSOR")}));
  end CompressorOnShaft;

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
  //  SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow src(T_out = 800, p_out = 10 ^ 5, m_flow = 986, redeclare package MedPB = SolarTherm.Media.SolidParticles.CarboHSP_ph, use_m_parameter = true) annotation(
  //    Placement(visible = true, transformation(origin = {84, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  //  SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink annotation(
  //    Placement(visible = true, transformation(origin = {14, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  //  connect(sink.port_a, exchanger.HTF_port_b) annotation(
  //    Line(points = {{21.4, 14}, {37.4, 14}, {37.4, 10}, {37.4, 10}}, color = {0, 127, 255}));
  //  connect(src.port_b, exchanger.HTF_port_a) annotation(
  //    Line(points = {{76, 16}, {52, 16}, {52, 10}, {52, 10}, {52, 10}, {52, 10}}, color = {0, 127, 255}));
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
end OffDesign;