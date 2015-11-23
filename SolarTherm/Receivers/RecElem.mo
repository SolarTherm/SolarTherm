within SolarTherm.Receivers;
partial model RecElem "Flat receiver element used to build up geometry"
	extends Modelica.Fluid.Interfaces.PartialTwoPort(
		allowFlowReversal=false);
	import SI = Modelica.SIunits;

	replaceable model FlowModel = SolarTherm.Interfaces.FlowModels.PartialFlowModel;

	parameter SI.Area A "Area of aperture";
	input SolarTherm.Interfaces.WeatherBus wbus;
	input SI.RadiantPower R "Radiant power on aperture";

	output SI.RadiantPower R_loss "Thermal loss";
	output SI.HeatFlowRate Q_flow_loss "Thermal convective loss";
protected
	Medium.BaseProperties mprop_a;
	Medium.BaseProperties mprop_b;
	FlowModel flowmod;
equation
	mprop_a.p = port_a.p;
	mprop_a.h = inStream(port_a.h_outflow);
	port_a.h_outflow = inStream(port_b.h_outflow); // shouldn't flow back

	mprop_b.p = port_b.p;
	mprop_b.h = port_b.h_outflow;

	port_a.m_flow + port_b.m_flow = 0;

	flowmod.m_flow = port_a.m_flow;
	flowmod.d_avg = mprop_a.d; // set it equal to inlet density
	port_b.p - port_a.p = flowmod.dp;
end RecElem;
