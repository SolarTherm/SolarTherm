within SolarTherm.Models.Analysis.Finances;
function fischerTropschCost_m_sg "Capital cost of a fischer tropsch reactor as a function of the nominal inlet mass flow rate of syngas"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.MassFlowRate m_flow "Syngas mass flow at design";
	output SolarTherm.Models.Analysis.Finances.Money C_cap "Capital cost";
protected
	constant Real p1 = 0.0;
	constant Real p2 = 59434107.603960396;
	constant Real p3 = 0.0;
	constant Real p4 = 0.0;
algorithm
	//Ref. Polynomials from A.R. ASPEN model
	C_cap := p1 + p2 * m_flow + p3 * m_flow ^ 2 + p4 * m_flow ^ 3;
end fischerTropschCost_m_sg;
