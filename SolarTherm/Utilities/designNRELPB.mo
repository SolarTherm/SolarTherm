within SolarTherm.Utilities;

function designNRELPB
  input Real P_net;
  input Real T_in_ref_blk;
  input Real p_high;
  input Real dT_PHX_hot_approach;
  input Real dT_PHX_cold_approach;
  input Real eta_isen_mc;
  input Real eta_isen_rc;
  input Real eta_isen_t;
  input Real dT_mc_approach;
  input Real T_amb_base;
  input String HTF_name;
  input String SolarTherm_path;
  output Real out[12]; 
  
  external "C" initNRELPB(
    P_net,
    T_in_ref_blk,
    p_high,
    dT_PHX_hot_approach,
    dT_PHX_cold_approach,
    eta_isen_mc,
    eta_isen_rc,
    eta_isen_t,
    dT_mc_approach,
    T_amb_base,
    HTF_name,
    SolarTherm_path,
    out);
    
    annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
                Include="#include \"st_on_the_fly_surrogate.c\"",
                Library = {"m","gsl","gslcblas","python2.7","tensorflow","dl","ssc"},
                LibraryDirectory="file:///home/philgun/SAM/2020.2.29/linux_64"
                );
end designNRELPB;