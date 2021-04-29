within SolarTherm.Media.Sodium.Sodium_pT_table;

function extends thermalConductivity "Return thermal conductivity"
	algorithm
		lambda := lamda_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end thermalConductivity;