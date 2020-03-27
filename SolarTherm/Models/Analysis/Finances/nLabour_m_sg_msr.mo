within SolarTherm.Models.Analysis.Finances;
function nLabour_m_sg_msr "Number of operators required to work at the whole solar fuel plant (with MSR) as a function of the nominal inlet mass flow rate of syngas"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.MassFlowRate m_flow "Syngas mass flow at design";
	output Integer n_labour "Number of operators";
protected
	constant Real p1 = 41.697952124521152;
	constant Real p2 = -1.466194390179329e-04;

algorithm
	//Ref. Polynomials from A.R. ASPEN model and from Table 23.3 on page 611 of "PRODUCT AND PROCESS DESIGN PRINCIPLES" book by Seider et al.
	n_labour := integer(ceil(p1*m_flow + p2));
end nLabour_m_sg_msr;
