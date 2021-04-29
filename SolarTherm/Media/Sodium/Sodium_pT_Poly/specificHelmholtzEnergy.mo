within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends specificHelmholtzEnergy "Return specific Helmholtz energy"
	algorithm
		f := helmholtz_pT(T = state.T,p = state.p);
		annotation (Documentation(info="<html>

			</html>"));	
	end specificHelmholtzEnergy;