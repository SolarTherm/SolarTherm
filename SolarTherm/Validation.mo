within SolarTherm;

package Validation
  model sCO2PBTestRig
    import SolarTherm.{Models,Media};
    import SI = Modelica.SIunits;
    import nSI = Modelica.SIunits.Conversions.NonSIunits;
    import Modelica.Constants.*;
    import Modelica.SIunits.Conversions.*;
    import FI = SolarTherm.Models.Analysis.Finances;
    import SolarTherm.Types.Solar_angles;
    import SolarTherm.Types.Currency;
    import Modelica.Math;
    extends SolarTherm.Media.CO2.PropCO2;
    extends Modelica.Icons.Example;
    // Input Parameters
    // *********************
    parameter Boolean match_sam = false "Configure to match SAM output";
    parameter Boolean fixed_field = false "true if the size of the solar field is fixed";
    //	replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
    replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Chloride Salt";
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph "Medium props for sCO2";
    parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
    parameter Currency currency = Currency.USD "Currency used for cost analysis";
    parameter Boolean const_dispatch = true "Constant dispatch of energy";
    parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not const_dispatch "Discharging schedule from a file";
    // Weather data
    parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/gen3p3_Daggett_TMY3.motab");
    parameter Real wdelay[8] = {1800, 1800, 0, 0, 0, 0, 0, 0} "Weather file delays";
    parameter nSI.Angle_deg lon = -116.800 "Longitude (+ve East)";
    parameter nSI.Angle_deg lat = 34.850 "Latitude (+ve North)";
    parameter nSI.Time_hour t_zone = -8 "Local time zone (UCT=0)";
    parameter Integer year = 1996 "Meteorological year";
    // Field
    parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/g3p3_opt_eff_1_azim_sud.motab");
    parameter Solar_angles angles = Solar_angles.ele_azi "Angles used in the lookup table file";
    parameter Real SM = 1.0 "Solar multiple";
    parameter Real land_mult = 6.16783860571 "Land area multiplier";
    parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
    parameter SI.Area A_heliostat = 100 "Heliostat module reflective area";
    parameter Real he_av_design = 0.99 "Helisotats availability";
    parameter SI.Efficiency eff_opt = 0.6389 "Field optical efficiency at design point";
    parameter SI.Irradiance dni_des = 950 "DNI at design point";
    parameter Real C = 1046.460400794 "Concentration ratio";
    parameter Real gnd_cvge = 0.3126 "Ground coverage";
    parameter Real excl_fac = 0.97 "Exclusion factor";
    parameter Real twr_ht_const = if polar then 2.25 else 1.25 "Constant for tower height calculation";
    parameter SI.Temperature T_out_CO2_des = from_degC(700);
    // Receiver
    parameter Integer N_pa_rec = 20 "Number of panels in receiver";
    parameter SI.Thickness t_tb_rec = 1.25e-3 "Receiver tube wall thickness";
    parameter SI.Diameter D_tb_rec = 40e-3 "Receiver tube outer diameter";
    parameter Real ar_rec = 1 "Height to diameter aspect ratio of receiver aperture";
    parameter SI.Efficiency ab_rec = 0.94 "Receiver coating absorptance";
    parameter SI.Efficiency em_rec = 0.86 "Receiver coating emissivity";
    parameter SI.RadiantPower R_des(fixed = if fixed_field then true else false) "Input power to receiver at design point";
    parameter Real rec_fr = 1.0 - 0.9569597659257708 "Receiver loss fraction of radiance at design point";
    parameter SI.Temperature rec_T_amb_des = from_degC(25) "Ambient temperature at design point";
    parameter Real f_loss = 0.000001 "Fraction of particles flow lost in receiver";
    parameter Real gamma = 0.221;
    // Storage
    parameter Real t_storage(unit = "h") = 14 "Hours of storage";
    parameter SI.Temperature T_cold_start = T_cold_set "Cold tank starting temperature";
    parameter SI.Temperature T_hot_start = from_degC(735) "Hot tank starting temperature";
    parameter SI.Temperature T_cold_aux_set = from_degC(500) "Cold tank auxiliary heater set-point temperature";
    parameter SI.Temperature T_hot_aux_set = from_degC(715) "Hot tank auxiliary heater set-point temperature";
    parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold partilces thermodynamic state at design";
    parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hot partilces thermodynamic state at design";
    parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
    parameter SI.Temperature tnk_T_amb_des = from_degC(25) "Ambient temperature at design point";
    parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
    parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
    parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
    parameter SI.CoefficientOfHeatTransfer alpha = 3 "Tank constant heat transfer coefficient with ambient";
    parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Hot tank parasitic power coefficient";
    parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot tank parasitic power coefficient";
    parameter SI.Power W_heater_hot = 30e8 "Hot tank heater capacity";
    parameter SI.Power W_heater_cold = 30e8 "Cold tank heater capacity";
    parameter Real tank_ar = 20 / 18.667 "storage aspect ratio";
    // Control
    parameter SI.Angle ele_min = from_deg(8) "Heliostat stow deploy angle";
    parameter Boolean use_wind = true "True if using wind stopping strategy in the solar field";
    parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
    parameter SI.HeatFlowRate Q_flow_defocus = if match_sam then Q_flow_des * (1 + rec_fr) else Q_flow_des / (1 - rec_fr) "Solar field thermal power at defocused state";
    parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
    parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
    parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
    parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound";
    // Level (below which) to stop disptach
    parameter Real hot_tnk_empty_ub = 50 "Hot tank empty trigger upper bound";
    // Level (above which) to start disptach
    parameter Real hot_tnk_full_lb = 93 "Hot tank full trigger lower bound";
    parameter Real hot_tnk_full_ub = 95 "Hot tank full trigger upper bound";
    parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound";
    // Level (below which) to stop disptach
    parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound";
    // Level (above which) to start disptach
    parameter Real cold_tnk_crit_lb = 1 "Cold tank critically empty trigger lower bound";
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
    parameter SI.Length D_receiver = sqrt(A_receiver / (pi * ar_rec)) "Receiver diameter";
    parameter SI.Length H_receiver = D_receiver * ar_rec "Receiver aperture height";
    parameter SI.Area A_land = land_mult * A_field + 197434.207385281 "Land area";
    parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold particles specific enthalpy at design";
    parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot particles specific enthalpy at design";
    parameter SI.Density rho_cold_set = Medium.density(state_cold_set) "Cold particles density at design";
    parameter SI.Density rho_hot_set = Medium.density(state_hot_set) "Hot particles density at design";
    parameter SI.Mass m_max = E_max / (h_hot_set - h_cold_set) "Max particles mass in tanks";
    parameter SI.Volume V_max = m_max / ((rho_hot_set + rho_cold_set) / 2) "Max particles volume in tanks";
    parameter SI.MassFlowRate m_flow_fac = SM * Q_flow_des / (h_hot_set - h_cold_set) "Mass flow rate to receiver at design point";
    parameter SI.MassFlowRate m_flow_rec_max = 1.3 * m_flow_fac "Maximum mass flow rate to receiver";
    //1.13952693353*m_flow_fac
    parameter SI.MassFlowRate m_flow_rec_start = 0.8 * m_flow_fac "Initial or guess value of mass flow rate to receiver in the feedback controller";
    //0.81394780966*m_flow_fac
    parameter SI.MassFlowRate m_flow_blk = Q_flow_des / (h_hot_set - h_cold_set) "Mass flow rate to power block at design point";
    parameter SI.Power P_name = P_net "Nameplate rating of power block";
    parameter SI.Length H_storage = ceil((4 * V_max * tank_ar ^ 2 / pi) ^ (1 / 3)) "Storage tank height";
    parameter SI.Diameter D_storage = H_storage / tank_ar "Storage tank diameter";
    parameter SI.Length H_tower = 0.154 * sqrt(twr_ht_const * (A_field / (gnd_cvge * excl_fac)) / pi) "Tower height";
    // A_field/(gnd_cvge*excl_fac) is the field gross area
    parameter SI.Diameter D_tower = D_receiver "Tower diameter";
    // That's a fair estimate. An accurate H-to-D correlation may be used.
    // Cost data in USD (default) or AUD
    parameter Real r_disc = 0.0439 "Real discount rate";
    parameter Real r_i = 0.025 "Inflation rate";
    parameter Integer t_life(unit = "year") = 30 "Lifetime of plant";
    parameter Integer t_cons(unit = "year") = 2 "Years of construction";
    parameter Real r_cur = 0.71 "The currency rate from AUD to USD";
    // Valid for 2019. See https://www.rba.gov.au/
    parameter Real f_Subs = 0 "Subsidies on initial investment costs";
    parameter Real r_contg = 0.1 "Contingency rate";
    parameter Real r_indirect = 0.13 "Indirect capital costs rate";
    parameter Real r_cons = 0.06 "Construction cost rate";
    parameter FI.AreaPrice pri_field = if currency == Currency.USD then 180 else 180 / r_cur "Field cost per design aperture area";
    parameter FI.AreaPrice pri_site = if currency == Currency.USD then 20 else 20 / r_cur "Site improvements cost per area";
    parameter FI.AreaPrice pri_land = if currency == Currency.USD then 10000 / 4046.86 else 10000 / 4046.86 / r_cur "Land cost per area";
    parameter FI.EnergyPrice pri_storage = if currency == Currency.USD then 37 / (1e3 * 3600) else 37 / (1e3 * 3600) / r_cur "Storage cost per energy capacity";
    parameter FI.PowerPrice pri_block = if currency == Currency.USD then 1000 / 1e3 else 1000 / r_cur "Power block cost per gross rated power";
    parameter FI.PowerPrice pri_bop = if currency == Currency.USD then 350 / 1e3 else 350 / 1e3 / r_cur "Balance of plant cost per gross rated power";
    parameter Real pri_om_name(unit = "$/W/year") = if currency == Currency.USD then 40 / 1e3 else 40 / 1e3 / r_cur "Fixed O&M cost per nameplate per year";
    parameter Real pri_om_prod(unit = "$/J/year") = if currency == Currency.USD then 3.5 * 0 / (1e6 * 3600) else 3.5 * 0 / (1e6 * 3600) / r_cur "Variable O&M cost per production per year";
    // Based on downselection criteria
    parameter FI.Money pri_tower = if currency == Currency.USD then 157.44 else 157.44 / r_cur "Fixed tower cost";
    parameter Real idx_pri_tower = 1.9174 "Tower cost scaling index";
    parameter FI.AreaPrice pri_receiver = if currency == Currency.USD then 37400 else 37400 / r_cur "Falling particle receiver cost per design aperture area";
    parameter FI.PowerPrice pri_hx = if currency == Currency.USD then 175.90 / 1e3 else 175.90 / 1e3 / r_cur "Heat exchnager cost per energy capacity";
    parameter FI.Money C_field = A_field * pri_field "Field cost";
    parameter FI.Money C_site = A_field * pri_site "Site improvements cost";
    parameter FI.Money C_tower = pri_tower * H_tower ^ idx_pri_tower "Tower cost";
    parameter FI.Money C_receiver = if currency == Currency.USD then 71708855 * (A_receiver / 879.8) ^ 0.7 else 71708855 * (A_receiver / 879.8) ^ 0.7 / r_cur "Receiver cost";
    parameter FI.Money C_storage = pri_storage * E_max "Storage cost";
    parameter FI.Money C_block(fixed = false) "Power block cost";
    // TODO Check sCO2 power block model to check PB cost equation
    parameter FI.Money C_bop = P_gross * pri_bop "Balance of plant cost";
    parameter FI.Money C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop) "Direct capital cost subtotal";
    parameter FI.Money C_contingency = 0.07 * C_cap_dir_sub "Contingency costs";
    parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
    parameter FI.Money C_EPC = 0.11 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
    parameter FI.Money C_land = A_land * pri_land "Land cost";
    parameter FI.Money C_cap(fixed = false) "Capital costs";
    parameter FI.MoneyPerYear C_year = P_name * pri_om_name "Fixed O&M cost per year";
    parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Variable O&M cost per production per year";
    // System components
    // *********************
    //Weather data
    //DNI_input
    //Tamb_input
    //WindSpeed_input
    //pressure_input
    //parasitic inputs
    Modelica.Blocks.Sources.RealExpression parasities_input(y = 0) annotation(
      Placement(visible = true, transformation(origin = {73, 44}, extent = {{-15, -12}, {15, 12}}, rotation = 180)));
    // Or block for defocusing
    //Sun
    // Solar field
    // Receiver
    // Hot tank
    // Cold tank
    // Receiver lift
    // Pump Hot
    SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium, k_loss = k_loss_hot) annotation(
      Placement(visible = true, transformation(origin = {24, 2}, extent = {{0, 0}, {12, 12}}, rotation = 0)));
    // Temperature sensor
    // PowerBlockControl
    // ReceiverControl
    // Power block
    // Price
    SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
      Placement(visible = true, transformation(extent = {{88, -28}, {108, -8}}, rotation = 0)));
    SolarTherm.Models.Sources.Schedule.Scheduler sch if not const_dispatch;
    // Variables:
    SI.Power P_elec "Output power of power block";
    SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
    FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Power block design parameter
    parameter SI.Temperature T_comp_in = from_degC(45) "Compressor inlet temperature at design";
    parameter SI.Efficiency eff_blk = 0.502 "Power block efficiency at design point";
    parameter Real par_fr = 0.1 "Parasitics fraction of power block rating at design point";
    parameter Boolean external_parasities = false "True if there is external parasitic power losses";
    parameter Real nu_min_blk = 0.5 "Minimum allowed part-load mass flow fraction to power block";
    parameter SI.Temperature blk_T_amb_des = from_degC(43) "Ambient temperature at design for power block";
    parameter SI.Temperature par_T_amb_des = 298.15 "Ambient temperature at design point";
    parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
    parameter SI.Temperature T_cold_set = from_degC(550) "Cold tank target temperature";
    parameter SI.Temperature T_hot_set = from_degC(735) "Particle inlet temperature from particle heat exchanger at design";
    parameter Real PR = 25 / 9.17;
    parameter SI.AbsolutePressure p_high_des = 250 * 10 ^ 5;
    parameter SI.ThermodynamicTemperature T_low = 45 + 273.15;
    parameter Real f_fixed_load = 0.0055;
    parameter SI.Power P_net = 100e6 "Power block gross rating at design point";
    parameter SI.Power P_gross = P_net / (1 - par_fr) "Power block net rating at design point";
    //Input operation parameter
    parameter SI.Temperature T_amb_input = from_degC(23);
    parameter SI.Temperature T_HTF_in = from_degC(550);
    parameter SI.MassFlowRate m_HTF_in = 1000;
    //Components instanciation
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.recompPB powerBlock(redeclare package MedRec = Medium, redeclare package MedPB = MedPB, E_net(displayUnit = ""), N_LTR = 15, N_exch = 5, PR = PR, P_gro = P_gross, P_nom = P_net, T_HTF_in_des = T_hot_set, T_amb_des = blk_T_amb_des, T_low = T_comp_in, external_parasities = false, f_fixed_load = f_fixed_load, nu_min = nu_min_blk, test_mode = true) annotation(
      Placement(visible = true, transformation(extent = {{36, -36}, {72, 2}}, rotation = 0)));
    SolarTherm.Models.Fluid.Sources.FluidSink fluidSink(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {-33, -25}, extent = {{19, -19}, {-19, 19}}, rotation = 0)));
    Modelica.Fluid.Sources.Boundary_pT boundary(redeclare package Medium = Medium, nPorts = 1, p = 101325, use_T_in = true) annotation(
      Placement(visible = true, transformation(origin = {-38, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression Tamb(y = T_amb_input) annotation(
      Placement(visible = true, transformation(origin = {-37, 59}, extent = {{-15, -13}, {15, 13}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression T_in(y = T_HTF_in) annotation(
      Placement(visible = true, transformation(origin = {-112, 12}, extent = {{-46, -14}, {46, 14}}, rotation = 0)));
    Modelica.Blocks.Sources.BooleanExpression always_true(y = false) annotation(
      Placement(visible = true, transformation(origin = {-44, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression m_flow_in(y = m_HTF_in) annotation(
      Placement(visible = true, transformation(origin = {75, 83}, extent = {{22, 11}, {-22, -11}}, rotation = 0)));
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  initial equation
    R_des = if match_sam then SM * Q_flow_des * (1 + rec_fr) else SM * Q_flow_des / (1 - rec_fr);
    C_block = powerBlock.C_PB;
    C_cap = (C_field + C_site + C_receiver + C_storage + C_block + C_bop) * (1 + r_contg) * (1 + r_indirect) * (1 + r_cons) + C_land;
  equation
    connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
      Line(points = {{36, 8}, {36, -11}, {46, -11}}, color = {0, 127, 255}));
    connect(parasities_input.y, powerBlock.parasities) annotation(
      Line(points = {{56.5, 44}, {56.5, 19}, {58, 19}, {58, -6}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(powerBlock.W_net, market.W_net) annotation(
      Line(points = {{63, -18}, {88, -18}}, color = {0, 0, 127}));
    P_elec = powerBlock.W_net;
    der(E_elec) = P_elec;
    R_spot = market.profit;
    connect(m_flow_in.y, pumpHot.m_flow) annotation(
      Line(points = {{51, 83}, {30, 83}, {30, 13}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(powerBlock.fluid_b, fluidSink.port_a) annotation(
      Line(points = {{44, -25}, {20, -25}, {20, -23}, {-14, -23}}, color = {0, 127, 255}));
    connect(boundary.ports[1], pumpHot.fluid_a) annotation(
      Line(points = {{-28, 8}, {24, 8}}, color = {0, 127, 255}));
    connect(T_in.y, boundary.T_in) annotation(
      Line(points = {{-61, 12}, {-50, 12}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(Tamb.y, powerBlock.T_amb) annotation(
      Line(points = {{-20.5, 59}, {50, 59}, {50, -6}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
/*connect(always_true.y, powerBlock.ramping) annotation(
      Line(points = {{18, 82}, {104, 82}, {104, 36}, {104, 36}}, color = {255, 0, 255}, pattern = LinePattern.Dot));*/
    connect(always_true.y, powerBlock.ramping) annotation(
      Line(points = {{-33, 40}, {54, 40}, {54, -6}}, color = {255, 0, 255}));
    annotation(
      Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1)),
      Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
      experiment(StopTime = 300, StartTime = 0, Tolerance = 0.0001, Interval = 1),
      __Dymola_experimentSetupOutput,
      Documentation(info = "<html>
  	<p>
  		<b>SaltSCO2System</b> models the system-level interactions of a two-tank CSP system using Chloride Salt.
  	</p>
  	</html>", revisions = "<html>
  	<ul>
  		<li><i>Jun 2019</i> by Ali Shirazi and <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
  		Created.</li>
  		<li><i>Jan 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
  		Integration of the sCO2 power block modelica model developed by Simon Kamerling at INES (Institut National de l’Énergie Solaire) in France.</li>
  	</ul>
  	</html>"),
      __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
      uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")));
  end sCO2PBTestRig;

  model test_hopper
    extends SolarTherm.Icons.ToDo;
    import SolarTherm.{Models,Media};
    import Modelica.SIunits.Conversions.from_degC;
    import SI = Modelica.SIunits;
    import nSI = Modelica.SIunits.Conversions.NonSIunits;
    import CN = Modelica.Constants;
    import CV = Modelica.SIunits.Conversions;
    import FI = SolarTherm.Models.Analysis.Finances;
    import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
    import Modelica.Math;
    import Modelica.Blocks;
    replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
    // Design Condition
    parameter SI.MassFlowRate m_in_fixed = 1000;
    parameter Real T_out_design = from_degC(800);
    parameter Real T_in_design = from_degC(580.3);
    parameter Real T_amb_design = from_degC(10);
    parameter Real L_start = 55;
    parameter Real L_hopper_lower_bound = 50;
    parameter Real L_hopper_upper_bound = 95;
    parameter SI.MassFlowRate m_flow_fac = 5000;
    parameter SI.Time t_sk = 1800;
    parameter SI.Time pouring_time = 5;
    SI.Mass m_in_hopper;
    SI.Mass m_out_hopper;
    Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_in_design, nPorts = 1, p = 1e5, use_T = true, use_p = false) annotation(
      Placement(visible = true, transformation(origin = {60, -14}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Medium, T = 300.0, d = 3300, nPorts = 1, p = 1e5, use_T = true) annotation(
      Placement(visible = true, transformation(extent = {{48, 50}, {28, 70}}, rotation = 0)));
    SolarTherm.Models.Fluid.Pumps.LiftSimple liftSimple(m_flow_fixed = m_in_fixed, use_input = true) annotation(
      Placement(visible = true, transformation(origin = {22, -16}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    SolarTherm.Models.Storage.Tank.Hopper hopper(T_out_design = T_out_design, L_start = L_start, L_hopper_lower_bound = L_hopper_lower_bound) annotation(
      Placement(visible = true, transformation(origin = {-31, 13}, extent = {{-19, -19}, {19, 19}}, rotation = 90)));
    Modelica.Blocks.Sources.RealExpression T_amb(y = T_amb_design) annotation(
      Placement(visible = true, transformation(origin = {-126, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression Q_inc(y = 300e6) annotation(
      Placement(visible = true, transformation(origin = {-126, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.BooleanExpression Operation(y = true) annotation(
      Placement(visible = true, transformation(origin = {-158, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression L_cold_tank_level(y = 70) annotation(
      Placement(visible = true, transformation(origin = {96, -60}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
    SolarTherm.Models.Control.PulseController pulseController(m_flow_fac = m_flow_fac, t_sk = t_sk, pouring_time = pouring_time) annotation(
      Placement(visible = true, transformation(origin = {62, 18}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  equation
    der(m_in_hopper) = pulseController.mass_flow_batch;
    der(m_out_hopper) = -hopper.fluid_b.m_flow;
/*connect(Operation.y, receiver.on) H_drop
  		annotation(
  		Line(points = {{-69, -4}, {-39.5, -4}, {-39.5, 5}, {-25, 5}}, color = {255, 0, 255}));*/
    connect(source.ports[1], liftSimple.fluid_a) annotation(
      Line(points = {{50, -14}, {27, -14}}, color = {0, 127, 255}));
    connect(liftSimple.fluid_b, hopper.fluid_a) annotation(
      Line(points = {{16, -14}, {-40, -14}, {-40, -6}, {-40, -6}}, color = {0, 127, 255}));
    connect(hopper.fluid_b, sink.ports[1]) annotation(
      Line(points = {{-18, 32}, {28, 32}, {28, 60}, {28, 60}}, color = {0, 127, 255}));
    connect(Q_inc.y, hopper.Q_inc) annotation(
      Line(points = {{-114, 26}, {-50, 26}, {-50, 28}, {-50, 28}}, color = {0, 0, 127}));
    connect(T_amb.y, hopper.T_amb) annotation(
      Line(points = {{-114, -2}, {-50, -2}, {-50, -2}, {-50, -2}}, color = {0, 0, 127}));
    connect(Operation.y, hopper.field_operation) annotation(
      Line(points = {{-146, 12}, {-48, 12}, {-48, 12}, {-50, 12}}, color = {255, 0, 255}));
    connect(pulseController.mass_flow_batch, liftSimple.m_flow) annotation(
      Line(points = {{50, 18}, {26, 18}, {26, -4}, {24, -4}}, color = {0, 0, 127}));
    connect(pulseController.L_mea_hopper, hopper.L_hopper_mea) annotation(
      Line(points = {{74, 20}, {94, 20}, {94, 88}, {-36, 88}, {-36, 36}, {-36, 36}}, color = {0, 0, 127}));
    connect(L_cold_tank_level.y, pulseController.L_mea_tank) annotation(
      Line(points = {{96, -48}, {96, -48}, {96, 16}, {74, 16}, {74, 16}}, color = {0, 0, 127}));
  protected
    annotation(
      uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")),
      experiment(StartTime = 0, StopTime = 108000, Tolerance = 1e-06, Interval = 10),
      __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
      Diagram);
  end test_hopper;

  model test_bucket
    extends SolarTherm.Icons.ToDo;
    import Modelica.SIunits.Conversions.*;
    import CN = Modelica.Constants;
    import SI = Modelica.SIunits;
    replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
    //Particle's properties
    parameter Real packing_factor = 0.7;
    parameter SI.Density rho_particle = 3300;
    parameter SI.Temperature T_particle_start = from_degC(580.3);
    //Hopper dimension
    parameter Real L_start = 55;
    parameter SI.Length D_hopper = 24;
    parameter SI.Length H_hopper = 24;
    parameter SI.Mass m_hopper_max = 0.25 * CN.pi * D_hopper ^ 2 * H_hopper * packing_factor * rho_particle;
    parameter SI.Mass m_flow_rec_des = 2500;
    //Bucket dimension
    parameter Real on_level_bucket = 50;
    parameter SI.Time traveling_time = 600;
    parameter SI.Mass m_bucket_max = (1 - on_level_bucket / 100) * m_hopper_max / 2;
    SolarTherm.Models.Storage.Tank.Hopper hopper(L_start = L_start, H_hopper = H_hopper, D_hopper = D_hopper, packing_factor = packing_factor, rho_particle = rho_particle, m_flow_max = m_flow_rec_des, T_Hopper_start = T_particle_start) annotation(
      Placement(visible = true, transformation(origin = {-82, 16}, extent = {{-22, -22}, {22, 22}}, rotation = 90)));
    Modelica.Blocks.Sources.RealExpression Q_inc(y = 500e6) annotation(
      Placement(visible = true, transformation(origin = {-154, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.BooleanExpression Operation(y = true) annotation(
      Placement(visible = true, transformation(origin = {-186, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression T_amb(y = from_degC(25)) annotation(
      Placement(visible = true, transformation(origin = {-154, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_particle_start, nPorts = 1, p = 1e5, use_T = true, use_p = false) annotation(
      Placement(visible = true, transformation(origin = {104, -48}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Medium, T = from_degC(25), d = 3300, nPorts = 1, p = 1e5, use_T = true) annotation(
      Placement(visible = true, transformation(extent = {{48, 50}, {28, 70}}, rotation = 0)));
    SolarTherm.Models.Fluid.Pumps.DoubleBucketModel doubleBucketModel(packing_factor = packing_factor, rho_particle = rho_particle, on_level = on_level_bucket, traveling_time = traveling_time, m_bucket_max = m_bucket_max, T_particle_start = T_particle_start) annotation(
      Placement(visible = true, transformation(origin = {0, -46}, extent = {{-32, -32}, {32, 32}}, rotation = 0)));
  equation
    connect(T_amb.y, hopper.T_amb) annotation(
      Line(points = {{-142, 6}, {-126, 6}, {-126, -4}, {-104, -4}, {-104, -2}}, color = {0, 0, 127}));
    connect(Operation.y, hopper.field_operation) annotation(
      Line(points = {{-174, 20}, {-106, 20}, {-106, 16}, {-104, 16}}, color = {255, 0, 255}));
    connect(Q_inc.y, hopper.Q_inc) annotation(
      Line(points = {{-142, 34}, {-106, 34}, {-106, 32}, {-104, 32}}, color = {0, 0, 127}));
    connect(hopper.fluid_b, sink.ports[1]) annotation(
      Line(points = {{-66, 38}, {-68, 38}, {-68, 60}, {28, 60}, {28, 60}}, color = {0, 127, 255}));
/* SolarTherm.Models.Fluid.Pumps.SingleBucketModel singleBucketModel(packing_factor = packing_factor, rho_particle = rho_particle, on_level = on_level_bucket, traveling_time = traveling_time, m_bucket_max = m_bucket_max) annotation(
      Placement(visible = true, transformation(origin = {-3, -43}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));*/
    connect(hopper.fluid_a, doubleBucketModel.fluid_b) annotation(
      Line(points = {{-92, -6}, {-94, -6}, {-94, -44}, {-12, -44}, {-12, -42}}, color = {0, 127, 255}));
    connect(source.ports[1], doubleBucketModel.fluid_a) annotation(
      Line(points = {{94, -48}, {12, -48}, {12, -42}, {10, -42}}, color = {0, 127, 255}));
    connect(hopper.L_hopper_mea, doubleBucketModel.level_hopper) annotation(
      Line(points = {{-88, 42}, {-88, 42}, {-88, 78}, {8, 78}, {8, -22}, {6, -22}}, color = {0, 0, 127}));
    connect(T_amb.y, doubleBucketModel.T_amb) annotation(
      Line(points = {{-142, 6}, {-4, 6}, {-4, -20}, {-8, -20}, {-8, -22}}, color = {0, 0, 127}));
    annotation(
      experiment(StartTime = 0, StopTime = 50000, Tolerance = 1e-06, Interval = 50));
  end test_bucket;

  //  SolarTherm.Models.Fluid.Pumps.SingleBucketModel singleBucketModel(packing_factor = packing_factor, rho_particle = rho_particle, on_level = on_level_bucket, traveling_time = traveling_time, m_bucket_max = m_bucket_max)
  //  SolarTherm.Models.Fluid.Pumps.SingleBucketModel singleBucketModel(packing_factor = packing_factor, rho_particle = rho_particle, on_level = on_level_bucket, traveling_time = traveling_time, m_bucket_max = m_bucket_max)

  model TestInterpolation
    import SI = Modelica.SIunits;
    import Util = SolarTherm.Media.CO2.CO2_utilities;
    parameter String ppath = "/home/philgun/solartherm-particle/SolarTherm/Resources/Include/Interpolation";
    parameter String pname = "interpolate_T_P_h";
    parameter String pfunc = "interpolate";
    parameter Integer argc = 2;
    parameter SI.Pressure p = 6232919.0847;
    parameter SI.SpecificEnthalpy h = 317030.849;
    SI.Temperature T;
  equation
    T = Util.T_p_h_new(ppath, pname, pfunc, argc, {h, p});
    annotation(
      experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.002));
  end TestInterpolation;

  model PBComponentTestRig
    extends SolarTherm.Icons.ToDo;
    import SolarTherm.{Models,Media};
    import Modelica.SIunits.Conversions.from_degC;
    import SI = Modelica.SIunits;
    import nSI = Modelica.SIunits.Conversions.NonSIunits;
    import CN = Modelica.Constants;
    import Modelica.SIunits.Conversions.*;
    import Modelica.Math;
    import Modelica.Blocks;
    import stprops = SolarTherm.Media.CO2.CO2_utilities.stprops;
    import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
    replaceable package Medium = SolarTherm.Media.CarbonDioxide_ph;
    //GENERAL PARAMETERS
    parameter String fluid = "CO2";
    parameter SI.Temperature T_amb_des = from_degC(45) "ambient temperature at design point";
    parameter SI.Efficiency eta_cycle_des_guess = 0.5;
    parameter SI.Efficiency eta_cycle_des(fixed = false);
    parameter SI.Power W_net_des = 100e6 "Net power output of the cycle";
    //CYCLE DESIGN PARAMETERS - Turbine and Compressor
    parameter SI.Power P_gross = 111.1111e6 "gross power output of the turbine";
    parameter SI.Efficiency par_fr = 0.1;
    parameter SI.Power P_net_des = P_gross * (1 - par_fr);
    parameter SI.Temperature T_hot_set = from_degC(715) "Turbine inlet temperature at design point";
    parameter SI.Pressure p_hot_set = 24e6 "Turbine inlet pressure at design";
    parameter Real PR = 3;
    parameter SI.Pressure p_cold_set = p_hot_set / PR "Turbine outlet pressure at design";
    parameter SI.Efficiency eta_design_compressor = 0.89 "compressor isentropic efficiency at design point";
    parameter SI.Efficiency eta_design_turbine = 0.91 "compressor isentropic efficiency at design point";
    parameter SI.MassFlowRate m_flow_des(fixed = false) "mass flow of the PB medium";
    //CYCLE DESIGN PARAMETERS - Heat exchanger
    parameter SI.HeatFlowRate Q_flow_des = P_gross / eta_cycle_des_guess "Heat that must be supplied to the cycle to produce power";
    parameter SI.Temperature T_hot_tank = from_degC(800) "temperature of the hot tank at design point";
    parameter SI.Temperature T_cold_tank = from_degC(580) "temperature of the cold tank at design point";
    parameter SI.MassFlowRate m_flow_HTF_des = Q_flow_des / (Util.h_T(T_hot_tank) - Util.h_T(T_cold_tank)) "mass flow rate of the HTF at design point entering the HX";
    parameter SI.Pressure p_in_medium_des = p_hot_set "inlet pressure of the PB medium to the HX at design pooint = compressor output pressure at design point";
    //CYCLE DESIGN PARAMETERS - Cooler
    parameter SI.Temperature delta_T_out_des = 10 "Temerature difference of T ambient and T medium at the outlet of the cooler at design point";
    parameter SI.Temperature T_cold_set = T_amb_des + delta_T_out_des "Temperature of the medium at the putlet of the cooler at design point";
    //VARIABLES
    SI.Power W_net "Net pwoer output of the cycle";
    //CONNECTIONS
    SolarTherm.Validation.Compressor compressor(eta_design = eta_design_compressor, p_in_des = p_cold_set, p_out_des = p_hot_set, T_in_des = T_cold_set, m_flow_des = m_flow_des, redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {-114, 0}, extent = {{-36, -36}, {36, 36}}, rotation = 0)));
    SolarTherm.Validation.Turbine turbine(eta_design = eta_design_turbine, p_in_des = p_hot_set, p_out_des = p_cold_set, redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {127, 1}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression T_amb(y = from_degC(45)) annotation(
      Placement(visible = true, transformation(origin = {-67, 162}, extent = {{-29, -10}, {29, 10}}, rotation = 0)));
    SolarTherm.Validation.Cooler cooler(P_gross = P_gross, m_flow_des = m_flow_des, delta_T_out_des = delta_T_out_des) annotation(
      Placement(visible = true, transformation(origin = {200, 84}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
    SolarTherm.Validation.HeatExchanger heatExchanger(Q_flow_des = Q_flow_des, T_out_medium_des = T_hot_set, T_hot_tank = T_hot_tank, T_cold_tank = T_cold_tank, m_flow_medium_des = m_flow_des) annotation(
      Placement(visible = true, transformation(origin = {20, -56}, extent = {{-35, 35}, {35, -35}}, rotation = 0)));
    Modelica.Fluid.Sources.FixedBoundary boundary(nPorts = 1, use_T = true, redeclare package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph, T = T_hot_tank) annotation(
      Placement(visible = true, transformation(origin = {160, -98}, extent = {{18, -18}, {-18, 18}}, rotation = 0)));
    SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure1 annotation(
      Placement(visible = true, transformation(origin = {80, -98}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    SolarTherm.Models.Fluid.Sources.FluidSink fluidSink annotation(
      Placement(visible = true, transformation(origin = {-89, -95}, extent = {{21, -21}, {-21, 21}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression realExpression(y = m_flow_HTF_des) annotation(
      Placement(visible = true, transformation(origin = {116, -56}, extent = {{30, -20}, {-30, 20}}, rotation = 0)));
  initial equation
//MASS FLOW EQUALITIES
    m_flow_des = turbine.m_flow_des;
//TEMPERATURE EQUALITIES
    turbine.T_out_des = cooler.T_in_des;
    cooler.T_out_des_comp = compressor.T_in_des;
//SYSTEM PERFORMANCE AT DESIGN POINT
    W_net_des = turbine.W_turb_des + compressor.W_comp_des + cooler.P_fan_cooler_des;
    eta_cycle_des = W_net_des / Q_flow_des;
  equation
    W_net = turbine.W_turb + compressor.W_comp;
//CONNECTIONS
    connect(T_amb.y, cooler.T_amb) annotation(
      Line(points = {{-35, 162}, {44, 162}, {44, 88}, {177, 88}}, color = {0, 0, 127}));
    connect(boundary.ports[1], pumpSimple_EqualPressure1.fluid_a) annotation(
      Line(points = {{142, -98}, {90, -98}}, color = {0, 127, 255}));
    connect(pumpSimple_EqualPressure1.fluid_b, heatExchanger.HTF_port_a) annotation(
      Line(points = {{70, -98}, {44.5, -98}, {44.5, -70}}, color = {0, 127, 255}));
    connect(fluidSink.port_a, heatExchanger.HTF_port_b) annotation(
      Line(points = {{-68, -93}, {-4.5, -93}, {-4.5, -70}}, color = {0, 127, 255}));
    connect(realExpression.y, pumpSimple_EqualPressure1.m_flow) annotation(
      Line(points = {{83, -56}, {80, -56}, {80, -90}}, color = {0, 0, 127}));
    connect(cooler.port_b, compressor.port_a) annotation(
      Line(points = {{200, 105}, {200, 130}, {-136, 130}, {-136, 7}}, color = {0, 127, 255}));
    connect(heatExchanger.medium_port_b, turbine.port_a) annotation(
      Line(points = {{44, -48}, {62, -48}, {62, 8}, {108, 8}, {108, 8}}, color = {0, 127, 255}));
    connect(compressor.port_b, heatExchanger.medium_port_a) annotation(
      Line(points = {{-92, -14}, {-34, -14}, {-34, -48}, {-6, -48}, {-6, -48}}, color = {0, 127, 255}));
    connect(turbine.port_b, cooler.port_a) annotation(
      Line(points = {{146, -12}, {200, -12}, {200, 64}, {200, 64}}, color = {0, 127, 255}));
  protected
    annotation(
      Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1)),
      Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
      experiment(StopTime = 1, StartTime = 0, Tolerance = 0.0001, Interval = 1),
      __Dymola_experimentSetupOutput,
      Documentation(info = "<html>
  	<p>
  		<b>TestSCO2PB</b> models the CO2 turbine.
  	</p>
  	</html>", revisions = "<html>
  	<ul>		
  		<li><i>Mar 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
  		First release.</li>
  	</ul>
  	</html>"),
      __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
      uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")));
  end PBComponentTestRig;

  model Compressor
    import Modelica.SIunits.Conversions.*;
    import SI = Modelica.SIunits;
    import Util = SolarTherm.Media.CO2.CO2_utilities;
    import Modelica.SIunits.Conversions.*;
    replaceable package Medium = SolarTherm.Media.CarbonDioxide_ph;
    parameter String fluid = "CO2" "Turbine working fluid (default: CO2)";
    //DESIGN PARAMETER
    parameter SI.AngularVelocity N_design = 40000 * 0.104 "Design rotational speed in rad/s";
    parameter SI.Efficiency eta_design = 0.89 "isentropic efficiency at design point";
    parameter Real phi_des = 0.0297035 "optimal adimensionned mass flow";
    parameter Real psi_des(fixed = false) "non-dimensional head at the design point";
    parameter Real PR = 3 "pressure ratio at design point";
    parameter SI.MassFlowRate m_flow_des = 1000 "mass flow rate of the medium at design point";
    parameter SI.Power W_comp_des(fixed = false) "power consumption of the compressor at design point";
    parameter SI.Length d_rotor_des(fixed = false) "rotor's diameter at design point";
    parameter SI.AngularVelocity tip_speed_des(fixed = false);
    //DESIGN PARAMETER -- outlet
    parameter SI.Pressure p_out_des = 25e6 "Output pressure at design point";
    parameter SI.SpecificEnthalpy h_out_des(fixed = false) "Enthalpy outlet at design point";
    parameter SI.SpecificEnthalpy h_out_isen_des(fixed = false);
    parameter SI.Temperature T_out_des(fixed = false);
    //DESIGN PARAMETER -- inlet
    parameter SI.Pressure p_in_des = p_out_des / PR "Inlet pressure at design point";
    parameter SI.Temperature T_in_des(fixed = false, start = from_degC(300)) "Inlet temperature at design point";
    parameter SI.SpecificEnthalpy h_in_des(fixed = false, start = Util.stprops("H", "P", p_in_des, "T", from_degC(150), fluid)) "Enthalpy inlet at design point";
    parameter SI.SpecificEntropy s_in_des(fixed = false);
    parameter SI.Density rho_in_des(fixed = false);
    //DYNAMIC VARIABLES
    SI.Efficiency eta(start = eta_design) "isentropic efficiency";
    Real phi(start = phi_des) "adimensionned mass flow";
    Real psi(start = psi_des);
    SI.Power W_comp "power consumption of the compressor";
    //DYNAMIC VARIABLES -- outlet
    SI.Pressure p_out(start = p_out_des) "Output pressure at design point";
    SI.SpecificEnthalpy h_out "Enthalpy outlet at design point";
    SI.SpecificEnthalpy h_out_isen;
    SI.Temperature T_out;
    //DYNAMIC VARIABLES -- inlet
    SI.Pressure p_in(start = p_in_des) "Inlet pressure at design point";
    SI.SpecificEnthalpy h_in "Enthalpy inlet at design point";
    SI.SpecificEntropy s_in;
    SI.Density rho_in;
    SI.Temperature T_in;
    //Inlet and outlet fluid ports
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  initial equation
    h_out_des = Util.stprops("H", "P", p_out_des, "T", T_out_des, fluid);
    h_in_des = Util.stprops("H", "P", p_in_des, "T", T_in_des, fluid);
    s_in_des = Util.stprops("S", "P", p_in_des, "H", h_in_des, fluid);
    h_out_isen_des = Util.stprops("H", "P", p_out_des, "S", s_in_des, fluid);
    eta_design = h_in_des - h_out_des - (h_in_des - h_out_isen_des);
    W_comp_des = m_flow_des * (h_in_des - h_out_des);
    rho_in_des = Util.stprops("D", "P", p_in_des, "H", h_in_des, fluid);
    d_rotor_des = (2 * m_flow_des / (phi_des * rho_in_des * N_design)) ^ (1 / 3);
    tip_speed_des = d_rotor_des * N_design / 2;
    psi_des = (h_out_isen_des - h_in_des) / tip_speed_des ^ 2;
  equation
//Mass Balance
    port_b.m_flow + port_a.m_flow = 0;
//Inlet outlet pressure
    p_in = port_a.p;
    p_out = port_b.p;
//Isentropic efficiency calculation during compressor operation (written in the order of solving)
    h_in = inStream(port_a.h_outflow);
    s_in = Util.stprops("S", "H", h_in, "P", p_in, fluid);
    rho_in = Util.stprops("D", "P", p_in, "H", h_in, fluid);
    phi = port_a.m_flow / (rho_in * tip_speed_des * d_rotor_des ^ 2);
    eta = eta_design / 0.677837 * ((-0.7069) + 168.6 * phi - 8089 * phi ^ 2 + 182725 * phi ^ 3 - 1.638 * 10 ^ 6 * phi ^ 4);
    psi = (0.04049 + 54.7 * phi - 2505 * phi ^ 2 + 53224 * phi ^ 3 - 498626 * phi ^ 4) * psi_des / 0.46181921979961293;
    h_out_isen = psi * tip_speed_des ^ 2 + h_in;
    p_out = Util.stprops("P", "H", h_out, "S", s_in, fluid);
    h_out = h_in + (h_out_isen - h_in) / eta;
    port_b.h_outflow = h_out;
//Calculating inlet outlet temperature
    T_out = Util.stprops("T", "P", p_out, "H", h_out, fluid);
    T_in = Util.stprops("T", "P", p_in, "H", h_in, fluid);
//Should not have a reverse flow case
    port_a.h_outflow = 0;
//Power consumption
    W_comp = port_a.m_flow * (h_in - h_out);
    annotation(
      Diagram(graphics = {Text(origin = {-8, 16}, extent = {{-28, 16}, {42, -46}}, textString = "Compressor"), Polygon(origin = {-2, 10}, rotation = 180, points = {{-42, 40}, {-42, -20}, {38, -50}, {38, 70}, {-42, 40}, {-42, 40}}), Line(origin = {50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {-50, -40.1649}, points = {{10, 0}, {-10, 0}, {-10, 0}})}, coordinateSystem(initialScale = 0.1)),
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {0, 2}, rotation = 180, points = {{-40, 32}, {-40, -28}, {40, -58}, {40, 62}, {-40, 32}}), Text(origin = {22, 17}, extent = {{-48, -31}, {4, -3}}, textString = "COMPRES"), Line(origin = {50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {-50, -40.1649}, points = {{10, 0}, {-10, 0}, {-10, 0}})}),
      Documentation(info = "<html>
  	<p>This compressor's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
  <p>The performance maps comes from the Sandia National Laboratory first compressor. It should be updated. The performance maps is compressed in three correlations, expressing the adimensionned head and the efficiency as functions of the adimensionned mass flow.&nbsp;</p>
  <p>The same correlations are used; only the maximal values are changed.</p>
  <p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  </html>"));
  end Compressor;

  model Turbine "Off-design turbine model"
    import Modelica.SIunits.Conversions.*;
    import SI = Modelica.SIunits;
    import stprops = SolarTherm.Media.CO2.CO2_utilities.stprops;
    replaceable package Medium = SolarTherm.Media.CarbonDioxide_ph;
    //Design Parameters
    parameter String fluid = "CO2" "Turbine working fluid (default: CO2)";
    parameter SI.Power W_turb_des(fixed = false) "Turbine power output at design";
    parameter SI.Temperature T_in_des = from_degC(715) "Turbine inlet temperature at design";
    parameter SI.Temperature T_out_des(fixed = false) "Turbine outlet temperature at design";
    parameter SI.Pressure p_in_des = 24e6 "Turbine inlet pressure at design";
    parameter SI.Pressure p_out_des = p_in_des / PR "Turbine outlet pressure at design";
    parameter SI.Efficiency eta_design = 0.9 "Turbine isentropic efficiency at design";
    parameter SI.Efficiency PR = 3 "Turbine pressure ratio at design";
    parameter SI.AngularVelocity n_shaft = 3358 "Turbine rotational speed at design";
    parameter SI.Area A_nozzle(fixed = false) "Turbine nozzle area";
    parameter SI.Diameter d_turb(fixed = false) "Turbine diameter";
    parameter SI.Velocity v_tip_des(fixed = false) "Turbine tip velocity at design";
    parameter SI.SpecificEnthalpy h_in_des(fixed = false) "Turbine inlet enthalpy at design";
    parameter SI.SpecificEntropy s_in_des(fixed = false) "Turbine inlet entropy at design";
    parameter SI.SpecificEnthalpy h_out_des(fixed = false) "Turbine outlet enthalpy at design";
    parameter SI.SpecificEnthalpy h_out_isen_des(fixed = false) "Turbine outlet isentropic enthalpy at design";
    parameter SI.Density rho_out_des(fixed = false) "Turbine outlet density at design";
    parameter SI.Velocity C_spouting_des(fixed = false) "Turbine spouting velocity at design";
    parameter SI.MassFlowRate m_flow_des(fixed = false) "Turbine mass flow rate at design";
    //Dynamic variables
    SI.AbsolutePressure p_in(start = p_in_des) "Turbine inlet pressure";
    SI.AbsolutePressure p_out(start = p_out_des) "Turbine outlet pressure";
    SI.SpecificEnthalpy h_in(start = h_in_des) "Turbine inlet enthalpy";
    SI.SpecificEntropy s_in "Turbine inlet entropy";
    SI.SpecificEnthalpy h_out_isen(start = h_out_isen_des) "Turbine outlet isentropic enthalpy";
    SI.SpecificEnthalpy h_out "Turbine outlet enthalpy";
    SI.Density rho_out "Turbine outlet density";
    SI.Velocity C_spouting(start = C_spouting_des) "Turbine spouting velociR744ty";
    SI.Efficiency eta_turb "Turbine efficiency";
    SI.Power W_turb "Turbine power output";
    SI.Temperature T_in;
    SI.Temperature T_out;
    SI.MassFlowRate m_dot_CO2(start = m_flow_des);
    //Inlet and outlet fluid ports
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  initial algorithm
    h_in_des := stprops("H", "T", T_in_des, "P", p_in_des, fluid);
    s_in_des := stprops("S", "T", T_in_des, "P", p_in_des, fluid);
    h_out_isen_des := stprops("H", "P", p_out_des, "S", s_in_des, fluid);
    h_out_des := h_in_des - (h_in_des - h_out_isen_des) * eta_design;
    rho_out_des := stprops("D", "P", p_out_des, "H", h_out_des, fluid);
    m_flow_des := W_turb_des / (h_in_des - h_out_des);
    C_spouting_des := sqrt(2 * (h_in_des - h_out_isen_des));
    A_nozzle := m_flow_des / (C_spouting_des * rho_out_des);
    v_tip_des := 0.707 * C_spouting_des;
    d_turb := v_tip_des / (0.5 * n_shaft);
    T_out_des := stprops("T", "P", p_out_des, "H", h_out_des, fluid);
  equation
//Mass balance
    port_a.m_flow + port_b.m_flow = 0;
//Inlet and outlet pressure
    p_in = port_a.p;
    p_out = port_b.p;
    p_out = p_in / PR;
//Inlet and outlet enthalpies
    h_in = inStream(port_a.h_outflow);
    s_in = stprops("S", "P", p_in, "H", h_in, fluid);
    h_out_isen = stprops("H", "P", p_out, "S", s_in, fluid);
    C_spouting = sqrt(2 * (h_in - h_out_isen));
    eta_turb = 2 * eta_design * (v_tip_des / C_spouting) * sqrt(1 - (v_tip_des / C_spouting) ^ 2);
    h_out = h_in - (h_in - h_out_isen) * eta_turb;
    port_b.h_outflow = h_out;
    rho_out = stprops("D", "P", p_out, "H", h_out, fluid);
    m_dot_CO2 = C_spouting * A_nozzle * rho_out;
    W_turb = m_dot_CO2 * (h_in - h_out);
    port_a.m_flow = m_dot_CO2;
//Should not have reverse flow
    port_a.h_outflow = 0.0;
//Calculatin temperature
    T_in = stprops("T", "P", p_in, "H", h_in, fluid);
    T_out = stprops("T", "P", p_out, "H", h_out, fluid);
    annotation(
      Documentation(info = "<html>
  	<p>This turbine's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
  	<p>The isentropic efficiency is calculated as a function of the tip speed ration between the tip speed of the rotor and the spouting velocity. It is said to be functionnal for any size.</p>
  	<p>The outlet pressure goes beyond the critical pressure for a mass flow too small. The cycle calculation should therefore not be performed below this pressure.</p>
  	<p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
  
  	</html>"),
      Diagram(graphics = {Text(origin = {-48, -48}, extent = {{18, 80}, {78, 16}}, textString = "Turbine"), Polygon(origin = {0, -10}, points = {{-40, 40}, {-40, -20}, {40, -50}, {40, 70}, {-40, 40}, {-40, 40}}), Line(origin = {-50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {50.111, -40.1649}, points = {{-10, 0}, {10, 0}, {10, 0}})}, coordinateSystem(initialScale = 0.1)),
      Icon(graphics = {Text(origin = {-20, 12}, extent = {{-10, 12}, {52, -34}}, textString = "TURBINA"), Ellipse(extent = {{56, 58}, {56, 58}}, endAngle = 360), Polygon(origin = {11, 7}, points = {{-51, 23}, {-51, -37}, {29, -67}, {29, 53}, {-51, 23}}), Line(origin = {-50, 20}, points = {{10, 0}, {-10, 0}, {-10, 0}}), Line(origin = {50, -39.8501}, points = {{-10, 0}, {10, 0}, {10, 0}})}, coordinateSystem(initialScale = 0.1)));
  end Turbine;

  model SimpleHX
    import stprops = SolarTherm.Media.CO2.CO2_utilities.stprops;
    import SI = Modelica.SIunits;
    import Modelica.SIunits.Conversions.*;
    parameter String fluid = "R744";
    replaceable package Medium = SolarTherm.Media.CarbonDioxide_ph;
    parameter SI.Temperature T_out_des = from_degC(715);
    SI.HeatFlowRate Q;
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  equation
//mass balance
    port_a.m_flow + port_b.m_flow = 0;
//no pressure loss
    port_a.p = port_b.p;
//no reverseflow
    port_a.h_outflow = 0;
//heat balance
    port_b.h_outflow = stprops("H", "P", port_a.p, "T", T_out_des, fluid);
    Q = port_a.m_flow * (inStream(port_a.h_outflow) - port_b.h_outflow);
  end SimpleHX;

  model Cooler
    import SI = Modelica.SIunits;
    import Modelica.SIunits.Conversions.*;
    import stprops = SolarTherm.Media.CO2.CO2_utilities.stprops;
    replaceable package Medium = SolarTherm.Media.CarbonDioxide_ph;
    //GENERAL PARAMETERS
    parameter String fluid = "CO2";
    parameter Integer N = 20 "discretization of the cooling --number of the thermodynamic state in the cooler. Number of control volume is N-1";
    //DESIGN PARAMETER
    parameter SI.Pressure p_drop = 0;
    parameter SI.Temperature T_amb_des = from_degC(45) "ambient temperature at design point";
    parameter SI.MassFlowRate m_flow_des = 1000 "mass flow rate at design point = mass flow rate of the medium after the splitter";
    parameter SI.Temperature delta_T_out_des = 10 "delta temperature of outlet temperature of the medium and ambient at design point";
    parameter SI.Power P_gross = 100e6 "Gross power output of the turbine";
    parameter SI.Power P_fan_cooler_des = -0.01 * P_gross "fan power rating";
    parameter SI.HeatFlowRate Q_cooler_des(fixed = false) "Cooling power at design point";
    parameter SI.SpecificEnthalpy delta_h_discretized_des(fixed = false) "discretized delta enthalpy";
    parameter SI.ThermalConductance UA_cooler(fixed = false) "UA rating of the cooler";
    //DESIGN PARAMETER - Inlet
    parameter SI.Pressure p_in_des = 8e6 "inlet design pressure in Pa";
    parameter SI.Temperature T_in_des(fixed = false) "inlet design temperature at degC = outlet design temperature of the Low-Temperature recuperator. The value is not specified in this model, since it will be detrmined in the system script. See the initial equation in thes system script";
    parameter SI.SpecificEnthalpy h_in_des = stprops("H", "P", p_in_des, "T", T_in_des, fluid);
    //DESIGN PARAMETER - Outlet
    parameter SI.Pressure p_out_des = p_in_des "no pressure loss";
    parameter SI.Temperature T_out_des_comp(fixed = false);
    parameter SI.Temperature T_out_des = T_amb_des + delta_T_out_des "outlet temperature of medium at design point in degC";
    parameter SI.Temperature T_out_des_real = if T_out_des_comp > T_out_des then T_out_des_comp else T_out_des;
    parameter SI.SpecificEnthalpy h_out_des = stprops("H", "P", p_out_des, "T", T_out_des_real, fluid);
    //DESING PARAMETER - Discretized variables
    parameter SI.SpecificEnthalpy[N] h_des(each fixed = false, start = linspace(h_in_des, h_out_des, N));
    parameter SI.Temperature[N] T_des(each fixed = false, start = linspace(T_in_des, T_out_des, N));
    parameter SI.Temperature[N] delta_T_des(each fixed = false, each start = 25) "difference of temperature of the medium and ambient at any point";
    //VARIABLES
    SI.HeatFlowRate Q_cooler "cooling capacity during operation";
    SI.Power P_fan_cooler "power needed by the fan to facilitate the required Q_cooler, the bigger the Q_cooler, the faster the fan must be, the higher the power";
    //VARIABLES -Inlet
    SI.Temperature T_in "inlet temperature of the medium during operation";
    SI.SpecificEnthalpy h_in "inlet enthalpy";
    //VARIABLES - Outlet
    SI.Temperature T_out "outlet temperature of the medium during operation";
    SI.SpecificEnthalpy h_out "outlet enthalpy";
    SI.Temperature delta_T_out "delta temperature of the medium and ambient during operation";
    //PORTS
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-2.22045e-16, -70}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {0, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-2.22045e-16, 70}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput T_amb annotation(
      Placement(visible = true, transformation(origin = {-78, 12}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-78, 12}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  initial algorithm
    Q_cooler_des := m_flow_des * (h_out_des - h_in_des);
    delta_h_discretized_des := Q_cooler_des / (N - 1) / m_flow_des;
    h_des[1] := h_in_des "the first element of h_des is equal to inlet design enthalpy";
    h_des[end] := h_out_des "the last element of h_des is equal to outlet design enthalpy";
    T_des[1] := T_in_des "the first element of T_des is equal to inlet design temp.";
    T_des[end] := T_out_des "the last element of T_des is equal to outlet design temp.";
    for i in 1:N - 1 loop
      h_des[i + 1] := h_des[i] + delta_h_discretized_des;
      T_des[i + 1] := stprops("T", "H", h_des[i + 1], "P", p_in_des, fluid);
    end for;
    for i in 1:N loop
      delta_T_des[i] := T_des[i] - T_amb_des;
    end for;
    UA_cooler := abs(Q_cooler_des) / (T_des[1] - T_amb_des) / (T_des[N] - T_amb_des) / Modelica.Math.log((T_des[1] - T_amb_des) / (T_des[N] - T_amb_des)) "LMTD method since the inlet-outlet temp of the medium is known and T_amb is also constant ";
  equation
//The equation is written in the order of solving
//No pressure drop
    port_b.p = port_a.p;
//Mass balance
    port_a.m_flow + port_b.m_flow = 0;
//Energy balance and intermediate calculation
    h_in = inStream(port_a.h_outflow);
    T_in = stprops("T", "H", h_in, "P", port_a.p, fluid);
    T_out = max(T_amb + 3, T_out_des);
    h_out = stprops("H", "T", T_out, "P", port_b.p, fluid);
    Q_cooler = port_a.m_flow * (h_out - h_in);
    delta_T_out = T_out - T_amb;
    P_fan_cooler = P_fan_cooler_des * (delta_T_out_des / delta_T_out) ^ (3 / 0.805) * (Q_cooler / Q_cooler_des);
//Should not have a reverse flow anyway
    port_a.h_outflow = 0;
//Outlet enthalpy
    port_b.h_outflow = h_out;
    annotation(
      Diagram(graphics = {Rectangle(origin = {-1, 2}, extent = {{-57, 72}, {57, -72}}), Text(origin = {1, 6}, extent = {{-11, 2}, {11, -2}}, textString = "Cooler", fontSize = 26)}, coordinateSystem(initialScale = 0.1)),
      Icon(graphics = {Rectangle(origin = {0, -1}, extent = {{-60, 71}, {60, -71}}), Text(origin = {1, 3}, extent = {{-31, 17}, {31, -17}}, textString = "Cooler")}));
  end Cooler;

  model HeatExchanger
    import SI = Modelica.SIunits;
    import Modelica.SIunits.Conversions.*;
    import stprops = SolarTherm.Media.CO2.CO2_utilities.stprops;
    import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
    replaceable package Medium = SolarTherm.Media.CarbonDioxide_ph;
    //GENERAL PARAMETERS
    parameter String fluid = "CO2";
    parameter Integer N = 15 "discretization of the HX";
    //DESIGN PARAMETERS
    parameter SI.HeatFlowRate Q_flow_des = 200e6 "heat exchanger rating at design point";
    parameter SI.MassFlowRate m_flow_HTF_des(fixed = false) "mass flow rate of the HTF coming into the HX at design point";
    parameter SI.MassFlowRate m_flow_medium_des(fixed = false) "mass flow rate of the medium coming into the HX at design point";
    parameter SI.HeatFlowRate Q_max_des(fixed = false);
    parameter SI.Efficiency eta_HX_des(fixed = false);
    //DESIGN PARAMETERS - Inlet parameters of the medium
    parameter SI.Temperature T_in_medium_des(fixed = false) "inlet temperature of the medium at the design point";
    parameter SI.Pressure p_in_medium_des = 8e6 "inlet pressure of the medium at design point";
    parameter SI.SpecificEnthalpy h_in_medium_des(fixed = false);
    //DESIGN PARAMETERS - Outlet parameters of the medium
    parameter SI.Temperature T_out_medium_des = from_degC(715) "outlet temperature of the medium at design point = inlet design temp. of the turbine";
    parameter SI.Pressure p_out_medium_des = p_in_medium_des "no pressure loss";
    parameter SI.SpecificEnthalpy h_out_medium_des = stprops("H", "P", p_out_medium_des, "T", T_out_medium_des, fluid);
    //DESIGN PARAMETERS - Inlet parameters of the HTF
    parameter SI.Temperature T_hot_tank = from_degC(800) "temperature of the hot tank at design point";
    parameter SI.Pressure p_in_HTF_des = 1e5 "pressure of the HTF from the hot tank coming into the HX";
    parameter SI.SpecificEnthalpy h_in_HTF_des = Util.h_T(T_hot_tank);
    //DESIGN PARAMETERS - Outlet parameters of the HTF
    parameter SI.Temperature T_cold_tank = from_degC(580) "temperature of the cold tank at design point";
    parameter SI.Pressure p_out_HTF_des = 1e5 "pressure of the HTF from the hot tank leaving the HX";
    parameter SI.SpecificEnthalpy h_out_HTF_des = Util.h_T(T_cold_tank);
    //DESIGN PARAMETERS - Discetized parameters
    parameter SI.ThermalConductance UA_HX_des(fixed = false) "UA value of the HX at design point";
    //VARIABLES
    SI.SpecificEnthalpy h_in_HTF(start = h_in_HTF_des);
    SI.SpecificEnthalpy h_out_HTF(start = h_out_HTF_des);
    SI.SpecificEnthalpy h_in_medium(start = h_in_medium_des);
    SI.SpecificEnthalpy h_out_medium(start = h_out_medium_des);
    SI.SpecificHeatCapacity Cp_in_medium(start = Util.cp_T(T_in_medium_des));
    SI.SpecificHeatCapacity Cp_in_HTF(start = stprops("CP", "P", p_in_HTF_des, "T", T_hot_tank, fluid));
    SI.ThermalConductance UA_HX(start = UA_HX_des);
    SI.HeatFlowRate Q_HX "total heat exchanged in the HX during operation";
    SI.Efficiency eta_HX "effectivenes of heat exchanger";
    SI.Temperature T_in_HTF(start = T_hot_tank);
    SI.Temperature T_out_HTF(start = T_cold_tank);
    SI.Temperature T_in_medium(start = T_in_medium_des);
    SI.Temperature T_out_medium(start = T_out_medium_des);
    Real C_min(start = 1) "minimum off-design capacitance";
    Real C_max(start = 1) "max off-design capacitance";
    Real C_R(start = 1) "off-design capacitance ratio of the HX";
    Real NTU "NTU method";
    //PORTS
    Modelica.Fluid.Interfaces.FluidPort_a HTF_port_a(redeclare package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph) annotation(
      Placement(visible = true, transformation(origin = {72, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {72, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_a medium_port_a(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {-72, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, -20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b HTF_port_b(redeclare package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph) annotation(
      Placement(visible = true, transformation(origin = {-72, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
    Modelica.Fluid.Interfaces.FluidPort_b medium_port_b(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {72, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, -20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  initial algorithm
    h_in_medium_des := h_out_medium_des - Q_flow_des / m_flow_medium_des "Finding the enthalpy inlet of medium at design point --> m_flow_medium_des = m_flow_des at turbine, Q_flow_des = Q_flow_HX at design point, h_out_medium_des = f(T_out_medium) which is equal to design point of turbine inlet temp.";
    T_in_medium_des := stprops("T", "H", h_in_medium_des, "P", p_in_medium_des, fluid) "this value will be passed as the T_out_medium_des of the high temp. recuperator";
    m_flow_HTF_des := Q_flow_des / (h_in_HTF_des - h_out_HTF_des);
    Q_max_des := m_flow_medium_des * stprops("C", "P", p_in_medium_des, "H", h_in_medium_des, fluid) * (T_hot_tank - T_in_medium_des);
    eta_HX_des := Q_flow_des / Q_max_des;
    UA_HX_des := eta_HX_des / (1 - eta_HX_des) * m_flow_medium_des * (0.5 * (stprops("C", "P", p_in_medium_des, "H", h_in_medium_des, fluid) + stprops("C", "P", p_out_medium_des, "H", h_out_medium_des, fluid)));
  equation
//Mass Balance
//medium_port_a.m_flow + medium_port_b.m_flow = 0;
    HTF_port_a.m_flow + HTF_port_b.m_flow = 0;
//Pressure balance
    medium_port_a.p = medium_port_b.p;
    HTF_port_a.p = HTF_port_b.p;
//No reverse flow
    medium_port_a.h_outflow = 0;
    HTF_port_a.h_outflow = 0;
//Intermediate calculation - written in order of solving
    T_in_HTF = Util.T_h(inStream(HTF_port_a.h_outflow));
    T_in_medium = stprops("T", "P", medium_port_a.p, "H", inStream(medium_port_a.h_outflow), fluid);
    h_in_HTF = inStream(HTF_port_a.h_outflow);
    h_in_medium = inStream(medium_port_a.h_outflow);
    Cp_in_medium = stprops("C", "H", inStream(medium_port_a.h_outflow), "P", medium_port_a.p, fluid);
    Cp_in_HTF = Util.cp_T(Util.T_h(inStream(HTF_port_a.h_outflow)));
    C_min = min(medium_port_a.m_flow * Cp_in_medium, HTF_port_a.m_flow * Cp_in_HTF);
    C_max = max(medium_port_a.m_flow * Cp_in_medium, HTF_port_a.m_flow * Cp_in_HTF);
    C_R = C_min / C_max;
    UA_HX = UA_HX_des * (0.5 * (medium_port_a.m_flow / m_flow_medium_des + HTF_port_a.m_flow / m_flow_HTF_des)) ^ 0.8;
    NTU = UA_HX / C_min;
    if C_R < 1 then
      eta_HX = (1 - exp(-NTU * (1 - C_R))) / (1 - C_R * exp(-NTU * (1 - C_R)));
    else
      eta_HX = NTU / (1 + NTU);
    end if;
    Q_HX = eta_HX * C_min * (T_in_HTF - T_in_medium);
    h_out_HTF = h_in_HTF - Q_HX / HTF_port_a.m_flow;
    h_out_medium = h_in_medium + Q_HX / medium_port_a.m_flow;
    T_out_HTF = Util.T_h(h_out_HTF);
    T_out_medium = stprops("T", "H", h_out_medium, "P", medium_port_a.p, fluid);
//Outlet port
    medium_port_b.h_outflow = h_out_medium;
    HTF_port_b.h_outflow = h_out_HTF;
    annotation(
      Diagram(graphics = {Rectangle(extent = {{-72, 40}, {72, -40}}), Text(origin = {4, 1}, extent = {{-40, 13}, {40, -13}}, textString = "Heat Exchanger"), Line(origin = {0, 20}, points = {{-72, 0}, {72, 0}, {72, 0}}), Text(origin = {0, 30}, extent = {{-26, 6}, {26, -6}}, textString = "Hot Side"), Line(origin = {0, -20}, points = {{-72, 0}, {72, 0}}), Text(origin = {5, -33}, extent = {{-35, 9}, {29, -3}}, textString = "Cold Side")}, coordinateSystem(initialScale = 0.1)),
      Icon(graphics = {Rectangle(extent = {{-72, 40}, {72, -40}}), Text(origin = {11, -6}, extent = {{-49, 20}, {33, -10}}, textString = "Heat Exchanger"), Text(origin = {1, 34}, extent = {{-15, 4}, {15, -4}}, textString = "Hot Side"), Text(origin = {1, -35}, extent = {{-15, 5}, {15, -5}}, textString = "Cold Side"), Line(origin = {0, 20}, points = {{-72, 0}, {72, 0}}), Line(origin = {0, -20}, points = {{-72, 0}, {72, 0}}), Line(origin = {0.81235, -20}, points = {{5.18765, 0}, {-4.81235, 8}, {-4.81235, -8}, {5.18765, 0}}), Line(origin = {-1.85355, 20}, points = {{-4.14645, 0}, {3.85355, 8}, {3.85355, -8}, {-4.14645, 0}})}, coordinateSystem(initialScale = 0.1)),
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
  end HeatExchanger;

  model Recuperator
    import SI = Modelica.SIunits;
    import Modelica.SIunits.Conversions.*;
    import stprops = SolarTherm.Media.CO2.CO2_utilities.stprops;
    import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
    import ln = Modelica.Math.log;
    replaceable package Medium = SolarTherm.Media.CarbonDioxide_ph;
    //GENERAL PARAMETERS
    parameter String fluid = "CO2";
    parameter Integer N = 30 "discretization of the HX";
    //DESIGN PARAMETERS
    parameter SI.Temperature pinch_point = 5 "pinch point at design condition";
    parameter SI.HeatFlowRate Q_flow_des(fixed = false) "heat exchanger rating at design point";
    parameter SI.MassFlowRate m_flow_hot_des = 800 "mass flow rate of the hot stream coming into the HX at design point";
    parameter SI.MassFlowRate m_flow_cold_des = 800 "mass flow rate of the cold stream coming into the HX at design point";
    parameter SI.HeatFlowRate Q_max_des(fixed = false) "maximum possible heat transfer occured assuming we have infinite size of HX";
    parameter SI.Efficiency eta_HX_des(fixed = false);
    //DESIGN PARAMETERS - Inlet parameters of the cold stream (cold side)
    parameter SI.Temperature T_in_cold_des(fixed = false) "inlet temperature of the cold stream at the design point = T_out_des compressor";
    parameter SI.Pressure p_in_cold_des = 8e6 "inlet pressure of the cold stream at design point = P_out_des turbine";
    parameter SI.SpecificEnthalpy h_in_cold_des(fixed = false, start = 500000);
    //DESIGN PARAMETERS - Outlet parameters of the cold
    parameter SI.Temperature T_out_cold_des = from_degC(424.005);
    //(fixed = false) "outlet temperature of the cold stream at design point =  heatExchanger.T_in_medium_des";
    parameter SI.Pressure p_out_cold_des = p_in_cold_des "no pressure loss";
    parameter SI.SpecificEnthalpy h_out_cold_des(fixed = false);
    //DESIGN PARAMETERS - Inlet parameters of the hot
    parameter SI.Temperature T_in_hot_des = from_degC(567);
    //(fixed = false) "temperature outlet of the turbine.T_out_des";
    parameter SI.Pressure p_in_hot_des = 24e6 "pressure of the hot from the ";
    parameter SI.SpecificEnthalpy h_in_hot_des(fixed = false);
    //DESIGN PARAMETERS - Outlet parameters of the hot
    parameter SI.Temperature T_out_hot_des(fixed = false) "temperature of the hot stream out at design point";
    parameter SI.Pressure p_out_hot_des = p_in_hot_des "pressure of the hot stream from compressor at design point";
    parameter SI.SpecificEnthalpy h_out_hot_des(fixed = false) "enthalpy of the hot stream out at design point";
    //DESIGN PARAMETERS - Discetized parameters
    parameter SI.ThermalConductance UA_HX_des(fixed = false) "UA value of the HX at design point";
    parameter SI.Temperature[N] delta_T_des(each fixed = false, each start = 25);
    parameter SI.Temperature[N] T_cold_des(each fixed = false, start = {140 + 273.15 + i / N * 300 for i in 1:N});
    parameter SI.Temperature[N] T_hot_des(each fixed = false, start = {160 + 273.15 + i / N * 300 for i in 1:N});
    parameter SI.SpecificEnthalpy[N] h_cold_des(each fixed = false, start = {500000 + i / N * 500000 for i in 1:N});
    parameter SI.SpecificEnthalpy[N] h_hot_des(each fixed = false, start = {530000 + i / N * 500000 for i in 1:N});
    parameter SI.ThermalConductance[N - 1] UA_HX_des_dis(each fixed = false, each start = 4000);
    parameter SI.SpecificEnthalpy delta_h_dis_des(fixed = false, each start = 18600);
    /*/VARIABLES
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.SpecificEnthalpy h_in_hot(start = h_in_hot_des);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.SpecificEnthalpy h_out_hot(start = h_out_hot_des);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.SpecificEnthalpy h_in_cold(start = h_in_cold_des);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.SpecificEnthalpy h_out_cold(start = h_out_cold_des);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.Temperature T_in_hot(start = T_in_hot_des);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.Temperature T_out_hot(start = T_out_hot_des);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.Temperature T_in_cold(start = T_in_cold_des);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.Temperature T_out_cold(start = T_out_cold_des);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.HeatFlowRate Q_HX "total heat exchanged in the HX during operation";
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    //VARIABLES - DISCRETIZED
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.SpecificEnthalpy[N] h_hot(start = {500000 + (i - 1) / N * 200000 for i in 1:N});
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.SpecificEnthalpy[N] h_cold(start = {480000 + (i - 1) / N * 200000 for i in 1:N});
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.Temperature[N] T_hot(start = {350 + (i - 1) / N * 150 for i in 1:N});
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    SI.Temperature[N] T_cold(start = {320 + (i - 1) / N * 150 for i in 1:N});
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Real[N] delta_T(start = {30 for i in 1:N});
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    //PORTS
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Modelica.Fluid.Interfaces.FluidPort_a hot_port_a(redeclare package Medium = Medium, m_flow.start = 1000) annotation(
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Placement(visible = true, transformation(origin = {72, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {72, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Modelica.Fluid.Interfaces.FluidPort_a cold_port_a(redeclare package Medium = Medium) annotation(
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Placement(visible = true, transformation(origin = {-72, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, -20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Modelica.Fluid.Interfaces.FluidPort_b hot_port_b(redeclare package Medium = Medium) annotation(
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Placement(visible = true, transformation(origin = {-72, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Modelica.Fluid.Interfaces.FluidPort_b cold_port_b(redeclare package Medium = Medium) annotation(
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Placement(visible = true, transformation(origin = {72, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, -20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));*/
  initial equation
    h_out_cold_des = stprops("H", "T", T_out_cold_des, "P", p_out_cold_des, fluid);
    h_in_hot_des = stprops("H", "T", T_in_hot_des, "P", p_in_hot_des, fluid);
    h_cold_des[1] = h_in_cold_des;
    h_cold_des[end] = h_out_cold_des;
    h_hot_des[1] = h_out_hot_des;
    h_hot_des[end] = h_in_hot_des;
    T_cold_des[1] = T_in_cold_des;
    T_hot_des[end] = T_in_hot_des;
    min(delta_T_des) = pinch_point "boundary condition";
    for i in 1:N loop
      delta_T_des[i] = T_hot_des[i] - T_cold_des[i];
    end for;
    for i in 1:N - 1 loop
      delta_h_dis_des = h_cold_des[i + 1] - h_cold_des[i];
      delta_h_dis_des = UA_HX_des_dis[i] / m_flow_hot_des * (delta_T_des[i + 1] + delta_T_des[i]) / 2;
      delta_h_dis_des = h_hot_des[i + 1] - h_hot_des[i];
    end for;
    T_in_cold_des = stprops("T", "H", h_in_cold_des, "P", p_in_cold_des, fluid);
    T_out_hot_des = stprops("T", "H", h_out_hot_des, "P", p_out_hot_des, fluid);
    Q_flow_des = m_flow_hot_des * delta_h_dis_des * (N - 1);
    UA_HX_des = sum(UA_HX_des_dis);
/*equation
//Mass Balance
    cold_port_a.m_flow + cold_port_b.m_flow = 0;
    hot_port_a.m_flow + hot_port_b.m_flow = 0;
//Pressure balance
    cold_port_a.p = cold_port_b.p;
    hot_port_a.p = hot_port_b.p;
//No reverse flow
    cold_port_a.h_outflow = 0;
    hot_port_a.h_outflow = 0;
//Intermediate calculation - written in order of solving
    h_in_hot = inStream(hot_port_a.h_outflow);
    h_in_cold = inStream(cold_port_a.h_outflow);
    T_in_hot = stprops("T", "P", hot_port_a.p, "H", h_in_hot, fluid);
    T_in_cold = stprops("T", "P", cold_port_a.p, "H", h_in_cold, fluid);
    h_cold[1] = h_in_cold;
    h_hot[end] = h_in_hot;
    for i in 1:N loop
      T_cold[i] = stprops("T", "H", h_cold[i], "P", cold_port_a.p, fluid);
      T_hot[i] = stprops("T", "H", h_hot[i], "P", hot_port_a.p, fluid);
      delta_T[i] = T_hot[i] - T_cold[i];
    end for;
    for i in 2:N loop
      hot_port_a.m_flow * (h_hot[i] - h_hot[i - 1]) = cold_port_a.m_flow * (h_cold[i] - h_cold[i - 1]);
      hot_port_a.m_flow * (h_hot[i] - h_hot[i - 1]) = UA_HX_des_dis[i - 1] * abs(cold_port_a.m_flow / m_flow_cold_des + hot_port_a.m_flow / m_flow_hot_des) ^ 0.8 / 2 ^ 0.8 * (T_hot[i - 1] - T_cold[i - 1] + T_hot[i] - T_cold[i]) / 2;
    end for;
    h_cold[end] = h_out_cold;
    h_hot[1] = h_out_hot;
    T_out_cold = T_cold[end];
    T_out_hot = T_hot[1];
    Q_HX = hot_port_a.m_flow * (h_in_hot - h_out_hot);
//Outlet port
    cold_port_b.h_outflow = h_out_cold;
    hot_port_b.h_outflow = h_out_hot;*/
    annotation(
      Diagram(graphics = {Text(origin = {0, 30}, extent = {{-26, 6}, {26, -6}}, textString = "Hot Side"), Line(origin = {0, 20}, points = {{-72, 0}, {72, 0}, {72, 0}}), Line(origin = {0, -20}, points = {{-72, 0}, {72, 0}}), Text(origin = {4, 1}, extent = {{-40, 13}, {40, -13}}, textString = "Recuperator"), Text(origin = {5, -33}, extent = {{-35, 9}, {29, -3}}, textString = "Cold Side"), Rectangle(extent = {{-72, 40}, {72, -40}})}, coordinateSystem(initialScale = 0.1)),
      Icon(graphics = {Line(origin = {0, -20}, points = {{-72, 0}, {72, 0}}), Line(origin = {-1.85355, 20}, points = {{-4.14645, 0}, {3.85355, 8}, {3.85355, -8}, {-4.14645, 0}}), Line(origin = {0.81235, -20}, points = {{5.18765, 0}, {-4.81235, 8}, {-4.81235, -8}, {5.18765, 0}}), Rectangle(extent = {{-72, 40}, {72, -40}}), Text(origin = {1, -35}, extent = {{-15, 5}, {15, -5}}, textString = "Cold Side"), Text(origin = {1, 34}, extent = {{-15, 4}, {15, -4}}, textString = "Hot Side"), Text(origin = {11, -6}, extent = {{-49, 20}, {33, -10}}, textString = "Recuperator"), Line(origin = {0, 20}, points = {{-72, 0}, {72, 0}})}, coordinateSystem(initialScale = 0.1)));
  end Recuperator;

  model PIDtesting
    import SI = Modelica.SIunits;
    import Modelica.SIunits.Conversions.*;
    replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
    import sin = Modelica.Math.Sin;
    // Receiver design params
    parameter SI.Length H_rcv(fixed = false);
    parameter SI.MassFlowRate m_flow_des(fixed = false);
    parameter SI.Irradiance dni_des = 950;
    parameter SI.CoefficientOfHeatTransfer h_conv_backwall = 10;
    parameter SI.CoefficientOfHeatTransfer h_conv_curtain = 32;
    parameter SI.Efficiency eta_opt_des = 0.88;
    parameter SI.HeatFlowRate Q_in = 500e6;
    parameter SI.Temperature T_in_design = from_degC(580.3);
    parameter SI.Temperature T_out_design = from_degC(800);
    parameter SI.Temperature T_amb_des = from_degC(25);
    parameter SI.Temperature T_amb = from_degC(5);
    parameter SI.Power P_net = 100e6;
    parameter SI.Efficiency par_fr = 0.1;
    parameter SI.Power P_gross = P_net / (1 - par_fr);
    parameter Real SM = 2.5;
    parameter Real eff_blk = 0.501;
    // Params PID
    parameter Real Ti = 0.1 "Time constant for integral component of receiver control";
    parameter Real Kp = -1000 "Gain of proportional component in receiver control";
    parameter SI.MassFlowRate m_flow_max = 3 * m_flow_des;
    parameter SI.MassFlowRate m_flow_min = 0;
    //Connections
    SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D(H_drop_design = H_rcv, N = 20, fixed_cp = false, test_mode = false, with_detail_h_ambient = false, with_isothermal_backwall = false, with_uniform_curtain_props = false, with_wall_conduction = true, h_conv_curtain = h_conv_curtain, h_conv_backwall = h_conv_backwall) annotation(
      Placement(visible = true, transformation(origin = {-28, 22}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
    Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_in_design, nPorts = 1, p = 1e5, use_T = true, use_p = false) annotation(
      Placement(visible = true, transformation(origin = {60, -14}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    SolarTherm.Models.Fluid.Pumps.LiftSimple liftSimple(redeclare package Medium = Medium, cont_m_flow = true, use_input = true, dh = 0, CF = 0, eff = 0.8) annotation(
      Placement(visible = true, transformation(origin = {12, -24}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    Modelica.Blocks.Sources.BooleanExpression Operation(y = true) annotation(
      Placement(visible = true, transformation(origin = {-84, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression realExpression(y = T_amb) annotation(
      Placement(visible = true, transformation(origin = {-80, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression Wind_dir(y = 1) annotation(
      Placement(visible = true, transformation(origin = {-83, 53}, extent = {{-11, -13}, {11, 13}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression Wspd_input(y = 1) annotation(
      Placement(visible = true, transformation(extent = {{-96, 60}, {-70, 80}}, rotation = 0)));
    Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Medium, T = 300.0, d = 3300, nPorts = 1, p = 1e5, use_T = true) annotation(
      Placement(visible = true, transformation(extent = {{76, 58}, {56, 78}}, rotation = 0)));
    SolarTherm.Models.Fluid.Sensors.Temperature temperature annotation(
      Placement(visible = true, transformation(origin = {22, 70}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
    SolarTherm.Models.Control.ReceiverControl receiverControl(Kp = Kp, T_ref = T_out_design, Ti = Ti, m_flow_max = m_flow_max, m_flow_min = m_flow_min) annotation(
      Placement(visible = true, transformation(origin = {30, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression realExpression1(y = 80) annotation(
      Placement(visible = true, transformation(origin = {107, 20}, extent = {{13, -10}, {-13, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression heat_in(y = Q_in) annotation(
      Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
      Placement(visible = true, transformation(origin = {-74, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1DCalculator particleReceiver1DCalculator(P_gross_design = P_gross, SolarMultiple = SM, T_amb_design = T_amb_des, T_in_design = T_in_design, T_out_design = T_out_design, dni_des = dni_des, eff_block_design = eff_blk, eta_opt_des = eta_opt_des, h_conv_backwall = h_conv_backwall, h_conv_curtain = h_conv_curtain) annotation(
      Placement(visible = true, transformation(origin = {88, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  initial equation
    m_flow_des = particleReceiver1DCalculator.m_in;
    H_rcv = particleReceiver1DCalculator.particleReceiver1D.H_drop;
  equation
    connect(particleReceiver1D.fluid_a, liftSimple.fluid_b) annotation(
      Line(points = {{-22, -2}, {-10, -2}, {-10, -22}, {6, -22}, {6, -22}}, color = {0, 127, 255}));
    connect(liftSimple.fluid_a, source.ports[1]) annotation(
      Line(points = {{18, -22}, {30, -22}, {30, -14}, {50, -14}, {50, -14}}, color = {0, 127, 255}));
    connect(Operation.y, particleReceiver1D.on) annotation(
      Line(points = {{-72, -20}, {-56, -20}, {-56, -2}, {-32, -2}, {-32, -2}}, color = {255, 0, 255}));
    connect(realExpression.y, particleReceiver1D.Tamb) annotation(
      Line(points = {{-68, 84}, {-22, 84}, {-22, 42}, {-22, 42}}, color = {0, 0, 127}));
    connect(Wind_dir.y, particleReceiver1D.Wdir) annotation(
      Line(points = {{-70, 54}, {-34, 54}, {-34, 42}, {-34, 42}}, color = {0, 0, 127}));
    connect(Wspd_input.y, particleReceiver1D.Wspd) annotation(
      Line(points = {{-68, 70}, {-28, 70}, {-28, 42}, {-28, 42}}, color = {0, 0, 127}));
    connect(temperature.fluid_b, sink.ports[1]) annotation(
      Line(points = {{32, 70}, {56, 70}, {56, 68}, {56, 68}}, color = {0, 127, 255}));
    connect(temperature.fluid_a, particleReceiver1D.fluid_b) annotation(
      Line(points = {{12, 70}, {-2, 70}, {-2, 34}, {-20, 34}, {-20, 34}}, color = {0, 127, 255}));
    connect(receiverControl.m_flow, liftSimple.m_flow) annotation(
      Line(points = {{18, 20}, {14, 20}, {14, -12}, {14, -12}}, color = {0, 0, 127}));
    connect(temperature.T, receiverControl.T_mea) annotation(
      Line(points = {{22, 60}, {22, 60}, {22, 36}, {60, 36}, {60, 26}, {42, 26}, {42, 26}}, color = {0, 0, 127}));
    connect(Operation.y, receiverControl.sf_on) annotation(
      Line(points = {{-72, -20}, {-56, -20}, {-56, -44}, {84, -44}, {84, 14}, {42, 14}, {42, 14}}, color = {255, 0, 255}));
    connect(realExpression1.y, receiverControl.L_mea) annotation(
      Line(points = {{92, 20}, {42, 20}, {42, 20}, {40, 20}}, color = {0, 0, 127}));
    connect(heat_in.y, prescribedHeatFlow.Q_flow) annotation(
      Line(points = {{-98, 30}, {-84, 30}, {-84, 30}, {-84, 30}}, color = {0, 0, 127}));
    connect(prescribedHeatFlow.port, particleReceiver1D.heat) annotation(
      Line(points = {{-64, 30}, {-54, 30}, {-54, 30}, {-54, 30}}, color = {191, 0, 0}));
    connect(prescribedHeatFlow.Q_flow, receiverControl.Q_input) annotation(
      Line(points = {{-84, 30}, {20, 30}, {20, 32}, {20, 32}}, color = {0, 0, 127}));
    connect(particleReceiver1D.eta_rec_out, receiverControl.eta_rec_in) annotation(
      Line(points = {{-20, 16}, {6, 16}, {6, 44}, {40, 44}, {40, 32}, {40, 32}}, color = {0, 0, 127}));
    annotation(
      experiment(StartTime = 0, StopTime = 6000, Tolerance = 1e-06, Interval = 1));
  end PIDtesting;

  model PBTestRig
    import FI = SolarTherm.Models.Analysis.Finances;
    import Modelica.SIunits.Conversions.*;
    replaceable package MedPB = SolarTherm.Media.CarbonDioxide_ph;
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
    parameter Modelica.SIunits.Power P_nom(fixed = false) "Electrical power at design point";
    parameter Modelica.SIunits.MassFlowRate m_HTF_des = 1000 "Mass flow rate at design point";
    parameter Modelica.SIunits.Efficiency gamma = 0.28 "Part of the mass flow going to the recompression directly";
    parameter Modelica.SIunits.AngularVelocity[4] choiceN = {75000, 30000, 10000, 3600} * 0.10471975512;
    parameter Modelica.SIunits.AngularVelocity N_shaft = choiceN[integer(Modelica.Math.log(P_gro / 1e6) / Modelica.Math.log(10)) + 2];
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
    Modelica.SIunits.Efficiency eta_cycle;
    Modelica.SIunits.Energy E_net(final start = 0, fixed = true, displayUnit = "MW.h");
    Boolean m_sup "Disconnect the production of electricity when the outlet pressure of the turbine is close to the critical pressure";
    //Components instanciation
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve HTR(redeclare package Medium = MedPB, N_q = N_HTR, P_nom_des = P_gro, ratio_m_des = 1) annotation(
      Placement(visible = true, transformation(origin = {26, -20}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.CompressorOnShaft mainCompressor(redeclare package Medium = MedPB, eta_design = eta_comp_main, N_design = N_shaft, P_nom_des = P_gro, p_high_des = p_high) annotation(
      Placement(visible = true, transformation(origin = {-81, -3}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Cooler cooler(redeclare package Medium = MedPB, T_low = T_low, P_nom_des = P_gro, T_amb_des = T_amb_des) annotation(
      Placement(visible = true, transformation(origin = {-83, -51}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Turbine turbine(redeclare package Medium = MedPB, PR = PR, T_amb = T_amb_des, N_shaft = N_shaft, eta_design = eta_turb) annotation(
      Placement(visible = true, transformation(origin = {74, 0}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.Exchanger exchanger(redeclare package MedRec = MedRec, redeclare package MedPB = MedPB, P_nom_des = P_gro, T_out_CO2_des = T_high, N_exch = N_exch, ratio_m_des = 1) annotation(
      Placement(visible = true, transformation(origin = {48, 34}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.CompressorOnShaft reCompressor(redeclare package Medium = MedPB, N_design = N_shaft, P_nom_des = P_gro, p_high_des = p_high) annotation(
      Placement(visible = true, transformation(origin = {-47, 23}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.HeatRecuperatorDTAve LTR(redeclare package Medium = MedPB, N_q = N_LTR, P_nom_des = P_gro, ratio_m_des = 1 - gamma) annotation(
      Placement(visible = true, transformation(origin = {-28, -44}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.FlowMixer mixer(redeclare package MedRec = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-3, -15}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.FlowSplitter splitter(gamma = gamma, redeclare package MedRec = MedPB) annotation(
      Placement(visible = true, transformation(origin = {-58, -44}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    Modelica.Fluid.Sources.MassFlowSource_T source(replaceable package Medium = MedRec, T = from_degC(720), m_flow = 1200, nPorts = 1) annotation(
      Placement(visible = true, transformation(origin = {86, 81.5}, extent = {{14, -14}, {-14, 14}}, rotation = 90)));
    Modelica.Fluid.Sources.FixedBoundary sink(replaceable package Medium = MedRec, nPorts = 1) annotation(
      Placement(visible = true, transformation(origin = {28, 88}, extent = {{13, 13}, {-13, -13}}, rotation = 90)));
    parameter MedRec.ThermodynamicState state_HTF_in_des = MedRec.setState_pTX(1e5, T_HTF_in_des);
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
    C_HTR = if HTR.T_turb_des[N_HTR] >= from_degC(550) then 49.45 * HTR.UA_HTR ^ 0.7544 * (1 + 0.02141 * (HTR.T_turb_des[N_HTR] - from_degC(550))) else 49.45 * HTR.UA_HTR ^ 0.7544;
    C_LTR = 49.45 * LTR.UA_HTR ^ 0.7544;
    C_turbine = if exchanger.T_CO2_des[2] >= from_degC(550) then 406200 * (-turbine.W_turb_des / 1e6) ^ 0.8 * (1 + 1.137e-5 * (exchanger.T_CO2_des[2] - from_degC(550)) ^ 2) else 406200 * (-turbine.W_turb_des / 1e6) ^ 0.8;
    C_mainCompressor = 1230000 * (mainCompressor.W_comp_des / 1e6) ^ 0.3392;
    C_reCompressor = 1230000 * (reCompressor.W_comp_des / 1e6) ^ 0.3392;
    C_cooler = 32.88 * cooler.UA_cooler ^ 0.75;
    C_generator = 108900 * (P_nom / 1e6) ^ 0.5463;
    C_exchanger = pri_exchanger * exchanger.Q_HX_des * m_HTF_des / 1000;
    C_PB = (C_HTR + C_LTR + C_turbine + C_mainCompressor + C_reCompressor + C_generator + C_cooler + C_exchanger) * 1.05;
// 1.05 factor due to cost scaling to 2017 USD
  equation
    connect(LTR.from_turb_port_b, splitter.port_a) annotation(
      Line(points = {{-43, -44}, {-14, -44}}, color = {0, 127, 255}));
    connect(LTR.from_turb_port_a, HTR.from_turb_port_b) annotation(
      Line(points = {{14, -56}, {32, -56}}, color = {0, 127, 255}));
    connect(LTR.from_comp_port_b, mixer.first_port_a) annotation(
      Line(points = {{4, -65}, {4, -71}}, color = {0, 127, 255}));
    connect(mixer.port_b, HTR.from_comp_port_a) annotation(
      Line(points = {{13, -80}, {41, -80}, {41, -63}}, color = {0, 127, 255}));
    connect(splitter.gamma_port_b, reCompressor.port_a) annotation(
      Line(points = {{-50, -38}, {-50, -15}}, color = {0, 127, 255}));
    connect(mainCompressor.port_b, LTR.from_comp_port_a) annotation(
      Line(points = {{-70, 48}, {-4, 48}, {-4, -36}}, color = {0, 127, 255}));
    connect(splitter.one_gamma_port_b, cooler.port_a) annotation(
      Line(points = {{-58, -44}, {-91, -44}, {-91, -41}}, color = {0, 127, 255}));
    connect(exchanger.CO2_port_a, HTR.from_comp_port_b) annotation(
      Line(points = {{49.5, -36}, {49.5, -19}}, color = {0, 127, 255}));
    connect(cooler.port_b, mainCompressor.port_a) annotation(
      Line(points = {{-91, 1}, {-91, 25}}, color = {0, 127, 255}));
    connect(exchanger.CO2_port_b, turbine.port_a) annotation(
      Line(points = {{50, 19}, {50, 32}}, color = {0, 127, 255}));
    connect(turbine.port_b, HTR.from_turb_port_a) annotation(
      Line(points = {{70, 55}, {140, 55}, {140, -44}, {59, -44}}, color = {0, 127, 255}));
    connect(reCompressor.port_b, mixer.second_port_a) annotation(
      Line(points = {{-30, 8}, {-20, 8}, {-20, -80}, {-5, -80}}, color = {0, 127, 255}));
    connect(source.ports[1], exchanger.HTF_port_a) annotation(
      Line(points = {{88, 11.5}, {100, 11.5}}, color = {0, 127, 255}));
    connect(sink.ports[1], exchanger.HTF_port_b) annotation(
      Line(points = {{88, -11.5}, {88, -20}, {100, -20}}, color = {0, 127, 255}));
    connect(cooler.T_amb, T_amb.y);
    connect(m_sup, exchanger.m_sup);
    connect(m_sup, cooler.m_sup);
    m_sup = exchanger.HTF_port_a.m_flow >= exchanger.m_HTF_des * nu_min;
    if m_sup then
      turbine.p_out = mainCompressor.p_out / PR;
    else
      exchanger.CO2_port_a.m_flow = exchanger.m_CO2_des;
    end if;
    eta_cycle = W_net / exchanger.Q_HX;
    der(E_net) = W_net;
    W_net = if m_sup then (-turbine.W_turb) - mainCompressor.W_comp - reCompressor.W_comp - cooler.P_cooling else 0;
    annotation(
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
  end PBTestRig;

  model PBTestRig2
    extends SolarTherm.Media.CO2.PropCO2;
    import Modelica.SIunits.Conversions.*;
    import SI = Modelica.SIunits;
    replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
    replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
    parameter SI.Power P_net = 100e6;
    parameter SI.Power P_gross = 111e6;
    parameter SI.Temperature T_in_ref_blk = from_degC(800);
    parameter SI.Temperature blk_T_amb_des = from_degC(45);
    parameter SI.Temperature T_comp_in = from_degC(41);
    parameter Real nu_min_blk = 0.5;
    parameter Real f_fixed_load = 0;
    parameter Real eta_motor = 1;
    Modelica.Blocks.Sources.RealExpression T_amb_des(y = from_degC(45)) annotation(
      Placement(visible = true, transformation(origin = {-76, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.BooleanExpression always_false annotation(
      Placement(visible = true, transformation(origin = {-76, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression always_zero annotation(
      Placement(visible = true, transformation(origin = {-76, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.recompPB recompPB(redeclare package MedRec = MedRec, P_gro = P_gross, T_HTF_in_des = T_in_ref_blk, T_amb_des = blk_T_amb_des, T_low = T_comp_in, external_parasities = false, nu_min = nu_min_blk, N_exch = 5 "PG", N_LTR = 15, f_fixed_load = f_fixed_load, eta_motor = eta_motor) annotation(
      Placement(visible = true, transformation(origin = {-2, -12}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
    Modelica.Fluid.Sources.MassFlowSource_T source(T = from_degC(720), m_flow = 1200, nPorts = 1, redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {-90, 5.5}, extent = {{14, -14}, {-14, 14}}, rotation = 180)));
    Modelica.Fluid.Sources.FixedBoundary sink(nPorts = 1, redeclare package Medium = MedRec) annotation(
      Placement(visible = true, transformation(origin = {-92, -54}, extent = {{13, 13}, {-13, -13}}, rotation = 180)));
  equation
    connect(always_false.y, recompPB.ramping) annotation(
      Line(points = {{-64, 40}, {-2, 40}, {-2, 12}, {-2, 12}}, color = {255, 0, 255}));
    connect(T_amb_des.y, recompPB.T_amb) annotation(
      Line(points = {{-64, 24}, {-10, 24}, {-10, 12}, {-10, 12}}, color = {0, 0, 127}));
    connect(always_zero.y, recompPB.parasities) annotation(
      Line(points = {{-64, 58}, {6, 58}, {6, 12}, {6, 12}}, color = {0, 0, 127}));
    connect(source.ports[1], recompPB.fluid_a) annotation(
      Line(points = {{-76, 6}, {-20, 6}, {-20, 2}, {-20, 2}}, color = {0, 127, 255}));
    connect(sink.ports[1], recompPB.fluid_b) annotation(
      Line(points = {{-79, -54}, {-26, -54}, {-26, -30}}, color = {0, 127, 255}));
    annotation(
      experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 1));
  end PBTestRig2;

  model test_interpolation_3D
    import SI = Modelica.SIunits;
    import Modelica.SIunits.Conversions.*;
    parameter SI.Temperature T_amb = 275.661111111;
    parameter SI.HeatFlowRate Q_in = 100e6;
    parameter Integer table_number = 11;
    parameter SI.Temperature T_cold_in = 720;
    parameter SI.Temperature T_cold_in_set[table_number] = linspace(730, 830, table_number);
    parameter Real step = T_cold_in_set[2] - T_cold_in_set[1];
    // Combitable2D params
    parameter String table_name = "mdot";
    parameter String[table_number] tablefile = {Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_730.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_740.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_750.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_760.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_770.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_780.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_790.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_800.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_810.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_820.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_830.motab")};
    // Instantiation of table_number combi table 2Ds
    Modelica.Blocks.Tables.CombiTable2D mdot_730(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[1]) annotation(
      Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable2D mdot_740(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[2]) annotation(
      Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable2D mdot_750(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[3]) annotation(
      Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable2D mdot_760(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[4]) annotation(
      Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable2D mdot_770(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[5]) annotation(
      Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable2D mdot_780(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[6]) annotation(
      Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable2D mdot_790(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[7]) annotation(
      Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable2D mdot_800(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[8]) annotation(
      Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable2D mdot_810(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[9]) annotation(
      Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable2D mdot_820(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[10]) annotation(
      Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
    Modelica.Blocks.Tables.CombiTable2D mdot_830(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[11]) annotation(
      Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
    // Variables
    Integer index[2](start = fill(0, 2));
    Real table_1D[table_number];
    Real weight_table[table_number];
    Real weight_val;
    Real iter_weight;
    Real T_cold_low;
    Real T_cold_high;
    Integer index_1;
    Integer index_2;
    SI.MassFlowRate mdot;
  algorithm
// Creating a 1-D table for given Q_in and T_amb
    mdot_730.u1 := Q_in;
    mdot_730.u2 := T_amb;
    table_1D[1] := mdot_730.y;
    mdot_740.u1 := Q_in;
    mdot_740.u2 := T_amb;
    table_1D[2] := mdot_740.y;
    mdot_750.u1 := Q_in;
    mdot_750.u2 := T_amb;
    table_1D[3] := mdot_750.y;
    mdot_760.u1 := Q_in;
    mdot_760.u2 := T_amb;
    table_1D[4] := mdot_760.y;
    mdot_770.u1 := Q_in;
    mdot_770.u2 := T_amb;
    table_1D[5] := mdot_770.y;
    mdot_780.u1 := Q_in;
    mdot_780.u2 := T_amb;
    table_1D[6] := mdot_780.y;
    mdot_790.u1 := Q_in;
    mdot_790.u2 := T_amb;
    table_1D[7] := mdot_790.y;
    mdot_800.u1 := Q_in;
    mdot_800.u2 := T_amb;
    table_1D[8] := mdot_800.y;
    mdot_810.u1 := Q_in;
    mdot_810.u2 := T_amb;
    table_1D[9] := mdot_810.y;
    mdot_820.u1 := Q_in;
    mdot_820.u2 := T_amb;
    table_1D[10] := mdot_820.y;
    mdot_830.u1 := Q_in;
    mdot_830.u2 := T_amb;
    table_1D[11] := mdot_830.y;
// Checking in between which index the T_cold_in lies
    for i in 1:table_number loop
      weight_val := abs(T_cold_in - T_cold_in_set[i]) / step;
      if weight_val > 0 and weight_val <= 1 then
        weight_table[i] := weight_val;
      elseif weight_val == 0 then
        weight_table[i] := 1e-2 "make sure there is no 0 in the weight table to avoid confusion of the solver";
      else
        weight_table[i] := -1000;
      end if;
    end for;
// Take the index
    for i in 1:table_number loop
      iter_weight := weight_table[i];
      if iter_weight >= 0 and iter_weight <= 1 then
        if index[1] == 0 then
          index[1] := i;
        elseif index[1] >= 0 then
          index[2] := i;
        end if;
      end if;
    end for;
// Interpolate
    index_1 := index[1];
    index_2 := index[2];
    T_cold_low := if T_cold_in < T_cold_in_set[1] or T_cold_in > T_cold_in_set[end] then T_cold_in_set[1] else T_cold_in_set[index_1];
    T_cold_high := if T_cold_in < T_cold_in_set[1] or T_cold_in > T_cold_in_set[end] then T_cold_in_set[1] else T_cold_in_set[index_2];
    if Q_in >= 100e6 then
      if T_cold_in < T_cold_in_set[1] then
        mdot := table_1D[1] - (table_1D[2] - table_1D[1]) / (T_cold_in_set[2] - T_cold_in_set[1]) * (T_cold_in_set[1] - T_cold_in) "possibility of having extrapolation == linear";
      elseif T_cold_in > T_cold_in_set[table_number] then
        mdot := table_1D[table_number] + (table_1D[end] - table_1D[end - 1]) / (T_cold_in_set[end] - T_cold_in_set[end - 1]) * (T_cold_in - T_cold_in_set[end]) "possibility of having extrapolation == linear";
      else
        mdot := (T_cold_in - T_cold_low) / (T_cold_high - T_cold_low) * (table_1D[index_2] - table_1D[index_1]) + table_1D[index_1];
      end if;
    else
      mdot := 0;
    end if;
    annotation(
      experiment(StartTime = 0, StopTime = 70, Tolerance = 1e-06, Interval = 0.002));
  end test_interpolation_3D;

  model linprog
    parameter String filepathDNI = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab");
    parameter String filepathPrice = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014_hourly_manipulated.motab") "Electricity price file";
    parameter Integer horison = 24;
    parameter Real dt = 1;
    parameter Real etaC = 0.6;
    parameter Real etaG = 0.4;
    parameter Real t_stg = 14.;
    parameter Real DEmax = 120 / 0.4;
    parameter Real SLmax = t_stg * DEmax;
    parameter Real SLinit = 0.2 * SLmax;
    parameter Real SLminrel = 0.1;
    parameter Real Ahelio = 900000.0;
    parameter Real const_t = -dt * 3600;
    Real optimalDispatch;
    Real counter(start = const_t);
    Real time_simul(start = 0);
  equation
    der(counter) = 1;
    when counter > 0 then
      time_simul = floor(time);
      optimalDispatch = SolarTherm.Utilities.LinProgFunc(filepathDNI, filepathPrice, horison, dt, time_simul, etaC, etaG, t_stg, DEmax, SLmax, SLinit, SLminrel, Ahelio);
      reinit(counter, const_t);
    end when;
    annotation(
      experiment(StartTime = 0, StopTime = 1e+06, Tolerance = 1e-06, Interval = 1));
  end linprog;

  model test_st_surrogate
    import SolarTherm.Utilities.SurrogateModelsMultiOutput.*;
    parameter Integer inputsize = 9;
    parameter Integer outputsize = 2;
    parameter Real[inputsize] X_max = {1.49954700e+08, 1.27315000e+03, 2.49995866e+07, 3.00000000e+00, 8.53110000e+02, 9.99900000e+01, 1.05000000e+00, 1.24450000e+03, 3.18150000e+02};
    parameter Real[inputsize] X_min = {1.01053953e+07, 1.02319000e+03, 2.40000109e+07, 2.74000000e+00, 7.98170000e+02, 2.00800000e+01, 5.00000000e-01, 9.15560000e+02, 2.63150000e+02};
    parameter Real out_max[outputsize] = {1.40015826, 3.26043832};
    parameter Real out_min[outputsize] = {0, 1.36126842e-20};
    parameter String saved_model_dir = "/home/philgun/Documents/codecodecode/codecodecode/ML/script/sCO2_Trained_Model/small-data/surrogate_model_0";
    Real out[outputsize];
    Real[inputsize] raw_input;
    //Initialisation of the session class
    STNeuralNetwork session = STNeuralNetwork(saved_model_dir);
  equation
    raw_input = {126664046.41, 1176.78, 24383286.53, 2.78, 817.38, 41.69, 0.98, 1119.17, 286.02};
    out = predict(session, raw_input, inputsize, outputsize, X_max, X_min, out_max, out_min);
    annotation(
      experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 1));
  end test_st_surrogate;

  model test_PID_surrogate
    import SolarTherm.Utilities.SurrogateModelsSingleOutput.*;
    parameter String saved_model_dir = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include/neural-network/trained-model/surrogate_PID_v1");
    STNeuralNetwork session = STNeuralNetwork(saved_model_dir) "Initialise the neural network session";
    parameter Real raw_input[input_size] = {18.125592, 44645303.510000, 842.574156, 1044.433130, 293.892870};
    parameter Real X_max[input_size] = {4.99840230e+01, 9.99735880e+08, 8.73149421e+02, 1.27313074e+03, 3.18143363e+02};
    parameter Real X_min[input_size] = {5.00281700e+00, 1.03123836e+06, 7.98173320e+02, 1.02328492e+03, 2.63159811e+02};
    parameter Real out_max = 4800.818978;
    parameter Real out_min = -1;
    parameter Integer input_size = 5;
    Real out;
  equation
    out = predict(session, raw_input, input_size, X_max, X_min, out_max, out_min);
  end test_PID_surrogate;

  model test_OTF_surrogate
    import SolarTherm.Utilities.Kriging_OnTheFly.*;
    import SolarTherm.Utilities.ANN_OnTheFly.*;
    /*This script is to test on the functionality of the on the fly surrogate models: Method Kriging and ANN*/
    parameter Real P_net = 3e7;
    parameter Real T_in_ref_blk = 1243.27;
    parameter Real p_high = 22707266.48;
    parameter Real PR = 2.98;
    parameter Real pinch_PHX = 23.67;
    parameter Real dTemp_HTF_PHX = 238.45;
    parameter Real load_base = 1;
    parameter Real T_amb_base = 39 + 273.15;
    parameter String base_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include") "Base path that points to which folder the C program is stored";
    parameter String SolarTherm_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm") "Base path that points to which sCO2 PB calculator model is stored";
    parameter Real eta_gross_base = 0.49991927091306 "*****eta_gross_base = sCO2SimonPB.eta_gross_design";
    parameter Real eta_Q_base = 0.9998537337387947 "*******eta_Q_base = sCO2SimonPB.eta_Q_design";
    parameter Integer inputsize = 3;
    parameter Integer outputsize = 2;
    parameter Real tolerance_kriging = 2.5e-3;
    //******************** Kriging
    Kriging_properties Kriging_variables = Kriging_properties(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, T_amb_base, eta_gross_base, eta_Q_base, base_path, SolarTherm_path, inputsize, outputsize, tolerance_kriging);
    //******************** ANN PB
    parameter Real tolerance_ANN = 1.5e-3;
    parameter Integer index_0 = 0;
    ANN_properties session_PB = ANN_properties(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, T_amb_base, eta_gross_base, eta_Q_base, index_0, base_path, SolarTherm_path, inputsize, outputsize, tolerance_ANN);
    //******************** ANN HX
    parameter Integer index_1 = 1;
    ANN_properties session_HX = ANN_properties(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, T_amb_base, eta_gross_base, eta_Q_base, index_1, base_path, SolarTherm_path, inputsize, outputsize, tolerance_ANN);
    Real[3] raw_inputs = {0.77, 1230, 283.15};
    Real eta_gross_kriging;
    Real eta_Q_kriging;
    Real eta_gross_ANN;
    Real eta_Q_ANN;
    Real deviation_eta_gross_kriging;
    Real deviation_eta_Q_kriging;
    Real deviation_eta_gross_ANN;
    Real deviation_eta_Q_ANN;
  equation
    deviation_eta_gross_kriging = OTF_Kriging_interpolate(Kriging_variables, raw_inputs, "eta_gross", "spherical");
    eta_gross_kriging = eta_gross_base - deviation_eta_gross_kriging;
    deviation_eta_Q_kriging = OTF_Kriging_interpolate(Kriging_variables, raw_inputs, "eta_Q", "spherical");
    eta_Q_kriging = eta_Q_base - deviation_eta_Q_kriging;
    deviation_eta_gross_ANN = OTF_ANN_predict(session_PB, raw_inputs, 0);
    eta_gross_ANN = eta_gross_base - deviation_eta_gross_ANN;
    deviation_eta_Q_ANN = OTF_ANN_predict(session_HX, raw_inputs, 1);
    eta_Q_ANN = eta_Q_base - deviation_eta_Q_ANN;
    annotation(
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
  end test_OTF_surrogate;

  model check_sCO2_props
    extends SolarTherm.Media.CO2.PropCO2;
    import Medium = SolarTherm.Media.CO2.CO2_ph;
    import SI = Modelica.SIunits;
    parameter SI.Pressure p_high = 25e6;
    SI.SpecificEnthalpy h;
    Medium.ThermodynamicState state;
    SI.ThermodynamicTemperature T;
  equation
    T = 41 + 273.15 - time;
    state = Medium.setState_pTX(p_high / 3.14, T);
    h = Medium.specificEnthalpy(state);
  end check_sCO2_props;

  model eval_particle_props
    replaceable package Medium = Media.SolidParticles.CarboHSP_ph;
    Medium.ThermodynamicState state;
    Modelica.SIunits.ThermodynamicTemperature T;
    Modelica.SIunits.SpecificHeatCapacity Cp;
    Modelica.SIunits.Density rho;
    Modelica.SIunits.DynamicViscosity mu;
    Modelica.SIunits.KinematicViscosity mu_k;
    Modelica.SIunits.ThermalConductivity k;
    Modelica.SIunits.SpecificEnthalpy h;
  equation
    T = 300 + 273.15 + time;
    state = Medium.setState_pTX(1e5, T);
    Cp = Medium.specificHeatCapacityCp(state);
    rho = Medium.density(state);
    mu = 1;
    mu_k = 1;
    k = Medium.thermalConductivity(state);
    h = Medium.specificEnthalpy(state);
  end eval_particle_props;
end Validation;