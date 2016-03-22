within SolarTherm.Fluid.Flows;
model DarcyWeisbachFlow "Darcy-Weisbach flow equations"
	extends SolarTherm.Fluid.Flows.Flow;
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	parameter SI.Length L = 1 "Length of pipe";
	parameter SI.Length D = 0.1 "Diameter of pipe";
	parameter Real f_D = 1.0 "Darcy-Weisbach friction factor";
protected
	parameter SI.Area A = CN.pi*D^2/4;

	SI.Velocity v "Average velocity of fluid";
equation
	v = m_flow/(A*d_avg);
	dp = f_D*(L/D)*d_avg*v^2/2;
end DarcyWeisbachFlow;
