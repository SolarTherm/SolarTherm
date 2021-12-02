within examples;
model FlowPathStress
	extends Modelica.Icons.Example;
	import Modelica.Utilities.Streams.*;
	import Modelica.Utilities.Strings.*;
	import Modelica.SIunits.Conversions.*;
	import SolarTherm.Utilities.NASHTubeStress;
	import SI = Modelica.SIunits;
	// *************************** Receiver and pipe section geometry ********************************
	parameter SI.Diameter id = 42e-3 "Inner tube diameter";
	parameter SI.Diameter od = 45e-3 "Outer tube diameter";
	parameter SI.Radius Ri = id / 2 "Inner tube diameter";
	parameter SI.Radius Ro = od / 2 "Outer tube diameter";
	parameter SI.Length dz = 0.42 "Longitude of the pipe segment";
	// *************************** Coating properties ************************************************
	parameter SI.Efficiency ab = 0.93 "Coating absorptance";
	parameter SI.Efficiency em = 0.87 "Coating emmisivity";
	// *************************** Weather and sky ***************************************************
	parameter SI.Temperature T_ambient = from_degC(25) "Ambient temperature";
	parameter SI.CoefficientOfHeatTransfer h_ext = 30 "Heat transfer coefficiente due to external convection";
	// *************************** Discretisations ***************************************************
	parameter Integer N = 225;
	parameter Integer nt = 91;
	// *************************** HTF parameters ****************************************************
	parameter SI.MassFlowRate m_flow = 3.7 "Mass flow rate";
	parameter SI.ThermalResistance R_fouling = 0;
	parameter SI.ThermalConductivity kp = 21 "Thermal conductivity of pipe metal";
	parameter SI.Temperature Tf = from_degC(290);
	// *************************** Tube metal parameters *********************************************
	parameter SI.LinearExpansionCoefficient alpha = 20e-6 "Linear expansion coefficient of pipe metal";
	parameter SI.Stress E = 165e9 "Young's modulus of elasticity of pipe metal";
	parameter Real nu = 0.31 "Coefficient of Poisson for pipe metal";
	// *************************** Variables ************************************************
	String filename = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/example_flux.csv");
	String line;
	SI.Stress stress_o[N];
	SI.Temperature Tcrown_o[N];
	SI.Temperature T_fluid[N];
	SI.HeatFlux solar_flux[N];
algorithm
	for i in 1:N loop
		line := readLine(filename,i);
		solar_flux[i] := scanReal(line)*1e6;
	end for;
equation
	(Tcrown_o,T_fluid,stress_o) = NASHTubeStress(
		Ri, Ro, dz, m_flow, Tf, T_ambient, solar_flux, nt, N, R_fouling, ab, em, kp, h_ext, alpha, E, nu);
	annotation(experiment(StartTime=0.0, StopTime=1, Interval=0.01, Tolerance=1e-06));
end FlowPathStress;