within SolarTherm.Utilities;

function designNRELPB
  import SI = Modelica.SIunits;
  input SI.Power P_net;
  input SI.Temperature T_in_ref_blk;
  input SI.Pressure p_high;
  input SI.TemperatureDifference dT_PHX_cold_approach;
  input SI.Efficiency eta_isen_mc;
  input SI.Efficiency eta_isen_rc;
  input SI.Efficiency eta_isen_t;
  input SI.TemperatureDifference dT_mc_approach;
  input SI.TemperatureDifference T_amb_base;
  input String HTF_name;
  input Integer HTF_choice;
  input String SolarTherm_path;
  input SI.Temperature T_HTF_cold_des;
  output Real out[13]; 
  
  external "C" initNRELPB(
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
    T_HTF_cold_des, 
    out
    );
    
    /*annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
                Include="#include \"st_on_the_fly_surrogate.c\"",
                Library = {"m","gsl","gslcblas","python2.7","tensorflow","dl","ssc"},
                LibraryDirectory="modelica://SolarTherm/Resources/SSC"
                );*/
	annotation(Library = "st_surrogate_on_the_fly");
end designNRELPB;
