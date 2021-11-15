within SolarTherm.Utilities;

function InterpolateSinteringThermalModel
  input String ppath;
  input String pname;
  input String pfunc;
  input String modelica_wd;
  input Real declination;
  input Real sun_hour_angle;
  input Real flux_multiple_off;
  output Real result;
  external result = interpolate_sintering_thermal_model(ppath, pname, pfunc, modelica_wd, declination, sun_hour_angle, flux_multiple_off)
  annotation(Library="python2.7",
      IncludeDirectory="modelica://SolarTherm/Resources/Include",
      Include="
          #include \"run_sintering.c\"
          #include \"ascend_models/ascend_utils.c\"
          "
  );

end InterpolateSinteringThermalModel;