within SolarTherm.Systems.Small_Scale_CSP;

model Small_Scale_Dish_system_200kW
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
  //Free Parameters
  //**********************
  parameter Real SM = 1.6 "Solar multiple";
  parameter Real t_storage(unit = "h") = 6.0 "Hours of storage";
  //Packages
  //**********************
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph "Medium props for molten salt";
  //Replaceable Models
  //**********************
  replaceable model Cycle = SolarTherm.Models.PowerBlocks.Correlation.sCO2NREL_200kWe_574C_290C;
  replaceable model Cooling = SolarTherm.Models.PowerBlocks.Cooling.NoCooling "PB cooling model";
  //Imported Files
  //**********************
  parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
  parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not const_dispatch "Discharging schedule from a file";
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab") "Weather file";
  parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/dish.motab") "Optical efficiency lookup table file";
  //Settings
  //**********************
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  parameter Boolean const_dispatch = true "Constant dispatch of energy";
  parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";
  parameter Boolean external_parasities = true "true if there is external parasitic power losses";
  //Design Values
  //**********************
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold salt thermodynamic state at design";
  //Temperatures
  parameter SI.Temperature T_cold_set = CV.from_degC(290) "Cold tank target temperature";
  parameter SI.Temperature T_hot_set = CV.from_degC(574) "Hot tank target temperature";
  parameter SI.Temperature T_cold_start = CV.from_degC(290) "Cold tank starting temperature";
  parameter SI.Temperature T_hot_start = CV.from_degC(574) "Hot tank starting temperature";
  parameter SI.Temperature T_cold_aux_set = CV.from_degC(270) "Cold tank auxiliary heater set-point temperature";
  parameter SI.Temperature T_hot_aux_set = CV.from_degC(500) "Hot tank auxiliary heater set-point temperature";
  parameter SI.Temperature T_amb_des = CV.from_degC(35) "Design ambient temperature";
  //Specific Enthalpies
  //**********
  parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";
  //Mass Flow Rates
  //***********
  parameter SI.MassFlowRate m_flow_PB_des = Q_PB_in_des / (h_hot_set - h_cold_set) "Mass flow rate to power block at design point";
  parameter SI.MassFlowRate m_flow_recv_des = SM * Q_PB_in_des / (h_hot_set - h_cold_set) "Mass flow rate to receiver at design point";
  //Power Block
  //**********
  parameter Real par_fr = 0.01 "Parasitics fraction of power block rating at design point";
  parameter Real par_fix_fr = 0.0055 "Fixed parasitics as fraction of gross rating";
  parameter Real nu_net_blk = 0.90 "Gross to net power conversion factor at the power block";
  parameter SI.Power P_name = 200.0e3 "Nameplate rating of power block";
  parameter SI.Power P_gross = P_name * (1 + par_fr) / (nu_net_blk - par_fix_fr) "Power block gross rating at design point";
  parameter Real eff_PB_gross_des = 0.2941 "Design gross efficiency of PB";
  parameter SI.HeatFlowRate Q_PB_in_des = P_gross / eff_PB_gross_des "Design PB heat input rate";
  //Storage
  //**********
  //parameter Real eff_stor_des = SM*Q_PB_in_des/(Q_PB_in_des+Q_tank_loss_des) "Storage thermal efficiency";
  parameter SI.HeatFlowRate Q_tank_loss_des = 0.5 * U_loss_tank * CN.pi * D_storage * H_storage * (T_hot_set + T_cold_set - 2 * T_amb_des) "Estimated tank heat loss";
  //Receiver
  //***********
  parameter SI.Efficiency ab_rec = 0.96 "Receiver coating absorptance";
  parameter SI.Efficiency em_rec = 0.85 "Receiver coating emissivity";
  parameter Real sigma = 5.670374419e-8 "Stefan-Boltzmann constant (W/(m2K4))";
  parameter SI.HeatFlowRate Q_recv_out_des = SM * (Q_PB_in_des + Q_tank_loss_des) "Design receiver output heat rate";
  parameter SI.HeatFlowRate Q_recv_loss_des = sigma * A_receiver * em_rec * ((0.5 * T_hot_set + 0.5 * T_cold_set) ^ 4 - T_amb_des ^ 4) "Design receiver heat loss rate";
  parameter SI.HeatFlowRate Q_recv_inc_des = (Q_recv_out_des - Q_recv_loss_des) / ab_rec "Design receiver incident heat rate";
  //Collector
  //***********
  parameter Real he_av_design = 1.00 "Dish availability";
  parameter Real eff_opt_des = 0.87071 "Design optical efficiency";
  parameter SI.HeatFlowRate Q_coll_inc_des = Q_recv_inc_des / (eff_opt_des * he_av_design) "Design collector incident";
  parameter SI.Irradiance dni_des = 950 "DNI at design point";
  parameter Real C = 2498 "Concentration ratio";
  parameter SI.Area A_field = 0.00137896 * Q_recv_out_des + 0.00468607 "Linear fit";
  parameter SI.Area A_receiver = A_field / C "Receiver Area";
  parameter Integer n_heliostat = 1 "Number of heliostats";
  parameter SI.Area A_heliostat = A_field / n_heliostat "Heliostat area";
  parameter SI.Energy helio_E_start = 90e3 * (A_heliostat / 148.84) "Start-up energy of a single heliostat";
  parameter SI.Power helio_W_track = 0.055e3 * (A_heliostat / 148.84) "Tracking power for a single heliostat";
  //Components
  //**********************
  // Weather data
  parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";
  parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 2019 "Meteorological year";
  // Field
  parameter Solar_angles angles = Solar_angles.ele_azi "Angles used in the lookup table file";
  parameter Real land_mult = 1.5 "Land area multiplier";
  // Receiver
  parameter Integer N_pa_rec = 20 "Number of panels in receiver";
  parameter SI.Thickness t_tb_rec = 1.25e-3 "Receiver tube wall thickness";
  parameter SI.Diameter D_tb_rec = 40e-3 "Receiver tube outer diameter";
  parameter SI.Diameter D_receiver = sqrt(4.0 * A_receiver / CN.pi) "Receiver diameter";
  parameter SI.Length H_receiver = 0.0 "Receiver height";
  // Storage
  parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
  parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
  parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 1.00 "Tank constant heat transfer coefficient with ambient (W/m2K)";
  parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold pump parasitic power coefficient";
  parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot pump parasitic power coefficient";
  parameter SI.Power W_heater_hot = 30e8 "Hot tank heater capacity";
  parameter SI.Power W_heater_cold = 30e8 "Cold tank heater capacity";
  parameter Real tank_ar = 20 / 18.667 "storage aspect ratio";
  // Power block
  parameter Real nu_min_blk = 0.5 "minimum allowed part-load mass flow fraction to power block";
  parameter SI.Power W_base_blk = par_fix_fr * P_gross "Power consumed at all times in power block";
  parameter SI.AbsolutePressure p_blk = 25e6 "Power block operating pressure";
  parameter SI.Temperature T_in_ref_blk = from_degC(574) "HTF inlet temperature to power block at design";
  parameter SI.Temperature T_out_ref_blk = from_degC(290) "HTF outlet temperature to power block at design";
  // Control
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
  parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
  parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
  parameter SI.HeatFlowRate Q_flow_defocus = Q_PB_in_des;
  //Unused
  parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
  parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
  parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
  parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real hot_tnk_empty_ub = 10 "Hot tank empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real hot_tnk_full_lb = 96 "Hot tank full trigger lower bound, 96";
  parameter Real hot_tnk_full_ub = 99 "Hot tank full trigger upper bound, 99";
  parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real cold_tnk_crit_lb = 5 "Cold tank critically empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound";
  // Level (above which) to start disptach
  //1000*(SM/1.8) "Gain of proportional component in receiver control" ;
  // Calculated Parameters
  parameter SI.Energy E_max = 1.0 * t_storage * 3600 * Q_PB_in_des "Maximum tank stored energy";
  parameter SI.Area A_land = land_mult * A_field "Land area";
  parameter SI.Density rho_cold_set = Medium.density(state_cold_set) "Cold salt density at design";
  parameter SI.Density rho_hot_set = Medium.density(state_hot_set) "Hot salt density at design";
  parameter SI.Mass m_max = E_max / (h_hot_set - h_cold_set) "Max salt mass in tanks";
  parameter SI.Volume V_max = m_max / ((rho_hot_set + rho_cold_set) / 2) "Max salt volume in tanks";
  parameter SI.Length H_storage = (4 * V_max * tank_ar ^ 2 / CN.pi) ^ (1 / 3) "Storage tank height";
  parameter SI.Diameter D_storage = H_storage / tank_ar "Storage tank diameter";
  parameter SI.Length H_tower = 0 "tower height set to 0 for dish system";
  parameter SI.Diameter D_tower = 0 "Tower diameter set to 0 for dish system";
  // That's a fair estimate. An accurate H-to-D correlation may be used.
  // Cost data in USD (default) or AUD
  parameter Real r_disc = 0.07 "Real discount rate";
  parameter Real r_i = 0.025 "Inflation rate";
  parameter Integer t_life = 25 "Lifetime of plant (yr)";
  parameter Integer t_cons = 0 "Years of construction (yr)";
  parameter Real r_cur = 0.71 "The currency rate from AUD to USD";
  //Unused
  // Valid for 2019. See https://www.rba.gov.au/
  parameter Real f_Subs = 0 "Subsidies on initial investment costs";
  parameter FI.AreaPrice pri_field = 292.5 "250Euro/m2, 1E = 1.17USD";
  parameter FI.AreaPrice pri_site = 16.0;
  parameter FI.EnergyPrice pri_storage = 22.0 / (1e3 * 3600);
  //parameter FI.PowerPrice pri_block = 1040.0 / 1e3;
  parameter FI.PowerPrice pri_block = powerBlock.C_PB_total/P_gross;
  parameter FI.PowerPrice pri_bop = 290.0 / 1e3;
  parameter FI.AreaPrice pri_land = 2.47;
  parameter Real pri_om_name(unit = "$/W/year") = 66.0 / 1e3;
  parameter Real pri_om_prod(unit = "$/J/year") = 3.50 / (1e6 * 3600);
  parameter FI.Money C_receiver = 158.95 * (Q_recv_out_des / 1000.0) "Giostri 135E/kW";
  parameter FI.Money C_field = pri_field * A_field "Field cost";
  parameter FI.Money C_site = pri_site * A_field "Site improvements cost";
  parameter FI.Money C_tower(fixed = false) = 0.0 "Tower cost";
  // SAM 2018 cost data: 103e6 * (A_receiver / 1571) ^ 0.7
  parameter FI.Money C_storage = pri_storage * E_max "Storage cost";
  //parameter FI.Money C_block = pri_block * P_gross "Power block cost";
  parameter FI.Money C_block = powerBlock.C_PB_total "Power block cost";
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
    Placement(visible = true, transformation(extent = {{-138, -32}, {-108, -4}}, rotation = 0)));
  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(origin = {-129, 70}, extent = {{-9, -10}, {9, 10}}, rotation = 0)));
  //Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(origin = {125, 80}, extent = {{5, -10}, {-5, 10}}, rotation = 0)));
  //WindSpeed_input
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(visible = true, transformation(origin = {-125, 54}, extent = {{-7, -10}, {7, 10}}, rotation = 0)));
  //pressure_input
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(visible = true, transformation(origin = {62, 28}, extent = {{6, -10}, {-6, 10}}, rotation = 0)));
  //parasitic inputs
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold.W_loss + tankHot.W_loss + tankCold.W_loss) annotation(
    Placement(visible = true, transformation(origin = {108, 54}, extent = {{-7, -9}, {7, 9}}, rotation = -90)));
  // Or block for defocusing
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
  // Solar field (Edited 14/08/20 to include scaling of parasitics)
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(n_h = n_heliostat, lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_recv_inc_des, nu_start = nu_start, redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file), E_start = helio_E_start, W_track = helio_W_track) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
  // Receiver
  SolarTherm.Models.CSP.CRS.Receivers.PBS_Receiver receiver(em = em_rec, redeclare package Medium = Medium, H_rcv = H_receiver, D_rcv = D_receiver, N_pa = N_pa_rec, t_tb = t_tb_rec, D_tb = D_tb_rec, ab = ab_rec, A = A_receiver) annotation(
    Placement(transformation(extent = {{-46, 4}, {-10, 40}})));
  // Hot tank
  SolarTherm.Models.Storage.Tank.Tank tankHot(redeclare package Medium = Medium, D = D_storage, H = H_storage, T_start = T_hot_start, L_start = (1 - split_cold) * 100, alpha = U_loss_tank, use_p_top = tnk_use_p_top, enable_losses = tnk_enable_losses, use_L = true, W_max = W_heater_hot, T_set = T_hot_aux_set) annotation(
    Placement(visible = true, transformation(extent = {{12, 70}, {32, 90}}, rotation = 0)));
  // Pump hot
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(redeclare package Medium = Medium, k_loss = k_loss_hot) annotation(
    Placement(visible = true, transformation(extent = {{66, 62}, {78, 74}}, rotation = 0)));
  // Cold tank
  SolarTherm.Models.Storage.Tank.Tank tankCold(redeclare package Medium = Medium, D = D_storage, H = H_storage, T_start = T_cold_start, L_start = split_cold * 100, alpha = U_loss_tank, use_p_top = tnk_use_p_top, enable_losses = tnk_enable_losses, use_L = true, W_max = W_heater_cold, T_set = T_cold_aux_set) annotation(
    Placement(visible = true, transformation(extent = {{74, -30}, {54, -10}}, rotation = 0)));
  // Pump cold
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(redeclare package Medium = Medium, k_loss = k_loss_cold) annotation(
    Placement(transformation(extent = {{10, -30}, {-2, -18}})));
  // Temperature sensor
  SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{-14, 74}, {-4, 64}})));
  // PowerBlockControl
  // ReceiverControl
  // Power block
  SolarTherm.Models.PowerBlocks.SSCSP_PowerBlockModel_sCO2NREL_200kWe_574C_290C powerBlock(W_des = P_gross, enable_losses = blk_enable_losses, redeclare model Cycle = Cycle, nu_min = nu_min_blk, external_parasities = external_parasities, W_base = W_base_blk, p_bo = p_blk, T_des = T_amb_des, nu_net = nu_net_blk, T_in_ref = T_in_ref_blk, T_out_ref = T_out_ref_blk, Q_flow_ref = Q_PB_in_des, m_flow_ref = m_flow_PB_des, redeclare model Cooling = Cooling) annotation(
    Placement(transformation(extent = {{88, 4}, {124, 42}})));
  // Price
  SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
    Placement(visible = true, transformation(extent = {{128, 12}, {148, 32}}, rotation = 0)));
  // TODO Needs to be configured in instantiation if not const_dispatch. See SimpleResistiveStorage model
  SolarTherm.Models.Sources.Schedule.Scheduler sch if not const_dispatch;
  // Variables:
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
  SolarTherm.Models.Control.SSCSP_Controller SSCSP_Controller(redeclare package HTF = Medium, T_target = T_hot_set, m_flow_PB_des = m_flow_PB_des) annotation(
    Placement(visible = true, transformation(origin = {27, 11}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression False annotation(
    Placement(visible = true, transformation(origin = {-108, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Connections from data
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-119, 70}, {-102, 70}, {-102, 69.8}, {-82.6, 69.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-117, 54}, {-100, 54}, {-100, 29.54}, {-87.68, 29.54}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Pres_input.y, tankCold.p_top) annotation(
    Line(points = {{55, 28}, {59.5, 28}, {59.5, -10}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Pres_input.y, tankHot.p_top) annotation(
    Line(points = {{55, 28}, {8, 28}, {8, 90}, {26.5, 90}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, powerBlock.T_amb) annotation(
    Line(points = {{119.5, 80}, {102.4, 80}, {102.4, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, tankHot.T_amb) annotation(
    Line(points = {{119.5, 80}, {68.75, 80}, {68.75, 90}, {18, 90}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(receiver.Tamb, tankHot.T_amb) annotation(
    Line(points = {{-28, 36.04}, {-28, 90}, {18, 90}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(tankCold.T_amb, powerBlock.T_amb) annotation(
    Line(points = {{68, -10}, {68, 20}, {92, 20}, {92, 42}, {102.4, 42}, {102.4, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
// Fluid connections
  connect(pumpCold.fluid_a, tankCold.fluid_b) annotation(
    Line(points = {{10, -24.12}, {10, -27}, {54, -27}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
    Line(points = {{-24.4, 5.8}, {-14.2, 5.8}, {-14.2, -24}, {-2, -24}}, color = {0, 127, 255}));
  connect(receiver.fluid_b, temperature.fluid_a) annotation(
    Line(points = {{-21.88, 30.64}, {-21.88, 30}, {-20, 30}, {-16, 30}, {-16, 69}, {-14, 69}}, color = {0, 127, 255}));
  connect(temperature.fluid_b, tankHot.fluid_a) annotation(
    Line(points = {{-4, 69}, {2, 69}, {2, 85}, {12, 85}}, color = {0, 127, 255}));
  connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{32, 73}, {32, 68}, {66, 68}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{78, 68}, {86, 68}, {86, 29.46}, {98.08, 29.46}}, color = {0, 127, 255}));
  connect(powerBlock.fluid_b, tankCold.fluid_a) annotation(
    Line(points = {{95.56, 14.64}, {74, 14.64}, {74, -15}}, color = {0, 127, 255}));
// controlCold connections
// controlHot connections
//Solar field connections i.e. solar.heat port and control
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-72, 60}, {-72, 36}}, color = {255, 128, 0}));
  connect(heliostatsField.heat, receiver.heat) annotation(
    Line(points = {{-55.68, 27.5}, {-54.82, 27.5}, {-54.82, 27.4}, {-46, 27.4}}, color = {191, 0, 0}));
//PowerBlock connections
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{108, 46}, {108, 40.85}, {109.6, 40.85}, {109.6, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{115.18, 22.05}, {119.59, 22.05}, {119.59, 22}, {128, 22}}, color = {0, 0, 127}));
  P_elec = powerBlock.W_net;
  E_elec = powerBlock.E_net;
  R_spot = market.profit;
  connect(SSCSP_Controller.defocus, receiver.defocus) annotation(
    Line(points = {{34, 8}, {40, 8}, {40, -16}, {-44, -16}, {-44, 18}, {-34, 18}, {-34, 18}}, color = {255, 0, 255}));
  connect(receiver.Q_rcv_raw, SSCSP_Controller.Q_rcv_raw) annotation(
    Line(points = {{-24, 18}, {10, 18}, {10, 16}, {20, 16}, {20, 16}}, color = {0, 0, 127}));
  connect(SSCSP_Controller.Q_defocus, receiver.Q_defocus) annotation(
    Line(points = {{20, 4}, {-4, 4}, {-4, 12}, {-24, 12}, {-24, 12}}, color = {0, 0, 127}));
  connect(tankHot.L, SSCSP_Controller.Level_Hot) annotation(
    Line(points = {{32, 84}, {38, 84}, {38, 34}, {14, 34}, {14, 12}, {20, 12}, {20, 12}}, color = {0, 0, 127}));
  connect(SSCSP_Controller.m_flow_recv, pumpCold.m_flow) annotation(
    Line(points = {{34, 16}, {46, 16}, {46, -12}, {4, -12}, {4, -18}, {4, -18}}, color = {0, 0, 127}));
  connect(SSCSP_Controller.m_flow_PB, pumpHot.m_flow) annotation(
    Line(points = {{34, 12}, {52, 12}, {52, 76}, {72, 76}, {72, 74}, {72, 74}}, color = {0, 0, 127}));
  connect(tankCold.h_fluid, SSCSP_Controller.h_tank_outlet) annotation(
    Line(points = {{54, -20}, {48, -20}, {48, 26}, {24, 26}, {24, 18}, {24, 18}}, color = {0, 0, 127}));
  connect(False.y, heliostatsField.defocus) annotation(
    Line(points = {{-96, 8}, {-90, 8}, {-90, 8}, {-88, 8}}, color = {255, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(origin = {-2, 16}, lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 9), Text(lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 9), Text(origin = {-2, 0}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 16, fontName = "CMU Serif"), Text(origin = {-2, 2}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostat", fontSize = 16, fontName = "CMU Serif"), Text(origin = {4, -8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 16, fontName = "CMU Serif"), Text(origin = {-2, 2}, extent = {{0, 58}, {48, 38}}, textString = "Hot Tank", fontSize = 16, fontName = "CMU Serif"), Text(origin = {2, 0}, extent = {{30, -24}, {78, -44}}, textString = "Cold Tank", fontSize = 16, fontName = "CMU Serif"), Text(origin = {4, 0}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 16, fontName = "CMU Serif"), Text(origin = {2, 30}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 16, fontName = "CMU Serif"), Text(origin = {6, -2}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 18, fontName = "CMU Serif"), Text(extent = {{-96, -12}, {-96, -12}}, textString = "Field", fontSize = 18), Text(origin = {-93, -13}, extent = {{-7, 5}, {17, -3}}, textString = "Field", fontSize = 16), Text(origin = {20, -1}, extent = {{-8, 1}, {20, -3}}, textString = "Control", fontSize = 16)}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
        <ul>
        <li> Zebedee Kee (Jan 2021) :<br>Released first version. </li>
        </ul>
        </html>"),
    uses(SolarTherm(version = "0.2"), Modelica(version = "3.2.3")));
end Small_Scale_Dish_system_200kW;