within SolarTherm.Models.PowerBlocks.sCO2Cycle;

package QuickCO2PB
  model Turbine "OD model of a turbine"
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    import SI = Modelica.SIunits;
    parameter SI.Efficiency eta_design = 0.9 "isentropic efficiency of the turbine";
    parameter SI.Efficiency PR = 3 "Pressure ratio";
    parameter SI.AngularVelocity N_shaft = 3358;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-32, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-38, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    MedPB.ThermodynamicState state_a(h.start = h_in_des) "thermodynamic state at the entrance";
    MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic decompression";
    MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real decompresssion";
    SI.Power W_turb "Outlet power";
    SI.SpecificEntropy s_entrance " entropy at the entrance of the turbine";
    parameter MedPB.ThermodynamicState state_in_des(p.fixed = false, h.fixed = false, h.start = 1.2 * 10 ^ 6), state_isen_des(p.fixed = false, h.fixed = false), state_out_des(p.fixed = false, h.fixed = false, h.start = 900000);
    parameter SI.SpecificEnthalpy h_in_des(fixed = false), h_out_des(fixed = false);
    parameter SI.AbsolutePressure p_in_des(fixed = false), p_out_des(fixed = false, start = 80 * 10 ^ 5);
    parameter SI.MassFlowRate m_des(fixed = false);
    parameter SI.Power W_turb_des(fixed = false);
  initial equation
    state_in_des = MedPB.setState_phX(p_in_des, h_in_des);
    state_isen_des = MedPB.setState_psX(p_in_des / PR, MedPB.specificEntropy(state_in_des));
    h_out_des = state_in_des.h + (state_isen_des.h - state_in_des.h) * eta_design;
    p_out_des = p_in_des / PR;
    state_out_des.p = p_out_des;
    state_out_des.h = h_out_des;
    W_turb_des = m_des * (h_out_des - state_in_des.h);
  equation
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    s_entrance = MedPB.specificEntropy(state_a);
    state_isen = MedPB.setState_psX(p_out_des, s_entrance);
    state_b = MedPB.setState_phX(p_out_des, state_a.h + (state_isen.h - state_a.h) * eta_design);
    port_b.p = state_b.p;
    port_a.h_outflow = inStream(port_b.h_outflow);
    port_b.h_outflow = state_b.h;
    W_turb = port_a.m_flow * (state_b.h - state_a.h);
    port_a.m_flow + port_b.m_flow = 0;
    annotation(
      Diagram(graphics = {Text(origin = {-36, -28}, extent = {{18, 80}, {78, 16}}, textString = "TURBINE"), Polygon(origin = {15, 20}, points = {{-35, 44}, {-35, -52}, {35, -68}, {35, 68}, {-35, 44}, {35, 68}, {-35, 44}})}, coordinateSystem(initialScale = 0.1)),
  Icon(graphics = {Text(origin = {-10, 26}, extent = {{-10, 12}, {52, -34}}, textString = "TURBINE"), Ellipse(extent = {{56, 58}, {56, 58}}, endAngle = 360), Polygon(origin = {11, 17}, points = {{-37, 49}, {-37, -51}, {37, -71}, {37, 71}, {-37, 49}})}, coordinateSystem(initialScale = 0.1)));
    annotation(
      Documentation(info = "<html>
  		<p>This turbine's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
  <p>The isentropic efficiency is calculated as a function of the tip speed ration between the tip speed of the rotor and the spouting velocity. It is said to be functionnal for any size.</p>
  <p>The outlet pressure goes beyond the critical pressure for a mass flow too small. The cycle calculation should therefore not be performed below this pressure.</p>
  <p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  		</html>"));
  end Turbine;

  model Exchanger
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
    import SI = Modelica.SIunits;
    parameter SI.ThermodynamicTemperature T_out_CO2_des = 715 + 273.15;
    parameter SI.Power P_nom_des = 164000;
    input Boolean m_sup "when m_sup=false, m_HTF=m_HTF_design and P_elec=0 -> allows switching off the PB";
    parameter Real ratio_m_des = 1 "ratio of m_CO2_des/m_HTF_des at design point";
    parameter Integer N_exch = 8;
    Modelica.Fluid.Interfaces.FluidPort_a HTF_port_a(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {60, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a CO2_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b HTF_port_b(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b CO2_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {58, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
      Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-2, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
    for i in 1:N_cool loop
      state_des[i] = MedPB.setState_pTX(p_in_des, T_CO2_des[i]);
      h_CO2_des[i] = MedPB.specificEnthalpy(state_des[i]);
      deltaT_des[i] = T_CO2_des[i] - T_amb_des;
    end for;
    T_CO2_des[N_cool] = T_low;
    h_CO2_des[1] = h_in_des;
    h_CO2_des[N_cool] = h_out_des;
    p_out_des = p_in_des;
    for i in 1:N_cool - 1 loop
      Q_dis_des = h_CO2_des[i + 1] - h_CO2_des[i];
      m_des * Q_dis_des = -UA_dis[i] * (deltaT_des[i] + deltaT_des[i + 1]) / 2;
//deltaT_lm_des[i] = if deltaT_des[i+1] * deltaT_des[i] < 0 then (abs(deltaT_des[i]) ^ (1 / 3) * sign(deltaT_des[i]) / 2 + abs(deltaT_des[i+1]) ^ (1 / 3) * sign(deltaT_des[i+1]) / 2) ^ 3 else (deltaT_des[i] - deltaT_des[i+1]) / (Modelica.Math.log(deltaT_des[i] / deltaT_des[i+1]) + 0.0001);
    end for;
    UA_cooler = sum(UA_dis);
    Q_cooler_des = (N_cool - 1) * Q_dis_des * m_des;
//P_cool_des * deltaT_des[N_cool]/(-Q_cooler_des)= 1.49*10^6*(35.7-30)/(136.6*10^6);
    P_cool_des = 0.01 * P_nom_des;
  equation
    deltaT = {MedPB.temperature(state_a) - T_amb, MedPB.temperature(state_b) - T_amb};
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    state_b = MedPB.setState_pTX(port_a.p, max(T_amb + 5, T_low));
    P_cooling = P_cool_des * (deltaT_design / deltaT[2]) ^ (3 / 0.805) * (Q_cooler / Q_cooler_des);
    Q_cooler = port_a.m_flow * (state_b.h - state_a.h);
    port_a.m_flow + port_b.m_flow = 0;
    port_a.p = port_b.p;
    port_b.h_outflow = state_b.h;
    port_a.h_outflow = inStream(port_b.h_outflow);
    annotation(
      Icon(graphics = {Rectangle(origin = {2, 1}, extent = {{-58, 65}, {58, -65}}), Text(origin = {0, -1}, extent = {{-40, -15}, {40, 15}}, textString = "COOLER")}),
  Diagram(graphics = {Rectangle(origin = {-4, 7}, extent = {{-64, 67}, {64, -67}}), Text(origin = {5, 14}, extent = {{-41, -12}, {41, 12}}, textString = "COOLER")}));
    annotation(
      Documentation(info = "<html>
  		<p>The cooler is thought to be a dry-air cooling device. The outlet temperature of the CO2 is imposed as max(T_low_cycle,T_amb+3). The variation of the ambiant temperature is taken into account in the estimation of the electricity demand for the fans, such as: P_cooling*deltaT/Q_cooler is a constant, deltaT being the average of the temperature of the CO2 and the ambiant, and Q_cooler the energy to withdraw.</p>
  		</html>"));
  end Cooler;

  model HeatRecuperatorDTAve "The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation."
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    import SI = Modelica.SIunits;
    parameter Integer N_q = 15 "Number of subdivision of the HX";
    parameter Real ratio_m_des = 1 "ratio of m_comp_des/m_turb_des; we suppose m_turb_des=1, and then scale-up";
    parameter Real pinchRecuperator = 5 "pinch of the recuperator. Imposed as a closing equation for on-design";
    Modelica.Fluid.Interfaces.FluidPort_a from_comp_port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a from_turb_port_a(redeclare package Medium = MedPB, m_flow.start = P_nom_des / 10 ^ 5) annotation(
      Placement(visible = true, transformation(origin = {60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_comp_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b from_turb_port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
      Documentation(info = "<html>
  		<p>This heat recuperator is a counter-flow HX. Closure equations are based on the equality of m_flow*delta_H for both sides and m_flow*delta_H= UA_i*DTAve_i, DTAve being the average of the temperature difference between the inlet and the outlet of the sub-HX.</p>
  <p>The UA_i must be given as parameters from the on-design analysis.&nbsp;</p>
  		
  		</html>"));
    annotation(
      Diagram(graphics = {Rectangle(origin = {1, 7}, extent = {{-61, 31}, {61, -31}}), Text(origin = {5, 1}, extent = {{-53, -17}, {53, 17}}, textString = "RECUPERATOR")}),
  Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-65, 33}, {65, -33}}), Text(origin = {-2, -5}, extent = {{-46, -15}, {46, 15}}, textString = "RECUPERATOR")}));
  end HeatRecuperatorDTAve;

  model CompressorOnShaft "0D model of a compressor on the same shaft as the turbine"
    extends SolarTherm.Media.CO2.PropCO2;
    import SI = Modelica.SIunits;
    import CV = Modelica.SIunits.Conversions;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    parameter Real eta_design = 0.89 "Maximal isentropic efficiency of the compressor";
    parameter SI.AngularVelocity N_design = 40000 * 0.104 "Design rotationnal speed in rad/s";
    parameter Real PR = 3 "pressure ratio chosen";
    parameter SI.Power P_nom_des "nominal power at design point";
    parameter SI.ThermodynamicTemperature T_in_des = CV.from_degC(45) "chosen inlet temperature of the compressor at design point";
    parameter SI.AbsolutePressure p_high_des = CV.from_bar(250);
    MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
    MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
    MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
    SI.Power W_comp "power used for compression";
    SI.SpecificEntropy s_entrance "entropy at the entrance of the compressor";
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
      Placement(visible = true, transformation(origin = {42, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter SI.SpecificEnthalpy h_out_des(fixed = false), h_in_des(fixed = false) "enthalpy at the outlet of the compressor";
    parameter MedPB.ThermodynamicState state_in_des(p.fixed = false, h.fixed = false, h.start = 550000);
    parameter MedPB.ThermodynamicState state_isen_des(p.fixed = false, h.fixed = false);
    parameter SI.AbsolutePressure p_in_des(fixed = false), p_out_des(fixed = false);
    parameter SI.Power W_comp_des(fixed = false);
    parameter SI.MassFlowRate m_des(fixed = false, start = 3) "design mass flow rate in kg/s";
  initial equation
    W_comp_des = m_des * (h_out_des - state_in_des.h);
    state_in_des = MedPB.setState_phX(p_in_des, h_in_des);
    p_out_des = p_high_des;
    state_isen_des = MedPB.setState_psX(p_out_des, MedPB.specificEntropy(state_in_des));
    h_out_des = state_in_des.h + (state_isen_des.h - state_in_des.h) / eta_design;
  equation
    state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
    s_entrance = MedPB.specificEntropy(state_a);
    state_isen = MedPB.setState_psX(p_out_des, s_entrance);
    state_b = MedPB.setState_phX(p_out_des, state_a.h + (state_isen.h - state_a.h) / eta_design);
    port_b.p = state_b.p;
    port_b.h_outflow = state_b.h;
    W_comp = port_a.m_flow * (state_b.h - state_a.h);
    port_a.h_outflow = 0;
    port_a.m_flow + port_b.m_flow = 0;
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
    import SI = Modelica.SIunits;
    import FI = SolarTherm.Models.Analysis.Finances;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
    //input SolarTherm.Interfaces.Connectors.WeatherBus wbus;
    extends Icons.PowerBlock;
    //  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = MedRec) annotation(
    //    Placement(visible = true,transformation(extent = {{-54, 22}, {-34, 42}}, rotation = 0), iconTransformation(extent = {{-48, 28}, {-40, 36}}, rotation = 0)));
    //  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = MedRec) annotation(
    //    Placement(transformation(extent = {{-74, -60}, {-54, -40}}), iconTransformation(extent = {{-62, -48}, {-54, -40}})));
    Modelica.Blocks.Interfaces.RealOutput W_net(quantity = "Power", unit = "W", displayUnit = "W") "Net electric power output" annotation(
      Placement(visible = true, transformation(extent = {{78, -22}, {98, -2}}, rotation = 0), iconTransformation(extent = {{48, -12}, {58, -2}}, rotation = 0)));
    // PB parameters
    parameter Boolean external_parasities = false "= true enable parasities as an input";
    parameter Real nu_min = 0.25 "Minimum turbine operation";
    Modelica.Blocks.Interfaces.RealInput parasities if external_parasities annotation(
      Placement(transformation(extent = {{-12, -12}, {12, 12}}, rotation = -90, origin = {1.77636e-015, 80}), iconTransformation(extent = {{-6, -6}, {6, 6}}, rotation = -90, origin = {20, 60})));
    input SI.ThermodynamicTemperature T_amb;
    //Cycle parameters
    parameter SI.AbsolutePressure p_high = 200 * 10 ^ 5 "high pressure of the cycle";
    parameter SI.ThermodynamicTemperature T_high = 715 + 273.15 "inlet temperature of the turbine";
    parameter SI.ThermodynamicTemperature T_amb_des = 30 + 273.15 "ambiant temperature";
    parameter Real PR = 2.5 "Pressure ratio";
    parameter SI.Power P_gro = 100 * 10 ^ 6 "first guess of power outlet";
    parameter SI.Power P_nom(fixed = false) "Electrical power at design point";
    parameter SI.MassFlowRate m_HTF_des = 1000 "Mass flow rate at design point";
    parameter Real gamma = 0.28 "Part of the mass flow going to the recompression directly";
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
    parameter SI.ThermodynamicTemperature T_low = 45 + 273.15 "Outlet temperature of the cooler";
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
    SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.HeatRecuperatorDTAve HTR(N_q = N_HTR, P_nom_des = P_gro, ratio_m_des = 1) annotation(
      Placement(visible = true, transformation(origin = {12, -22}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.CompressorOnShaft mainCompressor(eta_design = eta_comp_main, N_design = N_shaft, P_nom_des = P_gro, p_high_des = p_high) annotation(
      Placement(visible = true, transformation(origin = {-74, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.Cooler cooler(T_low = T_low, P_nom_des = P_gro, T_amb_des = T_amb_des) annotation(
      Placement(visible = true, transformation(origin = {-78, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.Turbine turbine(PR = PR, N_shaft = N_shaft, eta_design = eta_turb) annotation(
      Placement(visible = true, transformation(origin = {66, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.Exchanger exchanger(redeclare package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph, P_nom_des = P_gro, T_out_CO2_des = T_high, N_exch = N_exch, ratio_m_des = 1) annotation(
      Placement(visible = true, transformation(extent = {{34, -8}, {54, 12}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.CompressorOnShaft reCompressor(N_design = N_shaft, P_nom_des = P_gro, p_high_des = p_high) annotation(
      Placement(visible = true, transformation(origin = {-54, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.HeatRecuperatorDTAve LTR(N_q = N_LTR, P_nom_des = P_gro, ratio_m_des = 1 - gamma) annotation(
      Placement(visible = true, transformation(origin = {-42, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.FlowMixer mixer annotation(
      Placement(visible = true, transformation(origin = {-20, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB.FlowSplitter splitter(gamma = gamma) annotation(
      Placement(visible = true, transformation(origin = {-62, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    parameter MedRec.ThermodynamicState state_HTF_in_des = MedRec.setState_pTX(1.0325 * 10 ^ 5, T_HTF_in_des);
    //     SolarTherm.Models.PowerBlocks.sCO2Cycle.SourceFlow src(T_out = 800+273.15, p_out = 10 ^ 5, m_flow = exchanger.m_HTF_des, redeclare package MedPB = SolarTherm.Media.SolidParticles.CarboHSP_ph, use_m_parameter = true) annotation(
    //        Placement(visible = true, transformation(origin = {-52, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    //      SolarTherm.Models.PowerBlocks.sCO2Cycle.SinkFlow sink annotation(
    //        Placement(visible = true, transformation(origin = {-50, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    // Modelica.Blocks.Interfaces.RealInput parasities_internal;
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
    C_HTR = if HTR.T_turb_des[N_HTR] >= 550 + 273.15 then 49.45 * HTR.UA_HTR ^ 0.7544 * (1 + 0.02141 * (HTR.T_turb_des[N_HTR] - 550 - 273.15)) else 49.45 * HTR.UA_HTR ^ 0.7544;
    C_LTR = 49.45 * LTR.UA_HTR ^ 0.7544;
    C_turbine = if exchanger.T_CO2_des[2] >= 550 + 273.15 then 406200 * (-turbine.W_turb_des / 10 ^ 6) ^ 0.8 * (1 + 1.137 * 10 ^ (-5) * (exchanger.T_CO2_des[2] - 550 - 273.15) ^ 2) else 406200 * (-turbine.W_turb_des / 10 ^ 6) ^ 0.8;
    C_mainCompressor = 1230000 * (mainCompressor.W_comp_des / 10 ^ 6) ^ 0.3392;
    C_reCompressor = 1230000 * (reCompressor.W_comp_des / 10 ^ 6) ^ 0.3392;
    C_cooler = 32.88 * cooler.UA_cooler ^ 0.75;
    C_generator = 108900 * (P_nom / 10 ^ 6) ^ 0.5463;
    C_exchanger = pri_exchanger * exchanger.Q_HX_des * m_HTF_des / 1000;
    C_PB = (C_HTR + C_LTR + C_turbine + C_mainCompressor + C_reCompressor + C_generator + C_cooler + C_exchanger) * 1.05;
// 1.05 corresponds to inflation from 2017, as correlations are in 2017' dollars.
  equation
    connect(m_sup, exchanger.m_sup) annotation(
      Line);
    connect(exchanger.CO2_port_b, turbine.port_a) annotation(
      Line(points = {{50, -4}, {64.2, -4}, {64.2, -23.8}, {62.2, -23.8}, {62.2, -25.8}}, color = {0, 127, 255}));
    connect(exchanger.CO2_port_a, HTR.from_comp_port_b) annotation(
      Line(points = {{37, -4}, {22.8, -4}, {22.8, -13.6}}, color = {0, 127, 255}));
//  connect(fluid_b, exchanger.HTF_port_b) annotation(
//    Line(points = {{-64, -50}, {12, -50}, {12, 10}, {38, 10}, {38, 10}}, color = {0, 127, 255}));
//  connect(fluid_a, exchanger.HTF_port_a) annotation(
//    Line(points = {{-44, 32}, {54, 32}, {54, 10}, {52, 10}, {52, 10}}, color = {0, 127, 255}));
//connect(src.port_b, fluid_a) annotation(
//  Line(points = {{-60, 64}, {-72, 64}, {-72, 30}, {-42, 30}, {-42, 32}, {-44, 32}}, color = {0, 127, 255}));
//connect(sink.port_a, fluid_b) annotation(
//  Line(points = {{-42, -78}, {-64, -78}, {-64, -54}, {-64, -54}, {-64, -50}}, color = {0, 127, 255}));
//if external_parasities then
//    connect(parasities_internal,parasities);
//  else
//    parasities_internal=0;
//  end if;
    connect(LTR.from_turb_port_b, splitter.port_a) annotation(
      Line(points = {{-50, -34}, {-54, -34}, {-54, -36}, {-54, -36}}, color = {0, 127, 255}));
    connect(LTR.from_turb_port_a, HTR.from_turb_port_b) annotation(
      Line(points = {{-36, -34}, {0, -34}, {0, -32}, {0, -32}}, color = {0, 127, 255}));
    connect(reCompressor.port_b, mixer.second_port_a) annotation(
      Line(points = {{-50, -4}, {-20, -4}, {-20, -10}, {-20, -10}}, color = {0, 127, 255}));
    connect(LTR.from_comp_port_b, mixer.first_port_a) annotation(
      Line(points = {{-36, -24}, {-28, -24}, {-28, -18}, {-28, -18}}, color = {0, 127, 255}));
    connect(mixer.port_b, HTR.from_comp_port_a) annotation(
      Line(points = {{-12, -18}, {-4, -18}, {-4, -16}, {0, -16}}, color = {0, 127, 255}));
    connect(splitter.gamma_port_b, reCompressor.port_a) annotation(
      Line(points = {{-62, -28}, {-62, -28}, {-62, 8}, {-62, 8}}, color = {0, 127, 255}));
    connect(mainCompressor.port_b, LTR.from_comp_port_a) annotation(
      Line(points = {{-70, -18}, {-50, -18}, {-50, -24}, {-50, -24}}, color = {0, 127, 255}));
    connect(splitter.one_gamma_port_b, cooler.port_a) annotation(
      Line(points = {{-70, -36}, {-70, -36}, {-70, -62}, {-78, -62}, {-78, -62}}, color = {0, 127, 255}));
    connect(turbine.port_b, HTR.from_turb_port_a) annotation(
      Line(points = {{72, -36.6}, {48, -36.6}, {48, -34.6}, {22, -34.6}, {22, -34.1}, {22, -34.1}, {22, -31.6}}, color = {0, 127, 255}));
    connect(cooler.port_b, mainCompressor.port_a) annotation(
      Line(points = {{-78, -46}, {-88, -46}, {-88, -6}, {-82, -6}, {-82, -6}}, color = {0, 127, 255}));
    connect(cooler.T_amb, T_amb);
    connect(m_sup, cooler.m_sup);
//  exchanger.HTF_port_b.m_flow=fluid_b.m_flow;
//  -fluid_a.m_flow+exchanger.HTF_port_a.m_flow=0;
//  exchanger.HTF_port_b.p=fluid_b.p;
//  exchanger.HTF_port_a.p=fluid_a.p;
//  exchanger.HTF_port_a.h_outflow=fluid_a.h_outflow;
//  fluid_b.h_outflow=exchanger.HTF_port_b.h_outflow;
//m_sup = true;
    m_sup = exchanger.HTF_port_a.m_flow >= exchanger.m_HTF_des * nu_min;
    exchanger.CO2_port_a.m_flow = exchanger.m_CO2_des;
    eta_cycle = W_net / exchanger.Q_HX;
    der(E_net) = W_net;
    W_net = if m_sup then (-turbine.W_turb) - mainCompressor.W_comp - reCompressor.W_comp - cooler.P_cooling else 0;
    annotation(
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
      __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
  end recompPB;

  model FlowSplitter
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedRec = SolarTherm.Media.CO2.CO2_ph;
    parameter Real gamma;
    Real gamma_var;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b gamma_port_b(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {0, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b one_gamma_port_b(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
      Icon(graphics = {Text(origin = {0, 10}, extent = {{-56, -16}, {56, 16}}, textString = "SPLITTER")}),
      Diagram(graphics = {Text(origin = {7, 8}, extent = {{-49, -16}, {49, 16}}, textString = "SPLITTER")}));
  end FlowSplitter;

  model FlowMixer "This model is useful for the recompression cycle cycle, as it allows to mix two different fluid. The pressure in both should entrance should be the same; in case it is not, we ponderated it by the mass flows: as it is the same molar mass, the resulting pressure should look like that."
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedRec = SolarTherm.Media.CO2.CO2_ph;
    Modelica.Fluid.Interfaces.FluidPort_a first_port_a(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {0, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a second_port_a(redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedRec) annotation(
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
      __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));end test;

  model interpolSimplePB "This model calculates a few off-design points as initial equation and after interpolate over them"
    import SI = Modelica.SIunits;
    import CV = Modelica.SIunits.Conversions;
    import FI = SolarTherm.Models.Analysis.Finances;
    extends SolarTherm.Media.CO2.PropCO2;
    extends Icons.PowerBlock;
    
    input SI.ThermodynamicTemperature T_amb;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
    
    //Objective: having a few points in order to interpolate the HTF outlet temperature and the TIT. Should be feasible with for loops in the initial equation.
    parameter SI.Power P_nom = 100 * 10 ^ 6;
    parameter SI.AbsolutePressure p_high = CV.from_bar(250);
    parameter SI.AbsolutePressure p_low = CV.from_bar(80);
    parameter Real PR = p_high / p_low;
    parameter SI.ThermodynamicTemperature T_high = CV.from_degC(715) "inlet temperature of the turbine";
    parameter SI.ThermodynamicTemperature T_HTF_in_des = CV.from_degC(800) "inlet temperature of the HTF";
    parameter SI.ThermodynamicTemperature T_low = CV.from_degC(45) "Inlet temperature of the compressor";
    parameter SI.ThermodynamicTemperature T_amb_des = CV.from_degC(20) "ambient temperature at design";
    parameter SI.TemperatureDifference pinchHTR = 5;
    parameter SI.TemperatureDifference pinchExch = T_HTF_in_des - T_high;
    parameter SI.Efficiency eta_comp = 0.89;
    parameter SI.Efficiency eta_turb = 0.93;
    parameter Integer N_exch = 5;
    parameter Integer N_HTR = 15;
    parameter Integer N_cooler = 15;
    
    //Variables for real time calculation
    //Exchanger variables
    Boolean m_sup "indicates if mass flow from tank is superior enough to calculate";
    SI.MassFlowRate m_HTF_bis "mass flow rate used for switching off the PB";
    SI.ThermodynamicTemperature T_HTF_in "Inlet temperature of HTF";
    SI.ThermodynamicTemperature T_HTF_out "Outlet temperature of HTF";
    SI.ThermodynamicTemperature TIT_CO2 "Turbine inlet Temperature of CO2";
    SI.ThermodynamicTemperature T_CO2_in_HX "CO2 temperature at the inlet of the exchanger";
    
    MedPB.ThermodynamicState[N_exch] state_CO2_HX(each h.start = 10 ^ 6);
    MedRec.ThermodynamicState[N_exch] state_HTF_HX(each h.start = 6 * 10 ^ 5);
    SI.TemperatureDifference[N_exch] deltaT_HX(each start = 20);
    
    //PowerBlock variables
     Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = MedRec) annotation (Placement(
          transformation(extent={{-54,22},{-34,42}}),  iconTransformation(extent={{-48,30},
              {-40,38}})));
    Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = MedRec) annotation (Placement(
          transformation(extent={{-74,-60},{-54,-40}}),iconTransformation(extent={{-62,-48},
              {-54,-40}})));
    
    Modelica.Blocks.Interfaces.RealOutput W_net(
      quantity="Power",
      unit="W",
      displayUnit="W") "Net electric power output" annotation (Placement(
          visible = true,transformation(extent = {{78, -22}, {98, -2}}, rotation = 0), iconTransformation(extent = {{46, -10}, {56, 0}}, rotation = 0)));
    
    SI.Power P_cooling "Cooling power necessary to cool down the fluid";
    parameter FI.Money C_PB (fixed=false) "Overall cost of the power block";
    parameter SI.ThermodynamicTemperature T_HTF_out_des (fixed=false);
    parameter MedPB.ThermodynamicState state_comW_out (p.fixed=false, h.fixed=false);
    //Off-design parameters for calculation
    parameter Integer N_points = 10;
    parameter SI.ThermodynamicTemperature[N_points] T_high_frac(each fixed = false) "points for which efficiency will be calculated";
    
    //parameters to calculate on and off-design
    parameter SI.MassFlowRate m_des(fixed = false, start = P_nom / 10 ^ 5) "mass flow rate at the outlet of the turbine";
    parameter SI.Power[N_points] W_out(each fixed = false, each start = P_nom) "power at the outlet for off-design";
    parameter SI.Efficiency eta_cycle_on(fixed = false, start = 0.5) "efficiency of the cycle";
    parameter SI.Efficiency[N_points] eta_cycle_off(each fixed = false, each start = 0.5) "efficiency of the cycle";
    // bougé pour voir ce qu'il se passe
    parameter SI.Power W_comp(fixed = false);
    parameter SI.HeatFlowRate Q_dis_exch(fixed = false);
    parameter MedPB.ThermodynamicState state_cooler_out(p.fixed = false, h.fixed = false);
  protected
  
    //Inlet of the turbine
    parameter SI.SpecificEntropy[N_points + 1] s_in_turb(each fixed = false, each start = 2900) "inlet entropy to the turbine";
    parameter MedPB.ThermodynamicState[N_points + 1] state_in_turb(each p.fixed = false, each h.fixed = false);
    parameter SI.Power[N_points + 1] W_turb(each fixed = false);
    parameter MedPB.ThermodynamicState[N_points + 1] state_out_turb(each p.fixed = false, each h.fixed = false);
    
    //Main Compressor parameters
    parameter SI.SpecificEntropy s_in_mainComp(fixed = false, start = 1500) "inlet entropy to the main compressor";
    
    //Exchanger parameters. Calculated only at on-design
    parameter SolarTherm.Types.Conductance[N_exch - 1] UA_exch_dis(each fixed = false, each start = P_nom * 0.4 / N_exch);
    
    parameter MedPB.ThermodynamicState[N_exch] state_CO2_exch(each p.fixed = false, each h.fixed = false, each h.start = 10 ^ 6);
    parameter MedRec.ThermodynamicState[N_exch] state_HTF_exch(each p.fixed = false, each h.fixed = false, each h.start = 6 * 10 ^ 5);
    parameter SI.TemperatureDifference[N_exch] deltaT_exch(each start = 20, each fixed = false);
    
    // HTR parameters
    parameter SolarTherm.Types.Conductance[N_HTR - 1] UA_HTR_dis(each fixed = false, each start = P_nom * 0.4 / N_HTR);
    parameter SI.HeatFlowRate Q_dis_HTR(fixed = false, start = 2 * 10 ^ 4);
    parameter MedPB.ThermodynamicState[N_points + 1, N_HTR] state_HTR_turb(each p.fixed = false, each h.fixed = false, each h.start = 7 * 10 ^ 5);
    parameter MedPB.ThermodynamicState[N_points + 1, N_HTR] state_HTR_comp(each p.fixed = false, each h.fixed = false, each h.start = 6 * 10 ^ 5);
    parameter SI.TemperatureDifference[N_points + 1, N_HTR] deltaT_HTR(each start = 20, each fixed = false);
    parameter SI.ThermodynamicTemperature[N_points] T_CO2_in_HX_table (each fixed=false);
    
    // Cooler parameters
    parameter MedPB.ThermodynamicState[N_cooler] state_cooler(each p.fixed = false, each h.fixed = false, each h.start = 4.5 * 10 ^ 5);
    parameter SI.Power P_cool_des (fixed=false) "on-design power necessary to run the fans";
    parameter SI.HeatFlowRate Q_dis_cooler(fixed = false);
    parameter SolarTherm.Types.Conductance[N_cooler - 1] UA_cooler_dis(each fixed = false);
    
      //Financial analysis
    parameter FI.Money C_HTR (fixed=false) "cost of the high temperature heat recuperator";
    
    parameter FI.Money C_turbine (fixed=false) "cost of the turbine";
    parameter FI.Money C_compressor (fixed=false) "cost of the main compressor";
    
    parameter FI.Money C_exchanger (fixed=false) "cost of the exchanger";
    parameter FI.Money C_generator (fixed=false) "cost of the generator";
    parameter FI.Money C_cooler (fixed=false) "cost of the cooler";
    
    parameter FI.Money pri_exchanger = 150 "price of the primary exchanger in $/(kW_th). Objective for next-gen CSP with particles";
    
    
  initial equation
  //Part I. On-design=first point
  //Inlet of the turbine
    state_in_turb[1] = MedPB.setState_pTX(p_high, T_high);
    s_in_turb[1] = MedPB.specificEntropy(state_in_turb[1]);
    state_out_turb[1] = MedPB.setState_phX(p_low, state_in_turb[1].h + eta_turb * (MedPB.specificEnthalpy(MedPB.setState_psX(p_low, s_in_turb[1])) - state_in_turb[1].h));
    W_turb[1] = m_des * (state_out_turb[1].h - state_in_turb[1].h);
    
  //High temperature recuperator
    for k in 1:N_HTR - 1 loop
      Q_dis_HTR = state_HTR_turb[1, k + 1].h - state_HTR_turb[1, k].h;
      Q_dis_HTR = state_HTR_comp[1, k + 1].h - state_HTR_comp[1, k].h;
      deltaT_HTR[1, k] = MedPB.temperature(state_HTR_turb[1, k]) - MedPB.temperature(state_HTR_comp[1, k]);
      m_des * Q_dis_HTR = UA_HTR_dis[k] * (deltaT_HTR[1, k] + deltaT_HTR[1, k + 1]) / 2;
      state_HTR_comp[1, k + 1].p = p_high;
  //need to use setState when doing isentropic enthalpy
      state_HTR_turb[1, k].p = p_low;
    end for;
    
    deltaT_HTR[1, N_HTR] = MedPB.temperature(state_HTR_turb[1, N_HTR]) - MedPB.temperature(state_HTR_comp[1, N_HTR]);
    min(deltaT_HTR[1]) = pinchHTR;
    
    state_HTR_turb[1, N_HTR].p = p_low;
    state_HTR_turb[1, N_HTR].h = state_out_turb[1].h;
    state_cooler[1].h = state_HTR_turb[1, 1].h;
    
  //Cooler. UA (and therefore this part) are only for economical correlation
    for k in 1:N_cooler - 1 loop
      Q_dis_cooler = state_cooler[k + 1].h - state_cooler[k].h;
      m_des * Q_dis_cooler = -UA_cooler_dis[k] * (MedPB.temperature(state_cooler[k + 1]) - T_amb_des + MedPB.temperature(state_cooler[k]) - T_amb_des) / 2;
      state_cooler[k].p = p_low;
    end for;
    state_cooler[N_cooler] = state_cooler_out;
    state_cooler_out = MedPB.setState_pTX(p_low, T_low);
    P_cool_des * (T_low - T_amb_des)/(-m_des * Q_dis_cooler*(N_cooler-1))= 1.49*10^6*(35.7-30)/(136.6*10^6);
    
    
  //Main compressor. Inlet supposed always the same for off-design
    s_in_mainComp = MedPB.specificEntropy(state_cooler_out);
    state_HTR_comp[1, 1] = MedPB.setState_phX(p_high, state_cooler_out.h + (MedPB.specificEnthalpy(MedPB.setState_psX(p_high, s_in_mainComp)) - state_cooler_out.h)/eta_comp);
    W_comp = m_des * (state_HTR_comp[1, 1].h - state_cooler_out.h);
    state_comW_out=state_HTR_comp[1, 1]; //pour voir ce qu'il se passe
    
  //Exchanger. Done only on-design. After, only the TIT is varied.
    state_CO2_exch[N_exch].h = state_in_turb[1].h;
    state_CO2_exch[1].h = state_HTR_comp[1, N_HTR].h;
    state_HTF_exch[N_exch] = MedRec.setState_pTX(10 ^ 5, T_HTF_in_des);
    for k in 1:N_exch - 1 loop
      Q_dis_exch = state_CO2_exch[k + 1].h - state_CO2_exch[k].h;
      Q_dis_exch = state_HTF_exch[k + 1].h - state_HTF_exch[k].h;
      m_des * Q_dis_exch = UA_exch_dis[k] * (deltaT_exch[k] + deltaT_exch[k + 1]) / 2;
      deltaT_exch[k] = MedRec.temperature(state_HTF_exch[k]) - MedPB.temperature(state_CO2_exch[k]);
      state_CO2_exch[k].p = p_high;
      state_HTF_exch[k].p = 10 ^ 5;
    end for;
    deltaT_exch[N_exch] = MedRec.temperature(state_HTF_exch[N_exch]) - MedPB.temperature(state_CO2_exch[N_exch]);
    T_HTF_out_des = MedRec.temperature(state_HTF_exch[1]);
    state_CO2_exch[N_exch].p = p_high;
    P_nom = (-W_turb[1]) - W_comp;
    eta_cycle_on = P_nom / (m_des * Q_dis_exch * (N_exch - 1));
    
    //Part I.2. Financial analysis
    C_HTR= if MedPB.temperature(state_HTR_turb[1,N_exch])>=550+273.15 then 49.45*sum(UA_HTR_dis)^0.7544*(1+0.02141*(MedPB.temperature(state_HTR_turb[1,N_exch])-550-273.15)) else 49.45*sum(UA_HTR_dis)^0.7544;
    C_turbine= if T_high>= 550+273.15 then 406200*(-W_turb[1]/10^6)^0.8*(1+1.137*10^(-5)*(T_high-550-273.15)^2) else 406200*(-W_turb[1]/10^6)^0.8;
    C_compressor = 1230000*(W_comp/10^6)^0.3392;
    C_cooler = 32.88*sum(UA_cooler_dis)^0.75;
    C_generator = 108900*(P_nom/10^6)^0.5463;
    C_exchanger = pri_exchanger*m_des*Q_dis_exch * (N_exch - 1)/1000;
    C_PB=(C_HTR+C_turbine+C_compressor+C_generator+C_cooler+C_exchanger)*1.05;
    
  //Part II. Off-design points. Mass flow rate is kept constant
    for i in 2:N_points + 1 loop
  //    //Inlet of the turbine
      T_high_frac[i - 1] = (0.8 + (1.2 - 0.8) * (i - 1) / (N_points - 1)) * (T_high - 273.15) + 273.15;
      state_in_turb[i] = MedPB.setState_pTX(p_high, T_high_frac[i - 1]);
      s_in_turb[i] = MedPB.specificEntropy(state_in_turb[i]);
      state_out_turb[i] = MedPB.setState_phX(p_low, state_in_turb[i].h + eta_turb * (MedPB.specificEnthalpy(MedPB.setState_psX(p_low, s_in_turb[i])) - state_in_turb[i].h));
      state_HTR_turb[i, N_HTR] = state_out_turb[i];
      W_turb[i] = m_des * (state_out_turb[i].h - state_in_turb[i].h);
  //High temperature recuperator
      for k in 1:N_HTR - 1 loop
        state_HTR_turb[i, k + 1].h - state_HTR_turb[i, k].h = state_HTR_comp[i, k + 1].h - state_HTR_comp[i, k].h;
        deltaT_HTR[i, k] = MedPB.temperature(state_HTR_turb[i, k]) - MedPB.temperature(state_HTR_comp[i, k]);
        m_des * (state_HTR_turb[i, k + 1].h - state_HTR_turb[i, k].h) = UA_HTR_dis[k] * (deltaT_HTR[i, k] + deltaT_HTR[i, k + 1]) / 2;
        state_HTR_turb[i, k].p = p_low;
        state_HTR_comp[i, k + 1].p = p_high;
      end for;
      deltaT_HTR[i, N_HTR] = MedPB.temperature(state_HTR_turb[i, N_HTR]) - MedPB.temperature(state_HTR_comp[i, N_HTR]);
      T_CO2_in_HX_table[i-1]=MedPB.temperature(state_HTR_comp[i,N_HTR]);
  //   //Inlet of the HTR. Main Compressor always has the same inlet so no off-design
      state_HTR_comp[i, 1] = MedPB.setState_phX(p_high, state_cooler[N_cooler].h +  (MedPB.specificEnthalpy(MedPB.setState_psX(p_high, s_in_mainComp)) - state_cooler[N_cooler].h)/eta_comp);
      W_out[i - 1] = (-W_turb[i]) - W_comp;
      eta_cycle_off[i - 1] = W_out[i - 1] / (m_des * (state_in_turb[i].h - state_HTR_comp[i, N_HTR].h));
    end for;
  equation
    //Exchanger code
    m_sup=fluid_a.m_flow >=0.5*m_des;
    m_HTF_bis=if m_sup then fluid_a.m_flow else m_des;
    for k in 1:N_exch - 1 loop
      m_des * (state_CO2_HX[k + 1].h - state_CO2_HX[k].h) = m_HTF_bis * (state_HTF_HX[k + 1].h - state_HTF_HX[k].h);
      m_des * (state_CO2_HX[k + 1].h - state_CO2_HX[k].h) = UA_exch_dis[k] * (deltaT_HX[k] + deltaT_HX[k + 1]) / 2;
      deltaT_HX[k] = MedRec.temperature(state_HTF_HX[k]) - MedPB.temperature(state_CO2_HX[k]);
      state_HTF_HX[k].p = state_HTF_HX[k + 1].p;
      state_CO2_HX[k].p = state_CO2_HX[k + 1].p;
    end for;
    deltaT_HX[N_exch] = MedRec.temperature(state_HTF_HX[N_exch]) - MedPB.temperature(state_CO2_HX[N_exch]);
    state_HTF_HX[N_exch] = if m_sup then MedRec.setState_phX(fluid_a.p, inStream(fluid_a.h_outflow)) else state_HTF_exch[N_exch];
    //The TIT and T_CO2 at the inlet of the HX are interpolated from previous points
    T_HTF_in = MedRec.temperature(state_HTF_HX[N_exch]);
    T_HTF_out = MedRec.temperature(state_HTF_HX[1]);
    TIT_CO2 = MedPB.temperature(state_CO2_HX[N_exch]);
    T_CO2_in_HX = Modelica.Math.Vectors.interpolate(T_high_frac, T_CO2_in_HX_table, TIT_CO2);
    state_CO2_HX[1] = MedPB.setState_pTX(p_high, T_CO2_in_HX);
    // Power Block calculations
    P_cooling = P_cool_des * ((T_low-T_amb_des)/(max(T_amb + 5, T_low)-T_amb)) ^ (3 / 0.805); 
    W_net = if m_sup then max(0,Modelica.Math.Vectors.interpolate(T_high_frac, W_out, TIT_CO2)-P_cooling) else 0;
    
    //Connectors obligations
    fluid_b.p = fluid_a.p;
    fluid_a.m_flow + fluid_b.m_flow = 0;
    fluid_b.h_outflow = state_HTF_HX[1].h;
    fluid_a.h_outflow=0; //shouldn't flow back
    annotation(
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
      __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
  end interpolSimplePB;

  model correlRecompPB
    import SI = Modelica.SIunits;
    import CV = Modelica.SIunits.Conversions;
    extends SolarTherm.Media.CO2.PropCO2;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
    //Objective: having a few points in order to correlate. Should be feasible with for loops.
    parameter SI.Power P_nom = 100 * 10 ^ 6;
    parameter SI.AbsolutePressure p_high = CV.from_bar(250);
    parameter SI.AbsolutePressure p_low = CV.from_bar(80);
    parameter Real PR = p_high / p_low;
    parameter Real gamma = 0.28 "recompression fraction";
    parameter SI.ThermodynamicTemperature T_high = CV.from_degC(715) "inlet temperature of the turbine";
    parameter SI.ThermodynamicTemperature T_HTF_in = CV.from_degC(800) "inlet temperature of the HTF";
    parameter SI.ThermodynamicTemperature T_low = CV.from_degC(45) "Inlet temperature of the compressor";
    parameter SI.ThermodynamicTemperature T_amb_des = CV.from_degC(20) "ambient temperature at design";
    parameter SI.TemperatureDifference pinchHTR = 5;
    parameter SI.TemperatureDifference pinchLTR = 5;
    parameter SI.TemperatureDifference pinchExch = T_HTF_in - T_high;
    parameter SI.Efficiency eta_main_comp = 0.89;
    parameter SI.Efficiency eta_re_comp = 0.89;
    parameter SI.Efficiency eta_turb = 0.93;
    parameter Integer N_exch = 5;
    parameter Integer N_HTR = 15;
    parameter Integer N_LTR = 15;
    parameter Integer N_cooler = 15;
    parameter Integer N_points = 10;
    //parameter SI.ThermodynamicTemperature[N_points] T_high_frac (each fixed=false) "points for which efficiency will be calculated";
    //parameters to calculate
    // parameter SI.MassFlowRate m_des (fixed=false, start=P_nom/10^5) "mass flow rate at the outlet of the turbine";
    //parameter SI.Power[N_points] P_out (each fixed=false, each start=P_nom) "power at the outlet for off-design";
    //parameter SI.Efficiency eta_cycle (each fixed=false,each start=0.5) "efficiency of the cycle";
    //Inlet of the turbine
    parameter SI.SpecificEntropy s_in_turb(fixed = false, start = 2900) "inlet entropy to the turbine";
    parameter MedPB.ThermodynamicState state_in_turb(p.fixed = false, h.fixed = false);
    parameter SI.Power W_turb(each fixed = false);
    parameter MedPB.ThermodynamicState state_out_turb(p.fixed = false, h.fixed = false);
    //Main Compressor parameters
    parameter SI.SpecificEntropy s_in_mainComp(fixed = false, start = 1500) "inlet entropy to the main compressor";
    parameter SI.Power W_mainComp(fixed = false);
    //reCompressor parameters
    //  parameter SI.SpecificEntropy s_in_reComp (each fixed=false)"inlet entropy to the recompressor";
    //  parameter MedPB.ThermodynamicState state_out_reComp (each p=p_high, each h.fixed=false, each h.start=550000);
    //  parameter SI.Power W_reComp (each fixed=false);
    //Exchanger parameters. Calculated only at on-design
    parameter SolarTherm.Types.Conductance[N_exch - 1] UA_exch_dis(each fixed = false, each start = P_nom * 0.4 / N_exch);
    parameter SI.HeatFlowRate Q_dis_exch(fixed = false);
    parameter MedPB.ThermodynamicState[N_exch] state_CO2_exch(each p.fixed = false, each h.fixed = false, each h.start = 10 ^ 6);
    parameter MedRec.ThermodynamicState[N_exch] state_HTF_exch(each p.fixed = false, each h.fixed = false, each h.start = 6 * 10 ^ 5);
    parameter SI.TemperatureDifference[N_exch] deltaT_exch(each start = 20, each fixed = false);
    // HTR parameters
    parameter SolarTherm.Types.Conductance[N_HTR - 1] UA_HTR_dis(each fixed = false, each start = P_nom * 0.4 / N_HTR);
    parameter SI.HeatFlowRate Q_dis_HTR(fixed = false, start = 2 * 10 ^ 4);
    parameter MedPB.ThermodynamicState[N_HTR] state_HTR_turb(each p.fixed = false, each h.fixed = false, each h.start = 7 * 10 ^ 5);
    parameter MedPB.ThermodynamicState[N_HTR] state_HTR_comp(each p.fixed = false, each h.fixed = false, each h.start = 6 * 10 ^ 5);
    parameter SI.TemperatureDifference[N_HTR] deltaT_HTR(each start = 20, each fixed = false);
    //LTR parameters
    //  parameter SolarTherm.Types.Conductance[N_LTR-1] UA_LTR_dis (each fixed=false, each start=P_nom*0.4/N_HTR);
    //  parameter SI.HeatFlowRate Q_dis_LTR (fixed=false, start = 2*10^4);
    //  parameter SI.TemperatureDifference[N_LTR] deltaT_LTR (each start=20, each fixed=false);
    //  parameter MedPB.ThermodynamicState[N_LTR] state_LTR_turb (each p = p_low, each h.fixed=false, each h.start=6*10^5);
    //  parameter MedPB.ThermodynamicState[N_LTR] state_LTR_comp (each p = p_high, each h.fixed=false, each h.start=5*10^5);
    // Cooler parameters
    parameter MedPB.ThermodynamicState[N_cooler] state_cooler(each p.fixed = false, each h.fixed = false, each h.start = 4.5 * 10 ^ 5);
    parameter MedPB.ThermodynamicState state_cooler_out(p.fixed = false, h.fixed = false);
    parameter SI.HeatFlowRate Q_dis_cooler(fixed = false);
    parameter SolarTherm.Types.Conductance[N_cooler - 1] UA_cooler_dis(each fixed = false);
  initial equation
//Part I. On-design=first point
//Inlet of the turbine
    state_in_turb = MedPB.setState_pTX(p_high, T_high);
    s_in_turb = MedPB.specificEntropy(state_in_turb);
    state_out_turb = MedPB.setState_phX(p_low, state_in_turb.h + eta_turb * (MedPB.specificEnthalpy(MedPB.setState_psX(p_low, s_in_turb)) - state_in_turb.h));
    W_turb = state_out_turb.h - state_in_turb.h;
//High temperature recuperator
    for k in 1:N_HTR - 1 loop
      Q_dis_HTR = state_HTR_turb[k + 1].h - state_HTR_turb[k].h;
      Q_dis_HTR = state_HTR_comp[k + 1].h - state_HTR_comp[k].h;
      deltaT_HTR[k] = MedPB.temperature(state_HTR_turb[k]) - MedPB.temperature(state_HTR_comp[k]);
      Q_dis_HTR = UA_HTR_dis[k] * (deltaT_HTR[k] + deltaT_HTR[k + 1]) / 2;
      state_HTR_comp[k + 1].p = p_high;
//has to setState when doing isentropic enthalpy
      state_HTR_turb[k].p = p_low;
    end for;
    deltaT_HTR[N_HTR] = MedPB.temperature(state_HTR_turb[N_HTR]) - MedPB.temperature(state_HTR_comp[N_HTR]);
    min(deltaT_HTR) = pinchHTR;
    state_HTR_turb[N_HTR].p = p_low;
    state_HTR_turb[N_HTR].h = state_out_turb.h;
//state_LTR_turb[N_LTR].h=state_HTR_turb[1].h;
//Low temperature recuperator
//  for k in 1:(N_LTR-1) loop
//    Q_dis_LTR = state_LTR_turb[k+1].h-state_LTR_turb[k].h;
//    Q_dis_LTR = (1-gamma)*(state_LTR_comp[k+1].h-state_LTR_comp[k].h);
//    deltaT_LTR[k]=MedPB.temperature(state_LTR_turb[k])-MedPB.temperature(state_LTR_comp[k]);
//    m_des*Q_dis_LTR=UA_LTR_dis[k]*(deltaT_LTR[k]+deltaT_LTR[k+1])/2;
//   end for;
//   deltaT_LTR[N_LTR]=MedPB.temperature(state_LTR_turb[N_LTR])-MedPB.temperature(state_LTR_comp[N_LTR]);
//   min(deltaT_LTR)=pinchLTR;
    state_cooler[1].h = state_HTR_turb[1].h;
//Cooler. UA (and therefore this part) are only for economical correlation
    for k in 1:N_cooler - 1 loop
      Q_dis_cooler = state_cooler[k + 1].h - state_cooler[k].h;
      Q_dis_cooler = -UA_cooler_dis[k] * (MedPB.temperature(state_cooler[k + 1]) - T_amb_des + MedPB.temperature(state_cooler[k]) - T_amb_des) / 2;
      state_cooler[k].p = p_low;
    end for;
    state_cooler[N_cooler] = state_cooler_out;
    state_cooler_out = MedPB.setState_pTX(p_low, T_low);
//Main compressor. Inlet supposed always the same for off-design
    s_in_mainComp = MedPB.specificEntropy(state_cooler_out);
    state_HTR_comp[1] = MedPB.setState_phX(p_high, state_cooler_out.h + eta_main_comp * (MedPB.specificEnthalpy(MedPB.setState_psX(p_high, s_in_mainComp)) - state_cooler_out.h));
    W_mainComp = state_HTR_comp[1].h - state_cooler_out.h;
// ReCompression loop
//  s_in_reComp=MedPB.specificEntropy(state_LTR_turb[1]);
//  state_out_reComp.h=state_LTR_turb[1].h+eta_re_comp*(MedPB.specificEnthalpy(MedPB.setState_psX(p_high,s_in_reComp))-state_LTR_turb[1].h);
//  W_reComp = m_des*gamma*(state_out_reComp.h-state_LTR_turb[1].h);
//  state_HTR_comp[1].h=(1-gamma)*state_LTR_comp[N_LTR].h+gamma*state_out_reComp.h;
//Exchanger. Done only on-design. After, only the TIT is varied.
//Q_dis_exch*(N_exch-1)=state_CO2_exch[N_exch].h-state_CO2_exch[1].h;
    state_CO2_exch[N_exch].h = state_in_turb.h;
    state_CO2_exch[1].h = state_HTR_comp[N_HTR].h;
    state_HTF_exch[N_exch] = MedRec.setState_pTX(10 ^ 5, T_HTF_in);
    for k in 1:N_exch - 1 loop
      Q_dis_exch = state_CO2_exch[k + 1].h - state_CO2_exch[k].h;
      Q_dis_exch = state_HTF_exch[k + 1].h - state_HTF_exch[k].h;
      Q_dis_exch = UA_exch_dis[k] * (deltaT_exch[k] + deltaT_exch[k + 1]) / 2;
      deltaT_exch[k] = MedRec.temperature(state_HTF_exch[k]) - MedPB.temperature(state_CO2_exch[k]);
      state_CO2_exch[k].p = p_high;
      state_HTF_exch[k].p = 10 ^ 5;
    end for;
    deltaT_exch[N_exch] = MedRec.temperature(state_HTF_exch[N_exch]) - MedPB.temperature(state_CO2_exch[N_exch]);
    state_CO2_exch[N_exch].p = p_high;
// P_nom=(-W_turb)-W_mainComp;
//eta_cycle=P_nom/(m_des*Q_dis_exch*(N_exch-1));
//Part II. Off-design points. Mass flow rate is kept constant
//for i in 2:(N_points+1) loop
//    //Inlet of the turbine
//    T_high_frac[i-1]=(0.75+(1.25-0.75)*(i-1)/(N_points-1))*(T_high-273.15)+273.15;
//    state_in_turb[i].h = MedPB.specificEnthalpy(MedPB.setState_pTX(p_high,T_high_frac[i-1]));
//    s_in_turb[i]=MedPB.specificEntropy(state_in_turb[i]);
//    state_HTR_turb[i,N_HTR].h= state_in_turb[i].h+eta_turb*(MedPB.specificEnthalpy(MedPB.setState_psX(p_high,s_in_turb[i]))-state_in_turb[i].h);
//    W_turb[i]=m_des*(state_HTR_turb[i,N_HTR].h-state_in_turb[i].h);
//    //High temperature recuperator
//  for k in 1:(N_HTR-1) loop
//    state_HTR_turb[i,k+1].h-state_HTR_turb[i,k].h=state_HTR_comp[i,k+1].h-state_HTR_comp[i,k].h;
//    deltaT_HTR[i,k]=MedPB.temperature(state_HTR_turb[i,k])-MedPB.temperature(state_HTR_comp[i,k]);
//    m_des*(state_HTR_turb[i,k+1].h-state_HTR_turb[i,k].h)=UA_HTR_dis[k]*(deltaT_HTR[i,k]+deltaT_HTR[i,k+1])/2;
//   end for;
//   deltaT_HTR[i,N_HTR]=MedPB.temperature(state_HTR_turb[i,N_HTR])-MedPB.temperature(state_HTR_comp[i,N_HTR]);
//   state_LTR_turb[i,N_LTR].h=state_HTR_turb[i,1].h;
//   //Low-temperature recuperator
//    for k in 1:(N_LTR-1) loop
//     (1-gamma)*(state_LTR_comp[i,k+1].h-state_LTR_comp[i,k].h) = state_LTR_turb[i,k+1].h-state_LTR_turb[i,k].h;
//    deltaT_LTR[i,k]=MedPB.temperature(state_LTR_turb[i,k])-MedPB.temperature(state_LTR_comp[i,k]);
//    m_des*(state_LTR_turb[i,k+1].h-state_LTR_turb[i,k].h)=UA_LTR_dis[k]*(deltaT_LTR[i,k]+deltaT_LTR[i,k+1])/2;
//   end for;
//   deltaT_LTR[i,N_LTR]=MedPB.temperature(state_LTR_turb[i,N_LTR])-MedPB.temperature(state_LTR_comp[i,N_LTR]);
//   //Inlet of the LTR. Main Compressor always has the same inlet so no off-design
//   state_LTR_comp[i,1].h=state_cooler[N_cooler].h+eta_main_comp*(MedPB.specificEnthalpy(MedPB.setState_psX(p_high,s_in_mainComp))-state_cooler[N_cooler].h);
//   // ReCompression loop
//  s_in_reComp[i]=MedPB.specificEntropy(state_LTR_turb[i,1]);
//  state_out_reComp[i].h=state_LTR_turb[i,1].h+eta_re_comp*(MedPB.specificEnthalpy(MedPB.setState_psX(p_high,s_in_reComp[i]))-state_LTR_turb[i,1].h);
//  W_reComp[i] = m_des*gamma*(state_out_reComp[i].h-state_LTR_turb[i,1].h);
//  state_HTR_comp[i,1].h=(1-gamma)*state_LTR_comp[i,N_LTR].h+gamma*state_out_reComp[i].h;
//  P_out[i-1]=(-W_turb[i])-W_mainComp-W_reComp[i];
//  eta_cycle[i]=P_out[i-1]/(m_des*(state_in_turb[i].h-state_HTR_comp[i,N_LTR].h));
//end for;
    annotation(
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
      __OpenModelica_simulationFlags(lv = "LOG_INIT,LOG_LS_V,LOG_NLS,LOG_NLS_V,LOG_RES_INIT,LOG_STATS", outputFormat = "mat", s = "dassl"));
  end correlRecompPB;
end QuickCO2PB;