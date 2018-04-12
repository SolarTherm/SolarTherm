within examples;
model PS10_Bladed
	extends Modelica.Icons.Example;
	extends SolarTherm.Systems.GenericSystem(
		match_sam=false,
		wea_file=Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/ESP_Sevilla_083910_RMY.motab"),
		wdelay={1800,1800,0,0,0,0,0,0},
		angles=SolarTherm.Types.Solar_angles.ele_azi,
		opt_file=Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/ps10_flat_opt_eff.motab"),
		eff_opt=0.8,
		pri_file=Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab"),
		SM=2.0,
		P_gro=11.02e6,
		eff_cyc=0.3774,
		t_storage=6,
		ini_frac=0.1,
		deploy_angle=10,
		stow_angle=10,
		t_blk_heat=0.5,
		t_blk_cool=1.,
		blk_disp=0.25,
		blk_heat=0.2,
		tnk_min_start=0.1,
		rec_T_amb_des=293.15,
		tnk_T_amb_des=298.15,
		blk_T_amb_des=293.15,
		par_T_amb_des=293.15,
		dni_des=1000,
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
		land_mult=7.1,
		pri_field=200*1.07,
		pri_land=10000/4046.86,
		pri_receiver=0,
		pri_storage=(37/(1e3*3600))*1.07,
		pri_block=(1000/1e3)*1.07,
		pri_om_name=56.715/1e3,
		pri_om_prod=5.7320752/(1e6*3600),
		r_disc=0.07,
		t_life=27,
		t_cons=3,
		const_dispatch=true);

	Real dni_annual(unit="kWh/m2");
initial equation
	dni_annual = 0;
equation
	der(dni_annual) = wea.wbus.dni/(1000*3600);
	annotation (uses(Modelica(version="3.2.2")));
	annotation(experiment(StartTime=0.0, StopTime=31536000.0, Interval=60, Tolerance=1e-06));
end PS10_Bladed;

