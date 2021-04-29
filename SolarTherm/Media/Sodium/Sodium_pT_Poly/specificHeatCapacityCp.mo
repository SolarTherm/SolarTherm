within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends specificHeatCapacityCp
		"Return specific heat capacity at constant pressure"
	algorithm
		cp := SolarTherm.Media.Sodium.Sodium_Poly_utilities.cp_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end specificHeatCapacityCp;