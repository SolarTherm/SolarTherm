within SolarTherm.Utilities;

function storage_regression
input String ppath;
input String pname;
input String pfunc;
input String wd;
input String fn_mo;
input Real T_max;
input Real T_min;
input Real eta;
input Real d_p;
input Real E_max;
input Real t_storage;
input Real ar;

output Real regression_params[15];

external "C" storageRegression(
                  ppath,
                  pname,
                  pfunc,
                  wd,
                  fn_mo,
                  T_max,
                  T_min,
                  eta,
                  d_p,
                  E_max,
                  t_storage,
                  ar,
                  regression_params
              )
           annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
           Include=  "#include \"st_surrogate_packed_bed_storage.c\"",
           Library = "python2.7");

end storage_regression;