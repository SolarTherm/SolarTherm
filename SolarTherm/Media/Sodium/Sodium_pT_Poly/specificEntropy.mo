within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends specificEntropy "Return specific entropy"
	algorithm
		s := s_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));
	end specificEntropy;