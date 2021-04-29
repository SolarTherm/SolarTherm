within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends thermalConductivity "Return thermal conductivity"
	algorithm
		lambda := SolarTherm.Media.Sodium.Sodium_Poly_utilities.lamda_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end thermalConductivity;