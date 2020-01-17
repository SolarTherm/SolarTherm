within SolarTherm.Systems;

model SodiumBoiler_PCM_sCO2
  function getMetadata_opt
    import Modelica.Utilities.Streams;
    import Modelica.Utilities.Strings;
    input String file;
    output Real[8] meta;
  protected
    String line;
    Integer i;
    Integer j;
  algorithm
    line := Streams.readLine(file, 5);
    Streams.close(file);
//i := Strings.find(line,",",1);
//assert(i > 0, "Metadata cannot be read " + file);
//assert(Strings.substring(line, 1, i-1) == "#METADATA","Metadata cannot be read " + file);
//j := Strings.find(line, ",", i+1);
//meta[1] := Strings.substring(line, i+1, j-1);
//j := 8;
    i := 10;
    j := 10;
    (meta[1], j) := Strings.scanReal(line, j + 1, message = "Metadata cannot be read " + file);
    (meta[2], j) := Strings.scanReal(line, j + 1, message = "Metadata cannot be read " + file);
    (meta[3], j) := Strings.scanReal(line, j + 1, message = "Metadata cannot be read " + file);
    (meta[4], j) := Strings.scanReal(line, j + 1, message = "Metadata cannot be read " + file);
    (meta[5], j) := Strings.scanReal(line, j + 1, message = "Metadata cannot be read " + file);
    (meta[6], j) := Strings.scanReal(line, j + 1, message = "Metadata cannot be read " + file);
    (meta[7], j) := Strings.scanReal(line, j + 1, message = "Metadata cannot be read " + file);
    (meta[8], j) := Strings.scanReal(line, j + 1, message = "Metadata cannot be read " + file);
  end getMetadata_opt;

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

  function OpticsTables
    //Determines fileA and fileB for optics interpolation and the weight
    input String file_optics;
    input Real f_receiver;
    output String[2] file_optics_list;
  protected
    Real pct;
    Integer count;
    Integer[15] List = {60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200};
    Boolean success;
    Real weight;
    String file_opticsA;
    String file_opticsB;
  algorithm
    success := false;
    count := 1;
    pct := 100.0 * f_receiver;
    if pct > 200.0 then
      file_opticsA := file_optics + "_190.motab";
      file_opticsB := file_optics + "_200.motab";
      weight := (pct - 190) / (200 - 190);
    elseif pct < 60.0 then
      file_opticsA := file_optics + "_60.motab";
      file_opticsB := file_optics + "_70.motab";
      weight := (pct - 60) / (70 - 60);
    else
      while count < 15 and success == false loop
        if pct >= List[count] and pct <= List[count + 1] then
          file_opticsA := file_optics + "_" + String(List[count]) + ".motab";
          file_opticsB := file_optics + "_" + String(List[count + 1]) + ".motab";
          weight := (pct - List[count]) / (List[count + 1] - List[count]);
          success := true;
        else
          count := count + 1;
        end if;
      end while;
    end if;
    file_optics_list := {file_opticsA, file_opticsB};
//extrapolate to the right
//extrapolate to the left
//we need to use count and count+1
  end OpticsTables;

  function OpticsTableW
    //Determines fileA and fileB for optics interpolation and the weight
    input String file_optics;
    input Real f_receiver;
    output Real weight;
  protected
    Real pct;
    Integer count;
    Integer[15] List = {60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200};
    String file_opticsA;
    String file_opticsB;
    Boolean success;
  algorithm
    success := false;
    count := 1;
    pct := 100.0 * f_receiver;
    if pct > 200.0 then
      file_opticsA := file_optics + "_190.motab";
      file_opticsB := file_optics + "_200.motab";
      weight := (pct - 190) / (200 - 190);
    elseif pct < 60.0 then
      file_opticsA := file_optics + "_60.motab";
      file_opticsB := file_optics + "_70.motab";
      weight := (pct - 60) / (70 - 60);
    else
      while count < 15 and success == false loop
        if pct >= List[count] and pct <= List[count + 1] then
          file_opticsA := file_optics + "_" + String(List[count]) + ".motab";
          file_opticsB := file_optics + "_" + String(List[count + 1]) + ".motab";
          weight := (pct - List[count]) / (List[count + 1] - List[count]);
          success := true;
        else
          count := count + 1;
        end if;
      end while;
    end if;
//extrapolate to the right
//extrapolate to the left
//we need to use count and count+1
  end OpticsTableW;

  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Solar_angles;
  extends Modelica.Icons.Example;
  // Input Parameters
  // *********************
  parameter Boolean match_sam = false "Configure to match SAM output";
  parameter Boolean fixed_field = false "true if the size of the solar field is fixed";
  //TODO implement this feature later
  replaceable package Medium = Media.MoltenSalt.MoltenSalt_ph "Medium props for molten salt";
  // Weather data
  parameter String file_weather = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  // Field
  //parameter String file_optics = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/example_optics.motab");
  //parameter Real land_mult = 1.0 "Land area multiplier";
  parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
  parameter Real he_av_design = 0.99 "Helisotats availability";
  //SolarPILOT info
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
  //parameter SI.Area A_heliostat = 144.375 "Heliostat reflective area"; //remember this is H x W x 0.97 profile
  //parameter Integer n_heliostat = 6377 "Heliostats number";
  //parameter SI.Efficiency eff_opt = 0.634100 "Efficiency of optics at design point (max in opt_file)";
  parameter SI.Irradiance dni_des = 950 "DNI at design point";
  //parameter SI.Length H_tower = 183.33 "Tower height";
  // Receiver
  parameter SI.Efficiency ab_rec = 0.961 "Receiver coating absorptance";
  parameter SI.Efficiency em_rec = 0.920 "Receiver coating emissivity";
  parameter Real land_mult = 5.0 "Land area multiplier";
  parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
  parameter Real he_av_design = 0.99 "Helisotats availability";
  parameter Real SM_guess = 1.8;
  parameter String SM_10_real = String(2 * round(SM_guess * 5));
  //Metadata format Meta = [n_heliostat(float),A_heliostat,eff_opt,H_receiver,D_receiver,H_tower,lat,f_receiver]
  parameter Real[8] MetaA = getMetadata_opt(fileA);
  parameter Real[8] MetaB = getMetadata_opt(fileB);
  parameter Integer n_heliostat = round(MetaA[1]);
  parameter SI.Area A_heliostat = MetaA[2];
  parameter Real eff_opt = MetaA[3] + weight * (MetaB[3] - MetaA[3]);
  parameter SI.Length H_receiver = MetaA[4] + weight * (MetaB[4] - MetaA[4]);
  parameter SI.Length D_receiver = MetaA[5] + weight * (MetaB[5] - MetaA[5]);
  parameter SI.Length H_tower = MetaA[6];
  //Variable Receiver Size
  parameter String file_optics = "/home/admin-u5277975/SodiumBoiler_Project/Optics/Surround/100MWe/100_" + SM_10_real + "_1000";
  //Prefix for the optics table files
  parameter String[2] file_optics_list = OpticsTables(file_optics, f_receiver);
  parameter String fileA = file_optics_list[1];
  parameter String fileB = file_optics_list[2];
  parameter Real weight = OpticsTableW(file_optics, f_receiver);
  parameter Real f_receiver = 1.0 "Receiver area multiplier";
  parameter SI.CoefficientOfHeatTransfer h_convection_receiver = 20.0 "W/m2K";
  //End Variable Receiver Size
  // Storage
  parameter Real t_storage(unit = "h") = 4 "Hours of storage";
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
  parameter SI.Power P_gross = P_name / 0.9 "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.3774 "Power block efficiency at design point";
  parameter SI.MassFlowRate m_flow_blk = 682.544 * (Q_flow_ref_blk / 294.118e6) "Mass flow rate to power block at design";
  parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";
  parameter Boolean external_parasities = true "true if there is external parasitic power losses";
  parameter Real nu_min_blk = 0.5 "minimum allowed part-load mass flow fraction to power block";
  parameter SI.Power W_base_blk = 0.0055 * P_gross "Power consumed at all times in power block";
  parameter SI.AbsolutePressure p_blk = 10e6 "Power block operating pressure";
  parameter SI.Temperature blk_T_amb_des = 316.15 "Ambient temperature at design for power block";
  parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
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
  parameter SI.Length H_tank = 20.0 * (P_name * t_storage / (100.0e6 * 4.0)) ^ (1.0 / 3.0);
  parameter SI.Length D_tank = 18.667 * (P_name * t_storage / (100.0e6 * 4.0)) ^ (1.0 / 3.0);
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
  parameter SI.HeatFlowRate Q_flow_rec_loss_des = CN.sigma * em_rec * A_receiver * (706 ^ 4 - 300 ^ 4) + h_convection_receiver * A_receiver * (706 - 300) "Receiver design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_tank_loss_des = CN.pi * D_tank * H_tank * alpha * (T_hot_set - 300.0) "Tank design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_rec_des = dni_des * eff_opt * A_field * ab_rec - Q_flow_rec_loss_des "Receiver Thermal power output at design";
  parameter SI.RadiantPower R_des = 0 "Solar field design thermal power";
  // TODO to be calculated for sizing later
  //parameter SI.Area A_field = n_heliostat * A_heliostat "Solar field reflective area";
  parameter SI.Area A_land = land_mult * A_field "Land area";
  parameter SI.Area A_field = n_heliostat * A_heliostat "Solar field reflective area";
  parameter SI.Area A_receiver = CN.pi * D_receiver * H_receiver "Receiver area";
  parameter SI.HeatFlowRate Q_flow_des = P_gross / eff_blk "Heat to power block at design point";
  parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
  parameter Real C = eff_opt * A_field / A_receiver "Concentration ratio";
  //I'm going with actual concentration ratio = (Q_receiver/A_receiver)/DNI = (opteff*A_field)/(A_receiver)
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
  parameter FI.Money C_field = pri_field * A_field "Field cost";
  parameter FI.Money C_site = pri_site * A_field "Site improvements cost";
  //parameter FI.Money C_tower = 3.0e6*exp(0.0113*H_tower) "Tower cost";
  //parameter FI.Money C_receiver = 103.0e6*((A_receiver/1571.0)^0.7) "Receiver cost";
  parameter FI.Money C_tower = 3.0e6 * exp(H_tower * 0.0113) "Tower cost";
  parameter FI.Money C_receiver = A_receiver * 65563.0 "Receiver cost";
  parameter FI.Money C_storage = pri_storage * E_max "Storage cost";
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
    Placement(visible = true, transformation(extent = {{110, 90}, {90, 110}}, rotation = 0)));
  //parasitic inputs
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss) annotation(
    Placement(visible = true, transformation(origin = {128, 63}, extent = {{-12, 9}, {12, -9}}, rotation = 180)));
  // Or block for defocusing
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
  // Solar field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(E_start = 90e3 * A_heliostat / 144.375, W_track = 0.055e3 * A_heliostat / 144.375, n_h = n_heliostat, lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus, nu_start = nu_start, redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.TwoTable(angles = angles, fileA = fileA, fileB = fileB, weight = weight)) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
  // Receiver
  //TODO
  //TODO
  //TODO
  // Hot tank
  // Pump hot
  // Cold tank
  // Pump cold
  // Temperature sensor
  // PowerBlockControl
  // ReceiverControl
  // Power block
  // Price
  SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
    Placement(visible = true, transformation(extent = {{128, 12}, {148, 32}}, rotation = 0)));
  // Variables:
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true) "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
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
  SolarTherm.Models.Storage.PCM.SB_PCMStorage2 storage(n=10) annotation(
    Placement(visible = true, transformation(origin = {28, 16}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.SB_Receiver receiver(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-30, 22}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.PowerBlockModel powerBlock(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {104, 32}, extent = {{-18, -18}, {18, 18}}, rotation = 90)));
  SolarTherm.Models.Control.SB_Control control annotation(
    Placement(visible = true, transformation(origin = {44, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {76, 6}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-6, 6}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker recvLoopBreaker(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-2, 32}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker pbLoopBreaker(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {66, 24}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
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
//equation
//Connections from data
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-119, 70}, {-102, 70}, {-102, 69.8}, {-82.6, 69.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-112.7, 30}, {-100, 30}, {-100, 29.54}, {-87.68, 29.54}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
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
    Line(points = {{-56, 28}, {-50, 28}, {-50, 28}, {-48, 28}}, color = {191, 0, 0}));
  connect(Tamb_input.y, receiver.Tamb) annotation(
    Line(points = {{120, 80}, {-30, 80}, {-30, 36}, {-30, 36}}, color = {0, 0, 127}));
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{114, 64}, {86, 64}, {86, 36}, {94, 36}, {94, 36}}, color = {0, 0, 127}));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{104, 42}, {104, 42}, {104, 48}, {122, 48}, {122, 22}, {128, 22}, {128, 22}}, color = {0, 0, 127}));
  connect(storage.T_storage, control.T_stor) annotation(
    Line(points = {{43, 29}, {44, 29}, {44, 46}, {26, 46}, {26, 66}, {34, 66}}, color = {0, 0, 127}));
  connect(control.defocus, heliostatsField.defocus) annotation(
    Line(points = {{54, 60}, {58, 60}, {58, -6}, {-88, -6}, {-88, 8}, {-88, 8}}, color = {255, 0, 255}));
  connect(Tamb_input.y, storage.T_amb) annotation(
    Line(points = {{120, 80}, {28, 80}, {28, 27}}, color = {0, 0, 127}));
  connect(powerBlock.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{112, 22}, {112, 22}, {112, 6}, {84, 6}, {84, 6}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_b, storage.fluid_ap) annotation(
    Line(points = {{68, 6}, {42, 6}, {42, 6}, {42, 6}}, color = {0, 127, 255}));
  connect(storage.fluid_br, pumpCold.fluid_a) annotation(
    Line(points = {{14, 6}, {2, 6}, {2, 6}, {2, 6}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
    Line(points = {{-14, 6}, {-26, 6}, {-26, 6}, {-26, 6}}, color = {0, 127, 255}));
  connect(control.m_flow_PB, pumpHot.m_flow) annotation(
    Line(points = {{56, 64}, {76, 64}, {76, 12}, {76, 12}}, color = {0, 0, 127}));
  connect(Tamb_input.y, powerBlock.T_amb) annotation(
    Line(points = {{120, 80}, {82, 80}, {82, 28}, {94, 28}, {94, 28}}, color = {0, 0, 127}));
  connect(receiver.m_flow_guess, control.m_flow_rec_guess) annotation(
    Line(points = {{-26, 22}, {-16, 22}, {-16, 62}, {34, 62}, {34, 62}}, color = {0, 0, 127}));
  connect(control.m_flow_recv, pumpCold.m_flow) annotation(
    Line(points = {{56, 68}, {58, 68}, {58, 76}, {-6, 76}, {-6, 12}, {-6, 12}}, color = {0, 0, 127}));
  connect(receiver.fluid_b, recvLoopBreaker.port_a) annotation(
    Line(points = {{-24, 30}, {-20, 30}, {-20, 32}, {-16, 32}}, color = {0, 127, 255}));
  connect(recvLoopBreaker.port_b, storage.fluid_ar) annotation(
    Line(points = {{12, 32}, {12, 22}, {14, 22}, {14, 24}}, color = {0, 127, 255}));
  connect(storage.fluid_bp, pbLoopBreaker.port_a) annotation(
    Line(points = {{42, 24}, {52, 24}}, color = {0, 127, 255}));
  connect(pbLoopBreaker.port_b, powerBlock.fluid_a) annotation(
    Line(points = {{80, 24}, {98, 24}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 9), Text(lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 9), Text(origin = {2, 2}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, -8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"), Text(extent = {{30, -24}, {78, -44}}, textString = "Cold Tank", fontSize = 6, fontName = "CMU Serif"), Text(origin = {26, -78}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"), Text(origin = {6, 0}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"), Text(origin = {2, 32}, extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {8, -26}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li>Alberto de la Calle:<br>Released first version. </li>
	</ul>
	</html>"));
end SodiumBoiler_PCM_sCO2;