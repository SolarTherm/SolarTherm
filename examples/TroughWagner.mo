within examples;
model TroughWagner
	//wea_file="C:/Users/del155/Documents/Git/SolarTherm/resources/weather/USA_CA_Daggett.Barstow-Daggett.AP.723815_TMY3.motab",
	//opt_file="C:/Users/del155/Documents/Git/SolarTherm/resources/optics/troughwagner_opt_eff.motab",
	extends Modelica.Icons.Example;
	extends SolarTherm.Systems.GenericSystem(
		match_sam=false,
		wea_file=Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/USA_CA_Daggett.Barstow-Daggett.AP.723815_TMY3.motab"),
		wdelay={1800,1800,0,0,0,0,0,0},
		angles=SolarTherm.Types.Solar_angles.ele_azi,
		opt_file=Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/troughwagner_opt_eff.motab"),
		eff_opt=0.7449,
		SM=1.9343,
		P_gro=111e6,
		eff_cyc=0.3774,
		t_storage=6,
		ini_frac=0.1,
		deploy_angle=10,
		stow_angle=10,
		dni_start=0.001,
		dni_stop=0,
		t_blk_heat=0.5,
		t_blk_cool=1.,
		blk_disp=0.25,
		blk_heat=0.2,
		tnk_min_start=0.1,
		rec_T_amb_des=298.15,
		tnk_T_amb_des=298.15,
		blk_T_amb_des=293.15,
		par_T_amb_des=293.15,
		dni_des=950,
		rec_fr=0.071,
		tnk_fr=0.7*24*1e-3,
		par_fr=0.10,
		par_fix_fr=0.0055,
		rec_cf={0, 4.75, -8, 4.5, -0.25},
		rec_ca={1},
		rec_cw={1},
		tnk_cf={0, 1},
		tnk_ca={1},
		blk_cf={0.5628, 0.8685, -0.5164, 0.0844},
		blk_ca={1, -0.002},
		par_cf={0.0636, 0.803, -1.58, 1.7134},
		par_ca={1, 0.0025},
		land_mult=1.5,
		pri_field=350*1.07,
		pri_land=10000/4046.86,
		pri_receiver=0,
		pri_storage=(80/(1e3*3600))*1.07,
		pri_block=(940/1e3)*1.07,
		pri_om_name=0.065,
		pri_om_prod=4/(1e6*3600),
		r_disc=0.055,
		t_life=25,
		t_cons=0,
		const_dispatch=true);

  // The TMY2 Daggett was originally used, but don't have conversion yet
  // so changed it to TMY3 Daggett
                  // Should be max value in optFile
  //t_blk_heat=1.5,
  //t_blk_cool=6.,    // 0.7kWt/MW-hr-cap converted to capacity frac per day
                     // fixed parasitic load of 0.0055MWe/MWcap
                                    // Our formulation is more generic, raising power to get equivalent
  //rec_cf={4.75, -8, 4.5, -0.25}, // Our formulation is more generic, raising power to get equivalent
                 // Actual value is c0=1
                      // 7% contingency
                          // 10,000$/acre
                                    // 80$/kWht, 7% contingency
                            // 940$/kWe, 7% contingency
  //const_dispatch=false,
  //sch(
  //        file="resources/daily_sch_0.motab",
  //        ndaily=5, // needs to match file
  //        wmap={
  //                {2,2,2,2,2,3,3},
  //                {4,4,4,4,4,5,5}
  //                },
  //        mmap={1,1,1,2,2,2,2,2,2,1,1,1}
  //        )
 // Adapted data from:
 // Wagner, M. J.; Zhu, G. (2011). "Generic CSP Performance Model for NREL's
 // System Advisor Model", SolarPACES 2011

 // SAM original:
 // Annual energy 392.2GWh
 // Capacity factor 44.8%
 // LCOE (nominal) 14.77c/kWh
 // Average DNI 7.46kWh/m2/day

 // SAM trying to turn everything off
 // LCOE (nominal) 13.24c/kWh
 // LCOE (real) 13.24c/kWh

 // SAM modified
 // Annual energy 371GWh
 // Capf 42.4%
 // LCOE (nominal) 13.98c/kWh
 // Average DNI 7.46kWh/m2/day
 // $588M

 // Ours:
 // Annual energy 382.2GWh
 // Capacity factor 43.7%
 // LCOE (real) 13.6c/kWh
 // Average DNI 2723.71/365 = 7.46kWh/m2/day
 // $590M

 // Modifications to SAM model
 // Daggett.Barstow-Daggett TMY3 weather data
 // Max overdesign operation 1
 // Dry bulb power block reference temperature
 // PC and owner cost % of direct cost: 0%
 // Sales tax applied to: 0%
 // IRR target: 0%
 // IRR target year: 25
 // PPA price excalation: 0%/year
 // Inflation rate: 0%
 // Federal income tax rate: 0%/year
 // State income tax rate: 0%/year
 // Assessed percentage: 0%
 // Sales tax: 0%
 // Insurance rate: 0%
 // Property tax rate: 0%
 // Debt percent: 0%
 // Debt closing costs: $0
 // Load 1
 // Up-front fee: 0%
 // Months prior to operation: 0
 // Annual interest rate: 5.5%
 // Interest on reserves: 0%
 // Working capital reserve: 0mon
 // Debt service reserve accound: 0mon
 // Investment tax credit federal: 0%

	Real dni_annual(unit="kWh/m2");
initial equation
	dni_annual = 0;
equation
	der(dni_annual) = wea.wbus.dni/(1000*3600);
	annotation (uses(Modelica(version="3.2.2")));
	annotation(experiment(StartTime=0.0, StopTime=31536000.0, Interval=60, Tolerance=1e-06));
end TroughWagner;

