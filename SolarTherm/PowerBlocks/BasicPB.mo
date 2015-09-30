within SolarTherm.PowerBlocks;
model BasicPB "Basic power block model"
	extends SolarTherm.PowerBlocks.PowerBlock;
	import SI = Modelica.SIunits;

	parameter SI.Pressure p_set_outlet = 100000 "Set point p of outlet";
	parameter SI.Temperature T_set_outlet = 300 "Set point T of outlet";

	Medium.BaseProperties mprop_b;
equation
	mprop_b.T = T_set_outlet;
	mprop_b.p = p_set_outlet;
	port_b.p = p_set_outlet;
	port_b.h_outflow = mprop_b.h;
	port_a.h_outflow = inStream(port_b.h_outflow);

	P_out = port_a.m_flow*(inStream(port_a.h_outflow) - port_b.h_outflow);

	port_b.p = port_a.p; // Need to build pressure drop into PB
end BasicPB;
