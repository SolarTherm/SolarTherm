model TroughWagner
	extends SolarTherm.Systems.GenericSystem(
		weaFile="resources/Mildura_Real2010_Created20130430.motab",
		fluxFile="resources/field_flux.motab",
		sm=2.5,
		P_nom=100e6,
		eff_cyc=0.37,
		t_storage=6,
		rec_ci={4.75, -8, 4.5, -0.25},
		rec_ca={1},
		rec_cw={1},
		tnk_cf={0, 1},
		tnk_ca={1},
		blk_cf={0.5628, 0.8685, -0.5164, 0.0844},
		blk_ca={1, -0.002}
		);
end TroughWagner;
