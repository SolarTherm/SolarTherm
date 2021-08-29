block TestExternalPyStr
	output Integer y;

	function pyRunString
		input String s;
		output Integer out;
		external out = myextfunc(s)
			annotation(Library="st_test_ext_py_str");
			//	,Include="#include \"st_test_ext_py_str.h\"");
			//annotation(Library="python3.8",
			//	//IncludeDirectory="modelica://SolarTherm/Resources/Include",
			//	Include="#include \"st_test_ext_py_str.c\"");
	end pyRunString;
equation
	y = pyRunString("print (" + String(time) + ")");
	//annotation(experiment(StartTime=0.0, StopTime=4.0, Interval=1, Tolerance=1e-06));
end TestExternalPyStr;
