within SolarTherm.Systems;

model SB_Polar_StirlingSES
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
  parameter Real f_recv = 1.0 "Receiver area multiplier to be optimised";
  parameter Real f_PCM_safety = 1.05 "Safety factor such that PCM does not exceed wall height";
  parameter Real f_HTF_inventory = 1.37 "Multiplier to empty volume between PCM and wall level occupied to sodium at 1073K to calculate sodium mass inventory";
  parameter SI.Length z_PCM = 0.20 "Vertical depth of PCM in each tray, m";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.05 "Heat transfer coefficient of tank losses between sodium and ambient temps, W/m2K";
  parameter Real SM_guess = 1.8 "Solar multiple";
  parameter Real t_storage(unit = "h") = 8 "Hours of storage";
  parameter SI.Temperature T_low_u = 1038.0 "Temperature at which PB starts";
  
  //Constants
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_ph "Medium props for molten salt";
  replaceable package PCM = SolarTherm.Media.Materials.NaCl "Material model for Sodium Chloride PCM";
  parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  
  // Weather data
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";
  parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)"; //Alice Springs
  parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)"; //Alice Springs
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  
  // Heliostat Field
  parameter String opt_file_prefix = "modelica://SolarTherm/Data/Optics/SodiumBoiler/polar/1MWe/3460c%/1073K/1000kWpm2/" + SM_string + "dSM/" + "isp_designpt/" + "100%HT"; //where to find the optics file
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file"; //declination-hourangle
  parameter String SM_string = String(2 * SolarTherm.Utilities.Round(SM_guess * 5)) "Solar Multiple rounded to the nearest 0.2, multiplied by 10 and converted to string";
  parameter Real land_mult = 5.0 "Land area multiplier";
  parameter String field_type = "polar"; //is it polar or surround??
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
  parameter String[2] opt_file_list = SolarTherm.Utilities.Interpolation.OpticsTableNames(opt_file_prefix, f_recv);
  parameter String opt_file_A = Modelica.Utilities.Files.loadResource(opt_file_list[1]);
  parameter String opt_file_B = Modelica.Utilities.Files.loadResource(opt_file_list[2]);
  parameter Real opt_file_weight = SolarTherm.Utilities.Interpolation.OpticsTableWeight(opt_file_prefix, f_recv);
  
  //Metadata from the optical lookup table file(s)
  parameter Real[8] MetaA = SolarTherm.Utilities.Metadata_Optics(opt_file_A); //List of metadata values for field A
  parameter Real[8] MetaB = SolarTherm.Utilities.Metadata_Optics(opt_file_B); //List of metadata values for field B
  parameter Integer n_heliostat = SolarTherm.Utilities.Round(MetaA[1]) "Number of heliostats";
  parameter SI.Area A_heliostat = MetaA[2] "Area of one heliostat"; 
  parameter Real eff_opt_des = MetaA[3] + opt_file_weight * (MetaB[3] - MetaA[3]) "Design optical efficiency (interpolated)";
  parameter SI.Length H_recv = MetaA[4] + opt_file_weight * (MetaB[4] - MetaA[4]) "Height of the receiver (interpolated)";
  parameter SI.Length D_recv = MetaA[5] + opt_file_weight * (MetaB[5] - MetaA[5]) "Diameter/Width of the receiver (interpolated)";
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
  parameter SI.CoefficientOfHeatTransfer h_conv_recv = 20.0 "W/m2K"; //constant receiver convection loss coeff (maybe used)
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
  parameter SI.Length d_tray = 1.0 "Diameter of the tray base, m"; //also used for Nusselt number correlation
  parameter SI.ThermodynamicTemperature T_start = T_low_l "Starting temperature of the simulation, K";
  parameter Integer nodes = 20 "Number of discretization elements of PCM";
  parameter Real growth_ratio = 1.2 "Geometric growth ratio of initial mesh thickness, refined mesh at top and bottom surfaces";
  
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
  parameter SI.HeatFlowRate Q_flow_rec_loss_des = CN.sigma * em_recv * A_recv * ((1073 + T_superheat) ^ 4 - 298.15 ^ 4) + h_conv_recv * A_recv * (T_PCM_melt + T_superheat - 298.15) "Receiver design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_tank_loss_des = A_loss_tank * U_loss_tank * (1073 - 298.15) "Tank design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_rec_des = dni_des * he_av_design * eff_opt_des * A_field * ab_recv - Q_flow_rec_loss_des "Receiver Thermal power output at design";
  parameter SI.HeatFlowRate Q_flow_defocus = 0.90*(Q_flow_ref_blk_def + Q_flow_rec_loss_def + Q_flow_tank_loss_def) / ab_recv "Solar field thermal power at defocused state";
  
  //Mass flow rates
  parameter SI.MassFlowRate m_flow_blk_des = Q_flow_ref_blk / (h_in_ref_blk - h_out_ref_blk) "Design point mass flow rate of sodium vapor condensing into the power block";
  parameter SI.MassFlowRate m_flow_recv_des = Q_flow_rec_des / (h_out_ref_recv - h_in_ref_recv) "Design mass flow rate into recv";
 
  // Power block
  parameter String engine_brand = "SES" "Power block brand {SES,75%Carnot}";
  parameter SI.Power P_gross_des = 1.11e6 "Power block gross rating at design point";
  parameter SI.Power P_name_des = 1.00e6 "Power block nameplate rating";
  parameter SI.Temperature T_pb_cool_des = 323.0 "Design cooling temperature of PB";
  parameter SI.Efficiency eff_net_des = 0.9 "Power block net efficiency rating";
  parameter SI.Efficiency eff_blk_des = if engine_brand == "SES" then 0.7893*(1.0 - (T_pb_cool_des/T_PCM_melt)^0.5) else 0.75*(1.0 - (T_pb_cool_des/T_PCM_melt)) "Power block efficiency at design point";
  parameter SI.Efficiency eff_blk_def = if engine_brand == "SES" then 0.7893*(1.0 - (T_pb_cool_des/T_up_u)^0.5) else 0.75*(1.0 - (T_pb_cool_des/T_up_u)) "Power block efficiency at design point";
  
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
  parameter FI.PowerPrice pri_block = if currency == Currency.USD then 1360.00 / 1e3 else (1360.00 / 1e3) / r_cur "Power block cost per gross rated power";
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
  parameter FI.Money C_tower = 3850.0*H_tower "Tower cost";
  parameter FI.Money C_receiver =  44785.0*A_recv "Receiver cost";
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
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(visible = true, transformation(extent = {{138, 86}, {118, 106}}, rotation = 0)));
  //parasitic inputs
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + pumpHot.W_loss + pumpCold.W_loss) annotation(
    Placement(visible = true, transformation(origin = {109, 62}, extent = {{-13, -10}, {13, 10}}, rotation = -90)));
  // Or block for defocusing
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
  // Solar heliostat field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(n_h = n_heliostat, lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design = Q_flow_defocus, nu_start = nu_start, redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.TwoTable(angles = angles, fileA = opt_file_A, fileB = opt_file_B, weight = opt_file_weight)) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
  // Hot Pump (power block)
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium, k_loss = k_loss_hot) annotation(
    Placement(visible = true, transformation(origin = {66, 8}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
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
  SolarTherm.Models.Storage.PCM.DirectContact.SB_PCMStorage2 tankHot(z_tank = z_tank, d_tank = d_tank, t_tank = 5e-3, z_tray = z_tray, d_tray = d_tray, t_tray = 5e-3, N_tray = N_tray, z_PCM = z_PCM, m_HTF = m_HTF, n = nodes, growth_ratio = growth_ratio, T_max = T_up_u, T_min = T_low_l, T_start = T_low_l, U_loss_tank = U_loss_tank, Q_flow_ref_blk = Q_flow_ref_blk) annotation(
    Placement(visible = true, transformation(origin = {30, 22}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  //Loop Breakers
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-4, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {68, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Cold Controller (Receiver)
  SolarTherm.Models.Control.SB_ReceiverControl controlCold(T_df_on = T_up_u, T_df_off = T_up_l, Q_flow_recv_des = Q_flow_rec_des, m_flow_recv_des = m_flow_recv_des) annotation(
    Placement(visible = true, transformation(origin = {-32, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  //Hot Controller (Power Block)
  SolarTherm.Models.Control.SB_PowerBlockControl controlHot(T_on = T_low_u, T_off = T_low_l, m_flow_ref = m_flow_blk_des) annotation(
    Placement(visible = true, transformation(origin = {68, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Power Block
  SolarTherm.Models.PowerBlocks.SB_StirlingPowerBlockModel powerBlock(redeclare package Medium = Medium, P_name = P_name_des, nu_net = 0.9, T_in_ref = T_PCM_melt, T_out_ref = T_PCM_melt, T_cool_des = T_pb_cool_des, engine_brand = engine_brand, W_base = 0.0055 * P_gross_des, m_flow_ref = m_flow_blk_des) annotation(
    Placement(visible = true, transformation(origin = {103, 21}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
  //Annual Simulation variables
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
  Boolean constrained(start = false);
  Real distance(start = 0);
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
equation
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
    Line(points = {{12, 9}, {6, 9}, {6, 10}, {0, 10}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, receiver.fluid_a) annotation(
    Line(points = {{-12, 10}, {-25, 10}}, color = {0, 127, 255}));
  connect(receiver.fluid_b, loop_breaker1.port_a) annotation(
    Line(points = {{-23, 32}, {-14, 32}}, color = {0, 127, 255}));
  connect(loop_breaker1.port_b, tankHot.fluid_ar) annotation(
    Line(points = {{6, 32}, {9, 32}, {9, 31}, {12, 31}}, color = {0, 127, 255}));
  connect(controlCold.defocus, heliostatsField.defocus) annotation(
    Line(points = {{-44, -26}, {-44, -36}, {-94, -36}, {-94, 8}, {-88, 8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(receiver.Q_recv_in, controlCold.Q_recv_in) annotation(
    Line(points = {{-24, 24}, {-18, 24}, {-18, -14}, {-21, -14}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(tankHot.T_storage, controlCold.T_stor) annotation(
    Line(points = {{30, 2}, {14, 2}, {14, -26}, {-22, -26}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(tankHot.T_storage, controlHot.T_stor) annotation(
    Line(points = {{30, 2}, {46, 2}, {46, -26}, {57, -26}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(pumpHot.fluid_b, tankHot.fluid_ap) annotation(
    Line(points = {{60, 8}, {50, 8}, {50, 10}, {48, 10}}, color = {0, 127, 255}));
  connect(tankHot.fluid_bp, loop_breaker2.port_a) annotation(
    Line(points = {{48, 32}, {58, 32}}, color = {0, 127, 255}));
  connect(controlHot.m_flow_PB, pumpHot.m_flow) annotation(
    Line(points = {{80, -26}, {84, -26}, {84, 20}, {66, 20}, {66, 14}, {66, 14}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(controlCold.m_flow_recv, pumpCold.m_flow) annotation(
    Line(points = {{-42, -14}, {-48, -14}, {-48, -6}, {-14, -6}, {-14, 24}, {-6, 24}, {-6, 16}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{109, 48}, {109, 38}}, color = {0, 0, 127}));
  connect(powerBlock.T_amb, Tamb_input.y) annotation(
    Line(points = {{97, 38}, {97, 80}, {120, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(loop_breaker2.port_b, powerBlock.fluid_a) annotation(
    Line(points = {{78, 32}, {90, 32}, {90, 31}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_a, powerBlock.fluid_b) annotation(
    Line(points = {{72, 8}, {86, 8}}));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{118, 20}, {134, 20}, {134, 20}, {136, 20}}, color = {0, 0, 127}));
  connect(Tamb_input.y, receiver.Tamb) annotation(
    Line(points = {{120, 80}, {-25, 80}, {-25, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Wspd_input.y, receiver.Wspd) annotation(
    Line(points = {{-113, 48}, {-32, 48}, {-32, 36}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(Tamb_input.y, tankHot.T_amb) annotation(
    Line(points = {{120, 80}, {22, 80}, {22, 40}, {22, 40}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(receiver.net_gain, controlCold.net_gain) annotation(
    Line(points = {{-24, 18}, {-16, 18}, {-16, -20}, {-22, -20}, {-22, -20}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(origin = {2, 2}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, -8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"), Text(origin = {6, -2}, extent = {{0, 58}, {48, 38}}, textString = "Hot Tank", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-2, -10}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"), Text(origin = {14, 0}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"), Text(origin = {8, -26}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60, maxStep = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released first version. </li>
	</ul>

	</html>"));
end SB_Polar_StirlingSES;