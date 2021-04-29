within SolarTherm.Media.Sodium.Sodium_pT_table;

function extends density_derT_p
		"Return density derivative w.r.t. temperature at constant pressure"
	algorithm
		ddTp := drho_dT_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end density_derT_p;