within SolarTherm.Media.Sodium.Sodium_pT_table;

function extends specificGibbsEnergy "Return specific Gibbs energy"
	algorithm
		g := gibbs_T(state.T);
		annotation (Documentation(info="<html>

			</html>"));	
	end specificGibbsEnergy;