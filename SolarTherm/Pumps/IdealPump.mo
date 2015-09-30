within SolarTherm.Pumps;
model IdealPump "Solar receiver with fluid interface"
	extends Modelica.Fluid.Interfaces.PartialTwoPortTransport(
		show_V_flow=false,
		show_T=false
		);
	import SI = Modelica.SIunits;

	parameter Boolean cont_m_flow=true "Control m_flow else control dp";
	parameter Boolean use_input=true "Use input else parameter";

	parameter SI.MassFlowRate m_flow_fixed = 0 "Fixed m_flow when no input";
	parameter SI.Pressure dp_fixed = 0 "Fixed dp when no input";

	input SI.MassFlowRate m_flow_in if cont_m_flow and use_input;
	input SI.Pressure dp_in if (not cont_m_flow) and use_input;
equation
	// Mass and substance balance already taken care of by parent
	port_b.h_outflow = inStream(port_a.h_outflow);
	port_a.h_outflow = inStream(port_b.h_outflow);

	if cont_m_flow then
		m_flow = if use_input then m_flow_in else m_flow_fixed;
	else
		dp = if use_input then dp_in else dp_fixed;
	end if;
end IdealPump;
