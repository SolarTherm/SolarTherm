within examples;

model PhysicalParticleSystem1D
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Solar_angles;
  import SolarTherm.Types.Currency;
  import Modelica.Math;
  extends Modelica.Icons.Example;
  //TODO Incorporate Modelica HX model
  //TODO Use Coolprop for SCO2 props
  //TODO Re-train the sCO2 cycle for the particle medium and new setpoint temperatures
  //TODO fix Carbo HSP properties so there are never imaginary roots when solving for T.
  // Input Parameters
  // *********************
  parameter Boolean match_sam = false "Configure to match SAM output";
  parameter Boolean fixed_field = true "true if the size of the solar field is fixed";
  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
  //TODO add a new medium for sCO2
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
  //parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/g3p3_opt_eff_1.motab"); //Variable optical efficiency
  parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/g3p3_opt_eff_const.motab");
  //Constant optical efficiency
  parameter Solar_angles angles = Solar_angles.ele_azi "Angles used in the lookup table file";
  parameter Real SM(fixed = false) "Solar multiple";
  parameter Real land_mult = 0 "Land area multiplier";
  parameter Boolean polar = true "True for polar field layout, otherwise surrounded";
  parameter SI.Area A_heliostat = 100 "Heliostat module reflective area";
  parameter Real he_av_design = 1.00 "Helisotats availability ";
  // FIXME should be 0.99 or so
  parameter SI.Efficiency eff_opt(fixed = false) "Field optical efficiency at design point";
  parameter SI.Irradiance dni_des = 788.8 "DNI at design point";
  parameter Real C = 1200 "Instantaneous area-average flux concentration ratio";
  //Definition from Lifeng Li et al. (2016) "Optics of solar central receiver systems: a review"
  parameter Real gnd_cvge = 0.3126 "Ground coverage";
  parameter Real excl_fac = 0.97 "Exclusion factor";
  parameter Real twr_ht_const = if polar then 2.25 else 1.25 "Constant for tower height calculation";
  // Receiver
  parameter Real ar_rec = 1 "Height to diameter aspect ratio of receiver aperture";
  parameter SI.Efficiency em_curtain = 0.86 "Emissivity of curtain";
  parameter SI.Efficiency ab_curtain = 0.98 "Absorptivity of curtain";
  parameter Real em_particle = 0.86 "Emissivity of particles";
  parameter Real ab_particle = 0.93 "Absorptivity of curtain";
  parameter SI.CoefficientOfHeatTransfer h_th_rec = 100 "Receiver heat tranfer coefficient, make it inner so it can be accessed by every component inside the system";
  parameter SI.RadiantPower R_des(fixed = false) "Input power to receiver at design point";
  parameter SI.HeatFlowRate Q_rec_des(fixed = false) "Receiver net thermal power (heat into particles) at design point";
  // FIXME clarify the definition of this one:
  //parameter Real rec_fr = 0.0 "Receiver loss fraction of radiance at design point";
  inner parameter SI.Efficiency eta_rec_th_des = 0.8568 "PG Receiver thermal efficiency (Q_pcl / Q_sol)";
  parameter SI.Temperature rec_T_amb_des = 298.15 "Ambient temperature at design point";
  parameter Real f_loss = 0.000001 "Fraction of particles flow lost in receiver";
  // Storage
  parameter Real t_storage(unit = "h") = 14 "Hours of storage";
  parameter Real NS_particle = 0.05 "Fraction of additional non-storage particles";
  parameter SI.Temperature T_cold_set = CV.from_degC(580.3) "Cold tank target temperature";
  parameter SI.Temperature T_hot_set = CV.from_degC(800) "Hot tank target temperature";
  parameter SI.Temperature T_cold_start = CV.from_degC(580.3) "Cold tank starting temperature";
  parameter SI.Temperature T_hot_start = CV.from_degC(800) "Hot tank starting temperature";
  parameter SI.Temperature T_cold_aux_set = CV.from_degC(500) "Cold tank auxiliary heater set-point temperature";
  parameter SI.Temperature T_hot_aux_set = CV.from_degC(700) "Hot tank auxiliary heater set-point temperature";
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold partilces thermodynamic state at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hot partilces thermodynamic state at design";
  parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
  parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";
  parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
  parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
  parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
  parameter SI.CoefficientOfHeatTransfer alpha = 3 "Tank constant heat transfer coefficient with ambient";
  parameter SI.Power W_heater_hot = 0 "Hot tank heater capacity";
  parameter SI.Power W_heater_cold = 0 "Cold tank heater capacity";
  parameter Real tank_ar = 2 "storage aspect ratio";
  // Particle heat exchanger
  parameter SI.CoefficientOfHeatTransfer U_hx = 450 "Particle heat tranfer coefficient of the particle heat exchanger";
  parameter SI.Temperature dT_approach_hx = 15 "Particle heat exchanger approach temperature";
  // Power block
  replaceable model Cycle = Models.PowerBlocks.Correlation.sCO2 "sCO2 cycle regression model";
  parameter SI.Temperature T_comp_in = 318.15 "Compressor inlet temperature at design";
  replaceable model Cooling = Models.PowerBlocks.Cooling.DryCooling "PB cooling model";
  parameter SI.Power P_gross(fixed = false) "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.5023 "Power block efficiency at design point";
  parameter Real par_fr = 0 "Parasitics fraction of power block rating at design point";
  parameter Real par_fix_fr = 0 "Fixed parasitics as fraction of gross rating";
  parameter Boolean blk_enable_losses = true "True if the power heat loss calculation is enabled";
  parameter Boolean external_parasities = true "True if there is external parasitic power losses";
  parameter Real nu_min_blk = 0.5 "Minimum allowed part-load mass flow fraction to power block";
  parameter SI.Power W_base_blk = par_fix_fr * P_gross "Power consumed at all times in power block";
  parameter SI.AbsolutePressure p_blk = 10e6 "Power block operating pressure";
  parameter SI.Temperature blk_T_amb_des = 316.15 "Ambient temperature at design for power block";
  parameter SI.Temperature par_T_amb_des = 298.15 "Ambient temperature at design point";
  parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
  parameter SI.Temperature T_in_ref_blk = from_degC(800) "Particle inlet temperature to particle heat exchanger at design";
  parameter SI.Temperature T_out_ref_blk = from_degC(580.3) "Particle outlet temperature from particle heat exchanger at design";
  parameter SI.Temperature T_in_ref_co2 = CV.from_degC(565.3) "CO2 inlet temperature to particle heat exchanger at design";
  parameter SI.Temperature T_out_ref_co2 = CV.from_degC(715) "CO2 outlet temperature from particle heat exchanger at design";
  parameter Medium.ThermodynamicState state_co2_in_set = Medium.setState_pTX(Medium.p_default, T_in_ref_co2) "Cold CO2 thermodynamic state at design";
  //TODO pressure to be updated as for CO2
  parameter Medium.ThermodynamicState state_co2_out_set = Medium.setState_pTX(Medium.p_default, T_out_ref_co2) "Hot CO2 thermodynamic state at design";
  //TODO pressure to be updated as for CO2
  // Lifts
  parameter SI.Height dh_liftRC = H_tower "Vertical displacement in receiver lift";
  parameter SI.Height dh_liftHX = 10 "Vertical displacement in heat exchanger lift";
  parameter SI.Height dh_LiftCold = H_storage "Vertical displacement in cold storage lift";
  parameter SI.Efficiency eff_lift = 0.8 "Lift total efficiency";
  // Control
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
  parameter Boolean use_wind = true "True if using wind stopping strategy in the solar field";
  parameter SI.Velocity Wspd_max = 15.65 if use_wind "Wind stow speed";
  parameter SI.HeatFlowRate Q_flow_defocus(fixed = false) "Solar field thermal power at partly-defocused state (when storage is full)";
  parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
  parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
  parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
  parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real hot_tnk_empty_ub = 7 "Hot tank empty trigger upper bound";
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
  parameter SI.HeatFlowRate Q_blk_des(fixed = false) "Heat to power block at design";
  parameter SI.Energy E_max = t_storage * 3600 * Q_blk_des "Maximum tank stored energy";
  parameter SI.Area A_field(fixed = false) "Heliostat field reflective area";
  parameter Integer n_heliostat = integer(ceil(A_field / A_heliostat)) "Number of heliostats";
  parameter SI.Area A_receiver = R_des / C / dni_des "Receiver aperture area";
  parameter SI.Length H_receiver = sqrt(A_receiver * ar_rec) "Receiver aperture height";
  parameter SI.Length W_receiver(fixed = false) "Receiver aperture width";
  parameter SI.Length L_receiver = 1 "Receiver length(depth)";
  //parameter SI.Area A_land = land_mult*A_field + 197434.207385281 "Land area";
  parameter SI.Area A_land = 0 "Land area";
  parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold particles specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot particles specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_co2_in_set = Medium.specificEnthalpy(state_co2_in_set) "Cold CO2 specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_co2_out_set = Medium.specificEnthalpy(state_co2_out_set) "Hot CO2 specific enthalpy at design";
  parameter SI.Density rho_cold_set = Medium.density(state_cold_set) "Cold particles density at design";
  parameter SI.Density rho_hot_set = Medium.density(state_hot_set) "Hot particles density at design";
  parameter SI.Mass m_max = E_max / (h_hot_set - h_cold_set) "Max particles mass in tanks";
  parameter SI.Volume V_max = m_max / ((rho_hot_set + rho_cold_set) / 2) "Max particles volume in tanks";
  parameter SI.MassFlowRate m_flow_fac = SM * Q_blk_des / (h_hot_set - h_cold_set) "Mass flow rate to receiver at design point";
  parameter SI.MassFlowRate m_flow_rec_min = 0 "Minimum mass flow rate to receiver";
  parameter SI.MassFlowRate m_flow_rec_max = 1.5 * m_flow_fac "Maximum mass flow rate to receiver";
  parameter SI.MassFlowRate m_flow_rec_start = 0.8 * m_flow_fac "Initial or guess value of mass flow rate to receiver in the feedback controller";
  parameter SI.MassFlowRate m_flow_blk = Q_blk_des / (h_hot_set - h_cold_set) "Mass flow rate to power block at design point";
  parameter SI.MassFlowRate m_flow_co2 = Q_blk_des / (h_co2_out_set - h_co2_in_set) "Mass flow rate to power block at design point";
  parameter SI.Power P_net = (1 - par_fr) * P_gross "Power block net rating at design point";
  parameter SI.Power P_name = P_net "Nameplate rating of power block";
  parameter SI.Length H_storage = ceil((4 * V_max * tank_ar ^ 2 / CN.pi) ^ (1 / 3)) "Storage tank height";
  parameter SI.Diameter D_storage = H_storage / tank_ar "Storage tank diameter";
  parameter SI.Area SA_storage = CN.pi * D_storage * H_storage "Storage tank surface area";
  parameter SI.Length H_tower(fixed = false) "Tower height";
  // A_field/(gnd_cvge*excl_fac) is the field gross area
  parameter SI.Diameter D_tower = W_receiver "Tower diameter";
  // That's a fair estimate. An accurate H-to-D correlation may be used.
  parameter SI.TemperatureDifference LMTD_des = (T_hot_set - T_out_ref_co2 - (T_cold_set - T_in_ref_co2)) / Math.log((T_hot_set - T_out_ref_co2) / (T_cold_set - T_in_ref_co2)) "Particle heat exchnager LMTD at design";
  parameter SI.Area A_hx = Q_blk_des / (U_hx * LMTD_des) "Heat transfer surface area of the particle heat exchanger";
  // Cost data in USD (default) or AUD
  parameter Real r_disc = 0.07 "Real discount rate";
  //parameter Real r_i = 0.025 "Inflation rate";
  // FIXME perhaps these don't need to be integers?
  parameter Integer t_life(unit = "year") = 30 "Lifetime of plant";
  parameter Integer t_cons(unit = "year") = 2 "Years of construction";
  parameter Real r_cur = 0.71 "The currency rate from AUD to USD";
  // Valid for 2019. See https://www.rba.gov.au/
  parameter Real r_contg = 0.1 "Contingency rate";
  parameter Real r_indirect = 0.13 "Indirect capital costs rate";
  parameter Real r_cons = 0.06 "Construction cost rate";
  parameter FI.AreaPrice pri_field = if currency == Currency.USD then 75 else 75 / r_cur "Field cost per design aperture area";
  parameter FI.AreaPrice pri_site = if currency == Currency.USD then 10 else 10 / r_cur "Site improvements cost per area";
  parameter FI.AreaPrice pri_land = if currency == Currency.USD then 10000 / 4046.86 else 10000 / 4046.86 / r_cur "Land cost per area";
  parameter FI.Money pri_tower = if currency == Currency.USD then 157.44 else 157.44 / r_cur "Fixed tower cost";
  parameter Real idx_pri_tower = 1.9174 "Tower cost scaling index";
  parameter Real pri_lift = if currency == Currency.USD then 58.37 else 58.37 / r_cur "Lift cost per rated mass flow per height";
  parameter FI.AreaPrice pri_receiver = if currency == Currency.USD then 37400 else 37400 / r_cur "Falling particle receiver cost per design aperture area";
  // FIXME storage cost should be based on the bin geometry and (somehow) on cost of tank materials
  parameter FI.EnergyPrice pri_storage = if currency == Currency.USD then 17.90 / (1e3 * 3600) else 17.90 / (1e3 * 3600) / r_cur "Storage cost per energy capacity";
  parameter FI.MassPrice pri_particle = 1.0 "Unit cost of particles per kg";
  parameter FI.PowerPrice pri_hx = if currency == Currency.USD then 175. / 1e3 else 175. / 1e3 / r_cur "Heat exchnager cost per energy capacity";
  parameter FI.PowerPrice pri_block = if currency == Currency.USD then 600 / 1e3 else 600 / r_cur "Power block cost per gross rated power";
  //parameter FI.PowerPrice pri_bop = if currency==Currency.USD then 340 / 1e3 else (340 / 1e3)/r_cur "Balance of plant cost per gross rated power"; // Based on downselection criteria criteria
  parameter FI.PowerPrice pri_bop = if currency == Currency.USD then 0 / 1e3 else 0 / 1e3 / r_cur "Balance of plant cost per gross rated power";
  parameter Real pri_om_name(unit = "$/W/year") = if currency == Currency.USD then 40 / 1e3 else 40 / 1e3 / r_cur "Fixed O&M cost per nameplate per year";
  //parameter Real pri_om_prod(unit = "$/J/year") = if currency==Currency.USD then 3.5 / (1e6 * 3600) else (3.5 / (1e6 * 3600))/r_cur "Variable O&M cost per production per year"; // Based on downselection criteria criteria
  parameter Real pri_om_prod(unit = "$/J/year") = if currency == Currency.USD then 0 / (1e6 * 3600) else 0 / (1e6 * 3600) / r_cur "Variable O&M cost per production per year";
  parameter FI.Money C_field = A_field * pri_field "Field cost";
  parameter FI.Money C_site = A_field * pri_site "Site preparation cost";
  parameter FI.Money C_field_total = C_field + C_site "Heliostat field plus site preparation costs";
  parameter FI.Money C_tower = pri_tower * H_tower ^ idx_pri_tower "Tower cost";
  parameter FI.Money C_lift_rec = pri_lift * dh_liftRC * m_flow_fac "Receiver lift cost";
  parameter FI.Money C_lift_hx = pri_lift * dh_liftHX * m_flow_blk "Heat exchanger lift cost";
  parameter FI.Money C_lift_cold = pri_lift * dh_LiftCold * m_flow_blk "Cold storage tank lift cost";
  parameter FI.Money C_fpr = pri_receiver * A_receiver "Falling particle receiver cost";
  parameter FI.Money C_receiver = C_fpr + C_tower + C_lift_rec "Total receiver cost (particle receiver, tower, particle lift)";
  parameter FI.Money C_bins = FI.particleBinCost(T_hot_set) * SA_storage + FI.particleBinCost(T_cold_set) * SA_storage "Cost of cold and hot storage bins";
  parameter FI.Money C_particles = (1 + NS_particle) * pri_particle * m_max "Cost of particles";
  // FIXME m_s_annual in following equation is a hardwired 'magic number'. TODO Implement calculation of this value.
  parameter FI.Money C_storage = C_bins + C_particles + C_lift_hx + C_lift_cold + f_loss * t_life * pri_particle * 1.753e10 "Total storage cost";
  parameter FI.Money C_hx = Q_blk_des * pri_hx "Heat exchanger cost";
  // TODO Should be updated based on Eq. 11 in Albrecht et al's ASME conference paper draft
  parameter FI.Money C_pb = P_gross * pri_block "Power block cost";
  // TODO Should be updated based on Eq. 17 in Albrecht et al's ASME conference paper draft
  parameter FI.Money C_bop = P_gross * pri_bop "Balance of plant cost";
  parameter FI.Money C_land = A_land * pri_land "Land cost";
  parameter FI.Money C_cap_total = C_field_total + C_receiver + C_storage + C_hx + C_pb + C_bop "Total of raw capital costs";
  parameter FI.Money C_cap = C_cap_total * (1 + r_contg) * (1 + r_indirect) * (1 + r_cons) + C_land "Capital costs including contingency, indirect costs, construction costs and land costs";
  parameter FI.MoneyPerYear C_year = P_name * pri_om_name "Fixed O&M cost per year";
  parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Variable O&M cost per production per year";
  // System components
  // *********************
  //Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(extent = {{-132, -56}, {-102, -28}}, rotation = 0)));
  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(transformation(extent = {{-140, 60}, {-120, 80}})));
  //Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(transformation(extent = {{140, 70}, {120, 90}})));
  //WindSpeed_input
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(transformation(extent = {{-140, 20}, {-114, 40}})));
  //pressure_input
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(transformation(extent = {{76, 18}, {56, 38}})));
  //parasitic inputs
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + liftHX.W_loss + liftRC.W_loss + tankHot.W_loss + tankCold.W_loss) annotation(
    Placement(transformation(extent = {{-13, -10}, {13, 10}}, rotation = -90, origin = {109, 60})));
  // Or block for defocusing
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(transformation(extent = {{-102, 4}, {-94, 12}})));
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
  // Solar field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(n_h = n_heliostat, lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus, nu_start = nu_start, redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file)) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
  //redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Constant(k=0.5) /* FIXME CRASHES!!! issue with imag roots of pcl props */
  // Receiver
  // Hot tank
  SolarTherm.Models.Storage.Tank.Tank tankHot(redeclare package Medium = Medium, D = D_storage, H = H_storage, T_start = T_hot_start, L_start = (1 - split_cold) * 100, alpha = alpha, use_p_top = tnk_use_p_top, enable_losses = tnk_enable_losses, use_L = true, W_max = W_heater_hot, T_set = T_hot_aux_set) annotation(
    Placement(transformation(extent = {{16, 54}, {36, 74}})));
  // Cold tank
  SolarTherm.Models.Storage.Tank.Tank tankCold(redeclare package Medium = Medium, D = D_storage, H = H_storage, T_start = T_cold_start, L_start = split_cold * 100, alpha = alpha, use_p_top = tnk_use_p_top, enable_losses = tnk_enable_losses, use_L = true, W_max = W_heater_cold, T_set = T_cold_aux_set) annotation(
    Placement(transformation(extent = {{64, -28}, {44, -8}})));
  // Receiver lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftRC(redeclare package Medium = Medium, cont_m_flow = true, use_input = true, dh = dh_liftRC, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {-7, -53}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  // Heat exchanger lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftHX(redeclare package Medium = Medium, cont_m_flow = true, use_input = true, dh = dh_liftHX, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {76, 42}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  // Cold storage tank lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple LiftCold(redeclare package Medium = Medium, cont_m_flow = false, use_input = false, dh = dh_LiftCold, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {80, 6}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  // Temperature sensor
  SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{-14, 74}, {-4, 64}})));
  // Particle heat exchanger: TODO to be implemented
  //SolarTherm.Models.Fluid.HeatExchangers.SimpleHeatExchanger hx(
  //redeclare package Medium_A=Medium,
  //redeclare package Medium_B=Medium,
  //A=A_hx,
  //U=U_hx,
  //dT_approach=dT_approach_hx) annotation(
  //Placement(transformation(extent = {{-20, 8}, {-54, 99}})));
  // PowerBlockControl
  SolarTherm.Models.Control.PowerBlockControl controlHot(m_flow_on = m_flow_blk, L_on = hot_tnk_empty_ub, L_off = hot_tnk_empty_lb, L_df_on = hot_tnk_full_ub, L_df_off = hot_tnk_full_lb) annotation(
    Placement(transformation(extent = {{48, 72}, {60, 58}})));
  // ReceiverControl
  // Power block
  SolarTherm.Models.PowerBlocks.PowerBlockModel powerBlock(redeclare package Medium = Medium, W_des = P_gross, enable_losses = blk_enable_losses, redeclare model Cycle = Cycle, nu_min = nu_min_blk, external_parasities = external_parasities, W_base = W_base_blk, p_bo = p_blk, T_des = blk_T_amb_des, nu_net = nu_net_blk, T_in_ref = T_in_ref_blk, T_out_ref = T_out_ref_blk, Q_flow_ref = Q_blk_des, redeclare model Cooling = Cooling(T_co = T_comp_in)) annotation(
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
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D(N = 20, H_drop_design = H_receiver, test_mode = false, fixed_geometry = true, with_wall_conduction = true, fixed_cp = false, with_isothermal_backwall = false, with_uniform_curtain_props = false) annotation(
    Placement(visible = true, transformation(origin = {-28, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  SolarTherm.Models.Control.SimpleReceiverControl simpleReceiverControl(T_ref = T_hot_set, m_flow_min = m_flow_rec_min, m_flow_max = m_flow_rec_max, y_start = m_flow_rec_start, L_df_on = cold_tnk_defocus_lb, L_df_off = cold_tnk_defocus_ub, L_off = cold_tnk_crit_lb, L_on = cold_tnk_crit_ub, eta_rec_th_des = eta_rec_th_des) annotation(
    Placement(visible = true, transformation(origin = {20, -4}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Analytics PG
  SI.Energy E_resource(start = 0);
  SI.Energy E_helio_incident(start = 0);
  SI.Energy E_helio_raw(start = 0);
  SI.Energy E_helio_net(start = 0);
  SI.Energy E_recv_incident(start = 0);
  SI.Energy E_recv_net(start = 0);
  SI.Energy E_pb_input(start = 0);
  SI.Energy E_pb_gross(start = 0);
  SI.Energy E_pb_net(start = 0);
  Real eta_curtail_off(start = 0);
  Real eta_optical(start = 0);
  Real eta_he_av(start = 0);
  Real eta_curtail_defocus(start = 0);
  Real eta_recv_abs(start = 0);
  Real eta_recv_thermal(start = 0);
  Real eta_storage(start = 0);
  Real eta_pb_gross(start = 0);
  Real eta_pb_net(start = 0);
  Real eta_solartoelec(start = 0);
  Modelica.Blocks.Sources.RealExpression realExpression(y = 1) annotation(
    Placement(visible = true, transformation(extent = {{-140, 44}, {-114, 64}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression always_on(y = true) annotation(
    Placement(visible = true, transformation(origin = {-128, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
  if time > 31449600 then
    eta_curtail_off := E_helio_incident / E_resource;
    eta_optical := E_helio_raw / (E_helio_incident * he_av_design);
    eta_he_av := he_av_design;
    eta_curtail_defocus := E_helio_net / E_helio_raw;
    eta_recv_abs := E_recv_incident / E_helio_net;
    eta_recv_thermal := E_recv_net / E_recv_incident;
    eta_storage := E_pb_input / E_recv_net;
    eta_pb_gross := E_pb_gross / E_pb_input;
    eta_pb_net := E_pb_net / E_pb_input;
    eta_solartoelec := E_pb_net / E_resource;
  end if;
initial equation
  if fixed_field then
/* FIXME 'fixed field' mode should assume fixed R_des, and load a pre-defined
		 optical efficiency (at design point, and an optical efficiency lookup
		 table OELT */
    H_tower = 200;
    A_field = 1.473e6;
    eff_opt = 0.5;
    SM = 2.5;
  else
    SM = 2.5;
    P_gross = 100e6;
// FIXME 'free field' mode should use fixed power block to suggest field size
// 'free field' should also trigger ray-tracing simulations.
    eff_opt = 0.433;
// FIXME not clear where this comes from... averaged from solarpilot?
    H_tower = 0.154 * sqrt(twr_ht_const * (A_field / (gnd_cvge * excl_fac)) / CN.pi);
//R_des =  P_gross/eff_blk; /* unsure why this equation has this form... */
  end if;
  dni_des * A_field * eff_opt * eta_rec_th_des * he_av_design = Q_rec_des;
  Q_rec_des = Q_blk_des * SM;
  P_gross = Q_blk_des * eff_blk;
  R_des = Q_rec_des / eta_rec_th_des;
// FIXME check the 'match_sam' issue again here.
  Q_flow_defocus = Q_blk_des / eta_rec_th_des;
// FIXME check the 'match_sam' issue again here.
  W_receiver * H_receiver = A_receiver;
equation
  der(E_resource) = max(sun.dni * A_field, 0.0);
  der(E_helio_incident) = if heliostatsField.on_internal then heliostatsField.n_h * heliostatsField.A_h * max(0.0, heliostatsField.solar.dni) else 0.0;
  der(E_helio_raw) = heliostatsField.Q_raw;
  der(E_helio_net) = heliostatsField.Q_net;
  der(E_recv_incident) = particleReceiver1D.heat.Q_flow;
  der(E_recv_net) = particleReceiver1D.Qdot_rec;
  der(E_pb_input) = powerBlock.Q_flow;
  der(E_pb_gross) = -powerBlock.W_gross;
  der(E_pb_net) = -powerBlock.W_net;
//Connections from data
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-119, 70}, {-102, 70}, {-102, 69.8}, {-82.6, 69.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-112.7, 30}, {-100, 30}, {-100, 29.54}, {-87.68, 29.54}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Pres_input.y, tankCold.p_top) annotation(
    Line(points = {{55, 28}, {49.5, 28}, {49.5, 20}, {49.5, -8.3}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Pres_input.y, tankHot.p_top) annotation(
    Line(points = {{55, 28}, {46, 28}, {8, 28}, {8, 78}, {30.5, 78}, {30.5, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, powerBlock.T_amb) annotation(
    Line(points = {{119, 80}, {102.4, 80}, {102.4, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, tankHot.T_amb) annotation(
    Line(points = {{119, 80}, {68, 80}, {21.9, 80}, {21.9, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(tankCold.T_amb, powerBlock.T_amb) annotation(
    Line(points = {{58.1, -8.3}, {58.1, 20}, {90, 20}, {92, 20}, {92, 42}, {102.4, 42}, {102.4, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
// Fluid connections
  connect(liftRC.fluid_a, tankCold.fluid_b) annotation(
    Line(points = {{-1, -51}, {24.5, -51}, {24.5, -25}, {44, -25}}, color = {0, 127, 255}));
  connect(temperature.fluid_b, tankHot.fluid_a) annotation(
    Line(points = {{-4, 69}, {-4, 69}, {16, 69}}, color = {0, 127, 255}));
  connect(tankHot.fluid_b, liftHX.fluid_a) annotation(
    Line(points = {{36, 57}, {36, 52}, {36, 44}, {48, 44}, {48, 43.88}, {66, 43.88}}, color = {0, 127, 255}));
  connect(liftHX.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{78, 44}, {86, 44}, {86, 29.46}, {98.08, 29.46}}, color = {0, 127, 255}));
//connect(liftHX.fluid_b, hx.port_a_in) annotation(
//Line(points = {{78, 44}, {86, 44}, {86, 29.46}, {98.08, 29.46}}, color = {0, 127, 255}));
//connect(hx.port_a_out, LiftCold.fluid_a) annotation(
//Line(points = {{95.56, 14.64}, {78, 14.64}, {78, -13}, {64, -13}}, color = {0, 127, 255}));
//connect(hx.port_b_out, powerBlock.fluid_a) annotation(
//Line(points = {{95.56, 14.64}, {78, 14.64}, {78, -13}, {64, -13}}, color = {0, 127, 255}));
//connect(powerBlock.fluid_b, hx.port_b_in) annotation(
//Line(points = {{95.56, 14.64}, {78, 14.64}, {78, -13}, {64, -13}}, color = {0, 127, 255}));
// controlCold connections
// controlHot connections
  connect(tankHot.L, controlHot.L_mea) annotation(
    Line(points = {{36.2, 68.4}, {40, 68.4}, {40, 68.5}, {47.52, 68.5}}, color = {0, 0, 127}));
  connect(controlHot.m_flow, liftHX.m_flow) annotation(
    Line(points = {{60.72, 65}, {72, 65}, {72, 49.16}}, color = {0, 0, 127}));
  connect(controlHot.defocus, or1.u1) annotation(
    Line(points = {{54, 72.98}, {54, 72.98}, {54, 86}, {-106, 86}, {-106, 8}, {-102.8, 8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
//Solar field connections i.e. solar.heat port and control
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-72, 60}, {-72, 36}}, color = {255, 128, 0}));
  connect(or1.y, heliostatsField.defocus) annotation(
    Line(points = {{-93.6, 8}, {-92, 8}, {-92, 8.8}, {-87.68, 8.8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
//PowerBlock connections
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{109, 45.7}, {109, 40.85}, {109.6, 40.85}, {109.6, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{115.18, 22.05}, {119.59, 22.05}, {119.59, 22}, {128, 22}}, color = {0, 0, 127}));
  P_elec = powerBlock.W_net;
  E_elec = powerBlock.E_net;
  R_spot = market.profit;
  connect(heliostatsField.heat, particleReceiver1D.heat) annotation(
    Line(points = {{-56, 28}, {-48, 28}, {-48, 34}, {-48, 34}}, color = {191, 0, 0}));
  connect(Tamb_input.y, particleReceiver1D.Tamb) annotation(
    Line(points = {{120, 80}, {-28, 80}, {-28, 44}, {-28, 44}}, color = {0, 0, 127}));
  connect(temperature.fluid_a, particleReceiver1D.fluid_b) annotation(
    Line(points = {{-14, 70}, {-20, 70}, {-20, 38}, {-22, 38}}, color = {0, 127, 255}));
  connect(heliostatsField.on, particleReceiver1D.on) annotation(
    Line(points = {{-72, 2}, {-32, 2}, {-32, 10}, {-32, 10}}, color = {255, 0, 255}));
  connect(particleReceiver1D.fluid_a, liftRC.fluid_b) annotation(
    Line(points = {{-24, 10}, {-14, 10}, {-14, -51}}, color = {0, 127, 255}));
  connect(liftRC.m_flow, controlHot.m_flow_in) annotation(
    Line(points = {{-4, -39}, {-4, 48}, {46, 48}, {46, 62}, {48, 62}}, color = {0, 0, 127}));
  connect(simpleReceiverControl.defocus, or1.u2) annotation(
    Line(points = {{20, -16}, {20, -16}, {20, -26}, {-106, -26}, {-106, 4}, {-102, 4}, {-102, 4}}, color = {255, 0, 255}));
  connect(simpleReceiverControl.m_flow, liftRC.m_flow) annotation(
    Line(points = {{8, -4}, {-4, -4}, {-4, -40}, {-4, -40}}, color = {0, 0, 127}));
  connect(simpleReceiverControl.L_mea, tankCold.L) annotation(
    Line(points = {{30, -4}, {44, -4}, {44, -14}, {44, -14}}, color = {0, 0, 127}));
  connect(heliostatsField.on, simpleReceiverControl.sf_on) annotation(
    Line(points = {{-72, 2}, {-72, 2}, {-72, -18}, {32, -18}, {32, -10}, {32, -10}}, color = {255, 0, 255}));
  connect(tankCold.T_mea, simpleReceiverControl.T_mea) annotation(
    Line(points = {{42, -18}, {34, -18}, {34, 2}, {32, 2}}, color = {0, 0, 127}));
  connect(heliostatsField.Q_incident, simpleReceiverControl.Q_in) annotation(
    Line(points = {{-54, 20}, {48, 20}, {48, 4}, {32, 4}, {32, 4}}, color = {0, 0, 127}));
  connect(LiftCold.fluid_b, tankCold.fluid_a) annotation(
    Line(points = {{74, 8}, {68, 8}, {68, -12}, {64, -12}, {64, -12}}, color = {0, 127, 255}));
  connect(powerBlock.fluid_b, LiftCold.fluid_a) annotation(
    Line(points = {{96, 14}, {90, 14}, {90, 8}, {86, 8}, {86, 8}}, color = {0, 127, 255}));
  connect(temperature.T, simpleReceiverControl.T_out_receiver) annotation(
    Line(points = {{-8, 64}, {-10, 64}, {-10, 26}, {20, 26}, {20, 8}, {20, 8}}, color = {0, 0, 127}));
  connect(particleReceiver1D.eta_rec_out, simpleReceiverControl.eta_rec) annotation(
    Line(points = {{-22, 24}, {16, 24}, {16, 8}, {16, 8}}, color = {0, 0, 127}));
  connect(realExpression.y, particleReceiver1D.Wdir) annotation(
    Line(points = {{-112, 54}, {-32, 54}, {-32, 44}, {-32, 44}}, color = {0, 0, 127}));
  connect(realExpression.y, particleReceiver1D.Wspd) annotation(
    Line(points = {{-112, 54}, {-28, 54}, {-28, 44}, {-28, 44}}, color = {0, 0, 127}));
  connect(always_on.y, heliostatsField.on_hopper) annotation(
    Line(points = {{-116, -4}, {-110, -4}, {-110, 18}, {-88, 18}, {-88, 20}}, color = {255, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 9), Text(lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 9), Text(origin = {2, 2}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, -8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-4, 2}, extent = {{0, 58}, {48, 38}}, textString = "Hot Tank", fontSize = 6, fontName = "CMU Serif"), Text(extent = {{30, -24}, {78, -44}}, textString = "Cold Tank", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, -2}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"), Text(origin = {6, 0}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"), Text(origin = {2, 4}, extent = {{-6, 20}, {42, 0}}, textString = "Simple Receiver Control", fontSize = 6, fontName = "CMU Serif", textStyle = {TextStyle.Bold, TextStyle.Bold, TextStyle.Bold, TextStyle.Bold, TextStyle.Bold, TextStyle.Bold, TextStyle.Bold, TextStyle.Bold}), Text(origin = {2, 32}, extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {8, -26}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif"), Text(origin = {0, -44}, extent = {{-10, 8}, {10, -8}}, textString = "LiftRC", fontSize = 6, fontName = "CMU Serif"), Text(origin = {80, -8}, extent = {{-14, 8}, {14, -8}}, textString = "LiftCold", fontSize = 6, fontName = "CMU Serif"), Text(origin = {85, 59}, extent = {{-19, 11}, {19, -11}}, textString = "LiftHX", fontSize = 6, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 1800),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released 0D first version. </li>
	<li> Philipe Gunawan Gan (Jan 2020) :<br>Released PhysicalParticleSYstem1D (with 1D Receiver) <li>
	</ul>

	</html>"));
end PhysicalParticleSystem1D;