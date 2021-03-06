block TestExternalPyFunc
	output Real y;
	//parameter String ppath = "./" "Path to the Python script"; // This will be the OM working directory if run from OMedit.
		// It will point to ".../solartherm/tests" if run via terminal.
	parameter String ppath = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include") "Absolute path to the Python script";
	parameter String pname = "st_test_ext" "Python script name";
	parameter String pfunc = "testExternalPy_multiply" "Python functiuon name"; // i.e. c = a* b
	parameter Integer argc = 5 "Number of arguments to be passed to the C function";

	function pyRunFunction
		input Integer argc;
		input String argsv[:];
		output Real out;
		external out = TestExternalPy_func(argc, argsv)
		annotation(Library="python2.7",
			//IncludeDirectory="modelica://SolarTherm/Resources/Include",
			Include="#include \"st_test_ext_py_func.c\""
			);
	end pyRunFunction;
equation
	y = pyRunFunction(argc,{ppath,pname, pfunc, String(time), String(time)});
end TestExternalPyFunc;
