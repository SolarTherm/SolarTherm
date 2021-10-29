within SolarTherm.Models.PowerBlocks.sCO2Cycle;
model SourceFlow
	extends SolarTherm.Media.CO2.PropCO2;
	replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;

	MedPB.ThermodynamicState state_b ;

	parameter Real T_out=100;
	parameter Real p_out = 73*10^5;
	parameter Real m_flow = 10;
	parameter Boolean use_m_parameter = true;

	Real test;
	Real TEST2;

	Modelica.Fluid.Interfaces.FluidPort_b port_b (redeclare package Medium=MedPB) annotation(
		Placement(visible = true, transformation(origin = {80,0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
	state_b=MedPB.setState_pTX(p_out,T_out);
	port_b.h_outflow=MedPB.specificEnthalpy(state_b);
	test=MedPB.temperature(state_b);
	TEST2=inStream(port_b.h_outflow);

	if use_m_parameter then 
	port_b.m_flow = -max(m_flow*(0.5+time),m_flow*0.0001);
	end if;

	port_b.p = state_b.p;
end SourceFlow;
