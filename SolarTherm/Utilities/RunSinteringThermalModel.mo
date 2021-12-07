within SolarTherm.Utilities;

function RunSinteringThermalModel
  input String SolarTherm_path;
  input String solstice_wd;
  input Real vars[:];
  input String opt_file;
  input String iron_sample;
  output Integer result;
  external result = run_sintering_thermal_model_off_design(SolarTherm_path, solstice_wd, vars, opt_file, iron_sample)
  annotation(Library="python2.7",
      IncludeDirectory="modelica://SolarTherm/Resources/Include",
      Include="
          #include \"run_sintering.c\"
          #include \"ascend_models/ascend_utils.c\"
          "
  );

end RunSinteringThermalModel;
