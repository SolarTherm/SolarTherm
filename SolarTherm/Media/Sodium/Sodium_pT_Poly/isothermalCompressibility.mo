within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends isothermalCompressibility
		"Return overall the isothermal compressibility factor"
	algorithm
		kappa := kappa_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end isothermalCompressibility;