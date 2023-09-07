within SolarTherm.Models.Fluid.HeatExchangers;
model SimpleResistiveHeater
	extends SolarTherm.Interfaces.Models.SimpleResistiveHeater;
	parameter Modelica.SIunits.Temperature T_cold_set = from_degC(290);
	parameter Modelica.SIunits.Temperature T_hot_set = from_degC(565);
	final parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold fluid thermodynamic state at design";
	final parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Cold fluid thermodynamic state at design";
	final parameter Modelica.SIunits.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold fluid specific enthalpy at design";  
	final parameter Modelica.SIunits.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Cold fluid specific enthalpy at design";
	
	Modelica.SIunits.SpecificEnthalpy h_in;
	Modelica.SIunits.SpecificEnthalpy h_out;

	Modelica.Blocks.Interfaces.BooleanInput on_renewable annotation(
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
		h_out = h_in + P_elec_in/port_a.m_flow;
	else
		h_out = h_hot_set;
	end if;

end SimpleResistiveHeater;
