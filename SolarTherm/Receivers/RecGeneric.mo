within SolarTherm.Receivers;
model RecGeneric "Polynomial factors around design point"
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	parameter Integer nelem = 1 "Number of aperture elements";

	parameter SI.HeatFlowRate Q_flow_loss_des "Design heat loss";
	parameter SI.RadiantPower R_des "Design radiant power";
	parameter SI.Temperature T_amb_des "Design ambient temperature";

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

	input SolarTherm.Interfaces.WeatherBus wbus;
	input SI.RadiantPower R[nelem] "Radiant power on aperture";
	output SI.HeatFlowRate Q_flow "Heat flow leaving receiver";
	SI.HeatFlowRate Q_flow_loss "Heat loss";
protected
	Real fac_irr "Irradiation thermal loss factor";
	Real fac_amb "Ambient temperature thermal loss factor";
	Real fac_wnd "Wind thermal loss factor";
equation
	Q_flow = max(sum(R) - Q_flow_loss, 0);
	Q_flow_loss = Q_flow_loss_des*fac_irr*fac_amb*fac_wnd;
	fac_irr = ci0 + ci1*(sum(R)/R_des) + ci2*(sum(R)/R_des)^2 + ci3*(sum(R)/R_des)^3;
	fac_amb = ca0 + ca1*(wbus.Tdry - T_amb_des) + ca2*(wbus.Tdry - T_amb_des)^2 + ca3*(wbus.Tdry - T_amb_des)^3;
	fac_wnd = cw0 + cw1*wbus.wspd + cw2*wbus.wspd^2 + cw3*wbus.wspd^3;
end RecGeneric;
