within SolarTherm.Models.CSP.CRS.Receivers;
model PipeThermoMechanical
	extends SolarTherm.Interfaces.Models.Pipe;
	import SI = Modelica.SIunits;
	import Modelica.SIunits.Conversions.*;
	import SolarTherm.Utilities.NASHTubeStress;

	parameter Integer coolant = 2 "Heat transfer fluid (1: Nitrate salt, 2: Liquid sodium)";

	// Geometry
	parameter SI.Diameter id = 42e-3 "Inner tube diameter" annotation(group = "Geometry");
	parameter SI.Diameter od = 45e-3 "Outer tube diameter" annotation(group = "Geometry");
	parameter SI.Length dz = 0.42 "Longitude of the pipe segment" annotation(group = "Geometry");
	parameter Integer nt = 91 "Number of circumferential elements" annotation(group = "Geometry");
	parameter Integer nz = 25 "Number of radial elements" annotation(group = "Geometry");
	final parameter SI.Radius Ri = id / 2 "Inner tube diameter";
	final parameter SI.Radius Ro = od / 2 "Outer tube diameter";

	// Coating
	parameter SI.Efficiency ab = 0.93 "Coating absorptance" annotation(group = "Coating");
	parameter SI.Efficiency em = 0.87 "Coating emmisivity" annotation(group = "Coating");

	// Thermo-hydraulics
	parameter SI.CoefficientOfHeatTransfer h_ext = 30 "Heat transfer coefficient due to external convection";
	parameter SI.ThermalResistance R_fouling = 0;

	// Mechanical
	parameter SI.ThermalConductivity kp = 21 "Thermal conductivity of pipe metal";
	parameter SI.LinearExpansionCoefficient alpha = 20e-6 "Linear expansion coefficient of pipe metal";
	parameter SI.Stress E = 165e9 "Young's modulus of elasticity of pipe metal";
	parameter Real nu = 0.31 "Coefficient of Poisson for pipe metal";

	// Inputs
	Modelica.Blocks.Interfaces.RealInput Tamb annotation(	Placement(visible = true, 
	transformation(origin = {-100, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
	iconTransformation(origin = {-60, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
	
	Modelica.Blocks.Interfaces.RealInput v_wind annotation(Placement(visible = true,
		transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
	
	Modelica.Blocks.Interfaces.RealInput solar_flux annotation(Placement(visible = true, 
		transformation(origin = {-100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
		iconTransformation(origin = {60, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

	// Variables
	SI.Temperature Tf;
	SI.HeatFlux CG[nz];
	SI.Stress sigma[nz];
	SI.Temperature Tcrown[nz];
	SI.Temperature T_fluid[nz];

protected
	parameter Real factor[25] = 
		{0.2121837986, 0.2478704034, 0.3068942214, 0.4036800286, 0.4956872099,
		0.5910310198, 0.6791432369, 0.7694971756, 0.8452391329, 0.9051381766,
		0.9545968042, 0.9827689413, 0.997617952, 1.0000000000, 0.9903004092,
		0.9649648823, 0.9243679255, 0.8619679725, 0.7891739133, 0.7072007297,
		0.6165038089, 0.5200964267, 0.4245666699, 0.3402737446, 0.2719956786};
	Medium.ThermodynamicState state_in = Medium.setState_phX(Medium.p_default, inStream(fluid_a.h_outflow));
	Medium.ThermodynamicState state_out = Medium.setState_pTX(Medium.p_default, T_fluid[end]);
algorithm
	for i in 1:nz loop
		CG[i] := 0.85e6*solar_flux/1030.93*factor[i];
	end for;

equation
	fluid_b.m_flow + fluid_a.m_flow = 0.0;
	fluid_a.p - fluid_b.p = 0.0;

	Tf = Medium.temperature(state_in);

	fluid_b.h_outflow = Medium.specificEnthalpy(state_out);
	fluid_a.h_outflow = inStream(fluid_a.h_outflow);
	(Tcrown, T_fluid, sigma) = NASHTubeStress(coolant, Ri,Ro,dz,fluid_a.m_flow,Tf,	Tamb,
		CG,nt,nz,R_fouling,ab,em,kp,h_ext,alpha,E,nu);

end PipeThermoMechanical;