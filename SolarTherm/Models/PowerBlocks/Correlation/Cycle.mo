within SolarTherm.Models.PowerBlocks.Correlation;
partial model Cycle
	import SI = Modelica.SIunits;

	parameter SI.Temperature T_in_ref "HTF inlet temperature at design" annotation (Dialog(enable=false,group="Design"));

	input SI.Temperature T_in "HTF inlet temperature";
	input Real load "Load fraction";

	output Real k_q "Off-design heat fraction";
	output Real k_w "Off-design gross power fraction";
	annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
		coordinateSystem(preserveAspectRatio=false)));
end Cycle;
