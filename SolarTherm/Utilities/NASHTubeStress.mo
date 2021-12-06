within SolarTherm.Utilities;
function NASHTubeStress
	extends Modelica.Icons.Function;
	input Integer coolant;
	input Real Ri;
	input Real Ro;
	input Real dz;
	input Real m_flow;
	input Real T_htf_in;
	input Real Tamb;
	input Real CG[:];
	input Integer nt;
	input Integer nz;
	input Real R_fouling;
	input Real ab;
	input Real em;
	input Real kp;
	input Real h_ext;
	input Real alpha;
	input Real E;
	input Real nu;
	output Real Tcrown_o[nz];
	output Real T_fluid[nz];
	output Real stress_o[nz];
	external "C" stress(coolant, Ri, Ro, dz, m_flow, T_htf_in, Tamb, 
		CG, nt, nz, R_fouling, ab, em, kp, h_ext, alpha, E, 
		nu, Tcrown_o, T_fluid, stress_o);
	annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",Include="#include \"st_nash_tube_stress.c\"",Library = {"m","gsl"});
end NASHTubeStress;
