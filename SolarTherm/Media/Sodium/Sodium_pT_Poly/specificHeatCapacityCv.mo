within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends specificHeatCapacityCv
		"Return specific heat capacity at constant volume"
	algorithm
		cv := cv_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end specificHeatCapacityCv;