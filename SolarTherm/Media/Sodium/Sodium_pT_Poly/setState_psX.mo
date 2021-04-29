within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function setState_psX
		"Return thermodynamic state as function of p, s and composition X or Xi"
		extends Modelica.Icons.Function;
		input AbsolutePressure p "Pressure";
		input SpecificEntropy s "Specific entropy";
		input MassFraction X[:]=reference_X "Mass fractions";
		output ThermodynamicState state "Thermodynamic state record";
	algorithm
		state := ThermodynamicState(p=p, T=T_s(s));
		assert(false,"no inverse funtions");
	end setState_psX;