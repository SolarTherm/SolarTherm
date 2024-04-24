within SolarTherm.Interfaces.Models;
partial model SimpleResistiveHeater
	extends SolarTherm.Icons.ResistiveHeater;
	Modelica.Blocks.Interfaces.RealInput P_elec_in "Electrical power input" 
		annotation(
		Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
		iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealOutput P_thermal_out "Electrical power input" 
		annotation(
		Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
		iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

end SimpleResistiveHeater;