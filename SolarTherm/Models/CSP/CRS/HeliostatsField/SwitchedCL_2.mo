within SolarTherm.Models.CSP.CRS.HeliostatsField;
block SwitchedCL_2 "Collector with on/off switch, defocus and warm-up and cool-down delay features"
	extends SolarTherm.Models.CSP.CRS.HeliostatsField.Collector;
	import SI = Modelica.SIunits;

	parameter SI.Irradiance dni_stop = 300 "DNI at which concentrator stops";
	parameter SI.Irradiance dni_start = 300 "DNI at which concentrator starts";
	parameter SI.Time t_con_on_delay = 30 "Delay until concentrator starts";
	parameter SI.Time t_con_off_delay = 30 "Delay until concentrator shuts off";

	parameter Integer ramp_order(min=0, max=2) "ramping filter order";

	replaceable model OptEff =
		SolarTherm.Models.CSP.CRS.HeliostatsField.OptEff;	// should replace

	Modelica.Blocks.Interfaces.BooleanInput track "Set to true to start tracking";
	Modelica.Blocks.Interfaces.BooleanInput defocus(start=false) "true if the defocusing state is on";
	input SI.RadiantPower R_dfc "The targer radiation power at the defocused state";

	Integer state(min=1, max=5) "Concentrator state";
	SI.Time t_con_w_now "Time of concentrator current warm-up event";
	SI.Time t_con_w_next "Time of concentrator next warm-up event";
	SI.Time t_con_c_now "Time of concentrator current cool-down event";
	SI.Time t_con_c_next "Time of concentrator next cool-down event";
	Real fr_dfc[nelem](each min=0, each max=1) "Target energy fraction at the defocused state";

	OptEff oeff(nelem=nelem);

	SolarTherm.Utilities.Transition.Ramp ramp_up_con(ramp_order=ramp_order, t_dur= t_con_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_con(ramp_order=ramp_order, t_dur= t_con_off_delay, up=false);
	Real fr_ramp_con (min=0, max=1) "ramping transition rate for the concentrator";

	Modelica.Blocks.Logical.Timer timer "Timer measuring the times that the solar field is on";
	discrete SI.Time time_on(start=0, fixed=true) "Time marking when the solar field starts running";
	discrete SI.Time dt_on(start=0, fixed=true) "Time duration of everytime the solar field is on";
	discrete SI.Time tot "Total operating time of the solar field";
	Boolean on(start=false, fixed=true) "the solar field on/off signal";

initial equation
	pre(tot) = 0;
	state = 1;
	t_con_w_now = 0;
	t_con_w_next = 0;
	t_con_c_now = 0;
	t_con_c_next = 0;

algorithm
	when state == 2 and (wbus.dni <= dni_stop or defocus or not track) then
		state := 1; // off sun
	elsewhen state == 3 and (wbus.dni <= dni_stop) and t_con_off_delay > 0 then
		state := 5; // ramp down
	elsewhen state == 3 and (wbus.dni <= dni_stop) and t_con_off_delay <= 0 then
		state := 1; // off sun(no ramp-down)
	elsewhen state == 3 and defocus then
		state := 4; // on sun at part load
	elsewhen state == 4 and not defocus then
		state := 3; // on sun at full load
	elsewhen state == 4 and (wbus.dni <= dni_stop) and t_con_off_delay > 0 then
		state := 5; // ramp down
	elsewhen state == 4 and (wbus.dni <= dni_stop) and t_con_off_delay <= 0 then
		state := 1; // off sun (no ramp-down)
	elsewhen state == 1 and wbus.dni >= dni_start and not defocus and track and t_con_on_delay > 0 then
		state := 2; // start onsteering (i.e. ramp up)
	elsewhen state == 1 and wbus.dni >= dni_start and not defocus and track and t_con_on_delay <= 0 then
		state := 3; // on sun at full load (no ramp-up)
	elsewhen state == 2 and time >= t_con_w_next then
		state := 3; // on sun at full load
	elsewhen state == 5 and time >= t_con_c_next then
		state := 1; // Off sun
	end when;

	when state == 2 then
		t_con_w_now := time;
		t_con_w_next := time + t_con_on_delay;
	end when;

	when state == 5 then
		t_con_c_now := time;
		t_con_c_next := time + t_con_off_delay;
	end when;

	if state == 2 then
		fr_ramp_con := if ramp_order == 0 then 0 else abs(ramp_up_con.y);
	elseif state == 5 then
		fr_ramp_con := if ramp_order == 0 then 0 else abs(ramp_down_con.y);
	else
		fr_ramp_con := 0;
	end if;

	on := if (state == 3 or state == 4) then true else false;

	when on then
		time_on := time;
	end when;

equation
	connect(wbus, oeff.wbus);

	ramp_up_con.x = t_con_w_now;
	ramp_down_con.x = t_con_c_now;

	for i in 1:nelem loop
		if state <= 1 then
			fr_dfc[i] = 0;
			R_foc[i] = 0;
		elseif state == 2 then
			fr_dfc[i] = if ramp_order == 0 then 0 else 1;
			R_foc[i] = fr_ramp_con * max(oeff.eff[i]*wbus.dni*A, 0);
		elseif state == 5 then
			fr_dfc[i] = if ramp_order == 0 then 0 else 1;
			R_foc[i] = fr_ramp_con * max(oeff.eff[i]*wbus.dni*A, 0);
		else
			if defocus then
				if (oeff.eff[i]*wbus.dni*A) > R_dfc then
					fr_dfc[i] = R_foc[i] / (max(oeff.eff[i]*wbus.dni*A, 0) + 1e-10);
					R_foc[i] = min(R_dfc,max(oeff.eff[i]*wbus.dni*A, 0));
				else
					fr_dfc[i] = 1;
					R_foc[i] = max(oeff.eff[i]*wbus.dni*A, 0);
				end if;
			else
				fr_dfc[i] = 1;
				R_foc[i] = max(oeff.eff[i]*wbus.dni*A, 0);
			end if;
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
