within SolarTherm.Utilities;
function func_1
input String opt_file; //dummy input s.t. modelica knows the order of the calling func
input Integer status_run_postproc; //dummy input s.t. modelica knows the order of the calling func 
input String casefolder;
input Integer idx;

output String fn;
algorithm
  fn := Modelica.Utilities.Files.loadResource(casefolder +"/flux_map_DNI_" + String(idx) + ".motab");
end func_1;