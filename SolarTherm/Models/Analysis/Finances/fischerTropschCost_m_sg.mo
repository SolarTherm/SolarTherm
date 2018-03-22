within SolarTherm.Models.Analysis.Finances;
function fischerTropschCost_m_sg "Capital cost of a fischer tropsch reactor as a function of the nominal inlet mass flow rate of syngas"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.MassFlowRate m_flow "Syngas mass flow at design";
	output SolarTherm.Models.Analysis.Finances.Money C_cap "Capital cost";
protected
	constant Real p1 = -2.097693229607164e04;
	constant Real p2 = 2.662718352761091e05;
	constant Real p3 = -1.417794142739832e06;
	constant Real p4 = 5.633314709594577e07;
	constant Real p5 = 1.169034034339705e06;

algorithm
	//Ref. Polynomials from A.R. ASPEN model
	C_cap := p1*m_flow^4 + p2*m_flow^3 + p3*m_flow^2 + p4*m_flow + p5;
end fischerTropschCost_m_sg;
