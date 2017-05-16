model DishSG4
	extends SolarTherm.Systems.GenericSystem(
		wea_file="resources/weather/AUS_NT.Alice.Springs.Airport.943260_RMY.motab",
		opt_file="resources/optics/sg4_opt_eff.motab",
		pri_file="resources/prices/aemo_vic_2014.motab",
		SM=1.2,
		P_gro=133.89e3,
		eff_cyc=0.37,
		eff_opt=0.9506, // Should be max value in optFile
		t_storage=0,
		deploy_angle=5,
		stow_angle=5,
		rec_T_amb_des=298.15,
		blk_T_amb_des=294.15,
		par_T_amb_des=294.15, // Assuming
		rec_fr=0.02822,
		par_fr=0.08,
		par_fix_fr=0.0055, // fixed parasitic load of 0.0055MWe/MWcap
		rec_cf={0, 8.6081, -23.7695, 25.0621, -8.9007}, // Our formulation is more generic, raising power to get equivalent
		rec_ca={1, -0.00228, 0.00012905, -4.8891e-07},
		rec_cw={1},
		blk_cf={0.5628, 0.8685, -0.5164, 0.0844, 0.0007},
		blk_ca={1, -0.002},
		par_cf={0.0636, 0.803, -1.58, 1.7134},
		par_ca={1, 0.0025},
		land_mult=1.5,
		pri_field=500*1.07, // 7% contingency
		pri_land=10000/4046.86, // 10,000$/acre
		pri_receiver=0,
		pri_storage=0,
		pri_block=(1347/1e3)*1.07, // 1347$/kWe, 7% contingency
		pri_om_name=0.065,
		pri_om_prod=4/(1e6*3600),
		r_disc=0.076,
		t_life=25,
		t_cons=0
		);

	// SG4 250deg
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

	// Direct costs
	// Field cost 500$/m2 (484.222)
	// Power plant cost 1347$/kWe
	// Contingency 7%

	// Indirect costs
	// EPC and owner cost 11%
	// Total land cost 10000$/acre (1acre, in spreadsheet 0.17962acre)

	// O&M costs
	// Fixed capacity costs 65$/kWe/year 
	// Variable cost by generation 4$/MWh

	// Commercial load parameters
	// Debt fraction 60%
	// Load term 15years
	// Loan rate 7.78%

	// Analysis parameters
	// Analysis period 25years
	// Inflation rate 2.50%/year
	// Real discount rate 7.60%/year
	// Nominal discount rate 10.29%/year (=(1+real)*(1+infl) - 1)

	// Calculations:
	// LCOE real 11.7346c/kWh
	// LCOE nominal 14.60c/kWh
	// Annual energy 333 835kWh
	// Capacity factor 31.3987%
	// Total annual dni for site 2636.5kWh/m2

	// All financing stuff we do not have turned off
	// LCOE real 15.1c/kWh
	// LCOE nominal 18.8c/kWh

	// Our calcs:
	// LCOE (real) 14.6c/kWh
	// Annual energy 340.2MW/year
	// Capacity factor 31.5%
	// Total annual dni for site 2637.29kWh/m2

	Real dni_annual(unit="kWh/m2");
	initial equation
		dni_annual = 0;
	equation
		der(dni_annual) = wea.wbus.dni/(1000*3600);
end DishSG4;
