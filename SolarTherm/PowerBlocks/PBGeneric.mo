within SolarTherm.PowerBlocks;
model PBGeneric "Generic power block model"
	import SI = Modelica.SIunits;

	parameter SI.Efficiency eff_des = 0.5 "Power cycle efficiency at design";
	parameter SI.HeatFlowRate Q_flow_des "Heat of power block at design (max value)";
	parameter SI.Temperature T_amb_des "Ambient temperature at design";

	parameter Real cf[:] "Fraction operation factor coefficients";
	parameter Real ca[:] "Ambient temperature factor coefficients";

	parameter SI.Energy E_start(min=0) = 0 "Energy required to start cycle";
	parameter SI.HeatFlowRate Q_flow_leak(min=0) = 0 "Heat leak of startup energy";
	parameter Real buffer(min=1) = 1.1 "Stored energy buffer factor";

	parameter Boolean startup_energy = E_start > 0;

	input SI.HeatFlowRate Q_flow "Heat flow entering power block";
	input SolarTherm.Interfaces.WeatherBus wbus;
	output SI.Power P "Electrical output power";
	SI.HeatFlowRate Q_flow_cyc "Heat flow to power cycle";
	SI.Energy E_st if startup_energy "Energy used to start";
protected
	SolarTherm.Utilities.Polynomial.Poly fac_fra(c=cf);
	SolarTherm.Utilities.Polynomial.Poly fac_amb(c=ca);
initial equation
	if startup_energy then
		E_st = 0;
	end if;
equation
	if startup_energy then
		if E_st >= buffer*E_start then
			der(E_st) = min(0, Q_flow_cyc - Q_flow_leak);
		elseif E_st <= 0 then
			der(E_st) = max(0, Q_flow_cyc - Q_flow_leak);
		else
			der(E_st) = Q_flow_cyc - Q_flow_leak;
		end if;
		if E_st >= E_start then
			P = Q_flow_cyc*eff_des*fac_fra.y*fac_amb.y;
		else
			P = 0;
		end if;
	else
		P = Q_flow_cyc*eff_des*fac_fra.y*fac_amb.y;
	end if;

	Q_flow_cyc = min(Q_flow, Q_flow_des); // Discard heat above design
	fac_fra.x = Q_flow_cyc/Q_flow_des;
	fac_amb.x = wbus.Tdry - T_amb_des;
end PBGeneric;
