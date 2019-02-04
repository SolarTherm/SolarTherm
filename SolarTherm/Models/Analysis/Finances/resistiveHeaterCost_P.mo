within SolarTherm.Models.Analysis.Finances;
function resistiveHeaterCost_P "Bare module cost of a resistive hater"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Power P "Power to heater at design";
	output SolarTherm.Models.Analysis.Finances.Money C_cap "Capital cost";
protected
	constant Real p1 = 0.004112986371710;
	constant Real p2 = 0.092159354785374;

algorithm
	//Ref. Polynomials from M.V. Python model
	C_cap := p1*P + p2;
end resistiveHeaterCost_P;



