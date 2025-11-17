within SolarTherm.Media.Nara_airish.Air_amb_p_curvefit;

model extends BaseProperties(final standardOrderComponents=true)
		"Base properties of medium"

	equation
        h = state.h;
		d = rho_T(T);
		//h = h_Tf(T,0);
		u = h - p/d;
		MM = 0.02897;
		R = 8.3144/MM;
		state.p = p;
		T = T_h(h);
	end BaseProperties;