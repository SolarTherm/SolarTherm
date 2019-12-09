model test_HX_plus_Rec_wtank2
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import SolarTherm.Types.Solar_angles;
  extends Modelica.Icons.Example;
  extends Modelica.Fluid.System;
  //Media
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  // Input Parameters
  parameter Boolean fixed_field = false "true if the size of the solar field is fixed";
  // Weather data
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";
  parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  // Field
  parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/example_optics.motab");
  parameter Solar_angles angles = Solar_angles.elo_hra "Angles used in the lookup table file";
  parameter Real SM = 1.8 "Solar multiple";
  parameter Real land_mult = 6.16783860571 "Land area multiplier";
  parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
  parameter SI.Area A_heliostat = 144.375 "Heliostat module reflective area";
  parameter Real he_av_design = 0.99 "Helisotats availability";
  parameter SI.Efficiency eff_opt = 0.6389 "Field optical efficiency at design point";
  parameter SI.Irradiance dni_des = 950 "DNI at design point";
  parameter Real C = 1046.460400794 "Concentration ratio";
  parameter Real gnd_cvge = 0.26648 "Ground coverage";
  parameter Real excl_fac = 0.97 "Exclusion factor";
  parameter Real twr_ht_const = if polar then 2.25 else 1.25 "Constant for tower height calculation";
  // Receiver
  parameter Integer N_pa_rec = 20 "Number of panels in receiver";
  parameter SI.Thickness t_tb_rec = 1.25e-3 "Receiver tube wall thickness";
  parameter SI.Diameter D_tb_rec = 40e-3 "Receiver tube outer diameter";
  parameter Real ar_rec = 18.67 / 15 "Height to diameter aspect ratio of receiver aperture";
  parameter SI.Efficiency ab_rec = 0.94 "Receiver coating absorptance";
  parameter SI.Efficiency em_rec = 0.88 "Receiver coating emissivity";
  parameter SI.RadiantPower R_des(fixed = if fixed_field then true else false) "Input power to receiver at design point";
  parameter Real rec_fr = 1.0 - 0.9569597659257708 "Receiver loss fraction of radiance at design point";
  parameter SI.Temperature rec_T_amb_des = 298.15 "Ambient temperature at design point";
  //Cold Pump
  parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold tank parasitic power coefficient";
  // Control
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
  parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
  parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
  parameter SI.HeatFlowRate Q_flow_defocus = 330 / 294.18 * Q_flow_des "Solar field thermal power at defocused state";
  // This only works if const_dispatch=true. TODO for variable disptach Q_flow_defocus should be turned into an input variable to match the field production rate to the dispatch rate to the power block.
  parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
  parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
  parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
  //Receiver Control Parameters
  //  parameter SI.Temperature T_hot_set = Shell_and_Tube_HX.T_Na1_des "Hot Sodium target temperature";
  //  parameter SI.Temperature T_cold_set = Shell_and_Tube_HX.T_Na2_design "Cold Sodium target temperature";
  parameter SI.Temperature T_hot_set = Shell_and_Tube_HX.T_Na1_des "Hot Sodium target temperature";
  parameter SI.Temperature T_cold_set = Shell_and_Tube_HX.T_Na2_design "Cold Sodium target temperature";
  parameter Medium1.ThermodynamicState state_hot_set = Medium1.setState_pTX(Medium1.p_default, T_hot_set) "Hot sodium thermodynamic state at design";
  parameter Medium1.ThermodynamicState state_cold_set = Medium1.setState_pTX(Medium1.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  parameter SI.SpecificEnthalpy h_hot_set = Medium1.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_cold_set = Medium1.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";
  parameter SI.Power P_gross(fixed = if fixed_field then false else true) = 25e6 "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.3774 "Power block efficiency at design point";
  parameter SI.HeatFlowRate Q_flow_des = if fixed_field then R_des * (1 - rec_fr) / SM else P_gross / eff_blk "Heat to power block at design";
  parameter SI.MassFlowRate m_flow_fac = SM * Q_flow_des / (h_hot_set - h_cold_set) "Mass flow rate to receiver at design point";
  //parameter SI.MassFlowRate m_flow_fac = Shell_and_Tube_HX.m_flow_Na_design "Mass flow rate to receiver at design point";
  parameter SI.MassFlowRate m_flow_rec_max = 1.13952693353 * m_flow_fac "Maximum mass flow rate to receiver";
  parameter SI.MassFlowRate m_flow_rec_start = 0.81394780966 * m_flow_fac "Initial or guess value of mass flow rate to receiver in the feedback controller";
  parameter Real L_fake = 50;
  parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real cold_tnk_crit_lb = 0 "Cold tank critically empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real Ti = 0.1 "Time constant for integral component of receiver control";
  parameter Real Kp = -1000 "Gain of proportional component in receiver control";
  // SF Calculated Parameters
  parameter SI.Area A_field = R_des / eff_opt / he_av_design / dni_des "Heliostat field reflective area";
  parameter Integer n_heliostat = integer(ceil(A_field / A_heliostat)) "Number of heliostats";
  parameter SI.Area A_receiver = A_field / C "Receiver aperture area";
  parameter SI.Diameter D_receiver = sqrt(A_receiver / (CN.pi * ar_rec)) "Receiver diameter";
  parameter SI.Length H_receiver = D_receiver * ar_rec "Receiver height";
  parameter SI.Area A_land = land_mult * A_field + 197434.207385281 "Land area";
  parameter SI.Length H_tower = 0.154 * sqrt(twr_ht_const * (A_field / (gnd_cvge * excl_fac)) / CN.pi) "Tower height";
  // A_field/(gnd_cvge*excl_fac) is the field gross area
  parameter SI.Diameter D_tower = D_receiver "Tower diameter";
  // That's a fair estimate. An accurate H-to-D correlation may be used.
  //HX
  parameter SI.Temperature T_MS1_des = Shell_and_Tube_HX.T_MS1_des;
  parameter SI.Temperature T_MS2_des = Shell_and_Tube_HX.T_MS2_des;
  parameter SI.Temperature T_Na1_0 = Shell_and_Tube_HX.T_Na1_des;
  parameter SI.Temperature T_Na2_0 = Shell_and_Tube_HX.T_Na2_design;
  // ******************************************************************************************************************
  // System components
  //Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(extent = {{-118, -54}, {-88, -26}}, rotation = 0)));
  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(extent = {{-104, 60}, {-84, 80}}, rotation = 0)));
  //Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(extent = {{70, 84}, {50, 104}}, rotation = 0)));
  //WindSpeed_input
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(visible = true, transformation(extent = {{-104, 20}, {-78, 40}}, rotation = 0)));
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(visible = true, transformation(extent = {{-46, 60}, {-26, 80}}, rotation = 0)));
  // Solar field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(n_h = n_heliostat, lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus, nu_start = nu_start, redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file)) annotation(
    Placement(visible = true, transformation(extent = {{-52, 2}, {-20, 36}}, rotation = 0)));
  // Receiver
  SolarTherm.Models.CSP.CRS.Receivers.SodiumReceiver receiver(em = em_rec, redeclare package Medium = Medium1, H_rcv = H_receiver, D_rcv = D_receiver, N_pa = N_pa_rec, t_tb = t_tb_rec, D_tb = D_tb_rec, ab = ab_rec, T_out_0 = T_Na1_0, T_in_0 = T_Na2_0) annotation(
    Placement(visible = true, transformation(extent = {{-10, 4}, {26, 40}}, rotation = 0)));
  // Temperature sensor
  SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium1) annotation(
    Placement(visible = true, transformation(extent = {{22, 76}, {32, 66}}, rotation = 0)));
  // Pump cold
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(redeclare package Medium = Medium1, k_loss = k_loss_cold) annotation(
    Placement(visible = true, transformation(extent = {{46, -30}, {34, -18}}, rotation = 0)));
  // ReceiverControl
  SolarTherm.Models.Control.ReceiverControl controlCold(T_ref = T_hot_set, m_flow_max = m_flow_rec_max, y_start = 17.1174, L_df_on = cold_tnk_defocus_lb, L_df_off = cold_tnk_defocus_ub, L_off = cold_tnk_crit_lb, L_on = cold_tnk_crit_ub, Ti = Ti, Kp = Kp) annotation(
    Placement(visible = true, transformation(extent = {{60, -10}, {46, 4}}, rotation = 0)));
  //Fake Tank Level Input
  Modelica.Blocks.Sources.RealExpression L_input(y = L_fake) annotation(
    Placement(visible = true, transformation(extent = {{150, -54}, {130, -34}}, rotation = 0)));
  //HX
  SolarTherm.Models.Fluid.HeatExchangers.HX_wi_noF Shell_and_Tube_HX(replaceable package Medium1 = Medium1, replaceable package Medium2 = Medium2, Q_d_des = Q_flow_des * SM) annotation(
    Placement(visible = true, transformation(origin = {69, 47}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  /*, Q_receiver=receiver.Q_rcv*/
  /*Q = receiver.Q_rcv*/
  SolarTherm.Models.Fluid.Sources.FluidSink MS_Sink(replaceable package Medium = Medium2) annotation(
    Placement(visible = true, transformation(origin = {150, 80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T MS_inlet(replaceable package Medium = Medium2, T(start = 700, nominal = 700), nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {145, 25}, extent = {{7, -7}, {-7, 7}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker(replaceable package Medium = Medium1) annotation(
    Placement(visible = true, transformation(origin = {100, -24}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SI.MassFlowRate m_flow_Na;
  SI.Temperature T_MS1;
initial equation
  if fixed_field then
    P_gross = Q_flow_des * eff_blk;
  else
    R_des = SM * Q_flow_des / (1 - rec_fr);
  end if;
equation
//Connections from data
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-83, 70}, {-47, 70}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-77, 30}, {-52, 30}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, receiver.Tamb) annotation(
    Line(points = {{49, 94}, {8, 94}, {8, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
// Fluid connections
  T_MS1 = T_MS1_des;
  MS_inlet.T_in = T_MS1;
  controlCold.m_flow = m_flow_Na;
  connect(receiver.fluid_b, temperature.fluid_a) annotation(
    Line(points = {{14, 31}, {14, 71}, {22, 71}}, color = {0, 127, 255}));
  connect(temperature.fluid_b, Shell_and_Tube_HX.port_a_in) annotation(
    Line(points = {{32, 71}, {56, 71}, {56, 52}}, color = {0, 127, 255}));
  connect(Shell_and_Tube_HX.port_b_out, MS_Sink.port_a) annotation(
    Line(points = {{62, 56}, {62, 80}, {142, 80}}, color = {0, 127, 255}));
  connect(Shell_and_Tube_HX.port_b_in, MS_inlet.ports[1]) annotation(
    Line(points = {{74, 42}, {74, 25}, {138, 25}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_a, loop_breaker.port_b) annotation(
    Line(points = {{46, -24}, {90, -24}, {90, -24}, {90, -24}}, color = {0, 127, 255}));
  connect(loop_breaker.port_a, Shell_and_Tube_HX.port_a_out) annotation(
    Line(points = {{110, -24}, {118, -24}, {118, 46}, {82, 46}, {82, 46}}, color = {0, 127, 255}));
// controlCold connections
  connect(L_input.y, controlCold.L_mea) annotation(
    Line(points = {{129, -44}, {79.5, -44}, {79.5, -3}, {61, -3}}, color = {0, 0, 127}));
  connect(controlCold.m_flow, pumpCold.m_flow) annotation(
    Line(points = {{45, -3}, {40, -3}, {40, -19}}, color = {0, 0, 127}));
  connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
    Line(points = {{34, -24}, {24, -24}, {24, 6}, {12, 6}, {12, 6}}, color = {0, 127, 255}));
  connect(controlCold.defocus, heliostatsField.defocus) annotation(
    Line(points = {{54, -10}, {54, -52}, {-52, -52}, {-52, 9}}, color = {255, 0, 255}));
  connect(controlCold.sf_on, receiver.on) annotation(
    Line(points = {{60, -8}, {72, -8}, {72, -44}, {-46, -44}, {-46, -26}, {-8, -26}, {-8, 6}, {4, 6}, {4, 6}}, color = {255, 0, 255}));
  connect(heliostatsField.on, controlCold.sf_on) annotation(
    Line(points = {{-36, 2}, {-36, -44}, {72, -44}, {72, -8}, {60, -8}}, color = {255, 0, 255}));
//Solar field connections i.e. solar.heat port and control
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-36, 60}, {-36, 36}}, color = {255, 128, 0}));
  connect(temperature.T, controlCold.T_mea) annotation(
    Line(points = {{28, 66}, {26, 66}, {26, 16}, {72, 16}, {72, 2}, {60, 2}, {60, 2}}, color = {0, 0, 127}));
  connect(heliostatsField.on, Shell_and_Tube_HX.HF_on) annotation(
    Line(points = {{-36, 2}, {-120, 2}, {-120, 120}, {74, 120}, {74, 56}}, color = {255, 0, 255}));
  connect(heliostatsField.heat, receiver.heat) annotation(
    Line(points = {{-20, 28}, {-10, 28}, {-10, 28}, {-10, 28}}, color = {191, 0, 0}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(origin = {36, 0}, lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 9), Text(origin = {36, 0}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 4, fontName = "CMU Serif"), Text(origin = {44, 0}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 4, fontName = "CMU Serif", horizontalAlignment = TextAlignment.Left), Text(origin = {20, 10}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 4, fontName = "CMU Serif"), Text(origin = {36, 0}, extent = {{-6, 20}, {42, 0}}, textString = "Receiver Control", fontSize = 4, fontName = "CMU Serif"), Text(origin = {20, -24}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 4, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released first version. </li>
	</ul>

	</html>"),
    uses(SolarTherm(version = "0.2"), Modelica(version = "3.2.2")));
end test_HX_plus_Rec_wtank2;