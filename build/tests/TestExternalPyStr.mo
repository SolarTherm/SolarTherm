block TestExternalPyStr
	output Integer y;

	function pyRunString
		input String s;
		output Integer out;
		external out = TestExternalPy_string(s)
		annotation(Library="python2.7",
			//IncludeDirectory="modelica://SolarTherm/Resources/Include",
			Include="#include \"st_test_ext_py_str.c\""
			);
	end pyRunString;
equation
	y = pyRunString("print " + String(time) + "");
	//annotation(experiment(StartTime=0.0, StopTime=4.0, Interval=1, Tolerance=1e-06));
end TestExternalPyStr;
