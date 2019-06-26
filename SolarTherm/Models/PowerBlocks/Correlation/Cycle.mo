within SolarTherm.Models.PowerBlocks.Correlation;
partial model Cycle
	input Real T_ND "Non-dimensional temperature";
	input Real load "Load fraction";

	output Real k_q "Off-design heat fraction";
	output Real k_w "Off-design gross power fraction";
	annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
		coordinateSystem(preserveAspectRatio=false)));
end Cycle;
