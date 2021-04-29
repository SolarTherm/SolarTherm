within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function setState_pTX
		"Return thermodynamic state as function of p, T and composition X or Xi"
		extends Modelica.Icons.Function;
		input AbsolutePressure p "Pressure";
		input Temperature T "Temperature";
		input MassFraction X[:]=reference_X "Mass fractions";
		output ThermodynamicState state "Thermodynamic state record";
	algorithm
		state := ThermodynamicState(p=p, T=T);
	end setState_pTX;