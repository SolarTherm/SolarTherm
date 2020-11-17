within SolarTherm.Models.PowerBlocks;

model Test_init_NREL_PB
  import SolarTherm.Utilities.Kriging_OnTheFly.*;
  import SolarTherm.Utilities.ANN_OnTheFly.*;
  import SI = Modelica.SIunits;
  
  /*This script is to test on the functionality of the on the fly surrogate models: Method Kriging and ANN*/
  //******************************** CEA Power Block Parameters
  parameter Real P_net = 1e8;
  parameter Real T_in_ref_blk = 1073.15;
  parameter Real p_high = 25e6;
  parameter Real PR = 2.98;
  parameter Real pinch_PHX = 23.67;
  parameter Real dTemp_HTF_PHX = 238.45;
  parameter Real load_base = 1;
  parameter Real T_amb_base = 39 + 273.15;
  
  //******************************** NREL SAM PB Parameters
  parameter Integer HTF_choice = 50 "--------------------> 50 is user defined fluid properties";
  parameter SI.TemperatureDifference dT_PHX_hot_approach(fixed=false,start=100,min=5,max=300) "--------------------> [C/K] Temp. difference between hot HTF and TIT";
  parameter SI.TemperatureDifference dT_PHX_cold_approach = 15 "---------------------> [C/K] Temp. difference between cold HTF and cold CO2 PHX inlet";
  parameter Real eta_isen_mc = 0.85 "----------------> main compressor isentropic efficiency";
  parameter Real eta_isen_rc = 0.85 "----------------> re-compressor isentropic efficiency";
  parameter Real eta_isen_t = 0.9 "-----------------> turbine isentropic efficiency";
  parameter Real dT_mc_approach = 6.0 "--------------------> [C/K] Temp. difference between main compressor CO2 inlet and ambient";
  parameter Real NREL_PB_configurations[13](each fixed = false);
  parameter Real T_HTF_cold_des = 550 + 273.15;
  
  //********************************* On the fly and simulation configurations
  parameter String base_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include") "Base path that points to which folder the C program is stored";
  parameter String SolarTherm_path = Modelica.Utilities.Files.loadResource("modelica://SolarTherm") "Base path of SolarTherm";
  parameter Integer PB_model = 1 "-----------------------> 0 is for CEA power block, 1 is for NREL-SAM power block";
  parameter String HTF_name = "CarboHSP";
  
  Real a;
  
  //********************************* CEA power block
initial equation
  NREL_PB_configurations = SolarTherm.Utilities.designNRELPB(
              P_net,
              T_in_ref_blk, 
              p_high, 
              dT_PHX_cold_approach,
              eta_isen_mc,
              eta_isen_rc,
              eta_isen_t,
              dT_mc_approach,
              T_amb_base, 
              HTF_name, 
              HTF_choice, 
              SolarTherm_path, 
              T_HTF_cold_des);
  
  NREL_PB_configurations[13] = dT_PHX_hot_approach;
equation
  der(a) = time;
end Test_init_NREL_PB;