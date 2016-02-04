within SolarTherm.Storage;
model TankGeneric "Generic energy tank"
	import SI = Modelica.SIunits;
	parameter SI.Energy E_max = 1000 "Maximum energy";
	parameter SI.Energy E_0 = 0 "Starting energy";
	parameter SI.HeatFlowRate Q_flow_max "Maximum energy out to power block";
	parameter SI.HeatFlowRate Q_flow_loss_des "Design point heat loss";
	parameter SI.Temperature T_amb_des "Design point ambient temperature";

	parameter Real cf0 "Fraction charge factor coefficient";
	parameter Real cf1 "Fraction charge factor coefficient";
	parameter Real cf2 "Fraction charge factor coefficient";
	parameter Real cf3 "Fraction charge factor coefficient";
	parameter Real ca0 "Ambient temperature factor coefficient";
	parameter Real ca1 "Ambient temperature factor coefficient";
	parameter Real ca2 "Ambient temperature factor coefficient";
	parameter Real ca3 "Ambient temperature factor coefficient";

	input Real fac_in "Fraction of input stored";
	input Real fac_out "Fraction of max power to output";
	input SI.HeatFlowRate Q_flow_in "Heat flow entering tank";
	input SolarTherm.Interfaces.WeatherBus wbus;
	output SI.HeatFlowRate Q_flow_out "Heat flow leaving tank";
	SI.Energy E(start=E_0, fixed=true, min=0, max=E_max) "Energy in tank";
	SI.HeatFlowRate Q_flow_loss "Heat loss";
protected
	Real fac_fra "Fraction charged loss factor";
	Real fac_amb "Ambient temperature thermal loss factor";
equation
	der(E) = fac_in*Q_flow_in - Q_flow_out - Q_flow_loss;
	Q_flow_out = fac_out*Q_flow_max;
	//Q_flow_loss = 0;
	//fac_fra = 0;
	//fac_amb = 0;
	Q_flow_loss = Q_flow_loss_des*fac_fra*fac_amb;
	fac_fra = cf0 + cf1*(E/E_max) + cf2*(E/E_max)^2 + cf3*(E/E_max)^3;
	fac_amb = ca0 + ca1*(wbus.Tdry - T_amb_des) + ca2*(wbus.Tdry - T_amb_des)^2 + ca3*(wbus.Tdry - T_amb_des)^3;
end TankGeneric;
