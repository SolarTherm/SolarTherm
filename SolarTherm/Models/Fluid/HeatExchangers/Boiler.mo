within SolarTherm.Models.Fluid.HeatExchangers;
model Boiler
	extends SolarTherm.Interfaces.Models.Boiler;
	
	// Import required units and packages
	import Modelica.SIunits.Conversions.*;
	
	// Parameters
	parameter Modelica.SIunits.HeatFlowRate Q_flow_ref = 50e6 "Design thermal power";
	parameter Modelica.SIunits.Temperature T_cold_set = from_degC(290);
	parameter Modelica.SIunits.Temperature T_hot_set = from_degC(565);
	final parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
	final parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hot salt thermodynamic state at design";
	final parameter Modelica.SIunits.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";  
	final parameter Modelica.SIunits.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";  
	final parameter SI.MassFlowRate m_flow_ref = Q_flow_ref / (h_hot_set - h_cold_set) "Mass flow rate at design";
	final parameter Real nu_eps = 1e-3 "Minimum load";
	parameter Real nu_min = 0.25 "Minimum boiler operation";
	
	// Variables
	Real load;
	Boolean logic;
	
	// Outputs
	Modelica.SIunits.HeatFlowRate Q_flow;
	Modelica.SIunits.Energy E_thermal;
	Modelica.SIunits.SpecificEnthalpy h_in;
	Modelica.SIunits.SpecificEnthalpy h_out;
	
equation
	// Calculate load and logic
	load = max(nu_eps, port_a.m_flow / m_flow_ref);
	logic = load > nu_min;
	
	// Inlet and outlet enthalpy calculations
	h_in = inStream(port_a.h_outflow);
	h_out = port_b.h_outflow;
	h_out = port_a.h_outflow;
	h_out = h_cold_set;
	
	// Mass and pressure balance
	port_a.m_flow + port_b.m_flow = 0;
	port_a.p = port_b.p;
	
	// Calculate Q_flow based on logic
	if logic then
		Q_flow = -port_a.m_flow * (h_out - h_in);
	else
		Q_flow = 0;
	end if;
	
	// Thermal energy balance
	Q_flow = der(E_thermal);

annotation (Documentation(info="<html>
<p>
<b>Boiler</b> models the behavior of a boiler unit in a fluid heating system. It calculates the thermal power output based on the input parameters and the system's load conditions. The model employs energy and mass balances to determine the heat flow rate and includes parameters for controlling the minimum load and turbine operation.
</p>
<p>
The <b>Boiler</b> model has the following connectors:
</p>
<ul>
<li> A <b>port_a</b> and a <b>port_b</b> for fluid inflow and outflow. These connectors include variables such as mass flow rates, pressures, and specific enthalpies.</li>
<li> A <b>load</b> variable that represents the load condition of the boiler.</li>
<li> A <b>logic</b> variable that determines whether the boiler operates based on load conditions.</li>
</ul>
<p>
The model requires the <b>Medium</b> package from the <b>Media</b> library for fluid properties. The default medium package is <b>MoltenSalt_ph</b>.
</p>
<p>
The following parameters must be defined:
</p>
<ul>
<li> <b>Q_flow_ref</b>: Design thermal power, in Watts. Default: 50e6 W.</li>
<li> <b>T_cold_set</b>: Inlet fluid temperature at design, in Kelvin. Default: 290 Celsius.</li>
<li> <b>T_hot_set</b>: Outlet fluid temperature at design, in Kelvin. Default: 565 Celsius.</li>
<li> <b>nu_eps</b>: Minimum load condition. Default: 1e-3.</li>
<li> <b>nu_min</b>: Minimum boiler operation. Default: 0.25.</li>
</ul>
</html>", revisions="<html>
<ul>
	<li><i>September 2023</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
	Created documentation for Boiler.</li>
</ul>
</html>"));
end Boiler;