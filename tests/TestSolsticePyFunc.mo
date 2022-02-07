block TestSolsticePyFunc

  import SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticePyFunc;

  parameter String ppath = 
      Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Library")
      "Absolute path to the Python script";
  parameter String pname = "run_solstice" "Name of the Python script";
  parameter String pfunc = "run_simul" "Name of the Python functiuon"; 
  parameter String psave = "Test_SolsticePyFunc";    
  parameter String field_type = "polar" "Other options are : surround";
  parameter String rcv_type = "flat" "other options are : flat, cylinder, stl";  
  parameter String wea_file = 
      Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter String fluxlimitpath = "None" "path to load the flux limit file (not used in this test)";  
  parameter Integer argc = 6 "Number of variables to be passed to the C function";
  parameter Integer n_helios=20 "Number of heliostats";
  parameter Real H_tower=200 "Tower height";
  parameter Real W_helio=10 "Height of a heliostat";
  parameter Real H_helio=10 "Width of a heliostat";
  parameter Real H_rcv=24.789 "height of the receiver";
  parameter Real W_rcv=24.789 "width of the receiver";
    parameter String sunshape = "buie" "buie or pillbox sunshape";  
    parameter Real sunshape_param = 0.02 "csr for buie sunshape or angular size for pillbox (in deg)"; 

  parameter String tablefile(fixed=false);
  Real nu;

  Modelica.Blocks.Tables.CombiTable2D nu_table(
    tableOnFile=true,
    tableName="optics",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=tablefile
  );

initial algorithm
  tablefile := SolsticePyFunc(ppath, pname, pfunc, psave
    , field_type, rcv_type, wea_file, sunshape, fluxlimitpath, argc
    , {"n_helios","H_tower", "W_helio", "H_helio", "H_rcv", "W_rcv", "sunshape_param"}
    , {n_helios, H_tower, W_helio, H_helio, H_rcv, W_rcv, sunshape_param}
  );

equation

  nu_table.u1=0;
  nu_table.u2=0;
  nu=max(0, nu_table.y);

end TestSolsticePyFunc;

// vim: ts=2:sw=2:et 
