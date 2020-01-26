within SolarTherm.Models.Analysis.Finances;
function massCobalt_ft_m_sg "Mass of Cobalt catalyst required in FT for a three-year of operation as a function of the nominal inlet mass flow rate of syngas"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.MassFlowRate m_flow "Syngas mass flow at design";
	output SI.Mass m_cobalt "Mass of Cobalt catalyst required in FT at design";
protected
	constant Real p1 = 1.752095084592045;
	constant Real p2 = -11.294971280220974;
	constant Real p3 = 20.874688281356008;
	constant Real p4 = 6.814171157369776e02;
	constant Real p5 = 12.340067812222916;

algorithm
	//Ref. Polynomials from A.R. ASPEN model
	m_cobalt := p1*m_flow^4 + p2*m_flow^3 + p3*m_flow^2 + p4*m_flow + p5;
end massCobalt_ft_m_sg;
