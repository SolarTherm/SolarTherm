within SolarTherm.Receivers;
model EndTElem "Losses at outlet fluid temperature"
	extends SolarTherm.Receivers.RecElem(
		redeclare model FlowModel=SolarTherm.Interfaces.FlowModels.Lossless,
		port_b.h_outflow(start=0.0)
		);
	// port_b.h_outflow is used as iteration variable, so we should find a good
	// initial guess for it.  Setting to zero here to silence warning.
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	parameter Real ab "Absorbtivity";
	parameter Real em "Emissivity";
	parameter SI.CoefficientOfHeatTransfer h_th "Heat transfer coeff with env";
protected
	SI.HeatFlowRate Q_flow "Heat flow into fluid";
equation
	Q_flow = port_a.m_flow*(port_b.h_outflow - inStream(port_a.h_outflow));
	Q_flow_loss = h_th*A*(mprop_b.T - wbus.Tdry);
	R_loss = em*CN.sigma*A*(mprop_b.T^4 - wbus.Tdry^4);
	Q_flow + Q_flow_loss + R_loss = ab*R;
end EndTElem;
