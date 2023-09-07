within SolarTherm.Interfaces.Models;
partial model SimpleResistiveHeater
	extends SolarTherm.Icons.ResistiveHeater;
	extends Modelica.Fluid.Interfaces.PartialTwoPort;
	replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph
		constrainedby Modelica.Media.Interfaces.PartialMedium
		"Medium in the component"
	annotation (choicesAllMatching = true, Dialog(group="Working fluid"));
	Modelica.Blocks.Interfaces.RealInput P_elec_in "Electrical power input" 
		annotation(
		Placement(visible = true, transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {2, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
end SimpleResistiveHeater;