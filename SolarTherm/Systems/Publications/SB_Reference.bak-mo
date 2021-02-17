within SolarTherm.Systems.Publications;

model SB_Reference
  function opt_file_naming
    input String prefix;//"modelica://SolarTherm/Data/Optics/SodiumBoiler/surround/Ref/"
    input String phi_pct_string;
    input Real SM_guess;
    input Real HT_pct_guess;
    input Real f_recv_guess;
    output String opt_file;
  protected
    Integer phi;
    Integer SM;
    Integer HT_pct;
    Integer f_recv;
    String SM_string;
    String HT_pct_string;
    String f_recv_string;
  algorithm
    SM := max(14,min(38,1 * round(SM_guess * 10)));//Actually SM*10"
    HT_pct := max(70,min(130,5 * round(HT_pct_guess * 0.2)));
    f_recv := max(70,min(130,5 * round(f_recv_guess * 20)));
    SM_string := String(SM);
    HT_pct_string := String(HT_pct);
    f_recv_string := String(f_recv);
    opt_file := Modelica.Utilities.Files.loadResource(prefix+SM_string+"dSM/isp_designpt/"+phi_pct_string+"%phi_"+HT_pct_string+"%HT_"+f_recv_string+"%Arecv_optics.motab");
  end opt_file_naming;
    
  function round
    input Real number;
    output Integer int;
  protected
    Integer quotient;
    Real remainder;
  algorithm
    quotient := integer(number);
    remainder := number - floor(number);
    if remainder >= 0.5 then
      int := 1 + quotient;
    else
      int := quotient;
    end if;
  end round; 

  //import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Solar_angles;
  import SolarTherm.Types.Currency;
  // Input Parameters

  parameter Real f_recv = 1.20 "receiver area fraction";
  parameter Real SM_guess = 1.5 "guess SM";
  parameter Real HT_pct_guess = 91.0 "guess THT%";
  parameter Real t_storage = 14.0 "storage hours";
  parameter String field_type = "surround";
  parameter String opt_file_prefix = "modelica://SolarTherm/Data/Optics/SodiumBoiler/surround/Ref/";
  parameter String phi_pct_string = "124";
  parameter String opt_file = opt_file_naming(opt_file_prefix,phi_pct_string,SM_guess,HT_pct_guess,f_recv);
  //parameter String phi_pct_string = if field_type == "polar" then "100%phi_" else "124%phi_";
  //parameter String SM_string = String(1 * round(SM_guess * 10)) + "dSM/" "Solar Multiple rounded to the nearest 0.1, multiplied by 10 and converted to string";
  //parameter String HT_pct_string = String(5 * round(HT_pct_guess * 0.2)) + "%HT";
  //parameter String f_recv_string = String(5 * round(f_recv * 0.2)) + "%Arecv";
  //parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/SodiumBoiler/" + field_type + "/Ref/" + SM_string + "isp_designpt/" + phi_pct_string + HT_pct_string + f_recv_string+".motab");


  parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  //parameter Integer SM_int = 1*SolarTherm.Utilities.Round(SM_guess * 10.0);
  //parameter Integer HT_pct_int = 5*SolarTherm.Utilities.Round(HT_pct_guess * 0.2);
  //parameter String SM_string = String(SM_int) + "dSM/";
  //parameter String HT_pct_string = String(HT_pct_int) + "%HT";
  package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph "Medium props for molten salt";
  // Weather data
  parameter String file_weather = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  // Field
  //SolarPILOT info
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
  parameter SI.Irradiance dni_des = 950 "DNI at design point";
  // Receiver
  parameter SI.Efficiency ab_rec = 0.961 "Receiver coating absorptance";
  parameter SI.Efficiency em_rec = 0.920 "Receiver coating emissivity";
  parameter Real land_mult = 5.0 "Land area multiplier";
  parameter Real he_av_design = 0.99 "Helisotats availability";
  parameter SI.Energy helio_E_start = 90e3 * A_heliostat / 144.375 "Heliostat startup energy consumption";
  parameter SI.Power helio_W_track = 0.0553 * A_heliostat / 144.375 "Heliostat tracking power";
  //parameter String[2] opt_file_list = SolarTherm.Utilities.Interpolation.OpticsTableNames(opt_file_prefix, f_recv);
  //parameter String opt_file_A = Modelica.Utilities.Files.loadResource(opt_file_list[1]);
  //parameter String opt_file_B = Modelica.Utilities.Files.loadResource(opt_file_list[2]);
  parameter Real[8] MetaA = SolarTherm.Utilities.Metadata_Optics(opt_file);//_A);
  //parameter Real[8] MetaB = SolarTherm.Utilities.Metadata_Optics(opt_file_B);
  //parameter Real opt_file_weight = SolarTherm.Utilities.Interpolation.OpticsTableWeight(opt_file_prefix, f_recv);
  parameter SI.CoefficientOfHeatTransfer h_convection_receiver = 20.0 "W/m2K";
  parameter Integer n_heliostat = SolarTherm.Utilities.Round(MetaA[1]);
  parameter SI.Area A_heliostat = MetaA[2];
  parameter Real eff_opt = MetaA[3];// + opt_file_weight * (MetaB[3] - MetaA[3]);
  parameter SI.Length H_recv = MetaA[4];// + opt_file_weight * (MetaB[4] - MetaA[4]);
  parameter SI.Length D_recv = MetaA[5];// + opt_file_weight * (MetaB[5] - MetaA[5]);
  parameter SI.Length H_tower = MetaA[6];
  parameter SI.Temperature T_cold_start = CV.from_degC(290) "Cold tank starting temperature";
  parameter SI.Temperature T_hot_start = CV.from_degC(574) "Hot tank starting temperature";
  parameter SI.Temperature T_cold_aux_set = CV.from_degC(280) "Cold tank auxiliary heater set-point temperature";
  parameter SI.Temperature T_hot_aux_set = CV.from_degC(500) "Hot tank auxiliary heater set-point temperature";
  parameter SI.Temperature T_cold_set = CV.from_degC(290) "Cold tank target temperature";
  parameter SI.Temperature T_hot_set = CV.from_degC(574) "Hot tank target temperature";
  parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
  parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
  parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
  parameter SI.CoefficientOfHeatTransfer alpha = 3 "Tank constant heat transfer coefficient with ambient";
  parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold tank parasitic power coefficient";
  parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot tank parasitic power coefficient";
  // Power block
  parameter SI.Power P_name = 100e6 "Nameplate rating of power block";
  parameter SI.Power P_gross = P_name / 1.0 "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.3774 "Power block efficiency at design point";
  parameter SI.MassFlowRate m_flow_blk = 682.544 * (Q_flow_ref_blk / 294.118e6) "Mass flow rate to power block at design";
  parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";
  parameter Boolean external_parasities = true "true if there is external parasitic power losses";
  parameter Real nu_min_blk = 0.5 "minimum allowed part-load mass flow fraction to power block";
  parameter SI.Power W_base_blk = 0.0055 * P_gross "Power consumed at all times in power block";
  parameter SI.AbsolutePressure p_blk = 10e6 "Power block operating pressure";
  parameter SI.Temperature blk_T_amb_des = 316.15 "Ambient temperature at design for power block";
  parameter Real nu_net_blk = 1.0 "Gross to net power conversion factor at the power block";
  parameter SI.Temperature T_in_ref_blk = from_degC(574) "HTF inlet temperature to power block at design";
  parameter SI.Temperature T_out_ref_blk = from_degC(290) "HTF outlet temperature to power block at design";
  parameter SI.HeatFlowRate Q_flow_ref_blk = P_gross / eff_blk "Thermal power to power block at design";
  // Control
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
  parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
  parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
  parameter SI.HeatFlowRate Q_flow_defocus = (Q_flow_ref_blk + Q_flow_rec_loss_des + Q_flow_tank_loss_des) / ab_rec "Solar field thermal power at defocused state";
  //I am assuming this to be (Q_flow_ref_blk+Q_rec_loss_design)/ab
  parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
  parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
  parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
  parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real hot_tnk_empty_ub = 10 "Hot tank empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real hot_tnk_full_lb = 96 "Hot tank full trigger lower bound";
  // Level (below which) to stop defocus
  parameter Real hot_tnk_full_ub = 99 "Hot tank full trigger upper bound";
  // Level (above which) to start defocus
  parameter SI.Length H_tank = 1.0 * 20.0 * (P_name * t_storage / (100.0e6 * 4.0)) ^ (1.0 / 3.0);
  parameter SI.Length D_tank = 1.0 * 18.667 * (P_name * t_storage / (100.0e6 * 4.0)) ^ (1.0 / 3.0);
  parameter SI.MassFlowRate m_flow_rec_max = 1400 * (Q_flow_rec_des / 529.4e6) "Maximum mass flow rate to receiver";
  parameter SI.MassFlowRate m_flow_rec_start = 1000 * (Q_flow_rec_des / 529.4e6) "Initial or guess value of mass flow rate to receiver in the feedback controller";
  parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real cold_tnk_crit_lb = 1 "Cold tank critically empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real Ti = 0.1 "Time constant for integral component of receiver control";
  parameter Real Kp = -1000 * (Q_flow_rec_des / 529.4e6) "Gain of proportional component in receiver control";
  // Calculated Parameters
  parameter Real SM = Q_flow_rec_des / Q_flow_ref_blk "Solar multiple. Calculated to obtain 6377 heliostats";
  parameter SI.HeatFlowRate Q_flow_rec_loss_des = CN.sigma * em_rec * A_recv * (706 ^ 4 - 300 ^ 4) + h_convection_receiver * A_recv * (706 - 300) "Receiver design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_tank_loss_des = CN.pi * D_tank * H_tank * alpha * (T_hot_set - 300.0) "Tank design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_rec_des = dni_des * eff_opt * A_field * ab_rec - Q_flow_rec_loss_des "Receiver Thermal power output at design";
  parameter SI.Area A_field = n_heliostat * A_heliostat "Solar field reflective area";
  parameter SI.Area A_land = land_mult * A_field "Land area";
  parameter SI.Area A_recv = H_recv * D_recv * CN.pi "Receiver area";
  parameter SI.HeatFlowRate Q_flow_des = P_gross / eff_blk "Heat to power block at design point";
  parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
  // Cost data
  parameter Real r_disc = 0.07 "Discount rate";
  parameter Real r_i = 0.03 "Inflation rate";
  parameter Integer t_life(unit = "year") = 27 "Lifetime of plant";
  parameter Integer t_cons(unit = "year") = 3 "Years of construction";
  parameter Real f_Subs = 0 "Subsidies on initial investment costs";
  parameter FI.AreaPrice pri_field = 140.0 "Field cost per design aperture area";
  parameter FI.AreaPrice pri_site = 16.00 "Site improvements cost per area";
  parameter FI.EnergyPrice pri_storage = 22.0 / (1e3 * 3600) "Storage cost per energy capacity";
  parameter FI.PowerPrice pri_block = 1.040;
  //352.6*(P_gross^(-0.3145)) "Power block cost per gross rated power";
  parameter FI.PowerPrice pri_bop = 0.29;
  //9.7228*(P_gross^(-0.1896)) "Balance of plant cost per gross rated power";
  parameter FI.AreaPrice pri_land = 2.47 "Land cost per area";
  parameter Real pri_om_name(unit = "$/W/year") = 66.0 / 1e3 "Fixed O&M cost per nameplate per year";
  // It is 58 $/kW/year in Mehdi's report, but Andrew suggsted a more recent number
  parameter Real pri_om_prod(unit = "$/J/year") = 3.5 / (1e6 * 3600) "Variable O&M cost per production per year";
  // It was 5.9656 $/MWh/year in Mehdi's report, but Andrew suggsted a more recent number
  parameter FI.Money C_field = 1.0 * pri_field * A_field "Field cost";
  parameter FI.Money C_site = 1.0 * pri_site * A_field "Site improvements cost";
  //parameter FI.Money C_tower = 3.0e6*exp(0.0113*H_tower) "Tower cost";
  //parameter FI.Money C_receiver = 103.0e6*((A_receiver/1571.0)^0.7) "Receiver cost";
  parameter FI.Money C_tower = 3.0e6 * exp(H_tower * 0.0113) "Tower cost";
  parameter FI.Money C_receiver = A_recv * 65563.0 "Receiver cost";
  parameter FI.Money C_storage = 1.0 * pri_storage * t_storage * 3600 * Q_flow_des "Storage cost";
  parameter FI.Money C_block = pri_block * P_gross "Power block cost";
  parameter FI.Money C_bop = pri_bop * P_gross "Balance of plant cost";
  parameter FI.Money C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop) "Direct capital cost subtotal";
  // i.e. purchased equipment costs
  parameter FI.Money C_contingency = 0.07 * C_cap_dir_sub "Contingency costs";
  parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
  parameter FI.Money C_EPC = 0.11 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
  parameter FI.Money C_land = pri_land * A_land "Land cost";
  parameter FI.Money C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
  parameter FI.MoneyPerYear C_year = pri_om_name * P_name "Fixed O&M cost per year";
  parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Variable O&M cost per production per year";
  // System components
  // *********************
  //Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = file_weather) annotation(
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
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold.W_loss + tankHot.W_loss + tankCold.W_loss) annotation(
    Placement(transformation(extent = {{-13, -10}, {13, 10}}, rotation = -90, origin = {109, 60})));
  // Or block for defocusing
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(transformation(extent = {{-102, 4}, {-94, 12}})));
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = SolarTherm.Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
  // Solar field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(E_start = helio_E_start, W_track = helio_W_track, n_h = n_heliostat, lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus, nu_start = nu_start, redeclare model Optical = SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table_Full(angles = angles, file = opt_file)) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
  // Receiver
  SolarTherm.SolarPaces2019.ReceiverSimple_Flat receiver(em = em_rec, redeclare package Medium = Medium, H_rcv = H_recv, D_rcv = D_recv, N_pa = 20, t_tb = 1.25e-3, D_tb = 40e-3, h_convection = h_convection_receiver, ab = ab_rec) annotation(
    Placement(transformation(extent = {{-46, 4}, {-10, 40}})));
  //TODO
  //TODO
  //TODO
  // Hot tank
  SolarTherm.Models.Storage.Tank.Tank tankHot(redeclare package Medium = Medium, H = H_tank, D = D_tank, T_start = T_hot_start, L_start = (1 - split_cold) * 100, alpha = alpha, use_p_top = tnk_use_p_top, enable_losses = tnk_enable_losses, use_L = true, T_set = T_hot_aux_set) annotation(
    Placement(transformation(extent = {{16, 54}, {36, 74}})));
  // Pump hot
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(redeclare package Medium = Medium, k_loss = k_loss_hot) annotation(
    Placement(transformation(extent = {{66, 38}, {78, 50}})));
  // Cold tank
  SolarTherm.Models.Storage.Tank.Tank tankCold(redeclare package Medium = Medium, H = H_tank, D = D_tank, T_start = T_cold_start, L_start = split_cold * 100, alpha = alpha, use_p_top = tnk_use_p_top, enable_losses = tnk_enable_losses, use_L = true, T_set = T_cold_aux_set) annotation(
    Placement(visible = true, transformation(extent = {{64, -32}, {44, -12}}, rotation = 0)));
  // Pump cold
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(redeclare package Medium = Medium, k_loss = k_loss_cold) annotation(
    Placement(transformation(extent = {{10, -30}, {-2, -18}})));
  // Temperature sensor
  SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{-14, 74}, {-4, 64}})));
  // PowerBlockControl
  SolarTherm.Models.Control.PowerBlockControl controlHot(m_flow_on = m_flow_blk, L_on = hot_tnk_empty_ub, L_off = hot_tnk_empty_lb, L_df_on = hot_tnk_full_ub, L_df_off = hot_tnk_full_lb) annotation(
    Placement(transformation(extent = {{48, 72}, {60, 58}})));
  // ReceiverControl
  SolarTherm.Models.Control.ReceiverControl controlCold(T_ref = T_hot_set, m_flow_max = m_flow_rec_max, y_start = m_flow_rec_start, L_df_on = cold_tnk_defocus_lb, L_df_off = cold_tnk_defocus_ub, L_off = cold_tnk_crit_lb, L_on = cold_tnk_crit_ub, Ti = Ti, Kp = Kp) annotation(
    Placement(transformation(extent = {{24, -10}, {10, 4}})));
  // Power block
  SolarTherm.SolarPaces2019.PowerBlockModel powerBlock(W_net_des = P_name, W_des = P_gross, enable_losses = blk_enable_losses, redeclare model Cycle = SolarTherm.Models.PowerBlocks.Correlation.Rankine, nu_min = nu_min_blk, external_parasities = external_parasities, W_base = W_base_blk, p_bo = p_blk, T_des = blk_T_amb_des, nu_net = nu_net_blk, T_in_ref = T_in_ref_blk, T_out_ref = T_out_ref_blk, Q_flow_ref = Q_flow_ref_blk) annotation(
    Placement(transformation(extent = {{88, 4}, {124, 42}})));
  // Price
  SolarTherm.Models.Analysis.Market market(redeclare model Price = SolarTherm.Models.Analysis.EnergyPrice.Constant) annotation(
    Placement(visible = true, transformation(extent = {{128, 12}, {148, 32}}, rotation = 0)));
  // Variables:
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true) "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
  //Boolean constrained(start = false);
  //Real distance(start = 0);
  //Analytics Zeb
  SI.Energy E_resource(start = 0);
  SI.Energy E_helio_incident(start = 0);
  SI.Energy E_helio_raw(start = 0);
  SI.Energy E_helio_net(start = 0);
  SI.Energy E_recv_incident(start = 0);
  SI.Energy E_recv_net(start = 0);
  SI.Energy E_pb_input(start = 0);
  SI.Energy E_pb_gross(start = 0);
  SI.Energy E_pb_net(start = 0);
  /*
    Real sum_shading(start = 0) "Shading efficiency multiplied by time when heliostats are on";
    Real sum_cosine(start = 0) "Shading efficiency multiplied by time when heliostats are on";
    Real sum_reflection(start = 0) "Shading efficiency multiplied by time when heliostats are on";
    Real sum_blocking(start = 0) "Shading efficiency multiplied by time when heliostats are on";
    Real sum_attenuation(start = 0) "Shading efficiency multiplied by time when heliostats are on";
    Real sum_intercept(start = 0) "Shading efficiency multiplied by time when heliostats are on";
    Real sum_timehelio(start = 0) "Sum of time when heliostat is on";
    Real eta_shading;
    Real eta_cosine;
    Real eta_reflection;
    Real eta_blocking;
    Real eta_attenuation;
    Real eta_intercept;
    */
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
    eta_pb_net := E_pb_net / E_pb_gross;
    eta_solartoelec := E_pb_net / E_resource;
  end if;
/*
    eta_shading := sum_shading / sum_timehelio;
    eta_cosine := sum_cosine / sum_timehelio;
    eta_reflection := sum_reflection / sum_timehelio;
    eta_blocking := sum_blocking / sum_timehelio;
    eta_attenuation := sum_attenuation / sum_timehelio;
    eta_intercept := sum_intercept / sum_timehelio;
		*/
/*
  when time > 43200 then
    if heliostatsField.optical.isp_min < 1e-3 then
      constrained := true;
      distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
      terminate("Bad aiming");
    end if;
  end when;
	*/
equation
  der(E_resource) = max(sun.dni * A_field, 0.0);
  der(E_helio_incident) = if heliostatsField.on_internal then heliostatsField.n_h * heliostatsField.A_h * max(0.0, heliostatsField.solar.dni) else 0.0;
  der(E_helio_raw) = heliostatsField.Q_raw;
  der(E_helio_net) = heliostatsField.Q_net;
  der(E_recv_incident) = receiver.ab * receiver.heat.Q_flow;
  der(E_recv_net) = receiver.Q_rcv;
  der(E_pb_input) = powerBlock.Q_flow;
  der(E_pb_gross) = powerBlock.W_gross;
  der(E_pb_net) = powerBlock.W_net;
/*
  if heliostatsField.on_internal then
  //cumulative optics efficiency
    der(sum_shading) = max(sun.dni * A_field, 0.0) * heliostatsField.optical.nu_shading;
    der(sum_cosine) = max(sun.dni * A_field, 0.0) * heliostatsField.optical.nu_cosine;
    der(sum_reflection) = max(sun.dni * A_field, 0.0) * heliostatsField.optical.nu_reflection;
    der(sum_blocking) = max(sun.dni * A_field, 0.0) * heliostatsField.optical.nu_blocking;
    der(sum_attenuation) = max(sun.dni * A_field, 0.0) * heliostatsField.optical.nu_attenuation;
    der(sum_intercept) = max(sun.dni * A_field, 0.0) * heliostatsField.optical.nu_intercept;
    der(sum_timehelio) = max(sun.dni * A_field, 0.0);
  else
    der(sum_shading) = 0.0;
    der(sum_cosine) = 0.0;
    der(sum_reflection) = 0.0;
    der(sum_blocking) = 0.0;
    der(sum_attenuation) = 0.0;
    der(sum_intercept) = 0.0;
    der(sum_timehelio) = 0.0;
  end if;
	*/
//equation
//Connections from data
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-119, 70}, {-102, 70}, {-102, 69.8}, {-82.6, 69.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-112.7, 30}, {-100, 30}, {-100, 29.54}, {-87.68, 29.54}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Pres_input.y, tankCold.p_top) annotation(
    Line(points = {{55, 28}, {49.5, 28}, {49.5, -12}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Pres_input.y, tankHot.p_top) annotation(
    Line(points = {{55, 28}, {46, 28}, {8, 28}, {8, 78}, {30.5, 78}, {30.5, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, powerBlock.T_amb) annotation(
    Line(points = {{119, 80}, {102.4, 80}, {102.4, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, tankHot.T_amb) annotation(
    Line(points = {{119, 80}, {68, 80}, {21.9, 80}, {21.9, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(receiver.Tamb, tankHot.T_amb) annotation(
    Line(points = {{-28, 36.04}, {-28, 80}, {21.9, 80}, {21.9, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(tankCold.T_amb, powerBlock.T_amb) annotation(
    Line(points = {{58, -12}, {58, 20}, {92, 20}, {92, 42}, {102.4, 42}, {102.4, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
// Fluid connections
  connect(pumpCold.fluid_a, tankCold.fluid_b) annotation(
    Line(points = {{10, -24.12}, {10, -29}, {44, -29}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
    Line(points = {{-24.4, 5.8}, {-14.2, 5.8}, {-14.2, -24}, {-2, -24}}, color = {0, 127, 255}));
  connect(receiver.fluid_b, temperature.fluid_a) annotation(
    Line(points = {{-21.88, 30.64}, {-21.88, 30}, {-20, 30}, {-16, 30}, {-16, 69}, {-14, 69}}, color = {0, 127, 255}));
  connect(temperature.fluid_b, tankHot.fluid_a) annotation(
    Line(points = {{-4, 69}, {-4, 69}, {16, 69}}, color = {0, 127, 255}));
  connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{36, 57}, {36, 52}, {36, 44}, {48, 44}, {48, 43.88}, {66, 43.88}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{78, 44}, {86, 44}, {86, 29.46}, {98.08, 29.46}}, color = {0, 127, 255}));
  connect(powerBlock.fluid_b, tankCold.fluid_a) annotation(
    Line(points = {{95.56, 14.64}, {78, 14.64}, {78, -17}, {64, -17}}, color = {0, 127, 255}));
// controlCold connections
  connect(temperature.T, controlCold.T_mea) annotation(
    Line(points = {{-9, 63.9}, {-10, 63.9}, {-10, 24}, {38, 24}, {38, 1.2}, {24.7, 1.2}}, color = {0, 0, 127}));
  connect(tankCold.L, controlCold.L_mea) annotation(
    Line(points = {{44, -18}, {38, -18}, {38, -13.6}, {43.8, -13.6}}, color = {0, 0, 127}));
  connect(heliostatsField.on, controlCold.sf_on) annotation(
    Line(points = {{-72, 2}, {-72, 2}, {-72, -36}, {28, -36}, {28, -6}, {24.7, -6}, {24.7, -7.2}}, color = {255, 0, 255}));
  connect(controlCold.m_flow, pumpCold.m_flow) annotation(
    Line(points = {{9.16, -3}, {4, -3}, {4, -18.84}}, color = {0, 0, 127}));
  connect(controlCold.defocus, or1.u2) annotation(
    Line(points = {{17, -10.98}, {17, -32}, {-106, -32}, {-106, 4.8}, {-102.8, 4.8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
// controlHot connections
  connect(tankHot.L, controlHot.L_mea) annotation(
    Line(points = {{36.2, 68.4}, {40, 68.4}, {40, 68.5}, {47.52, 68.5}}, color = {0, 0, 127}));
  connect(pumpCold.m_flow, controlHot.m_flow_in) annotation(
    Line(points = {{47.52, 61.5}, {39.52, 61.5}, {39.52, 30}, {4, 30}, {4, -18.84}}, color = {0, 0, 127}));
  connect(controlHot.m_flow, pumpHot.m_flow) annotation(
    Line(points = {{60.72, 65}, {72, 65}, {72, 49.16}}, color = {0, 0, 127}));
  connect(controlHot.defocus, or1.u1) annotation(
    Line(points = {{54, 72.98}, {54, 72.98}, {54, 86}, {-106, 86}, {-106, 8}, {-102.8, 8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
//Solar field connections i.e. solar.heat port and control
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-72, 60}, {-72, 36}}, color = {255, 128, 0}));
  connect(heliostatsField.heat, receiver.heat) annotation(
    Line(points = {{-55.68, 27.5}, {-54.82, 27.5}, {-54.82, 27.4}, {-46, 27.4}}, color = {191, 0, 0}));
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
  connect(Wspd_input.y, receiver.Wspd) annotation(
    Line(points = {{-112, 30}, {-102, 30}, {-102, 44}, {-32, 44}, {-32, 36}, {-32, 36}}, color = {0, 0, 127}));
end SB_Reference;