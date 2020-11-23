within examples;

model PhysicalParticleCO21D_1stApproach_SurrogateReceiverMultiAperture_SurrogatePB_SingleOutput
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
  import metadata = SolarTherm.Utilities.Metadata_Optics_3Apertures;
  extends SolarTherm.Media.CO2.PropCO2;
  extends Modelica.Icons.Example;
  parameter Boolean pri_field_wspd_max = true "using wspd_max dependent cost";
  parameter Boolean match_sam_cost = true "tower cost is evaluated to match SAM";
  parameter Boolean detail_field_om = false "true if want to use detail washing and field O&M cost";
  parameter Boolean const_dispatch = true "Constant dispatch of energy";
  parameter Boolean feedforward = true;
  parameter Boolean dispatch_optimiser = false;
  parameter Boolean new_storage_calc = false;
  parameter Boolean use_neural_network = true;
  // *********************
  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
  replaceable package MedPB = SolarTherm.Media.CarbonDioxide_ph "Medium props for sCO2";
  parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014_hourly_manipulated.motab") "Electricity price file";
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not const_dispatch "Discharging schedule from a file";
  // Weather data
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab");
  parameter Real wdelay[8] = {1800, 1800, 0, 0, 0, 0, 0, 0} "Weather file delays";
  parameter nSI.Angle_deg lon = -116.800 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = 34.850 "Lati1tude (+ve North)";
  parameter nSI.Time_hour t_zone = -8 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  // Field, heliostat and tower
  parameter String opt_file(fixed = false);
  parameter String casefolder = ".";
  parameter Real metadata_list[18] = metadata(opt_file);
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
  parameter String field_type = "polar" "Other options are : surround";
  parameter Real land_mult = 0 "Land area multiplier : will be calculated from Solstice";
  parameter SI.Area A_helio = 144.375 "Emes et al. ,Effect of heliostat design wind speed on the levelised cost ofelectricity from concentrating solar thermal power tower plants,Solar Energy 115 (2015) 441–451 ==> taken from the locus of minimum heliostat cost Fig 8.";
  parameter Real AR_helio = 1 "H_helio/W_helio";
  parameter SI.Length W_helio = sqrt(A_helio / AR_helio) "width of heliostat in m";
  parameter SI.Length H_helio = AR_helio * W_helio "height of heliostat in m";
  parameter SI.Efficiency rho_helio = 0.95 "reflectivity of heliostat max =1, min 0.94";
  parameter SI.Angle slope_error = 1.53e-3 "slope error of the heliostat in rad";
  parameter SI.Length H_tower = 200 "Tower height";
  parameter SI.Length R_tower = (W_rcv_1 + W_rcv_2 + W_rcv_3) / 2 "Tower radius";
  parameter SI.Length R1 = 80 "distance between the first row heliostat and the tower";
  parameter Real fb = 0.6 "factor to grow the field layout";
  parameter Boolean single_field = true "True for single field, false for multi tower";
  parameter Boolean concrete_tower = true "True for concrete, false for thrust tower";
  parameter Real he_av_design = 0.99 "Helisotats availability";
  parameter Real gnd_cvge = 0.3126 "Ground coverage";
  parameter Real excl_fac = 0.97 "Exclusion factor";
  parameter Boolean match_gen3_report_cost = false "PB, receiver+tower cost sub system are evaluated using gen3_cost";
  parameter SI.ThermalInsulance U_value_hot_tank = 0.25 "Desired U_value for the tanks";
  parameter SI.ThermalInsulance U_value_cold_tank = 0.25 "Desired U value for the tanks";
  //Design Condition
  parameter String rcv_type = "particle" "other options are : flat, cylindrical, stl";
  parameter SI.Area A_rcv_1(fixed = false) "Receiver 1 aperture area";
  parameter SI.Area A_rcv_2(fixed = false) "Receiver 2 aperture area";
  parameter SI.Area A_rcv_3(fixed = false) "Receiver 3 aperture area";
  parameter nSI.Angle_deg tilt_rcv = 0 "tilt of receiver in degree relative to tower axis";
  parameter Real SM = 2.5 "Solar multiple";
  parameter SI.Efficiency eff_blk(fixed = false) "Power block efficiency at design point";
  parameter SI.Temperature T_in_rec = T_cold_set "Particle inlet temperature to particle receiver at design";
  parameter SI.Irradiance dni_des = 950 "DNI at design poinop Equinox";
  parameter SI.Efficiency eta_rcv_assumption = 0.88;
  parameter Real CR = 1200 "Concentration ratio";
  parameter Real n_helios_1 = metadata_list[10] "Number of heliostats";
  parameter Real n_helios_2 = metadata_list[11] "Number of heliostats";
  parameter Real n_helios_3 = metadata_list[12] "Number of heliostats";
  parameter SI.Temperature T_amb_des_rcv = from_degC(10) "Design point ambient temp";
  parameter Real alpha_rcv = 1;
  parameter SI.HeatFlowRate Q_in_rcv_total = P_gross / eff_blk / eta_rcv_assumption * SM;
  parameter Real fraction_Q_1 = 0.5 "Heat allocation for aperture 1";
  parameter Real fraction_Q_2 = (1 - fraction_Q_1) / 2 "Heat allocation for aperture 2";
  parameter Real fraction_Q_3 = (1 - fraction_Q_1) / 2 "Heat allocation for aperture 3";
  parameter SI.HeatFlowRate Q_in_rcv_1 = Q_in_rcv_total * fraction_Q_1;
  parameter SI.HeatFlowRate Q_in_rcv_2 = Q_in_rcv_total * fraction_Q_2;
  parameter SI.HeatFlowRate Q_in_rcv_3 = Q_in_rcv_total * fraction_Q_3;
  parameter SI.Area A_field = A_helio * (n_helios_1 + n_helios_2 + n_helios_3) "Heliostat field reflective area";
  parameter Real A_land = metadata_list[3];
  parameter SI.Velocity Wspd_max = 15.65 if use_wind "Wind stow speed DOE suggestionn";
  parameter SI.HeatFlowRate Q_flow_defocus_calculated1(fixed = false);
  parameter SI.HeatFlowRate Q_flow_defocus_calculated2(fixed = false);
  parameter SI.HeatFlowRate Q_flow_defocus_calculated3(fixed = false);
  parameter SI.Efficiency packing_factor = 0.6 "New High-Density Packings of Similarly Sized Binary SpheresPatrick I. O’Toole and Toby S. Hudson*  https://pubs.acs.org/doi/pdf/10.1021/jp206115p";
  //Optical simulation parameters
  parameter Integer n_rays = 10000 "number of rays for solstice";
  parameter Integer n_procs = 1 "number of processors in soltice";
  //Output of the optical simulation
  parameter Real n_row_oelt = 5 "number of rows of the look up table (simulated days in a year)";
  parameter Real n_col_oelt = 22 "number of columns of the lookup table (simulated hours per day)";
  // Receiver
  parameter Real ar_rec = 1 "Height to diameter aspect ratio of receiver aperture";
  parameter Real em_particle = 0.86 "Emissivity of particles";
  parameter Real ab_particle = 0.9 "Absorptivity of curtain";
  parameter Real rec_fr(fixed = false) "CHANGED PG Receiver loss fraction of radiance at design point";
  inner parameter SI.Efficiency eta_rec_th_des = 1 - rec_fr "Receiver thermal efficiency (Q_pcl / Q_sol)";
  parameter Real f_loss = 0.000001 "Fraction of particles flow lost in receiver";
  parameter SI.Length th_w = 0.05 "Backwall thickness of the receiver";
  parameter SI.ThermalConductance k_w = 0.2 "Thermal conductance of the back wall of the receiver";
  parameter SI.CoefficientOfHeatTransfer h_conv_curtain = 32. "Convective heat transfer coefficient (curtain) [W/m^2-K]";
  parameter SI.CoefficientOfHeatTransfer h_conv_backwall = 10. "Convective heat transfer coefficient (backwall) [W/m^2-K]";
  parameter SI.Length d_p = 0.00035 "Particle diameter [m]";
  parameter SI.SpecificHeatCapacity cp_s = 1200 "particle specific heat capacity [J/kgK]";
  parameter SI.Density rho_s = 3300 "Particle density [kg/m3]";
  parameter Real eps_s = 0.9 "Particle emmisivity";
  parameter Real abs_s = 0.9 "Particle absorptivity";
  parameter Real F = 0.54 "View Factor of the particle curtain";
  parameter Real eps_w = 0.8 "Receiver wall emmisivity";
  //****************************** NN Based Receiver Parameter
  parameter Integer inputsize_rcv = 7;
  parameter Real[inputsize_rcv] X_max_rcv = {4.49992754e+01, 4.60614216e+09, 9.73141498e+02, 1.47312835e+03, 3.23148941e+02, 3.99993851e+01, 3.59998406e+02};
  parameter Real[inputsize_rcv] X_min_rcv = {5.00113178e+00, 1.59570610e+07, 7.73150760e+02, 1.02315541e+03, 2.53150059e+02, 1.61563590e-03, 1.17909395e-02};
  parameter Real y_max_rcv = 0.99893263;
  parameter Real y_min_rcv = 0.01285256;
  parameter String saved_model_dir_rcv = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include/neural-network/trained-model/ParticleReceiver/surrogate_model_7");
  //****************************** OnTheFlySurrogate Parameters
  /************************************************************************************************************************* /
                                    /       NREL PB and CEA are sizing the power block based on cycle power. In this code it is called P_gross   /
                                    /      -cycle power: W_turb_des - W_comp_des - W_recomp_des                                                  / 
                                    /      -net power : (cycle_power - W_cooling_fan) * eta_motor * (1-f_fixed_load)                             /
                                    /      All power above are before parasities_input => heliostat field, pump/lift power consumption           /
                                    /      The output of the on the fly surrogates are: eta_gross and eta Q                                      /
                                    /      eta_gross: (W_cycle-W_cooling) / Q_HX                                                                 /
                                    /      eta_Q: (Q_HX / Q_HX_des)                                                                              /
                                   /      The power block initalisation will produce Q_HX_des, regardless which PB model is used                /   
                      ***************************************************************************************************************************/
  //******************************** Simulation configurations
  parameter String base_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include") "Base path that points to which folder the C program located";
  parameter String SolarTherm_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm") "Base path that points to which folder SolarTherm libs are located";
  parameter Integer inputsize_PB = 3;
  parameter Integer outputsize_PB = 2;
  parameter Real tolerance_kriging = 6e-3 "Mean Absolute Error";
  parameter Real tolerance_ANN = 6e-3 "Mean Absolute Error";
  parameter Integer which_surrogate = 1 "1 for Kriging, 2 for ANN";
  parameter Real eta_gross_base(fixed = false) "By product of PB initialisation, regardless which PB model is chosen e.g CEA or SAM";
  parameter Real eta_Q_base(fixed = false) "By product of PB initialisation, regardless which PB model is chosen e.g CEA or SAM";
  //******************************** General PB Parameters
  parameter SI.ThermodynamicTemperature T_low = 41 + 273.15 "Inlet temperature of the compressor";
  parameter Integer N_HTR = 15 "Discretisation of high temperature recuperator";
  parameter Integer N_LTR_parameter = 15 "Discretisation of low temperature recuperator";
  parameter Real f_fixed_load = 0.0055 "Fixed load constantly consumed by PB when it operates";
  parameter SI.ThermodynamicTemperature T_high = 700 + 273.15 "inlet temperature of the turbine";
  parameter Real gamma = 0.28 "Part of the mass flow going to the recompression directly";
  parameter Real par_fr = 0.1 "Parasitics fraction of power block rating at design point";
  //******************************** CEA PB Parameters
  parameter SI.Power P_net = 100e6 "Power block net rating at design point";
  parameter SI.Power P_gross = P_net / (1 - par_fr) "Power block gross rating at design point";
  parameter SI.Temperature T_in_ref_blk = T_hot_set "Particle inlet temperature to particle heat exchanger at design";
  parameter SI.AbsolutePressure p_high = 25e6 "high pressure of the cycle in Pa";
  parameter Real PR = 2.78 "Pressure ratio";
  parameter SI.TemperatureDifference pinch_exchanger = 25;
  parameter SI.TemperatureDifference dTemp_HTF_PHX = T_hot_set - T_cold_set;
  parameter SI.Temperature blk_T_amb_des = T_low - dT_mc_approach "Ambient temperature at design for power block";
  //******************************** NREL SAM PB Parameters - some parameters are defined in the CEA's section
  parameter Integer htf_choice = 50 "--------------------> 50 is user defined fluid properties";
  parameter SI.TemperatureDifference dT_PHX_hot_approach(fixed = false) "--------------------> [C/K] Temp. difference between hot HTF and TIT. 
                                                                                                   Product of iteration s.t. the T_HTF_cold_design == T_cold_set";
  parameter SI.TemperatureDifference dT_PHX_cold_approach = 15 "---> [C/K] Temp. difference between cold HTF and cold CO2 PHX inlet";
  parameter SI.Efficiency eta_comp_main = 0.89 "----------------> main compressor isentropic efficiency";
  parameter SI.Efficiency eta_comp_re = 0.89 "----------------> re-compressor isentropic efficiency";
  parameter SI.Efficiency eta_turb = if P_gross > 3e7 then 0.93 else 0.85 "-----------------> turbine isentropic efficiency";
  parameter SI.TemperatureDifference dT_mc_approach = 6.0 "--------------------> [C/K] Temp. difference between main compressor CO2 inlet and ambient";
  parameter Integer which_PB_model = 1 "-----------------------> 0 is for CEA power block, 1 is for NREL-SAM power block";
  parameter String HTF_name = "CarboHSP";
  parameter Real NREL_PB_configurations[13](each fixed = false) if which_PB_model == 1 "array to store design point sizing result";
  //****************************** Storage
  parameter Real t_storage(unit = "h") = 0.5 "Hours of storage";
  parameter Real NS_particle = 0.05 "Fraction of additional non-storage particles";
  parameter SI.Temperature T_cold_set = 550 + 273.15 "Cold tank target temperature ==  HTF outlet temperature from PB at design point";
  parameter SI.Temperature T_hot_set = 1073.15 "Hot tank target temperature == HTF inlet temperature to the PB at design point";
  parameter SI.Temperature T_cold_start = T_cold_set "Cold tank starting temperature";
  parameter SI.Temperature T_hot_start = T_hot_set "Hot tank starting temperature";
  parameter SI.Temperature T_cold_aux_set = CV.from_degC(500) "Cold tank auxiliary heater set-point temperature";
  parameter SI.Temperature T_hot_aux_set = CV.from_degC(700) "Hot tank auxiliary heater set-point temperature";
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold partilces thermodynamic state at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hot partilces thermodynamic state at design";
  parameter Real split_cold = (100 - hot_tnk_empty_ub + 1) / 100 "Starting medium fraction in cold tank, must be the function of the upper bound trigger level of the hot tank so the simulation wont crash at t=0, since the control logic use t_on - t_start etc";
  parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
  parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
  parameter SI.CoefficientOfHeatTransfer alpha = 3 "Tank constant heat transfer coefficient with ambient";
  parameter SI.Power W_heater_hot = 0 "Hot tank heater capacity";
  parameter SI.Power W_heater_cold = 0 "Cold tank heater capacity";
  parameter Real tank_ar = 2 "storage aspect ratio";
  //****************************** Power Block Technical Parameters - CEA Power Block
  /*Heat Exchanger Parameters*/
  parameter Real pinch_recuperator = 15;
  parameter SI.Temperature T_out_ref_blk = T_cold_set "Particle outlet temperature from particle heat exchanger at design";
  parameter SI.Temperature T_in_ref_co2 = T_cold_set - pinch_exchanger "CO2 inlet temperature to particle heat exchanger at design";
  parameter SI.Temperature T_out_ref_co2 = T_high "CO2 outlet temperature from particle heat exchanger at design";
  parameter Integer N_exch_parameter = 15 "PG";
  parameter Real par_fix_fr = 0 "Fixed parasitics as fraction of gross rating";
  parameter Boolean blk_enable_losses = true "True if the power heat loss calculation is enabled";
  parameter Boolean external_parasities = true "True if there is external parasitic power losses";
  parameter Real nu_min_blk = 0.5 "Minimum allowed part-load mass flow fraction to power block";
  parameter Medium.ThermodynamicState state_co2_in_set = MedPB.setState_pTX(p_high, T_in_ref_co2) "Cold CO2 thermodynamic state at design";
  parameter Medium.ThermodynamicState state_co2_out_set = MedPB.setState_pTX(p_high, T_out_ref_co2) "Hot CO2 thermodynamic state at design";
  //****************************** Particle Lift Parameters
  parameter SI.Height dh_liftRC = H_tower "Vertical displacement in receiver lift";
  parameter SI.Height dh_liftHX = 10 "Vertical displacement in heat exchanger lift";
  parameter SI.Height dh_LiftCold = H_storage "Vertical displacement in cold storage lift";
  parameter SI.Efficiency eff_lift = 0.8 "Lift total efficiency";
  //****************************** Power Plant Control
  parameter SI.Time t_start = 3600 "Start-up traking delay";
  parameter SI.Angle ele_min = 0.0872665 "Heliostat stow deploy angle = 5 degree";
  parameter Boolean use_wind = true "True if using wind stopping strategy in the solar field";
  parameter SI.HeatFlowRate Q_flow_defocus = if feedforward == true then 280e6 else Q_flow_des / (1 - rec_fr) "Solar field thermal power at defocused state";
  parameter Real nu_start = 0.3 "Minimum energy start-up fraction to start the receiver";
  parameter Real nu_min_sf = 0.3 "Minimum turn-down energy fraction to stop the receiver";
  parameter Real nu_defocus = 1 "Energy fraction to the receiver at defocus state";
  parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound";
  // Level (below which)s to stop disptach
  parameter Real hot_tnk_empty_ub = 10 "Hot tank trigger to start dispatching";
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
  parameter Real Kp = -575 "Gain of proportional component in receiver control";
  //****************************** Dispatch Optimiser
  parameter String DNI_file = wea_file;
  parameter String price_file = pri_file;
  parameter Integer horison = 48;
  parameter Real dt = 1 "delta t of the optimisation";
  parameter Real etaG(fixed = false);
  parameter Real etaC = metadata_list[3];
  parameter Real SLminrel = hot_tnk_empty_lb / 100 "hot tank empt trigger point";
  parameter Real Ahelio = A_field;
  parameter Real const_t = -dt * 3600;
  //******************************* Other Parameters
  parameter SI.CoefficientOfHeatTransfer h_conv_CO2 = 2000 "According to Luis Code";
  parameter SI.HeatFlowRate Q_flow_des(fixed = false) "Heat to power block at design";
  parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
  parameter SI.Length H_rcv_1 = sqrt(A_rcv_1 * ar_rec) "Receiver aperture height";
  parameter SI.Length H_rcv_2 = sqrt(A_rcv_2 * ar_rec) "Receiver aperture height";
  parameter SI.Length H_rcv_3 = sqrt(A_rcv_3 * ar_rec) "Receiver aperture height";
  parameter SI.Length W_rcv_1 = A_rcv_1 / H_rcv_1 "Receiver aperture width";
  parameter SI.Length W_rcv_2 = A_rcv_2 / H_rcv_2 "Receiver aperture width";
  parameter SI.Length W_rcv_3 = A_rcv_3 / H_rcv_3 "Receiver aperture width";
  parameter SI.Length L_rcv = 1 "Receiver length(depth)";
  parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold particles specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot particles specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_co2_in_set = MedPB.specificEnthalpy(state_co2_in_set) "Cold CO2 specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_co2_out_set = MedPB.specificEnthalpy(state_co2_out_set) "Hot CO2 specific enthalpy at design";
  parameter SI.Density rho_cold_set = Medium.density(state_cold_set) "Cold particles density at design";
  parameter SI.Density rho_hot_set = Medium.density(state_hot_set) "Hot particles density at design";
  parameter SI.Mass m_max = E_max / (h_hot_set - h_cold_set) "Max particles mass in tanks";
  parameter SI.Volume V_max = m_max / ((rho_hot_set + rho_cold_set) / 2) / packing_factor "Volume needed to host particles in the tank with certain packing factor value";
  parameter SI.MassFlowRate m_flow_fac(fixed = false);
  parameter SI.MassFlowRate m_flow_rec_min = 0 "Minimum mass flow rate to receiver";
  parameter SI.MassFlowRate m_flow_rec_max = 1.5 * m_flow_fac "Maximum mass flow rate to receiver";
  parameter SI.MassFlowRate m_flow_rec_start = 0.8 * m_flow_fac "Initial https://pubs.acs.org/doi/pdf/10.1021/jp206115por guess value of mass flow rate to receiver in the feedback controller";
  parameter SI.MassFlowRate m_flow_blk(fixed = false);
  parameter SI.Power P_name = P_net "Nameplate rating of power block";
  parameter SI.Length H_storage = ceil((4 * V_max * tank_ar ^ 2 / CN.pi) ^ (1 / 3)) "Storage tank height";
  parameter SI.Diameter D_storage = H_storage / tank_ar "Storage tank diameter";
  parameter SI.Area SA_storage = CN.pi * D_storage * H_storage "Storage tank surface area";
  //******************************* Cost Model
  parameter Real A_HX(fixed = false) "Heat exchanger total surface area --> UA_HX / U_HX";
  parameter Real UA_HX(fixed = false) "By product of initialisation of the PB model regardless which PB model is chosen";
  parameter Real U_HX(fixed = false) "Calculated parameter in the initial equation";
  parameter FI.Money C_HTR(fixed = false) "cost of the high temperature heat recuperator";
  parameter FI.Money C_LTR(fixed = false) "cost of the low temperature heat recuperator";
  parameter FI.Money C_turbine(fixed = false) "cost of the turbine";
  parameter FI.Money C_mainCompressor(fixed = false) "cost of the main compressor";
  parameter FI.Money C_reCompressor(fixed = false) "cost of the re compressor";
  parameter FI.Money C_exchanger(fixed = false) "cost of the exchanger";
  parameter FI.Money C_generator(fixed = false) "cost of the generator";
  parameter FI.Money C_cooler(fixed = false) "cost of the cooler";
  parameter Real r_i = 0.025 "Inflation rate";
  parameter Real r_disc_nom = 0.0701 "Nominal discount rate";
  parameter Real r_disc = (1 + r_disc_nom) / (1 + r_i) - 1;
  parameter Integer t_life(unit = "year") = 30 "Lifetime of plant";
  parameter Integer t_cons(unit = "year") = 2 "Years of construction";
  parameter Real r_cur = 0.71 "The currency rate from AUD to USD valid for 2019. See https://www.rba.gov.au/";
  parameter Real r_contg = 0.1 "Contingency rate";
  parameter Real r_cons = 0.09 "Construction cost rate";
  parameter FI.AreaPrice pri_field = if pri_field_wspd_max == true then if currency == Currency.USD then FI.heliostat_specific_cost_w_spd(Wspd_max = Wspd_max, A_helio = A_helio) * 0.3716 else FI.heliostat_specific_cost_w_spd(Wspd_max = Wspd_max, A_helio = A_helio) * 0.3716 / r_cur else if currency == Currency.USD then 75 else 75 / r_cur " Emes et al. ,Effect of heliostat design wind speed on the levelised cost ofelectricity from concentrating solar thermal power tower plants,Solar Energy 115 (2015) 441–451 ==> taken from the Fig 8.....75 is taken from Gen3 Roadmap Report";
  parameter FI.AreaPrice pri_site = if currency == Currency.USD then 10 else 10 / r_cur "Site improvements cost per area";
  parameter FI.AreaPrice pri_land = if currency == Currency.USD then 10000 / 4046.86 else 10000 / 4046.86 / r_cur "Land cost per area";
  parameter FI.Money pri_tower = if currency == Currency.USD then 157.44 else 157.44 / r_cur "Fixed tower cost";
  parameter Real idx_pri_tower = 1.9174 "Tower cost scaling index";
  parameter Real pri_tower_fix = 3e6 "Fix tower cost according to SAM cost function";
  parameter Real pri_tower_scalar_exp = 0.0113 "Scaler for tower cost according to SAM";
  parameter Real pri_lift = if currency == Currency.USD then 58.37 else 58.37 / r_cur "Lift cost per rated mass flow per height";
  parameter FI.AreaPrice pri_receiver = if match_gen3_report_cost then if currency == Currency.USD then 150 else 150 / r_cur else if currency == Currency.USD then 37400 else 37400 / r_cur "Falling particle receiver cost per design aperture area";
  parameter FI.MassPrice pri_particle = 1.0 "Unit cost of particles per kg";
  parameter Real pri_bin = 1230 "bin specific cost";
  parameter Real pri_bin_linear = 0.369;
  parameter Real pri_bin_multiplier = 1;
  //******************************* Specific Cost parameters for Power Block Components
  parameter Real pri_recuperator = 5.2;
  parameter Real pri_turbine = 9923.7;
  parameter Real pri_compressor = 643.15;
  parameter Real pri_cooler = 76.25;
  parameter Real pri_generator = 108900;
  parameter Real pri_PHX_BOP_CO2 = 4753 "[$-s/kg] Primary Heat Exchanger Specific Cost - G3P3 conversation email by Cliff 11 Nov 2020";
  parameter Real pri_PHX_BOP_s = 9153 "[$-s/kg] Primary Heat Exchanger Specific Cost - G3P3 conversation email by Cliff 11 Nov 2020";
  parameter Real pri_PHX_manufacture = 3711 "[$/m2] Primary Heat Exchanger Specific Cost - G3P3 conversation email by Cliff 11 Nov 2020";
  parameter Real pri_PHX_material = 5320 "[$/m2] Primary Heat Exchanger Specific Cost - G3P3 conversation email by Cliff 11 Nov 2020";
  parameter SI.Efficiency eta_motor = 1 "electrical generator efficiency";
  parameter FI.Money pri_exchanger = 150 "price of the primary exchanger in $/(kW_th). Objective for next-gen CSP with particles  --> value from v.9 EES sandia result c_hx";
  parameter FI.PowerPrice pri_bop = if currency == Currency.USD then 290 / 1040 * 600 / 1000 else 290 / 1040 * 600 / 1000 / r_cur "USD/We Balance of plant cost per gross rated power. 290--> Maximum BOP cost per MWe from SAM. 1040 is the maximum power block cost per MWe at SAM. 600 is the specific cost of the power block in USD/kWe according to DOE guidline,  ";
  parameter FI.PowerPrice pri_block = if currency == Currency.USD then 900 else 900 / r_cur "sCO2 PB cost per kWe based on the G3P3 Roadmap Report";
  //******************************* O&M Specific Cost & Cost for Washing Heliostat
  // Source : Heliostat Cost Reduction Study Gregory J. Kolb, page 138 Table 1
  parameter Real pri_om_name(unit = "$/W/year") = if currency == Currency.USD then 40 / 1e3 else 40 / 1e3 / r_cur "Fixed O&M cost per nameplate per year";
  parameter Real pri_om_prod(unit = "$/J/year") = if currency == Currency.USD then 0.003 / (1e6 * 3.6) else 0.003 / (1e6 * 3.6) / r_cur "Variable O&M cost per production per year";
  parameter Real C1 = 98 " % cleanliness of the mirror after 1 cleaning pass for method 1";
  parameter Real C2 = 96.5 " % cleanliness of the mirror after 1 cleaning pass for method 2";
  parameter Real C_target = rho_helio * 100 "annual reflectivity target";
  parameter Real R_soil = 0.49 "% reflectivity loss from the design reflectivity due to soiling";
  parameter Real P_w = 12 "Month(s) in a year that the cleaning will be conducted";
  parameter Real omega_n = 1.5 "Natural washing frequency (rain, snow, etc)";
  parameter Real omega_twister(fixed = false) "Supplementary washing (with machine) frequency per year";
  parameter Real pri_washing_deluge_method = 0.0027 * 1.3 "USD/m.sq field annually. 1.3 is a factor of conversion from USD 2007 to 2020";
  parameter Real pri_washing_twister_method = 0.0076 * 1.3 "USD/m.sq field annually. 1.3 is a factor of conversion from USD 2007 to 2020";
  parameter Real omega_deluge = 2 * omega_twister "this approach uses KJC cleaning method (1 Twister and 2 Deluge truck in between";
  // Source : Heliostat Cost Reduction Study Gregory J. Kolb, page 121 Table A-8
  parameter Real pri_om_field = 52.8815449319 * A_helio ^ (-1.0359277351) "O&M field based on number of heliostat in USD / unit. The price is multiplied by 1.5 to conver it to USD 2020 from USD 2000";
  //******************************* Cost Calculation
  parameter FI.Money C_washing = (omega_twister * pri_washing_twister_method + omega_deluge * pri_washing_deluge_method) * A_field "Washing cost [USD/year]";
  parameter FI.Money C_om_field = pri_om_field * A_field "OnM field exclude washing cost [USD/year]";
  parameter FI.Money C_field = A_field * pri_field "Field cost";
  parameter FI.Money C_site = A_field * pri_site "Site improvements cost";
  parameter FI.Money C_land = A_land * pri_land "Land cost";
  parameter FI.Money C_field_total = C_field + C_site "Heliostat field plus site preparation costs";
  //Receiver Sub-system Cost
  parameter FI.Money C_tower = if match_gen3_report_cost then 0 elseif match_sam_cost then pri_tower_fix * Modelica.Math.exp(pri_tower_scalar_exp * (H_tower + 0.5 * H_helio - (H_rcv_1 + H_rcv_2 + H_rcv_3) / 2)) else pri_tower * H_tower ^ idx_pri_tower "Tower cost. SAM cost function is based on DELSOL3 report 1986 but the constants value has been updated according to SAM 2018.11.11";
  parameter FI.Money C_fpr = if match_gen3_report_cost then 0 else pri_receiver * (A_rcv_1 + A_rcv_2 + A_rcv_3) "Falling particle receiver cost";
  parameter FI.Money C_lift_rec = if match_gen3_report_cost then 0 else pri_lift * dh_liftRC * m_flow_fac "Receiver lift cost";
  parameter FI.Money C_receiver = if match_gen3_report_cost then Q_flow_des * 0.150 else C_fpr + C_tower + C_lift_rec "Total receiver cost";
  //Storage Sub-system cost
  parameter FI.Money C_lift_cold = pri_lift * dh_LiftCold * m_flow_blk "Cold storage tank lift cost";
  parameter FI.Money C_bins = if new_storage_calc then 750 * CN.pi * (D_storage + t_mp + t_tuffcrete47) * H_storage else pri_bin_multiplier * (pri_bin + pri_bin_linear * (T_hot_set - 600) / 400) * SA_storage + pri_bin_multiplier * (pri_bin + pri_bin_linear * (T_cold_set - 600) / 400) * SA_storage "Cost of cold and hot storage bins without insulation, 750 is taken from the email from jeremy stent by Philipe Gunawan";
  parameter FI.Money C_insulation = if U_value_hot_tank == 0 and U_value_cold_tank == 0 then 0 else SA_storage * (131.0426 / U_value_hot_tank + 23.18) + SA_storage * (131.0426 / U_value_cold_tank + 23.18);
  //FIXME: THere are 2 u_values now, implement it in the tuffcrete x microporous analysis
  //(131.0426 / U_value + 23.18) ======> cost function insulation of Tuffcrete, Microporous and Concrete
  //(873.11/U_value) - 322.202 ======> cost function insulation of Tuffcrete, Pumplite60 and Concrete
  //parameter SI.Length t_mp = 0.32368 / U_value - 0.146096;
  //0.03293006 / U_value + 0.01518 =====> thickness function of Pumplite60;
  //0.32368 / U_value - 0.146096   =====> thickness function of Microporous;
  parameter SI.Length t_tuffcrete47 = 0.01;
  parameter FI.Money C_particles = (1 + NS_particle) * pri_particle * m_max "Cost of particles";
  parameter FI.Money C_storage = C_bins + C_particles + C_lift_hx + C_lift_cold + C_insulation + f_loss * t_life * pri_particle * 1.753e10 "Total storage cost";
  parameter FI.Money C_bop = P_gross * pri_bop "Balance of plant cost";
  parameter FI.Money C_lift_hx = pri_lift * dh_liftHX * m_flow_blk "Heat exchanger lift cost";
  parameter FI.Money C_block(fixed = false) "Power block cost";
  parameter FI.Money C_cap_total(fixed = false) "equipment cost";
  parameter FI.Money C_direct(fixed = false) "Direct capital costs";
  parameter FI.Money C_indirect(fixed = false) "Indirect capital costs";
  parameter FI.Money C_cap(fixed = false) "Capital costs";
  parameter FI.MoneyPerYear C_year = if detail_field_om then P_name * pri_om_name + C_om_field + C_washing else P_name * pri_om_name "Fixed O&M cost per year + OnM field + Cost of washing the field";
  parameter FI.Money C_prod = pri_om_prod "Variable O&M cost per production per year";
  // *********************System Components Instantiation
  //Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(extent = {{-144, -60}, {-114, -32}}, rotation = 0)));
  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(origin = {-127, 70}, extent = {{-13, -10}, {13, 10}}, rotation = 0)));
  //Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(origin = {139, 80}, extent = {{19, -10}, {-19, 10}}, rotation = 0)));
  //WindSpeed_input
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(transformation(extent = {{-140, 20}, {-114, 40}})));
  // Wind dir
  Modelica.Blocks.Sources.BooleanExpression always_on(y = true) annotation(
    Placement(visible = true, transformation(origin = {-128, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Wind_dir(y = data.Wdir) annotation(
    Placement(visible = true, transformation(origin = {-129, 51}, extent = {{-11, -13}, {11, 13}}, rotation = 0)));
  //pressure_input
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(transformation(extent = {{76, 18}, {56, 38}})));
  //parasitic inputs
  Modelica.Blocks.Sources.RealExpression parasities_input(y = heliostatsField.W_loss + liftHX.W_loss + liftRC.W_loss + tankHot.W_loss + tankCold.W_loss) annotation(
    Placement(visible = true, transformation(origin = {105, 59}, extent = {{-12, -8}, {12, 8}}, rotation = -90)));
  // Or block for defocusing
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(transformation(extent = {{-102, 4}, {-94, 12}})));
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(transformation(extent = {{-82, 60}, {-62, 80}})));
  // Solar field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsFieldSolstice_3Apertures_1stApproach heliostatsField(lon = data.lon, lat = data.lat, ele_min(displayUnit = "deg") = ele_min, use_wind = use_wind, t_start = t_start, Wspd_max = Wspd_max, he_av = he_av_design, use_on = true, use_defocus = true, A_h = A_helio, nu_defocus = nu_defocus, nu_min = nu_min_sf, Q_design_1 = Q_flow_defocus_calculated1, Q_design_2 = Q_flow_defocus_calculated2, Q_design_3 = Q_flow_defocus_calculated3, nu_start = nu_start, Q_in_rcv_1 = Q_in_rcv_1, Q_in_rcv_2 = Q_in_rcv_2, Q_in_rcv_3 = Q_in_rcv_3, H_rcv_1 = H_rcv_1, H_rcv_2 = H_rcv_2, H_rcv_3 = H_rcv_3, W_rcv_1 = W_rcv_1, W_rcv_2 = W_rcv_2, W_rcv_3 = W_rcv_3, tilt_rcv = tilt_rcv, W_helio = W_helio, H_helio = H_helio, H_tower = H_tower, R_tower = R_tower, R1 = R1, fb = fb, rho_helio = rho_helio, slope_error = slope_error, n_row_oelt = n_row_oelt, n_col_oelt = n_col_oelt, psave = casefolder, wea_file = wea_file) annotation(
    Placement(transformation(extent = {{-88, 2}, {-56, 36}})));
  // Washing calculator
  SolarTherm.Models.CSP.CRS.HeliostatsField.WashingFrequencyCalculator washingFrequencyCalculator(C_tw = C1, C_dl = C2, R_soil = R_soil, P_w = P_w, omega_n = omega_n, C_target = C_target) annotation(
    Placement(visible = true, transformation(origin = {-130, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Surrogate Receiver
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver_3Apertures particleReceiver(H_drop_design = H_rcv_1, use_neural_network = use_neural_network, redeclare package Medium = Medium, X_max = X_max_rcv, X_min = X_min_rcv, inputsize = inputsize_rcv, out_max = y_max_rcv, out_min = y_min_rcv, saved_model_dir = saved_model_dir_rcv, T_0 = T_cold_set, T_out = T_hot_set, m_flow_rec_max = m_flow_rec_max) annotation(
    Placement(visible = true, transformation(origin = {-26, 30}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  // Receiver Design Condition Sizing Calculator - Using expensive model
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1DCalculator particleReceiver1DCalculator1(Q_in = Q_in_rcv_1, T_out_design = T_in_ref_blk, T_in_design = T_in_rec, T_amb_design = T_amb_des_rcv, CR = CR, Wspd_design = 0, Wspd_dir = 0, dni_des = dni_des, h_conv_backwall = h_conv_backwall, h_conv_curtain = h_conv_curtain, phi_max = packing_factor, eps_w = eps_w, th_w = th_w, k_w = k_w, F = F, d_p = d_p, cp_s = cp_s, rho_s = rho_s, eps_s = eps_s, abs_s = abs_s, with_detail_h_ambient = true, with_wind_effect = true, test_mode = false, fixed_geometry = false, iterate_Q_flow = false, with_iterate_mdot = false, with_pre_determined_eta = false) annotation(
    Placement(visible = true, transformation(origin = {150, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1DCalculator particleReceiver1DCalculator2(Q_in = Q_in_rcv_2, T_out_design = T_in_ref_blk, T_in_design = T_in_rec, T_amb_design = T_amb_des_rcv, CR = CR, Wspd_design = 0, Wspd_dir = 0, dni_des = dni_des, h_conv_backwall = h_conv_backwall, h_conv_curtain = h_conv_curtain, phi_max = packing_factor, eps_w = eps_w, th_w = th_w, k_w = k_w, F = F, d_p = d_p, cp_s = cp_s, rho_s = rho_s, eps_s = eps_s, abs_s = abs_s, with_detail_h_ambient = true, with_wind_effect = true, test_mode = false, fixed_geometry = false, iterate_Q_flow = false, with_iterate_mdot = false, with_pre_determined_eta = false) annotation(
    Placement(visible = true, transformation(origin = {120, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1DCalculator particleReceiver1DCalculator3(Q_in = Q_in_rcv_3, T_out_design = T_in_ref_blk, T_in_design = T_in_rec, T_amb_design = T_amb_des_rcv, CR = CR, Wspd_design = 0, Wspd_dir = 0, dni_des = dni_des, h_conv_backwall = h_conv_backwall, h_conv_curtain = h_conv_curtain, phi_max = packing_factor, eps_w = eps_w, th_w = th_w, k_w = k_w, F = F, d_p = d_p, cp_s = cp_s, rho_s = rho_s, eps_s = eps_s, abs_s = abs_s, with_detail_h_ambient = true, with_wind_effect = true, test_mode = false, fixed_geometry = false, iterate_Q_flow = false, with_iterate_mdot = false, with_pre_determined_eta = false) annotation(
    Placement(visible = true, transformation(origin = {90, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Defocus calculator - minimum heat flow to each receiver such that mass flow blok design is achieving design temp
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1DCalculator defocuscalculator1(T_out_design = T_in_ref_blk, T_in_design = T_in_rec, T_amb_design = T_amb_des_rcv, CR = CR, Wspd_design = 0, Wspd_dir = 0, dni_des = dni_des, h_conv_backwall = h_conv_backwall, h_conv_curtain = h_conv_curtain, phi_max = packing_factor, eps_w = eps_w, th_w = th_w, k_w = k_w, F = F, d_p = d_p, cp_s = cp_s, rho_s = rho_s, eps_s = eps_s, abs_s = abs_s, with_detail_h_ambient = true, with_wind_effect = true, fixed_geometry = true, iterate_Q_flow = true, with_iterate_mdot = false, m_design = m_flow_blk * fraction_Q_1, H_drop_design = H_rcv_1, with_pre_determined_eta = false) annotation(
    Placement(visible = true, transformation(origin = {-132, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1DCalculator defocuscalculator2(T_out_design = T_in_ref_blk, T_in_design = T_in_rec, T_amb_design = T_amb_des_rcv, CR = CR, Wspd_design = 0, Wspd_dir = 0, dni_des = dni_des, h_conv_backwall = h_conv_backwall, h_conv_curtain = h_conv_curtain, phi_max = packing_factor, eps_w = eps_w, th_w = th_w, k_w = k_w, F = F, d_p = d_p, cp_s = cp_s, rho_s = rho_s, eps_s = eps_s, abs_s = abs_s, with_detail_h_ambient = true, with_wind_effect = true, fixed_geometry = true, iterate_Q_flow = true, with_iterate_mdot = false, m_design = m_flow_blk * fraction_Q_2, H_drop_design = H_rcv_2, with_pre_determined_eta = false) annotation(
    Placement(visible = true, transformation(origin = {-108, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1DCalculator defocuscalculator3(T_out_design = T_in_ref_blk, T_in_design = T_in_rec, T_amb_design = T_amb_des_rcv, CR = CR, Wspd_design = 0, Wspd_dir = 0, dni_des = dni_des, h_conv_backwall = h_conv_backwall, h_conv_curtain = h_conv_curtain, phi_max = packing_factor, eps_w = eps_w, th_w = th_w, k_w = k_w, F = F, d_p = d_p, cp_s = cp_s, rho_s = rho_s, eps_s = eps_s, abs_s = abs_s, with_detail_h_ambient = true, with_wind_effect = true, fixed_geometry = true, iterate_Q_flow = true, with_iterate_mdot = false, m_design = m_flow_blk * fraction_Q_3, H_drop_design = H_rcv_3, with_pre_determined_eta = false) annotation(
    Placement(visible = true, transformation(origin = {-84, -112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Hot tank
  SolarTherm.Models.Storage.Tank.Tank tankHot(redeclare package Medium = Medium, D = D_storage, H = H_storage, T_start = T_hot_start, L_start = (1 - split_cold) * 100, alpha = alpha, use_p_top = tnk_use_p_top, enable_losses = tnk_enable_losses, use_L = true, W_max = W_heater_hot, T_set = T_hot_aux_set, U_value = U_value_hot_tank, packing_factor = packing_factor) annotation(
    Placement(transformation(extent = {{16, 54}, {36, 74}})));
  // Cold tank
  SolarTherm.Models.Storage.Tank.Tank tankCold(redeclare package Medium = Medium, D = D_storage, H = H_storage, T_start = T_cold_start, L_start = split_cold * 100, alpha = alpha, use_p_top = tnk_use_p_top, enable_losses = tnk_enable_losses, use_L = true, W_max = W_heater_cold, T_set = T_cold_aux_set, U_value = U_value_cold_tank, packing_factor = packing_factor) annotation(
    Placement(transformation(extent = {{64, -28}, {44, -8}})));
  // Receiver lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftRC(redeclare package Medium = Medium, cont_m_flow = true, use_input = true, dh = dh_liftRC, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {-1, -27}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  // Heat exchanger lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftHX(redeclare package Medium = Medium, cont_m_flow = true, use_input = true, dh = dh_liftHX, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {76, 42}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  // Cold storage tank lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple LiftCold(redeclare package Medium = Medium, cont_m_flow = false, use_input = false, dh = dh_LiftCold, CF = 0, eff = eff_lift) annotation(
    Placement(visible = true, transformation(origin = {106, -34}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  // Temperature sensor
  SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-6, 68}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  // PowerBlockControl
  SolarTherm.Models.Control.PowerBlockControl controlHot(m_flow_on = m_flow_blk, L_on = hot_tnk_empty_ub, L_off = hot_tnk_empty_lb, L_df_on = hot_tnk_full_ub, L_df_off = hot_tnk_full_lb, logic.dispatch_optimiser = dispatch_optimiser) annotation(
    Placement(transformation(extent = {{48, 72}, {60, 58}})));
  // Power block
  SolarTherm.Models.PowerBlocks.SurrogatesCO2PB_OTF powerBlock(P_gross = P_gross, T_in_ref_blk = T_hot_set, p_high = p_high, PR = PR, pinch_PHX = pinch_exchanger, dTemp_HTF_PHX = dTemp_HTF_PHX, T_amb_base = blk_T_amb_des, htf_choice = htf_choice, dT_PHX_hot_approach = dT_PHX_hot_approach, dT_PHX_cold_approach = dT_PHX_cold_approach, eta_isen_mc = eta_comp_main, eta_isen_rc = eta_comp_re, eta_isen_t = eta_turb, dT_mc_approach = dT_mc_approach, which_PB_model = which_PB_model, load_base = 1, eta_gross_base = eta_gross_base, eta_Q_base = eta_Q_base, Q_HX_des = Q_flow_des, m_HTF_des = m_flow_blk, base_path = base_path, SolarTherm_path = SolarTherm_path, inputsize = inputsize_PB, outputsize = outputsize_PB, tolerance_kriging = tolerance_kriging, tolerance_ANN = tolerance_ANN, which_surrogate = which_surrogate, test_mode = false, eta_motor = eta_motor, f_fixed_load = f_fixed_load) annotation(
    Placement(transformation(extent = {{88, 4}, {124, 42}})));
  //Power Block Calculator
  SolarTherm.Models.PowerBlocks.sCO2PBCalculator_Using_JPidea sCO2PBDesignPointCalculator(redeclare package Medium = Medium, P_net = P_net, T_in_ref_blk = T_in_ref_blk, p_high = p_high, PR = PR, pinch_PHX = pinch_exchanger, dTemp_HTF_PHX = T_hot_set - T_cold_set, T_HTF_in = T_in_ref_blk, T_amb_input = blk_T_amb_des, load = 1, f_fixed_load = f_fixed_load, blk_T_amb_des = blk_T_amb_des, T_low = T_low, nu_min_blk = nu_min_blk, N_exch_parameter = N_exch_parameter, N_LTR_parameter = N_LTR_parameter, pri_recuperator = pri_recuperator, pri_turbine = pri_turbine, pri_compressor = pri_compressor, pri_cooler = pri_cooler, pri_generator = pri_generator, pri_exchanger = pri_exchanger, eta_motor = eta_motor, pinch_recuperator = pinch_recuperator, par_fr = par_fr, test_mode = true, external_parasities = external_parasities) annotation(
    Placement(visible = true, transformation(origin = {192, 110}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  // Price
  SolarTherm.Models.Analysis.Market market(redeclare model Price = Models.Analysis.EnergyPrice.Table(file = pri_file)) annotation(
    Placement(visible = true, transformation(extent = {{128, 12}, {148, 32}}, rotation = 0)));
  SolarTherm.Models.Sources.Schedule.Scheduler sch if not const_dispatch;
  // *********************Variables of interest
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
  // Analytics
  SI.Energy E_resource(start = 0);
  SI.Energy E_resource_after_optical_eff(start = 0);
  SI.Energy E_helio_incident(start = 0);
  SI.Energy E_helio_raw(start = 0);
  SI.Energy E_helio_net(start = 0);
  SI.Energy E_recv_incident(start = 0);
  SI.Energy E_recv_net(start = 0);
  SI.Energy E_pb_input(start = 0);
  SI.Energy E_pb_gross(start = 0);
  SI.Energy E_pb_net(start = 0);
  //Analytics All The Losses
  SI.Energy E_losses_curtailment(start = 0);
  SI.Energy E_losses_availability(start = 0);
  SI.Energy E_losses_optical(start = 0);
  SI.Energy E_losses_defocus(start = 0);
  SI.Energy E_check;
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
  //Dispatch optimiser variables
  Real SLinit;
  Real counter(start = const_t);
  Real time_simul;
  Real optimalDispatch;
  Real DEmax(start = Q_flow_des / 1e6) "Maximum dispatchable heat from the storage in MWth";
  Real SLmax(start = E_max * 2.77778e-10) "Storage capacity in MWh th";
  Real dummyRatio;
  Real accumulated_m;
  Real TOD_W(start = 0);
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y = false) annotation(
    Placement(visible = true, transformation(origin = {-128, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
  if time > 31449600 then
    eta_curtail_off := E_helio_incident / E_resource;
    eta_optical := E_resource_after_optical_eff / E_resource;
    eta_he_av := he_av_design;
    eta_curtail_defocus := E_helio_net / E_helio_raw;
    eta_recv_abs := E_recv_incident / E_helio_net;
    eta_recv_thermal := E_recv_net / E_recv_incident;
    eta_storage := E_pb_input / E_recv_net;
    eta_pb_gross := E_pb_gross / E_pb_input;
    eta_pb_net := E_pb_net / E_pb_input;
    eta_solartoelec := E_pb_net / E_resource;
    E_check := E_resource - E_losses_availability - E_losses_curtailment - E_losses_defocus - E_losses_optical - E_helio_net;
  end if;
initial equation
  omega_twister = ceil(washingFrequencyCalculator.omega);
  opt_file = heliostatsField.optical.tablefile;
  A_rcv_1 = particleReceiver1DCalculator1.particleReceiver1D.H_drop ^ 2;
  A_rcv_2 = particleReceiver1DCalculator2.particleReceiver1D.H_drop ^ 2;
  A_rcv_3 = particleReceiver1DCalculator3.particleReceiver1D.H_drop ^ 2;
  rec_fr = 1 - (particleReceiver1DCalculator1.particleReceiver1D.eta_rec + particleReceiver1DCalculator2.particleReceiver1D.eta_rec + particleReceiver1DCalculator3.particleReceiver1D.eta_rec) / 3;
  m_flow_fac = particleReceiver1DCalculator1.particleReceiver1D.mdot + particleReceiver1DCalculator2.particleReceiver1D.mdot + particleReceiver1DCalculator3.particleReceiver1D.mdot;
  Q_flow_defocus_calculated1 = defocuscalculator1.particleReceiver1D.q_solar * A_rcv_1;
  Q_flow_defocus_calculated2 = defocuscalculator2.particleReceiver1D.q_solar * A_rcv_2;
  Q_flow_defocus_calculated3 = defocuscalculator3.particleReceiver1D.q_solar * A_rcv_3;
  if which_PB_model == 0 then
    eta_gross_base = sCO2PBDesignPointCalculator.eta_gross;
    eta_Q_base = sCO2PBDesignPointCalculator.eta_Q;
    Q_flow_des = sCO2PBDesignPointCalculator.powerBlock.Q_HX_des;
    etaG = sCO2PBDesignPointCalculator.powerBlock.eta_net_design;
    eff_blk = sCO2PBDesignPointCalculator.powerBlock.eta_net_design;
    m_flow_blk = sCO2PBDesignPointCalculator.m_HTF_des;
    UA_HX = sCO2PBDesignPointCalculator.powerBlock.exchanger.UA;
  elseif which_PB_model == 1 then
    NREL_PB_configurations = SolarTherm.Utilities.designNRELPB(P_gross, T_in_ref_blk, p_high, dT_PHX_cold_approach, eta_comp_main, eta_comp_re, eta_turb, dT_mc_approach, blk_T_amb_des, HTF_name, htf_choice, SolarTherm_path, T_cold_set);
    Q_flow_des = NREL_PB_configurations[10] "Heat transfer of the PHX at the design point";
    eta_gross_base = NREL_PB_configurations[11] "After cooling power, before other parasities and fixed self-power consumption";
    eta_Q_base = NREL_PB_configurations[12] "";
    etaG = eta_gross_base * (1 - f_fixed_load) "after cooling power, motor eff and fixed load parasities";
    eff_blk = etaG;
    m_flow_blk = NREL_PB_configurations[9] "HTF mass flow rate at the design point";
    dT_PHX_hot_approach = NREL_PB_configurations[13];
    UA_HX = NREL_PB_configurations[7];
  else
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
  A_HX = UA_HX / U_HX;
//************************************ Power Block Cost Calculation
  if which_PB_model == 1 then
    C_HTR = pri_recuperator * NREL_PB_configurations[1] ^ 0.8933;
    C_LTR = pri_recuperator * NREL_PB_configurations[1] ^ 0.8933;
    C_turbine = pri_turbine * (NREL_PB_configurations[3] / 10 ^ 3) ^ 0.5886;
    C_mainCompressor = pri_compressor * (NREL_PB_configurations[4] / 10 ^ 3) ^ 0.9142;
    C_reCompressor = pri_compressor * (NREL_PB_configurations[4] / 10 ^ 3) ^ 0.9142;
    C_cooler = pri_cooler * NREL_PB_configurations[6] ^ 0.8919;
    C_exchanger = (pri_PHX_material + pri_PHX_manufacture) * A_HX + pri_PHX_BOP_s * m_flow_blk + pri_PHX_BOP_CO2 * NREL_PB_configurations[8];
    C_generator = pri_generator * (P_net / 10 ^ 6) ^ 0.5463;
  elseif which_PB_model == 0 then
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
  if which_PB_model == 0 then
    if match_gen3_report_cost then
      C_block = pri_block * P_gross / 1000;
    else
      C_block = sCO2PBDesignPointCalculator.powerBlock.C_PB;
    end if;
  elseif which_PB_model == 1 then
    if match_gen3_report_cost then
      C_block = pri_block * P_gross / 1000;
    else
      C_block = C_HTR + C_LTR + C_turbine + C_mainCompressor + C_reCompressor + C_cooler + C_exchanger + C_generator;
    end if;
  else
    C_block = -1;
  end if;
//************************************ Capital Cost Calculation
  C_cap_total = C_field + C_site + C_receiver + C_storage + C_block + C_bop;
  C_direct = (1 + r_contg) * C_cap_total;
  C_indirect = r_cons * C_direct + C_land;
  C_cap = C_direct + C_indirect;
equation
/*Equations below exist to close the model, s.t. the particle receiver model is agnostic to the input dimension*/
  particleReceiver.raw_input_1[1] = H_rcv_1;
  particleReceiver.raw_input_1[2] = particleReceiver.Q_in_1;
  particleReceiver.raw_input_1[3] = particleReceiver.T_in;
  particleReceiver.raw_input_1[4] = T_hot_set;
  particleReceiver.raw_input_1[5] = particleReceiver.Tamb;
  particleReceiver.raw_input_1[6] = particleReceiver.Wspd;
  particleReceiver.raw_input_1[7] = particleReceiver.Wdir;
  particleReceiver.ratio_1 = heliostatsField.ratio_1 "Equation to close the model";
  particleReceiver.raw_input_2[1] = H_rcv_2;
  particleReceiver.raw_input_2[2] = particleReceiver.Q_in_2;
  particleReceiver.raw_input_2[3] = particleReceiver.T_in;
  particleReceiver.raw_input_2[4] = T_hot_set;
  particleReceiver.raw_input_2[5] = particleReceiver.Tamb;
  particleReceiver.raw_input_2[6] = particleReceiver.Wspd;
  particleReceiver.raw_input_2[7] = particleReceiver.Wdir;
  particleReceiver.ratio_2 = heliostatsField.ratio_2 "Equation to close the model";
  particleReceiver.raw_input_3[1] = H_rcv_3;
  particleReceiver.raw_input_3[2] = particleReceiver.Q_in_3;
  particleReceiver.raw_input_3[3] = particleReceiver.T_in;
  particleReceiver.raw_input_3[4] = T_hot_set;
  particleReceiver.raw_input_3[5] = particleReceiver.Tamb;
  particleReceiver.raw_input_3[6] = particleReceiver.Wspd;
  particleReceiver.raw_input_3[7] = particleReceiver.Wdir;
  particleReceiver.ratio_3 = heliostatsField.ratio_3 "Equation to close the model";
/*End section*/
/*Assigning the input to the surrogate model*/
  powerBlock.raw_input[1] = powerBlock.load;
  powerBlock.raw_input[2] = tankHot.medium.T;
  powerBlock.raw_input[3] = data.Tdry;
/*End section*/
  der(accumulated_m) = particleReceiver.fluid_a.m_flow;
//Dispatch optimiser variables
  SLinit = tankHot.L / 100 * m_max * (Utils.h_T(tankHot.medium.T) - Utils.h_T(tankCold.medium.T)) * 2.7778e-10 "Thermal energy left in the hot tank [MWh_th]";
  DEmax = m_flow_blk * (Utils.h_T(tankHot.medium.T) - Utils.h_T(tankCold.medium.T)) * 1e-6 "Maximum dispatchable heat [MWth]";
  SLmax = m_max * (Utils.h_T(tankHot.medium.T) - Utils.h_T(tankCold.medium.T)) * 2.7778e-10 "Maximum storage level in MWhth";
  if dispatch_optimiser == true then
    der(counter) = 1;
  else
    der(counter) = 0;
  end if;
  when counter > 0 then
    time_simul = floor(time);
    if dispatch_optimiser then
      optimalDispatch = SolarTherm.Utilities.LinProgFunc(DNI_file, price_file, horison, dt, time_simul, etaC, etaG, t_storage, DEmax, SLmax, SLinit, SLminrel, A_field);
    else
      optimalDispatch = DEmax;
    end if;
    reinit(counter, const_t);
  end when;
  controlHot.logic.optimalMassFlow = if dispatch_optimiser == true then min(optimalDispatch / DEmax * m_flow_blk, m_flow_blk) else 0;
  dummyRatio = optimalDispatch / DEmax;
  der(E_resource) = max(sun.dni * (n_helios_1 + n_helios_2 + n_helios_3) * A_helio, 0.0);
  der(E_losses_optical) = (1 - heliostatsField.nu_1) * max(heliostatsField.solar.dni * heliostatsField.n_h_1 * heliostatsField.A_h, 0.0);
  der(E_losses_availability) = (1 - he_av_design) * max(heliostatsField.nu_1 * heliostatsField.solar.dni * heliostatsField.n_h_1 * heliostatsField.A_h, 0.0);
  der(E_losses_curtailment) = if heliostatsField.on_hf_1 == true then 0 else (1 - he_av_design) * max(heliostatsField.nu_1 * heliostatsField.solar.dni * heliostatsField.n_h_1 * heliostatsField.A_h, 0.0);
  der(E_losses_defocus) = if heliostatsField.on_internal_1 then if heliostatsField.defocus_internal then abs(heliostatsField.Q_incident - (heliostatsField.Q_raw_1 + heliostatsField.Q_raw_2 + heliostatsField.Q_raw_3)) else 0 else 0;
  der(E_resource_after_optical_eff) = max(sun.dni * n_helios_1 * A_helio, 0.0) * heliostatsField.nu_1;
  der(E_helio_incident) = if heliostatsField.on_hf_1 then heliostatsField.n_h_1 * heliostatsField.A_h * max(0.0, heliostatsField.solar.dni) else 0.0;
  der(E_helio_raw) = heliostatsField.Q_raw_1 + heliostatsField.Q_raw_2 + heliostatsField.Q_raw_3;
  der(E_helio_net) = heliostatsField.Q_incident;
  der(E_recv_incident) = particleReceiver.heat.Q_flow;
  der(E_recv_net) = particleReceiver.heat.Q_flow;
//if powerBlock.m_sup == true then
  der(E_pb_input) = powerBlock.Q_HX;
  der(E_pb_gross) = -powerBlock.W_gross;
//else
//der(E_pb_input) = 0;
//der(E_pb_gross) = 0;
//end if;
  der(E_pb_net) = powerBlock.W_net;
  P_elec = powerBlock.W_net;
  der(E_elec) = P_elec;
  R_spot = market.profit;
  der(TOD_W) = market.price.price * powerBlock.W_net;
//Connections from data
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
// Fluid connections
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
    Line(points = {{105, 46}, {105, 40.85}, {109.6, 40.85}, {109.6, 34.4}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
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
  connect(Wspd_input.y, particleReceiver.Wspd) annotation(
    Line(points = {{-112, 30}, {-108, 30}, {-108, 52}, {-26, 52}, {-26, 42}, {-26, 42}}, color = {0, 0, 127}));
  connect(Tamb_input.y, particleReceiver.Tamb) annotation(
    Line(points = {{118, 80}, {-22, 80}, {-22, 42}, {-22, 42}}, color = {0, 0, 127}));
  connect(booleanExpression.y, or1.u2) annotation(
    Line(points = {{-116, -22}, {-106, -22}, {-106, 4}, {-102, 4}, {-102, 4}}, color = {255, 0, 255}));
  connect(tankCold.L, particleReceiver.level) annotation(
    Line(points = {{44, -14}, {24, -14}, {24, 24}, {-20, 24}, {-20, 24}}, color = {0, 0, 127}));
  connect(heliostatsField.on_2, particleReceiver.on_2) annotation(
    Line(points = {{-66, 2}, {-44, 2}, {-44, 20}, {-28, 20}, {-28, 20}}, color = {255, 0, 255}));
  connect(heliostatsField.on_1, particleReceiver.on_1) annotation(
    Line(points = {{-72, 2}, {-30, 2}, {-30, 16}, {-28, 16}}, color = {255, 0, 255}));
  connect(heliostatsField.on_3, particleReceiver.on_3) annotation(
    Line(points = {{-78, 2}, {-36, 2}, {-36, 18}, {-28, 18}, {-28, 18}}, color = {255, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(lineColor = {217, 67, 180}, extent = {{4, 92}, {40, 90}}, textString = "defocus strategy", fontSize = 9), Text(origin = {-8, -20}, lineColor = {217, 67, 180}, extent = {{-58, -18}, {-14, -40}}, textString = "on/off strategy", fontSize = 9), Text(origin = {12, 24}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, -8}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-4, 2}, extent = {{0, 58}, {48, 38}}, textString = "Hot Tank", fontSize = 6, fontName = "CMU Serif"), Text(extent = {{30, -24}, {78, -44}}, textString = "Cold Tank", fontSize = 6, fontName = "CMU Serif"), Text(origin = {4, -2}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"), Text(origin = {6, 0}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"), Text(origin = {20, 4}, extent = {{-6, 20}, {42, 0}}, textString = "Receiver Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {2, 32}, extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-6, -26}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif"), Text(origin = {0, -40}, extent = {{-10, 8}, {10, -8}}, textString = "Lift Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {80, -8}, extent = {{-14, 8}, {14, -8}}, textString = "LiftCold", fontSize = 6, fontName = "CMU Serif"), Text(origin = {85, 59}, extent = {{-19, 11}, {19, -11}}, textString = "LiftHX", fontSize = 6, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 1e-06, Interval = 3600),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li> A. Shirazi and A. Fontalvo Lascano (June 2019) :<br>Released first version. </li>
	<li> Philipe Gunawan Gan (Jan 2020) :<br>Released PhysicalParticleCO21D (with 1D particle receiver). </li>
	</ul>

	</html>"),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end PhysicalParticleCO21D_1stApproach_SurrogateReceiverMultiAperture_SurrogatePB_SingleOutput;