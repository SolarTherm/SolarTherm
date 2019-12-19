model test_HX_plus_Rec_wtank_2
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
  parameter SI.Temperature T_hot_set = CV.from_degC(740) "Hot Sodium target temperature";
  parameter SI.Temperature T_cold_set = Shell_and_Tube_HX.T_Na2_design "Cold Sodium target temperature";
  parameter Medium1.ThermodynamicState state_hot_set = Medium1.setState_pTX(Medium1.p_default, T_hot_set) "Hot sodium thermodynamic state at design";
  parameter Medium1.ThermodynamicState state_cold_set = Medium1.setState_pTX(Medium1.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  parameter SI.SpecificEnthalpy h_hot_set = Medium1.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_cold_set = Medium1.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";
  parameter SI.Power P_gross(fixed = if fixed_field then false else true) = 25e6 "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.3774 "Power block efficiency at design point";
  parameter SI.HeatFlowRate Q_flow_des = if fixed_field then R_des * (1 - rec_fr) / SM else P_gross / eff_blk "Heat to power block at design";
  parameter SI.MassFlowRate m_flow_fac = SM * Q_flow_des / (h_hot_set - h_cold_set) "Mass flow rate to receiver at design point";
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
  parameter SI.Temperature T_MS1_des = CV.from_degC(500);
  // ******************************************************************************************************************
  // System components
  //Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(origin = {-123, -23}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(extent = {{-138, 60}, {-118, 80}}, rotation = 0)));
  //Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(extent = {{144, 86}, {124, 106}}, rotation = 0)));
  //WindSpeed_input
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(visible = true, transformation(extent = {{-138, 20}, {-112, 40}}, rotation = 0)));
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(visible = true, transformation(extent = {{-98, 60}, {-78, 80}}, rotation = 0)));
  // Solar field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(n_h = n_heliostat, lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus, nu_start = nu_start, redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file)) annotation(
    Placement(visible = true, transformation(origin = {-87.8824, 21}, extent = {{-14.1176, -15}, {14.1176, 15}}, rotation = 0)));
  // Receiver
  SolarTherm.Models.CSP.CRS.Receivers.ReceiverSimple_2 receiver(em = em_rec, redeclare package Medium = Medium1, H_rcv = H_receiver, D_rcv = D_receiver, N_pa = N_pa_rec, t_tb = t_tb_rec, D_tb = D_tb_rec, ab = ab_rec, T_0 = Shell_and_Tube_HX.T_Na1_0, T_in_0 = Shell_and_Tube_HX.T_Na2_0) annotation(
    Placement(visible = true, transformation(origin = {-47, 23}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  // Temperature sensor
  SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium1) annotation(
    Placement(visible = true, transformation(extent = {{-34, 56}, {-24, 46}}, rotation = 0)));
  // Pump cold
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(redeclare package Medium = Medium1, k_loss = k_loss_cold) annotation(
    Placement(visible = true, transformation(extent = {{-18, 2}, {-30, 14}}, rotation = 0)));
  // ReceiverControl
  //Fake Tank Level Input
  //HX
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker(replaceable package Medium = Medium1) annotation(
    Placement(visible = true, transformation(origin = {-2, 8}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  SI.MassFlowRate m_flow_Na;
  SI.Temperature T_MS1;
  SolarTherm.Models.Fluid.HeatExchangers.HX_wi Shell_and_Tube_HX(Q_d_des = Q_flow_des * SM) annotation(
    Placement(visible = true, transformation(origin = {-3, 37}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  SolarTherm.Models.Storage.Tank.Tank tankCold(D = D_storage, H = H_storage, L_start = split_cold * 100, T_set = T_cold_aux_set, T_start = T_cold_start, W_max = W_heater_cold, alpha = alpha, enable_losses = tnk_enable_losses, use_L = true, use_p_top = tnk_use_p_top) annotation(
    Placement(visible = true, transformation(extent = {{64, 18}, {44, 38}}, rotation = 0)));
  SolarTherm.Models.Storage.Tank.Tank tankHot(D = D_storage, H = H_storage, L_start = (1 - split_cold) * 100, T_set = T_hot_aux_set, T_start = T_hot_start, W_max = W_heater_hot, alpha = alpha, enable_losses = tnk_enable_losses, use_L = true, use_p_top = tnk_use_p_top) annotation(
    Placement(visible = true, transformation(extent = {{42, 54}, {62, 74}}, rotation = 0)));
  SolarTherm.Models.Control.ReceiverControl receiverControl(Kp = Kp, L_df_off = cold_tnk_defocus_ub, L_df_on = cold_tnk_defocus_lb, L_off = cold_tnk_crit_lb, L_on = cold_tnk_crit_ub, T_ref = T_hot_set, Ti = Ti, m_flow_max = m_flow_rec_max, y_start = m_flow_rec_start) annotation(
    Placement(visible = true, transformation(extent = {{-18, -24}, {-32, -10}}, rotation = 0)));
  SolarTherm.Models.Control.ReceiverControl receiverControl1(Kp = Kp, L_df_off = cold_tnk_defocus_ub, L_df_on = cold_tnk_defocus_lb, L_off = cold_tnk_crit_lb, L_on = cold_tnk_crit_ub, T_ref = T_hot_set, Ti = Ti, m_flow_max = m_flow_rec_max, y_start = m_flow_rec_start) annotation(
    Placement(visible = true, transformation(origin = {13, 83}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple(k_loss = k_loss_cold) annotation(
    Placement(visible = true, transformation(extent = {{34, 14}, {22, 26}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sensors.Temperature temperature1 annotation(
    Placement(visible = true, transformation(extent = {{-2, 74}, {8, 64}}, rotation = 0)));
  SolarTherm.Models.Analysis.Market market annotation(
    Placement(visible = true, transformation(extent = {{136, 32}, {156, 52}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(k_loss = k_loss_hot) annotation(
    Placement(visible = true, transformation(origin = {84, 50}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  SolarTherm.Models.Control.PowerBlockControl controlHot(L_df_off = hot_tnk_full_lb, L_df_on = hot_tnk_full_ub, L_off = hot_tnk_empty_lb, L_on = hot_tnk_empty_ub, m_flow_on = m_flow_blk) annotation(
    Placement(visible = true, transformation(origin = {90, 9}, extent = {{-6, -7}, {6, 7}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.PowerBlockModel powerBlock(Q_flow_ref = Q_flow_des, T_des = blk_T_amb_des, T_in_ref = T_in_ref_blk, T_out_ref = T_out_ref_blk, W_base = W_base_blk, W_des = P_gross, enable_losses = blk_enable_losses, external_parasities = external_parasities, nu_min = nu_min_blk, nu_net = nu_net_blk, p_bo = p_blk) annotation(
    Placement(visible = true, transformation(extent = {{100, 24}, {136, 62}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {-115, 13}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or2 annotation(
    Placement(visible = true, transformation(origin = {-60, -26}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(visible = true, transformation(extent = {{148, 70}, {128, 90}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold.W_loss + tankHot.W_loss + tankCold.W_loss) annotation(
    Placement(visible = true, transformation(origin = {141, 62}, extent = {{13, -10}, {-13, 10}}, rotation = 0)));
initial equation
  if fixed_field then
    P_gross = Q_flow_des * eff_blk;
  else
    R_des = SM * Q_flow_des / (1 - rec_fr);
  end if;
equation
//Connections from data
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-117, 70}, {-99, 70}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-111, 30}, {-102, 30}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, receiver.Tamb) annotation(
    Line(points = {{123, 96}, {-47, 96}, {-47, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
// Fluid connections
  T_MS1 = T_MS1_des;
  MS_inlet.T_in = T_MS1;
  controlCold.m_flow = m_flow_Na;
  connect(receiver.fluid_b, temperature.fluid_a) annotation(
    Line(points = {{-41, 31}, {-41, 51}, {-34, 51}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_a, loop_breaker.port_b) annotation(
    Line(points = {{-18, 8}, {-8, 8}}, color = {0, 127, 255}));
// controlCold connections
  connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
    Line(points = {{-30, 8}, {-44, 8}}, color = {0, 127, 255}));
//Solar field connections i.e. solar.heat port and control
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-88, 60}, {-88, 36}}, color = {255, 128, 0}));
  connect(temperature.fluid_b, Shell_and_Tube_HX.port_a_in) annotation(
    Line(points = {{-24, 51}, {-16, 51}, {-16, 42}}, color = {0, 127, 255}));
  connect(heliostatsField.heat, receiver.heat) annotation(
    Line(points = {{-73, 28.5}, {-64, 28.5}, {-64, 28}}, color = {191, 0, 0}));
  connect(pumpSimple.fluid_b, Shell_and_Tube_HX.port_b_in) annotation(
    Line(points = {{22, 20}, {3, 20}, {3, 31}}, color = {0, 127, 255}));
  connect(pumpSimple.fluid_a, tankCold.fluid_b) annotation(
    Line(points = {{34, 20}, {44, 20}, {44, 21}}, color = {0, 127, 255}));
  connect(Shell_and_Tube_HX.port_b_out, temperature1.fluid_a) annotation(
    Line(points = {{-9, 46}, {-9, 69}, {-2, 69}}, color = {0, 127, 255}));
  connect(temperature1.fluid_b, tankHot.fluid_a) annotation(
    Line(points = {{8, 69}, {42, 69}}, color = {0, 127, 255}));
  connect(Shell_and_Tube_HX.port_a_out, loop_breaker.port_a) annotation(
    Line(points = {{10, 36}, {18, 36}, {18, 8}, {4, 8}}, color = {0, 127, 255}));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{127, 42}, {136, 42}}, color = {0, 0, 127}));
  connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{62, 57}, {71, 57}, {71, 50}, {78, 50}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{90, 50}, {100, 50}, {100, 49}, {110, 49}}, color = {0, 127, 255}));
  connect(tankCold.fluid_a, powerBlock.fluid_b) annotation(
    Line(points = {{64, 33}, {108, 33}, {108, 35}}, color = {0, 127, 255}));
  connect(receiverControl.m_flow, pumpCold.m_flow) annotation(
    Line(points = {{-33, -17}, {-36, -17}, {-36, 18}, {-24, 18}, {-24, 14}}, color = {0, 0, 127}));
  connect(tankCold.L, receiverControl.L_mea) annotation(
    Line(points = {{44, 32}, {38, 32}, {38, -16}, {-17, -16}, {-17, -17}}, color = {0, 0, 127}));
  connect(receiverControl.T_mea, temperature.T) annotation(
    Line(points = {{-17, -13}, {-12, -13}, {-12, 22}, {-29, 22}, {-29, 46}}, color = {0, 0, 127}));
  connect(Tamb_input.y, tankCold.T_amb) annotation(
    Line(points = {{123, 96}, {68, 96}, {68, 44}, {58, 44}, {58, 38}}, color = {0, 0, 127}));
  connect(receiverControl1.m_flow, pumpSimple.m_flow) annotation(
    Line(points = {{21, 83}, {28, 83}, {28, 26}}, color = {0, 0, 127}));
  connect(temperature1.T, receiverControl1.T_mea) annotation(
    Line(points = {{4, 64}, {4, 60}, {-22, 60}, {-22, 86}, {5, 86}, {5, 87}}, color = {0, 0, 127}));
  connect(tankCold.L, receiverControl1.L_mea) annotation(
    Line(points = {{44, 32}, {38, 32}, {38, 104}, {-12, 104}, {-12, 82}, {5, 82}, {5, 83}}, color = {0, 0, 127}));
  connect(heliostatsField.on, receiver.on) annotation(
    Line(points = {{-88, 6}, {-88, 6}, {-88, -14}, {-66, -14}, {-66, 8}, {-50, 8}, {-50, 8}}, color = {255, 0, 255}));
  connect(heliostatsField.on, receiverControl1.sf_on) annotation(
    Line(points = {{-88, 6}, {-88, -14}, {-66, -14}, {-66, 79}, {5, 79}}, color = {255, 0, 255}));
  connect(heliostatsField.on, receiverControl.sf_on) annotation(
    Line(points = {{-88, 6}, {-88, -32}, {4, -32}, {4, -21}, {-17, -21}}, color = {255, 0, 255}));
  connect(or1.y, heliostatsField.defocus) annotation(
    Line(points = {{-109, 13}, {-106, 13}, {-106, 12}, {-102, 12}}, color = {255, 0, 255}));
  connect(receiverControl.defocus, or2.u1) annotation(
    Line(points = {{-25, -25}, {-25, -26}, {-55, -26}}, color = {255, 0, 255}));
  connect(receiverControl1.defocus, or2.u2) annotation(
    Line(points = {{13, 75}, {14, 75}, {14, -29}, {-55, -29}}, color = {255, 0, 255}));
  connect(controlHot.m_flow, pumpHot.m_flow) annotation(
    Line(points = {{97, 9}, {102, 9}, {102, 62}, {84, 62}, {84, 56}}, color = {0, 0, 127}));
  connect(controlHot.defocus, or1.u1) annotation(
    Line(points = {{90, 1}, {90, -34}, {-110, -34}, {-110, -8}, {-132, -8}, {-132, 14}, {-122, 14}}, color = {255, 0, 255}));
  connect(or2.y, or1.u2) annotation(
    Line(points = {{-64, -26}, {-106, -26}, {-106, -2}, {-128, -2}, {-128, 10}, {-120, 10}, {-120, 8}, {-122, 8}}, color = {255, 0, 255}));
  connect(heliostatsField.on, Shell_and_Tube_HX.HF_on) annotation(
    Line(points = {{-88, 6}, {-88, 6}, {-88, -14}, {-66, -14}, {-66, 56}, {2, 56}, {2, 46}, {2, 46}}, color = {255, 0, 255}));
  connect(tankHot.L, controlHot.L_mea) annotation(
    Line(points = {{62, 68}, {72, 68}, {72, 5.5}, {84, 5.5}}, color = {0, 0, 127}));
  connect(receiverControl1.m_flow, controlHot.m_flow_in) annotation(
    Line(points = {{21, 83}, {74, 83}, {74, 12.5}, {84, 12.5}}, color = {0, 0, 127}));
  connect(Tamb_input.y, tankHot.T_amb) annotation(
    Line(points = {{123, 96}, {48, 96}, {48, 74}}, color = {0, 0, 127}));
  connect(Pres_input.y, tankHot.p_top) annotation(
    Line(points = {{127, 80}, {56, 80}, {56, 74}}, color = {0, 0, 127}));
  connect(Pres_input.y, tankCold.p_top) annotation(
    Line(points = {{127, 80}, {32, 80}, {32, 42}, {50, 42}, {50, 38}}, color = {0, 0, 127}));
  connect(Tamb_input.y, powerBlock.T_amb) annotation(
    Line(points = {{123, 96}, {114, 96}, {114, 54}}, color = {0, 0, 127}));
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{126, 62}, {122, 62}, {122, 54}, {122, 54}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(origin = {-18, 4}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 14, fontName = "CMU Serif"), Text(origin = {6, 2}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 14, fontName = "CMU Serif", horizontalAlignment = TextAlignment.Left), Text(origin = {-34, 8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 14, fontName = "CMU Serif"), Text(origin = {-42, -16}, extent = {{-6, 20}, {42, 0}}, textString = "Receiver Control", fontSize = 14, fontName = "CMU Serif"), Text(origin = {0, -2}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 14, fontName = "CMU Serif"), Text(origin = {-20, 16}, extent = {{-6, 20}, {42, 0}}, textString = "Heat Exchanger", fontSize = 14, fontName = "CMU Serif"), Text(origin = {28, 2}, extent = {{0, 58}, {48, 38}}, textString = "Hot Tank", fontSize = 14, fontName = "CMU Serif"), Text(origin = {20, -128}, lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 9), Text(origin = {0, 48}, extent = {{30, -24}, {78, -44}}, textString = "Cold Tank", fontSize = 14, fontName = "CMU Serif"), Text(origin = {-6, 84}, extent = {{-6, 20}, {42, 0}}, textString = "Storage Control", fontSize = 14, fontName = "CMU Serif"), Text(origin = {38, -56}, extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 14, fontName = "CMU Serif"), Text(origin = {14, 22}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 14, fontName = "CMU Serif"), Text(origin = {10, 22}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 14, fontName = "CMU Serif"), Text(origin = {-10, 116}, lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 9)}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released first version. </li>
	</ul>

	</html>"),
    uses(SolarTherm(version = "0.2"), Modelica(version = "3.2.2")));
end test_HX_plus_Rec_wtank_2;