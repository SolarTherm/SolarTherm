within SolarTherm.Models.PowerBlocks;

model Test_OTF_PB
  import SolarTherm.Utilities.Kriging_OnTheFly.*;
  import SolarTherm.Utilities.ANN_OnTheFly.*;
  
  /*This script is to test on the functionality of the on the fly surrogate models: Method Kriging and ANN*/
  //******************************** CEA Power Block Parameters
  parameter Real P_net = 3e7;
  parameter Real T_in_ref_blk = 1243.27;
  parameter Real p_high = 22707266.48;
  parameter Real PR = 2.98;
  parameter Real pinch_PHX = 23.67;
  parameter Real dTemp_HTF_PHX = 238.45;
  parameter Real load_base = 1;
  parameter Real T_amb_base = 39 + 273.15;
  
  //******************************** NREL SAM PB Parameters
  parameter Integer htf_choice = 50 "--------------------> 50 is user defined fluid properties";
  parameter Real dT_PHX_hot_approach = 20 "--------------------> [C/K] Temp. difference between hot HTF and TIT";
  parameter Real dT_PHX_cold_approach = 20 "---------------------> [C/K] Temp. difference between cold HTF and cold CO2 PHX inlet";
  parameter Real eta_isen_mc = 0.85 "----------------> main compressor isentropic efficiency";
  parameter Real eta_isen_rc = 0.85 "----------------> re-compressor isentropic efficiency";
  parameter Real eta_isen_t = 0.9 "-----------------> turbine isentropic efficiency";
  parameter Real dT_mc_approach = 6.0 "--------------------> [C/K] Temp. difference between main compressor CO2 inlet and ambient";
  
  //********************************* On the fly and simulation configurations
  parameter String base_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include") "Base path that points to which folder the C program is stored";
  parameter String SolarTherm_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm") "Base path of SolarTherm";
  parameter Integer PB_model = 1 "-----------------------> 0 is for CEA power block, 1 is for NREL-SAM power block";
  parameter String HTF_name = "CarboHSP";
  
  //********************************* CEA power block
  parameter Real eta_gross_base(fixed = false) "*****eta_gross_base = sCO2SimonPB.eta_gross_design";
  parameter Real eta_Q_base(fixed = false) "*******eta_Q_base = sCO2SimonPB.eta_Q_design";
  
  //********************************* NREL PB power block calculated parameters
  parameter Real eta_gross_base_NREL(fixed = false);
  parameter Real eta_Q_base_NREL(fixed = false);
  parameter Real NREL_PB_configurations[12](each fixed = false);
  parameter Integer inputsize = 3;
  parameter Integer outputsize = 2;
  parameter Real tolerance_kriging = 1;
  
  //******************** Kriging
  Kriging_properties Kriging_variables = Kriging_properties(
                P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, T_amb_base, eta_gross_base, 
                eta_Q_base, base_path, SolarTherm_path, inputsize, outputsize, tolerance_kriging, PB_model, htf_choice,     
                dT_PHX_hot_approach, dT_PHX_cold_approach, eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach, HTF_name);
  
  //******************** ANN PB
  parameter Real tolerance_ANN = 1;
  parameter Integer index_0 = 0;
  ANN_properties session_PB = ANN_properties(
              P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, T_amb_base, eta_gross_base, eta_Q_base, 
              index_0, base_path, SolarTherm_path, inputsize, outputsize, tolerance_ANN, PB_model, htf_choice, 
              dT_PHX_hot_approach, dT_PHX_cold_approach, eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach, HTF_name);
              
  //******************** ANN HX
  parameter Integer index_1 = 1;
  ANN_properties session_HX = ANN_properties(
              P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, T_amb_base, eta_gross_base, eta_Q_base, 
              index_1, base_path, SolarTherm_path, inputsize, outputsize, tolerance_ANN, PB_model, htf_choice, 
              dT_PHX_hot_approach, dT_PHX_cold_approach, eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach, HTF_name);
              
  //******************** Variables
  Real[3] raw_inputs = {0.77, 1230, 283.15};
  Real eta_gross_kriging;
  Real eta_Q_kriging;
  Real eta_gross_ANN;
  Real eta_Q_ANN;
  Real deviation_eta_gross_kriging;
  Real deviation_eta_Q_kriging;
  Real deviation_eta_gross_ANN;
  Real deviation_eta_Q_ANN;
  
initial equation
  NREL_PB_configurations = SolarTherm.Utilities.designNRELPB(
              P_net, T_in_ref_blk, p_high, dT_PHX_hot_approach, dT_PHX_cold_approach, 
              eta_isen_mc, eta_isen_rc, eta_isen_t,
              dT_mc_approach, T_amb_base, HTF_name, SolarTherm_path);
              
  eta_gross_base_NREL = NREL_PB_configurations[11];
  eta_Q_base_NREL = NREL_PB_configurations[12];
  /*start calculating cost here*/
  eta_gross_base = eta_gross_base_NREL;
  eta_Q_base = eta_Q_base_NREL;
  
equation
  deviation_eta_gross_kriging = OTF_Kriging_interpolate(Kriging_variables, raw_inputs, "eta_gross", "spherical");
  eta_gross_kriging = eta_gross_base - deviation_eta_gross_kriging;
  deviation_eta_Q_kriging = OTF_Kriging_interpolate(Kriging_variables, raw_inputs, "eta_Q", "spherical");
  eta_Q_kriging = eta_Q_base - deviation_eta_Q_kriging;
  deviation_eta_gross_ANN = OTF_ANN_predict(session_PB, raw_inputs, 0);
  eta_gross_ANN = eta_gross_base - deviation_eta_gross_ANN;
  deviation_eta_Q_ANN = OTF_ANN_predict(session_HX, raw_inputs, 1);
  eta_Q_ANN = eta_Q_base - deviation_eta_Q_ANN;

end Test_OTF_PB;