within SolarTherm.Test;
block TestExternalC
	output Real y;

	function Square
		input Real x;
		output Real y;
		external y=TestExternalC_square(x) annotation(Library="solartherm_test");
	end Square;
equation
	y = Square(time);
end TestExternalC;
