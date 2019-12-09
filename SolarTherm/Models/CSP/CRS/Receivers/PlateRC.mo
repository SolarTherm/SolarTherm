within SolarTherm.Models.CSP.CRS.Receivers;
model PlateRC "Single element plate receiver with fluid interface"
	extends SolarTherm.Models.CSP.CRS.Receivers.FluidRC(port_b.h_outflow(start=0.0));
	// port_b.h_outflow is used as iteration variable, so we should find a good
	// initial guess for it.  Setting to zero here to silence warning.
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	parameter SI.Area A "Area of aperture";
	parameter Real em "Emissivity";
	parameter Real ab "Absorptivity";
	parameter SI.CoefficientOfHeatTransfer h_th "Heat transfer coeff with env";

	replaceable model FlowModel =
		SolarTherm.Models.Fluid.Flows.LosslessFlow constrainedby
		SolarTherm.Models.Fluid.Flows.Flow
		"a flow model consisting of the mass flow rate, density and pressure change inside the two-ported control volume (i.e. PlateRC)";

	FlowModel flowmod;

	input Boolean door_open(start=false) "If receiver door is open";

	Medium.Temperature T_avg "Average temperature of receiver";
	SI.HeatFlowRate Q_flow "Heat flow into fluid";
	SI.HeatFlowRate Q_flow_loss "Convective losses";
	SI.RadiantPower R_loss "Radiative losses";
	Medium.Temperature T_a "Temperature at inlet";
	Medium.Temperature T_b "Temperature at outlet";
protected
	Medium.BaseProperties mprop_a;
	Medium.BaseProperties mprop_b;
equation
	T_a = mprop_a.T;
	T_b = mprop_b.T;

	port_a.m_flow + port_b.m_flow = 0;

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
	Q_flow_loss = h_th*A*(T_avg - wbus.Tdry);
	R_loss = em*CN.sigma*A*(T_avg^4 - wbus.Tdry^4);

	if door_open then
		Q_flow + Q_flow_loss + R_loss = ab*R[1];
	else
		//Q_flow = 0;
		port_b.h_outflow = inStream(port_a.h_outflow);
	end if;
end PlateRC;
