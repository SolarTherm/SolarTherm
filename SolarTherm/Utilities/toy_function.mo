within SolarTherm.Utilities;

function toy_function
input Real hf;
input Real hp;
output Real[2] res;

external "C" toyfunction(
                  hf,hp,res
              )
           annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
           Include=  "#include \"toy_function.c\"");

end toy_function;