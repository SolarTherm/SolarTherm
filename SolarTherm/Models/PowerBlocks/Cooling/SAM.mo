within SolarTherm.Models.PowerBlocks.Cooling;
model SAM "Rankine SAM (no restriction)"
	extends Cooling;

	parameter SI.Temperature T_des=from_degC(43) "Ambient temperature at design"; 
equation
	nu_q=1;
	nu_w=1+0.075*(T_des-T_amb)/20;

	annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end SAM;
