block TestExternalC
	output Real y;

	function square
		input Real x;
		output Real y;
		external y = TestExternalC_square(x)
			//annotation(Library="st_test_ext");
			annotation(Include="#include \"st_test_ext.c\"");
		// Because is not under SolarTherm it won't look there, but in default
		// locations and in ./Resources/Library under current directory.
	end square;
equation
	y = square(time);
	//annotation(experiment(StartTime=0.0, StopTime=4.0, Interval=0.01, Tolerance=1e-06));
end TestExternalC;
