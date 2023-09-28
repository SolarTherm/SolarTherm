within SolarTherm.Systems.Publications;

package SodiumBoiler
  model SB_Reference
    function opt_file_naming
      input String prefix;
      //"modelica://SolarTherm/Data/Optics/SodiumBoiler/surround/Ref/"
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
      SM := max(14, min(38, 1 * round(SM_guess * 10)));
//Actually SM*10"
      HT_pct := max(70, min(130, 5 * round(HT_pct_guess * 0.2)));
      f_recv := max(70, min(130, 5 * round(f_recv_guess * 20)));
      SM_string := String(SM);
      HT_pct_string := String(HT_pct);
      f_recv_string := String(f_recv);
      opt_file := Modelica.Utilities.Files.loadResource(prefix + SM_string + "dSM/isp_designpt/" + phi_pct_string + "%phi_" + HT_pct_string + "%HT_" + f_recv_string + "%Arecv_optics.motab");
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
    extends Modelica.Icons.Example;
    // Input Parameters
    parameter Real f_recv = 0.88 "receiver area fraction";
    parameter Real SM_guess = 2.77 "guess SM";
    parameter Real HT_pct_guess = 82.2 "guess THT%";
    parameter Real t_storage = 13.6 "storage hours";
    parameter String field_type = "surround";
    parameter String opt_file_prefix = "modelica://SolarTherm/Data/Optics/SodiumBoiler/surround/Ref/";
    parameter String phi_pct_string = "124";
    parameter String opt_file = opt_file_naming(opt_file_prefix, phi_pct_string, SM_guess, HT_pct_guess, f_recv);
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
    parameter Real[8] MetaA = SolarTherm.Utilities.Metadata_Optics(opt_file);
    //_A);
    //parameter Real[8] MetaB = SolarTherm.Utilities.Metadata_Optics(opt_file_B);
    //parameter Real opt_file_weight = SolarTherm.Utilities.Interpolation.OpticsTableWeight(opt_file_prefix, f_recv);
    parameter SI.CoefficientOfHeatTransfer h_convection_receiver = 20.0 "W/m2K";
    parameter Integer n_heliostat = SolarTherm.Utilities.Round(MetaA[1]);
    parameter SI.Area A_heliostat = MetaA[2];
    parameter Real eff_opt = MetaA[3];
    // + opt_file_weight * (MetaB[3] - MetaA[3]);
    parameter SI.Length H_recv = MetaA[4];
    // + opt_file_weight * (MetaB[4] - MetaA[4]);
    parameter SI.Length D_recv = MetaA[5];
    // + opt_file_weight * (MetaB[5] - MetaA[5]);
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
    parameter FI.Money C_receiver = 103000000 * (A_recv / 1571) ^ 0.7 "Receiver cost";
    //A_recv * 65563.0 "Receiver cost";
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
      Placement(visible = true, transformation(extent = {{-148, -12}, {-118, 16}}, rotation = 0)));
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
      Placement(visible = true, transformation(origin = {133, 60}, extent = {{13, -10}, {-13, 10}}, rotation = 0)));
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
      Line(points = {{119, 60}, {119, 40.85}, {109.6, 40.85}, {109.6, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
    connect(powerBlock.W_net, market.W_net) annotation(
      Line(points = {{115.18, 22.05}, {119.59, 22.05}, {119.59, 22}, {128, 22}}, color = {0, 0, 127}));
    P_elec = powerBlock.W_net;
    E_elec = powerBlock.E_net;
    R_spot = market.profit;
    connect(Wspd_input.y, receiver.Wspd) annotation(
      Line(points = {{-112, 30}, {-102, 30}, {-102, 44}, {-32, 44}, {-32, 36}, {-32, 36}}, color = {0, 0, 127}));
    annotation(
      Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false), graphics = {Text(origin = {56, -37}, extent = {{-10, 3}, {10, -3}}, textString = "Cold Tank"), Text(origin = {28, 49}, extent = {{-10, 3}, {10, -3}}, textString = "Hot Tank"), Text(origin = {6, 9}, extent = {{-2, 1}, {26, -5}}, textString = "Cold Control"), Text(origin = {48, 79}, extent = {{-6, -1}, {26, -5}}, textString = "Hot Control"), Text(origin = {104, 5}, extent = {{-10, 3}, {14, -3}}, textString = "Power Block"), Text(origin = {138, 7}, extent = {{-6, 1}, {10, -3}}, textString = "Market"), Text(origin = {-30, -1}, extent = {{-6, 1}, {12, -3}}, textString = "Receiver"), Text(origin = {-82, 1}, extent = {{-6, 1}, {28, -13}}, textString = "Heliostat Field")}),
      Icon(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)),
      experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60, maxStepSize = 60, initialStepSize = 60));
  end SB_Reference;

  model SB_Polar_75Carnot
    function opt_file_naming
      input String prefix;
      //"modelica://SolarTherm/Data/Optics/SodiumBoiler/surround/Ref/"
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
      SM := max(14, min(38, 1 * round(SM_guess * 10)));
//Actually SM*10"
      HT_pct := max(70, min(130, 5 * round(HT_pct_guess * 0.2)));
      f_recv := max(70, min(130, 5 * round(f_recv_guess * 20)));
      SM_string := String(SM);
      HT_pct_string := String(HT_pct);
      f_recv_string := String(f_recv);
      opt_file := Modelica.Utilities.Files.loadResource(prefix + SM_string + "dSM/isp_designpt/" + phi_pct_string + "%phi_" + HT_pct_string + "%HT_" + f_recv_string + "%Arecv_optics.motab");
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
    //To be optimised
    //--Tank
    //Trays
    parameter Real f_recv = 0.803 "Receiver area multiplier to be optimised";
    parameter Real f_PCM_safety = 1.0005 "Safety factor such that PCM does not exceed wall height";
    parameter Real f_HTF_inventory = 0.8126 "Multiplier to empty volume between PCM and wall level occupied to sodium at 1073K to calculate sodium mass inventory";
    parameter SI.Length z_PCM = 0.0582 "Vertical depth of PCM in each tray, m";
    parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.0876 "Heat transfer coefficient of tank losses between sodium and ambient temps, W/m2K";
    parameter Real SM_guess = 3.63 "Solar multiple";
    parameter Real t_storage(unit = "h") = 14.08 "Hours of storage";
    parameter SI.Temperature T_low_u = 1042.7 "Temperature at which PB starts";
    parameter String field_type = "polar";
    parameter String opt_file_prefix = "modelica://SolarTherm/Data/Optics/SodiumBoiler/polar/1MWe/5130c%/1073K/500kWpm2/";
    parameter String phi_pct_string = "100";
    parameter String opt_file = opt_file_naming(opt_file_prefix, phi_pct_string, SM_guess, HT_pct_guess, f_recv);
    //Constants
    replaceable package Medium = SolarTherm.Media.Sodium.Sodium_ph_table "Medium props for sodium";
    replaceable package PCM = SolarTherm.Materials.NaCl_10K "Material model for Sodium Chloride PCM";
    replaceable package HTF = SolarTherm.Materials.Sodium2P_Table "Material model for Sodium HTF";
    parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
    parameter Currency currency = Currency.USD "Currency used for cost analysis";
    // Weather data
    parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
    parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";
    parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)";
    //Alice Springs
    parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)";
    //Alice Springs
    parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
    parameter Integer year = 1996 "Meteorological year";
    // Heliostat Field
    parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
    //declination-hourangle
    //parameter String SM_string = String(1 * SolarTherm.Utilities.Round(SM_guess * 10))+ "dSM/" "Solar Multiple rounded to the nearest 0.1, multiplied by 10 and converted to string";
    parameter Real HT_pct_guess = 74.56;
    //parameter String phi_pct_string = (if field_type == "polar" then "100%phi_" else "100%phi_");
    //parameter String HT_pct_string = String(5 * SolarTherm.Utilities.Round(HT_pct_guess * 0.2)) + "%HT";
    parameter Real land_mult = 5.0 "Land area multiplier";
    //is it polar or surround??
    parameter Real he_av_design = 0.99 "Helisotats availability";
    //parameter String opt_file_prefix = "modelica://SolarTherm/Data/Optics/SodiumBoiler/"+field_type+"/1MWe/5130c%/1073K/500kWpm2/" + SM_string + "isp_designpt/" + phi_pct_string + HT_pct_string;
    //where to find the optics file
    parameter SI.Energy helio_E_start = 90e3 * A_heliostat / 144.375 "Heliostat startup energy consumption";
    parameter SI.Power helio_W_track = 0.0553 * A_heliostat / 144.375 "Heliostat tracking power";
    parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
    parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
    parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
    parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
    parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
    parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
    //Determine the optics file(s) needed to simulate this case and the interpolation weight
    //parameter String[2] opt_file_list = SolarTherm.Utilities.Interpolation.OpticsTableNames(opt_file_prefix, f_recv);
    //parameter String opt_file = Modelica.Utilities.Files.loadResource(opt_file_list[1]);
    //parameter Real opt_file_weight = SolarTherm.Utilities.Interpolation.OpticsTableWeight(opt_file_prefix, f_recv);
    //Metadata from the optical lookup table file(s)
    parameter Real[8] MetaA = SolarTherm.Utilities.Metadata_Optics(opt_file);
    //List of metadata values for field A
    //parameter Real[8] MetaB = SolarTherm.Utilities.Metadata_Optics(opt_file_B);
    //List of metadata values for field B
    parameter Integer n_heliostat = SolarTherm.Utilities.Round(MetaA[1]) "Number of heliostats";
    parameter SI.Area A_heliostat = MetaA[2] "Area of one heliostat";
    parameter Real eff_opt_des = MetaA[3];
    // + opt_file_weight * (MetaB[3] - MetaA[3]) "Design optical efficiency (interpolated)";
    parameter SI.Length H_recv = MetaA[4];
    // + opt_file_weight * (MetaB[4] - MetaA[4]) "Height of the receiver (interpolated)";
    parameter SI.Length D_recv = MetaA[5];
    // + opt_file_weight * (MetaB[5] - MetaA[5]) "Diameter/Width of the receiver (interpolated)";
    parameter SI.Length H_tower = MetaA[6] "Height of the tower";
    parameter SI.Area A_field = A_heliostat * n_heliostat "Area of the entire field (reflective area)";
    parameter SI.Area A_land = land_mult * A_field "Land area occupied by the plant";
    //Receiver
    parameter SI.Area A_recv = if field_type == "polar" then H_recv * D_recv else H_recv * D_recv * CN.pi "Receiver area";
    parameter Integer N_pa_recv = 20 "Number of panels in receiver";
    parameter SI.Thickness t_tb_recv = 1.25e-3 "Receiver tube wall thickness";
    parameter SI.Diameter D_tb_recv = 40e-3 "Receiver tube outer diameter";
    parameter SI.Efficiency ab_recv = 0.961 "Receiver coating absorptance";
    parameter SI.Efficiency em_recv = 0.92 "Receiver coating emissivity";
    parameter SI.CoefficientOfHeatTransfer h_conv_recv = 10.0 "W/m2K";
    //constant receiver convection loss coeff (maybe used)
    parameter SI.TemperatureDifference T_superheat = 50.0 "Superheat during boiling of sodium at the receiver (K)";
    // Storage
    parameter Real tank_ar = 1 "storage aspect ratio";
    parameter Real f_packing_xy = 0.80 "Horizontal(xy) packing factor of PCM trays defined as A_tray_base/A_tank_base";
    parameter Real f_packing_z = 0.80 "Vertical(z) packing factor of PCM trays defined as z_tray/z_tank";
    parameter SI.Volume V_tank = N_tray * CN.pi * d_tray * d_tray * z_tray / (4.0 * f_packing_xy * f_packing_xy) "Total volume of a cylindrical tank with aspect ratio ar, m3";
    parameter Real ar_tank = 1.0 "Aspect ratio height(z)/diameter(d) of tank";
    parameter Real f_PCM_expansion = 1.40 "Expansion factor from 298.15K to 1123K of PCM (50K above melting)";
    //fixed
    parameter SI.Area A_pertray = CN.pi * d_tray * d_tray * 0.25 "Cross sectional area per tray, m2";
    parameter SI.Area d_tank = (4.0 * V_tank / (CN.pi * ar_tank)) ^ (1.0 / 3.0) "Diameter of the storage tank in, m";
    parameter SI.Length z_tank = ar_tank * d_tank "Height of the storage tank, m";
    parameter SI.Area A_loss_tank = CN.pi * (0.5 * d_tank * d_tank + d_tank * z_tank) "Total surface area of the tank used for thermal loss calculation";
    //Graphite
    parameter SI.Energy E_max_min = t_storage * 3600 * Q_flow_ref_blk "Minimum storage size required by the design, real storage size is slightly above this";
    parameter SI.Mass m_PCM_min = E_max_min / (PCM.h_Tf(T_up_u, 1.0) - PCM.h_Tf(T_low_l, 0.0)) "Minimum mass of PCM required by the design, real mass of PCM is slightly above this";
    parameter SI.Area A_PCM_min = m_PCM_min / (z_PCM * PCM.rho_Tf(298.15, 0.0)) "Minimum required area of PCM";
    parameter Integer N_tray = integer(ceil(A_PCM_min / A_pertray)) "Number of PCM trays must be an integer";
    parameter SI.Area A_PCM = N_tray * A_pertray "Actual crpss sectional area of PCM";
    parameter SI.Mass m_PCM = A_PCM * z_PCM * PCM.rho_Tf(298.15, 0.0) "True mass of PCM used in the storage, constrained by integer of number of trays";
    parameter SI.Energy E_max = m_PCM * (PCM.h_Tf(T_up_u, 1.0) - PCM.h_Tf(T_low_l, 0.0)) "True theoretical energy storage capacity of the PCM";
    parameter SI.Mass m_HTF = f_HTF_inventory * 760.0 * 0.25 * CN.pi * d_tray * d_tray * (z_tray - z_PCM) * N_tray "Mass of sodium in the vessel, kg";
    parameter SI.Length z_tray = z_PCM * f_PCM_expansion * f_PCM_safety "Tray wall height, m";
    parameter SI.Length d_tray = 1.0 "Diameter of the tray base, m";
    //also used for Nusselt number correlation
    parameter SI.ThermodynamicTemperature T_start = T_low_l "Starting temperature of the simulation, K";
    parameter Integer nodes = 20 "Number of discretization elements of PCM";
    parameter Real growth_ratio = 1.1 "Geometric growth ratio of initial mesh thickness, refined mesh at top and bottom surfaces";
    //Controls, pumps , etc
    parameter SI.Temperature T_max = 1123.0 "Absolute maximum temperature where receiver is shut off";
    parameter SI.Temperature T_up_u = 1118.0 "Temperature at which defocusing starts";
    parameter SI.Temperature T_up_l = 1108.0 "Temperature at which defocusing stops";
    parameter SI.Temperature T_PCM_melt = PCM.T_melt "Melting temperature of PCM";
    parameter SI.Temperature T_low_l = 1028.0 "Temperature at which PB stops";
    parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold pump parasitic power coefficient";
    parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot pump parasitic power coefficient";
    //Design values
    parameter SI.Irradiance dni_des = SolarTherm.Utilities.DNI_Models.Meinel(abs(lat)) "Design point DNI value";
    parameter Real SM = Q_flow_rec_des / Q_flow_ref_blk "Real solar multiple";
    //Enthalpies
    parameter SI.SpecificEnthalpy h_in_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, 1073.0, {0.0, 1.0})) "Specific enthalpy of sodium completely in vapor phase at 1073K";
    parameter SI.SpecificEnthalpy h_out_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, 1073.0, {1.0, 0.0})) "Specific enthalpy of sodium completely in liquid phase at 1073K";
    parameter SI.SpecificEnthalpy h_in_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, 1073.0, {1.0, 0.0})) "Specific enthalpy of sodium completely in liquid phase at 1073K";
    parameter SI.SpecificEnthalpy h_out_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, 1073.0, {0.0, 0.2})) "Specific enthalpy of sodium cwith vapor quality of 0.2 at 1073K";
    //Heat Flow Rates
    parameter SI.HeatFlowRate Q_flow_ref_blk = P_gross_des / eff_blk_des "design heat input rate into the PB";
    parameter SI.HeatFlowRate Q_flow_ref_blk_def = P_gross_des / eff_blk_def "design heat input rate to PB during defocus (higher efficiency)";
    parameter SI.HeatFlowRate Q_flow_rec_loss_def = CN.sigma * em_recv * A_recv * ((T_up_u + T_superheat) ^ 4 - 298.15 ^ 4) + h_conv_recv * A_recv * (T_up_u + T_superheat - 298.15) "Receiver defocus heat loss rate";
    parameter SI.HeatFlowRate Q_flow_tank_loss_def = A_loss_tank * U_loss_tank * (T_up_u - 298.15) "Tank defocus heat loss rate";
    parameter SI.HeatFlowRate Q_flow_rec_loss_des = CN.sigma * em_recv * A_recv * ((T_PCM_melt + T_superheat) ^ 4 - 298.15 ^ 4) + h_conv_recv * A_recv * (T_PCM_melt + T_superheat - 298.15) "Receiver design heat loss rate";
    parameter SI.HeatFlowRate Q_flow_tank_loss_des = A_loss_tank * U_loss_tank * (T_PCM_melt - 298.15) "Tank design heat loss rate";
    parameter SI.HeatFlowRate Q_flow_rec_des = dni_des * he_av_design * eff_opt_des * A_field * ab_recv - Q_flow_rec_loss_des "Receiver Thermal power output at design";
    parameter SI.HeatFlowRate Q_flow_defocus = (Q_flow_ref_blk_def + Q_flow_rec_loss_def + Q_flow_tank_loss_def) / ab_recv "Solar field thermal power at defocused state";
    //Mass flow rates
    parameter SI.MassFlowRate m_flow_blk_des = Q_flow_ref_blk / (h_in_ref_blk - h_out_ref_blk) "Design point mass flow rate of sodium vapor condensing into the power block";
    parameter SI.MassFlowRate m_flow_recv_des = Q_flow_rec_des / (h_out_ref_recv - h_in_ref_recv) "Design mass flow rate into recv";
    // Power block
    parameter String engine_brand = "75%Carnot" "Power block brand {SES,75%Carnot}";
    parameter SI.Power P_gross_des = 1.11e6 "Power block gross rating at design point";
    parameter SI.Power P_name_des = 1.00e6 "Power block nameplate rating";
    parameter SI.Power P_name = P_name_des;
    parameter SI.Temperature T_pb_cool_des = 323.0 "Design cooling temperature of PB";
    parameter SI.Efficiency eff_net_des = 0.9 "Power block net efficiency rating";
    parameter SI.Efficiency eff_blk_des = if engine_brand == "SES" then 0.7893 * (1.0 - (T_pb_cool_des / T_PCM_melt) ^ 0.5) else 0.75 * (1.0 - T_pb_cool_des / T_PCM_melt) "Power block efficiency at design point";
    parameter SI.Efficiency eff_blk_def = if engine_brand == "SES" then 0.7893 * (1.0 - (T_pb_cool_des / T_up_u) ^ 0.5) else 0.75 * (1.0 - T_pb_cool_des / T_up_u) "Power block efficiency at design point";
    parameter SI.Time PB_startup = 20.0 * 60.0 "Startup ramping time of striling engine is 20mins";
    // Cost data in USD (default) or AUD
    parameter Real r_disc = 0.07 "Real discount rate";
    parameter Real r_i = 0.03 "Inflation rate";
    parameter Integer t_life(unit = "year") = 27 "Lifetime of plant";
    parameter Integer t_cons(unit = "year") = 3 "Years of construction";
    parameter Real r_cur = 0.71 "The currency rate from AUD to USD";
    // Valid for 2019. See https://www.rba.gov.au/
    parameter Real f_Subs = 0 "Subsidies on initial investment costs";
    parameter FI.AreaPrice pri_field = if currency == Currency.USD then 140.00 else 140.00 / r_cur "Field cost per design aperture area";
    // SAM 2018 cost data: 177*(603.1/525.4) in USD. Note that (603.1/525.4) is CEPCI index from 2007 to 2018
    parameter FI.AreaPrice pri_site = if currency == Currency.USD then 16.00 else 16.00 / r_cur "Site improvements cost per area";
    // SAM 2018 cost data: 16
    //parameter FI.EnergyPrice pri_storage = if currency == Currency.USD then 37 / (1e3 * 3600) else 37 / (1e3 * 3600) / r_cur "Storage cost per energy capacity";
    // SAM 2018 cost data: 22 / (1e3 * 3600)
    parameter FI.PowerPrice pri_block = if currency == Currency.USD then 1360.00 / 1e3 else 1360.00 / 1e3 / r_cur "Power block cost per gross rated power";
    // SAM 2018 cost data: 1040
    parameter FI.PowerPrice pri_bop = if currency == Currency.USD then 0.29 else 0.29 "Balance of plant cost per gross rated power";
    //SAM 2018 cost data: 290
    parameter FI.AreaPrice pri_land = if currency == Currency.USD then 2.47 else 2.47 "Land cost per area";
    parameter Real pri_om_name(unit = "$/W/year") = if currency == Currency.USD then 75.00 / 1e3 else 75.00 / 1e3 / r_cur "Fixed O&M cost per nameplate per year";
    //SAM 2018 cost data: 66
    parameter Real pri_om_prod(unit = "$/J/year") = if currency == Currency.USD then 4.00 / (1e6 * 3600) else 4.00 / (1e6 * 3600) / r_cur "Variable O&M cost per production per year";
    //SAM 2018 cost data: 3.5
    parameter FI.Money C_field = pri_field * A_field "Field cost";
    parameter FI.Money C_site = pri_site * A_field "Site improvements cost";
    parameter FI.Money C_tower = 3850.0 * H_tower "Tower cost";
    parameter FI.Money C_receiver = 85675.0 * A_recv "Receiver cost";
    // SAM 2018 cost data: 103e6 * (A_receiver / 1571) ^ 0.7
    parameter FI.Money C_storage = tankHot.C_Storage "Storage cost";
    parameter FI.Money C_block = pri_block * P_gross_des "Power block cost";
    parameter FI.Money C_bop = pri_bop * P_gross_des "Balance of plant cost";
    parameter FI.Money C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop) "Direct capital cost subtotal";
    // i.e. purchased equipment costs
    parameter FI.Money C_contingency = 0.07 * C_cap_dir_sub "Contingency costs";
    parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
    parameter FI.Money C_EPC = 0.11 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
    // SAM 2018 cost data: 0.13
    parameter FI.Money C_land = pri_land * A_land "Land cost";
    parameter FI.Money C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
    parameter FI.MoneyPerYear C_year = pri_om_name * P_name_des "Fixed O&M cost per year";
    parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Variable O&M cost per production per year";
    // System components
    // *********************
    //Weather data
    SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
      Placement(visible = true, transformation(origin = {-161, 92}, extent = {{-11, -10}, {11, 10}}, rotation = 0)));
    //DNI_input
    Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
      Placement(visible = true, transformation(extent = {{-128, 60}, {-108, 80}}, rotation = 0)));
    //Tamb_input
    Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
      Placement(visible = true, transformation(origin = {119, 80}, extent = {{11, -10}, {-11, 10}}, rotation = 0)));
    //WindSpeed_input
    Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
      Placement(visible = true, transformation(extent = {{-128, 38}, {-102, 58}}, rotation = 0)));
    //pressure_input
    //parasitic inputs
    Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold.W_loss) annotation(
      Placement(visible = true, transformation(origin = {125, 66}, extent = {{-17, -10}, {17, 10}}, rotation = 180)));
    // Or block for defocusing
    //Sun
    SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
      Placement(visible = true, transformation(extent = {{-88, 60}, {-68, 80}}, rotation = 0)));
    // Solar heliostat field
    SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(n_h = n_heliostat, lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus, nu_start = nu_start, redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table_Full(angles = angles, file = opt_file)) annotation(
      Placement(visible = true, transformation(origin = {-78, 24}, extent = {{-14, -16}, {14, 16}}, rotation = 0)));
    // Hot Pump (power block)
    SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium, k_loss = k_loss_hot) annotation(
      Placement(visible = true, transformation(origin = {63, 11}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
    // Cold pump (receiver)
    SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium, k_loss = k_loss_cold) annotation(
      Placement(visible = true, transformation(origin = {-9, 11}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
    //Market
    SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
      Placement(visible = true, transformation(origin = {134, 20}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    //Receiver
    SolarTherm.Models.CSP.CRS.Receivers.SB_Receiver receiver(redeclare package Medium = Medium, concept = if field_type == "polar" then "Billboard" else "Cylindrical", convection = "Siebers", H_tower = H_tower, H_rcv = H_recv, D_rcv = D_recv, N_pa = N_pa_recv, D_tb = D_tb_recv, t_tb = t_tb_recv, ab = ab_recv, em = em_recv, T_0 = T_PCM_melt, h_c_const = h_conv_recv, T_super = T_superheat) annotation(
      Placement(visible = true, transformation(origin = {-40, 26}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
    //Storage
    SolarTherm.Models.Storage.PCM.DirectContact.SB_PCMStorage2 tankHot(z_tank = z_tank, d_tank = d_tank, t_tank = 10e-3, z_tray = z_tray, d_tray = d_tray, t_tray = 10e-3, N_tray = N_tray, z_PCM = z_PCM, m_HTF = m_HTF, n = nodes, growth_ratio = growth_ratio, T_max = T_up_u, T_min = T_low_l, T_start = T_low_l, U_loss_tank = U_loss_tank, Q_flow_ref_blk = Q_flow_ref_blk, redeclare package PCM_Package = PCM, redeclare package HTF_Package = HTF, redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {27, 25}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
    //Loop Breakers
    SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker1(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {-17, 35}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
    SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker2(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {67, 35}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
    //Cold Controller (Receiver)
    SolarTherm.Models.Control.SB_ReceiverControl controlCold(T_df_on = T_up_u, T_df_off = T_up_l, Q_flow_recv_des = Q_flow_rec_des, m_flow_recv_des = m_flow_recv_des) annotation(
      Placement(visible = true, transformation(origin = {-39, -25}, extent = {{7, -7}, {-7, 7}}, rotation = 0)));
    //Hot Controller (Power Block)
    SolarTherm.Models.Control.SB_PowerBlockControl controlHot(T_on = T_low_u, T_off = T_low_l, m_flow_ref = m_flow_blk_des) annotation(
      Placement(visible = true, transformation(origin = {63, -25}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
    //Power Block
    SolarTherm.Models.PowerBlocks.SB_StirlingPowerBlockModel powerBlock(redeclare package Medium = Medium, P_name = P_name_des, nu_net = 0.9, T_in_ref = T_PCM_melt, T_out_ref = T_PCM_melt, T_cool_des = T_pb_cool_des, engine_brand = engine_brand, W_base = 0.0055 * P_gross_des, m_flow_ref = m_flow_blk_des) annotation(
      Placement(visible = true, transformation(origin = {94, 21}, extent = {{-24, -23}, {24, 23}}, rotation = 0)));
    //Annual Simulation variables
    SI.Power P_elec "Output power of power block";
    SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
    FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
    Boolean constrained(start = false);
    Real distance(start = 0);
    //Analytics
    //Accumulated energy
    SI.Energy E_resource(start = 0) "Integral of DNI with time if greater than zero";
    SI.Energy E_helio_incident(start = 0) "Cumulative heat energy incident on heliostats after curtailment (low-DNI/high-wind)";
    SI.Energy E_helio_raw(start = 0) "Cumulative heat energy delivered by field to receiver after he_av losses + optical losses";
    SI.Energy E_helio_net(start = 0) "Cumulative heat energy delivered by field to receiver after defocusing losses";
    SI.Energy E_recv_absorbed(start = 0) "Cumulative heat energy absorbed by the receiver before re-emission and convection";
    SI.Energy E_recv_output(start = 0) "Cumulative heat energy outputted by the receiver after thermal losses";
    SI.Energy E_PB_input(start = 0) "Cumulative heat energy inputted into the power block";
    SI.Energy E_PB_gross(start = 0) "Cumulative gross electrical energy produced by the power block";
    SI.Energy E_PB_net(start = 0) "Cumulative electrical output of the power block after parasitics and generator losses";
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
    //Annual efficiencies
    Real eta_curtail_off "Curtailment: Heliostat off";
    Real eta_he_av "Heliostat Availability";
    Real eta_optical "Field optical efficiency including spillage";
    Real eta_curtail_defocus "Curtailment: Full Storage";
    Real eta_recv_abs "Receiver Absorptivity";
    Real eta_recv_thermal "Receiver thermal efficiency";
    Real eta_storage "Storage thermal efficiency";
    Real eta_pb_gross "Power block gross efficiency";
    Real eta_pb_net "Power block net efficiency";
    Real eta_solartoelec "Solar to electric";
    //End Analytics
    Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
      Placement(visible = true, transformation(origin = {185, 102}, extent = {{11, -10}, {-11, 10}}, rotation = 0)));
  algorithm
    if time > 60.0 then
      if tankHot.m_avail < 1.0e-6 then
        constrained := true;
        distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
        terminate("Receiver Dries Out");
      elseif tankHot.L_total > z_tray then
        constrained := true;
        distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
        terminate("Liquid PCM spills out the tray");
      elseif tankHot.T_HTF < 600.0 then
        constrained := true;
        distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
        terminate("Tank gets too cold to continue");
      elseif tankHot.x_HTF < 0.0 or tankHot.x_HTF > 1.0 then
        constrained := true;
        distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
        terminate("Invalid Quality");
      end if;
    end if;
    when time > 43200 then
      if heliostatsField.optical.isp_min < 1e-3 then
        constrained := true;
        distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
        terminate("Bad aiming");
      end if;
    end when;
//Annual Efficieny
    if time > 31449600 then
      eta_curtail_off := E_helio_incident / E_resource;
      eta_optical := E_helio_raw / (E_helio_incident * he_av_design);
      eta_he_av := he_av_design;
      eta_curtail_defocus := E_helio_net / E_helio_raw;
      eta_recv_abs := E_recv_absorbed / E_helio_net;
      eta_recv_thermal := E_recv_output / E_recv_absorbed;
      eta_storage := E_PB_input / E_recv_output;
      eta_pb_gross := E_PB_gross / E_PB_input;
      eta_pb_net := E_PB_net / E_PB_gross;
      eta_solartoelec := E_PB_net / E_resource;
      eta_shading := sum_shading / sum_timehelio;
      eta_cosine := sum_cosine / sum_timehelio;
      eta_reflection := sum_reflection / sum_timehelio;
      eta_blocking := sum_blocking / sum_timehelio;
      eta_attenuation := sum_attenuation / sum_timehelio;
      eta_intercept := sum_intercept / sum_timehelio;
    end if;
//Optics
  equation
//Analytics
//Cumulative heat
    der(E_resource) = max(sun.dni * A_field, 0.0);
    der(E_helio_incident) = if heliostatsField.on_internal then heliostatsField.n_h * heliostatsField.A_h * max(0.0, heliostatsField.solar.dni) else 0.0;
    der(E_helio_raw) = heliostatsField.Q_raw;
    der(E_helio_net) = heliostatsField.Q_net;
    der(E_recv_absorbed) = receiver.ab * receiver.heat.Q_flow;
    der(E_recv_output) = receiver.Q_rcv;
    der(E_PB_input) = powerBlock.Q_flow;
    der(E_PB_gross) = powerBlock.W_gross;
    der(E_PB_net) = powerBlock.W_net;
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
//Connections from data
    connect(DNI_input.y, sun.dni) annotation(
      Line(points = {{-107, 70}, {-89, 70}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(Wspd_input.y, heliostatsField.Wspd) annotation(
      Line(points = {{-101, 48}, {-96.35, 48}, {-96.35, 34}, {-92, 34}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
// Fluid connections
// controlCold connections
// controlHot connections
//Solar field connections i.e. solar.heat port and control
    connect(sun.solar, heliostatsField.solar) annotation(
      Line(points = {{-78, 60}, {-78, 40}}, color = {255, 128, 0}));
//PowerBlock connections
    P_elec = powerBlock.W_net;
    E_elec = powerBlock.E_net;
    R_spot = market.profit;
    connect(heliostatsField.heat, receiver.heat) annotation(
      Line(points = {{-64, 32}, {-58, 32}, {-58, 31}}, color = {191, 0, 0}));
    connect(tankHot.fluid_br, pumpCold.fluid_a) annotation(
      Line(points = {{8, 12}, {1, 12}, {1, 11}, {-4, 11}}, color = {0, 127, 255}));
    connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
      Line(points = {{-14, 11}, {-23.5, 11}, {-23.5, 10}, {-36, 10}}, color = {0, 127, 255}));
    connect(receiver.fluid_b, loop_breaker1.port_a) annotation(
      Line(points = {{-34, 35}, {-21, 35}}, color = {0, 127, 255}));
    connect(loop_breaker1.port_b, tankHot.fluid_ar) annotation(
      Line(points = {{-14, 35}, {-6.5, 35}, {-6.5, 34.5}, {8, 34.5}}, color = {0, 127, 255}));
    connect(receiver.Q_recv_in, controlCold.Q_recv_in) annotation(
      Line(points = {{-35.5, 26}, {-26, 26}, {-26, -21}, {-31, -21}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(tankHot.T_storage, controlCold.T_stor) annotation(
      Line(points = {{27, 4}, {0, 4}, {0, -29}, {-31, -29}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(tankHot.T_storage, controlHot.T_stor) annotation(
      Line(points = {{27, 4}, {52, 4}, {52, -25}, {56, -25}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(pumpHot.fluid_b, tankHot.fluid_ap) annotation(
      Line(points = {{58, 11}, {56, 11}, {56, 12}, {46, 12}}, color = {0, 127, 255}));
    connect(tankHot.fluid_bp, loop_breaker2.port_a) annotation(
      Line(points = {{46, 34.5}, {59, 34.5}, {59, 35}, {63, 35}}, color = {0, 127, 255}));
    connect(controlHot.m_flow_PB, pumpHot.m_flow) annotation(
      Line(points = {{71, -25}, {76, -25}, {76, 20}, {63, 20}, {63, 15}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(controlCold.m_flow_recv, pumpCold.m_flow) annotation(
      Line(points = {{-47, -21}, {-55, -21}, {-55, -6}, {-17, -6}, {-17, 24}, {-9, 24}, {-9, 15}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(powerBlock.T_amb, Tamb_input.y) annotation(
      Line(points = {{89, 35}, {89, 80}, {107, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(loop_breaker2.port_b, powerBlock.fluid_a) annotation(
      Line(points = {{70, 35}, {83, 35}, {83, 29}}, color = {0, 127, 255}));
    connect(pumpHot.fluid_a, powerBlock.fluid_b) annotation(
      Line(points = {{68, 11}, {80, 11}}));
    connect(powerBlock.W_net, market.W_net) annotation(
      Line(points = {{106, 20}, {122, 20}}, color = {0, 0, 127}));
    connect(Tamb_input.y, receiver.Tamb) annotation(
      Line(points = {{107, 80}, {-36, 80}, {-36, 40}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(Wspd_input.y, receiver.Wspd) annotation(
      Line(points = {{-101, 48}, {-44, 48}, {-44, 40}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(Tamb_input.y, tankHot.T_amb) annotation(
      Line(points = {{107, 80}, {43, 80}, {43, 46}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(receiver.net_gain, controlCold.net_gain) annotation(
      Line(points = {{-35.5, 19}, {-22, 19}, {-22, -25}, {-31, -25}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
    connect(controlCold.defocus, heliostatsField.defocus) annotation(
      Line(points = {{-48, -30}, {-112, -30}, {-112, 14}, {-92, 14}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
    connect(parasities_input.y, powerBlock.parasities) annotation(
      Line(points = {{106, 66}, {103.5, 66}, {103.5, 35}, {99, 35}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    annotation(
      Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(origin = {-12, 4}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 14, fontName = "Liberation Serif"), Text(origin = {4, 8}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 14, fontName = "Liberation Serif"), Text(origin = {-22, 10}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 14, fontName = "Liberation Serif"), Text(origin = {4, -33}, extent = {{0, 29}, {46, 19}}, textString = "Storage Tank", fontSize = 14, fontName = "Liberation Serif"), Text(origin = {-10, -6}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 14, fontName = "Liberation Serif"), Text(origin = {-8, -10}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 14, fontName = "Liberation Serif"), Text(origin = {-44, 114}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 14, fontName = "Liberation Serif"), Text(origin = {-64, -84}, extent = {{0, 58}, {54, 38}}, textString = "Receiver Control", fontSize = 14, fontName = "Liberation Serif"), Text(origin = {40, -84}, extent = {{0, 58}, {48, 38}}, textString = "PB Control", fontSize = 14, fontName = "Liberation Serif"), Text(origin = {22, 31}, extent = {{0, 29}, {46, 19}}, textString = "T_amb", fontSize = 14, fontName = "Liberation Serif"), Text(origin = {-4, -23}, extent = {{0, 29}, {46, 19}}, textString = "T_stor", fontSize = 14, fontName = "Liberation Serif")}),
      Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
      experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60, maxStepSize = 60, initialStepSize = 60),
      __Dymola_experimentSetupOutput,
      Documentation(revisions = "<html>
  	<ul>
  	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released first version. </li>
  	</ul>
  
  	</html>"));
  end SB_Polar_75Carnot;

  model SB_Surround_75Carnot
    function opt_file_naming
      input String prefix;
      //"modelica://SolarTherm/Data/Optics/SodiumBoiler/surround/Ref/"
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
      SM := max(14, min(38, 1 * round(SM_guess * 10)));
//Actually SM*10"
      HT_pct := max(50, min(130, 5 * round(HT_pct_guess * 0.2)));
      f_recv := max(70, min(200, 5 * round(f_recv_guess * 20.0)));
      SM_string := String(SM);
      HT_pct_string := String(HT_pct);
      f_recv_string := String(f_recv);
      opt_file := Modelica.Utilities.Files.loadResource(prefix + SM_string + "dSM/isp_designpt/" + phi_pct_string + "%phi_" + HT_pct_string + "%HT_" + f_recv_string + "%Arecv_optics.motab");
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
    //To be optimised
    //--Tank
    //Trays
    parameter Real f_recv = 1.31 "Receiver area multiplier to be optimised";
    parameter Real f_PCM_safety = 0.9994 "Safety factor such that PCM does not exceed wall height";
    parameter Real f_HTF_inventory = 0.9270 "Multiplier to empty volume between PCM and wall level occupied to sodium at 1073K to calculate sodium mass inventory";
    parameter SI.Length z_PCM = 0.0521 "Vertical depth of PCM in each tray, m";
    parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1159 "Heat transfer coefficient of tank losses between sodium and ambient temps, W/m2K";
    parameter Real SM_guess = 2.895 "Solar multiple";
    parameter Real t_storage(unit = "h") = 14.08 "Hours of storage";
    parameter SI.Temperature T_low_u = 1043.65 "Temperature at which PB starts";
    parameter String field_type = "surround";
    parameter String opt_file_prefix = "modelica://SolarTherm/Data/Optics/SodiumBoiler/surround/1MWe/5130c%/1073K/500kWpm2/";
    parameter String phi_pct_string = "124";
    parameter String opt_file = opt_file_naming(opt_file_prefix, phi_pct_string, SM_guess, HT_pct_guess, f_recv);
    //Constants
    replaceable package Medium = SolarTherm.Media.Sodium.Sodium_ph_table "Medium props for sodium";
    replaceable package PCM = SolarTherm.Materials.NaCl_10K "Material model for Sodium Chloride PCM";
    replaceable package HTF = SolarTherm.Materials.Sodium2P_Table "Material model for Sodium HTF";
    parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
    parameter Currency currency = Currency.USD "Currency used for cost analysis";
    // Weather data
    parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
    parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";
    parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)";
    //Alice Springs
    parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)";
    //Alice Springs
    parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
    parameter Integer year = 1996 "Meteorological year";
    // Heliostat Field
    parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
    //declination-hourangle
    //parameter String SM_string = String(1 * SolarTherm.Utilities.Round(SM_guess * 10))+ "dSM/" "Solar Multiple rounded to the nearest 0.1, multiplied by 10 and converted to string";
    parameter Real HT_pct_guess = 64.63;
    //parameter String phi_pct_string = (if field_type == "polar" then "100%phi_" else "100%phi_");
    //parameter String HT_pct_string = String(5 * SolarTherm.Utilities.Round(HT_pct_guess * 0.2)) + "%HT";
    parameter Real land_mult = 5.0 "Land area multiplier";
    //is it polar or surround??
    parameter Real he_av_design = 0.99 "Helisotats availability";
    //parameter String opt_file_prefix = "modelica://SolarTherm/Data/Optics/SodiumBoiler/"+field_type+"/1MWe/5130c%/1073K/500kWpm2/" + SM_string + "isp_designpt/" + phi_pct_string + HT_pct_string;
    //where to find the optics file
    parameter SI.Energy helio_E_start = 90e3 * A_heliostat / 144.375 "Heliostat startup energy consumption";
    parameter SI.Power helio_W_track = 0.0553 * A_heliostat / 144.375 "Heliostat tracking power";
    parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
    parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
    parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
    parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
    parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
    parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
    //Determine the optics file(s) needed to simulate this case and the interpolation weight
    //parameter String[2] opt_file_list = SolarTherm.Utilities.Interpolation.OpticsTableNames(opt_file_prefix, f_recv);
    //parameter String opt_file = Modelica.Utilities.Files.loadResource(opt_file_list[1]);
    //parameter Real opt_file_weight = SolarTherm.Utilities.Interpolation.OpticsTableWeight(opt_file_prefix, f_recv);
    //Metadata from the optical lookup table file(s)
    parameter Real[8] MetaA = SolarTherm.Utilities.Metadata_Optics(opt_file);
    //List of metadata values for field A
    //parameter Real[8] MetaB = SolarTherm.Utilities.Metadata_Optics(opt_file_B);
    //List of metadata values for field B
    parameter Integer n_heliostat = SolarTherm.Utilities.Round(MetaA[1]) "Number of heliostats";
    parameter SI.Area A_heliostat = MetaA[2] "Area of one heliostat";
    parameter Real eff_opt_des = MetaA[3];
    // + opt_file_weight * (MetaB[3] - MetaA[3]) "Design optical efficiency (interpolated)";
    parameter SI.Length H_recv = MetaA[4];
    // + opt_file_weight * (MetaB[4] - MetaA[4]) "Height of the receiver (interpolated)";
    parameter SI.Length D_recv = MetaA[5];
    // + opt_file_weight * (MetaB[5] - MetaA[5]) "Diameter/Width of the receiver (interpolated)";
    parameter SI.Length H_tower = MetaA[6] "Height of the tower";
    parameter SI.Area A_field = A_heliostat * n_heliostat "Area of the entire field (reflective area)";
    parameter SI.Area A_land = land_mult * A_field "Land area occupied by the plant";
    //Receiver
    parameter SI.Area A_recv = if field_type == "polar" then H_recv * D_recv else H_recv * D_recv * CN.pi "Receiver area";
    parameter Integer N_pa_recv = 20 "Number of panels in receiver";
    parameter SI.Thickness t_tb_recv = 1.25e-3 "Receiver tube wall thickness";
    parameter SI.Diameter D_tb_recv = 40e-3 "Receiver tube outer diameter";
    parameter SI.Efficiency ab_recv = 0.961 "Receiver coating absorptance";
    parameter SI.Efficiency em_recv = 0.92 "Receiver coating emissivity";
    parameter SI.CoefficientOfHeatTransfer h_conv_recv = 10.0 "W/m2K";
    //constant receiver convection loss coeff (maybe used)
    parameter SI.TemperatureDifference T_superheat = 50.0 "Superheat during boiling of sodium at the receiver (K)";
    // Storage
    parameter Real tank_ar = 1 "storage aspect ratio";
    parameter Real f_packing_xy = 0.80 "Horizontal(xy) packing factor of PCM trays defined as A_tray_base/A_tank_base";
    parameter Real f_packing_z = 0.80 "Vertical(z) packing factor of PCM trays defined as z_tray/z_tank";
    parameter SI.Volume V_tank = N_tray * CN.pi * d_tray * d_tray * z_tray / (4.0 * f_packing_xy * f_packing_xy) "Total volume of a cylindrical tank with aspect ratio ar, m3";
    parameter Real ar_tank = 1.0 "Aspect ratio height(z)/diameter(d) of tank";
    parameter Real f_PCM_expansion = 1.40 "Expansion factor from 298.15K to 1123K of PCM (50K above melting)";
    //fixed
    parameter SI.Area A_pertray = CN.pi * d_tray * d_tray * 0.25 "Cross sectional area per tray, m2";
    parameter SI.Area d_tank = (4.0 * V_tank / (CN.pi * ar_tank)) ^ (1.0 / 3.0) "Diameter of the storage tank in, m";
    parameter SI.Length z_tank = ar_tank * d_tank "Height of the storage tank, m";
    parameter SI.Area A_loss_tank = CN.pi * (0.5 * d_tank * d_tank + d_tank * z_tank) "Total surface area of the tank used for thermal loss calculation";
    //Graphite
    parameter SI.Energy E_max_min = t_storage * 3600 * Q_flow_ref_blk "Minimum storage size required by the design, real storage size is slightly above this";
    parameter SI.Mass m_PCM_min = E_max_min / (PCM.h_Tf(T_up_u, 1.0) - PCM.h_Tf(T_low_l, 0.0)) "Minimum mass of PCM required by the design, real mass of PCM is slightly above this";
    parameter SI.Area A_PCM_min = m_PCM_min / (z_PCM * PCM.rho_Tf(298.15, 0.0)) "Minimum required area of PCM";
    parameter Integer N_tray = integer(ceil(A_PCM_min / A_pertray)) "Number of PCM trays must be an integer";
    parameter SI.Area A_PCM = N_tray * A_pertray "Actual crpss sectional area of PCM";
    parameter SI.Mass m_PCM = A_PCM * z_PCM * PCM.rho_Tf(298.15, 0.0) "True mass of PCM used in the storage, constrained by integer of number of trays";
    parameter SI.Energy E_max = m_PCM * (PCM.h_Tf(T_up_u, 1.0) - PCM.h_Tf(T_low_l, 0.0)) "True theoretical energy storage capacity of the PCM";
    parameter SI.Mass m_HTF = f_HTF_inventory * 760.0 * 0.25 * CN.pi * d_tray * d_tray * (z_tray - z_PCM) * N_tray "Mass of sodium in the vessel, kg";
    parameter SI.Length z_tray = z_PCM * f_PCM_expansion * f_PCM_safety "Tray wall height, m";
    parameter SI.Length d_tray = 1.0 "Diameter of the tray base, m";
    //also used for Nusselt number correlation
    parameter SI.ThermodynamicTemperature T_start = T_low_l "Starting temperature of the simulation, K";
    parameter Integer nodes = 20 "Number of discretization elements of PCM";
    parameter Real growth_ratio = 1.1 "Geometric growth ratio of initial mesh thickness, refined mesh at top and bottom surfaces";
    //Controls, pumps , etc
    parameter SI.Temperature T_max = 1123.0 "Absolute maximum temperature where receiver is shut off";
    parameter SI.Temperature T_up_u = 1118.0 "Temperature at which defocusing starts";
    parameter SI.Temperature T_up_l = 1108.0 "Temperature at which defocusing stops";
    parameter SI.Temperature T_PCM_melt = PCM.T_melt "Melting temperature of PCM";
    parameter SI.Temperature T_low_l = 1028.0 "Temperature at which PB stops";
    parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold pump parasitic power coefficient";
    parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot pump parasitic power coefficient";
    //Design values
    parameter SI.Irradiance dni_des = SolarTherm.Utilities.DNI_Models.Meinel(abs(lat)) "Design point DNI value";
    parameter Real SM = Q_flow_rec_des / Q_flow_ref_blk "Real solar multiple";
    //Enthalpies
    parameter SI.SpecificEnthalpy h_in_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, 1073.0, {0.0, 1.0})) "Specific enthalpy of sodium completely in vapor phase at 1073K";
    parameter SI.SpecificEnthalpy h_out_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, 1073.0, {1.0, 0.0})) "Specific enthalpy of sodium completely in liquid phase at 1073K";
    parameter SI.SpecificEnthalpy h_in_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, 1073.0, {1.0, 0.0})) "Specific enthalpy of sodium completely in liquid phase at 1073K";
    parameter SI.SpecificEnthalpy h_out_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, 1073.0, {0.0, 0.2})) "Specific enthalpy of sodium cwith vapor quality of 0.2 at 1073K";
    //Heat Flow Rates
    parameter SI.HeatFlowRate Q_flow_ref_blk = P_gross_des / eff_blk_des "design heat input rate into the PB";
    parameter SI.HeatFlowRate Q_flow_ref_blk_def = P_gross_des / eff_blk_def "design heat input rate to PB during defocus (higher efficiency)";
    parameter SI.HeatFlowRate Q_flow_rec_loss_def = CN.sigma * em_recv * A_recv * ((T_up_u + T_superheat) ^ 4 - 298.15 ^ 4) + h_conv_recv * A_recv * (T_up_u + T_superheat - 298.15) "Receiver defocus heat loss rate";
    parameter SI.HeatFlowRate Q_flow_tank_loss_def = A_loss_tank * U_loss_tank * (T_up_u - 298.15) "Tank defocus heat loss rate";
    parameter SI.HeatFlowRate Q_flow_rec_loss_des = CN.sigma * em_recv * A_recv * ((T_PCM_melt + T_superheat) ^ 4 - 298.15 ^ 4) + h_conv_recv * A_recv * (T_PCM_melt + T_superheat - 298.15) "Receiver design heat loss rate";
    parameter SI.HeatFlowRate Q_flow_tank_loss_des = A_loss_tank * U_loss_tank * (T_PCM_melt - 298.15) "Tank design heat loss rate";
    parameter SI.HeatFlowRate Q_flow_rec_des = dni_des * he_av_design * eff_opt_des * A_field * ab_recv - Q_flow_rec_loss_des "Receiver Thermal power output at design";
    parameter SI.HeatFlowRate Q_flow_defocus = (Q_flow_ref_blk_def + Q_flow_rec_loss_def + Q_flow_tank_loss_def) / ab_recv "Solar field thermal power at defocused state";
    //Mass flow rates
    parameter SI.MassFlowRate m_flow_blk_des = Q_flow_ref_blk / (h_in_ref_blk - h_out_ref_blk) "Design point mass flow rate of sodium vapor condensing into the power block";
    parameter SI.MassFlowRate m_flow_recv_des = Q_flow_rec_des / (h_out_ref_recv - h_in_ref_recv) "Design mass flow rate into recv";
    // Power block
    parameter String engine_brand = "75%Carnot" "Power block brand {SES,75%Carnot}";
    parameter SI.Power P_gross_des = 1.11e6 "Power block gross rating at design point";
    parameter SI.Power P_name_des = 1.00e6 "Power block nameplate rating";
    parameter SI.Power P_name = P_name_des;
    parameter SI.Temperature T_pb_cool_des = 323.0 "Design cooling temperature of PB";
    parameter SI.Efficiency eff_net_des = 0.9 "Power block net efficiency rating";
    parameter SI.Efficiency eff_blk_des = if engine_brand == "SES" then 0.7893 * (1.0 - (T_pb_cool_des / T_PCM_melt) ^ 0.5) else 0.75 * (1.0 - T_pb_cool_des / T_PCM_melt) "Power block efficiency at design point";
    parameter SI.Efficiency eff_blk_def = if engine_brand == "SES" then 0.7893 * (1.0 - (T_pb_cool_des / T_up_u) ^ 0.5) else 0.75 * (1.0 - T_pb_cool_des / T_up_u) "Power block efficiency at design point";
    parameter SI.Time PB_startup = 20.0 * 60.0 "Startup ramping time of striling engine is 20mins";
    // Cost data in USD (default) or AUD
    parameter Real r_disc = 0.07 "Real discount rate";
    parameter Real r_i = 0.03 "Inflation rate";
    parameter Integer t_life(unit = "year") = 27 "Lifetime of plant";
    parameter Integer t_cons(unit = "year") = 3 "Years of construction";
    parameter Real r_cur = 0.71 "The currency rate from AUD to USD";
    // Valid for 2019. See https://www.rba.gov.au/
    parameter Real f_Subs = 0 "Subsidies on initial investment costs";
    parameter FI.AreaPrice pri_field = if currency == Currency.USD then 140.00 else 140.00 / r_cur "Field cost per design aperture area";
    // SAM 2018 cost data: 177*(603.1/525.4) in USD. Note that (603.1/525.4) is CEPCI index from 2007 to 2018
    parameter FI.AreaPrice pri_site = if currency == Currency.USD then 16.00 else 16.00 / r_cur "Site improvements cost per area";
    // SAM 2018 cost data: 16
    //parameter FI.EnergyPrice pri_storage = if currency == Currency.USD then 37 / (1e3 * 3600) else 37 / (1e3 * 3600) / r_cur "Storage cost per energy capacity";
    // SAM 2018 cost data: 22 / (1e3 * 3600)
    parameter FI.PowerPrice pri_block = if currency == Currency.USD then 1360.00 / 1e3 else 1360.00 / 1e3 / r_cur "Power block cost per gross rated power";
    // SAM 2018 cost data: 1040
    parameter FI.PowerPrice pri_bop = if currency == Currency.USD then 0.29 else 0.29 "Balance of plant cost per gross rated power";
    //SAM 2018 cost data: 290
    parameter FI.AreaPrice pri_land = if currency == Currency.USD then 2.47 else 2.47 "Land cost per area";
    parameter Real pri_om_name(unit = "$/W/year") = if currency == Currency.USD then 75.00 / 1e3 else 75.00 / 1e3 / r_cur "Fixed O&M cost per nameplate per year";
    //SAM 2018 cost data: 66
    parameter Real pri_om_prod(unit = "$/J/year") = if currency == Currency.USD then 4.00 / (1e6 * 3600) else 4.00 / (1e6 * 3600) / r_cur "Variable O&M cost per production per year";
    //SAM 2018 cost data: 3.5
    parameter FI.Money C_field = pri_field * A_field "Field cost";
    parameter FI.Money C_site = pri_site * A_field "Site improvements cost";
    parameter FI.Money C_tower = 3850.0 * H_tower "Tower cost";
    parameter FI.Money C_receiver = 85675.0 * A_recv "Receiver cost";
    // SAM 2018 cost data: 103e6 * (A_receiver / 1571) ^ 0.7
    parameter FI.Money C_storage = tankHot.C_Storage "Storage cost";
    parameter FI.Money C_block = pri_block * P_gross_des "Power block cost";
    parameter FI.Money C_bop = pri_bop * P_gross_des "Balance of plant cost";
    parameter FI.Money C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop) "Direct capital cost subtotal";
    // i.e. purchased equipment costs
    parameter FI.Money C_contingency = 0.07 * C_cap_dir_sub "Contingency costs";
    parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
    parameter FI.Money C_EPC = 0.11 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
    // SAM 2018 cost data: 0.13
    parameter FI.Money C_land = pri_land * A_land "Land cost";
    parameter FI.Money C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
    parameter FI.MoneyPerYear C_year = pri_om_name * P_name_des "Fixed O&M cost per year";
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
    //parasitic inputs
    Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold.W_loss) annotation(
      Placement(visible = true, transformation(origin = {121, 60}, extent = {{-13, -10}, {13, 10}}, rotation = 180)));
    // Or block for defocusing
    //Sun
    SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
      Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
    // Solar heliostat field
    SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(n_h = n_heliostat, lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus, nu_start = nu_start, redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table_Full(angles = angles, file = opt_file)) annotation(
      Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
    // Hot Pump (power block)
    SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium, k_loss = k_loss_hot) annotation(
      Placement(visible = true, transformation(origin = {72, 10}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
    // Cold pump (receiver)
    SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium, k_loss = k_loss_cold) annotation(
      Placement(visible = true, transformation(extent = {{0, 4}, {-12, 16}}, rotation = 0)));
    //Market
    SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
      Placement(visible = true, transformation(origin = {148, 20}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    //Receiver
    SolarTherm.Models.CSP.CRS.Receivers.SB_Receiver receiver(redeclare package Medium = Medium, concept = if field_type == "polar" then "Billboard" else "Cylindrical", convection = "Siebers", H_tower = H_tower, H_rcv = H_recv, D_rcv = D_recv, N_pa = N_pa_recv, D_tb = D_tb_recv, t_tb = t_tb_recv, ab = ab_recv, em = em_recv, T_0 = T_PCM_melt, h_c_const = h_conv_recv, T_super = T_superheat) annotation(
      Placement(visible = true, transformation(origin = {-28, 24}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    //Storage
    SolarTherm.Models.Storage.PCM.DirectContact.SB_PCMStorage2 tankHot(z_tank = z_tank, d_tank = d_tank, t_tank = 5e-3, z_tray = z_tray, d_tray = d_tray, t_tray = 5e-3, N_tray = N_tray, z_PCM = z_PCM, m_HTF = m_HTF, n = nodes, growth_ratio = growth_ratio, T_max = T_up_u, T_min = T_low_l, T_start = T_low_l, U_loss_tank = U_loss_tank, Q_flow_ref_blk = Q_flow_ref_blk, redeclare package PCM_Package = PCM, redeclare package HTF_Package = HTF, redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {33, 19}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
    //Loop Breakers
    SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker1(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {-8, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker2(redeclare package Medium = Medium) annotation(
      Placement(visible = true, transformation(origin = {74, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //Cold Controller (Receiver)
    SolarTherm.Models.Control.SB_ReceiverControl controlCold(T_df_on = T_up_u, T_df_off = T_up_l, Q_flow_recv_des = Q_flow_rec_des, m_flow_recv_des = m_flow_recv_des) annotation(
      Placement(visible = true, transformation(origin = {-32, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    //Hot Controller (Power Block)
    SolarTherm.Models.Control.SB_PowerBlockControl controlHot(T_on = T_low_u, T_off = T_low_l, m_flow_ref = m_flow_blk_des) annotation(
      Placement(visible = true, transformation(origin = {66, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //Power Block
    SolarTherm.Models.PowerBlocks.SB_StirlingPowerBlockModel powerBlock(redeclare package Medium = Medium, P_name = P_name_des, nu_net = 0.9, T_in_ref = T_PCM_melt, T_out_ref = T_PCM_melt, T_cool_des = T_pb_cool_des, engine_brand = engine_brand, W_base = 0.0055 * P_gross_des, m_flow_ref = m_flow_blk_des) annotation(
      Placement(visible = true, transformation(origin = {105, 17}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    //Annual Simulation variables
    SI.Power P_elec "Output power of power block";
    SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
    FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
    Boolean constrained(start = false);
    Real distance(start = 0);
    //Analytics
    //Accumulated energy
    SI.Energy E_resource(start = 0) "Integral of DNI with time if greater than zero";
    SI.Energy E_helio_incident(start = 0) "Cumulative heat energy incident on heliostats after curtailment (low-DNI/high-wind)";
    SI.Energy E_helio_raw(start = 0) "Cumulative heat energy delivered by field to receiver after he_av losses + optical losses";
    SI.Energy E_helio_net(start = 0) "Cumulative heat energy delivered by field to receiver after defocusing losses";
    SI.Energy E_recv_absorbed(start = 0) "Cumulative heat energy absorbed by the receiver before re-emission and convection";
    SI.Energy E_recv_output(start = 0) "Cumulative heat energy outputted by the receiver after thermal losses";
    SI.Energy E_PB_input(start = 0) "Cumulative heat energy inputted into the power block";
    SI.Energy E_PB_gross(start = 0) "Cumulative gross electrical energy produced by the power block";
    SI.Energy E_PB_net(start = 0) "Cumulative electrical output of the power block after parasitics and generator losses";
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
    //Annual efficiencies
    Real eta_curtail_off "Curtailment: Heliostat off";
    Real eta_he_av "Heliostat Availability";
    Real eta_optical "Field optical efficiency including spillage";
    Real eta_curtail_defocus "Curtailment: Full Storage";
    Real eta_recv_abs "Receiver Absorptivity";
    Real eta_recv_thermal "Receiver thermal efficiency";
    Real eta_storage "Storage thermal efficiency";
    Real eta_pb_gross "Power block gross efficiency";
    Real eta_pb_net "Power block net efficiency";
    Real eta_solartoelec "Solar to electric";
    //End Analytics
    Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
      Placement(visible = true, transformation(extent = {{138, 86}, {118, 106}}, rotation = 0)));
  algorithm
    if time > 60.0 then
      if tankHot.m_avail < 1.0e-6 then
        constrained := true;
        distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
        terminate("Receiver Dries Out");
      elseif tankHot.L_total > z_tray then
        constrained := true;
        distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
        terminate("Liquid PCM spills out the tray");
      elseif tankHot.T_HTF < 600.0 then
        constrained := true;
        distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
        terminate("Tank gets too cold to continue");
      elseif tankHot.x_HTF < 0.0 or tankHot.x_HTF > 1.0 then
        constrained := true;
        distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
        terminate("Invalid Quality");
      end if;
    end if;
    when time > 43200 then
      if heliostatsField.optical.isp_min < 1e-3 then
        constrained := true;
        distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
        terminate("Bad aiming");
      end if;
    end when;
//Annual Efficieny
    if time > 31449600 then
      eta_curtail_off := E_helio_incident / E_resource;
      eta_optical := E_helio_raw / (E_helio_incident * he_av_design);
      eta_he_av := he_av_design;
      eta_curtail_defocus := E_helio_net / E_helio_raw;
      eta_recv_abs := E_recv_absorbed / E_helio_net;
      eta_recv_thermal := E_recv_output / E_recv_absorbed;
      eta_storage := E_PB_input / E_recv_output;
      eta_pb_gross := E_PB_gross / E_PB_input;
      eta_pb_net := E_PB_net / E_PB_gross;
      eta_solartoelec := E_PB_net / E_resource;
      eta_shading := sum_shading / sum_timehelio;
      eta_cosine := sum_cosine / sum_timehelio;
      eta_reflection := sum_reflection / sum_timehelio;
      eta_blocking := sum_blocking / sum_timehelio;
      eta_attenuation := sum_attenuation / sum_timehelio;
      eta_intercept := sum_intercept / sum_timehelio;
    end if;
//Optics
  equation
//Analytics
//Cumulative heat
    der(E_resource) = max(sun.dni * A_field, 0.0);
    der(E_helio_incident) = if heliostatsField.on_internal then heliostatsField.n_h * heliostatsField.A_h * max(0.0, heliostatsField.solar.dni) else 0.0;
    der(E_helio_raw) = heliostatsField.Q_raw;
    der(E_helio_net) = heliostatsField.Q_net;
    der(E_recv_absorbed) = receiver.ab * receiver.heat.Q_flow;
    der(E_recv_output) = receiver.Q_rcv;
    der(E_PB_input) = powerBlock.Q_flow;
    der(E_PB_gross) = powerBlock.W_gross;
    der(E_PB_net) = powerBlock.W_net;
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
      Line(points = {{20, 10}, {0, 10}}, color = {0, 127, 255}));
    connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
      Line(points = {{-12, 10}, {-25, 10}}, color = {0, 127, 255}));
    connect(receiver.fluid_b, loop_breaker1.port_a) annotation(
      Line(points = {{-23, 32}, {-18, 32}, {-18, 26}, {-11, 26}}, color = {0, 127, 255}));
    connect(loop_breaker1.port_b, tankHot.fluid_ar) annotation(
      Line(points = {{-6, 26}, {9, 26}, {9, 25.5}, {20, 25.5}}, color = {0, 127, 255}));
    connect(controlCold.defocus, heliostatsField.defocus) annotation(
      Line(points = {{-44, -26}, {-44, -36}, {-94, -36}, {-94, 8}, {-88, 8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
    connect(receiver.Q_recv_in, controlCold.Q_recv_in) annotation(
      Line(points = {{-24, 24}, {-18, 24}, {-18, -14}, {-21, -14}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(tankHot.T_storage, controlCold.T_stor) annotation(
      Line(points = {{33, 5}, {33, -10}, {10, -10}, {10, -26}, {-22, -26}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(pumpHot.fluid_b, tankHot.fluid_ap) annotation(
      Line(points = {{66, 10}, {46, 10}}, color = {0, 127, 255}));
    connect(tankHot.fluid_bp, loop_breaker2.port_a) annotation(
      Line(points = {{46, 25.5}, {53, 25.5}, {53, 26}, {71, 26}}, color = {0, 127, 255}));
    connect(controlHot.m_flow_PB, pumpHot.m_flow) annotation(
      Line(points = {{77, -18}, {84, -18}, {84, 20}, {72, 20}, {72, 15}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(controlCold.m_flow_recv, pumpCold.m_flow) annotation(
      Line(points = {{-42, -14}, {-48, -14}, {-48, -6}, {-14, -6}, {-14, 24}, {-6, 24}, {-6, 16}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(parasities_input.y, powerBlock.parasities) annotation(
      Line(points = {{107, 60}, {107, 49}, {110, 49}, {110, 32}}, color = {0, 0, 127}));
    connect(powerBlock.T_amb, Tamb_input.y) annotation(
      Line(points = {{100, 32}, {100, 80}, {120, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(loop_breaker2.port_b, powerBlock.fluid_a) annotation(
      Line(points = {{76, 26}, {94, 26}, {94, 25.5}}, color = {0, 127, 255}));
    connect(pumpHot.fluid_a, powerBlock.fluid_b) annotation(
      Line(points = {{78, 10}, {81, 10}, {81, 6}, {91, 6}}));
    connect(powerBlock.W_net, market.W_net) annotation(
      Line(points = {{118, 16}, {126, 16}, {126, 20}, {136, 20}}, color = {0, 0, 127}));
    connect(Tamb_input.y, receiver.Tamb) annotation(
      Line(points = {{120, 80}, {-25, 80}, {-25, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(Wspd_input.y, receiver.Wspd) annotation(
      Line(points = {{-113, 48}, {-32, 48}, {-32, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(Tamb_input.y, tankHot.T_amb) annotation(
      Line(points = {{120, 80}, {44, 80}, {44, 33}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    connect(receiver.net_gain, controlCold.net_gain) annotation(
      Line(points = {{-24, 18}, {-16, 18}, {-16, -20}, {-22, -20}, {-22, -20}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
    connect(tankHot.T_storage, controlHot.T_stor) annotation(
      Line(points = {{34, 4}, {32, 4}, {32, -18}, {56, -18}, {56, -18}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
    annotation(
      Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(origin = {0, 6}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-16, 6}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-2, -40}, extent = {{30, 46}, {48, 38}}, textString = "T_stor", fontSize = 14, fontName = "Times New Roman"), Text(origin = {-2, -10}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, -2}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"), Text(origin = {8, -26}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif"), Text(origin = {-56, -84}, extent = {{0, 58}, {48, 38}}, textString = "Receiver Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {42, -84}, extent = {{0, 58}, {48, 38}}, textString = "PB Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {0, -4}, extent = {{30, 46}, {48, 38}}, textString = "T_amb", fontSize = 14, fontName = "Times New Roman")}),
      Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
      experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60, maxStepSize = 60, initialStepSize = 60),
      __Dymola_experimentSetupOutput,
      Documentation(revisions = "<html>
  	<ul>
  	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released first version. </li>
  	</ul>
  
  	</html>"));
  end SB_Surround_75Carnot;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end SodiumBoiler;