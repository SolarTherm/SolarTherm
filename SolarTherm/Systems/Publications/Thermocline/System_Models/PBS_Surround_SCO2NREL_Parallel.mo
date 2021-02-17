within SolarTherm.Systems.Publications.Thermocline.System_Models;

model PBS_Surround_SCO2NREL_Parallel
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
  parameter SI.Temperature T_max = 740.0 + 273.15 "Ideal high temperature of the storage";
  parameter SI.Temperature T_min = 510.0 + 273.15 "Ideal low temperature of the storage";
  parameter SI.TemperatureDifference T_tol_recv = 60.0 "Temperature tolerance above design receiver input temperature before receiver is shut off";
  parameter SI.TemperatureDifference T_tol_PB = 60.0 "Temperature tolerance below design PB input temperature before PB is shut off";
  //Controls, pumps , etc
  parameter SI.Temperature T_recv_max = T_min + T_tol_recv "Maximum temperature at bottom of tank when it can no longer be pumped into the receiver";
  parameter SI.Temperature T_recv_start = T_min + 0.5 * T_tol_recv "Temperature at bottom of tank when it can start being pumped into the receiver again";
  parameter SI.Temperature T_PB_start = T_max - 0.5 * T_tol_PB "Temperature at top of tank where PB can start";
  parameter SI.Temperature T_PB_min = T_max - T_tol_PB "Temperature at top of tank where PB must stop";
  parameter Real t_storage(unit = "h") = 12.0 "Hours of storage";
  //Constants
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT "Medium props for molten salt";
  replaceable package Fluid = SolarTherm.Materials.Sodium "Material model for Sodium Chloride PCM";
  //Filler Properties
  replaceable package Filler_A = SolarTherm.Materials.CaO_Constant "Bottom tank filler";
  replaceable package Filler_B = SolarTherm.Materials.CaO_Constant "Middle tank filler";
  replaceable package Filler_C = SolarTherm.Materials.CaO_Constant "Top tank filler";
  parameter SI.Length d_p_A = 0.20 "Bottom tank filler diameter";
  parameter SI.Length d_p_B = 0.20 "Middle tank filler diameter";
  parameter SI.Length d_p_C = 0.20 "Top tank filler diameter";
  parameter Real eta = 0.26 "Packed bed porosity factor of all tanks";
  parameter Real ar = 2.0 "Aspect ratio (H/D) of all tanks";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.10 "Heat loss coefficient of all tanks";
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
  parameter Real SM_guess = 2.2;
  parameter Real HT_pct_guess = 100;
  parameter Real f_recv = 1.0;
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
  parameter Real nu_start = 0.4 "Minimum energy start-up fraction to start the receiver";
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
  // Storage
  //also used for Nusselt number correlation
  parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold pump parasitic power coefficient";
  parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot pump parasitic power coefficient";
  //Design values
  parameter SI.Irradiance dni_des = SolarTherm.Utilities.DNI_Models.Meinel(abs(lat)) "Design point DNI value";
  parameter Real SM = Q_flow_rec_des / Q_flow_ref_blk "Real solar multiple";
  //Enthalpies
  parameter SI.SpecificEnthalpy h_in_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_max)) "Specific enthalpy of sodium entering PB at design pt";
  parameter SI.SpecificEnthalpy h_out_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_min)) "Specific enthalpy of sodium leaving PB at design pt";
  parameter SI.SpecificEnthalpy h_in_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_min)) "Specific enthalpy of sodium entering receiver at design pt";
  parameter SI.SpecificEnthalpy h_out_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_max)) "Specific enthalpy of sodium leaving receiver at design pt";
  //Heat Flow Rates
  parameter SI.HeatFlowRate Q_flow_ref_blk = P_gross_des / eff_blk_des "design heat input rate into the PB";
  parameter SI.HeatFlowRate Q_flow_rec_loss_des = CN.sigma * em_recv * A_recv * ((0.5 * T_max + 0.5 * T_min + 273.15) ^ 4 - 298.15 ^ 4) "Receiver design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_rec_des = dni_des * he_av_design * eff_opt_des * A_field * ab_recv - Q_flow_rec_loss_des "Receiver Thermal power output at design";
  parameter SI.HeatFlowRate Q_flow_defocus = (Q_flow_ref_blk + Q_flow_rec_loss_des) / ab_recv "Solar field thermal power at defocused state";
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
  parameter Integer t_life = 27 "Lifetime of plant";
  parameter Integer t_cons = 3 "Years of construction";
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
    Placement(visible = true, transformation(extent = {{-108, 82}, {-78, 110}}, rotation = 0)));
  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(extent = {{-102, 60}, {-82, 80}}, rotation = 0)));
  //Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(transformation(extent = {{140, 70}, {120, 90}})));
  //WindSpeed_input
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(visible = true, transformation(extent = {{-98, 38}, {-72, 58}}, rotation = 0)));
  //pressure_input
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(visible = true, transformation(extent = {{138, 86}, {118, 106}}, rotation = 0)));
  //parasitic inputs
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold.W_loss) annotation(
    Placement(visible = true, transformation(extent = {{-30, 94}, {0, 122}}, rotation = 0)));
  // Or block for defocusing
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(visible = true, transformation(extent = {{-74, 60}, {-54, 80}}, rotation = 0)));
  // Solar heliostat field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table_Full(angles = angles, file = opt_file), A_h = A_heliostat, Q_design = Q_flow_defocus, Wspd_max = Wspd_max, ele_min(displayUnit = "deg") = ele_min, he_av = he_av_design, lat = data.lat, lon = data.lon, n_h = n_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, nu_start = nu_start, use_defocus = false, use_on = true, use_wind = true) annotation(
    Placement(visible = true, transformation(origin = {-52, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Hot Pump (power block)
  // Cold pump (receiver)
  //Market
  SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
    Placement(visible = true, transformation(extent = {{116, 12}, {142, 32}}, rotation = 0)));
  //Receiver
  SolarTherm.Models.CSP.CRS.Receivers.PBS_Receiver receiver(redeclare package Medium = Medium, H_rcv = H_recv, D_rcv = D_recv, N_pa = N_pa_recv, D_tb = D_tb_recv, t_tb = t_tb_recv, ab = ab_recv, em = em_recv, T_0 = T_min, Q_des_blk = Q_flow_ref_blk, T_max = T_max) annotation(
    Placement(visible = true, transformation(origin = {-16, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Storage
  //Loop Breakers
  //Cold Controller (Receiver)
  //Hot Controller (Power Block)
  //Power Block
  SolarTherm.Models.PowerBlocks.PBS_PowerBlockModel_sCO2NREL_100MWe_700C_510C powerBlock(redeclare package Medium = Medium, nu_net = 1.0, W_base = 0.0055 * P_gross_des, m_flow_ref = m_flow_blk_des, T_in_ref = T_max, T_out_ref = T_min, Q_flow_ref = Q_flow_ref_blk, redeclare model Cooling = SolarTherm.Models.PowerBlocks.Cooling.NoCooling) annotation(
    Placement(visible = true, transformation(origin = {95, 16}, extent = {{17, -16}, {-17, 16}}, rotation = 180)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction_LoopBreaker Splitter_bot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {32, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction Splitter_top(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {33, 86.5827}, extent = {{-11, 0}, {11, 13.418}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {12, 10}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {58, 98}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  SolarTherm.Models.Control.PBS_Controller Control(redeclare package HTF = Medium, T_recv_max = T_recv_max, T_PB_min = T_PB_min, T_target = T_max, m_flow_PB_des = m_flow_blk_des, Q_des_blk = Q_flow_ref_blk, T_recv_start = T_recv_start, T_PB_start = T_PB_start) annotation(
    Placement(visible = true, transformation(origin = {61, -2.41667}, extent = {{7, -6.41667}, {-7, 6.41667}}, rotation = 0)));
  //Annual Simulation variables
  Modelica.SIunits.Power P_elec "Output power of power block" annotation(
    Placement(visible = true, transformation(origin = {134, 62}, extent = {{-10, 0}, {10, 12.971}}, rotation = 180)));
  Modelica.SIunits.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity" annotation(
    Placement(visible = true, transformation(origin = {126, -62}, extent = {{-10, 0}, {10, 13.7601}}, rotation = 0)));
  SolarTherm.Models.Analysis.Finances.Money R_spot(start = 0, fixed = true) "Spot market revenue" annotation(
    Placement(visible = true, transformation(origin = {134, 40}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  //Boolean constrained(start = false);
  //Real distance(start = 0);
  /*
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
                                  */
  //Storage Uitlization
  //Real E_max_today(start=0.0) "Today's max energy stored";
  //Real E_min_today(start=0.0) "Today's min energy stored";
  //Real eta_util_ytd(start=0.0) "yesterday's total utilization pct of storage";
  //End Analytics
  /*SolarTherm.Models.Storage.Thermocline.Cascaded.Thermocline_Group_3 Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package_A = Filler_A, redeclare package Filler_Package_B = Filler_B, redeclare package Filler_Package_C = Filler_C, Correlation = 3, E_max = t_storage * 3600 * Q_flow_ref_blk, N_f_A = 10, N_f_B = 30, N_f_C = 10, N_p_A = 5, N_p_B = 5, N_p_C = 5, T_max = T_max, T_min = T_min, U_loss_tank = U_loss_tank, ar = ar, d_p = d_p_A, eta = eta, frac_1 = 0.1, frac_2 = 0.1) annotation(
                                  Placement(visible = true, transformation(origin = {26, 36}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
                                */
  /* 
              SolarTherm.Models.Storage.Thermocline.Parallel.Thermocline_Spheres_Parallel_A2_Final Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package_A = Filler_B, redeclare package Filler_Package_B = Filler_B, Correlation = 3, E_max = t_storage * 3600 * Q_flow_ref_blk, N_f_A = 20, N_p_A = 5, N_f_B = 20, N_p_B = 5, T_max = T_max, T_min = T_min, U_loss_tank_A = U_loss_tank, ar_A = ar, d_p_A = d_p_A, eta_A = eta, frac_1 = 0.5, T_bot_high = T_recv_max - 5, T_top_low = T_PB_min + 5) annotation(
                Placement(visible = true, transformation(origin = {26, 36}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
              */
  /*
                      SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_SingleTank Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler_B, Correlation = 3, E_max = t_storage * 3600 * Q_flow_ref_blk, N_f = 20, N_p = 5, T_max = T_max, T_min = T_min, U_loss_tank = U_loss_tank, ar = ar, d_p = d_p_A, eta = eta) annotation(
                        Placement(visible = true, transformation(origin = {26, 36}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
                      */
  /*
                      SolarTherm.Models.Storage.Thermocline.Thermocline_HCylinders_SingleTank Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler_B, Correlation = 8, E_max = t_storage * 3600 * Q_flow_ref_blk, N_f = 20, N_p = 5, T_max = T_max, T_min = T_min, U_loss_tank = U_loss_tank, ar = ar, d_p = d_p_A, eta = eta) annotation(
                        Placement(visible = true, transformation(origin = {26, 36}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
                      */
  SolarTherm.Models.Storage.Thermocline.Parallel.Thermocline_Spheres_Parallel_A3_Final Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package_A = Filler_B, redeclare package Filler_Package_B = Filler_B, redeclare package Filler_Package_C = Filler_B, Correlation = 3, E_max = t_storage * 3600 * Q_flow_ref_blk, N_f_A = 20, N_p_A = 5, N_f_B = 20, N_p_B = 5, T_max = T_max, T_min = T_min, U_loss_tank_A = U_loss_tank, ar_A = ar, d_p_A = d_p_A, eta_A = eta, frac_1 = 1.0 / 3.0, T_bot_high = T_recv_max - 1.0, T_top_low = T_PB_min + 1.0) annotation(
    Placement(visible = true, transformation(origin = {34, 58}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  /*
                      SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_SingleTank_Compact Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler_B, Correlation = 3, E_max = t_storage * 3600 * Q_flow_ref_blk, N_f = 100, N_p = 10, T_max = T_max, T_min = T_min, U_loss_tank = U_loss_tank, ar = ar, d_p = d_p_A, eta = eta) annotation(
                        Placement(visible = true, transformation(origin = {26, 36}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
                      */
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
  end if;
*/
/*
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
*/
//Optics
equation
/*
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
  */
//Connections from data
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-81, 70}, {-75, 70}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
// Fluid connections
// controlCold connections
// controlHot connections
//Solar field connections i.e. solar.heat port and control
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-64, 60}, {-64, 50}, {-52, 50}, {-52, 40}}, color = {255, 128, 0}));
//PowerBlock connections
  P_elec = powerBlock.W_net;
  E_elec = powerBlock.E_net;
  R_spot = market.profit;
  connect(heliostatsField.heat, receiver.heat) annotation(
    Line(points = {{-42, 35}, {-26, 35}}, color = {191, 0, 0}));
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{1.5, 108}, {1.5, 65}, {98, 65}, {98, 6}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(powerBlock.T_amb, Tamb_input.y) annotation(
    Line(points = {{92, 6}, {111.5, 6}, {111.5, 80}, {120, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{104, 17}, {121.5, 17}, {121.5, 22}, {116, 22}}, color = {0, 0, 127}));
  connect(Tamb_input.y, receiver.Tamb) annotation(
    Line(points = {{120, 80}, {120, 40}, {-16, 40}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
//connect(Wspd_input.y, receiver.Wspd) annotation(
//  Line(points = {{-113, 48}, {-32, 48}, {-32, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tamb_input.y, Tank.T_amb) annotation(
    Line(points = {{120, 80}, {16, 80}, {16, 58}, {25, 58}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tank.p_amb, Pres_input.y) annotation(
    Line(points = {{43, 58}, {72, 58}, {72, 96}, {118, 96}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
    Line(points = {{8, 10}, {8, 10.5}, {-14, 10.5}, {-14, 23}}, color = {0, 127, 255}));
  connect(receiver.fluid_b, Splitter_top.fluid_a) annotation(
    Line(points = {{-13, 37}, {-18, 37}, {-18, 99}, {24, 99}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{62, 98}, {80.5, 98}, {80.5, 11}, {88, 11}}, color = {0, 127, 255}));
  connect(Splitter_top.fluid_c, Tank.fluid_a) annotation(
    Line(points = {{33, 88}, {33, 74}, {34, 74}}, color = {0, 127, 255}));
  connect(Control.m_flow_recv, pumpCold.m_flow) annotation(
    Line(points = {{53, 1}, {-6.5, 1}, {-6.5, 13}, {12, 13}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Control.defocus, receiver.defocus) annotation(
    Line(points = {{53, -5}, {-38, -5}, {-38, 30}, {-19, 30}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(Tank.h_bot_outlet, Control.h_tank_outlet) annotation(
    Line(points = {{29, 45}, {29, 27}, {64, 27}, {64, 5}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(powerBlock.h_out_signal, Control.h_PB_outlet) annotation(
    Line(points = {{85, 25}, {85, 9}, {57, 9}, {57, 5}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Splitter_top.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{42, 99}, {48, 99}, {48, 98}, {54, 98}}, color = {0, 127, 255}));
  connect(receiver.Q_rcv_raw, Control.Q_rcv_raw) annotation(
    Line(points = {{-13.5, 29.5}, {4, 29.5}, {4, 2}, {68, 2}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Control.m_flow_PB, pumpHot.m_flow) annotation(
    Line(points = {{53, -2}, {53, 48.5}, {58, 48.5}, {58, 101}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Splitter_bot.fluid_b, pumpCold.fluid_a) annotation(
    Line(points = {{24, 10}, {16, 10}}, color = {0, 127, 255}));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-71, 48}, {-24.5, 48}, {-24.5, 36}, {-62, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Control.Q_defocus, receiver.Q_defocus) annotation(
    Line(points = {{69, -8}, {48.5, -8}, {48.5, 21}, {9.25, 21}, {9.25, 27}, {-14, 27}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tank.fluid_b, Splitter_bot.fluid_c) annotation(
    Line(points = {{34, 42}, {25, 42}, {25, 18}, {32, 18}}, color = {0, 127, 255}));
  connect(powerBlock.fluid_b, Splitter_bot.fluid_a) annotation(
    Line(points = {{85, 23}, {57.5, 23}, {57.5, 10}, {40, 10}}, color = {0, 127, 255}));
  connect(Tank.T_top_measured, Control.T_top_tank) annotation(
    Line(points = {{43, 69}, {68, 69}, {68, -2}}, color = {0, 0, 127}));
  connect(Tank.T_bot_measured, Control.T_bot_tank) annotation(
    Line(points = {{43, 47}, {68, 47}, {68, -5}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1, preserveAspectRatio = false), graphics = {Text(origin = {14, 20}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {32, 22}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-6, 8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, 2}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"), Text(origin = {10, 6}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"), Text(origin = {28, 146}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif"), Text(origin = {44, -62}, extent = {{0, 58}, {48, 38}}, textString = "Receiver Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {42, -66}, extent = {{0, 58}, {48, 38}}, textString = "PB Control", fontSize = 6, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-200, -100}, {100, 100}}, initialScale = 0.1, preserveAspectRatio = false)),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.001, Interval = 300, maxStepSize = 60, initialStepSize = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li>Zebedee Kee (June 2020) :<br>Released first version. </li>
	</ul>

	</html>"));
end PBS_Surround_SCO2NREL_Parallel;