within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends dynamicViscosity "Return dynamic viscosity"
	algorithm
		eta := eta_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end dynamicViscosity;