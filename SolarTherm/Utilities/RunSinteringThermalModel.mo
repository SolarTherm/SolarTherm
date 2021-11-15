within SolarTherm.Utilities;

function RunSinteringThermalModel
  input String ppath;
  input String pname;
  input String SolarTherm_path;
  input String modelica_wd;
  input String varnames[:];
  input Real vars[:];
  output Integer result;
  external result = run_sintering_thermal_model(ppath, pname, SolarTherm_path, modelica_wd,varnames, vars)
  annotation(Library="python2.7",
      IncludeDirectory="modelica://SolarTherm/Resources/Include",
      Include="
          #include \"run_sintering.c\"
          #include \"ascend_models/ascend_utils.c\"
          "
  );

end RunSinteringThermalModel;