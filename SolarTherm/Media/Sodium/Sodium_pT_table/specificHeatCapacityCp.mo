within SolarTherm.Media.Sodium.Sodium_pT_table;

function extends specificHeatCapacityCp
		"Return specific heat capacity at constant pressure"
	algorithm
		cp := cp_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end specificHeatCapacityCp;