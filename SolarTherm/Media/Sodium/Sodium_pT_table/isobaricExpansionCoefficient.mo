within SolarTherm.Media.Sodium.Sodium_pT_table;

function extends isobaricExpansionCoefficient
		"Return overall the isobaric expansion coefficient beta"
	algorithm
		beta := beta_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end isobaricExpansionCoefficient;