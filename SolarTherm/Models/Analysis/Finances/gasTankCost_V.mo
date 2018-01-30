within SolarTherm.Models.Analysis.Finances;
function gasTankCost_V "Capital cost of a gas tank as a function of volume"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Volume V "Tank volume";
	output SolarTherm.Models.Analysis.Finances.Money C_cap "Capital cost";
protected
	parameter Real ci_present = 562.1 "Chemical engineering plant cost index (CI) at present"; //i.e. 2017 Ref: http://www.chemengonline.com/
	parameter Real ci_ref = 548.4 "Chemical engineering plant cost index (CI) at the reference year"; //i.e. 2008 Ref: http://www.chemengonline.com/
	parameter Real uf = ci_present/ci_ref "Update factor";
algorithm
	//Ref. W.D. Seider et al., Product and Process Design Principles: Synthesis, Analysis and Design, 3rd Edition 2008
	// Valid for V = 4000 to 400,000 ft3 and pressure up to 3 bar
	C_cap := 0.799 * 3170 * ((V * 35.3147)^0.43) * uf; // The currency rate from USD to AUD (i.e. 0.799) is valid for Jan 2018.
end gasTankCost_V;
