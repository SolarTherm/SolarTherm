within SolarTherm.Utilities;
package Polynomial
block Poly "Polynomial model"
	parameter Real c[:] "Coefficiencts";

	input Real x;
	output Real y;
equation
	y = sum(c[i]*x^(i-1) for i in 1:size(c,1));
end Poly;
end Polynomial;
