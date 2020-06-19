model TestGraphiteProperty
import SI = Modelica.SIunits;
import SolarTherm.Materials.Graphite;
	

	SolarTherm.Materials.Graphite.State graphite "state";

	parameter SI.Temperature T_start = 575 "Start temperature of everything in the tank (K)";
	//parameter SI.SpecificEnthalpy h_p_start = SolarTherm.Materials.Graphite.h_Tf(T_start);
	//SI.SpecificEnthalpy h_p(start = h_p_start) "J/kg";

	parameter SI.SpecificEnthalpy h_p_start =370939;

	SI.ThermalConductivity k_p "W/mK";
	SI.Density rho_p "kg/m3";
	SI.Temperature T_p "Temperature (K)";

equation
	graphite.h=h_p_start;
	k_p=graphite.k;
	rho_p=graphite.rho;
	T_p=graphite.T;
	
end TestGraphiteProperty;
