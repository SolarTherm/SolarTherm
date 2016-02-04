within SolarTherm.PowerBlocks;
model PBGeneric "Generic power block model"
	import SI = Modelica.SIunits;

	parameter SI.Efficiency eff_des = 0.5 "Power cycle design efficiency";
	parameter SI.HeatFlowRate Q_flow_max "Maximum energy out to power block";
	parameter SI.Temperature T_amb_des "Design point ambient temperature";

	parameter Real cf0 "Fraction operation factor coefficient";
	parameter Real cf1 "Fraction operation factor coefficient";
	parameter Real cf2 "Fraction operation factor coefficient";
	parameter Real cf3 "Fraction operation factor coefficient";
	parameter Real cf4 "Fraction operation factor coefficient";
	parameter Real ca0 "Ambient temperature factor coefficient";
	parameter Real ca1 "Ambient temperature factor coefficient";
	parameter Real ca2 "Ambient temperature factor coefficient";
	parameter Real ca3 "Ambient temperature factor coefficient";
	parameter Real ca4 "Ambient temperature factor coefficient";

	input SI.HeatFlowRate Q_flow "Heat flow entering power block";
	input SolarTherm.Interfaces.WeatherBus wbus;
	SI.Power P_out "Electrical output power";
protected
	SI.Efficiency eff "Efficiency";
	Real fac_fra "Fraction charged loss factor";
	Real fac_amb "Ambient temperature thermal loss factor";
equation
	P_out = eff*Q_flow;
	eff = eff_des*fac_fra*fac_amb;
	fac_fra = cf0 + cf1*(Q_flow/Q_flow_max) + cf2*(Q_flow/Q_flow_max)^2 + cf3*(Q_flow/Q_flow_max)^3 + cf4*(Q_flow/Q_flow_max)^4;
	fac_amb = ca0 + ca1*(wbus.Tdry - T_amb_des) + ca2*(wbus.Tdry - T_amb_des)^2 + ca3*(wbus.Tdry - T_amb_des)^3 + ca4*(wbus.Tdry - T_amb_des)^4;
end PBGeneric;
