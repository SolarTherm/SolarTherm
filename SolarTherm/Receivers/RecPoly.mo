within SolarTherm.Receivers;
model RecPoly "Polynomial factors around design point"
	extends SolarTherm.Receivers.Receiver(port_b.h_outflow(start=0.0));
	// port_b.h_outflow is used as iteration variable, so we should find a good
	// initial guess for it.  Setting to zero here to silence warning.
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	parameter SI.HeatFlowRate Q_flow_loss_des "Design heat loss";
	parameter SI.RaidantPower R_des "Design radiant";
	parameter SI.Temperature T_des "Design temperature";

	parameter Real ci0 "Irradiance factor coefficient";
	parameter Real ci1 "Irradiance factor coefficient";
	parameter Real ci2 "Irradiance factor coefficient";
	parameter Real ci3 "Irradiance factor coefficient";
	parameter Real ca0 "Ambient temperature factor coefficient";
	parameter Real ca1 "Ambient temperature factor coefficient";
	parameter Real ca2 "Ambient temperature factor coefficient";
	parameter Real ca3 "Ambient temperature factor coefficient";
	parameter Real cw0 "Wind factor coefficient";
	parameter Real cw1 "Wind factor coefficient";
	parameter Real cw2 "Wind factor coefficient";
	parameter Real cw3 "Wind factor coefficient";

	replaceable model FlowModel = SolarTherm.Interfaces.FlowModels.Lossless
		constrainedby SolarTherm.Interfaces.FlowLoss.PartialFlowModel;

	SolarTherm.Receivers.HeatedFluid hfluid(
		redeclare package Medium=Medium,
		redeclare model FlowModel=FlowModel
		);
protected
	SI.HeatFlowRate Q_flow_loss "Heat loss";
	Real fac_irr "Irradiation thermal loss factor";
	Real fac_amb "Ambient temperature thermal loss factor";
	Real fac_wnd "Wind thermal loss factor";
equation
	connect(port_a, hfluid.port_a);
	connect(hfluid.port_b, port_b);

	hfluid.Q_flow = max(R[1] - Q_flow_loss, 0);
	Q_flow_loss = Q_flow_loss_des*fac_irr*fac_amb*fac_wnd;
	fac_irr = ci0 + ci1*(R[1]/R_des) + ci2*(R[1]/R_des)^2 + ci3*(R[1]/R_des)^3;
	fac_amb = ca0 + ca1*(wbus.Tdry - T_des) + ca2*(wbus.Tdry - T_des)^2 + ca3*(wbus.Tdry - T_des)^3;
	fac_wnd = cw0 + cw1*wbus.wspd + cw2*wbus.wspd^2 + cw3*wbus.wspd^3;
end RecPoly;
