within SolarTherm.Models.PowerBlocks.Cooling;
model DryCooling "sCO2 Dry cooling model"
	extends Cooling;

	parameter SI.Temperature T_co=from_degC(43) "Compressor inlet temperature at design";
	final parameter SI.Temperature T_lim=from_degC(0.86294*to_degC(T_co)+4.18885);

equation
	nu_q = if T_lim >= T_amb then 1 else min(1, SolarTherm.Models.PowerBlocks.Cooling.Energy_nu_q(T_amb, T_co)/100);
	nu_w = if T_lim >= T_amb then 1 else min(1, SolarTherm.Models.PowerBlocks.Cooling.Energy_nu_w(T_amb, T_co)/100);

	annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end DryCooling;
