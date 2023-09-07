within SolarTherm.Interfaces.Models;
partial model Boiler
	extends SolarTherm.Icons.Boiler;
	extends Modelica.Fluid.Interfaces.PartialTwoPort;
	replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph
		constrainedby Modelica.Media.Interfaces.PartialMedium
		"Medium in the component"
	annotation (choicesAllMatching = true, Dialog(group="Working fluid"));
end Boiler;