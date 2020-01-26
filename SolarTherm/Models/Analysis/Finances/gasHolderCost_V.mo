within SolarTherm.Models.Analysis.Finances;
function gasHolderCost_V "Capital cost of a gas holder as a function of volume"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Volume V "Tank volume";
	output SolarTherm.Models.Analysis.Finances.Money C_cap "Capital cost in AUD";
protected
	parameter Real ci_present =  556.8 "Chemical engineering plant cost index (CI) at present"; //i.e. 2016 Ref: http://www.chemengonline.com/
	parameter Real ci_ref = 548.4 "Chemical engineering plant cost index (CI) at the reference year"; //i.e. 2008 Ref: http://www.chemengonline.com/
	parameter Real uf = ci_present/ci_ref "Update factor";
	parameter Real r_cur = 0.7617 "The currency rate from AUD to USD"; //Valid for June 2016: 1 USD = 0.7617 AUD
algorithm
	//Ref. Table 22.32 page 595 in  W.D. Seider et al., Product and Process Design Principles: Synthesis, Analysis and Design, 3rd Edition 2008
	// Low pressure gas holder: valid for V = 4000 to 400,000 ft3 and pressure up to 3 psig
	C_cap := 3170 * ((V * 35.3147)^0.43) * uf / r_cur;
end gasHolderCost_V;
