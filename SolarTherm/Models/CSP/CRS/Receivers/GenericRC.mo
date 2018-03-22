within SolarTherm.Models.CSP.CRS.Receivers;
model GenericRC "Polynomial factors around design point"
	extends SolarTherm.Models.CSP.CRS.Receivers.Receiver;
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	parameter Boolean match_sam = false "Configure to match SAM output";

	parameter SI.HeatFlowRate Q_flow_loss_des "Design heat loss";
	parameter SI.RadiantPower R_des "Design radiant power";
	parameter SI.Irradiance I_des = 1000 "Design irradiance";
	parameter SI.Temperature T_amb_des "Design ambient temperature";

	parameter Real cf[:] "Fraction irradiance factor coefficients";
	parameter Real ca[:] "Ambient temperature factor coefficients";
	parameter Real cw[:] "Wind factor coefficients";

	output SI.HeatFlowRate Q_flow "Heat flow leaving receiver";
	SI.HeatFlowRate Q_flow_loss "Heat loss";
protected
	SolarTherm.Utilities.Polynomial.Poly fac_fra(c=cf);
	SolarTherm.Utilities.Polynomial.Poly fac_amb(c=ca);
	SolarTherm.Utilities.Polynomial.Poly fac_wnd(c=cw);
equation
	Q_flow = max(sum(R) - Q_flow_loss, 0);
	Q_flow_loss = Q_flow_loss_des*fac_fra.y*fac_amb.y*fac_wnd.y;
	fac_fra.x = if match_sam then wbus.dni/I_des else sum(R)/R_des;
	fac_amb.x = wbus.Tdry - T_amb_des;
	fac_wnd.x = wbus.wspd;
end GenericRC;
