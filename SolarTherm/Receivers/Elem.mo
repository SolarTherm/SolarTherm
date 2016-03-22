within SolarTherm.Receivers;
partial model Elem "Flat receiver element used to build up geometry"
	extends Modelica.Fluid.Interfaces.PartialTwoPort(
		allowFlowReversal=false);
	import SI = Modelica.SIunits;

	replaceable model FlowModel = SolarTherm.Fluid.Flows.LosslessFlow
		constrainedby SolarTherm.Fluid.Flows.Flow;

	parameter SI.Area A "Area of aperture";

	SolarTherm.Receivers.HeatedFluid hfluid(
		redeclare package Medium=Medium,
		redeclare model FlowModel=FlowModel
		);

	input SolarTherm.Interfaces.WeatherBus wbus;
	input SI.RadiantPower R "Radiant power on aperture";

	output SI.RadiantPower R_loss "Thermal loss";
	output SI.HeatFlowRate Q_flow_loss "Thermal convective loss";
equation
	connect(port_a, hfluid.port_a);
	connect(hfluid.port_b, port_b);
	// Extended models need to define what hfluid.Q_flow is
end Elem;
