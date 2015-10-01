within SolarTherm.Receivers;
model Plate "Single element plate receiver with fluid interface"
	extends SolarTherm.Receivers.Receiver(port_b.h_outflow(start=0.0));
	// port_b.h_outflow is used as iteration variable, so we should find a good
	// initial guess for it.  Setting to zero here to silence warning.
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	parameter Real em "Emissivity";
	parameter SI.CoefficientOfHeatTransfer h_th "Heat transfer coeff with env";

	replaceable model FlowModel = SolarTherm.Interfaces.FlowModels.Lossless
		constrainedby SolarTherm.Interfaces.FlowLoss.PartialFlowModel;

	FlowModel flowmod;

	SI.Temperature T_avg "Average temperature of receiver";
	SI.HeatFlowRate Q_flow "Heat flow into receiver mass";
protected
	Medium.BaseProperties mprop_a;
	Medium.BaseProperties mprop_b;
equation
	//port_a.p = port_b.p;
	flowmod.m_flow = port_a.m_flow;
	flowmod.d_avg = mprop_a.d;
	port_b.p - port_a.p = flowmod.dp;

	mprop_a.p = port_a.p;
	mprop_a.h = inStream(port_a.h_outflow);
	port_a.h_outflow = inStream(port_b.h_outflow); // shouldn't flow back

	mprop_b.p = port_b.p;
	mprop_b.h = port_b.h_outflow;

	T_avg = (mprop_a.T + mprop_b.T)/2;

	Q_flow = port_a.m_flow*(port_b.h_outflow - inStream(port_a.h_outflow));
	Q_flow = em*R // power from concentrator (em used for absorptivity)
		- h_th*A*(T_avg - wbus.Tdry) // convection losses (should add wind forcing)
		- em*CN.sigma*A*(T_avg^4 - wbus.Tdry^4); // radiative losses
end Plate;
