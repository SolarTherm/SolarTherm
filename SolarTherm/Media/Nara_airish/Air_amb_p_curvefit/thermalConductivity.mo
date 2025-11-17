within SolarTherm.Media.Nara_airish.Air_amb_p_curvefit;

function extends thermalConductivity "Return thermal conductivity"
	algorithm
		lambda := k_T(T_h(state.h));
		annotation (Documentation(info="<html>

			</html>"));
	end thermalConductivity;