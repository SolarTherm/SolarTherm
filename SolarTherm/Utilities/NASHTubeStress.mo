within SolarTherm.Utilities;
function NASHTubeStress
	extends Modelica.Icons.Function;
	input Real m_flow;
	input Real Ri;
	input Real Ro;
	input Real Tf;
	input Real Tamb;
	input Real q0[Nz];
	input Integer Nz;
	input Boolean verbose;
	output Real Tcrow[Nz];
	output Real trupture[Nz];
	output Real nfailure[Nz];
	output Real Stress[Nz];
	output Real Strain[Nz];
	external "C" damage_crown(m_flow, Ri, Ro, Tf, Tamb, q0, Nz, Tcrow, trupture, nfailure, Stress, Strain, verbose);
	annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",Include="#include \"st_nash_tube_stress.c\"",Library = {"m","gsl"});
end NASHTubeStress;
