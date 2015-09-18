within SolarTherm.Receivers;
model Plate "Single element plate receiver with fluid interface"
	// Only setup for one way flow (might be overridden by system)
	extends SolarTherm.Receivers.Receiver(port_a(m_flow(min=0)),
		port_b(m_flow(max=0)));
	// Contains medium, port_a and port_b and flow reversal switch
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	parameter SI.Mass m "Thermal mass of receiver";
	parameter SI.SpecificHeatCapacity c "Heat capacity of thermal mass";
	parameter Real em "Emissivity";
	parameter SI.CoefficientOfHeatTransfer h_th "Heat transfer coeff with env";
	parameter SI.Temperature T_0 = 300;

	SI.Temperature T(start=T_0, fixed=true) "Temperature of receiver mass";
	SI.HeatFlowRate Q_flow "Heat flow into receiver mass";
protected
	Medium.BaseProperties mprop_b;
equation
	port_a.p = port_b.p;

	mprop_b.T = T;
	mprop_b.p = port_b.p;
	port_b.h_outflow = mprop_b.h;
	port_a.h_outflow = mprop_b.h; // set it as same, but shouldn't flow back
	Q_flow = em*R // power from concentrator (em used for absorptivity)
		- port_a.m_flow*(port_b.h_outflow - inStream(port_a.h_outflow))
		- h_th*A*(T - wbus.Tdry) // convection losses (should add wind forcing)
		- em*CN.sigma*A*(T^4 - wbus.Tdry^4); // radiative losses
	c*m*der(T) = Q_flow;

	// Could use actualStream above (should also probably mark it smooth)

	// Think about adding pressure drop proportional to flow?

	// How about we have a controller that draws away heat once rec temp
	// passes a level, and only draws energy such that the rec temp is fixed.
end Plate;
