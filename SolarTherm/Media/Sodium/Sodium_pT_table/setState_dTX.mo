within SolarTherm.Media.Sodium.Sodium_pT_table;

function setState_dTX
		"Return thermodynamic state as function of d, T and composition X or Xi"
		extends Modelica.Icons.Function;
		input Density d "Density";
		input Temperature T "Temperature";
		input MassFraction X[:]=reference_X "Mass fractions";
		output ThermodynamicState state "Thermodynamic state record";
	algorithm
		state := ThermodynamicState(p=p_rho(d), T=T);
		assert(false,"no inverse functions");
	end setState_dTX;