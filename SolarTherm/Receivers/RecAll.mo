within SolarTherm.Receivers;
model RecAll "Receiver accepts all power given"
	extends SolarTherm.Receivers.Receiver(port_b.h_outflow(start=0.0));
	// port_b.h_outflow is used as iteration variable, so we should find a good
	// initial guess for it.  Setting to zero here to silence warning.
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	replaceable model FlowModel = SolarTherm.Interfaces.FlowModels.Lossless
		constrainedby SolarTherm.Interfaces.FlowLoss.PartialFlowModel;

	FlowModel flowmod;
protected
	Medium.BaseProperties mprop_a;
	Medium.BaseProperties mprop_b;
equation
	port_a.m_flow + port_b.m_flow = 0;

	flowmod.m_flow = port_a.m_flow;
	flowmod.d_avg = mprop_a.d;
	port_b.p - port_a.p = flowmod.dp;

	mprop_a.p = port_a.p;
	mprop_a.h = inStream(port_a.h_outflow);
	port_a.h_outflow = inStream(port_b.h_outflow); // shouldn't flow back

	mprop_b.p = port_b.p;
	mprop_b.h = port_b.h_outflow;

	R[1] = port_a.m_flow*(port_b.h_outflow - inStream(port_a.h_outflow));
end RecAll;
