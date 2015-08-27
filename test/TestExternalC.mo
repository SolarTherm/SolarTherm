block TestExternalC
	output Real y;

	function square
		input Real x;
		output Real y;
		external y = TestExternalC_square(x) annotation(Library="solartherm_test");
	end square;
equation
	y = square(time);
end TestExternalC;
