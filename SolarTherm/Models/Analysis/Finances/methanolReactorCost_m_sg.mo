within SolarTherm.Models.Analysis.Finances;
function methanolReactorCost_m_sg "Capital cost of a methanol synthesis reactor as a function of the nominal inlet mass flow rate of syngas"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.MassFlowRate m_flow "Syngas mass flow at design";
	output SolarTherm.Models.Analysis.Finances.Money C_cap "Capital cost";
	output Real fr[6] "Components cost fraction";
protected
	constant Real p1 = -9.876714455835060e04;
	constant Real p2 = 1.040534345486721e06;
	constant Real p3 = -4.511406081277338e06;
	constant Real p4 = 2.530862369919860e07;
	constant Real p5 = 1.842831792081892e06;

	constant Real a[6] = {-0.657119412372057, 4.342253291982460e-04, 0.008010634118654, 0.001619651441952,
		-0.288602827553465, -0.053247945462926};
		// 1: Compressor, 2: Mixer/Splitters, 3: Sepr, 4: HX, 5: MSR, 6: Dist
	constant Real b[6] = {-0.096953634986102, -0.833256784710221, -0.889637680941088, -0.441235371212157,
		0.159289359059493, 0.159289756220512};
	constant Real c[6] = {1.179578296587748, 1.715089881209413e-06, 0.011099302103676, 0.008109420596071,
		0.671504204379020, 0.123894383620589};

algorithm
	//Ref. Polynomials from A.R. ASPEN model
	C_cap := p1*m_flow^4 + p2*m_flow^3 + p3*m_flow^2 + p4*m_flow + p5;
	for i in 1:size(fr, 1) loop
		fr[i] := a[i]*m_flow^b[i]+c[i];
	end for;
end methanolReactorCost_m_sg;
