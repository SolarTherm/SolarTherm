within SolarTherm.Models.Analysis.Finances;
function gasTankCost_V "Capital cost of a gas tank as a function of volume"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Volume V "Tank volume";
	output SolarTherm.Models.Analysis.Finances.Money C_cap "Capital cost";
algorithm
	//Ref. W.D. Seider et al., Product and Process Design Principles: Synthesis, Analysis and Design, 3rd Edition
	// Valid for V = 4000 to 400,000 ft3 and pressure up to 3 bar
	C_cap := 0.75 * 3170 * ((V * 35.3147)^0.43);
end gasTankCost_V;
