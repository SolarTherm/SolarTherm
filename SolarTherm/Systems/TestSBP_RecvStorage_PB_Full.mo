within SolarTherm.Systems;

model TestSBP_RecvStorage_PB_Full
  extends Modelica.Icons.Example;
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Solar_angles;

  package Medium = SolarTherm.Media.Sodium.Sodium_ph;

  //Optimise Parameters
  //Storage Subsystem
  //--Tank
  parameter SI.Volume V_tank = (N_tray*CN.pi*d_tray*d_tray*z_tray)/(4.0*f_packing_xy*f_packing_xy);//1.0e3 "Total volume of a cylindrical tank with aspect ratio a, m3";
  //Trays
  parameter Real f_packing_xy = 0.80 "Horizontal(xy) packing factor of PCM trays defined as A_tray_base/A_tank_base";
  parameter Real f_PCM_safety = 1.05 "Safety factor such that PCM does not exceed wall height";
  //HTF
  parameter Real f_HTF_inventory = 1.0 "Multiplier to empty volume between PCM and wall level occupied to sodium at 1073K to calculate sodium mass inventory";
  //Density of liq sodium ~760kg/m3 at 1073K
  //PCM
  parameter SI.Length z_PCM = 0.20 "Vertical depth of PCM in each tray, m";
  //Insulation
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.5 "Heat transfer coefficient of tank losses between sodium and ambient temps, W/m2K";
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
  parameter Real land_mult = 5.0 "Land area multiplier";
  parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
  parameter Real he_av_design = 0.99 "Helisotats availability";

	//Variable SM
    parameter Real SM_guess = 1.8;
    parameter String SM_10_real = String(2*SolarTherm.Utilities.Round(SM_guess*5));
    //Metadata format Meta = [n_heliostat(float),A_heliostat,eff_opt,H_receiver,D_receiver,H_tower,lat,f_receiver]
    //parameter Real[8] MetaA = SolarTherm.Utilities.Metadata_Optics(fileA);
    //parameter Real[8] MetaB = SolarTherm.Utilities.Metadata_Optics(fileB);
	
    //parameter String file_optics = "/home/admin-u5277975/SodiumBoiler_Project/Optics/Surround/1MWe_75Carnot/1_"+SM_10_real+"_500"; //format (Pname_MW)_(SM*10)_(qmax)
    parameter Integer n_heliostat =3682;// SolarTherm.Utilities.Round(MetaA[1]);
    parameter SI.Area A_heliostat = 3.88;//MetaA[2];
    parameter Real eff_opt = 0.5052;//MetaA[3] + weight*(MetaB[3]-MetaA[3]);
    parameter SI.Length H_receiver = 3.06;// MetaA[4] + weight*(MetaB[4]-MetaA[4]);
    parameter SI.Length D_receiver = 3.06;//MetaA[5] + weight*(MetaB[5]-MetaA[5]);
    parameter SI.Length H_tower = 28.9;//MetaA[6];

  //SolarPILOT info
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
//  parameter SI.Area A_heliostat = 2.0 * 2.0 * 0.97 "Heliostat reflective area";
  //remember this is H x W x 0.97 profile
//  parameter Integer n_heliostat = 2670 "Heliostats number";
//  parameter SI.Efficiency eff_opt = (-3.73e-1) + ((4.07e-1)*A_receiver) + ((-5.81e-2)*(A_receiver^2)) + ((3.34e-3)*(A_receiver^3)) + ((-5.24e-5)*(A_receiver^4)) "Efficiency of optics at design point (max in opt_file)";
  parameter SI.Irradiance dni_des = 950 "DNI at design point";
//  parameter SI.Length H_tower = 20.6 "Tower height";
  // Receiver
  parameter SI.Efficiency ab_rec = 0.961 "Receiver coating absorptance";
  parameter SI.Efficiency em_rec = 0.920 "Receiver coating emissivity";
  //Variable Receiver Size
//  parameter String file_optics = "1_18_1750";
  //Prefix for the optics table files
  //parameter String[2] file_optics_list = OpticsTables(file_optics, f_receiver);
  parameter String convection_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/Convection.txt");
  parameter String fileA = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/SodiumBoiler/Polar/1_18_1000_100_90.motab");
  parameter String fileB = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/SodiumBoiler/Polar/1_18_1000_100_100.motab");
  parameter Real weight = 0.5;//OpticsTableW(file_optics, f_receiver);
  parameter Real f_receiver = 0.95 "Receiver area multiplier";
//  parameter SI.Length H_receiver_base = 1.59 "Receiver height";
//  parameter SI.Diameter D_receiver_base = 1.28 "Receiver diameter";
//  parameter SI.Length H_receiver = H_receiver_base * f_receiver ^ 0.5;
//  parameter SI.Diameter D_receiver = D_receiver_base * f_receiver ^ 0.5;
  parameter SI.CoefficientOfHeatTransfer h_convection_receiver = 20.0 "W/m2K";
  //End Variable Receiver Size
  // Storage
  parameter Real t_storage(unit = "h") = 4.0;//(E_max/Q_flow_ref_blk)/3600.0 "Hours of storage";
  //parameter SI.Temperature T_cold_start = CV.from_degC(290) "Cold tank starting temperature";
  //parameter SI.Temperature T_hot_start = CV.from_degC(574) "Hot tank starting temperature";
  //parameter SI.Temperature T_cold_aux_set = CV.from_degC(280) "Cold tank auxiliary heater set-point temperature";
  //parameter SI.Temperature T_hot_aux_set = CV.from_degC(500) "Hot tank auxiliary heater set-point temperature";
  //parameter SI.Temperature T_cold_set = CV.from_degC(290) "Cold tank target temperature";
  //parameter SI.Temperature T_hot_set = CV.from_degC(574) "Hot tank target temperature";
  //parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
  //parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
  //parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
  //parameter SI.CoefficientOfHeatTransfer alpha = 3 "Tank constant heat transfer coefficient with ambient";
  //Material Properties and Dimensions
  // PCM
  parameter SI.Density rho_PCM_300 = 2136.1 "Density of PCM at 300K, kg/m3";
  parameter SI.Density rho_PCM_start = 1908.236 "Density of PCM at starting point of simulation, kg/m3";
  parameter SI.SpecificEnthalpy h_PCM_start = 713495.0 "Specific enthalpy of PCM at starting point of simulation, J/kg";
  parameter SI.SpecificEnthalpy h_PCM_latent = 482390.5 "Specific enthalpy of fusion of PCM, J/kg";
  parameter SI.SpecificEnthalpy h_PCM_theoretical = 5.8725e5 "Theoretical enthalpy per kg of PCM between -45K and +45K about m.p";
  //NaCl
  // Tank
  parameter SI.Length t_tank = 0.005 "m";
  //1cm Inconel
  parameter SI.Density rho_tank = 8840.0 "kg/m3";
  //Inconel
  parameter SI.SpecificHeatCapacity cp_tank = 600.0 "J/kgK";
  //Inconel
  // Tray
  parameter SI.Length t_tray = 0.005 "m";
  //1cm Steel
  parameter SI.Density rho_tray = 7620.0 "kg/m3";
  //Steel
  parameter SI.SpecificHeatCapacity cp_tray = 627.0 "J/kgK";
  //Steel
  //Constants and Calculations
  parameter Real a_tank = 1.0 "Aspect ratio height(z)/diameter(d) of tank";
  parameter Real f_PCM_expansion = 1.40 "Expansion factor from 300K to 1123K of PCM (50K above melting)";
  //fixed
  parameter Real f_packing_z = 0.80 "Vertical(z) packing factor of PCM trays defined as z_tray/z_tank";
  parameter SI.Area A_pertray = CN.pi * d_tray * d_tray * 0.25 "Cross sectional area per tray, m2";
  parameter SI.Area d_tank = (4.0 * V_tank / (CN.pi * a_tank)) ^ (1.0 / 3.0) "Diameter of the storage tank in, m";
  parameter SI.Length z_tank = a_tank * d_tank "Height of the storage tank, m";
  parameter Integer N_tray = integer(ceil(A_PCM_min/A_pertray)) "Number of PCM trays";//integer(floor(d_tank * d_tank * f_packing_xy / d_tray) * floor(z_tank * f_packing_z / z_tray)) "Number of PCM trays fit into the tank";
  parameter SI.Area A_loss_tank = CN.pi * (0.5 * d_tank * d_tank + d_tank * z_tank) "Total surface area of the tank used for thermal loss calculation";
  //Nota 0.5 is used in place of 1/2 to reduce comp cost
  parameter SI.Volume V_tray = t_tray * N_tray * CN.pi * (d_tray * d_tray * 0.25 + d_tray * z_tray) "Volume occupied by the tray material";
  //Note 0.25 is used in place of 1/4 to reduce computational cost
  parameter SI.Mass m_tank = A_loss_tank * t_tank * rho_tank "Total mass of tank material, kg";
  //Inconel
  parameter SI.Mass m_tray = N_tray * CN.pi * (0.25 * d_tray * d_tray + d_tray * z_tray) * t_tray * rho_tray "Total mass of tray material, kg";
  //Graphite
  parameter SI.Mass m_PCM_min = E_max_min/(h_PCM_theoretical);//A_PCM * z_PCM * rho_PCM_300 "Total mass of PCM material determined during assembly of system at 300K, kg";
  parameter SI.Mass m_PCM = A_PCM*z_PCM*rho_PCM_300;
  //Model Inputs
  parameter SI.HeatCapacity HCap_tank = m_tank * cp_tank;
  parameter SI.HeatCapacity HCap_tray = m_tray * cp_tray;
  parameter SI.Mass m_HTF = f_HTF_inventory * 760.0 * 0.25 * CN.pi * d_tray * d_tray * (z_tray - z_PCM) * N_tray "Mass of sodium in the vessel, kg";
  parameter SI.Length z_tray = z_PCM * f_PCM_expansion * f_PCM_safety "Tray wall height, m";
  parameter SI.Length d_tray = 1.0 "Diameter of the tray base, m";
  //also used for Nusselt number correlation
  parameter SI.Area A_PCM_min = m_PCM_min/(z_PCM*rho_PCM_300);//N_tray * A_pertray "Total cross sectional area per tray, m2";
  parameter SI.Area A_PCM = N_tray*A_pertray;
  parameter SI.ThermodynamicTemperature T_start = T_low_l "Starting temperature of the simulation, K";
  parameter Integer nodes = 20 "Number of discretization elements of PCM";
  parameter Real growth_ratio = 1.2 "Geometric growth ratio of initial mesh thickness, refined mesh at top and bottom surfaces";
  //Pump Loss
  parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold tank parasitic power coefficient";
  parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot tank parasitic power coefficient";
  // Power block (heater head assumed to be 1023K constant, with cold sink temperature designed for 323K)
  parameter Real N_Stirling = P_name/25000.0 "Number of Stirling Engines used";
  parameter SI.Power P_gross = P_name/0.9 "Total gross engines output (23.226kWe gross per engine)";
  parameter SI.Power P_name = 1.0e6 "Total nameplate engine output, assumed to be 90% of nameplate";
  parameter SI.Efficiency eff_blk = 0.5132 "Power block efficiency at design point";
  parameter SI.Temperature TH_set = 1023.0 "Heater head set temperature";
  parameter SI.Power W_base_blk = 0.0055 * P_gross "Power consumed at all times in power block";
  //parameter SI.Power P_name = 1.0e6 "Nameplate rating of power block";
  //parameter SI.Power P_gross = P_name/0.9 "Power block gross rating at design point";
  //parameter SI.Efficiency eff_blk = 0.339 "Power block efficiency at design point";
  //parameter SI.MassFlowRate m_flow_blk = 682.544*(Q_flow_ref_blk/294.118e6) "Mass flow rate to power block at design";
  //parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";
  //parameter Boolean external_parasities = true "true if there is external parasitic power losses";
  //parameter Real nu_min_blk = 0.5 "minimum allowed part-load mass flow fraction to power block";
  //parameter SI.AbsolutePressure p_blk = 10e6 "Power block operating pressure";
  //parameter SI.Temperature blk_T_amb_des = 316.15 "Ambient temperature at design for power block";
  //parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
  //parameter SI.Temperature T_in_ref_blk = from_degC(574) "HTF inlet temperature to power block at design";
  //parameter SI.Temperature T_out_ref_blk = from_degC(290) "HTF outlet temperature to power block at design";
  parameter SI.HeatFlowRate Q_flow_ref_blk = N_Stirling * 54.1266e3 "Thermal power to power block at design";
  // Control
  parameter SI.ThermodynamicTemperature T_up_u = 1118.0;
  //1073+45
  parameter SI.ThermodynamicTemperature T_up_l = 1108.0;
  //1073+35
  parameter SI.ThermodynamicTemperature T_low_u = 1038.0;
  //1073-35
  parameter SI.ThermodynamicTemperature T_low_l = 1028.0;
  parameter SI.TemperatureDifference T_super = 50.0;
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
  parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
  parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
  parameter SI.HeatFlowRate Q_flow_defocus = (Q_flow_ref_blk + Q_flow_rec_loss_def + Q_flow_tank_loss_def) / ab_rec "Solar field thermal power at defocused state";
  //I am assuming this to be (Q_flow_ref_blk+Q_rec_loss_design)/ab
  parameter Real nu_start = 0.6 "Minimum energy start-up fraction to start the receiver";
  parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
  parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
  //parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound"; // Level (below which) to stop disptach
  //parameter Real hot_tnk_empty_ub = 10 "Hot tank empty trigger upper bound"; // Level (above which) to start disptach
  //parameter Real hot_tnk_full_lb = 96 "Hot tank full trigger lower bound"; // Level (below which) to stop defocus
  //parameter Real hot_tnk_full_ub = 99 "Hot tank full trigger upper bound"; // Level (above which) to start defocus
  //parameter SI.Length H_tank = 20.0*((P_name*t_storage)/(100.0e6*4.0))^(1.0/3.0);
  //parameter SI.Length D_tank = 18.667*((P_name*t_storage)/(100.0e6*4.0))^(1.0/3.0);
  //parameter SI.MassFlowRate m_flow_rec_max = 1400*(Q_flow_rec_des/529.4e6) "Maximum mass flow rate to receiver";
  //parameter SI.MassFlowRate m_flow_rec_start = 1000*(Q_flow_rec_des/529.4e6) "Initial or guess value of mass flow rate to receiver in the feedback controller";
  //parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound"; // Level (below which) to stop disptach
  //parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound"; // Level (above which) to start disptach
  //parameter Real cold_tnk_crit_lb = 1 "Cold tank critically empty trigger lower bound"; // Level (below which) to stop disptach
  //parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound"; // Level (above which) to start disptach
  //parameter Real Ti = 0.1 "Time constant for integral component of receiver control";
  //parameter Real Kp = -1000*(Q_flow_rec_des/529.4e6) "Gain of proportional component in receiver control"; //unsure
  // Calculated Parameters
  parameter Real SM = Q_flow_rec_des / Q_flow_ref_blk "Solar multiple. Calculated to obtain 6377 heliostats";
  parameter SI.HeatFlowRate Q_flow_rec_loss_def = CN.sigma * em_rec * A_receiver * ((T_up_u+T_super) ^ 4 - 300 ^ 4) + h_convection_receiver * A_receiver * (T_up_u + T_super - 300) "Receiver defocus heat loss rate";
  parameter SI.HeatFlowRate Q_flow_tank_loss_def = A_loss_tank * U_loss_tank * (T_up_u - 300.0) "Tank defocus heat loss rate";
  parameter SI.HeatFlowRate Q_flow_rec_loss_des = CN.sigma * em_rec * A_receiver * ((1073+T_super) ^ 4 - 300 ^ 4) + h_convection_receiver * A_receiver * (1073 + T_super - 300) "Receiver design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_tank_loss_des = A_loss_tank * U_loss_tank * (1073 - 300.0) "Tank design heat loss rate";
  parameter SI.HeatFlowRate Q_flow_rec_des = dni_des * he_av_design * eff_opt * A_field * ab_rec - Q_flow_rec_loss_des "Receiver Thermal power output at design";
  parameter SI.RadiantPower R_des = 0 "Solar field design thermal power";
  // TODO to be calculated for sizing later
  parameter SI.Area A_land = land_mult * A_field "Land area";
  // TODO land_mult*A_field
  parameter SI.Area A_field = n_heliostat * A_heliostat "Solar field reflective area";
  parameter SI.Area A_receiver = CN.pi * D_receiver * H_receiver "Receiver area";
  parameter SI.HeatFlowRate Q_flow_des = P_gross / eff_blk "Heat to power block at design point";
  parameter SI.Energy E_max_min = t_storage*3600*Q_flow_ref_blk "Maximum tank stored energy (J)";//m_PCM * h_PCM_theoretical "Maximum tank stored energy (theoretical)";
  parameter SI.Energy E_max = m_PCM*h_PCM_theoretical;
  parameter Real C = eff_opt * A_field / A_receiver "Concentration ratio";
  //I'm going with actual concentration ratio = (Q_receiver/A_receiver)/DNI = (opteff*A_field)/(A_receiver)
  // Cost data
  parameter Real r_disc = 0.07 "Discount rate";
  parameter Real r_i = 0.03 "Inflation rate";
  parameter Integer t_life(unit = "year") = 27 "Lifetime of plant";
  parameter Integer t_cons(unit = "year") = 3 "Years of construction";
  parameter Real f_Subs = 0 "Subsidies on initial investment costs";
  parameter FI.AreaPrice pri_field = 140.0 "Field cost per design aperture area";
  //252.0 for 2mx2m
  parameter FI.AreaPrice pri_site = 16.00 "Site improvements cost per area";
  //parameter FI.EnergyPrice pri_storage = 22.0/(1e3*3600) "Storage cost per energy capacity";
  //parameter FI.PowerPrice pri_block = 352.6*(P_gross^(-0.3145)) "Power block cost per gross rated power";
  parameter FI.PowerPrice pri_block = 1360.0 / 1e3 "Power block cost per gross rated power 550USD/kWgross Stirling but too low so choose same as Rankine";
  parameter FI.PowerPrice pri_bop = 0.29;//9.7228 * P_gross ^ (-0.1896) "Balance of plant cost per gross rated power";
  parameter FI.AreaPrice pri_land = 2.47 "Land cost per area";
  parameter Real pri_om_name(unit = "$/W/year") = 75.0 / 1e3 "Fixed O&M cost per nameplate per year";
  // It is 58 $/kW/year in Mehdi's report, but Andrew suggsted a more recent number
  parameter Real pri_om_prod(unit = "$/J/year") = 4.0 / (1e6 * 3600) "Variable O&M cost per production per year";
  // It was 5.9656 $/MWh/year in Mehdi's report, but Andrew suggsted a more recent number
  parameter FI.Money C_field = pri_field * A_field "Field cost";
  parameter FI.Money C_site = pri_site * A_field "Site improvements cost";

  //parameter FI.Money C_tower = 3.0e6 * exp(0.0113 * H_tower) "Tower cost";
  //parameter FI.Money C_receiver = 1.5 * 103.0e6 * (A_receiver / 1571.0) ^ 0.7 "Receiver cost";
  parameter FI.Money C_tower = 3850.0*H_tower "Receiver and tower cost is same USD/kWth of receiver as SAM 2018";
  parameter FI.Money C_receiver = 44785.0*A_receiver "Abengoa Reconstructed Cost";

  //parameter FI.Money C_storage = pri_storage * E_max "Storage cost";
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
  //Unit Storage Cost Prices
  parameter FI.MassPrice pri_HTF = 3.0 "USD/kg for Na";
  parameter FI.MassPrice pri_PCM = 0.049 "USD/kg for NaCl";
  parameter FI.MassPrice pri_tray = 4.255 "USD/kg for SS316L";
  parameter FI.MassPrice pri_tank = 34.5 "USD/kg for Inconel 625";
  //Storage Costs
  parameter FI.Money Cost_HTF = m_HTF * pri_HTF;
  parameter FI.Money Cost_PCM = m_PCM * pri_PCM;
  parameter FI.Money Cost_insulation = A_loss_tank * ((39.89/U_loss_tank) - 0.0539);
  //parameter FI.Money Cost_misc = (m_tank + m_tray + m_HTF + m_PCM) * 0.1722 + 68015.0 * z_tank + 0.018615 * Q_flow_ref_blk + m_PCM * (h_PCM_theoretical / 3600.0e3) * 0.6471;
  parameter FI.Money Cost_misc = (m_tank + m_tray + m_HTF + m_PCM) * 0.1722 + 0.018615 * Q_flow_ref_blk + m_PCM * (h_PCM_theoretical / 3600.0e3) * 0.6471; //small tanks dont require platforms
  //Miscellenous storage items are 13.39USD per KWh_thermal storage capacity
  parameter FI.Money Cost_tank = 1.0 * m_tank * pri_tank;
  parameter FI.Money Cost_tray = 1.5 * m_tray * pri_tray;
  parameter FI.Money C_storage = Cost_tray + Cost_HTF + Cost_PCM + Cost_tank + Cost_insulation + Cost_misc "Storage cost";
  //Boolean constrained(start = false);
  //Real distance(start = 0);

  SolarTherm.Models.Storage.PCM.DirectContact.SB_PCMStorage2 storage( A_PCM = A_PCM, A_surf_tank = A_loss_tank, N_tray = N_tray, T_start = T_low_l, U_loss_tank = U_loss_tank,V_tank = V_tank, V_tray = V_tray, convection_file = convection_file, d_tank = 5, d_tray=d_tray, growth_ratio = growth_ratio, m_HTF = m_HTF, n = nodes, z_PCM = z_PCM, z_tank = 5, z_tray = z_tray) annotation(
    Placement(visible = true, transformation(origin = {-2, 6}, extent = {{-34, -34}, {34, 34}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpRecv(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-74, 14}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpPB(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {74, -26}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.SB_Receiver sB_Receiver(redeclare package Medium = Medium,
	D_rcv = D_receiver,
	D_tb = 40e-3,
	H_rcv = H_receiver, H_tower = 20,
	N_pa = 20, T_0 = 1346.15,
	ab = ab_rec,
	em = em_rec,
	h_convection = h_convection_receiver,
	t_tb = 1.25e-3) annotation(
    Placement(visible = true, transformation(origin = {-112, -6}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-76, -24}, extent = {{18, -18}, {-18, 18}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {74, 20}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression parasit annotation(
    Placement(visible = true, transformation(origin = {142, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.SB_Control sB_Control(m_flow_PB(start = 10), m_flow_PB_des = 200, m_flow_recv(start = 10))  annotation(
    Placement(visible = true, transformation(origin = {6, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Sources.DataTable.DataTable data(file = file_weather, lat = lat, lon = lon, t_zone = t_zone, year = year) annotation(
    Placement(visible = true, transformation(extent = {{-90, -76}, {-60, -48}}, rotation = 0)));

  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(extent = {{118, 84}, {98, 104}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(extent = {{-190, 40}, {-170, 60}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(visible = true, transformation(extent = {{-212, 8}, {-186, 28}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(A_h = A_heliostat, E_start = 90e3 * A_heliostat / 144.375, Q_design = Q_flow_defocus, W_track = 0.055e3 * A_heliostat / 144.375, Wspd_max = Wspd_max, ele_min(displayUnit = "deg") = ele_min, he_av = he_av_design, lat = data.lat, lon = data.lon, n_h = n_heliostat, nu_defocus = nu_defocus, nu_min = nu_min_sf, nu_start = nu_start, use_defocus = true, use_on = true, use_wind = use_wind, redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.TwoTable(angles = angles, fileA = fileA, fileB = fileB, weight = weight)) annotation(
    Placement(visible = true, transformation(extent = {{-180, -38}, {-148, -4}}, rotation = 0)));
  SolarTherm.Models.Sources.SolarModel.Sun sun(lat = data.lat, lon = data.lon, t_zone = data.t_zone, year = data.year,redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(visible = true, transformation(extent = {{-148, 40}, {-128, 60}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.SB_PowerBlockModel PowerBlockModel annotation(
    Placement(visible = true, transformation(origin = {141, -1}, extent = {{-41, -41}, {41, 41}}, rotation = 0)));
    
/*algorithm
  if time > 60.0 then
    if storage.m_avail < 1.0e-6 then
      constrained := true;
      distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
      terminate("Receiver Dries Out");
    elseif storage.L_total > z_tray then
      constrained := true;
      distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
      terminate("Liquid PCM spills out the tray");
    elseif storage.T_HTF < 600.0 then
      constrained := true;
      distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
      terminate("Tank gets too cold to continue");
    elseif storage.x_HTF < 0.0 or storage.x_HTF > 1.0 then
      constrained := true;
      distance := 1000 + 1000 * ((31536000.0 - time) / 31536000.0);
      terminate("Invalid Quality");
    end if;
  end if;*/
equation
  connect(pumpPB.fluid_b, storage.fluid_ap) annotation(
    Line(points = {{66, -26}, {46, -26}, {46, -18}, {32, -18}}, color = {0, 127, 255}));
  connect(sB_Receiver.fluid_b, pumpRecv.fluid_a) annotation(
    Line(points = {{-106, 4}, {-96, 4}, {-96, 14}, {-82, 14}, {-82, 14}}, color = {0, 127, 255}));
  connect(pumpRecv.fluid_b, storage.fluid_ar) annotation(
    Line(points = {{-66, 14}, {-52, 14}, {-52, 23}, {-36, 23}}, color = {0, 127, 255}));
  connect(storage.fluid_br, loop_breaker.port_a) annotation(
    Line(points = {{-36, -18}, {-48, -18}, {-48, -24}, {-58, -24}}, color = {0, 127, 255}));
  connect(sB_Receiver.fluid_a, loop_breaker.port_b) annotation(
    Line(points = {{-108, -24}, {-94, -24}, {-94, -24}, {-94, -24}}, color = {0, 127, 255}));
  connect(storage.fluid_bp, loop_breaker2.port_a) annotation(
    Line(points = {{32, 23}, {46, 23}, {46, 20}, {58, 20}}, color = {0, 127, 255}));
  connect(sB_Control.T_stor, storage.T_storage) annotation(
    Line(points = {{-5, 94}, {-24, 94}, {-24, 54}, {58, 54}, {58, 37}, {35, 37}}, color = {0, 0, 127}));
  connect(sB_Control.m_flow_rec_guess, sB_Receiver.m_flow_guess) annotation(
    Line(points = {{-5, 91}, {-92, 91}, {-92, -6}, {-106, -6}}, color = {0, 0, 127}));
  connect(sB_Control.m_flow_recv, pumpRecv.m_flow) annotation(
    Line(points = {{17, 96}, {32, 96}, {32, 50}, {-74, 50}, {-74, 20}}, color = {0, 0, 127}));
  connect(sB_Control.m_flow_PB, pumpPB.m_flow) annotation(
    Line(points = {{17, 92}, {74, 92}, {74, -20}}, color = {0, 0, 127}));
  connect(sB_Receiver.Tamb, Tamb_input.y) annotation(
    Line(points = {{-112, 10}, {-112, 46}, {90, 46}, {90, 94}, {97, 94}}, color = {0, 0, 127}));
  connect(Tamb_input.y, storage.T_amb) annotation(
    Line(points = {{97, 94}, {90, 94}, {90, 46}, {-2, 46}, {-2, 33}}, color = {0, 0, 127}));
  connect(heliostatsField.heat, sB_Receiver.heat) annotation(
    Line(points = {{-148, -12.5}, {-138, -12.5}, {-138, 0}, {-132, 0}}, color = {191, 0, 0}));
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-169, 50}, {-149, 50}}, color = {0, 0, 127}));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-185, 18}, {-185, 9}, {-180, 9}, {-180, -10}}, color = {0, 0, 127}));
  connect(heliostatsField.on, sB_Control.helio_on) annotation(
    Line(points = {{-164, -38}, {-126, -38}, {-126, 87}, {-5, 87}}, color = {255, 0, 255}));
  connect(sB_Control.defocus, heliostatsField.defocus) annotation(
    Line(points = {{17, 88}, {26, 88}, {26, 70}, {-206, 70}, {-206, -31}, {-180, -31}}, color = {255, 0, 255}));
  connect(loop_breaker2.port_b, PowerBlockModel.fluid_a) annotation(
    Line(points = {{90, 20}, {123, 20}, {123, 13}}, color = {0, 127, 255}));
  connect(pumpPB.fluid_a, PowerBlockModel.fluid_b) annotation(
    Line(points = {{82, -26}, {96, -26}, {96, -19}, {117, -19}}, color = {0, 127, 255}));
  connect(Tamb_input.y, PowerBlockModel.T_amb) annotation(
    Line(points = {{97, 94}, {90, 94}, {90, 38}, {133, 38}, {133, 24}}, color = {0, 0, 127}));
  connect(parasit.y, PowerBlockModel.parasities) annotation(
    Line(points = {{154, 58}, {162, 58}, {162, 38}, {148, 38}, {148, 24}, {149, 24}}, color = {0, 0, 127}));
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-138, 40}, {-164, 40}, {-164, -4}}, color = {0, 127, 255}));
end TestSBP_RecvStorage_PB_Full;