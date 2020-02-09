within SolarTherm.Validation.Models;

model TestSCO2PB_Zeb
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
  replaceable package Medium = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph "Medium props for Chloride Salt";
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
  // Storage
  parameter Real t_storage(unit = "h") = 14 "Hours of storage";
  parameter SI.Temperature T_cold_set(fixed = false) "Cold tank target temperature";
  parameter SI.Temperature T_hot_set = from_degC(735) "Hot tank target temperature";
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
  // Power block
  replaceable model Cycle = Models.PowerBlocks.Correlation.sCO2 "sCO2 cycle regression model";
  parameter SI.Temperature T_comp_in = from_degC(45) "Compressor inlet temperature at design";
  replaceable model Cooling = Models.PowerBlocks.Cooling.DryCooling "PB cooling model";
  parameter SI.Power P_gross(fixed = if fixed_field then false else true) = 111e6 "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.502 "Power block efficiency at design point";
  parameter Real par_fr = 0.099099099 "Parasitics fraction of power block rating at design point";
  parameter Real par_fix_fr = 0.0055 "Fixed parasitics as fraction of gross rating";
  parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";
  parameter Boolean external_parasities = false "True if there is external parasitic power losses";
  parameter Real nu_min_blk = 0.5 "Minimum allowed part-load mass flow fraction to power block";
  parameter SI.Power W_base_blk = par_fix_fr * P_gross "Power consumed at all times in power block";
  parameter SI.AbsolutePressure p_blk = 25e6 "high pressure of the cycle";
  parameter SI.Temperature blk_T_amb_des = from_degC(43) "Ambient temperature at design for power block";
  parameter SI.Temperature par_T_amb_des = 298.15 "Ambient temperature at design point";
  parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
  parameter SI.Temperature T_in_ref_blk = from_degC(735) "Particle inlet temperature to particle heat exchanger at design";
  parameter SI.Temperature T_out_ref_blk(fixed = false) "Particle outlet temperature from particle heat exchanger at design";
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
  parameter SI.Power P_net = (1 - par_fr) * P_gross "Power block net rating at design point";
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
    Placement(visible = true, transformation(origin = {123, 86}, extent = {{-15, -12}, {15, 12}}, rotation = 180)));
  // Or block for defocusing
  //Sun
  // Solar field
  // Receiver
  // Hot tank
  // Cold tank
  // Receiver lift
  // Pump Hot
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(redeclare package Medium = Medium, k_loss = k_loss_hot) annotation(
    Placement(transformation(origin = {74, 44}, extent = {{0, 0}, {12, 12}})));
  // Temperature sensor
  // PowerBlockControl
  // ReceiverControl
  // Power block
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.recompPB powerBlock(redeclare package MedRec = Medium, E_net(displayUnit = ""), P_gro = P_gross, T_amb_des = blk_T_amb_des, T_low = from_degC(36), eta_turb = 0.90, external_parasities = false, nu_min = nu_min_blk) annotation(
    Placement(visible = true, transformation(extent = {{84, 6}, {120, 44}}, rotation = 0)));
  // Price
  SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
    Placement(visible = true, transformation(extent = {{138, 14}, {158, 34}}, rotation = 0)));
  SolarTherm.Models.Sources.Schedule.Scheduler sch if not const_dispatch;
  // Variables:
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
  Modelica.Blocks.Sources.RealExpression m_flow_in(y = 1000) annotation(
    Placement(visible = true, transformation(origin = {125, 125}, extent = {{22, 11}, {-22, -11}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink fluidSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {17, 17}, extent = {{19, -19}, {-19, 19}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary(redeclare package Medium = Medium, nPorts = 1, p = 101325, use_T_in = true) annotation(
    Placement(visible = true, transformation(origin = {12, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 300) annotation(
    Placement(visible = true, transformation(origin = {19, 99}, extent = {{-15, -13}, {15, 13}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression T_in(y = 500 + 273.15 + time) annotation(
    Placement(visible = true, transformation(origin = {-40, 54}, extent = {{-24, -14}, {24, 14}}, rotation = 0)));
initial equation
  if fixed_field then
    P_gross = Q_flow_des * eff_cyc;
  else
    R_des = if match_sam then SM * Q_flow_des * (1 + rec_fr) else SM * Q_flow_des / (1 - rec_fr);
  end if;
  T_cold_set = powerBlock.exchanger.T_HTF_des[1];
  T_cold_set = T_out_ref_blk;
  C_block = powerBlock.C_PB;
  C_cap = (C_field + C_site + C_receiver + C_storage + C_block + C_bop) * (1 + r_contg) * (1 + r_indirect) * (1 + r_cons) + C_land;
equation
//Connections from data
// Fluid connections
  connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{78, 50}, {86, 50}, {86, 31}, {94, 31}}, color = {0, 127, 255}));
// controlCold connections
//	connect(heliostatsField.on, receiver.on) annotation(
//		Line(points = {{-31.24, 5.44}, {-44, 5.44}, {-44, -18}, {-72, -18}, {-72, -36}, {28, -36}, {28, -6}, {24.7, -6}, {24.7, -7.2}}, color = {255, 0, 255}));
// controlHot connections
//Solar field connections i.e. solar.heat port and control
//PowerBlock connections
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{106, 86}, {106, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{111, 24}, {138, 24}}, color = {0, 0, 127}));
  P_elec = powerBlock.W_net;
  der(E_elec) = P_elec;
  R_spot = market.profit;
  connect(m_flow_in.y, pumpHot.m_flow) annotation(
    Line(points = {{101, 125}, {80, 125}, {80, 56}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(powerBlock.fluid_b, fluidSink.port_a) annotation(
    Line(points = {{92, 17}, {36, 17}}, color = {0, 127, 255}));
  connect(boundary.ports[1], pumpHot.fluid_a) annotation(
    Line(points = {{22, 50}, {74, 50}, {74, 50}, {74, 50}}, color = {0, 127, 255}));
  connect(T_in.y, boundary.T_in) annotation(
    Line(points = {{-14, 54}, {0, 54}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tamb.y, powerBlock.T_amb) annotation(
    Line(points = {{36, 100}, {98, 100}, {98, 36}, {98, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
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
end TestSCO2PB_Zeb;