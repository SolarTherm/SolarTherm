within SolarTherm.Utilities;

function sigmoid_regression
input String ppath;
input String pname;
input String pfunc;
input Integer N;
input Real T[:];
input Real u_flow;
output Real out[4];

external "C" sigmoidRegression(
                  ppath,
                  pname,
                  pfunc,
                  N,
                  T,
                  u_flow,
                  out
              )
           annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
           Include=  "#include \"sigmoidRegression.c\"",
           Library = "python2.7");

end sigmoid_regression;