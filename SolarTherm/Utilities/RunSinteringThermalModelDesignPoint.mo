within SolarTherm.Utilities;

function RunSinteringThermalModelDesignPoint
  input String ppath;
  input String pname;
  input String pfunc;
  input String SolarTherm_path;
  input String modelica_wd;
  input String varnames[:];
  input Real vars[:];
  input Integer argc;
  output Real result;
  external result = run_sintering_thermal_model_designpoint(ppath, pname, pfunc, SolarTherm_path, modelica_wd, varnames, vars, argc)
  annotation(Library="python2.7",
      IncludeDirectory="modelica://SolarTherm/Resources/Include",
      Include="
          #include \"run_sintering.c\"
          #include \"ascend_models/ascend_utils.c\"
          "
  );

end RunSinteringThermalModelDesignPoint;