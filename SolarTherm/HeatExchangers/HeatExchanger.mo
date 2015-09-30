within SolarTherm.HeatExchangers;
partial model HeatExchanger "Four port heat exchanger partial model"
	import CN = Modelica.Constants;
	import SI = Modelica.SIunits;
	outer Modelica.Fluid.System system;
	replaceable package Medium1 = Modelica.Media.Interfaces.PartialMedium;
	replaceable package Medium2 = Modelica.Media.Interfaces.PartialMedium;

	parameter Boolean allowFlowReversal = system.allowFlowReversal;
	parameter SI.Pressure dp_start = 0.01*system.p_start;
	parameter SI.Pressure m_flow_start = system.m_flow_start;

	// Define ports
	Modelica.Fluid.Interfaces.FluidPort_a port_1a(
		redeclare package Medium=Medium1,
		m_flow(min=if allowFlowReversal then -CN.inf else 0)
		);
	Modelica.Fluid.Interfaces.FluidPort_b port_1b(
		redeclare package Medium=Medium1,
		m_flow(max=if allowFlowReversal then CN.inf else 0)
		);
	Modelica.Fluid.Interfaces.FluidPort_a port_2a(
		redeclare package Medium=Medium2,
		m_flow(min=if allowFlowReversal then -CN.inf else 0)
		);
	Modelica.Fluid.Interfaces.FluidPort_b port_2b(
		redeclare package Medium=Medium2,
		m_flow(max=if allowFlowReversal then CN.inf else 0)
		);
equation
	port_1a.m_flow + port_1b.m_flow = 0;
	port_2a.m_flow + port_2b.m_flow = 0;

	port_1b.Xi_outflow = inStream(port_1a.Xi_outflow);
	port_1a.Xi_outflow = inStream(port_1b.Xi_outflow);
	port_2b.Xi_outflow = inStream(port_2a.Xi_outflow);
	port_2a.Xi_outflow = inStream(port_2b.Xi_outflow);

	port_1b.C_outflow = inStream(port_1a.C_outflow);
	port_1a.C_outflow = inStream(port_1b.C_outflow);
	port_2b.C_outflow = inStream(port_2a.C_outflow);
	port_2a.C_outflow = inStream(port_2b.C_outflow);
end HeatExchanger;
