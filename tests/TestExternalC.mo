block TestExternalC
	output Real y;

	function square
		input Real x;
		output Real y;
		external y = TestExternalC_square(x)
			annotation(Library="st_test_ext");
		// Because is not under SolarTherm it won't look there, but in default
		// locations and in ./Resources/Library under current directory.
	end square;
equation
	y = square(time);
end TestExternalC;
