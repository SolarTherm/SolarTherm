within SolarTherm.Models.Fluid.HeatExchangers;
block ResistiveHeater "Resistive heater with ramp features"

	import SI = Modelica.SIunits;

	//Parameters:
	//****************
	parameter SI.Power P_des "Power to heater at design";
	parameter SI.Power P_min "Minimum allowed power to heater";
	parameter SI.Power P_max "Maximum allowed power to heater";
	parameter SI.HeatFlowRate Q_flow_des "Heat flow output from heater at design";

	parameter SI.Efficiency eff_htr = 0.99 "Thermal efficiency of heater at design point";

	parameter SI.Time t_htr_on_delay = 1*60 "Delay until heater starts";
	parameter SI.Time t_htr_off_delay = 1*60 "Delay until heater shuts off";

	parameter Integer ramp_order_cons(min=0, max=2) "ramping filter order for power consumption";
	parameter Integer ramp_order_prod(min=0, max=2) "ramping filter order for thermal heat production";

	parameter Real cq_htr[:] = {1} "Heat flow output coefficients at heater";
	parameter Real cp_htr[:] = {1} "Power input coefficients at heater";

	//Variables:
	//****************
	input SI.Power P(min=0, displayUnit="MW") "Electrical power to heater";
	input SI.HeatFlowRate Q_flow_dfc(min=0, displayUnit="MW") "The target heat flow at the defocused state";
	output SI.HeatFlowRate Q_flow(min=0, displayUnit="MW") "Heat flow output from heater";

	SI.Power P_in(min=0, displayUnit="MW") "Power consumption rate at heater";

	Modelica.Blocks.Interfaces.BooleanInput grid "Set to true to start connecting to the grid";
	Modelica.Blocks.Interfaces.BooleanInput defocus(start=false) "true if the defocusing state is on";

	Integer state(min=1, max=5) "Heater state";
	SI.Time t_htr_w_now "Time of heater current warm-up event";
	SI.Time t_htr_w_next "Time of heater next warm-up event";
	SI.Time t_htr_c_now "Time of heater current cool-down event";
	SI.Time t_htr_c_next "Time of heater next cool-down event";
	Real fr_dfc(min=0, max=1, start=1) "Target power fraction at the defocused state";

	Boolean useful_prod(start=false) "true if power supply is converted to useful heat";

	SI.Power P_waste(min=0) "Power wasted at heater";

	SolarTherm.Utilities.Transition.Ramp ramp_up_cons(ramp_order=ramp_order_cons, t_dur= t_htr_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_cons(ramp_order=ramp_order_cons, t_dur= t_htr_off_delay, up=false);
	Real fr_ramp_cons (min=0, max=1) "ramping transition rate for power consumption at the heater";

	SolarTherm.Utilities.Transition.Ramp ramp_up_prod(ramp_order=ramp_order_prod, t_dur= t_htr_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_prod(ramp_order=ramp_order_prod, t_dur= t_htr_off_delay, up=false);
	Real fr_ramp_prod (min=0, max=1) "ramping transition rate for thermal heat production at the heater";

	Modelica.Blocks.Logical.Timer timer "Timer measuring the times that the heater is on";
	discrete SI.Time time_on(start=0, fixed=true) "Time marking when the heater starts running";
	discrete SI.Time dt_on(start=0, fixed=true) "Time duration of everytime the heater is on";
	discrete SI.Time tot "Total operating time of the heater";
	Boolean on(start=false, fixed=true) "the heater on/off signal";

//protected
	SolarTherm.Utilities.Polynomial.Poly q_htr(c=cq_htr);
	SolarTherm.Utilities.Polynomial.Poly p_htr_dfc(c=cp_htr);

initial equation
	pre(tot) = 0;
	state = 1;
	t_htr_w_now = 0;
	t_htr_w_next = 0;
	t_htr_c_now = 0;
	t_htr_c_next = 0;

algorithm
	when state == 2 and (P <= P_min or P >= P_max or defocus or not grid) then
		state := 1; // off
	elsewhen state == 3 and (P <= P_min or P >= P_max) and t_htr_off_delay > 0 then
		state := 5; // ramp down
	elsewhen state == 3 and (P <= P_min or P >= P_max) and t_htr_off_delay <= 0 then
		state := 1; // off (no ramp-down)
	elsewhen state == 3 and defocus then
		if Q_flow_dfc > 0 then
			state := 4; //on at part load
		elseif Q_flow_dfc <= 0 and t_htr_off_delay > 0 then
			state := 5; // ramp down
		else
			state := 1; // off (no ramp-down)
		end if;
	elsewhen state == 4 and not defocus then
		state := 3; // on at full load
	elsewhen state == 4 and (P <= P_min or P >= P_max) and t_htr_off_delay > 0 then
		state := 5; // ramp down
	elsewhen state == 4 and (P <= P_min or P >= P_max) and t_htr_off_delay <= 0 then
		state := 1; // off (no ramp-down)
	elsewhen state == 1 and P >= P_min and P <= P_max and not defocus and grid and t_htr_on_delay > 0 then
		state := 2; // start (i.e. ramp up)
	elsewhen state == 1 and P >= P_min and P <= P_max and not defocus and grid and t_htr_on_delay <= 0 then
		state := 3; // on at full load (no ramp-up)
	elsewhen state == 2 and time >= t_htr_w_next then
		state := 3; // on at full load
	elsewhen state == 5 and time >= t_htr_c_next then
		state := 1; // off
	end when;

	when state == 2 then
		t_htr_w_now := time;
		t_htr_w_next := time + t_htr_on_delay;
	end when;

	when state == 5 then
		t_htr_c_now := time;
		t_htr_c_next := time + t_htr_off_delay;
	end when;

	if state == 2 then
		fr_ramp_cons := if ramp_order_cons == 0 then 1 else abs(ramp_up_cons.y);
		fr_ramp_prod := if ramp_order_prod == 0 then 0 else abs(ramp_up_prod.y);
	elseif state == 5 then
		fr_ramp_cons := if ramp_order_cons == 0 then 0 else abs(ramp_down_cons.y);
		fr_ramp_prod := if ramp_order_prod == 0 then 0 else abs(ramp_down_prod.y);
	else
		fr_ramp_cons := 0;
		fr_ramp_prod := 0;
	end if;

	if state == 1 then
		useful_prod := false;
	elseif state == 2 or state == 4 then
		useful_prod := if ramp_order_cons == 0 then false else true;
	else
		useful_prod := true;
	end if;

	on := if (state == 3 or state == 4) then true else false;

	when on then
		time_on := time;
	end when;

equation
	ramp_up_cons.x = t_htr_w_now;
	ramp_down_cons.x = t_htr_c_now;

	ramp_up_prod.x = t_htr_w_now;
	ramp_down_prod.x = t_htr_c_now;

	if state <= 1 then
		fr_dfc = 1;
		Q_flow = 0;
		q_htr.x = 0;
		p_htr_dfc.x = 0;
		P_in = 0;
	elseif state == 2 or state == 5 then
		fr_dfc = 1;
		q_htr.x = if ramp_order_prod == 0 then 0 else (P/P_des);
		Q_flow = eff_htr * Q_flow_des * fr_ramp_prod * max(q_htr.y,0);
		p_htr_dfc.x = 0;
		P_in = fr_ramp_cons * P;
	else
		q_htr.x = (P/P_des);
		if defocus then
			if (eff_htr * Q_flow_des * max(q_htr.y,0)) > Q_flow_dfc then
				p_htr_dfc.x = (Q_flow_dfc/Q_flow_des);
				P_in = P_des*max(p_htr_dfc.y,0)/eff_htr;
				Q_flow = min(Q_flow_dfc, (eff_htr* Q_flow_des*max(q_htr.y,0)));
				fr_dfc = Q_flow / ((eff_htr * Q_flow_des*max(q_htr.y,0)) + 1e-10);
				//fr_dfc = Q_flow / ((eff_htr * Q_flow_des*max(q_htr.y,0)) + 1e-10);
				//Q_flow = min(Q_flow_dfc, (eff_htr* Q_flow_des*max(q_htr.y,0)));
				//q_htr_dfc.x = (P_in/P_des);
				//Q_flow_dfc = eff_htr * Q_flow_des*max(q_htr_dfc.y,0);
			else
				fr_dfc = 1;
				Q_flow = eff_htr * Q_flow_des * max(q_htr.y,0);
				p_htr_dfc.x = 0;
				P_in = P;
			end if;
		else
			fr_dfc = 1;
			Q_flow = eff_htr * Q_flow_des * max(q_htr.y,0);
			p_htr_dfc.x = 0;
			P_in = P;
		end if;
	end if;

	if useful_prod then
		P_waste = 0;
	else
		P_waste = P_in;
	end if;

	timer.u = on;
	dt_on = timer.y;

	when dt_on <= 0 then
		tot = pre(tot) + pre(dt_on);
	end when;

	when terminal() then
		reinit(tot, pre(tot) + dt_on);
	end when;
end ResistiveHeater;
