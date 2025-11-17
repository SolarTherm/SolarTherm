within SolarTherm.Media.Nara_airish.Air_amb_p;

function extends dynamicViscosity "Return dynamic viscosity"
	algorithm
		eta := mu_T(T_h(state.h));
		annotation (Documentation(info="<html>

			</html>"));
	end dynamicViscosity;