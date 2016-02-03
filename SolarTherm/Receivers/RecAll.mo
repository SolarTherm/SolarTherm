within SolarTherm.Receivers;
model RecAll "Receiver accepts all power given"
	extends SolarTherm.Receivers.Receiver(port_b.h_outflow(start=0.0));
	// port_b.h_outflow is used as iteration variable, so we should find a good
	// initial guess for it.  Setting to zero here to silence warning.
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	replaceable model FlowModel = SolarTherm.Interfaces.FlowModels.Lossless
		constrainedby SolarTherm.Interfaces.FlowLoss.PartialFlowModel;

	SolarTherm.Receivers.HeatedFluid hfluid(
		redeclare package Medium=Medium,
		redeclare model FlowModel=FlowModel
		);

equation
	connect(port_a, hfluid.port_a);
	connect(hfluid.port_b, port_b);

	hfluid.Q_flow = R[1];
end RecAll;
