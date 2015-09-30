within SolarTherm.HeatExchangers;
model BasicHE "Basic counterflow heat exchanger model"
	extends SolarTherm.HeatExchangers.HeatExchanger(
		allowFlowReversal=false
		);
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import Modelica.Math;

	parameter SI.CoefficientOfHeatTransfer h_th = 1.0 "Heat transfer coeff";
	parameter SI.Length D = 0.1 "Diameter of pipes";
	parameter SI.Length L = 1 "Length of pipes";

	parameter SI.MassFlowRate too_fast = 1;

	SI.HeatFlowRate Q_flow "Heat flow from side 1 to 2";
	SI.Temperature T_1a(start=330);
	SI.Temperature T_1b(start=310);
	SI.Temperature T_2a(start=300);
	SI.Temperature T_2b(start=305);

	Medium1.BaseProperties mprop_1a;
	Medium1.BaseProperties mprop_1b;
	Medium2.BaseProperties mprop_2a;
	Medium2.BaseProperties mprop_2b;
equation
	//port_1b.h_outflow = inStream(port_1a.h_outflow);
	//port_1a.h_outflow = inStream(port_1b.h_outflow);
	//port_2b.h_outflow = inStream(port_2a.h_outflow);
	//port_2a.h_outflow = inStream(port_2b.h_outflow);

	mprop_1a.T = T_1a;
	mprop_1b.T = T_1b;
	mprop_2a.T = T_2a;
	mprop_2b.T = T_2b;
	mprop_1a.p = port_1a.p;
	mprop_1b.p = port_1b.p;
	mprop_2a.p = port_2a.p;
	mprop_2b.p = port_2b.p;
	mprop_1a.h = inStream(port_1a.h_outflow);
	mprop_1b.h = port_1b.h_outflow;
	mprop_2a.h = inStream(port_2a.h_outflow);
	mprop_2b.h = port_2b.h_outflow;

	Q_flow = port_1a.m_flow*(inStream(port_1a.h_outflow) - port_1b.h_outflow);
	Q_flow = port_2a.m_flow*(port_2b.h_outflow - inStream(port_2a.h_outflow));

	//Q_flow = h_th*CN.pi*D*L*((T_1a - T_2b) - (T_1b - T_2a))/
	//	Math.log((T_1a - T_2b)/(T_1b - T_2a));

	// Control needs to make sure port_1a.m_flow is sensible so that T_1b
	// doesn't drop below T_2a
	// Linear response to mass flow rate
	T_2b = (T_1a - T_2a)*max(0, min(1, too_fast - port_2a.m_flow)) + T_2a;
	assert(T_1b >= T_2a, "Mass flow rate too low on hot side");

	// Shouldn't have reverse flows
	port_1a.h_outflow = 0.0;
	port_2a.h_outflow = 0.0;

	port_1b.p = port_1a.p;
	port_2b.p = port_2a.p;
end BasicHE;
