within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends isentropicExponent "Return isentropic exponent"
		extends Modelica.Icons.Function;
	algorithm
		gamma := cp_T(state.T) / cv_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end isentropicExponent;