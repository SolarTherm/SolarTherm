within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function setState_phX
		"Return thermodynamic state as function of p, h and composition X or Xi"
		extends Modelica.Icons.Function;
		input AbsolutePressure p "Pressure";
		input SpecificEnthalpy h "Specific enthalpy";
		input MassFraction X[:]=reference_X "Mass fractions";
		output ThermodynamicState state "Thermodynamic state record";
	algorithm
		state := ThermodynamicState(p=p, T=T_h(h));
	end setState_phX;