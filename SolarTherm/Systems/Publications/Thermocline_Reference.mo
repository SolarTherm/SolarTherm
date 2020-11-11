within SolarTherm.Systems.Publications;

model Thermocline_Reference
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
    f_recv := max(70, min(130, 5 * round(f_recv_guess * 20.0)));
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
  //Concept Parameters
  parameter SI.Temperature T_des_high = 740.0 + 273.15 "Ideal high temperature of the storage";
  parameter SI.Temperature T_des_low = 510.0 + 273.15 "Ideal low temperature of the storage";
  parameter SI.TemperatureDifference T_tol_recv = 40.0 "Temperature tolerance above design receiver input temperature before receiver is shut off";
  parameter SI.TemperatureDifference T_tol_PB = 60.0 "Temperature tolerance below design PB input temperature before PB is shut off";
  //Controls, pumps , etc
  parameter SI.Temperature T_recv_max = T_des_low+T_tol_recv "Absolute maximum temperature at bottom of tank where receiver is shut off";


  parameter SI.Temperature T_low_u = T_des_high - 0.5*T_tol_PB "Temperature at which PB starts";
  parameter SI.Temperature T_low_l = T_des_high - T_tol_PB "Temperature at which PB stops";
  
  parameter SI.Temperature T_PCM_melt = Filler.T_melt "Melting temperature of PCM, not used";
  parameter SI.Temperature T_up_u = 710.0 + 273.15 "Temperature at which defocusing starts, not used";
  parameter SI.Temperature T_up_l = 700.0 + 273.15 "Temperature at which defocusing stops, not used";  
  //Trays
  parameter Real f_recv = 1.00 "Receiver area multiplier to be optimised";
  parameter Real f_PCM_safety = 1.05 "Safety factor such that PCM does not exceed wall height";
  parameter Real f_HTF_inventory = 1.10 "Multiplier to empty volume between PCM and wall level occupied to sodium at 1073K to calculate sodium mass inventory";
  parameter SI.Length z_PCM = 0.05 "Vertical depth of PCM in each tray, m";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.05 "Heat transfer coefficient of tank losses between sodium and ambient temps, W/m2K";
  //parameter Real SM_guess = 1.8 "Solar multiple";
  parameter Real t_storage(unit = "h") = 6.0 "Hours of storage";
  //Constants
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT "Medium props for molten salt";
  replaceable package Fluid = SolarTherm.Materials.Sodium "Material model for Sodium Chloride PCM";
  replaceable package Filler = SolarTherm.Materials.PigIron_Constant;
  replaceable package PCM = SolarTherm.Materials.NaCl;
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
  parameter String field_type = "surround";
  parameter String opt_file_prefix = "modelica://SolarTherm/Data/Optics/SodiumBoiler/surround/100MWe/5000c%/893K/1000kWpm2/";
  parameter String phi_pct_string = "124";
  parameter Real SM_guess = 1.8;
  parameter Real HT_pct_guess = 100;
  parameter String opt_file = opt_file_naming(opt_file_prefix, phi_pct_string, SM_guess, HT_pct_guess, f_recv);
  //where to find the optics file
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
  //declination-hourangle
  parameter String SM_string = String(2 * SolarTherm.Utilities.Round(SM_guess * 5)) "Solar Multiple rounded to the nearest 0.2, multiplied by 10 and converted to string";
  parameter Real land_mult = 5.0 "Land area multiplier";
  //is it polar or surround??
  parameter Real he_av_design = 0.99 "Helisotats availability";
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
  //parameter String opt_file_B = Modelica.Utilities.Files.loadResource(opt_file_list[2]);
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
  parameter Integer nodes = 15 "Number of discretization elements of PCM";
  parameter Real growth_ratio = 1.2 "Geometric growth ratio of initial mesh thickness, refined mesh at top and bottom surfaces";

  parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold pump parasitic power coefficient";
  parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot pump parasitic power coefficient";
  //Design values
  parameter SI.Irradiance dni_des = SolarTherm.Utilities.DNI_Models.Meinel(abs(lat)) "Design point DNI value";
  parameter Real SM = Q_flow_rec_des / Q_flow_ref_blk "Real solar multiple";
  //Enthalpies
  parameter SI.SpecificEnthalpy h_in_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_des_high)) "Specific enthalpy of sodium entering PB at design pt";
  parameter SI.SpecificEnthalpy h_out_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_des_low)) "Specific enthalpy of sodium leaving PB at design pt";
  parameter SI.SpecificEnthalpy h_in_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_des_low)) "Specific enthalpy of sodium entering receiver at design pt";
  parameter SI.SpecificEnthalpy h_out_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_des_high)) "Specific enthalpy of sodium leaving receiver at design pt";
  //Heat Flow Rates
  parameter SI.HeatFlowRate Q_flow_ref_blk = P_gross_des / eff_blk_des "design heat input rate into the PB";
  parameter SI.HeatFlowRate Q_flow_ref_blk_def = P_gross_des / eff_blk_def "design heat input rate to PB during defocus (higher efficiency)";
  parameter SI.HeatFlowRate Q_flow_rec_loss_def = CN.sigma * em_recv * A_recv * ((620 + 273.15) ^ 4 - 298.15 ^ 4) + h_conv_recv * A_recv * (T_up_u + T_superheat - 298.15) "Receiver defocus heat loss rate";
  parameter SI.HeatFlowRate Q_flow_tank_loss_def = 0.0;
  // A_loss_tank * U_loss_tank * (T_up_u - 298.15) "Tank defocus heat loss rate has no effect coz it is disconnected during defocus";
  parameter SI.HeatFlowRate Q_flow_rec_loss_des = CN.sigma * em_recv * A_recv * ((620 + 273.15) ^ 4 - 298.15 ^ 4) "Receiver design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_tank_loss_des = 0.0;
  // A_loss_tank * U_loss_tank * (700 + 273.15 - 298.15) "Tank design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_rec_des = dni_des * he_av_design * eff_opt_des * A_field * ab_recv - Q_flow_rec_loss_des "Receiver Thermal power output at design";
  parameter SI.HeatFlowRate Q_flow_defocus = (Q_flow_ref_blk_def + Q_flow_rec_loss_def + Q_flow_tank_loss_def) / ab_recv "Solar field thermal power at defocused state";
  //Mass flow rates
  parameter SI.MassFlowRate m_flow_blk_des = Q_flow_ref_blk / (h_in_ref_blk - h_out_ref_blk) "Design point mass flow rate of sodium vapor condensing into the power block";
  parameter SI.MassFlowRate m_flow_recv_des = Q_flow_rec_des / (h_out_ref_recv - h_in_ref_recv) "Design mass flow rate into recv";
  // Power block
  parameter String engine_brand = "SES" "Power block brand {SES,75%Carnot}";
  parameter SI.Power P_gross_des = 100e6 "Power block gross rating at design point";
  parameter SI.Power P_name_des = 100e6 "Power block nameplate rating";
  parameter SI.Power P_name = P_name_des;
  parameter SI.Temperature T_pb_cool_des = 323.0 "Design cooling temperature of PB";
  parameter SI.Efficiency eff_net_des = 1.0 "Power block net efficiency rating";
  parameter SI.Efficiency eff_blk_des = 0.51 "Power block efficiency at design point";
  parameter SI.Efficiency eff_blk_def = 0.51 "Power block efficiency at design point";
  //parameter SI.Efficiency eff_blk_des = if engine_brand == "SES" then 0.7893 * (1.0 - (T_pb_cool_des / T_PCM_melt) ^ 0.5) else 0.75 * (1.0 - T_pb_cool_des / T_PCM_melt) "Power block efficiency at design point";
  //parameter SI.Efficiency eff_blk_def = if engine_brand == "SES" then 0.7893 * (1.0 - (T_pb_cool_des / T_up_u) ^ 0.5) else 0.75 * (1.0 - T_pb_cool_des / T_up_u) "Power block efficiency at design point";
  parameter SI.Time PB_startup = 20.0 * 60.0 "Startup ramping time of striling engine is 20mins";
  // Cost data in USD (default) or AUD
  parameter Real r_disc = 0.07 "Real discount rate";
  parameter Real r_i = 0.03 "Inflation rate";
  parameter Integer t_life(unit = "year") = 27 "Lifetime of plant";
  parameter Integer t_cons(unit = "year") = 3 "Years of construction";
  parameter Real r_cur = 0.71 "The currency rate from AUD to USD";
  // Valid for 2019. See https://www.rba.gov.au/
  parameter Real f_Subs = 0 "Subsidies on initial investment costs";
  parameter FI.AreaPrice pri_field = if currency == Currency.USD then 75.00 else 75.00 / r_cur "Field cost per design aperture area";
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
  parameter FI.Money C_tower = 3117043.67 * exp(0.0113 * H_tower) "Tower cost";
  parameter FI.Money C_receiver = 72365.8 * A_recv "Receiver cost";
  // SAM 2018 cost data: 103e6 * (A_receiver / 1571) ^ 0.7
  parameter FI.Money C_storage = Tank.C_total;
  //tankHot.C_Storage "Storage cost";
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
    Placement(visible = true, transformation(extent = {{-140, -38}, {-110, -10}}, rotation = 0)));
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
    Placement(visible = true, transformation(origin = {121, 60}, extent = {{-13, -10}, {13, 10}}, rotation = 180)));
  // Or block for defocusing
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
  // Solar heliostat field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(n_h = n_heliostat, lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus, nu_start = nu_start, redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table_Full(angles = angles, file = opt_file)) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
  // Hot Pump (power block)
  // Cold pump (receiver)
  //Market
  SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
    Placement(visible = true, transformation(origin = {144, 20}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  //Receiver
  SolarTherm.Models.CSP.CRS.Receivers.ReceiverSimple_3 receiver(redeclare package Medium = Medium, H_rcv = H_recv, D_rcv = D_recv, N_pa = N_pa_recv, D_tb = D_tb_recv, t_tb = t_tb_recv, ab = ab_recv, em = em_recv, T_0 = T_des_low) annotation(
    Placement(visible = true, transformation(origin = {-28, 24}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  //Storage
  //Loop Breakers
  //Cold Controller (Receiver)
  SolarTherm.Models.Control.Thermocline_ReceiverControl controlCold(T_df_on = T_up_u, T_df_off = T_up_l, T_max = T_recv_max,T_target=T_des_high, Q_flow_recv_des = Q_flow_rec_des, m_flow_recv_des = m_flow_recv_des) annotation(
    Placement(visible = true, transformation(origin = {-32, -22}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  //Hot Controller (Power Block)
  SolarTherm.Models.Control.SB_PowerBlockControl controlHot(T_on = T_low_u, T_off = T_low_l, m_flow_ref = m_flow_blk_des) annotation(
    Placement(visible = true, transformation(origin = {66, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Power Block
  SolarTherm.Models.PowerBlocks.PowerBlockModel_sCO2NREL powerBlock(redeclare package Medium = Medium, nu_net = 1.0, W_base = 0.0055 * P_gross_des,m_flow_ref = m_flow_blk_des, T_in_ref = T_des_high, T_out_ref = T_des_low, Q_flow_ref=Q_flow_ref_blk, redeclare model Cooling = SolarTherm.Models.PowerBlocks.Cooling.NoCooling) annotation(
    Placement(visible = true, transformation(origin = {101, 21}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
  //Annual Simulation variables
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
  //Boolean constrained(start = false);
  //Real distance(start = 0);
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
  //Storage Uitlization
  //Real E_max_today(start=0.0) "Today's max energy stored";
  //Real E_min_today(start=0.0) "Today's min energy stored";
  //Real eta_util_ytd(start=0.0) "yesterday's total utilization pct of storage";
  //End Analytics
  SolarTherm.Models.Storage.Thermocline.Thermocline_Tank Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler, Correlation = 3, E_max = t_storage * 3600 * Q_flow_ref_blk, N_f = 30, T_max = T_des_high, T_min = T_des_low,d_p=0.148, ar = 4.0, eta = 0.24, U_loss_tank = 0.1) annotation(
    Placement(visible = true, transformation(origin = {26, 36}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.Thermocline_Splitter_2 Splitter_bot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {26, 14}, extent = {{-10, 0}, {10, 10}}, rotation = 180)));
  SolarTherm.Models.Fluid.Valves.Thermocline_Splitter Splitter_top(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {26, 60}, extent = {{-10, 0}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-2, 6}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {66, 68}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
algorithm
  /*when rem(time,86400) > 86399 then //reset the storage utilization
    if time > 432000 then //after 5 days
      //eta_util_ytd := (E_max_today - E_min_today)/E_max;
      E_max_today := Tank.Tank_A.E_stored;
      E_min_today := Tank.Tank_A.E_stored;
    end if;
  end when;
  when rem(time,600) > 599 then //update the Max and Min energy stored for the day if appropriate;
  if time > 432000 then //after 5 days
    if Tank.Tank_A.E_stored > E_max_today then
      E_max_today := Tank.Tank_A.E_stored;
    end if;
    if Tank.Tank_A.E_stored < E_min_today then
      E_min_today := Tank.Tank_A.E_stored;
    end if;
  end if;
  end when;
  */
/*if time > 60.0 then
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
  end if;*/
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
  connect(controlCold.defocus, heliostatsField.defocus) annotation(
    Line(points = {{-44, -28}, {-44, -36}, {-94, -36}, {-94, 8}, {-88, 8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(receiver.Q_recv_in, controlCold.Q_recv_in) annotation(
    Line(points = {{-24, 24}, {-18, 24}, {-18, -15}, {-21, -15}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{107, 60}, {107, 38}}, color = {0, 0, 127}));
  connect(powerBlock.T_amb, Tamb_input.y) annotation(
    Line(points = {{95, 38}, {95, 80}, {120, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{116, 20}, {132, 20}}, color = {0, 0, 127}));
  connect(Tamb_input.y, receiver.Tamb) annotation(
    Line(points = {{120, 80}, {-28, 80}, {-28, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
//connect(Wspd_input.y, receiver.Wspd) annotation(
//  Line(points = {{-113, 48}, {-32, 48}, {-32, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(receiver.net_gain, controlCold.net_gain) annotation(
    Line(points = {{-24, 18}, {-16, 18}, {-16, -23}, {-21, -23}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(Tamb_input.y, Tank.T_amb) annotation(
    Line(points = {{120, 80}, {16, 80}, {16, 36}, {19, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tank.p_amb, Pres_input.y) annotation(
    Line(points = {{33, 36}, {72, 36}, {72, 96}, {118, 96}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tank.T_top_measured, controlHot.T_stor) annotation(
    Line(points = {{33, 45}, {46, 45}, {46, -18}, {56, -18}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Splitter_bot.fluid_b, pumpCold.fluid_a) annotation(
    Line(points = {{18, 6}, {2, 6}, {2, 6}, {2, 6}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
    Line(points = {{-6, 6}, {-14, 6}, {-14, 10}, {-24, 10}, {-24, 10}}, color = {0, 127, 255}));
  connect(receiver.fluid_b, Splitter_top.fluid_a) annotation(
    Line(points = {{-22, 32}, {-18, 32}, {-18, 68}, {18, 68}, {18, 68}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{70, 68}, {82, 68}, {82, 30}, {88, 30}}, color = {0, 127, 255}));
  connect(powerBlock.fluid_b, Splitter_bot.fluid_a) annotation(
    Line(points = {{84, 8}, {58, 8}, {58, 6}, {34, 6}, {34, 6}}, color = {0, 127, 255}));
  connect(Tank.fluid_b, Splitter_bot.fluid_c) annotation(
    Line(points = {{26, 23}, {26, 14}}, color = {0, 127, 255}));
  connect(controlCold.m_flow_recv, pumpCold.m_flow) annotation(
    Line(points = {{-43, -16}, {-48, -16}, {-48, -2}, {-8, -2}, {-8, 14}, {-2, 14}, {-2, 10}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(controlHot.m_flow_PB, pumpHot.m_flow) annotation(
    Line(points = {{78, -18}, {80, -18}, {80, 76}, {66, 76}, {66, 71}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Splitter_top.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{34, 68}, {62, 68}, {62, 68}, {62, 68}}, color = {0, 127, 255}));
  connect(Splitter_top.fluid_c, Tank.fluid_a) annotation(
    Line(points = {{26, 60}, {26, 49}}, color = {0, 127, 255}));
  connect(receiver.Q_loss, controlCold.Q_loss) annotation(
    Line(points = {{-24, 22}, {-14, 22}, {-14, -18}, {-21, -18}}, color = {0, 0, 127}));
  connect(Tank.T_bot_measured, controlCold.T_stor) annotation(
    Line(points = {{34, 28}, {38, 28}, {38, -24}, {-21, -24}, {-21, -25}}, color = {0, 0, 127}));
  connect(controlCold.h_PB_outlet, powerBlock.h_out_signal) annotation(
    Line(points = {{-21, -28}, {44, -28}, {44, 4}, {84, 4}}, color = {0, 0, 127}));
  connect(controlHot.m_flow_PB, controlCold.m_PB_outlet) annotation(
    Line(points = {{78, -18}, {82, -18}, {82, -38}, {-16, -38}, {-16, -30}, {-21, -30}}, color = {0, 0, 127}));
  connect(Tank.h_bot_outlet, controlCold.h_tank_outlet) annotation(
    Line(points = {{22, 26}, {12, 26}, {12, -20}, {-20, -20}, {-20, -28}, {-22, -28}}, color = {0, 0, 127}));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(origin = {0, 6}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-16, 6}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-2, -10}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, -2}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-4, -6}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif"), Text(origin = {-56, -84}, extent = {{0, 58}, {48, 38}}, textString = "Receiver Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {42, -84}, extent = {{0, 58}, {48, 38}}, textString = "PB Control", fontSize = 6, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.001, Interval = 300, maxStepSize = 60, initialStepSize = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li>Zebedee Kee (June 2020) :<br>Released first version. </li>
	</ul>

	</html>"));

end Thermocline_Reference;