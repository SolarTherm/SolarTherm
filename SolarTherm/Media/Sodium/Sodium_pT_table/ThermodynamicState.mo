within SolarTherm.Media.Sodium.Sodium_pT_table;

record extends ThermodynamicState
		"A selection of variables that uniquely defines the thermodynamic state"
		AbsolutePressure p "Absolute pressure of medium";
		Temperature T "Temperature of medium";
		annotation (Documentation(info="<html>
			
			</html>"));
	end ThermodynamicState;