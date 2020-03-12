block TestSolsticePyFunc
	function RunPyFunction
		input String ppath;
		input String pname;
		input String pfunc;
        input String psave;
		input Integer argc;
        input String varnames[:];
        input Real vars[:];
		output String result;
		external result =RunSolsticeFunc(ppath, pname, pfunc, psave, argc, varnames, vars)
		annotation(Library="python2.7",
			IncludeDirectory="modelica://SolarTherm/Resources/Include",
			Include="#include \"run_py_func.c\""
			);
	end RunPyFunction;

	parameter String ppath = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include/SolsticePy") "Absolute path to the Python script";
	parameter String pname = "run_solstice" "Name of the Python script";
	parameter String pfunc = "run_simul" "Name of the Python functiuon"; 
    parameter String psave = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include/SolsticePy/result/demo") "the directory for saving the results";    
	parameter Integer argc = 6 "Number of variables to be passed to the C function";
    parameter Integer n_heliostat=20 "Number of heliostats";
    parameter Real H_tower=200 "Tower height";
    parameter Real W_heliostat=10 "Height of a heliostat";
    parameter Real H_heliostat=10 "Width of a heliostat";
    parameter Real rec_h=24.789 "height of the receiver";
    parameter Real rec_w=24.789 "width of the receiver";

    parameter String tablefile(fixed=false);
    Real nu;

  Modelica.Blocks.Tables.CombiTable2D nu_table(
    tableOnFile=true,
    tableName="optics",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=tablefile);

initial algorithm
tablefile := RunPyFunction(ppath, pname, pfunc, psave, argc, {"n_heliostat","H_tower", "W_heliostat", "H_heliostat", "rec_h", "rec_w"}, {n_heliostat, H_tower, W_heliostat, H_heliostat, rec_h, rec_w});

equation
nu_table.u1=0;
nu_table.u2=0;
nu=max(0, nu_table.y);


end TestSolsticePyFunc;


