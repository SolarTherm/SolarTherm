model TroughWagner
	extends SolarTherm.Systems.GenericSystem(
		weaFile="resources/Mildura_Real2010_Created20130430.motab", //*
		fluxFile="resources/field_flux.motab", // *
		priFile="resources/aemo_vic_2014.motab", // *
		SM=2.5, // *
		P_gross=111e6,
		P_rate=100e6,
		eff_cyc=0.3774,
		t_storage=6,
		rec_T_amb_des=298.15, // *
		tnk_T_amb_des=298.15, // *
		blk_T_amb_des=298.15, // *
		par_T_amb_des=298.15, // *
		rec_fr=0.03, // *
		tnk_fr=0.05, // *
		par_fr=0.10, // *
		rec_ci={0, 4.75, -8, 4.5, -0.25}, // Our formulation is more generic, raising power to get equivalent
		rec_ca={1},
		rec_cw={1},
		tnk_cf={0, 1}, // *
		tnk_ca={1}, // *
		blk_cf={0.5628, 0.8685, -0.5164, 0.0844},
		blk_ca={1, -0.002},
		par_cf={0.0636, 0.803, -1.58, 1.7134},
		par_ca={1, 0.0025},
		C_cap=100e6, // *  Should probably calculate these from file
		C_main=100e3, // *
		r_disc=0.05, // *
		t_life= 20, // *
		t_cons=1 // *
		);
	// Adapted data from:
	// Wagner, M. J.; Zhu, G. (2011). "Generic CSP Performance Model for NREL's System Advisor Model", SolarPACES 2011
	// * indicates where substitute data was used (either missing or replacement)
end TroughWagner;
