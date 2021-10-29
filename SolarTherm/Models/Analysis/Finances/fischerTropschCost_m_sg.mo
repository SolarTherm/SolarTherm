within SolarTherm.Models.Analysis.Finances;
function fischerTropschCost_m_sg "Capital cost of a fischer tropsch reactor as a function of the nominal inlet mass flow rate of syngas"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.MassFlowRate m_flow "Syngas mass flow at design";
	output SolarTherm.Models.Analysis.Finances.Money C_cap "Capital cost";
	output Real fr[8] "Components cost fraction";
protected
	constant Real p1 = -1.700705766728789e05;
	constant Real p2 = 1.754191346635879e06;
	constant Real p3 = -7.198859432890602e06;
	constant Real p4 = 3.070965942719981e07;
	constant Real p5 = 2.919574276993031e06;

	constant Real a[8] = {1.954599064179756, -0.040946656515895, 3.468781642234624e-04, 0.013378350845173,
		-3.730200321551914e-04, -0.125484642971228, -4.183323984833677e-05, 0.045966150251920};
		// 1: Compressor, 2: Turbine, 3: Mixer/Splitters, 4: HX, 5: FT, 6: Hydro, 7: SMR, 8: Sepr
	constant Real b[8] = {0.026470199924860, 0.085546866799363, -0.821234414365821, -0.845787456706915,
		2.088367754438455, 0.301981378759563, -1.944617179680414,  0.152339430679951};
	constant Real c[8] = {-1.661953569504096, 0.064594332468978, 4.133717587866804e-04, 0.085834046544145,
		0.093957067876861, 0.566231332398198, 0.021907782637993, -0.017815478521895};

algorithm
	//Ref. Polynomials from A.R. ASPEN model
	C_cap := p1*m_flow^4 + p2*m_flow^3 + p3*m_flow^2 + p4*m_flow + p5;
	for i in 1:size(fr, 1) loop
		fr[i] := a[i]*m_flow^b[i]+c[i];
	end for;
end fischerTropschCost_m_sg;
