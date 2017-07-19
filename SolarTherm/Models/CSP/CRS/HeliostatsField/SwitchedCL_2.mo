within SolarTherm.Models.CSP.CRS.HeliostatsField;
block SwitchedCL_2 "Collector with on/off switch, defocus and warm-up delay features"
	extends SolarTherm.Models.CSP.CRS.HeliostatsField.Collector;
	import SI = Modelica.SIunits;

	parameter SI.Irradiance dni_stop = 200 "DNI at which concentrator stops";
	parameter SI.Irradiance dni_start = 300 "DNI at which concentrator starts";
	parameter SI.Time t_con_on_delay = 20*60 "Delay until concentrator starts";

	replaceable model OptEff =
		SolarTherm.Models.CSP.CRS.HeliostatsField.OptEff;	// should replace

	Modelica.Blocks.Interfaces.BooleanInput track "Set to true to start tracking";
	Modelica.Blocks.Interfaces.BooleanInput defocus(start=false) "true if the defocusing state is on";
	input SI.RadiantPower R_dfc "The targer radiation power at the defocused state";

	Integer con_state(min=1, max=3) "Concentrator state";
	Real t_con_next "Time of next concentrator event";
	Real fr_dfc[nelem] "Target energy fraction at the defocused state";

	OptEff oeff(nelem=nelem);

	Modelica.Blocks.Logical.Timer timer "Timer measuring the times that the solar field is on";
	discrete SI.Time time_on(start=0, fixed=true) "Time marking when the solar field starts running";
	discrete SI.Time dt_on(start=0, fixed=true) "Time duration of everytime the solar field is on";
	discrete SI.Time tot "Total operating time of the solar field";
	Boolean on(start=false, fixed=true) "the solar field on/off signal";

initial equation
	pre(tot) = 0;
	con_state = 1;
	t_con_next = 0;

algorithm
	when con_state >= 2 and (wbus.dni < dni_stop or not track) then
		con_state := 1; // off sun
	elsewhen con_state == 1 and wbus.dni >= dni_start and track then
		con_state := 2; // start onsteering
	elsewhen con_state == 2 and time >= t_con_next then
		con_state := 3; // on sun
	end when;

	when con_state == 2 then
		t_con_next := time + t_con_on_delay;
	end when;

	on := if con_state == 3 then true else false;

	when on then
		time_on := time;
	end when;

equation
	connect(wbus, oeff.wbus);

	for i in 1:nelem loop
		if defocus then
			R_foc[i] = if con_state <= 2 then 0 else min(R_dfc,max(oeff.eff[i]*wbus.dni*A, 0));
			fr_dfc[i] = if con_state <= 2 then 0 else R_foc[i] / (max(oeff.eff[i]*wbus.dni*A, 0) + 1e6);
		else
			fr_dfc[i] = if con_state <= 2 then 0 else 1;
			R_foc[i] = if con_state <= 2 then 0 else max(oeff.eff[i]*wbus.dni*A, 0);
		end if;
	end for;

	timer.u = on;
	dt_on = timer.y;

	when dt_on <= 0 then
		tot = pre(tot) + pre(dt_on);
	end when;

	when terminal() then
		reinit(tot, pre(tot) + dt_on);
	end when;

end SwitchedCL_2;
