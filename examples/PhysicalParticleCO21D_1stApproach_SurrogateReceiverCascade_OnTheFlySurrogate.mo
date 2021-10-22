within examples;

//***************************** As per December 7 2020, the tower cost function is changed to the Latest Tower Cost Function
//***************************** based on the email by J.Sment (Sandia) Sat 05/12/2020 05:48

model PhysicalParticleCO21D_1stApproach_SurrogateReceiverCascade_OnTheFlySurrogate
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import Utils = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  import SolarTherm.Types.Solar_angles;
  import SolarTherm.Types.Currency;
  import Modelica.Math;
  import SolarTherm.Utilities.Kriging_OnTheFly.*;
  import SolarTherm.Utilities.ANN_OnTheFly.*;
  import metadata = SolarTherm.Utilities.Metadata_Optics_3Apertures;
  import SolarTherm.Models.CSP.CRS.HeliostatsField.TowerRadiusCalculator;
  extends SolarTherm.Media.CO2.PropCO2;
  extends Modelica.Icons.Example;


  
  //****************************** Simulation Set-up
  parameter Boolean set_pri_field_wspd = false "[H&T] true = using wspd_max dependent heliostat cost based on Emes 2017 https://is.gd/xSgpMV ";
  parameter Boolean set_detail_field_om = false "[H&T] true = use detail washing and field O&M cost";
  parameter Boolean set_const_dispatch = true "[CTRL] Constant dispatch of energy";
  parameter Boolean set_feedforward = true "[CTRL] if true then defocus heat is calculated using expensive PB model. False = defocus heat is a function of Q_in_rcv";
  parameter Boolean set_dispatch_optimiser = false;
  parameter Boolean set_new_storage_calc = false "[ST] if true = use tuffcrete and microporous insulation (Zebedee Kee's idea)";
  parameter Boolean set_use_neural_network = true;
  parameter Boolean set_dome_storage = true "[ST] If true then use dome storage calculation provided by Jeremy Sment from Sandia";
  parameter Boolean set_simple_PB_cost = true "[PB] sub system (excluding the primary heat exchanger) are evaluated using gen3_cost";
  parameter Boolean set_tnk_use_p_top = true "true if tank pressure is to connect to weather file";
  parameter Boolean set_tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
  parameter Boolean set_external_storage = true "[ST] true if storage bins are not integrated with tower";
  parameter Boolean set_SAM_tower_cost = true "[H&T] true tower cost is evaluated to match SAM";
  parameter Boolean set_single_field = true "[H&T] True for single field, false for multi tower";
  parameter Boolean set_external_parasities = true "[PB] True = net power calculation in the PB model will consider parasitic losses";
  parameter Boolean set_use_wind = true "True if using wind stopping strategy in the solar field";
  parameter Boolean set_swaying_optical_eff = true "[H&T] True if optical efficiency depends on the wind speed due to swaying effect";
  parameter Boolean get_optics_breakdown = false "if true, the breakdown of the optical performance will be processed";
  parameter Boolean set_optics_verbose = false "[H&T] true if to save all the optical simulation details";
  parameter Boolean set_optics_view_scene = false "[H&T] true if to visualise the optical simulation scene (generate vtk files)";
  
  //****************************** Importing medium and external files
  replaceable package Particle_Package = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
  replaceable package MedPB = SolarTherm.Media.CarbonDioxide_ph "Medium props for sCO2";
  parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/g3p3_TOD.motab") "[FN] Electricity or Time-of-day factor file";
  parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not set_const_dispatch "Discharging schedule from a file";
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab") "[SYS] Weather file";
  parameter String DNI_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab") "[CTRL] Weather file for dispatch optimisation - there was a bug in Modelica s.t. when I parse wea_file to dispatch optimisation, the 
    file path changes to .home/philgun..... which makes C program threw back segfault";
  parameter String price_file = pri_file;
  
  //************************ Weather Data Properties -  based on Dagget TMY2 sent by Luis G from UP Madrid to Philipe Gunawan at 7 April 2020
  parameter nSI.Angle_deg lon = -116.783 "[SYS] Longitude (+ve East) TMY2 Dagget 1967 Location ID 23161";
  parameter nSI.Angle_deg lat = 34.86667 "[SYS] Lati1tude (+ve North) TMY2 Dagget 1967 Location ID 23161";
  parameter nSI.Time_hour t_zone = -8 "[SYS] Local time zone (UTC=0) TMY2 Dagget 1967 Location ID 23161";
  parameter Integer year = 1967 "[SYS] Meteorological year TMY2 Dagget 1967 Location ID 23161";
  
  //****************************** Reading Metadata result
  parameter Real metadata_list[24] = metadata(opt_file);
  
  parameter Real n_helios_1 = metadata_list[11];
  parameter Real n_helios_2 = metadata_list[16];
  parameter Real n_helios_3 = metadata_list[21];
  
  parameter Real n_helios_total = metadata_list[6] "Number of heliostats";
  parameter SI.Area A_field = n_helios_total * metadata_list[5] "Heliostat field reflective area (m^2)";
  parameter Real A_land = metadata_list[3] "Land area consumed by the plant - calculated value by Solstice (m^2)";
  parameter Real etaC = metadata_list[1] "Efficiency of the field at design point";
  
  parameter SI.HeatFlowRate Q_in_lv1(fixed=false) "Heat flow rate to the top receiver at design point [W]";
  parameter SI.HeatFlowRate Q_in_lv2(fixed=false) "Heat flow rate to the mid receiver at design point [W]";
  parameter SI.HeatFlowRate Q_in_lv3(fixed=false) "Heat flow rate to the bottom receiver at design point [W]";
  
  parameter SI.Length Z_rcv_lv1 = metadata_list[14] "Height of the top receiver from the ground [m]";
  parameter SI.Length Z_rcv_lv2 = metadata_list[19] "Height of the mid receiver from the ground [m]";
  parameter SI.Length Z_rcv_lv3 = metadata_list[24] "Height of the bottom receiver from the ground [m]";
  
  //****************************** Field simulation parameters
  parameter String opt_file(fixed = false);
  parameter String casefolder = "." "[H&T] Folder to which the OELT_Solstice look-up table will be stored";
  parameter Solar_angles angles = Solar_angles.dec_hra "[SYS] Angles used in the lookup table file";
  parameter String field_type = "multi-aperture" "[H&T] Other options are : surround";
  parameter SI.Area A_helio = 144.375 "[H&T] Heliostat mirror area (m^2)";
  parameter Real AR_helio = 1 "[H&T] ratio between H_helio/W_helio";
  parameter SI.Length W_helio = sqrt(A_helio / AR_helio) "width of heliostat in m";
  parameter SI.Length H_helio = AR_helio * W_helio "height of heliostat in m";
  parameter SI.Angle slope_error = 1.53e-3 "[H&T] slope error of heliostats, in radiance";
  parameter Real windy_slope_error_factor = 2/(1.53) "[H&T] Multiplier to the slope_error such that the product is the windy_slope_error (2 mrad at nominal)";
  parameter SI.Angle slope_error_windy = windy_slope_error_factor * slope_error "A larger optical error of heliostats under windy conditions, in radiance";
  parameter SI.Length H_tower = 200 "[H&T] Tower height";
  parameter SI.Length R_tower(fixed=false) "Tower inner radius (from the center of the tower until before structural concrete [m]";
  parameter SI.Length R1 = 100 "[H&T] distance between the first row heliostat and the tower";
  parameter Real fb = 0.6 "[H&T] factor to grow the field layout";
  parameter Real he_av_design = 0.99 "[H&T] Helisotats availability";
  parameter Real angular_range = 180 "[H&T] angular range of the multi-aperture configuration";
  parameter Integer num_aperture = 3 "[H&T] number of apertures";
  parameter SI.Length R_rcv_distance(fixed=false) "The raidal distrance of each aperture from the centre of the tower [m]";
  //parameter Integer n_rays = 10000 "[H&T] number of rays for solstice";
  parameter Real n_row_oelt = 5 "[H&T] number of rows of the look up table (simulated days in a year)";
  parameter Real n_col_oelt = 22 "[H&T] number of columns of the lookup table (simulated hours per day)";
  parameter Real n_procs = 0 "[H&T] number of processors to run the MCRT, 0 is using maximum available num cpu, 1 is 1 CPU,i.e run in series mode";
  parameter SI.Efficiency helio_rho = 0.95 "[H&T] Reflectivity of heliostat. 0.95 is the default value in SolarPILOT";
  parameter SI.Efficiency helio_sf_ratio = 0.97 "[H&T] Reflective surface ratio. 0.97 is the default value in SolarPILOT";
  parameter SI.Efficiency helio_soil = 0.95 "[H&T] Heliostat soiling factor. 0.95 is the default value in SolarPILOT";
  parameter SI.Efficiency helio_uncertain_factor = 1 "[H&T] Uncertainty multiplier to the effective heliostat reflectance. The uncertain range is made by making the effective reflectance in the range of 0.8 to 0.95";
  parameter SI.Efficiency helio_refl = helio_rho*helio_sf_ratio*helio_soil*helio_uncertain_factor "The effective heliostat reflectance (product of helio_soil, helio_sf_ratio and helio_rho and the helio_uncertain_factor)";
  
  //****************************** Design condition of the plant
  parameter SI.HeatFlowRate Q_in_rcv = P_gross / eff_blk / eta_rcv_assumption * SM "Incident heat flow rate to the receiver at design point [Wth]";
  parameter String rcv_type = "multi-aperture" "[RCV] other options are : flat, cylindrical, stl";
  parameter nSI.Angle_deg tilt_rcv = 0 "[RCV] tilt of receiver in degree relative to tower axis";
  parameter Real SM = 1.5 "[SYS] Solar multiple";
  parameter SI.Power P_gross = P_net / (1 - par_fr) "The mechanical power of the PB (Turbine power - all of compressors) before cooling and parasities losses";
  parameter SI.Efficiency eff_blk(fixed = false) "Power block efficiency at design point";
  parameter SI.Temperature T_in_rec = T_cold_set "Particle inlet temperature to particle receiver at design";
  parameter SI.Irradiance dni_des = 950 "[SYS] DNI at design point - common values that everyone use?";
  parameter SI.Efficiency eta_rcv_assumption = 0.88 "[RCV] Receiver net thermal efficiency guess value to size the receiver";
  parameter SI.Temperature T_amb_des_rcv = from_degC(10) "[RCV] Design point ambient temp of the receiver (K)";
  parameter SI.Velocity Wspd_max = 15.65 if set_use_wind "[CTRL] Wind stow speed - based on DOE suggestion (m/s)";
  parameter SI.Efficiency packing_factor = 0.6 "[RCV] Based on EES model by Sandia / Luis";
  
  //****************************** Design condition of the Particle Receiver
  parameter Integer discretisations = 30 "[RCV] Number of discretisations when sizing the receiver";
  parameter SI.Area A_ap_lv1 = 300 "[RCV] Top receiver aperture area [m2]";
  parameter SI.Area A_ap_lv2 = 300 "[RCV] Mid receiver aperture area [m2]";
  parameter SI.Area A_ap_lv3 = 300 "[RCV] Bottom receiver aperture area [m2]";

  parameter SI.Area A_ap_lv1_parsed(fixed=false) "Top receiver aperture area [m2]";
  parameter SI.Area A_ap_lv2_parsed(fixed=false) "Middle receiver aperture area [m2]";
  parameter SI.Area A_ap_lv3_parsed(fixed=false) "Bottom receiver aperture area [m2]";
  parameter SI.Area A_rcv_total = A_ap_lv1_parsed + A_ap_lv2_parsed + A_ap_lv3_parsed;
  
  parameter Real ar_rec_lv1 = 1 "[RCV] Height to diameter aspect ratio of the top receiver aperture";
  parameter Real ar_rec_lv2 = 1 "[RCV] Height to diameter aspect ratio of the mid receiver aperture";
  parameter Real ar_rec_lv3 = 1 "[RCV] Height to diameter aspect ratio of the bottom receiver aperture";

  parameter Real ar_rec_lv1_parsed(fixed=false) "Height to diameter aspect ratio of the top receiver aperture";
  parameter Real ar_rec_lv2_parsed(fixed=false) "Height to diameter aspect ratio of the mid receiver aperture";
  parameter Real ar_rec_lv3_parsed(fixed=false) "Height to diameter aspect ratio of the bottom receiver aperture";

  parameter Real rec_fr(fixed = false) "Receiver loss fraction at design point";
  
  parameter SI.Length H_rcv_lv1 = sqrt(A_ap_lv1_parsed * ar_rec_lv1_parsed) "Receiver aperture height";
  parameter SI.Length W_rcv_lv1 = A_ap_lv1_parsed / H_rcv_lv1 "Receiver aperture width";
  
  parameter SI.Length H_rcv_lv2 = sqrt(A_ap_lv2_parsed * ar_rec_lv2_parsed) "Receiver aperture height";
  parameter SI.Length W_rcv_lv2 = A_ap_lv2_parsed / H_rcv_lv2 "Receiver aperture width";
  
  parameter SI.Length H_rcv_lv3 = sqrt(A_ap_lv3_parsed * ar_rec_lv3_parsed) "Receiver aperture height";
  parameter SI.Length W_rcv_lv3 = A_ap_lv3_parsed / H_rcv_lv3 "Receiver aperture width";
  
  parameter SI.Length H_rcv_total = H_rcv_lv1 + H_rcv_lv2 + H_rcv_lv3;
  parameter SI.Length W_rcv(fixed=false) "the maximum width among the three receiver apertures";
  parameter SI.Length L_rcv = 1 "[RCV] Receiver length (depth) (m)";
  
  inner parameter SI.Efficiency eta_rec_th_des = 1 - rec_fr "Receiver thermal efficiency (Q_pcl / Q_sol)";
  parameter Real f_loss = 0.000001 "[RCV] Fraction of particles flow lost in receiver";
  parameter SI.Length th_w = 0.05 "[RCV] Backwall thickness of the receiver";
  parameter SI.ThermalConductance k_w = 0.2 "[RCV] Thermal conductance of the back wall of the receiver";
  parameter SI.CoefficientOfHeatTransfer h_conv_curtain = 32. "[RCV] Constant convective heat transfer coefficient (curtain) [W/m^2-K]";
  parameter SI.CoefficientOfHeatTransfer h_conv_backwall = 10. "[RCV] Constant Convective heat transfer coefficient (backwall) [W/m^2-K]";
  parameter SI.Length d_p = 0.00035 "[RCV] Particle diameter [m]";
  parameter SI.SpecificHeatCapacity cp_s = 1200 "[RCV] particle specific heat capacity [J/kgK]";
  parameter SI.Density rho_s = 3300 "[RCV] Particle intrinsic density [kg/m3]";
  parameter Real eps_s = 0.9 "[RCV] Particle emmisivity - based on EES code by Sandia";
  parameter Real abs_s = 0.9 "[RCV] Particle absorptivity - based on EES code by Sandia";
  parameter Real F = 0.54 "[RCV] View Factor of the particle curtain - based on EES code by Sandia";
  parameter Real eps_w = 0.8 "[RCV] Receiver wall emmisivity - based on EES code by Sandia";
  
  //****************************** NN Based Cascaded Receiver Parameters
  parameter Integer inputsize_rcv = 13;
  
  parameter SI.Area A_ap_lv1_max = 596.1468216938;
  parameter SI.Area A_ap_lv2_max = 597.1294104855999;
  parameter SI.Area A_ap_lv3_max = 596.1483250231;
  
  parameter Real ar_rec_lv1_max = 2.649179561;
  parameter Real ar_rec_lv2_max = 2.9074526455000003;
  parameter Real ar_rec_lv3_max = 2.7704816027;
  
  parameter SI.HeatFlowRate Q_in_rcv_lv1_max = 599950032.084144;
  parameter SI.HeatFlowRate Q_in_rcv_lv2_max = 599946137.752136;
  parameter SI.HeatFlowRate Q_in_rcv_lv3_max = 599557455.8767481;
  
  parameter SI.Temperature T_amb_max_rcv = 323.1293457347;
  parameter SI.Temperature T_in_max_rcv = 973.1350462299;
  parameter SI.Temperature T_out_max_rcv = 2811.7641373140996;
  parameter Real F_wind_max_rcv = 4.8919307372;
  
  parameter SI.Area A_ap_lv1_min = 200.6048838129;
  parameter SI.Area A_ap_lv2_min = 200.66625353220002;
  parameter SI.Area A_ap_lv3_min =202.829754768;
  
  parameter Real ar_rec_lv1_min =0.4537252344;
  parameter Real ar_rec_lv2_min =0.4440564895;
  parameter Real ar_rec_lv3_min =0.6528287836;
  
  parameter SI.HeatFlowRate Q_in_rcv_lv1_min =100331245.403517;
  parameter SI.HeatFlowRate Q_in_rcv_lv2_min =100417983.330101;
  parameter SI.HeatFlowRate Q_in_rcv_lv3_min =100020977.94985;
  
  parameter SI.Temperature T_amb_min_rcv =253.1670653414;
  parameter SI.Temperature T_in_min_rcv =773.3075388557;
  parameter SI.Temperature T_out_min_rcv =852.8923106944002;
  parameter Real F_wind_min_rcv =1.0000008589;
      
  parameter Real[inputsize_rcv] X_max_rcv = {
                                    A_ap_lv1_max, 
                                    A_ap_lv2_max, 
                                    A_ap_lv3_max, 
                                    ar_rec_lv1_max, 
                                    ar_rec_lv2_max, 
                                    ar_rec_lv3_max, 
                                    Q_in_rcv_lv1_max,
                                    Q_in_rcv_lv2_max,
                                    Q_in_rcv_lv3_max,
                                    T_amb_max_rcv,
                                    T_in_max_rcv,
                                    T_out_max_rcv,
                                    F_wind_max_rcv
                                };
                    
  parameter Real[inputsize_rcv] X_min_rcv = {
                                    A_ap_lv1_min, 
                                    A_ap_lv2_min, 
                                    A_ap_lv3_min, 
                                    ar_rec_lv1_min, 
                                    ar_rec_lv2_min, 
                                    ar_rec_lv3_min, 
                                    Q_in_rcv_lv1_min,
                                    Q_in_rcv_lv2_min,
                                    Q_in_rcv_lv3_min,
                                    T_amb_min_rcv,
                                    T_in_min_rcv,
                                    T_out_min_rcv,
                                    F_wind_min_rcv
                                };
  parameter Real y_max_rcv = 0.9573148743;
  parameter Real y_min_rcv = 0.2329207794;
  parameter String saved_model_dir_rcv = 
        Modelica.Utilities.Files.loadResource(
              "modelica://SolarTherm/Resources/Include/neural-network/trained-model/ParticleReceiver/CascadeReceiver/surrogate_receiver_2"
              )
  "[RCV] path to which the static particle receiver surrogate model is stored - Updated model MSE_test = 0.0067, old-model MSE = 0.08";
  
  //****************************** OnTheFlySurrogate Power Block Parameters
  /************************************************************************************************************** /
      /       NREL PB and CEA are sizing the power block based on cycle power. In this code it is called P_gross   /
      /      -cycle power: W_turb_des - W_comp_des - W_recomp_des                                                  / 
      /      -net power : (cycle_power - W_cooling_fan) * eta_motor * (1-f_fixed_load)                             /
      /      All power above are before parasities_input => heliostat field, pump/lift power consumption           /
      /      The output of the on the fly surrogates are: eta_gross and eta Q                                      /
      /      eta_gross: (W_cycle-W_cooling) / Q_HX                                                                 /
      /      eta_Q: (Q_HX / Q_HX_des)                                                                              /
      /      The power block initalisation will produce Q_HX_des, regardless which PB model is used                /   
    ***************************************************************************************************************/
  //******************************** OnTheFlySurrogate PB Simulation Set-up
  parameter String base_path = Modelica.Utilities.Files.loadResource(
                                              "modelica://SolarTherm/Resources/Include"
                              ) 
  "[PB] Base path that points to which folder the C program located";
  
  parameter String SolarTherm_path = Modelica.Utilities.Files.loadResource(
                                                          "modelica://SolarTherm"
                                     ) 
  "[PB] Base path that points to which folder SolarTherm libs are located";
  parameter Integer inputsize_PB = 3 "[PB] the input dimenstion of the surrogate model PB";
  parameter Integer outputsize_PB = 2 "[PB] the output dimension of the surrogate model PB";
  parameter Real tolerance_kriging = 6e-3 "[PB] Error tolerance of the on-the-fly surrogate model Kriging (Mean Absolute Error)";
  parameter Real tolerance_ANN = 6e-3 "[PB] Error tolerance of the on-the-fly surrogate model ANN (Mean Absolute Error)";
  parameter Integer which_surrogate = 2 "1 for Kriging, 2 for ANN";
  parameter Real eta_gross_base(fixed = false) "By product of PB initialisation, regardless which PB model is chosen e.g CEA or SAM";
  parameter Real eta_Q_base(fixed = false) "By product of PB initialisation, regardless which PB model is chosen e.g CEA or SAM";
  
  //******************************** General PB Parameters
  parameter SI.ThermodynamicTemperature T_low = 41 + 273.15 "[PB] Compressor inlet temperature at design point (K)";
  parameter Integer N_HTR = 15 "[PB] Discretisation of high temperature recuperator - CEA PB Parameter";
  parameter Integer N_LTR_parameter = 15 "Discretisation of low temperature recuperator";
  parameter Real f_fixed_load = 0.0055 "[PB] Fixed load constantly consumed by PB when it operates";
  parameter SI.ThermodynamicTemperature T_high = 700 + 273.15 "[PB] Turbine inlet temperature [K] - CEA PB Parameters";
  parameter Real gamma = 0.28 "[PB] Part of the mass flow going to the recompression directly - CEA PB parameters";
  parameter Real par_fr = 0.1 "[PB] Guess value of the parasitics fraction of power block rating at design point";
  
  //******************************** CEA PB Parameters
  parameter SI.Power P_net = 100e6 "[PB] Power block net rating at design point";
  parameter SI.Temperature T_in_ref_blk = T_hot_set "Particle inlet temperature to particle heat exchanger at design";
  parameter SI.AbsolutePressure p_high = 25e6 "[PB] Compressor outlet pressure (Pa)";
  parameter Real PR = 2.78 "[PB] Pressure ratio - CEA PB parameters";
  parameter SI.TemperatureDifference pinch_exchanger = 25 "[PB] pinch point of the heat exchanger - CEA PB parameters";
  parameter SI.TemperatureDifference dTemp_HTF_PHX = T_hot_set - T_cold_set;
  parameter SI.Temperature blk_T_amb_des = T_low - dT_mc_approach "[PB] Ambient temperature at design for power block";
  
  //******************************** NREL SAM PB Parameters - some parameters are defined in the CEA's section
  parameter Integer htf_choice = 50 "[PB] 50 is user defined fluid properties";
  parameter SI.TemperatureDifference dT_PHX_hot_approach(fixed = false) "[PB] difference between hot HTF and TIT (C/K). Product of iteration s.t. the T_HTF_cold_design == T_cold_set";
  parameter SI.TemperatureDifference dT_PHX_cold_approach = 15 "[PB] Temp. difference between cold HTF and cold CO2 PHX inlet (C/K)";
  parameter SI.Efficiency eta_comp_main = 0.89 "[PB] main compressor isentropic efficiency";
  parameter SI.Efficiency eta_comp_re = 0.89 "[PB] re-compressor isentropic efficiency";
  parameter SI.Efficiency eta_turb = if P_gross > 3e7 then 0.93 else 0.85 "turbine isentropic efficiency";
  parameter SI.TemperatureDifference dT_mc_approach = 6.0 "[PB] Temp. difference between main compressor CO2 inlet and ambient (C/K)";
  parameter Integer which_PB_model = 1 "0 is for CEA power block, 1 is for NREL-SAM power block";
  parameter String HTF_name = "CarboHSP" "[PB]";
  parameter Real NREL_PB_configurations[13](each fixed = false) if which_PB_model == 1 "array to store design point sizing result";
  
  //****************************** Storage Parameters
  parameter SI.ThermalInsulance U_value_hot_tank = 0.25 "[ST] Desired U_value for the tanks";
  parameter SI.ThermalInsulance U_value_cold_tank = 0.25 "[ST] Desired U value for the tanks";
  parameter Real t_storage(unit = "h") = 14 "[ST] Storage capacity";
  parameter Real NS_particle = 0.05 "[ST] Fraction of additional non-storage particles";
  parameter SI.Temperature T_cold_set = 550 + 273.15 "[ST] Cold tank target temperature ==  HTF outlet temperature from PB at design point (K)";
  parameter SI.Temperature T_hot_set = 1073.15 "[ST] Hot tank target temperature == HTF inlet temperature to the PB at design point (K)";
  parameter SI.Temperature T_cold_start = T_cold_set "Cold tank starting temperature";
  parameter SI.Temperature T_hot_start = T_hot_set "Hot tank starting temperature";
  
  /*Thermophysical of the particle*/
  parameter Real split_cold = (100 - hot_tnk_empty_ub + 1) / 100 
  "Starting medium fraction in cold tank, must be the function of the upper bound trigger level of the hot tank 
   so the simulation wont crash at t=0, since the control logic use t_on - t_start etc";
  parameter SI.Density rho_cold_set = Particle_Package.rho_T(T_cold_set) "Cold particles density at design";
  parameter SI.Density rho_hot_set = Particle_Package.rho_T(T_hot_set) "Hot particles density at design";
  parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy [J]";
  parameter SI.Mass m_max = E_max / (h_hot_set - h_cold_set) "Max particles mass in tanks [kg]";
  parameter SI.Volume V_max = m_max / ((rho_hot_set + rho_cold_set) / 2) / packing_factor 
  "Volume needed to host particles in the tank with certain packing factor value";
  parameter Real tank_ar = 1.17 "[ST] storage aspect ratio";
  parameter SI.Diameter D_storage = H_storage / tank_ar "Storage tank diameter";
  parameter Real X_dome = 1 / (4 * tank_ar ^ 2) - 1 / (8 * tank_ar ^ 3) + 1 / (12 * tank_ar ^ 3);
  
  parameter SI.Length H_storage = 
        if set_dome_storage then 
                ceil((V_max / (CN.pi * X_dome)) ^ (1 / 3)) 
        else 
                ceil((4 * V_max * tank_ar ^ 2 / CN.pi) ^ (1 / 3)) "Storage tank total height [m]";
  parameter SI.Area SA_storage = 
        if set_dome_storage then 
        //************************ Surface area of the hemisphere and the cylinder
                CN.pi * D_storage * (H_storage - 0.5 * D_storage) + 2 * CN.pi * (D_storage / 2) ^ 2 
        else 
        //************************ Assuming cylindrical storage
                  CN.pi * D_storage * H_storage "Storage tank surface area";
  
  
  
  parameter SI.Length Th_refractory_hot_tank = 1.0 "[ST] Thickness of the refractory of the hot tank [m] - Dome Storage only";
  parameter SI.Length Th_refractory_cold_tank = 0.5 "[ST] Thickness of the refractory of the cold tank [m] - Dome Storage only";
  
  //****************************** Power Block Technical Parameters - CEA Power Block
  /*Heat Exchanger Parameters*/
  parameter Real pinch_recuperator = 15 "Pinch point of the recuperators - CEA PB Parameters";
  parameter SI.Temperature T_out_ref_blk = T_cold_set "Particle outlet temperature from particle heat exchanger at design";
  parameter SI.Temperature T_in_ref_co2 = T_cold_set - pinch_exchanger "CO2 inlet temperature to particle heat exchanger at design";
  parameter SI.Temperature T_out_ref_co2 = T_high "CO2 outlet temperature from particle heat exchanger at design";
  parameter Integer N_exch_parameter = 15 "Heat exchanger discretisation - CEA PB Parameters";
  parameter Real nu_min_blk = 0.5 "[PB] Minimum allowed part-load mass flow fraction to power block";
  parameter SI.CoefficientOfHeatTransfer h_conv_CO2 = 2000 "[PB] According to Sandia EES Code";
  parameter Real A_HX(fixed = false) "Heat exchanger total surface area --> UA_HX / U_HX";
  parameter Real UA_HX(fixed = false) "By product of initialisation of the PB model regardless which PB model is chosen";
  parameter Real U_HX(fixed = false) "Calculated parameter in the initial equation";
  
  //****************************** Particle Lift Parameters
  parameter SI.Height dh_liftRC = H_tower "Vertical displacement in receiver lift";
  parameter SI.Height dh_liftHX = 10 "[H&T] Vertical displacement in heat exchanger lift";
  parameter SI.Height dh_LiftCold = H_storage "Vertical displacement in cold storage lift";
  parameter SI.Efficiency eff_lift = 0.8 "[H&T] Lift total efficiency";
  
  //****************************** Power Plant Control
  parameter SI.Time t_start = 3600 "[CTRL] Start-up traking delay";
  parameter SI.Angle ele_min = 0.0872665 "[CTRL] Heliostat stow deploy angle = 5 degree";
  parameter SI.HeatFlowRate Q_flow_defocus_calculated_lv1(fixed = false);
  parameter SI.HeatFlowRate Q_flow_defocus_calculated_lv2(fixed = false);
  parameter SI.HeatFlowRate Q_flow_defocus_calculated_lv3(fixed = false);
  //parameter SI.HeatFlowRate Q_flow_defocus = if feedforward == true then 280e6 else Q_flow_des / (1 - rec_fr) "Solar field thermal power at defocused state";
  
  parameter Real nu_start = 0.29 "[CTRL] Fraction of Q_in_rcv above which the receiver stop working - SAM 2020.2.29 value minus hysterisis";
  parameter Real nu_min_sf = 0.3 "[CTRL] Fraction of Q_in_rcv below which the receiver stop working - SAM 2020.2.29 value";
  parameter Real nu_defocus = 1 "[CTRL] Energy fraction to the receiver at defocus state -> nu_defocus * Q_flow_defocus_calculated";
  parameter Real hot_tnk_empty_lb = 5 "[CTRL] Hot tank empty trigger lower bound";
  parameter Real hot_tnk_empty_ub = 10 "[CTRL] Hot tank trigger to start dispatching";
  parameter Real hot_tnk_full_lb = 93 "[CTRL] Hot tank full trigger lower bound";
  parameter Real hot_tnk_full_ub = 95 "[CTRL] Hot tank full trigger upper bound";
  parameter Real cold_tnk_defocus_lb = 5 "[CTRL] Cold tank defocus trigger lower bound";
  parameter Real cold_tnk_defocus_ub = 7 "[CTRL] Cold tank defocus trigger upper bound";
  parameter Real cold_tnk_crit_lb = 1 "[CTRL] Cold tank critically empty trigger lower bound";
  parameter Real cold_tnk_crit_ub = 30 "[CTRL] Cold tank critically empty trigger upper bound";
  
  //****************************** Dispatch Optimiser Parameters
  parameter Integer horizon = 48 "[CTRL] Forecast horizon of the dispatch optimisation algoriuthm in GLPK";
  parameter Real dt = 1 "[CTRL] delta t of the optimisation. For each how many hour the dispatch optimiser is gonna be called";
  parameter Real etaG(fixed = false) "By product of power block intialisation";
  parameter Real SLminrel = hot_tnk_empty_lb / 100 "hot tank empty trigger point";
  parameter Real Ahelio = A_field;
  parameter Real const_t = -dt * 3600;
  
  //******************************* Other Parameters
  parameter SI.HeatFlowRate Q_flow_des(fixed = false) "Heat to power block at design--> result of PB initialisation (W)";
  parameter SI.SpecificEnthalpy h_cold_set = Particle_Package.h_T(T_cold_set) "Cold particles specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_hot_set = Particle_Package.h_T(T_hot_set) "Hot particles specific enthalpy at design";
  parameter SI.MassFlowRate m_flow_fac(fixed = false);
  parameter SI.MassFlowRate m_flow_rec_max = 1.5 * m_flow_fac "Maximum mass flow rate to receiver";
  parameter SI.MassFlowRate m_flow_rec_start = 0.8 * m_flow_fac "Initial https://pubs.acs.org/doi/pdf/10.1021/jp206115por guess value of mass flow rate to receiver in the feedback controller";
  parameter SI.MassFlowRate m_flow_blk(fixed = false);
  parameter SI.Power P_name = P_net "Nameplate rating of power block";
  
  //******************************* Financial parameters
  parameter Currency currency = Currency.USD "[FN] Currency used for cost analysis 2 is USD 1 is AUD";
  parameter Real r_i = 0.025 "[FN] Inflation rate";
  parameter Real r_disc_nom = 0.0701 "[FN] Nominal discount rate";
  parameter Real r_disc = (1 + r_disc_nom) / (1 + r_i) - 1 "[FN] Real discount rate : Calculated using Fisher equation";
  parameter Integer t_life(unit = "year") = 30 "[FN] Lifetime of plant";
  parameter Integer t_cons(unit = "year") = 0 "[FN] Years of construction";
  parameter Real r_cur = 0.71 "[FN] The currency rate from AUD to USD valid for 2019. See https://www.rba.gov.au/";
  parameter Real r_contg = 0.1 "[FN] Contingency rate";
  parameter Real r_cons = 0.09 "[FN] Construction cost rate";
  
  //******************************* Specific cost for field, particle receiver, tower and lift
  parameter FI.AreaPrice pri_field = 
        if set_pri_field_wspd == true then 
        //********** Field price depends on the wind speed and mirror size Emes 2017 https://is.gd/xSgpMV
            FI.heliostat_specific_cost_w_spd(Wspd_max = Wspd_max, A_helio = A_helio) * 0.3716 
        else 
            75 "Heliostat field specific price (USD/m^2)";
            
  //******************************* Field price is based on Gen3 Roadmap Report
  parameter FI.AreaPrice pri_site = 10 "Site improvements cost per area [USD/m2 of heliostat]";
  parameter FI.AreaPrice pri_land = 10000 / 4046.86 "Land cost per area [USD/m2]";
  parameter Real pri_tower_fix_SAM = 3e6 "[H&T] Fix tower cost according to SAM cost function";
  parameter Real pri_tower_scalar_exp_SAM = 0.0113 "[H&T] Scaler for tower cost according to SAM";
  parameter Real pri_lift = 58.37 "Lift cost per rated mass flow per height Kevin Albrect, 2019 https://is.gd/3VN0O7";
  parameter FI.AreaPrice pri_receiver = 37400 "Falling particle receiver cost per design aperture area Kevin Albrect, 2019 https://is.gd/3VN0O7";
  
  //******************************** Specific cost for the storage system
  parameter FI.MassPrice pri_particle = 1.0 "[ST] Unit cost of particles per kg";
  parameter Real pri_bin = 1230 "[ST] bin specific cost to tank surface area based on Kevin Albrect, 2019 https://is.gd/3VN0O7";
  parameter Real pri_bin_linear = 0.369 "[ST] bin linear scaler to tank temperature [USD/m^2] based on Kevin Albrect, 2019 https://is.gd/3VN0O7";
  parameter Real pri_bin_multiplier = 1 "[ST] number of each type of tank - use 1 if only have 1 hot tank and 1 cold tank";
  /*Starting from here, specific cost is for Jeremy Sment storage system cost function*/
  parameter Real pri_HRC = 850 "[ST] Specific cost of high resistance concrete [USD/m^3]";
  parameter Real pri_portland = 229 "[ST] Specific cost of portland concrete [USD/m^3]";
  parameter Real pri_RF = 2700 "[ST] Specific cost of refractory [USD/m^3]";
  parameter Real pri_filler_floor = 150 "[ST] Specific cost of floor filler material [USD/m^3]";
  parameter Real pri_roof = 457.4662 "[ST] Specific cost for roof (integrated storage)";
  parameter Real[6] c_storage = {
                        pri_HRC, 
                        pri_portland, 
                        pri_RF, 
                        pri_filler_floor, 
                        pri_particle,
                        pri_roof};
                        
  parameter Real D_outlet = if E_max * 2.777778e-10 < 600 then 0.21 else 0.5 "If stg capacity >= 600 MWh then D_outlet is 0.5 else 0.21 m";
  
  //******************************* Specific Cost parameters for Power Block Components
  parameter Real pri_recuperator = 5.2 "[PB] Specific cost of turbine (USD-K^0.8933/W^0.8933) based on Albrecht 2019 https://is.gd/3VN0O7";
  parameter Real pri_turbine = 9923.7 "[PB] Specific cost of turbine (USD/kW^0.5886) based on Albrecht 2019 https://is.gd/3VN0O7";
  parameter Real pri_compressor = 643.15 "[PB] Specific cost of compressor (USD/kW^0.9142) based on Albrecht 2019 https://is.gd/3VN0O7";
  parameter Real pri_cooler = 2.3 
  "[PB] Main cooler specific cost:
                 >  Based on Albrecht 2019 https://is.gd/3VN0O7 the specific cost is 76.25 (USD-K^0.8919/W^0.8919)
                 >  Based on NREL sCO2 PB model used in SAM --> 2.3 USD-K/W
  If we use UA_cooler from SAM Simulation Core sCO2 model and use Albrecht cost function, the cooler cost can reach up to 100 M.USD.
  I believe we can just use NREL sCO2 PB model cooler cost function --> 2.3 x UA_cooler [W/K]";
  
  parameter Real pri_generator = 108900 "[PB] Generator cost (USD/MWe^0.5463) based on Weiland 2019 https://is.gd/uTaFkD";
  parameter Real pri_PHX_BOP_CO2 = 4753 "[PB] Primary Heat Exchanger sCO2 Line Cost (USD-s/kg) - G3P3 conversation email by Cliff 11 Nov 2020";
  parameter Real pri_PHX_BOP_s = 9153 "[PB] Primary Heat Exchanger Particle Cost [USD-s/kg] - G3P3 conversation email by Cliff 11 Nov 2020";
  parameter Real pri_PHX_per_area = 6594.5 "[PB] Primary Heat Exchanger Material+Manufacture Cost (USD/m2) - G3P3 conversation email by Cliff 11 Nov 2020";
  parameter FI.Money pri_exchanger = 150 "[PB] price of the primary exchanger in (USD/(kW_th). Value from v.9 EES sandia result c_hx";
  parameter FI.PowerPrice pri_bop = 290 / 1040 * 600 / 1000 "USD/We Balance of plant cost per gross rated power. 290--> Maximum BOP cost per MWe from SAM. 
     1040 is the maximum power block cost per MWe at SAM. 600 is the specific cost of the power block in USD/kWe according to DOE guidline";
  parameter FI.PowerPrice pri_block = 600 "sCO2 PB cost USD per kWe net based on the G3P3 Roadmap Report";
  
  //******************************* O&M & Washing Heliostat Specific Cost
  // Source : Heliostat Cost Reduction Study Gregory J. Kolb, page 138 Table 1
  parameter Real pri_om_name(unit = "$/W/year") = 40 / 1e3 "Fixed O&M cost per nameplate per year";
  parameter Real pri_om_prod(unit = "$/J/year") = 0.003 / (1e6 * 3.6) "Variable O&M cost per production per year";
  parameter Real C1_washing = 98 "[H&T] cleanliness of the mirror after 1 cleaning pass for method 1 (%)";
  parameter Real C2_washing = 96.5 "[H&T] cleanliness of the mirror after 1 cleaning pass for method 2 (%)";
  parameter Real C_target = helio_rho * 100 "annual reflectivity target";
  parameter Real R_soil = 0.49 "[H&T] reflectivity loss from the design reflectivity due to soiling";
  parameter Real P_w = 12 "[H&T] Month(s) in a year that the cleaning will be conducted";
  parameter Real omega_n = 1.5 "[H&T] Natural washing frequency (rain, snow, etc)";
  parameter Real omega_twister(fixed = false) "Supplementary washing (with machine) frequency per year";
  parameter Real pri_washing_deluge_method = 0.0027 * 1.3 "[H&T] USD/m.sq field annually. 1.3 is a factor of conversion from USD 2007 to 2020";
  parameter Real pri_washing_twister_method = 0.0076 * 1.3 "[H&T] USD/m.sq field annually. 1.3 is a factor of conversion from USD 2007 to 2020";
  parameter Real omega_deluge = 2 * omega_twister "this approach uses KJC cleaning method (1 Twister and 2 Deluge truck in between)
    Source : Heliostat Cost Reduction Study Gregory J. Kolb, page 121 Table A-8";
  parameter Real pri_om_field = 52.8815449319 * A_helio ^ (-1.0359277351) "O&M field based on number of heliostat in USD / unit. 
    The price is multiplied by 1.5 to converT it to USD 2020 from USD 2000";
    
  //******************************* Cost of the PB components ---> product of PB initalisation
  parameter FI.Money C_HTR(fixed = false) "cost of the high temperature heat recuperator";
  parameter FI.Money C_LTR(fixed = false) "cost of the low temperature heat recuperator";
  parameter FI.Money C_turbine(fixed = false) "cost of the turbine";
  parameter FI.Money C_mainCompressor(fixed = false) "cost of the main compressor";
  parameter FI.Money C_reCompressor(fixed = false) "cost of the re compressor";
  parameter FI.Money C_exchanger(fixed = false) "cost of the exchanger";
  parameter FI.Money C_generator(fixed = false) "cost of the generator";
  parameter FI.Money C_cooler(fixed = false) "cost of the cooler";
  parameter FI.Money C_block(fixed = false) "Power block cost";
  
  //******************************* Cost Washing calculation
  parameter FI.Money C_washing = (omega_twister * pri_washing_twister_method + omega_deluge * pri_washing_deluge_method) * A_field "Washing cost [USD/year]";
  parameter FI.Money C_om_field = pri_om_field * A_field "OnM field exclude washing cost [USD/year]";
  
  //******************************* Cost of solar field calculation
  parameter FI.Money C_field = A_field * pri_field "Field cost";
  parameter FI.Money C_site = A_field * pri_site "Site improvements cost";
  parameter FI.Money C_land = A_land * pri_land "Land cost";
  parameter FI.Money C_field_total = C_field + C_site "Heliostat field plus site preparation costs";
  
  
  //******************************* Cost of tower sub-system (receiver + tower + receiver lift)
  //******************************* As per December 7 2020, the tower cost function is changed to the Latest Tower Cost Function
  parameter Real Euro_to_USD_exchange_rate = 1.21 "[USD/Euro]";
  parameter FI.Money C_extra_structure(fixed=false);
  
  /*Latest Tower Cost Function Based on the email by J.Sment (Sandia) Sat 05/12/2020 05:48 */
  parameter FI.Money C_tower = 
      if set_SAM_tower_cost then 
        //*********************************** Evaluating tower cost using SAM tower correlation - piping cost + ducting cost + extra structure cost
        //*********************************** Based on the email by J.Sment (Sandia) Sat 05/12/2020 05:48 
        /*C_tower = Tim Harvey structure only cost [USD]- SBP Materials [USD]+ Sam Tower Cost [USD]- Piping Cost [in Euro] + Ducting cost [USD]*/
            C_extra_structure - 
            
            1.992 * H_tower^2.747 + 523100 +  //==================> SBP Material Cost
            
            pri_tower_fix_SAM * Modelica.Math.exp(pri_tower_scalar_exp_SAM * (H_tower + 0.5 * H_helio - H_rcv_total / 2)) - //==========> SAM Cost v2020.2.29
            
            28000 * Euro_to_USD_exchange_rate * H_tower +  //================> Piping cost
            
            1573 * H_tower //==================> Ducting Cost
      else
        //*********************************** Evaluating tower cost using SAM tower correlation - piping cost + ducting cost + extra structure cost
        //*********************************** Based on the email by J.Sment (Sandia) Sat 05/12/2020 05:48 
        /*C_tower = Tim Harvey structure only cost [USD]- SBP Materials [USD]+ SBP Tower Cost without Piping [Euro] + Ducting cost [USD]*/
            C_extra_structure - 
            
            1.992 * H_tower^2.747 + 523100 + //==================> SBP Material Cost
            
            (0.7452 * H_tower^3 - 148.25 * H_tower^2 + 37204*H_tower - 731236) * Euro_to_USD_exchange_rate +  //======> SBP no pipe cost 
            
            1573 * H_tower //======> Ducting Cost
  
  "Cost of tower based on J.Sment (Sandia) email to G3P3 Team at Sat 05/12/2020 05:48
      > Tim Harvey structure only cost model is a function of tower height [H_tower] and maximum particle mass in one storage tank [m_max]
            - Regression model for Tim Harvey cost is made using an online tool https://stats.blue/Stats_Suite/multiple_linear_regression_calculator.html:
             
              C_harvey = 2293496.5853409-45954.7293032756*H_tower+
                                0.1048843661*m_max+256.311306896*H_tower^2+0.0015436937*m_max*H_tower-0.0000000021*m_max^2  
      > The Upper Boundary cost is the one with SAM cost function:
          C_tower = Tim Harvey cost [USD] - SBP Material Cost [USD] + SAM Tower Cost [USD] - Piping Cost [Euro] * USD_to_Euro + Ducting cost [USD]
      > The Lower Boundary cost:
          C_tower = Tim Harvey cost [USD] - SBP Material Cost [USD] + SBP Tower Cost (no pipe) [USD] - Ducting cost [USD]
      
      As per December 7 2020, the tower cost function is changed to the Latest Tower Cost Function";
      
  parameter FI.Money C_fpr = pri_receiver * A_rcv_total "Falling particle receiver cost";
  parameter FI.Money C_lift_rec = pri_lift * dh_liftRC * m_flow_fac "Receiver lift cost";
  parameter FI.Money C_receiver = C_fpr + C_tower + C_lift_rec "Total receiver sub-system cost";
  
  //******************************* Cost of storage sub-system (bins + cold tank lift + particles + PHX lift + insulation)
  parameter FI.Money C_lift_cold = if set_external_storage then 
                                            pri_lift * dh_LiftCold * m_flow_blk 
                                   else
                                            0
  "Cold storage tank lift cost";
  
  //******************************* Storage bin cost calculation based on Kevin Albrect, 2019 https://is.gd/3VN0O7
  parameter FI.Money C_bins = 
      if set_new_storage_calc then 
          750 * CN.pi * (D_storage - 1 - 1) * H_storage 
      else 
          pri_bin_multiplier * (pri_bin + pri_bin_linear * (T_hot_set - 600) / 400) * SA_storage 
                + pri_bin_multiplier * (pri_bin + pri_bin_linear * (T_cold_set - 600) / 400) * SA_storage;
                
  //******************************* Storage bin cost calculation based on Jeremy Sment of Sandia study (g3p3 project)
  parameter FI.Money C_bins_dome = 
      if set_external_storage then 
          SolarTherm.Utilities.G3P3StorageCostFunction(
                Th_refractory_hot_tank, 
                H_storage, 
                D_storage, 
                D_outlet, 
                t_storage, 
                m_max, 
                c_storage) + 
          
          SolarTherm.Utilities.G3P3StorageCostFunction(
                Th_refractory_cold_tank, 
                H_storage, 
                D_storage, 
                D_outlet, 
                t_storage, 
                m_max, 
                c_storage) 
      else 
          SolarTherm.Utilities.G3P3StorageCostFunction_Integrated(
                Th_refractory_cold_tank, 
                H_tower, 
                R_tower * 2, 
                m_max, 
                D_outlet, 
                packing_factor,
                c_storage) + 
                
          SolarTherm.Utilities.G3P3StorageCostFunction_Integrated(
                Th_refractory_hot_tank, 
                H_tower, 
                R_tower * 2, 
                m_max, 
                D_outlet, 
                packing_factor,
                c_storage) 
  "Storage bin for dome storage --> based on the type of storage";
  
  parameter FI.Money C_insulation = 
        if U_value_hot_tank == 0 and U_value_cold_tank == 0 then 
            0 
        else 
            SA_storage * (131.0426 / U_value_hot_tank + 23.18) + 
                  SA_storage * (131.0426 / U_value_cold_tank + 23.18) 
  "Insulation cost based on Kevin Albrecht 2019 https://is.gd/3VN0O7";
  
  parameter FI.Money C_particles = (1 + NS_particle) * pri_particle * m_max "Cost of particles";
  parameter FI.Money C_lift_hx = pri_lift * dh_liftHX * m_flow_blk "Heat exchanger lift cost";
  /******************************************************************************************************
            FIXME: There are 2 u_values now, implement it in the tuffcrete x microporous analysis
            (131.0426 / U_value + 23.18) ======> cost function insulation of Tuffcrete, Microporous and Concrete
            (873.11/U_value) - 322.202 ======> cost function insulation of Tuffcrete, Pumplite60 and Concrete
            0.03293006 / U_value + 0.01518 =====> thickness function of Pumplite60;
            0.32368 / U_value - 0.146096   =====> thickness function of Microporous;
            parameter SI.Length t_mp = 0.32368 / (U_value_hot_tank + U_value_cold_tank) - 0.146096;
            parameter SI.Length t_tuffcrete47 = 0.01;
    ******************************************************************************************************/
  parameter FI.Money C_storage = 
      if set_dome_storage then 
          C_bins_dome + C_particles + C_lift_hx + C_lift_cold + 0 + f_loss * t_life * pri_particle * 1.753e10 
      else 
          C_bins + C_particles + C_lift_hx + C_lift_cold + C_insulation + f_loss * t_life * pri_particle * 1.753e10 
  "Total storage cost. Dome storage bin cost calculation already considers insulation (refractory) s.t. C_insulation = 0";
  
  //******************************* Cost of BOP
  parameter FI.Money C_bop = P_gross * pri_bop "Balance of plant cost";
  //******************************* Cost of O&M (fixed + varied)
  parameter FI.MoneyPerYear C_year = 
      if set_detail_field_om then 
          P_name * pri_om_name + C_om_field + C_washing 
      else 
          P_name * pri_om_name 
  "Fixed O&M cost per year + OnM field + Cost of washing the field";
  
  parameter FI.Money C_prod = pri_om_prod "Variable O&M cost per production per year";
  
  //******************************* Total cost calculation
  parameter FI.Money C_cap_total(fixed = false) "equipment cost";
  parameter FI.Money C_direct(fixed = false) "Direct capital costs";
  parameter FI.Money C_indirect(fixed = false) "Indirect capital costs";
  parameter FI.Money C_cap(fixed = false) "Capital costs";
  
  //********************* System Components Instantiation
  //********************* Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(extent = {{-144, -60}, {-114, -32}}, rotation = 0)));
  //********************* DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(origin = {-127, 70}, extent = {{-13, -10}, {13, 10}}, rotation = 0)));
  
  //********************* Weather inputs
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(origin = {139, 80}, extent = {{19, -10}, {-19, 10}}, rotation = 0)));
  
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(transformation(extent = {{-140, 20}, {-114, 40}})));
  
  Modelica.Blocks.Sources.BooleanExpression always_on(y = true) annotation(
    Placement(visible = true, transformation(origin = {-128, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Sources.RealExpression Wind_dir(y = data.Wdir) annotation(
    Placement(visible = true, transformation(origin = {-129, 51}, extent = {{-11, -13}, {11, 13}}, rotation = 0)));
  
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(transformation(extent = {{76, 18}, {56, 38}})));
  
  SolarTherm.Utilities.WspdScaler wspdScaler(H_tower = H_tower) annotation(
    Placement(visible = true, transformation(origin = {-51, 45}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  
  //********************* Parasitic inputs
  Modelica.Blocks.Sources.RealExpression parasities_input(
      y = 
          if set_external_storage then 
                heliostatsField.W_loss + liftHX.W_loss + liftRC.W_loss + tankHot.W_loss + tankCold.W_loss 
          else 
                heliostatsField.W_loss + 0 + liftRC.W_loss + tankHot.W_loss + tankCold.W_loss) annotation(
    Placement(visible = true, transformation(origin = {143, 57}, extent = {{-12, -6}, {12, 6}}, rotation = -90)));
  
  //*********************  Or block for defocusing
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(transformation(extent = {{-102, 4}, {-94, 12}})));
  
  //********************* Sun Model
  SolarTherm.Models.Sources.SolarModel.Sun sun(
      lon = lon, 
      lat = lat, 
      t_zone = t_zone, 
      year = year, 
      redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
  
  //********************* Solar field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsFieldSolstice_3Apertures_1stApproach heliostatsField(
      lon = lon, 
      lat = lat, 
      ele_min(displayUnit = "deg") = ele_min, 
      use_wind = set_use_wind, 
      t_start = t_start, 
      Wspd_max = Wspd_max, 
      he_av = he_av_design, 
      use_on = true, 
      use_defocus = true, 
      A_h = A_helio, 
      nu_defocus = nu_defocus, 
      nu_min = nu_min_sf,
      nu_start = nu_start, 
      Q_design_1 = Q_flow_defocus_calculated_lv1, 
      Q_design_2 = Q_flow_defocus_calculated_lv2, 
      Q_design_3 = Q_flow_defocus_calculated_lv3, 
      Q_in_rcv = Q_in_rcv,
      H_rcv_1 = H_rcv_lv1, 
      H_rcv_2 = H_rcv_lv2, 
      H_rcv_3 = H_rcv_lv3, 
      W_rcv_1 = W_rcv_lv1, 
      W_rcv_2 = W_rcv_lv2, 
      W_rcv_3 = W_rcv_lv3, 
      tilt_rcv = tilt_rcv, 
	  angular_range=angular_range,
	  num_aperture=num_aperture,
      W_helio = W_helio, 
      H_helio = H_helio, 
      H_tower = H_tower, 
      R_tower = R_tower, 
      R1 = R1, 
      fb = fb, 
	  helio_refl=helio_refl,
      slope_error = slope_error, 
      slope_error_windy = slope_error_windy, 
      n_row_oelt = n_row_oelt, 
      n_col_oelt = n_col_oelt, 
      n_procs = n_procs, 
      psave = casefolder, 
      wea_file = wea_file,
	  optics_verbose=set_optics_verbose,
	  optics_view_scene=set_optics_view_scene,
	  get_optics_breakdown=get_optics_breakdown,
      set_swaying_optical_eff = set_swaying_optical_eff) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
  
  //********************* Washing calculator
  SolarTherm.Models.CSP.CRS.HeliostatsField.WashingFrequencyCalculator washingFrequencyCalculator(
      C_tw = C1_washing, 
      C_dl = C2_washing, 
      R_soil = R_soil, 
      P_w = P_w, 
      omega_n = omega_n, 
      C_target = C_target) annotation(
    Placement(visible = true, transformation(origin = {-130, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  //********************* Surrogate Receiver
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver_3AperturesCascade particleReceiver(
      H_drop_design = H_rcv_total, 
      use_neural_network = set_use_neural_network, 
      redeclare package Medium = Medium, 
      X_max = X_max_rcv, 
      X_min = X_min_rcv, 
      inputsize = inputsize_rcv, 
      out_max = y_max_rcv, 
      out_min = y_min_rcv, 
      saved_model_dir = saved_model_dir_rcv, 
      T_0 = T_cold_set, 
      T_out = T_hot_set, 
      m_flow_rec_max = m_flow_rec_max) annotation(
    Placement(visible = true, transformation(origin = {-26, 30}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  
  //********************* Receiver Design Condition Sizing Calculator - Using expensive model to find mass flow rate at design point
  SolarTherm.Models.CSP.CRS.Receivers.CascadeParticleReceiver1DCalculator particleReceiver1DCalculator(
      A_ap_lv1 = A_ap_lv1_parsed,
      A_ap_lv2 = A_ap_lv2_parsed,
      A_ap_lv3 = A_ap_lv3_parsed,
      ar_rec_lv1 = ar_rec_lv1_parsed,
      ar_rec_lv2 = ar_rec_lv2_parsed,
      ar_rec_lv3 = ar_rec_lv3_parsed, 
      Q_in_lv1 = Q_in_lv1,
      Q_in_lv2 = Q_in_lv2,
      Q_in_lv3 = Q_in_lv3,
      m_in = m_flow_blk, 
      T_out_target = T_in_ref_blk, 
      T_in = T_in_rec, 
      T_amb_design = T_amb_des_rcv, 
      Wspd = 0, 
      Wdir = 0, 
      h_conv_backwall = h_conv_backwall, 
      h_conv_curtain = h_conv_curtain, 
      phi_max = packing_factor, 
      eps_w = eps_w, 
      th_w = th_w, 
      k_w = k_w, 
      F = F, 
      d_p = d_p, 
      cp_s = cp_s, 
      rho_s = rho_s, 
      eps_s = eps_s, 
      abs_s = abs_s, 
      with_detail_h_ambient = true, 
      with_wind_effect = true, 
      fixed_geometry = true, 
      iterate_Q_flow = false, 
      with_iterate_mdot = false, 
      with_pre_determined_eta = false,
      with_iterate_mdot_outer_loop = true,
      N = discretisations,
      with_catch_and_release_mechanism = false) annotation(
    Placement(visible = true, transformation(origin = {150, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  //********************* Defocus calculator
  SolarTherm.Models.CSP.CRS.Receivers.CascadeParticleReceiver1DCalculator defocuscalculator(
      A_ap_lv1 = A_ap_lv1_parsed,
      A_ap_lv2 = A_ap_lv2_parsed,
      A_ap_lv3 = A_ap_lv3_parsed,
      ar_rec_lv1 = ar_rec_lv1_parsed,
      ar_rec_lv2 = ar_rec_lv2_parsed,
      ar_rec_lv3 = ar_rec_lv3_parsed, 
      m_in = m_flow_blk, 
      T_out_target = T_in_ref_blk, 
      T_in = T_in_rec, 
      T_amb_design = T_amb_des_rcv, 
      Wspd = 0, 
      Wdir = 0, 
      h_conv_backwall = h_conv_backwall, 
      h_conv_curtain = h_conv_curtain, 
      phi_max = packing_factor, 
      eps_w = eps_w, 
      th_w = th_w, 
      k_w = k_w, 
      F = F, 
      d_p = d_p, 
      cp_s = cp_s, 
      rho_s = rho_s, 
      eps_s = eps_s, 
      abs_s = abs_s, 
      with_detail_h_ambient = true, 
      with_wind_effect = true, 
      fixed_geometry = true, 
      iterate_Q_flow = true, 
      with_iterate_mdot = false, 
      with_pre_determined_eta = false,
      with_iterate_mdot_outer_loop = false,
      N = discretisations,
      with_catch_and_release_mechanism = false) annotation(
    Placement(visible = true, transformation(origin = {12, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  //********************* Hot tank
  SolarTherm.Models.Storage.Tank.Tank tankHot(
      redeclare package Medium = Medium, 
      D = D_storage, 
      H = H_storage, 

      dome_storage = set_dome_storage, 
      Th_refractory = Th_refractory_hot_tank, 
      H_tower = H_tower, 
      D_tower = 2 * R_tower, 
      m_tot = m_max, 
      D_outlet = D_outlet, 
      t_storage = t_storage, 
      T_start = T_hot_start, 
      L_start = (1 - split_cold) * 100, 
      use_p_top = set_tnk_use_p_top, 
      enable_losses = set_tnk_enable_losses, 
      use_L = true, 
      W_max = 0, 
      T_set = 0, 
      U_value = U_value_hot_tank, 
      packing_factor = packing_factor) annotation(
    Placement(transformation(extent = {{16, 54}, {36, 74}})));
  
  //********************* Cold tank
  SolarTherm.Models.Storage.Tank.Tank tankCold(
      redeclare package Medium = Medium, 
      D = D_storage, 
      H = H_storage, 
      dome_storage = set_dome_storage, 
      Th_refractory = Th_refractory_cold_tank, 
      H_tower = H_tower, 
      D_tower = 2 * R_tower, 
      m_tot = m_max, 
      D_outlet = D_outlet, 
      T_start = T_cold_start, 
      L_start = split_cold * 100, 
      use_p_top = set_tnk_use_p_top, 
      enable_losses = set_tnk_enable_losses, 
      use_L = true, 
      W_max = 0, 
      T_set = 0, 
      U_value = U_value_cold_tank, 
      packing_factor = packing_factor) annotation(
    Placement(transformation(extent = {{64, -28}, {44, -8}})));
  
  //********************* Tower Inner Diameter Calculator - for integrated storage concept only
  SolarTherm.Utilities.TowerInnerDiameterCalculator_IntegratedG3P3Storage towerInnerDiameterCalculator(
      rho_particle = (rho_cold_set + rho_hot_set)/2,
      H_tower = H_tower,
      m_max = m_max,
      Th_refractory =  if Th_refractory_cold_tank == Th_refractory_hot_tank then 
                            Th_refractory_cold_tank
                       else
                            max(Th_refractory_cold_tank,Th_refractory_hot_tank),
      D_outlet = D_outlet,
      phi = packing_factor
  );
  
  //********************* Receiver lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftRC(redeclare package Medium = Medium, cont_m_flow = true, use_input = true, dh = dh_liftRC, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {-1, -27}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  
  //********************* Heat exchanger lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftHX(redeclare package Medium = Medium, cont_m_flow = true, use_input = true, dh = dh_liftHX, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {76, 42}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  
  //********************* Cold storage tank lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple LiftCold(redeclare package Medium = Medium, cont_m_flow = false, use_input = false, dh = dh_LiftCold, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {106, -34}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  
  //********************* Temperature sensor
  SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-6, 68}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  
  //********************* PowerBlockControl
  SolarTherm.Models.Control.PowerBlockControl_particle controlHot(m_flow_on = m_flow_blk, L_on = hot_tnk_empty_ub, L_off = hot_tnk_empty_lb, L_df_on = hot_tnk_full_ub, L_df_off = hot_tnk_full_lb, logic.dispatch_optimiser = set_dispatch_optimiser) annotation(
    Placement(transformation(extent = {{48, 72}, {60, 58}})));
  
  //********************* Power block
  SolarTherm.Models.PowerBlocks.SurrogatesCO2PB_OTF powerBlock(
      P_gross = P_gross, 
      T_in_ref_blk = T_hot_set, 
      p_high = p_high, 
      PR = PR, 
      pinch_PHX = pinch_exchanger, 
      dTemp_HTF_PHX = dTemp_HTF_PHX, 
      T_amb_base = blk_T_amb_des, 
      htf_choice = htf_choice, 
      dT_PHX_hot_approach = dT_PHX_hot_approach, 
      dT_PHX_cold_approach = dT_PHX_cold_approach, 
      eta_isen_mc = eta_comp_main, 
      eta_isen_rc = eta_comp_re, 
      eta_isen_t = eta_turb, 
      dT_mc_approach = dT_mc_approach, 
      which_PB_model = which_PB_model, 
      load_base = 1, 
      eta_gross_base = eta_gross_base, 
      eta_Q_base = eta_Q_base, 
      Q_HX_des = Q_flow_des, 
      m_HTF_des = m_flow_blk, 
      base_path = base_path, 
      SolarTherm_path = SolarTherm_path, 
      inputsize = inputsize_PB, 
      outputsize = outputsize_PB, 
      tolerance_kriging = tolerance_kriging, 
      tolerance_ANN = tolerance_ANN, 
      which_surrogate = which_surrogate, 
      test_mode = false, 
      eta_motor = 1, 
      f_fixed_load = f_fixed_load, 
      external_parasities = set_external_parasities) annotation(
    Placement(transformation(extent = {{88, 4}, {124, 42}})));
  
  //*********************Power Block Calculator
  SolarTherm.Models.PowerBlocks.sCO2PBCalculator_Using_JPidea sCO2PBDesignPointCalculator(
      redeclare package Medium = Medium, 
      P_net = P_net, 
      T_in_ref_blk = T_in_ref_blk, 
      p_high = p_high, 
      PR = PR, 
      pinch_PHX = pinch_exchanger, 
      dTemp_HTF_PHX = dTemp_HTF_PHX, 
      T_HTF_in = T_in_ref_blk, 
      T_amb_input = blk_T_amb_des, 
      load = 1, 
      f_fixed_load = f_fixed_load, 
      blk_T_amb_des = blk_T_amb_des, 
      T_low = T_low, 
      nu_min_blk = nu_min_blk, 
      N_exch_parameter = N_exch_parameter, 
      N_LTR_parameter = N_LTR_parameter, 
      pri_recuperator = pri_recuperator, 
      pri_turbine = pri_turbine, 
      pri_compressor = pri_compressor, 
      pri_cooler = pri_cooler, 
      pri_generator = pri_generator, 
      pri_exchanger = pri_exchanger, 
      eta_motor = 1, 
      pinch_recuperator = pinch_recuperator, 
      par_fr = par_fr, 
      test_mode = true, 
      external_parasities = set_external_parasities) annotation(
    Placement(visible = true, transformation(origin = {192, 110}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  
  //********************* Price
  SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Table(file = pri_file)) annotation(
    Placement(visible = true, transformation(extent = {{128, 12}, {148, 32}}, rotation = 0)));
  SolarTherm.Models.Sources.Schedule.Scheduler sch if not set_const_dispatch;
  
  //********************* Tim Harvey Extra Cost for the tower structure
  SolarTherm.Utilities.TowerExtraCostTimHarvey structureExtraCost(
    H_tower = H_tower,
    D_inner_tower = R_tower * 2
  );
  
  //********************* Variables
  SI.Power P_elec "Net output power of power block";
  SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
  
  SI.Energy E_resource(start = 0, fixed = true);
  SI.Energy E_resource_after_optical_eff(start = 0, fixed = true);
  SI.Energy E_helio_raw(start = 0, fixed = true);
  SI.Energy E_helio_net(start = 0, fixed = true);
  SI.Energy E_helio_spillage(start = 0, fixed = true);
  SI.Energy E_helio_cosine(start = 0, fixed = true);
  SI.Energy E_recv_incident(start = 0, fixed = true);
  SI.Energy E_recv_net(start = 0, fixed = true);
  SI.Energy E_pb_input(start = 0, fixed = true);
  SI.Energy E_pb_gross(start = 0, fixed = true);
  SI.Energy E_pb_net(start = 0, fixed = true);
 
  SI.Energy E_helio_incident_1(start = 0, fixed = true);
  SI.Energy E_helio_incident_2(start = 0, fixed = true);
  SI.Energy E_helio_incident_3(start = 0, fixed = true);
  
  SI.Energy E_losses_curtailment_1(start = 0, fixed = true);
  SI.Energy E_losses_curtailment_2(start = 0, fixed = true);
  SI.Energy E_losses_curtailment_3(start = 0, fixed = true);
  
  SI.Energy E_losses_availability_1(start = 0, fixed = true);
  SI.Energy E_losses_availability_2(start = 0, fixed = true);
  SI.Energy E_losses_availability_3(start = 0, fixed = true);
  
  SI.Energy E_losses_optical_1(start = 0, fixed = true);
  SI.Energy E_losses_optical_2(start = 0, fixed = true);
  SI.Energy E_losses_optical_3(start = 0, fixed = true);
  
  SI.Energy E_losses_defocus_1(start = 0, fixed = true);
  SI.Energy E_losses_defocus_2(start = 0, fixed = true);
  SI.Energy E_losses_defocus_3(start = 0, fixed = true);
  
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
    
  //*********************Dispatch optimiser variables
  Real SLinit;
  Real counter(start = const_t);
  Real time_simul;
  Real optimalDispatch;
  Real DEmax(start = Q_flow_des / 1e6) "Maximum dispatchable heat from the storage in MWth";
  Real SLmax(start = E_max * 2.77778e-10) "Storage capacity in MWh th";
  Real dummyRatio;
  Real accumulated_m;
  Real TOD_W(start = 0, fixed = true) "Product of Time-of-day factor and instant of electric power";
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y = false) annotation(
    Placement(visible = true, transformation(origin = {-128, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

algorithm
  if time > 31449600 then
    eta_curtail_off := (E_helio_incident_1 + E_helio_incident_2 + E_helio_incident_3) / E_resource;
    eta_optical := E_resource_after_optical_eff / E_resource;
    eta_he_av := he_av_design;
    eta_curtail_defocus := E_helio_net / E_helio_raw;
    eta_recv_abs := E_recv_incident / E_helio_net;
    eta_recv_thermal := E_recv_net / E_recv_incident;
    eta_storage := E_pb_input / E_recv_net;
    eta_pb_gross := E_pb_gross / E_pb_input;
    eta_pb_net := E_pb_net / E_pb_input;
    eta_solartoelec := E_pb_net / E_resource;
  end if;

initial algorithm
	R_rcv_distance:=TowerRadiusCalculator(angular_range, num_aperture, W_rcv);
  
initial equation
   C_extra_structure = structureExtraCost.C_extra_structure_cost;

   W_rcv=max(W_rcv_lv1, W_rcv_lv3);


   if set_external_storage then
      R_tower = max(25/2,R_rcv_distance);
   else
	  if R_rcv_distance>25/2 then
	      R_tower = max(R_rcv_distance,towerInnerDiameterCalculator.D_inner_tower/2+1.83);
	  else
	      R_tower = max(25/2 ,towerInnerDiameterCalculator.D_inner_tower/2+1.83);
      end if;
   end if;
   
   A_ap_lv1 = A_ap_lv1_parsed;
   A_ap_lv2 = A_ap_lv2_parsed;
   A_ap_lv3 = A_ap_lv3_parsed;
   ar_rec_lv1 = ar_rec_lv1_parsed;
   ar_rec_lv2 = ar_rec_lv2_parsed;
   ar_rec_lv3 = ar_rec_lv3_parsed;
   Q_in_lv1 = heliostatsField.Q_in_rcv_1;
   Q_in_lv2 = heliostatsField.Q_in_rcv_2;
   Q_in_lv3 = heliostatsField.Q_in_rcv_3;

  omega_twister = ceil(washingFrequencyCalculator.omega);
  opt_file = heliostatsField.optical.tablefile;
  rec_fr = 1 - particleReceiver1DCalculator.eta_rcv;
  m_flow_fac = particleReceiver1DCalculator.mdot;
  
  Q_flow_defocus_calculated_lv1 = defocuscalculator.Q_rcv_lv1_calculated;
  Q_flow_defocus_calculated_lv2 = defocuscalculator.Q_rcv_lv2_calculated;
  Q_flow_defocus_calculated_lv3 = defocuscalculator.Q_rcv_lv3_calculated;
  
//********************* Retrieve the PB design points result from the PB model intialisation
  if which_PB_model == 0 then
//********************* CEA - Power Block
    eta_gross_base = sCO2PBDesignPointCalculator.eta_gross;
    eta_Q_base = sCO2PBDesignPointCalculator.eta_Q;
    Q_flow_des = sCO2PBDesignPointCalculator.powerBlock.Q_HX_des;
    etaG = sCO2PBDesignPointCalculator.powerBlock.eta_net_design;
    eff_blk = sCO2PBDesignPointCalculator.powerBlock.eta_net_design;
    m_flow_blk = sCO2PBDesignPointCalculator.m_HTF_des;
    UA_HX = sCO2PBDesignPointCalculator.powerBlock.exchanger.UA;
  elseif which_PB_model == 1 then
//********************* NREL Power Block - Initialisation
    NREL_PB_configurations = SolarTherm.Utilities.designNRELPB(P_gross, T_in_ref_blk, p_high, dT_PHX_cold_approach, eta_comp_main, eta_comp_re, eta_turb, dT_mc_approach, blk_T_amb_des, HTF_name, htf_choice, SolarTherm_path, T_cold_set);
//********************* NREL Power Block - Retrieve initialisation result
    Q_flow_des = NREL_PB_configurations[10] "Heat transfer of the PHX at the design point";
    eta_gross_base = NREL_PB_configurations[11] "After cooling power, before other parasities and fixed self-power consumption";
    eta_Q_base = NREL_PB_configurations[12] "";
    etaG = eta_gross_base "after cooling power, motor eff and fixed load parasities";
    eff_blk = etaG;
    m_flow_blk = NREL_PB_configurations[9] "HTF mass flow rate at the design point";
    dT_PHX_hot_approach = NREL_PB_configurations[13];
    UA_HX = NREL_PB_configurations[7];
  else
//********************* Wrong which_PB_model choice
    eta_gross_base = -1;
    eta_Q_base = -1;
    Q_flow_des = -1;
    etaG = -1;
    eff_blk = -1;
    m_flow_blk = -1;
    dT_PHX_hot_approach = -1;
    UA_HX = -1;
  end if;
  
//************************************ Heat Exchanger Area Calculation
  U_HX = 1 / (1 / h_conv_CO2 + 1 / SolarTherm.Utilities.h_particle(SolarTherm.Media.SolidParticles.CarboHSP_utilities.lamda_T(0.5 * (T_cold_set + T_hot_set)), 0.008, 1, 1));
  A_HX = UA_HX / U_HX "Heat exchanger total area";
//************************************ Power Block Component Cost Calculation
  if which_PB_model == 1 then
//************************************ Based on NREL Power Block - Cost function is based on Kevin Albrect, 2019 https://is.gd/3VN0O7
    C_HTR = pri_recuperator * NREL_PB_configurations[1] ^ 0.8933;
    C_LTR = pri_recuperator * NREL_PB_configurations[1] ^ 0.8933;
    C_turbine = pri_turbine * (NREL_PB_configurations[3] / 10 ^ 3) ^ 0.5886;
    C_mainCompressor = pri_compressor * (NREL_PB_configurations[4] / 10 ^ 3) ^ 0.9142;
    C_reCompressor = pri_compressor * (NREL_PB_configurations[4] / 10 ^ 3) ^ 0.9142;
    C_cooler = pri_cooler * NREL_PB_configurations[6];
    C_exchanger = (pri_PHX_per_area) * A_HX + pri_PHX_BOP_s * m_flow_blk + pri_PHX_BOP_CO2 * NREL_PB_configurations[8];
    C_generator = pri_generator * (P_gross / 10 ^ 6) ^ 0.5463;
  elseif which_PB_model == 0 then
//************************************ Based on NREL Power Blockbased on CEA Power Block*/
    C_HTR = sCO2PBDesignPointCalculator.powerBlock.C_HTR;
    C_LTR = sCO2PBDesignPointCalculator.powerBlock.C_LTR;
    C_turbine = sCO2PBDesignPointCalculator.powerBlock.C_turbine;
    C_mainCompressor = sCO2PBDesignPointCalculator.powerBlock.C_mainCompressor;
    C_reCompressor = sCO2PBDesignPointCalculator.powerBlock.C_reCompressor;
    C_cooler = sCO2PBDesignPointCalculator.powerBlock.C_cooler;
    C_exchanger = sCO2PBDesignPointCalculator.powerBlock.C_exchanger;
    C_generator = sCO2PBDesignPointCalculator.powerBlock.C_generator;
  else
    C_HTR = -1;
    C_LTR = -1;
    C_turbine = -1;
    C_mainCompressor = -1;
    C_reCompressor = -1;
    C_cooler = -1;
    C_exchanger = -1;
    C_generator = -1;
  end if;
  
//********************* Power Block Cost Calculation
  if which_PB_model == 0 then
    if set_simple_PB_cost then
      C_block = pri_block * P_gross / 1000 + C_exchanger;
    else
      C_block = sCO2PBDesignPointCalculator.powerBlock.C_PB;
    end if;
  elseif which_PB_model == 1 then
    if set_simple_PB_cost then
      C_block = pri_block * P_gross / 1000 + C_exchanger;
    else
      C_block = C_HTR + C_LTR + C_turbine + C_mainCompressor + C_reCompressor + C_cooler + C_exchanger + C_generator;
    end if;
  else
    C_block = -1;
  end if;
  
//************************************ Capital Cost Calculation
  C_cap_total = C_field + C_site + C_receiver + C_storage + C_block + C_bop "Total equipment cost";
  C_direct = (1 + r_contg) * C_cap_total;
  C_indirect = r_cons * C_direct + C_land;
  C_cap = C_direct + C_indirect;

equation
//************************************ Equations below exist to close the model
  particleReceiver.raw_input[1] = A_ap_lv1;
  particleReceiver.raw_input[2] = A_ap_lv2;
  particleReceiver.raw_input[3] = A_ap_lv3;
  particleReceiver.raw_input[4] = ar_rec_lv1;
  particleReceiver.raw_input[5] = ar_rec_lv2;
  particleReceiver.raw_input[6] = ar_rec_lv3;
  particleReceiver.raw_input[7] = particleReceiver.Q_in_1;
  particleReceiver.raw_input[8] = particleReceiver.Q_in_2;
  particleReceiver.raw_input[9] = particleReceiver.Q_in_3;
  particleReceiver.raw_input[10] = particleReceiver.Tamb;
  particleReceiver.raw_input[11] = particleReceiver.T_in;
  particleReceiver.raw_input[12] = T_hot_set;
  particleReceiver.raw_input[13] = 1 + 
                                         0.13929 * 
                                              (particleReceiver.Wspd * (Modelica.Math.log(H_tower/1e-3))/(Modelica.Math.log(2/1e-3))) 
                                                  * Modelica.Math.exp(-1*((abs(Modelica.SIunits.Conversions.to_deg(data.Wdir)-180)-105)/30)^2);
  particleReceiver.ratio_1 = heliostatsField.ratio_1 "Equation to close the model";
  particleReceiver.ratio_2 = heliostatsField.ratio_2 "Equation to close the model";
  particleReceiver.ratio_3 = heliostatsField.ratio_3 "Equation to close the model";
  
  //*********************** Connect these connections with graphical interface yeah?
  connect(heliostatsField.on_1, particleReceiver.on_1);
  connect(heliostatsField.on_2, particleReceiver.on_2);
  connect(heliostatsField.on_3, particleReceiver.on_3);

//************************************ Assigning the input to the surrogate model*/
  powerBlock.raw_input[1] = powerBlock.load;
  powerBlock.raw_input[2] = tankHot.medium.T;
  powerBlock.raw_input[3] = data.Tdry;
  der(accumulated_m) = particleReceiver.fluid_a.m_flow;

//************************************ Dispatch optimiser variables
  SLinit = tankHot.L / 100 * m_max * (Utils.h_T(tankHot.medium.T) - Utils.h_T(tankCold.medium.T)) * 2.7778e-10 "Thermal energy left in the hot tank [MWh_th]";
  DEmax = m_flow_blk * (Utils.h_T(tankHot.medium.T) - Utils.h_T(tankCold.medium.T)) * 1e-6 "Maximum dispatchable heat [MWth]";
  SLmax = m_max * (Utils.h_T(tankHot.medium.T) - Utils.h_T(tankCold.medium.T)) * 2.7778e-10 "Maximum storage level in MWhth";
  if set_dispatch_optimiser == true then
    der(counter) = 1;
  else
    der(counter) = 0;
  end if;
  
  when counter > 0 then
    time_simul = floor(time) "Rounding down the time";
    if set_dispatch_optimiser then
      optimalDispatch = SolarTherm.Utilities.LinProgFunc(
          DNI_file, 
          price_file, 
          horizon, 
          dt, 
          time_simul, 
          etaC * (1 - rec_fr), 
          etaG, 
          t_storage, 
          DEmax, 
          SLmax, 
          SLinit, 
          SLminrel, 
          A_field);
    else
      optimalDispatch = DEmax;
    end if;
    reinit(counter, const_t);
  end when;

  //************* Equation here is to close the power block controller models  since the component is lack of 1 equation to close optimalMassFlow variable
  controlHot.logic.optimalMassFlow = if set_dispatch_optimiser == true then min(optimalDispatch / DEmax * m_flow_blk, m_flow_blk) else 0;
  dummyRatio = optimalDispatch / DEmax;
  
  der(E_resource) = max(sun.dni * n_helios_total * A_helio, 0.0) "Raw sun energy that comes to the heliostat field [J]";
  
  der(E_losses_defocus_1) = 
        if heliostatsField.on_internal_1 then 
            if heliostatsField.defocus_internal then 
                  abs(heliostatsField.Q_net_1 - heliostatsField.Q_raw_1) 
            else 0 
        else 
            0;
  der(E_losses_defocus_2) = 
        if heliostatsField.on_internal_2 then 
            if heliostatsField.defocus_internal then 
                  abs(heliostatsField.Q_net_2 - heliostatsField.Q_raw_2) 
            else 0 
        else 
            0;
  
  der(E_losses_defocus_3) = 
        if heliostatsField.on_internal_3 then 
            if heliostatsField.defocus_internal then 
                  abs(heliostatsField.Q_net_3 - heliostatsField.Q_raw_3) 
            else 0 
        else 
            0;
  
  der(E_losses_availability_1) = (1 - he_av_design) * 
                                      max(heliostatsField.nu_1 * heliostatsField.solar.dni * heliostatsField.n_h_1 *
                                      heliostatsField.A_h, 0.0);
  der(E_losses_availability_2) = (1 - he_av_design) * 
                                      max(heliostatsField.nu_2 * heliostatsField.solar.dni * heliostatsField.n_h_2 *
                                      heliostatsField.A_h, 0.0);
  der(E_losses_availability_3) = (1 - he_av_design) * 
                                      max(heliostatsField.nu_3 * heliostatsField.solar.dni * heliostatsField.n_h_3 *
                                      heliostatsField.A_h, 0.0);
  
  der(E_losses_curtailment_1) = if heliostatsField.on_hf_1 == true then 0 else (1 - he_av_design) * max(heliostatsField.nu_1 * heliostatsField.solar.dni * heliostatsField.n_h_1 * heliostatsField.A_h, 0.0);
  
  der(E_losses_curtailment_2) = if heliostatsField.on_hf_2 == true then 0 else (1 - he_av_design) * max(heliostatsField.nu_2 * heliostatsField.solar.dni * heliostatsField.n_h_2 * heliostatsField.A_h, 0.0);
  
  der(E_losses_curtailment_3) = if heliostatsField.on_hf_3 == true then 0 else (1 - he_av_design) * max(heliostatsField.nu_3 * heliostatsField.solar.dni * heliostatsField.n_h_3 * heliostatsField.A_h, 0.0);
                                      
  
  der(E_losses_optical_1) = if heliostatsField.on_internal_1 then 
                                (1 - heliostatsField.nu_1) * 
                                max(heliostatsField.solar.dni * heliostatsField.n_h_1 * heliostatsField.A_h, 0.0)
                            else
                                0;
                                
  der(E_losses_optical_2) = if heliostatsField.on_internal_2 then 
                                (1 - heliostatsField.nu_2) * 
                                max(heliostatsField.solar.dni * heliostatsField.n_h_2 * heliostatsField.A_h, 0.0)
                            else
                                0;
                                
  der(E_losses_optical_3) = if heliostatsField.on_internal_3 then
                                (1 - heliostatsField.nu_3) * 
                                max(heliostatsField.solar.dni * heliostatsField.n_h_3 * heliostatsField.A_h, 0.0)
                            else
                                0;
              
  der(E_resource_after_optical_eff) = 
                      max(sun.dni * heliostatsField.n_h_1 * A_helio, 0.0) * heliostatsField.nu_1 +
                      max(sun.dni * heliostatsField.n_h_2 * A_helio, 0.0) * heliostatsField.nu_2 +
                      max(sun.dni * heliostatsField.n_h_3 * A_helio, 0.0) * heliostatsField.nu_3;
                      
  der(E_helio_incident_1) = if heliostatsField.on_hf_1 then 
                                heliostatsField.n_h_1 * heliostatsField.A_h * max(0.0, heliostatsField.solar.dni) 
                            else 
                                0.0;
  der(E_helio_incident_2) = if heliostatsField.on_hf_2 then 
                                heliostatsField.n_h_2 * heliostatsField.A_h * max(0.0, heliostatsField.solar.dni) 
                            else 
                                0.0;
  der(E_helio_incident_3) = if heliostatsField.on_hf_3 then 
                                heliostatsField.n_h_3 * heliostatsField.A_h * max(0.0, heliostatsField.solar.dni) 
                            else 
                                0.0;

                                  
  der(E_helio_raw) = heliostatsField.Q_raw_1  + heliostatsField.Q_raw_2 + heliostatsField.Q_raw_3;
  der(E_helio_net) = heliostatsField.Q_net_1 + heliostatsField.Q_net_2 + heliostatsField.Q_net_3;
  der(E_helio_spillage)= heliostatsField.Q_spil;
  der(E_helio_cosine)= heliostatsField.Q_cosine;
  
  der(E_recv_incident) = particleReceiver.heat.Q_flow;
  der(E_recv_net) = particleReceiver.Q_rcv;
  der(E_pb_input) = powerBlock.Q_HX;
  der(E_pb_gross) = -powerBlock.W_gross;
  der(E_pb_net) = powerBlock.W_net;
  
  P_elec = powerBlock.W_net;
  der(E_elec) = P_elec;
  R_spot = market.profit;
  der(TOD_W) = market.price.price * powerBlock.W_net;

//************************************ Connections from data
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-113, 70}, {-102, 70}, {-102, 69.8}, {-82.6, 69.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-112.7, 30}, {-100, 30}, {-100, 29.54}, {-87.68, 29.54}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Pres_input.y, tankCold.p_top) annotation(
    Line(points = {{55, 28}, {49.5, 28}, {49.5, 20}, {49.5, -8.3}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Pres_input.y, tankHot.p_top) annotation(
    Line(points = {{55, 28}, {46, 28}, {8, 28}, {8, 78}, {30.5, 78}, {30.5, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, powerBlock.T_amb) annotation(
    Line(points = {{118, 80}, {102.4, 80}, {102.4, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Tamb_input.y, tankHot.T_amb) annotation(
    Line(points = {{118, 80}, {21.9, 80}, {21.9, 73.7}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(tankCold.T_amb, Tamb_input.y) annotation(
    Line(points = {{58.1, -8.3}, {58.1, 20}, {92, 20}, {92, 42}, {118, 42}, {118, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

//************************************ Fluid connections
  connect(liftRC.fluid_a, tankCold.fluid_b) annotation(
    Line(points = {{5, -25}, {44, -25}}, color = {0, 127, 255}));
  connect(temperature.fluid_b, tankHot.fluid_a) annotation(
    Line(points = {{4, 68}, {9, 68}, {9, 69}, {16, 69}}, color = {0, 127, 255}));
  connect(tankHot.fluid_b, liftHX.fluid_a) annotation(
    Line(points = {{36, 57}, {36, 52}, {36, 44}, {48, 44}, {48, 43.88}, {66, 43.88}}, color = {0, 127, 255}));
  connect(liftHX.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{78, 44}, {86, 44}, {86, 29.46}, {98.08, 29.46}}, color = {0, 127, 255}));
  connect(powerBlock.fluid_b, LiftCold.fluid_a) annotation(
    Line(points = {{95.56, 14.64}, {78, 14.64}, {78, -32}, {101, -32}}, color = {0, 127, 255}));
  connect(LiftCold.fluid_b, tankCold.fluid_a) annotation(
    Line(points = {{112, -32}, {112, -13}, {64, -13}}, color = {0, 127, 255}));

//************************************ controlHot connections
  connect(tankHot.L, controlHot.L_mea) annotation(
    Line(points = {{36.2, 68.4}, {40, 68.4}, {40, 68.5}, {47.52, 68.5}}, color = {0, 0, 127}));
  connect(controlHot.m_flow, liftHX.m_flow) annotation(
    Line(points = {{60.72, 65}, {72, 65}, {72, 49.16}}, color = {0, 0, 127}));
  connect(controlHot.defocus, or1.u1) annotation(
    Line(points = {{54, 72.98}, {54, 72.98}, {54, 86}, {-106, 86}, {-106, 8}, {-102.8, 8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));

//************************************ Solar field connections i.e. solar.heat port and control
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-72, 60}, {-72, 36}}, color = {255, 128, 0}));
  connect(or1.y, heliostatsField.defocus) annotation(
    Line(points = {{-93.6, 8}, {-92, 8}, {-92, 8.8}, {-87.68, 8.8}}, color = {255, 0, 255}, pattern = LinePattern.Dash));

//************************************ PowerBlock connections
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{143, 44}, {143, 40.85}, {109.6, 40.85}, {109.6, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(powerBlock.W_net, market.W_net) annotation(
    Line(points = {{115.18, 22.05}, {119.59, 22.05}, {119.59, 22}, {128, 22}}, color = {0, 0, 127}));
  connect(always_on.y, heliostatsField.on_hopper) annotation(
    Line(points = {{-116, -4}, {-112, -4}, {-112, 20}, {-88, 20}, {-88, 20}}, color = {255, 0, 255}));
  connect(controlHot.rampingout, powerBlock.ramping) annotation(
    Line(points = {{60, 68}, {106, 68}, {106, 34}, {106, 34}}, color = {255, 0, 255}));
  connect(heliostatsField.heat, particleReceiver.heat) annotation(
    Line(points = {{-56, 28}, {-42, 28}, {-42, 34}, {-42, 34}}, color = {191, 0, 0}));
  connect(liftRC.fluid_b, particleReceiver.fluid_a) annotation(
    Line(points = {{-8, -26}, {-22, -26}, {-22, 16}, {-22, 16}}, color = {0, 127, 255}));
  connect(particleReceiver.m_flow_out, controlHot.m_flow_in) annotation(
    Line(points = {{-22, 28}, {46, 28}, {46, 62}, {48, 62}}, color = {0, 0, 127}));
  connect(particleReceiver.fluid_b, temperature.fluid_a) annotation(
    Line(points = {{-20, 38}, {-16, 38}, {-16, 68}, {-16, 68}}, color = {0, 127, 255}));
  connect(Wind_dir.y, particleReceiver.Wdir) annotation(
    Line(points = {{-116, 52}, {-30, 52}, {-30, 42}, {-30, 42}}, color = {0, 0, 127}));
  connect(Tamb_input.y, particleReceiver.Tamb) annotation(
    Line(points = {{118, 80}, {-22, 80}, {-22, 42}, {-22, 42}}, color = {0, 0, 127}));
  connect(booleanExpression.y, or1.u2) annotation(
    Line(points = {{-116, -22}, {-106, -22}, {-106, 4}, {-102, 4}, {-102, 4}}, color = {255, 0, 255}));
  connect(tankCold.L, particleReceiver.level) annotation(
    Line(points = {{44, -14}, {24, -14}, {24, 24}, {-20, 24}, {-20, 24}}, color = {0, 0, 127}));

//************************************ End of The System Model ********************************************\\
  connect(Wspd_input.y, wspdScaler.WspdGround) annotation(
    Line(points = {{-112, 30}, {-98, 30}, {-98, 50}, {-59, 50}, {-59, 45}}, color = {0, 0, 127}));
  connect(wspdScaler.WspdOut, particleReceiver.Wspd) annotation(
    Line(points = {{-43, 45}, {-26, 45}, {-26, 42}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 9), Text(origin = {-8, -20}, lineColor = {217, 67, 180}, extent = {{-58, -18}, {-14, -40}}, textString = "on/off strategy", fontSize = 9), Text(origin = {12, 24}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, -8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-4, 2}, extent = {{0, 58}, {48, 38}}, textString = "Hot Tank", fontSize = 6, fontName = "CMU Serif"), Text(extent = {{30, -24}, {78, -44}}, textString = "Cold Tank", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, -2}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"), Text(origin = {6, 0}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"), Text(origin = {20, 4}, extent = {{-6, 20}, {42, 0}}, textString = "Receiver Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {2, 32}, extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-6, -26}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif"), Text(origin = {0, -40}, extent = {{-10, 8}, {10, -8}}, textString = "Lift Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {80, -8}, extent = {{-14, 8}, {14, -8}}, textString = "LiftCold", fontSize = 6, fontName = "CMU Serif"), Text(origin = {85, 59}, extent = {{-19, 11}, {19, -11}}, textString = "LiftHX", fontSize = 6, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 1e-06, Interval = 3600),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released first version. </li>
	<li> Philipe Gunawan Gan (Dec 2020) :<br>Released Particle System with ANN based Particle Receiver (based on Sandia model) and On The Fly ANN Power Block model based on System Advisor Model power block. </li>
	</ul>

	</html>"),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end PhysicalParticleCO21D_1stApproach_SurrogateReceiverCascade_OnTheFlySurrogate;
