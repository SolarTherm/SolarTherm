within SolarTherm.Models.Analysis.Finances;
function massNickel_ft_m_sg "Mass of Nickel/Aluminum Oxide catalyst required in FT for a three-year of operation as a function of the nominal inlet mass flow rate of syngas"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.MassFlowRate m_flow "Syngas mass flow at design";
	output SI.Mass m_nickel "Mass of Nickel/Aluminum Oxide catalyst required in FT at design";
protected
	constant Real p1 = -0.024312165460329;
	constant Real p2 = 0.163834353981065;
	constant Real p3 = -0.328625657660620;
	constant Real p4 = 1.004096443438880e03;
	constant Real p5 = -0.036432683842489;

algorithm
	//Ref. Polynomials from A.R. ASPEN model
	m_nickel := p1*m_flow^4 + p2*m_flow^3 + p3*m_flow^2 + p4*m_flow + p5;
end massNickel_ft_m_sg;
