within SolarTherm.Models.Fluid.HeatExchangers;
model SimpleResistiveHeater
	extends SolarTherm.Interfaces.Models.SimpleResistiveHeater;

	// Parameters
	parameter Modelica.SIunits.Efficiency heater_efficiency = 0.99 "Electric heater efficiency";

	// Grid on/off signal
	Modelica.Blocks.Interfaces.BooleanInput on_renewable "grid on/off signal" annotation(
		Placement(visible = true, 
		transformation(origin = {-100,-50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
		iconTransformation(origin = {-100,-60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	
equation
	P_thermal_out = P_elec_in*heater_efficiency;

annotation (Documentation(info="<html>
<p>
<b>SimpleResistiveHeater</b> models the behavior of a resistive heater used in fluid heating systems.
</p>
<p>
The <b>SimpleResistiveHeater</b> model has the following connectors:
</p>
<ul>
<li> A <b>on_renewable</b> input signal that determines whether the grid is on or off.</li>
</ul>
<p>
The following parameters must be defined:
</p>
<ul>
<li> <b>heater_efficiency</b>: Electric heater efficiency. Default: 0.99.</li>
</ul>
</html>",
revisions="<html>
<ul>
	<li><i>April 2024</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
	Created documentation for SimpleResistiveHeater.</li>
</ul>
</html>"));

end SimpleResistiveHeater;
