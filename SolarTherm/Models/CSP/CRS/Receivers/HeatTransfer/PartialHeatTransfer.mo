within SolarTherm.Models.CSP.CRS.Receivers.HeatTransfer;
partial model PartialHeatTransfer
	replaceable package Medium =
		Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(Dialog(tab = "Internal Interface", enable = false));
	
	parameter Real D = 1 "Diameter" annotation(Dialog(tab = "Internal Interface", enable = false), Evaluate = true);
	parameter Real L = 1 "Lenght" annotation(Dialog(tab = "Internal Interface", enable = false), Evaluate = true);

	input SI.Velocity v;
	input Medium.ThermodynamicState state;

	output Real Nu;
	annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
		coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransfer;
