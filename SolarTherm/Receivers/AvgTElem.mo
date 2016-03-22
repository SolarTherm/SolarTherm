within SolarTherm.Receivers;
model AvgTElem "Losses at average fluid temperature"
	extends SolarTherm.Receivers.Elem(
		redeclare model FlowModel=SolarTherm.Fluid.Flows.LosslessFlow,
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
	Medium.Temperature T_avg "Average temperature of receiver";
equation
	T_avg = (hfluid.mprop_a.T + hfluid.mprop_b.T)/2;

	Q_flow_loss = h_th*A*(T_avg - wbus.Tdry);
	R_loss = em*CN.sigma*A*(T_avg^4 - wbus.Tdry^4);
	hfluid.Q_flow + Q_flow_loss + R_loss = ab*R;
end AvgTElem;
