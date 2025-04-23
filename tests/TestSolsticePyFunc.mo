block TestSolsticePyFunc
  import SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticePyFunc;
  import SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticeStatusFunc;   
  import SI = Modelica.SIunits;

  parameter String ppath = 
      Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Library")
      "Absolute path to the Python script";
  parameter String pname = "run_solstice" "Name of the Python script"; // FIXME can't we remove this?
  parameter String psave = "Test_SolsticePyFunc"; // FIXME can't we remove this?
  parameter String field_type = "polar" "Other options are : surround";
  parameter String rcv_type = "flat" "other options are : flat, cylinder, stl";  
  parameter String wea_file = 
      Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter Integer argc = 8 "Number of variables to be passed to the C function";
  parameter SI.HeatFlowRate Q_in_rcv = 56e6 "Incident energy to the reciever";
  parameter Real H_tower=120 "Tower height";
  parameter Real H_rcv=12 "height of the receiver";
  parameter Real W_rcv=12 "width of the receiver";
  parameter Real fb=0.5 "Field blocking factor";
  parameter Real R1=50 "Distance from first row heliostat to the bottom of tower";
  parameter Real n_col_oelt=5 "Number of column of oelt";
  parameter Real n_row_oelt=3 "Number of row of oelt";  

  parameter String tablefile(fixed=false);
  parameter Integer tablefile_status(fixed=false);

  Real nu;

  Modelica.Blocks.Tables.CombiTable2D nu_table(
    tableOnFile=true,
    tableName="optics",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=tablefile
  );

initial algorithm
  tablefile_status := SolsticePyFunc(ppath, pname, psave
    , field_type, rcv_type, wea_file, argc
    , {"Q_in_rcv","H_tower", "H_rcv", "W_rcv", "fb", "R1", "n_col_oelt","n_row_oelt"}
    , {Q_in_rcv, H_tower, H_rcv, W_rcv, fb, R1, n_col_oelt, n_row_oelt}
  );

  tablefile := SolsticeStatusFunc(tablefile_status, psave);

equation

  nu_table.u1=0;
  nu_table.u2=0;
  nu=max(0, nu_table.y);

end TestSolsticePyFunc;

// vim: ts=2:sw=2:et 
