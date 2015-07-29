within SolarTherm.Test;
block TestExternalC
	output Real y;

	function ExternalFunc
		input Real x;
		output Real y;
		external y=TestExternalC_func(x) annotation(Library="solartherm_test");
	end ExternalFunc;
equation
	y = ExternalFunc(time);
end TestExternalC;
