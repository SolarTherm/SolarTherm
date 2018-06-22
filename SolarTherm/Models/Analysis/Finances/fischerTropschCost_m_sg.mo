within SolarTherm.Models.Analysis.Finances;
function fischerTropschCost_m_sg "Capital cost of a fischer tropsch reactor as a function of the nominal inlet mass flow rate of syngas"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.MassFlowRate m_flow "Syngas mass flow at design";
	output SolarTherm.Models.Analysis.Finances.Money C_cap "Capital cost";
protected
	constant Real p1 = -1.700705766728789e05;
	constant Real p2 = 1.754191346635879e06;
	constant Real p3 = -7.198859432890602e06;
	constant Real p4 = 3.070965942719981e07;
	constant Real p5 = 2.919574276993031e06;

algorithm
	//Ref. Polynomials from A.R. ASPEN model
	C_cap := p1*m_flow^4 + p2*m_flow^3 + p3*m_flow^2 + p4*m_flow + p5;
end fischerTropschCost_m_sg;
