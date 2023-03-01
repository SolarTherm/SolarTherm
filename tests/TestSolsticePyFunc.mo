block TestSolsticePyFunc

  function RunPyFunction
    input String ppath;
    input String pname;
    input String pfunc;
    input String psave;
    input String field_type;
    input String rcv_type;
    input String wea_file;
    input Integer argc;
    input String varnames[:];
    input Real vars[:];
    output String result;
    // FIXME let's update RunSolsticeFunc so that it doesn't need pname, pfunc and ideally psave?
    // Having to pass ppath is perhaps unavoidable, on the othe hand.
    external result = RunSolsticeFunc(ppath, pname, pfunc, psave, field_type, rcv_type, wea_file, argc, varnames, vars)
      annotation(
        Library="st_solsticepy"
        ,LibraryDirectory="modelica://SolarTherm/Resources/Library"
      );
      //	IncludeDirectory="modelica://SolarTherm/Resources/Include",
      //	Include="#include \"run_py_func.c\""
      //	);
  end RunPyFunction;

  parameter String ppath = 
      Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Library")
      "Absolute path to the Python script";
  parameter String pname = "run_solstice" "Name of the Python script"; // FIXME can't we remove this?
  parameter String pfunc = "run_simul" "Name of the Python functiuon"; // FIXME can't we remove this?
  parameter String psave = "Test_SolsticePyFunc"; // FIXME can't we remove this?
  parameter String field_type = "polar" "Other options are : surround";
  parameter String rcv_type = "flat" "other options are : flat, cylinder, stl";  
  parameter String wea_file = 
      Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter Integer argc = 6 "Number of variables to be passed to the C function";
  parameter Integer n_helios=20 "Number of heliostats";
  parameter Real H_tower=200 "Tower height";
  parameter Real W_helio=10 "Height of a heliostat";
  parameter Real H_helio=10 "Width of a heliostat";
  parameter Real H_rcv=24.789 "height of the receiver";
  parameter Real W_rcv=24.789 "width of the receiver";

  parameter String tablefile(fixed=false);
  Real nu;

  Modelica.Blocks.Tables.CombiTable2D nu_table(
    tableOnFile=true,
    tableName="optics",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=tablefile
  );

initial algorithm
  tablefile := RunPyFunction(ppath, pname, pfunc, psave
    , field_type, rcv_type, wea_file, argc
    , {"n_helios","H_tower", "W_helio", "H_helio", "H_rcv", "W_rcv"}
    , {n_helios, H_tower, W_helio, H_helio, H_rcv, W_rcv}
  );

equation

  nu_table.u1=0;
  nu_table.u2=0;
  nu=max(0, nu_table.y);

end TestSolsticePyFunc;

// vim: ts=2:sw=2:et 
