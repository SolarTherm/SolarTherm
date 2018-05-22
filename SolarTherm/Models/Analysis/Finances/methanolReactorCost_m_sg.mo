within SolarTherm.Models.Analysis.Finances;
function methanolReactorCost_m_sg "Capital cost of a methanol synthesis reactor as a function of the nominal inlet mass flow rate of syngas"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.MassFlowRate m_flow "Syngas mass flow at design";
	output SolarTherm.Models.Analysis.Finances.Money C_cap "Capital cost";
protected
	constant Real p1 = -9.876714455835060e04;
	constant Real p2 = 1.040534345486721e06;
	constant Real p3 = -4.511406081277338e06;
	constant Real p4 = 2.530862369919860e07;
	constant Real p5 = 1.842831792081892e06;

algorithm
	//Ref. Polynomials from A.R. ASPEN model
	C_cap := p1*m_flow^4 + p2*m_flow^3 + p3*m_flow^2 + p4*m_flow + p5;
end methanolReactorCost_m_sg;
