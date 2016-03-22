within SolarTherm.Fluid.HeatExchangers;
model Extractor "Ideal heat extractor"
	extends Modelica.Fluid.Interfaces.PartialTwoPort(
		allowFlowReversal=false);
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	parameter SI.Efficiency eff = 1.0 "Efficiency of conversion";

	replaceable model FlowModel = SolarTherm.Fluid.Flows.LosslessFlow
		constrainedby SolarTherm.Fluid.Flows.Flow;

	FlowModel flowmod;

	parameter Boolean use_input = true "Use input else parameter";

	parameter Medium.Temperature T_fixed = system.T_start "Fixed T when no input";

	input Medium.Temperature T_set if use_input "Set T from input";
	output SI.HeatFlowRate Q_flow "Heat from extractor";
	output Medium.Temperature T "Delivered temperature";
protected
	Medium.BaseProperties mprop_a;
	Medium.BaseProperties mprop_b;
equation
	port_a.m_flow + port_b.m_flow = 0;

	//port_a.p = port_b.p;
	flowmod.m_flow = port_a.m_flow;
	flowmod.d_avg = mprop_a.d;
	port_b.p - port_a.p = flowmod.dp;

	mprop_a.p = port_a.p;
	mprop_a.h = inStream(port_a.h_outflow);
	port_a.h_outflow = inStream(port_b.h_outflow); // shouldn't flow back

	mprop_b.T = if use_input then T_set else T_fixed;
	mprop_b.p = port_b.p;
	port_b.h_outflow = mprop_b.h;

	Q_flow = eff*port_a.m_flow*(inStream(port_a.h_outflow) - port_b.h_outflow);
	T = mprop_a.T; // setting delivered temperature to extractor input temp

	// Reverse heat flows only problem because of the way efficiency is defined
	assert(Q_flow >= 0, "Heat flowing wrong way in extractor");
end Extractor;
