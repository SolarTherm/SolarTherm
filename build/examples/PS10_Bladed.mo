within examples;
model PS10_Bladed
	extends Modelica.Icons.Example;
	extends SolarTherm.Systems.GenericSystem(
		match_sam=false,
		fac_fra_wrt_dni=true,
		fixed_field=true, // if true, R_des must be given as input, otherwise P_gro must be given as input
		wea_file=Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/ESP_Sevilla_083910_RMY.motab"),
		wdelay={1800,1800,0,0,0,0,0,0},
		angles=SolarTherm.Types.Solar_angles.ele_azi,
		opt_file=Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/ps10_bladed_opt_eff.motab"),
		eff_opt=0.8290,
		pri_file=Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab"), //note currency is in AUD
		SM=4.83,
		R_des=64017610,
		H_tower=115,
		A_receiver=100,
		A0_receiver=1571,
		eff_cyc=0.3774,
		t_storage=14.48,
		storage=true,
		ini_frac=0.1,
		deploy_angle=8,
		stow_angle=8,
		dni_start=250,
		dni_stop=250,
		t_blk_heat=0.5,
		t_blk_cool=1.,
		blk_disp=0.2,
		blk_heat=0.2,
		tnk_min_start=0.1,
		rec_T_amb_des=293.15,
		tnk_T_amb_des=298.15,
		blk_T_amb_des=293.15,
		par_T_amb_des=293.15,
		dni_des=1000,
		rec_fr=0.033,
		tnk_fr=0.7*24*1e-3,
		par_fr=0.10,
		par_fix_fr=0.0055,
		rec_cf={0.896497274901515, 0.108301589510490},
		rec_ca={0.999999999999445, -0.001260903244333},
		rec_cw={1},
		tnk_cf={0, 1},
		tnk_ca={1},
		blk_cf={0.5628, 0.8685, -0.5164, 0.0844},
		blk_ca={1, -0.002},
		par_cf={0.0636, 0.803, -1.58, 1.7134},
		par_ca={1, 0.0025},
		land_mult=7.1,
		pri_field=145*1.07, //note currency is in USD
		pri_site=16*1.07, //note currency is in USD
		pri_land=10000/4046.86, //note currency is in USD
		pri_tower = 3e6*1.07, //note currency is in USD
		idx_pri_tower = 0.0113,
		pri_receiver= 113896922*1.07, //note currency is in USD // lower case: 113896922 // upper case: 120132530
		idx_pri_receiver=0.7,
		pri_storage=(24/(1e3*3600))*1.07, //note currency is in USD
		pri_block=(1100/1e3)*1.07, //note currency is in USD
		pri_bop=340/1e3*1.07, //note currency is in USD
		pri_om_name=66/1e3, //note currency is in USD
		pri_om_prod=3.5/(1e6*3600), //note currency is in USD
		r_disc=0.055,
		t_life=25,
		t_cons=2,
		const_dispatch=true);

	Real dni_annual(unit="kWh/m2");
initial equation
	dni_annual = 0;
equation
	der(dni_annual) = wea.wbus.dni/(1000*3600);
	annotation (uses(Modelica(version="3.2.2")));
	annotation(experiment(StartTime=0.0, StopTime=31536000.0, Interval=60, Tolerance=1e-06));
end PS10_Bladed;

