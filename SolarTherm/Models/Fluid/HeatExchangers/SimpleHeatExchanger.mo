within SolarTherm.Models.Fluid.HeatExchangers;
model SimpleHeatExchanger "A simple counterflow heat exchanger model based on LMTD method"
	extends SolarTherm.Interfaces.Models.HeatExchangerFluid;

	import CN = Modelica.Constants;
	import SI = Modelica.SIunits;
	import Modelica.Math;

	parameter SI.Area A = 1 "Heat transfer surface area";
	parameter SI.CoefficientOfHeatTransfer U = 1 "Heat tranfer coefficient";
	parameter SI.TemperatureDifference dT_approach = 15 "Approach temperature";
	parameter SI.Pressure pcold = 1e5 "Cold side pressure";
	parameter SI.MassFlowRate m_flow_cold = 731.042 "Cold side mass flow rate";

	Medium_A.ThermodynamicState state_a_in = Medium_A.setState_phX(port_a_in.p,inStream(port_a_in.h_outflow));
	Medium_A.ThermodynamicState state_a_out = Medium_A.setState_pTX(port_a_in.p,T_a_out);
	Medium_B.ThermodynamicState state_b_in = Medium_B.setState_phX(port_b_in.p,inStream(port_b_in.h_outflow));
	Medium_B.ThermodynamicState state_b_out = Medium_B.setState_pTX(port_b_in.p,T_b_out);

	SI.Temperature T_a_in(start=800+273.15) "Medium A inlet temperature";
	SI.Temperature T_a_out(start=580.3+273.15) "Medium A outlet temperature";
	SI.Temperature T_b_in(start=565.3+273.15) "Medium B inlet temperature";
	SI.Temperature T_b_out(start=715+273.15) "Medium B outlet temperature";
	parameter	SI.Temperature T_b_out_ref = 785 + 273.15 "Medium B outlet temperature";

	SI.HeatFlowRate Q_flow "Heat flow from hot to cold side";
	SI.TemperatureDifference LMTD(start=40.36) "Logarithmic mean temperature difference";
	SI.SpecificEnthalpy h_a_in = inStream(port_a_in.h_outflow);

equation
	port_a_out.h_outflow = Medium_A.specificEnthalpy(state_a_out);
	port_b_in.m_flow = m_flow_cold;
	port_a_in.m_flow + port_a_out.m_flow = 0;

	port_a_out.Xi_outflow = inStream(port_a_in.Xi_outflow);
	port_a_in.Xi_outflow = inStream(port_a_out.Xi_outflow);
	port_b_out.Xi_outflow = inStream(port_b_in.Xi_outflow);
	port_b_in.Xi_outflow = inStream(port_b_out.Xi_outflow);

	port_a_out.C_outflow = inStream(port_a_in.C_outflow);
	port_a_in.C_outflow = inStream(port_a_out.C_outflow);
	port_b_out.C_outflow = inStream(port_b_in.C_outflow);
	port_b_in.C_outflow = inStream(port_b_out.C_outflow);

	T_a_in = Medium_A.temperature(state_a_in);
	T_b_in = Medium_B.temperature(state_b_in);
	

	dT_approach = T_a_out - T_b_in;
	Q_flow = port_a_in.m_flow*(inStream(port_a_in.h_outflow) - port_a_out.h_outflow);
	Q_flow = U*A*LMTD;
	LMTD = ((T_a_in-T_b_out)-dT_approach)/(Math.log((T_a_in-T_b_out)/dT_approach));
	Q_flow = port_b_in.m_flow*(port_b_out.h_outflow - inStream(port_b_in.h_outflow));

	port_a_out.p = port_a_in.p;
	port_b_out.p = pcold;

	// Shouldn't have reverse flows
	port_a_in.h_outflow = 0.0;
	port_b_in.h_outflow = 0.0;

	annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>A. Shirazi:<br>Released first version. </li>
</ul>
</html>"));

end SimpleHeatExchanger;
