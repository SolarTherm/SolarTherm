within SolarTherm.Systems.Thesis;

model PBS_Surround_SCO2NREL_MixedOutlet
  //This is a Gen3 inspired annual system model with two towers for and equivalent of 100 MWe, this variation has three tanks and a mixed-outlet storage algorithm.
  //Packed-bed storage, three-tank mixed-outlet blending strategy, surround field with external-cylindrical receiver, SCO2 power block
  //Do not run this unless you have 4 weeks to spare!

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
    opt_file := Modelica.Utilities.Files.loadResource(prefix + SM_string + "dSM/isp_optimised/" + phi_pct_string + "%phi_" + HT_pct_string + "%HT_" + f_recv_string + "%Arecv_optics.motab");
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
  //Tolerance of PB and receiver inlet
  parameter SI.TemperatureDifference T_tol_recv = 40.0 "Temperature tolerance above design receiver input temperature before receiver is shut off";
  parameter SI.TemperatureDifference T_tol_PB = 20.0 "Temperature tolerance below design PB input temperature before PB is shut off";
  //Temperature controls
  parameter SI.Temperature T_max = 720.0 + 273.15 "Ideal high temperature of the storage";
  parameter SI.Temperature T_PB_start = T_max - T_tol_PB + 10.0 "Temperature at top of tank where PB can start";
  parameter SI.Temperature T_PB_min = T_max - T_tol_PB "Temperature at top of tank where PB must stop";
  parameter SI.Temperature T_recv_max = T_min + T_tol_recv "Maximum temperature at bottom of tank when it can no longer be pumped into the receiver";
  parameter SI.Temperature T_recv_start = T_min + T_tol_recv - 10.0 "Temperature at bottom of tank when it can start being pumped into the receiver again";
  parameter SI.Temperature T_min = 500.0 + 273.15 "Ideal low temperature of the storage";
  //Additional Power Block design temperature
  parameter SI.Temperature T_PB_in_des = 700.0 + 273.15 "Power Block design inlet temperature";
  parameter SI.Temperature T_PB_out_des = 500.0 + 273.15 "Power Block design outlet temperature";
  //Controller Parameters
  parameter Real eff_storage_des = 0.85 "design storage utilisation";
  parameter SI.Time t_stor_startPB = 1.0 * 3600.0 "minimum hours of storage available to startup PB";
  //Material and Media Packages
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT "Medium props for molten salt";
  replaceable package Fluid = SolarTherm.Materials.Sodium_Table "Material model for Sodium Chloride PCM";
  replaceable package Filler = SolarTherm.Materials.MgO_Constant "Tank filler";
  //Storage Design
  parameter SI.Energy E_max = Q_flow_ref_blk * t_storage * 3600.0 "Theoretical max capacity of storage";
  parameter Integer N_f = 252 "Number of discretizations in vertical fluid phase for each tank";
  parameter Integer N_p = 10 "Number of discretizations in radial filler phase";
  parameter SI.Length d_p = 0.10 "Tank filler diameter";
  parameter Real eta = 0.26 "Packed bed void fraction (porosity)";
  parameter Real ar = 0.5 "Aspect ratio (H/D) of tank";
  //default equivalent value
  parameter Real t_storage(unit = "h") = 12.0 "Hours of storage";
  //combined capacity
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.10 "Heat loss coefficient of all tanks";
  //Multitank Parameters
  parameter Real frac_1 = 1.0 / 3.0 "Fraction of energy of total capacity in Tank A";
  parameter Real frac_2 = 1.0 / 3.0 "Fraction of energy of total capacity in Tank B";
  parameter Real frac_3 = 1.0 - frac_1 - frac_2 "Fraction of energy of total capacity in Tank C";
  parameter Real ar_A = 0.5 "Tank aspect ratio";
  //Note the 2.0 in the formula is the default aspect ratio of a single tank.
  parameter Real ar_B = ar_A "Tank aspect ratio";
  parameter Real ar_C = ar_A "Tank aspect ratio";
  //Multitank Blended Temperature Settings
  parameter SI.Temperature T_PB_set = 700.0 + 273.15 "Mixed Flow Algorithm will attempt to flatten discharge output to this value";
  parameter SI.Temperature T_Recv_set = 540.0 + 273.15 "Mixed Flow Algorithm will attempt to flatten charge output to this value";
  //Weather Data (Alice Springs)
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";
  parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  //Optical Model Parameters
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
  parameter String field_type = "surround";
  parameter String opt_file_prefix = "modelica://SolarTherm/Data/Optics/surround/50MWe/4555c%/883K/1000kWpm2/";
  parameter String phi_pct_string = "100";
  parameter Real SM_guess = 3.0;
  parameter Real HT_pct_guess = 100;
  parameter Real f_recv = 1.0;
  parameter String opt_file = opt_file_naming(opt_file_prefix, phi_pct_string, SM_guess, HT_pct_guess, f_recv);
  parameter String SM_string = String(2 * SolarTherm.Utilities.Round(SM_guess * 5)) "Solar Multiple rounded to the nearest 0.2, multiplied by 10 and converted to string";
  parameter Real he_av_design = 1.00 "Helisotats availability";
  parameter SI.Energy helio_E_start = 90e3 * A_heliostat / 144.375 "Heliostat startup energy consumption";
  parameter SI.Power helio_W_track = 0.0553 * A_heliostat / 144.375 "Heliostat tracking power";
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
  parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
  parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
  parameter Real nu_start = 0.4 "Minimum energy start-up fraction to start the receiver";
  parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
  parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
  parameter Real[8] MetaA = SolarTherm.Utilities.Metadata_Optics(opt_file);
  parameter Integer n_heliostat = SolarTherm.Utilities.Round(MetaA[1]) * 2 "Number of heliostats";
  //Two-tower system
  parameter SI.Area A_heliostat = MetaA[2] "Area of one heliostat";
  parameter Real eff_opt_des = MetaA[3];
  parameter SI.Length H_recv = MetaA[4];
  parameter SI.Length D_recv = MetaA[5];
  parameter SI.Length H_tower = MetaA[6] "Height of the tower";
  parameter SI.Area A_field = A_heliostat * n_heliostat "Area of the entire field (reflective area)";
  parameter SI.Area A_land = land_mult * A_field "Land area occupied by the plant";
  //Receiver Parameters
  parameter SI.Area A_recv = if field_type == "polar" then 2.0 * H_recv * D_recv else 2.0 * H_recv * D_recv * CN.pi "Total Receiver area";
  //Two-tower system
  //parameter Integer N_pa_recv = 20 "Number of panels in receiver";
  //parameter SI.Thickness t_tb_recv = 1.25e-3 "Receiver tube wall thickness";
  //parameter SI.Diameter D_tb_recv = 40e-3 "Receiver tube outer diameter";
  parameter SI.Efficiency ab_recv = 0.9872 "Receiver coating absorptance";
  parameter SI.Efficiency em_recv = 0.9408 "Receiver coating emissivity";
  parameter SI.CoefficientOfHeatTransfer h_conv_recv = 20.0 "W/m2K";
  parameter SI.Temperature T_4avg_recv = (0.20 * (T_min ^ 4 + T_min ^ 3 * T_max + T_min ^ 2 * T_max ^ 2 + T_min * T_max ^ 3 + T_max ^ 4)) ^ 0.25;
  parameter SI.Temperature T_avg_recv = 0.50 * (T_min + T_max);
  parameter SI.Temperature T_amb_recv_des = 25.0 + 273.15 "Design ambient temperature (K)";
  // Power block
  parameter SI.Power P_gross_des = P_name / eff_net_des "Power block gross rating at design point";
  parameter SI.Power P_name = 100e6;
  parameter SI.Temperature T_pb_cool_des = 35.0 + 273.15 "Design cooling temperature ambient of PB, is 6 degrees below 41 degC";
  parameter SI.Efficiency eff_net_des = 0.90 "Power block net efficiency rating";
  parameter SI.Efficiency eff_blk_des = 0.4555 "Power block efficiency at design point";
  parameter SI.Time t_PB_wait = 1.0 * 3600.0 "Wait time between shutdown and turning back on";
  //Pumping and Parasitics
  parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold pump parasitic power coefficient";
  parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot pump parasitic power coefficient";
  //Design Calculations
  parameter SI.Irradiance dni_des = SolarTherm.Utilities.DNI_Models.Meinel(abs(lat)) "Design point DNI value based on meinel calculation";
  parameter Real SM = Q_flow_rec_des / Q_flow_ref_blk "Real solar multiple";
  //Enthalpies
  parameter SI.SpecificEnthalpy h_in_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_PB_in_des)) "Specific enthalpy of sodium entering PB at design pt";
  parameter SI.SpecificEnthalpy h_out_ref_blk = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_PB_out_des)) "Specific enthalpy of sodium leaving PB at design pt";
  parameter SI.SpecificEnthalpy h_in_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_min)) "Specific enthalpy of sodium entering receiver at design pt";
  parameter SI.SpecificEnthalpy h_out_ref_recv = Medium.specificEnthalpy(Medium.setState_pTX(101323.0, T_max)) "Specific enthalpy of sodium leaving receiver at design pt";
  //Heat Flow Rates
  parameter SI.HeatFlowRate Q_flow_ref_blk = P_gross_des / eff_blk_des "design heat input rate into the PB";
  parameter SI.HeatFlowRate Q_flow_rec_loss_des = CN.sigma * em_recv * A_recv * (T_4avg_recv ^ 4 - T_amb_recv_des ^ 4) + h_conv_recv * A_recv * (T_avg_recv - T_amb_recv_des) "Receiver design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_rec_des = dni_des * he_av_design * eff_opt_des * A_field * ab_recv - Q_flow_rec_loss_des "Receiver Thermal power output at design";
  parameter SI.HeatFlowRate Q_flow_defocus = (Q_flow_ref_blk + Q_flow_rec_loss_des) / ab_recv "Solar field thermal power at defocused state (not used)";
  //Mass flow rates
  parameter SI.MassFlowRate m_flow_blk_des = Q_flow_ref_blk / (h_in_ref_blk - h_out_ref_blk) "Design point mass flow rate of sodium vapor condensing into the power block";
  parameter SI.MassFlowRate m_flow_recv_des = Q_flow_rec_des / (h_out_ref_recv - h_in_ref_recv) "Design mass flow rate into recv";
  //Cost & Financial Parameters
  parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  parameter Real land_mult = 5.0 "Land area multiplier";
  // Cost data in USD (default) or AUD
  parameter Real r_disc = 0.044 "Real discount rate";
  parameter Real r_i = 0.00 "Inflation rate";
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
  //parameter FI.PowerPrice pri_block = if currency == Currency.USD then 1040.00 / 1e3 else 1040.00 / 1e3 / r_cur "Power block cost per gross rated power";
  parameter FI.PowerPrice pri_block = powerBlock.C_PB_total / P_gross_des;
  // SAM 2018 cost data: 1040
  parameter FI.PowerPrice pri_bop = if currency == Currency.USD then 0.29 else 0.29 "Balance of plant cost per gross rated power";
  //not used
  //SAM 2018 cost data: 290
  parameter FI.AreaPrice pri_land = if currency == Currency.USD then 2.471 else 2.471 "Land cost per area";
  parameter Real pri_om_name(unit = "$/W/year") = if currency == Currency.USD then 40.0 / 1e3 else 40.0 / 1e3 / r_cur "Fixed O&M cost per nameplate per year";
  //SAM 2018 cost data: 66
  parameter Real pri_om_prod(unit = "$/J/year") = if currency == Currency.USD then 3.0 / (1e6 * 3600) else 3.0 / (1e6 * 3600) / r_cur "Variable O&M cost per production per year";
  //SAM 2018 cost data: 3.5
  parameter FI.Money C_field = pri_field * A_field "Field cost";
  parameter FI.Money C_site = pri_site * A_field "Site improvements cost";
  parameter FI.Money C_tower = 3000000.0 * exp(0.0113 * H_tower) * 2.0 "Tower cost";
  //two-tower system
  parameter FI.Money C_receiver = (4780420.0 + 21480230.0 * (D_recv / 14.0) * (H_recv / 14.5) ^ 0.6) * 2.0 "Receiver cost";
  //two-tower system
  // SAM 2018 cost data: 103e6 * (A_receiver / 1571) ^ 0.7
  parameter FI.Money C_storage = Tank.C_total;
  //tankHot.C_Storage "Storage cost";
  //parameter FI.Money C_block = pri_block * P_gross_des "Power block cost";
  parameter FI.Money C_block = powerBlock.C_PB_total "Power block cost";
  parameter FI.Money C_bop = 16216995.0 * (P_name / 100e6) + 11919765.0 * (2.0 * H_tower / 300.0) "Balance of plant cost";
  parameter FI.Money C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop) "Direct capital cost subtotal";
  // i.e. purchased equipment costs
  parameter FI.Money C_contingency = 0.10 * C_cap_dir_sub "Contingency costs";
  parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
  parameter FI.Money C_EPC = 0.09 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
  // SAM 2018 cost data: 0.13
  parameter FI.Money C_land = pri_land * A_land "Land cost";
  parameter FI.Money C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
  parameter FI.MoneyPerYear C_year = pri_om_name * P_name "Fixed O&M cost per year";
  parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Variable O&M cost per production per year";
  // System components
  // *********************
  //Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(origin = {-92, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(extent = {{-104, 60}, {-84, 80}}, rotation = 0)));
  //Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(extent = {{150, 76}, {130, 96}}, rotation = 0)));
  //WindSpeed_input
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(visible = true, transformation(extent = {{-104, 40}, {-78, 60}}, rotation = 0)));
  //pressure_input
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(visible = true, transformation(extent = {{150, 94}, {130, 114}}, rotation = 0)));
  //parasitic inputs
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold.W_loss + Tank.W_loss_pump) annotation(
    Placement(visible = true, transformation(origin = {136, 71}, extent = {{-14, -9}, {14, 9}}, rotation = 180)));
  // Or block for defocusing
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(visible = true, transformation(extent = {{-64, 60}, {-44, 80}}, rotation = 0)));
  // Solar heliostat field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table_Full(angles = angles, file = opt_file), A_h = A_heliostat, Q_design = Q_flow_defocus, Wspd_max = Wspd_max, ele_min(displayUnit = "deg") = ele_min, he_av = he_av_design, lat = data.lat, lon = data.lon, n_h = n_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, nu_start = nu_start, use_defocus = false, use_on = true, use_wind = true) annotation(
    Placement(visible = true, transformation(origin = {-53.7647, 35}, extent = {{-12.2353, -13}, {12.2353, 13}}, rotation = 0)));
  // Hot Pump (power block)
  // Cold pump (receiver)
  //Market
  SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Constant) annotation(
    Placement(visible = true, transformation(origin = {140, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Receiver
  //Storage
  //Loop Breakers
  //Cold Controller (Receiver)
  //Hot Controller (Power Block)
  //Power Block
  SolarTherm.Models.PowerBlocks.PBS_PowerBlockModel_sCO2NREL_100MWe_700C_500C powerBlock(redeclare package Medium = Medium, redeclare model Cooling = SolarTherm.Models.PowerBlocks.Cooling.NoCooling, Q_flow_ref = Q_flow_ref_blk, T_out_ref = T_PB_out_des, W_base = 0.0055 * P_gross_des, m_flow_ref = m_flow_blk_des, nu_net = eff_net_des) annotation(
    Placement(visible = true, transformation(origin = {103, 39}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  //Annual Simulation variables
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
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
                  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_SingleTank_Final Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler, Correlation = 3, E_max = t_storage * 3600 * Q_flow_ref_blk, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, U_loss_tank = U_loss_tank, ar = ar, d_p = d_p, eta = eta) annotation(
                    Placement(visible = true, transformation(origin = {26, 36}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
                */
  //SolarTherm.Models.Storage.Thermocline.Parallel.Thermocline_Spheres_2P_MixedFlow_Strat2 Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package_A = Filler, redeclare package Filler_Package_B = Filler, frac_1 = 1.0 / 2.0, N_f_A = N_f, N_p_A = N_p, T_max = T_max, T_min = T_min, E_max = t_storage * 3600 * Q_flow_ref_blk, ar_A = ar, eta_A = eta, d_p_A = d_p, U_loss_tank_A = 0.0, T_PB_set = 0.5 * (T_max + T_PB_min), T_recv_set = T_recv_max, Correlation = 3) annotation(
  //Placement(visible = true, transformation(origin = {26, 36}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  SolarTherm.Models.Storage.Thermocline.Parallel.Thermocline_Spheres_3P_MixedOutlet Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package_A = Filler, redeclare package Filler_Package_B = Filler, redeclare package Filler_Package_C = Filler, frac_1 = frac_1, frac_2 = frac_2, N_f_A = N_f, N_p_A = N_p, T_max = T_max, T_min = T_min, E_max = E_max, ar_A = ar_A, ar_B = ar_B, ar_C = ar_C, eta_A = eta, d_p_A = d_p, U_loss_tank_A = U_loss_tank, T_recv_set = T_Recv_set, T_PB_set = T_PB_set, Correlation = 3) annotation(
    Placement(visible = true, transformation(origin = {34, 36}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  /*
                            SolarTherm.Models.Storage.Thermocline.Thermocline_HCylinders_SingleTank Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler_B, Correlation = 8, E_max = t_storage * 3600 * Q_flow_ref_blk, N_f = 100, N_p = 10, T_max = T_max, T_min = T_min, U_loss_tank = U_loss_tank, ar = ar, d_p = d_p_A, eta = eta) annotation(
                              Placement(visible = true, transformation(origin = {26, 36}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
                            */
  /*
                          SolarTherm.Models.Storage.Thermocline.Series.Thermocline_Spheres_SGroup3_Compact Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package_A = Filler_A, redeclare package Filler_Package_B = Filler_B, redeclare package Filler_Package_C = Filler_C, Correlation = 3, E_max = t_storage * 3600 * Q_flow_ref_blk, N_f_A = 15, N_p_A = 5, N_f_B = 70, N_p_B = 5, N_f_C = 15, N_p_C = 5, T_max = T_max, T_min = T_min, U_loss_tank = U_loss_tank, ar_A = ar, d_p_A = d_p_A, eta_A = eta, frac_1 = 0.15) annotation(
                            Placement(visible = true, transformation(origin = {26, 36}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
                          */
  /*
                            SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_SingleTank_Compact Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler_B, Correlation = 3, E_max = t_storage * 3600 * Q_flow_ref_blk, N_f = 100, N_p = 10, T_max = T_max, T_min = T_min, U_loss_tank = U_loss_tank, ar = ar, d_p = d_p_A, eta = eta) annotation(
                              Placement(visible = true, transformation(origin = {26, 36}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
                            */
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction_LoopBreaker Splitter_bot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {34, 5}, extent = {{-12, -11}, {12, 11}}, rotation = 180)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction Splitter_top(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {34, 56.9422}, extent = {{-12, 0}, {12, 16.6584}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {4, -4}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {60, 74}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  SolarTherm.Models.Control.PBS_Controller_PBLimit_v2 Control(redeclare package HTF = Medium, T_recv_max = T_recv_max, T_PB_min = T_PB_min, T_target = T_max, m_flow_PB_des = m_flow_blk_des, Q_des_blk = Q_flow_ref_blk, T_recv_start = T_recv_start, T_PB_start = T_PB_start, t_wait = t_PB_wait, eff_storage_des = eff_storage_des, t_stor_startPB = t_stor_startPB, E_max = Tank.E_max) annotation(
    Placement(visible = true, transformation(origin = {70, -20}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  //Analytics
  //Real W_1 "Non-dimensional degradation width of Tank A";
  //Real W_2 "Non-dimensional degradation width of Tank B";
  //Real W_3 "Non-dimensional degradation width of Tank C";
  Models.CSP.CRS.Receivers.PBS_Receiver receiver(A_recv = A_recv, D_rcv = D_recv, H_rcv = H_recv, Q_des_blk = Q_flow_ref_blk, T_0 = T_min, T_max = T_max, ab = ab_recv, em = em_recv) annotation(
    Placement(visible = true, transformation(origin = {-18, 40}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
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
//W_1 = SolarTherm.Utilities.Thermocline.Degradation_Width_2(Tank.Tank_A.z_f, Tank.Tank_A.T_f, 0.05, 0.95, T_min, T_max) / Tank.Tank_A.H_tank;
//W_2 = SolarTherm.Utilities.Thermocline.Degradation_Width_2(Tank.Tank_B.z_f, Tank.Tank_B.T_f, 0.05, 0.95, T_min, T_max) / Tank.Tank_B.H_tank;
//W_3 = SolarTherm.Utilities.Thermocline.Degradation_Width_2(Tank.Tank_C.z_f, Tank.Tank_C.T_f, 0.05, 0.95, T_min, T_max) / Tank.Tank_C.H_tank;
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
    Line(points = {{-83, 70}, {-65, 70}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-77, 50}, {-74.5, 50}, {-74.5, 43}, {-66, 43}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
// Fluid connections
// controlCold connections
// controlHot connections
//Solar field connections i.e. solar.heat port and control
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-54, 60}, {-54, 48}}, color = {255, 128, 0}, thickness = 0.5));
//PowerBlock connections
  P_elec = powerBlock.W_net;
  E_elec = powerBlock.E_net;
  R_spot = market.profit;
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{113, 38}, {130, 38}}, color = {0, 0, 127}));
//connect(Wspd_input.y, receiver.Wspd) annotation(
//  Line(points = {{-113, 48}, {-32, 48}, {-32, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tank.p_amb, Pres_input.y) annotation(
    Line(points = {{46, 36}, {72, 36}, {72, 104}, {129, 104}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Splitter_bot.fluid_b, pumpCold.fluid_a) annotation(
    Line(points = {{24, -4}, {8, -4}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Tank.fluid_b, Splitter_bot.fluid_c) annotation(
    Line(points = {{34, 15}, {34, 5}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Splitter_top.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{44, 74}, {56, 74}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Splitter_top.fluid_c, Tank.fluid_a) annotation(
    Line(points = {{34, 60}, {34, 57}}, color = {0, 127, 255}, thickness = 0.5));
  connect(powerBlock.h_out_signal, Control.h_PB_outlet) annotation(
    Line(points = {{91, 28}, {74, 28}, {74, -11}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tamb_input.y, powerBlock.T_amb) annotation(
    Line(points = {{129, 86}, {99, 86}, {99, 50}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tamb_input.y, Tank.T_amb) annotation(
    Line(points = {{129, 86}, {16, 86}, {16, 36}, {22, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Control.m_flow_PB, pumpHot.m_flow) annotation(
    Line(points = {{79, -19}, {82, -19}, {82, 82}, {60, 82}, {60, 77}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Splitter_bot.fluid_a, powerBlock.fluid_b) annotation(
    Line(points = {{44, -4}, {88, -4}, {88, 30}, {92, 30}}, color = {0, 127, 255}, thickness = 0.5));
  connect(receiver.fluid_a, pumpCold.fluid_b) annotation(
    Line(points = {{-15, 26}, {-6, 26}, {-6, -4}, {0, -4}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Control.defocus, receiver.defocus) annotation(
    Line(points = {{79, -23}, {84, -23}, {84, -40}, {-30, -40}, {-30, 36}, {-23, 36}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(Tamb_input.y, receiver.Tamb) annotation(
    Line(points = {{129, 86}, {-18, 86}, {-18, 52}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(receiver.Q_rcv_raw, Control.Q_rcv_raw) annotation(
    Line(points = {{-14, 36}, {10, 36}, {10, -15}, {62, -15}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Splitter_top.fluid_a, receiver.fluid_b) annotation(
    Line(points = {{24, 74}, {-6, 74}, {-6, 48}, {-13, 48}}, color = {0, 127, 255}, thickness = 0.5));
  connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{64, 74}, {88, 74}, {88, 46}, {94, 46}, {94, 46}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Control.Q_defocus, receiver.Q_defocus) annotation(
    Line(points = {{61, -27}, {-8, -27}, {-8, 31}, {-14, 31}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Control.m_flow_recv, pumpCold.m_flow) annotation(
    Line(points = {{79, -15}, {92, -15}, {92, 4}, {4, 4}, {4, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tank.h_bot_outlet, Control.h_tank_outlet) annotation(
    Line(points = {{27, 19}, {27, 10}, {67, 10}, {67, -11}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tank.T_bot_measured, Control.T_bot_tank) annotation(
    Line(points = {{46, 22}, {50, 22}, {50, -25}, {62, -25}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Control.Level, Tank.Level) annotation(
    Line(points = {{62, -22}, {52, -22}, {52, 42}, {46, 42}, {46, 42}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tank.T_top_measured, Control.T_top_tank) annotation(
    Line(points = {{46, 50}, {54, 50}, {54, -18}, {62, -18}, {62, -18}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{121, 71}, {106, 71}, {106, 50}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(heliostatsField.heat, receiver.heat) annotation(
    Line(points = {{-42, 42}, {-38, 42}, {-38, 44}, {-34, 44}, {-34, 44}}, color = {191, 0, 0}, thickness = 0.5));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(origin = {10, 20}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 12, fontName = "CMU Serif"), Text(origin = {32, 30}, extent = {{-108, -8}, {-62, -16}}, textString = "Heliostat Field", fontSize = 12, fontName = "CMU Serif"), Text(origin = {-16, 16}, extent = {{-44, 72}, {-32, 66}}, textString = "Sun", fontSize = 12, fontName = "CMU Serif"), Text(origin = {14, 10}, extent = {{80, 12}, {100, 6}}, textString = "Power Block", fontSize = 12, fontName = "CMU Serif"), Text(origin = {4, 20}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 12, fontName = "CMU Serif"), Text(origin = {-20, -42}, extent = {{80, 12}, {96, 6}}, textString = "Controller", fontSize = 12, fontName = "CMU Serif"), Text(origin = {104, -2}, extent = {{-108, -8}, {-92, -12}}, textString = "Cold", fontSize = 12, fontName = "CMU Serif"), Text(origin = {104, -8}, extent = {{-108, -8}, {-92, -12}}, textString = "Pump", fontSize = 12, fontName = "CMU Serif"), Text(origin = {160, 76}, extent = {{-108, -8}, {-92, -12}}, textString = "Hot", fontSize = 12, fontName = "CMU Serif"), Text(origin = {160, 70}, extent = {{-108, -8}, {-92, -12}}, textString = "Pump", fontSize = 12, fontName = "CMU Serif"), Text(origin = {-86, -46}, lineColor = {255, 0, 255}, extent = {{80, 12}, {96, 6}}, textString = "Curtailment Strategy", fontSize = 12, fontName = "CMU Serif"), Text(origin = {-54, 16}, extent = {{-44, 72}, {-32, 66}}, textString = "Data Input", fontSize = 12, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.001, Interval = 300, maxStepSize = 60, initialStepSize = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li>Zebedee Kee (Mar 2023) :<br>Started Full Annual Simulations. </li>
	</ul>

	</html>"));
end PBS_Surround_SCO2NREL_MixedOutlet;