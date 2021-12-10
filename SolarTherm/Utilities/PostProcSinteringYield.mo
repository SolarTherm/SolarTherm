within SolarTherm.Utilities;

function PostProcSinteringYield
  input String solstice_wd;
  input String SolarTherm_path;
  input String dummy_file;
  input Integer dummy_status_run_off;
  output Integer status_run;
  external "C" status_run = post_processing(solstice_wd, SolarTherm_path, dummy_file, dummy_status_run_off)
  annotation(Library="python2.7",
      IncludeDirectory="modelica://SolarTherm/Resources/Include",
      Include="
          #include \"run_sintering.c\"
          #include \"ascend_models/ascend_utils.c\"
          "
  );

end PostProcSinteringYield;