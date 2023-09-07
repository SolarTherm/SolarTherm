within SolarTherm.Models.Fluid.HeatExchangers;
model SimpleResistiveHeater
	extends SolarTherm.Interfaces.Models.SimpleResistiveHeater;

	// Parameters
	parameter Modelica.SIunits.Temperature T_cold_set = from_degC(290) "Inlet fluid temperature at design";
	parameter Modelica.SIunits.Temperature T_hot_set = from_degC(565) "Outlet fluid temperature at design";
	parameter Modelica.SIunits.Efficiency heater_efficiency = 0.99 "Electric heater efficiency";

	// Thermodynamic states at design conditions
	final parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold fluid thermodynamic state at design";
	final parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hot fluid thermodynamic state at design";
	
	// Specific enthalpy at design conditions
	final parameter Modelica.SIunits.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold fluid specific enthalpy at design";  
	final parameter Modelica.SIunits.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot fluid specific enthalpy at design";
	
	// Inlet and outlet enthalpy
	Modelica.SIunits.SpecificEnthalpy h_in "Inlet fluid enthalpy";
	Modelica.SIunits.SpecificEnthalpy h_out "Outlet fluid enthalpy";

	// Grid on/off signal
	Modelica.Blocks.Interfaces.BooleanInput on_renewable "grid on/off signal" annotation(
		Placement(visible = true, 
		transformation(origin = {-50, 100}, extent = {{20, -20}, {-20, 20}}, rotation = 90), 
		iconTransformation(origin = {-60, 100}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
	
equation
	port_a.m_flow + port_b.m_flow = 0.0;
	port_a.p = port_b.p;

	h_in=inStream(port_a.h_outflow);

	h_out=port_b.h_outflow;
	h_out=port_a.h_outflow;
	
	if on_renewable then
		h_out = h_in + P_elec_in*heater_efficiency/port_a.m_flow;
	else
		h_out = h_hot_set;
	end if;

annotation (Documentation(info="<html>
<p>
<b>SimpleResistiveHeater</b> models the behavior of a resistive heater used in fluid heating systems. It calculates the outlet enthalpy of a fluid based on the input parameters and the status of the grid. The model takes into account the specified efficiency of the electric heater and the inlet fluid temperature to determine the outlet temperature.
</p>
<p>
The <b>SimpleResistiveHeater</b> model has the following connectors:
</p>
<ul>
<li> A <b>port_a</b> and a <b>port_b</b> for fluid inflow and outflow. These connectors have variables such as mass flow rates and pressures.</li>
<li> A <b>on_renewable</b> input signal that determines whether the grid is on or off.</li>
</ul>
<p>
The model requires the <b>Medium</b> package from the <b>Media</b> library for fluid properties. The default medium package is <b>MoltenSalt_ph</b>.
</p>
<p>
The following parameters must be defined:
</p>
<ul>
<li> <b>T_cold_set</b>: Inlet fluid temperature at design, in Kelvin. Default: 290 Celsius.</li>
<li> <b>T_hot_set</b>: Outlet fluid temperature at design, in Kelvin. Default: 565 Celsius.</li>
<li> <b>heater_efficiency</b>: Electric heater efficiency. Default: 0.99.</li>
</ul>
</html>",
revisions="<html>
<ul>
	<li><i>September 2023</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
	Created documentation for SimpleResistiveHeater.</li>
</ul>
</html>"));

end SimpleResistiveHeater;
