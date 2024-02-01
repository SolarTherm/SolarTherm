within SolarTherm.Media.H2.H2_amb_p_table;

function extends dynamicViscosity "Return dynamic viscosity"
	algorithm
		eta := mu_T(T_h(state.h));
		annotation (Documentation(info="<html>

			</html>"));
	end dynamicViscosity;