within SolarTherm.Fluid.Pumps;
model IdealPump "Solar receiver with fluid interface"
	extends Modelica.Fluid.Interfaces.PartialTwoPort;
	import SI = Modelica.SIunits;

	parameter Boolean cont_m_flow = true "Control m_flow else control dp";
	parameter Boolean use_input = true "Use input else parameter";

	parameter SI.MassFlowRate m_flow_fixed = 0 "Fixed m_flow when no input";
	parameter SI.Pressure dp_fixed = 0 "Fixed dp when no input";

	input SI.MassFlowRate m_flow_set if cont_m_flow and use_input;
	input SI.Pressure dp_set if (not cont_m_flow) and use_input;
equation
	port_b.h_outflow = inStream(port_a.h_outflow);
	port_a.h_outflow = inStream(port_b.h_outflow);
	port_a.m_flow + port_b.m_flow = 0;

	if cont_m_flow then
		port_a.m_flow = if use_input then m_flow_set else m_flow_fixed;
	else
		port_a.p - port_b.p = if use_input then dp_set else dp_fixed;
	end if;
end IdealPump;
