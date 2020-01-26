within SolarTherm.Models.PowerBlocks.Cooling;
model NoCooling "No cooling drop factor"
	extends Cooling;
equation
	nu_q=1;
	nu_w=1;

	annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end NoCooling;
