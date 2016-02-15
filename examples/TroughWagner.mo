model TroughWagner
	extends SolarTherm.Systems.GenericSystem(
		weaFile="resources/AUS_NT.Alice.Springs.Airport.943260_RMY.motab",
		//weaFile="resources/USA_CA_Daggett.Barstow-Daggett.AP.723815_TMY3.motab",
		// Numerical problem with daggett solar position calcs
		// The TMY2 Daggett data was actually used, but don't have conversion yet
		optFile="resources/troughwagner_opt_eff.motab",
		SM=1.9343,
		P_gro=111e6,
		eff_cyc=0.3774,
		eff_opt=0.7449, // Should be max value in optFile
		t_storage=6,
		ini_frac=0.1,
		rec_T_amb_des=298.15,
		tnk_T_amb_des=298.15,
		blk_T_amb_des=293.15,
		par_T_amb_des=293.15,
		dni_des=950,
		rec_fr=0.071,
		tnk_fr=0.7*24*1e-3, // 0.7kWt/MW-hr-cap converted to capacity frac per day
		par_fr=0.10, // not accounting for fixed parasitic load of 0.0055MWe/MWcap
		rec_cf={0, 4.75, -8, 4.5, -0.25}, // Our formulation is more generic, raising power to get equivalent
		rec_ca={1},
		rec_cw={1},
		tnk_cf={0, 1}, // Actual value is c0=1
		tnk_ca={1},
		blk_cf={0.5628, 0.8685, -0.5164, 0.0844},
		blk_ca={1, -0.002},
		par_cf={0.0636, 0.803, -1.58, 1.7134},
		par_ca={1, 0.0025},
		land_mult=1.5,
		pri_field=350*1.07, // 7% contingency
		pri_land=10000/4046.86, // 10,000$/acre
		pri_receiver=0,
		pri_storage=(80/(1e3*3600))*1.07, // 80$/kWht, 7% contingency
		pri_block=(940/1e3)*1.07, // 940$/kWe, 7% contingency
		pri_om_name=0.065,
		pri_om_prod=4/(1e6*3600),
		r_disc=0.055,
		t_life=25,
		t_cons=0,
		const_dispatch=true
		//const_dispatch=false,
		//sch(
		//	file="resources/daily_sch_0.motab",
		//	ndaily=5, // needs to match file
		//	wmap={
		//		{2,2,2,2,2,3,3},
		//		{4,4,4,4,4,5,5}
		//		},
		//	mmap={1,1,1,2,2,2,2,2,2,1,1,1}
		//	)
		);
	// Adapted data from:
	// Wagner, M. J.; Zhu, G. (2011). "Generic CSP Performance Model for NREL's System Advisor Model", SolarPACES 2011
	// * indicates where substitute data was used (either missing or replacement)

	// SAM:
	// Annual energy 387.538GWh
	// Capacity factor 44.3%
	// LCOE (nominal) 14.95c/kWh
	// Average DNI 7.65kWh/m2/day

	// Ours:
	// ALICE SPRINGS!
	// Annual energy 415.334GWh
	// Capacity factor 47.6%
	// LCOE (real) 12.0c/kWh
	// Average DNI 2637.35/365 = 7.23kWh/m2/day
	Real dni_annual(unit="kWh/m2");
	initial equation
		dni_annual = 0;
	equation
		der(dni_annual) = wea.wbus.dni/(1000*3600);
end TroughWagner;
