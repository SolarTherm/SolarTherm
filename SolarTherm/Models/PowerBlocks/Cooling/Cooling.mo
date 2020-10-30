within SolarTherm.Models.PowerBlocks.Cooling;
partial model Cooling
	input SI.Temperature T_amb;

	output Real nu_q "Heating drop factor";
	output Real nu_w "Electrical drop factor";

	annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Cooling;
