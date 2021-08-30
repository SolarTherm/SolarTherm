block TestGenEffectivenessPyFunc

function GenEffectivenessPyFunc

	input String ppath;
	input String pname;
	input String pfunc;
    input String psave;
    input String modelicapath;
	input Integer argc;
    input String varnames[:];
    input Real vars[:];
	output String result;
	external result =RunStorageFunc(ppath, pname, pfunc, psave, modelicapath, argc, varnames, vars)
	annotation(
		Library="st_storage"
	        ,LibraryDirectory="modelica://SolarTherm/Resources/Library"
      );
end GenEffectivenessPyFunc;

  parameter Real t_storage(unit = "h") = 8.0 "Hours of storage";
  parameter String ppath = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Library") "Absolute path to the Python script";
  parameter String pname = "run_storage" "Name of the Python script";
  parameter String pfunc = "get_effectiveness" "Name of the Python functiuon"; 
  parameter String psave = "effectiveness_test" "the directory for saving the results"; 
  parameter String modelicapath =  Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Models/Storage");
  parameter Integer argc =1 "Number of variables to be passed to the C function";

  parameter String table_file(fixed=false);
  Modelica.Blocks.Tables.CombiTable1Ds Table_Charging (tableOnFile=true, tableName="table_charging", columns=2:2, fileName=table_file);

  Modelica.Blocks.Tables.CombiTable1Ds Table_Discharging (tableOnFile=true, tableName="table_discharging", columns=2:2, fileName=table_file);

  Real eff_chg;
  Real eff_dischg;


initial algorithm
table_file := GenEffectivenessPyFunc(ppath, pname, pfunc, psave, modelicapath, argc, {"t_storage"}, {t_storage}); 

equation
Table_Charging.u=0.5;
Table_Discharging.u=0.5;

eff_chg=min(1.0, Table_Charging.y[1]);
eff_dischg=min(1.0, Table_Discharging.y[1]);


end TestGenEffectivenessPyFunc;


