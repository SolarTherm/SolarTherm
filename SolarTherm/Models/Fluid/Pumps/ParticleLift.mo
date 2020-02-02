within SolarTherm.Models.Fluid.Pumps;
model ParticleLift "Solid particle lift"
	extends Modelica.Fluid.Interfaces.PartialTwoPort;
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	parameter Boolean cont_m_flow = true "Control m_flow else control dp";
	parameter Boolean use_input = true "Use input else parameter";

	parameter SI.MassFlowRate m_flow_fixed = 0 "Fixed m_flow when no input";
	parameter SI.Pressure dp_fixed = 0 "Fixed dp when no input";

	parameter SI.Height dh = 0 "Vertical displacement";
	parameter Real CF = 0.5 "Counterweight factor ";
	parameter SI.Efficiency eff = 0.85 "Elevator total efficiency";

	input SI.MassFlowRate m_flow_set if cont_m_flow and use_input;
	input SI.Pressure dp_set if (not cont_m_flow) and use_input;

	SI.Power W "Power required to lift particles";

equation
	port_b.h_outflow = inStream(port_a.h_outflow);
	port_a.h_outflow = inStream(port_b.h_outflow);
    port_a.m_flow + port_b.m_flow = 0; 


	W = port_a.m_flow * CN.g_n * dh * (1 - CF) / eff;

	if cont_m_flow then
		port_a.m_flow = if use_input then m_flow_set else m_flow_fixed;
	else
		port_a.p - port_b.p = if use_input then dp_set else dp_fixed;
	end if;
end ParticleLift;
