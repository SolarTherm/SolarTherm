within SolarTherm.Models.Analysis.Finances;
function massPlatinum_ft_m_sg "Mass of Platinum catalyst required in FT for a three-year of operation as a function of the nominal inlet mass flow rate of syngas"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.MassFlowRate m_flow "Syngas mass flow at design";
	output SI.Mass m_platinum "Mass of Cobalt catalyst required in FT at design";
protected
	constant Real p1 = -0.020598556194049;
	constant Real p2 = 0.147611987351198;
	constant Real p3 = -0.331153000124054;
	constant Real p4 = 7.425703372352051e02;
	constant Real p5 = -0.065114037948762;

algorithm
	//Ref. Polynomials from A.R. ASPEN model
	m_platinum := p1*m_flow^4 + p2*m_flow^3 + p3*m_flow^2 + p4*m_flow + p5;
end massPlatinum_ft_m_sg;
