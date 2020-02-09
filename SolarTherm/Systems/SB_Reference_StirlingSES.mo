within SolarTherm.Systems;

model SB_Reference_StirlingSES
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Solar_angles;
  import SolarTherm.Types.Currency;
  extends Modelica.Icons.Example;
  // Input Parameters
  // *********************
  parameter Boolean match_sam = false "Configure to match SAM output";
  parameter Boolean fixed_field = false "true if the size of the solar field is fixed";
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_ph "Medium props for molten salt";
  parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  parameter Boolean const_dispatch = true "Constant dispatch of energy";
  parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not const_dispatch "Discharging schedule from a file";
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
  // Storage
  parameter Real t_storage(unit = "h") = 4 "Hours of storage";
  //parameter SI.Temperature T_cold_set = CV.from_degC(290) "Cold tank target temperature";
  //parameter SI.Temperature T_hot_set = CV.from_degC(574) "Hot tank target temperature";
  //parameter SI.Temperature T_cold_start = CV.from_degC(290) "Cold tank starting temperature";
  //parameter SI.Temperature T_hot_start = CV.from_degC(574) "Hot tank starting temperature";
  //parameter SI.Temperature T_cold_aux_set = CV.from_degC(280) "Cold tank auxiliary heater set-point temperature";
  //parameter SI.Temperature T_hot_aux_set = CV.from_degC(500) "Hot tank auxiliary heater set-point temperature";
  //parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  //parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold salt thermodynamic state at design";
  parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
  parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";
  parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
  parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
  parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
  parameter SI.CoefficientOfHeatTransfer alpha = 3 "Tank constant heat transfer coefficient with ambient";
  parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold pump parasitic power coefficient";
  parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot pump parasitic power coefficient";
  parameter SI.Power W_heater_hot = 30e8 "Hot tank heater capacity";
  parameter SI.Power W_heater_cold = 30e8 "Cold tank heater capacity";
  parameter Real tank_ar = 20 / 18.667 "storage aspect ratio";
  // Power block
  replaceable model Cycle = Models.PowerBlocks.Correlation.Rankine "Rankine cycle regression model";
  replaceable model Cooling = Models.PowerBlocks.Cooling.SAM "PB cooling model";
  parameter SI.Power P_gross(fixed = if fixed_field then false else true) = 1.11e6 "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.346 "Power block efficiency at design point";
  parameter Real par_fr = 0.099099099 "Parasitics fraction of power block rating at design point";
  parameter Real par_fix_fr = 0.0055 "Fixed parasitics as fraction of gross rating";
  parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";
  parameter Boolean external_parasities = true "true if there is external parasitic power losses";
  parameter Real nu_min_blk = 0.5 "minimum allowed part-load mass flow fraction to power block";
  parameter SI.Power W_base_blk = par_fix_fr * P_gross "Power consumed at all times in power block";
  parameter SI.AbsolutePressure p_blk = 10e6 "Power block operating pressure";
  parameter SI.Temperature blk_T_amb_des = 316.15 "Ambient temperature at design for power block";
  parameter SI.Temperature par_T_amb_des = 298.15 "Ambient temperature at design point";
  parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
  parameter SI.Temperature T_in_ref_blk = from_degC(574) "HTF inlet temperature to power block at design";
  parameter SI.Temperature T_out_ref_blk = from_degC(290) "HTF outlet temperature to power block at design";
  // Control
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
  parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
  parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
  parameter SI.HeatFlowRate Q_flow_defocus = 330 / 294.18 * Q_flow_des "Solar field thermal power at defocused state";
  // This only works if const_dispatch=true. TODO for variable disptach Q_flow_defocus should be turned into an input variable to match the field production rate to the dispatch rate to the power block.
  parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
  parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
  parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
  parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real hot_tnk_empty_ub = 10 "Hot tank empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real hot_tnk_full_lb = 123 "Hot tank full trigger lower bound";
  parameter Real hot_tnk_full_ub = 120 "Hot tank full trigger upper bound";
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
  // Calculated Parameters
  parameter SI.HeatFlowRate Q_flow_des = if fixed_field then if match_sam then R_des / ((1 + rec_fr) * SM) else R_des * (1 - rec_fr) / SM else P_gross / eff_blk "Heat to power block at design";
  parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
  parameter SI.Area A_field = R_des / eff_opt / he_av_design / dni_des "Heliostat field reflective area";
  parameter Integer n_heliostat = integer(ceil(A_field / A_heliostat)) "Number of heliostats";
  parameter SI.Area A_receiver = A_field / C "Receiver aperture area";
  parameter SI.Diameter D_receiver = sqrt(A_receiver / (CN.pi * ar_rec)) "Receiver diameter";
  parameter SI.Length H_receiver = D_receiver * ar_rec "Receiver height";
  parameter SI.Area A_land = land_mult * A_field + 197434.207385281 "Land area";
  //parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";
  //parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";
  //parameter SI.Density rho_cold_set = Medium.density(state_cold_set) "Cold salt density at design";
  //parameter SI.Density rho_hot_set = Medium.density(state_hot_set) "Hot salt density at design";
  //parameter SI.Mass m_max = E_max / (h_hot_set - h_cold_set) "Max salt mass in tanks";
  //parameter SI.Volume V_max = m_max / ((rho_hot_set + rho_cold_set) / 2) "Max salt volume in tanks";
  //parameter SI.MassFlowRate m_flow_fac = SM * Q_flow_des / (h_hot_set - h_cold_set) "Mass flow rate to receiver at design point";
  //parameter SI.MassFlowRate m_flow_rec_max = 1.13952693353 * m_flow_fac "Maximum mass flow rate to receiver";
  //parameter SI.MassFlowRate m_flow_rec_start = 0.81394780966 * m_flow_fac "Initial or guess value of mass flow rate to receiver in the feedback controller";
  //parameter SI.MassFlowRate m_flow_blk = Q_flow_des / (h_hot_set - h_cold_set) "Mass flow rate to power block at design point";
  parameter SI.Power P_net = (1 - par_fr) * P_gross "Power block net rating at design point";
  parameter SI.Power P_name = P_net "Nameplate rating of power block";
  //parameter SI.Length H_storage = ceil((4 * V_max * tank_ar ^ 2 / CN.pi) ^ (1 / 3)) "Storage tank height";
  //parameter SI.Diameter D_storage = H_storage / tank_ar "Storage tank diameter";
  parameter SI.Length H_tower = 0.154 * sqrt(twr_ht_const * (A_field / (gnd_cvge * excl_fac)) / CN.pi) "Tower height";
  // A_field/(gnd_cvge*excl_fac) is the field gross area
  parameter SI.Diameter D_tower = D_receiver "Tower diameter";
  // That's a fair estimate. An accurate H-to-D correlation may be used.
  // Cost data in USD (default) or AUD
  parameter Real r_disc = 0.07 "Real discount rate";
  parameter Real r_i = 0.03 "Inflation rate";
  parameter Integer t_life(unit = "year") = 27 "Lifetime of plant";
  parameter Integer t_cons(unit = "year") = 3 "Years of construction";
  parameter Real r_cur = 0.71 "The currency rate from AUD to USD";
  // Valid for 2019. See https://www.rba.gov.au/
  parameter Real f_Subs = 0 "Subsidies on initial investment costs";
  parameter FI.AreaPrice pri_field = if currency == Currency.USD then 180 else 180 / r_cur "Field cost per design aperture area";
  // SAM 2018 cost data: 177*(603.1/525.4) in USD. Note that (603.1/525.4) is CEPCI index from 2007 to 2018
  parameter FI.AreaPrice pri_site = if currency == Currency.USD then 20 else 20 / r_cur "Site improvements cost per area";
  // SAM 2018 cost data: 16
  parameter FI.EnergyPrice pri_storage = if currency == Currency.USD then 37 / (1e3 * 3600) else 37 / (1e3 * 3600) / r_cur "Storage cost per energy capacity";
  // SAM 2018 cost data: 22 / (1e3 * 3600)
  parameter FI.PowerPrice pri_block = if currency == Currency.USD then 1000 / 1e3 else 1000 / r_cur "Power block cost per gross rated power";
  // SAM 2018 cost data: 1040
  parameter FI.PowerPrice pri_bop = if currency == Currency.USD then 350 / 1e3 else 350 / 1e3 / r_cur "Balance of plant cost per gross rated power";
  //SAM 2018 cost data: 290
  parameter FI.AreaPrice pri_land = if currency == Currency.USD then 10000 / 4046.86 else 10000 / 4046.86 / r_cur "Land cost per area";
  parameter Real pri_om_name(unit = "$/W/year") = if currency == Currency.USD then 56.715 / 1e3 else 56.715 / 1e3 / r_cur "Fixed O&M cost per nameplate per year";
  //SAM 2018 cost data: 66
  parameter Real pri_om_prod(unit = "$/J/year") = if currency == Currency.USD then 5.7320752 / (1e6 * 3600) else 5.7320752 / (1e6 * 3600) / r_cur "Variable O&M cost per production per year";
  //SAM 2018 cost data: 3.5
  parameter FI.Money C_field = pri_field * A_field "Field cost";
  parameter FI.Money C_site = pri_site * A_field "Site improvements cost";
  parameter FI.Money C_tower(fixed = false) "Tower cost";
  parameter FI.Money C_receiver = if currency == Currency.USD then 71708855 * (A_receiver / 879.8) ^ 0.7 else 71708855 * (A_receiver / 879.8) ^ 0.7 / r_cur "Receiver cost";
  // SAM 2018 cost data: 103e6 * (A_receiver / 1571) ^ 0.7
  parameter FI.Money C_storage = pri_storage * E_max "Storage cost";
  parameter FI.Money C_block = pri_block * P_gross "Power block cost";
  parameter FI.Money C_bop = pri_bop * P_gross "Balance of plant cost";
  parameter FI.Money C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop) "Direct capital cost subtotal";
  // i.e. purchased equipment costs
  parameter FI.Money C_contingency = 0.07 * C_cap_dir_sub "Contingency costs";
  parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
  parameter FI.Money C_EPC = 0.11 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
  // SAM 2018 cost data: 0.13
  parameter FI.Money C_land = pri_land * A_land "Land cost";
  parameter FI.Money C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
  parameter FI.MoneyPerYear C_year = pri_om_name * P_name "Fixed O&M cost per year";
  parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Variable O&M cost per production per year";
  // System components
  // *********************
  //Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(extent = {{-132, -56}, {-102, -28}}, rotation = 0)));
  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(extent = {{-140, 60}, {-120, 80}}, rotation = 0)));
  //Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(transformation(extent = {{140, 70}, {120, 90}})));
  //WindSpeed_input
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(visible = true, transformation(extent = {{-140, 38}, {-114, 58}}, rotation = 0)));
  //pressure_input
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(visible = true, transformation(extent = {{138, 86}, {118, 106}}, rotation = 0)));
  //parasitic inputs
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold.W_loss) annotation(
    Placement(visible = true, transformation(origin = {109, 62}, extent = {{-13, -10}, {13, 10}}, rotation = -90)));
  // Or block for defocusing
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
  // Solar field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(n_h = n_heliostat, lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus, nu_start = nu_start, redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file)) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
  // Receiver
  // Hot tank
  // Pump hot
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium, k_loss = k_loss_hot) annotation(
    Placement(visible = true, transformation(origin = {66, 8}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  // Cold tank
  // Pump cold
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium, k_loss = k_loss_cold) annotation(
    Placement(visible = true, transformation(extent = {{0, 4}, {-12, 16}}, rotation = 0)));
  // Temperature sensor
  // PowerBlockControl
  // ReceiverControl
  // Power block
  // Price
  SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
    Placement(visible = true, transformation(origin = {148, 20}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  // TODO Needs to be configured in instantiation if not const_dispatch. See SimpleResistiveStorage model
  SolarTherm.Models.Sources.Schedule.Scheduler sch if not const_dispatch;
  // Variables:
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
  SolarTherm.Models.CSP.CRS.Receivers.SB_Receiver receiver(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-28, 24}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  SolarTherm.Models.Storage.PCM.DirectContact.SB_PCMStorage2 tankHot(N_tray = 400, T_max = 1118, T_min = 1028, T_start = 1028, U_loss_tank = 0.01, d_tank = 8, growth_ratio = 1.1, m_HTF_start = 5000, n = 10, z_PCM = 0.07, z_tank = 8, z_tray = 0.1) annotation(
    Placement(visible = true, transformation(origin = {30, 22}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-4, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {68, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.SB_ReceiverControl controlCold annotation(
    Placement(visible = true, transformation(origin = {-32, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.SB_PowerBlockControl controlHot(m_flow_ref = 1.2) annotation(
    Placement(visible = true, transformation(origin = {68, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.SB_StirlingPowerBlockModel powerBlock annotation(
    Placement(visible = true, transformation(origin = {103, 21}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
initial equation
  if fixed_field then
    P_gross = Q_flow_des * eff_cyc;
  else
    R_des = if match_sam then SM * Q_flow_des * (1 + rec_fr) else SM * Q_flow_des / (1 - rec_fr);
  end if;
  if H_tower > 120 then
// then use concrete tower
    C_tower = if currency == Currency.USD then 3117043.67 * exp(0.0113 * H_tower) else 3117043.67 * exp(0.0113 * H_tower) / r_cur "Tower cost";
//SAM 2018 cost data: 3e6 * exp(0.0113 * H_tower) in USD
  else
// use Latticework steel tower
    C_tower = if currency == Currency.USD then 1.09025e6 * exp(0.00879 * H_tower) else 1.09025e6 * exp(0.00879 * H_tower) / r_cur "Tower cost";
// SAM 2018 cost data: 1.09025e6 * (603.1/318.4) * exp(0.00879 * H_tower)
  end if;
equation
//Connections from data
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-119, 70}, {-83, 70}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-113, 48}, {-100.35, 48}, {-100.35, 30}, {-88, 30}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
// Fluid connections
// controlCold connections
// controlHot connections
//Solar field connections i.e. solar.heat port and control
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-72, 60}, {-72, 36}}, color = {255, 128, 0}));
//PowerBlock connections
  P_elec = powerBlock.W_net;
  E_elec = powerBlock.E_net;
  R_spot = market.profit;
  connect(heliostatsField.heat, receiver.heat) annotation(
    Line(points = {{-56, 27.5}, {-44, 27.5}, {-44, 29}}, color = {191, 0, 0}));
  connect(tankHot.fluid_br, pumpCold.fluid_a) annotation(
    Line(points = {{12, 9}, {6, 9}, {6, 10}, {0, 10}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
    Line(points = {{-12, 10}, {-25, 10}}, color = {0, 127, 255}));
  connect(receiver.fluid_b, loop_breaker1.port_a) annotation(
    Line(points = {{-23, 32}, {-14, 32}}, color = {0, 127, 255}));
  connect(loop_breaker1.port_b, tankHot.fluid_ar) annotation(
    Line(points = {{6, 32}, {9, 32}, {9, 31}, {12, 31}}, color = {0, 127, 255}));
  connect(controlCold.defocus, heliostatsField.defocus) annotation(
    Line(points = {{-44, -26}, {-44, -36}, {-94, -36}, {-94, 8}, {-88, 8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(receiver.Q_recv_in, controlCold.Q_recv_in) annotation(
    Line(points = {{-24, 24}, {-18, 24}, {-18, -14}, {-21, -14}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(tankHot.T_storage, controlCold.T_stor) annotation(
    Line(points = {{30, 2}, {14, 2}, {14, -26}, {-22, -26}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(tankHot.T_storage, controlHot.T_stor) annotation(
    Line(points = {{30, 2}, {46, 2}, {46, -26}, {57, -26}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(pumpHot.fluid_b, tankHot.fluid_ap) annotation(
    Line(points = {{60, 8}, {50, 8}, {50, 10}, {48, 10}}, color = {0, 127, 255}));
  connect(tankHot.fluid_bp, loop_breaker2.port_a) annotation(
    Line(points = {{48, 32}, {58, 32}}, color = {0, 127, 255}));
  connect(controlHot.m_flow_PB, pumpHot.m_flow) annotation(
    Line(points = {{80, -26}, {84, -26}, {84, 20}, {66, 20}, {66, 14}, {66, 14}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(controlCold.m_flow_recv, pumpCold.m_flow) annotation(
    Line(points = {{-42, -14}, {-48, -14}, {-48, -6}, {-14, -6}, {-14, 24}, {-6, 24}, {-6, 16}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{109, 48}, {109, 38}}, color = {0, 0, 127}));
  connect(powerBlock.T_amb, Tamb_input.y) annotation(
    Line(points = {{97, 38}, {97, 80}, {120, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(loop_breaker2.port_b, powerBlock.fluid_a) annotation(
    Line(points = {{78, 32}, {90, 32}, {90, 31}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_a, powerBlock.fluid_b) annotation(
    Line(points = {{72, 8}, {86, 8}}));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{118, 20}, {134, 20}, {134, 20}, {136, 20}}, color = {0, 0, 127}));
  connect(Tamb_input.y, receiver.Tamb) annotation(
    Line(points = {{120, 80}, {-25, 80}, {-25, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Wspd_input.y, receiver.Wspd) annotation(
    Line(points = {{-113, 48}, {-32, 48}, {-32, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tamb_input.y, tankHot.T_amb) annotation(
    Line(points = {{120, 80}, {22, 80}, {22, 40}, {22, 40}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(origin = {2, 2}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, -8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"), Text(origin = {6, -2}, extent = {{0, 58}, {48, 38}}, textString = "Hot Tank", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-2, -10}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"), Text(origin = {14, 0}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"), Text(origin = {8, -26}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released first version. </li>
	</ul>

	</html>"));
end SB_Reference_StirlingSES;