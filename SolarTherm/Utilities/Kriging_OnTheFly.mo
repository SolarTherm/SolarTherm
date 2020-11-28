within SolarTherm.Utilities;

package Kriging_OnTheFly
  class Kriging_properties
    extends ExternalObject;
  
    function constructor
      input Real P_net "Net power of the sCO2 power blocl at the design point";
      input Real T_in_ref_blk "Temperature of the hot tank at the design point";
      input Real p_high "Compressor pressure at the design point";
      input Real PR "Pressure ratio (p_high / p_turbine)";
      input Real pinch_PHX "Pinch point of the sCO2 primary heat exchanger";
      input Real dTemp_HTF_PHX "delta temperature between the hot tank and cold tank at the design point";
      input Real load_base "full load condition. Usually = 1. Load is defined as mass flow rate of the particle to the primary heat exchanger at the operational hour divided at the design point";
      input Real T_amb_base "Ambient temperature [K] at the design point";
      input Real eta_gross_base "Design point gross efficiency of the sCO2 PB. Design point gross efficiency = (W_turbine-W_compressors - W_cooler) /  Q_HX_des";
      input Real eta_Q_base "Primary HX efficiency at the design point. Usually the value close to 1"; 
      input String base_path "Path to the directory where the C program is stored. Default value: SolarTherm/Resources/Include";
      input String SolarTherm_path;
      input Integer inputsize "Input size to the Kriging Model. Usually it is 3: load, T_HTF_in, T_amb";
      input Integer outputsize "Output size of the Kriging Model. Usually it is 2: eta_gross and eta_Q at during operation";
      input Real tolerance_kriging "Tolerance -> stop criterion of the Kriging Model validation";
      input Integer PB_model "User choice PB model: 0 is for CEA model, 1 is for NREL model";
      input Integer htf_choice "put 50 for user defined HTF properties";
      input Real dT_PHX_hot_approach "Temperature difference between incoming HTF and outlet sCO2 at design point at the heat exchanger";
      input Real dT_PHX_cold_approach "Temperature difference between outgoing HTF and incoming sCO2 at design point";
      input Real eta_isen_mc "Main compressor isentropic efficiency at design point";
      input Real eta_isen_rc "Recompressor isentropic efficiency at design point";
      input Real eta_isen_t "Turbine isentropic efficiency at design point";
      input Real dT_mc_approach "Tempereature difference between ambient and cooler output at design point";
      input String HTF_name "user defined HTF name. The properties csv must be stored in modelica://SolarTherm/Data/<HTF_name>/props_for_NREL_PB.csv";
      output Kriging_properties Kriging_variables "Object that contains Kriging matrix, kriging parameter such as Sill, Nugget, Rang, Scalers: Max and Min data, and all base values";
      external "C" Kriging_variables = constructKriging(
                          P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,load_base,T_amb_base, 
                          eta_gross_base,eta_Q_base,base_path, SolarTherm_path,inputsize, outputsize,tolerance_kriging,PB_model,
                          htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
                          HTF_name
                          ); 
                annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
                Include="#include \"st_on_the_fly_surrogate.c\"",
                Library = {"m","gsl","gslcblas","python2.7","tensorflow","dl","ssc"},
                LibraryDirectory="modelica://SolarTherm/Resources/SSC"
                );
    end constructor;
  
    function destructor
     input Kriging_properties Kriging_variables;
     external "C" destructKriging(Kriging_variables)
      annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
                Include="#include \"st_on_the_fly_surrogate.c\"",
                Library = {"m","gsl","gslcblas","python2.7","tensorflow","dl","ssc"},
                LibraryDirectory="modelica://SolarTherm/Resources/SSC"
                );
    end destructor;
  end Kriging_properties;

  function OTF_Kriging_interpolate
    input Kriging_properties Kriging_variables;
    input Real raw_inputs[:];
    input String which_eta;
    input String variogram_model;
    output Real out;
    external "C" out = predict_Kriging(
                       Kriging_variables,
                       raw_inputs,
                       which_eta,
                       variogram_model
                       );
    annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
                Include="#include \"st_on_the_fly_surrogate.c\"",
                Library = {"m","gsl","gslcblas","python2.7","tensorflow","dl","ssc"},
                LibraryDirectory="modelica://SolarTherm/Resources/SSC"
                );
  end OTF_Kriging_interpolate;
end Kriging_OnTheFly;
