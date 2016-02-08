model DishSG4
	extends SolarTherm.Systems.GenericSystem(
		weaFile="resources/AUS_NT.Alice.Springs.Airport.943260_RMY.motab",
		fluxFile="resources/sg4_flux.motab",
		priFile="resources/aemo_vic_2014.motab",
		SM=1.2,
		P_gross=133.89e3,
		P_rate=0.9065*133.89e3,
		eff_cyc=0.37,
		t_storage=0, // *
		rec_T_amb_des=298.15,
		blk_T_amb_des=294.15, //
		par_T_amb_des=294.15, // *
		rec_fr=0.02822,
		par_fr=0.08, // *
		rec_ci={0, 8.6081, -23.7695, 25.0621, -8.9007}, // Our formulation is more generic, raising power to get equivalent
		rec_ca={1, -0.00228, 0.00012905, -4.8891e-07},
		rec_cw={1},
		blk_cf={0.5628, 0.8685, -0.5164, 0.0844, 0.0007},
		blk_ca={1, -0.002},
		par_cf={0.0636, 0.803, -1.58, 1.7134},
		par_ca={1, 0.0025},
		C_cap=100e6,
		C_main=100e3,
		r_disc=0.05,
		t_life= 20,
		t_cons=1
		);
	// Don't have parasitics constant term.
	// It is silly having it separate because it could be accounted for
	// in the in polynomials...

	// From SAM:
	// Field and receiver
	// Solar field design output 0.434MWt
	// Cleanliness factor 0.97
	// Reference thermal loss fraction 0.02822MWt/MWtcap
	// Thermal loss at design 0.0122542MW (is 0.434 * 0.02822)

	// Power block
	// Max over design operation 1.05
	// Minimum load 0.25
	// Power cycle startup energy 0.2
	// Boiler LHV efficiency 0.9
	// Power cycle design temp 21degC (different from field one of 25degC)
	// Temperature correction wet bulb?

	// Parasitics
	// Fixed parasitic load 0.0055MWe/MWcap
	// Production based parasitic 0.08MWe/MWe
	// Design point parasitic load 0.000738236MWe (approx 0.13389 * 0.0055)

	// LCOE real 11.7346c/kWh
	// Annual energy 333 835kWh
	// Capacity factor 31.3987

	// Total annual dni for site 2636.5kWh/m2

	// Our calcs:
	// Annual energy 328.82MW/year
	// Total annual dni for site 2637.29kWh/m2
	// Capacity factor 28.035

	Real dni_annual(unit="kWh/m2");
	initial equation
		dni_annual = 0;
	equation
		der(dni_annual) = wea.wbus.dni/(1000*3600);
end DishSG4;
