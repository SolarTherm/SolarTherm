within SolarTherm.Fluid.Sources;
model FluidSink "Infinite fluid sink"
	replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
	Modelica.Fluid.Interfaces.FluidPort_a port_a(
		redeclare package Medium=Medium,
		m_flow(min=0)
		);
equation
	port_a.h_outflow = 0; // shouldn't flow backwards anyway
end FluidSink;
