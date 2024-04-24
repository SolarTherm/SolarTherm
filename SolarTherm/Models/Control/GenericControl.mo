within SolarTherm.Models.Control;
model GenericControl
	extends SolarTherm.Icons.Control;

	// Parameters
	parameter Real level_on = 10 "Fraction of Emax to start discharge";
	parameter Real level_off = 5 "Fraction of Emax to stop discharge";
	parameter Real level_curtailment_on = 99 "Fraction of Emax to start curtailment";
	parameter Real level_curtailment_off = 96 "Fraction of Emax to stop curtailment";

	parameter SI.Time t_process_ramp_up = 15*60 "Delay until power block starts";
	parameter SI.Time t_process_ramp_dw = 10*60 "Delay until power block shuts off";

	parameter Integer ramp_order = 1 "ramping filter order";

	parameter SI.HeatFlowRate Q_schedule_des = 5e7;

	// Connectors
	Modelica.Blocks.Interfaces.RealInput Q_schedule "Scheduled discharge heat flow rate" 
		annotation(
		Placement(visible = true, transformation(origin = {-108, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
		iconTransformation(origin = {-108, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	
	Modelica.Blocks.Interfaces.RealInput storage_level "Instantaneous storage level" 
		annotation(
		Placement(visible = true, transformation(origin = {-108, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
		iconTransformation(origin = {-108, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealOutput Q_discharging "Heat flow rate discharging the storage" 
		annotation(
		Placement(visible = true, transformation(origin = {108, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
		iconTransformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	
	Modelica.Blocks.Interfaces.BooleanOutput curtailment "Curtailment signal to power input" 
		annotation(Placement(transformation(origin = {0, -107}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));

	SolarTherm.Utilities.Transition.Ramp ramp_up_proc(ramp_order=ramp_order, t_dur= t_process_ramp_up, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_proc(ramp_order=ramp_order, t_dur= t_process_ramp_dw, up=false);

	SI.Time  t_blk_w_now "Time of power block current warm-up event";
	SI.Time  t_blk_w_next "Time of power block next warm-up event";
	SI.Time  t_blk_c_now "Time of power block current cool-down event";
	SI.Time  t_blk_c_next "Time of power block next cool-down event";

	Integer process_state(min=1, max=4) "Power block state";
	Real fr_ramp_blk (min=0.0, max=1.0) "ramping transition rate for the power block";

algorithm
	when process_state == 2 and Q_schedule <= 0 then
		process_state := 1; // turn off (or stop ramping) due to no demand
	elsewhen process_state == 2 and storage_level <= level_off then
		process_state := 1; // turn off (or stop ramping) due to empty tank
	elsewhen process_state == 3 and Q_schedule <= 0 and t_process_ramp_dw > 0 then
		process_state := 4; // ramp down due to no demand
	elsewhen process_state == 3 and Q_schedule <= 0 and t_process_ramp_dw <= 0 then
		process_state := 1; // turn off (no ramp-down) due to no demand
	elsewhen process_state == 3 and storage_level <= level_off and t_process_ramp_dw > 0 then
		process_state := 4; // ramp down due to empty tank
	elsewhen process_state == 3 and storage_level <= level_off and t_process_ramp_dw <= 0 then
		process_state := 1; // turn off (no ramp down) due to empty tank
	elsewhen process_state == 2 and time >= t_blk_w_next then
		process_state := 3; // operational, ramp-up completed
	elsewhen process_state == 1 and Q_schedule > 0 and storage_level >= level_on  and t_process_ramp_up > 0 then
		process_state := 2; // ramp up, demand and tank has capacity
	elsewhen process_state == 1 and Q_schedule > 0 and storage_level >= level_on  and t_process_ramp_up <= 0 then
		process_state := 3; // operational (no ramp-up)
	elsewhen process_state == 4 and time >= t_blk_c_next then
		process_state := 1; // turn off after the ramp-down is complete
	end when;

	when process_state == 2 then
		t_blk_w_now := time;
		t_blk_w_next := time + t_process_ramp_up;
	end when;

	when process_state == 4 then
		t_blk_c_now := time;
		t_blk_c_next := time + t_process_ramp_dw;
	end when;

	when storage_level > level_curtailment_on then
		curtailment := true;
	elsewhen storage_level < level_curtailment_off then
		curtailment := false;
	end when;

	if process_state == 2 then
		fr_ramp_blk := if ramp_order == 0 then 0.0 else abs(ramp_up_proc.y);
	elseif process_state == 4 then
		fr_ramp_blk := if ramp_order == 0 then 0.0 else abs(ramp_down_proc.y);
	else
		fr_ramp_blk := 0;
	end if;

initial equation
	process_state = 3;
	t_blk_w_now = 0;
	t_blk_w_next = 0;
	t_blk_c_now = 0;
	t_blk_c_next = 0;

	if storage_level > level_curtailment_off then
		curtailment = true;
	elseif storage_level < level_curtailment_off then
		curtailment = false;
	else
		curtailment = true;
	end if;

equation

	ramp_up_proc.x = t_blk_w_now;
	ramp_down_proc.x = t_blk_c_now;

	if process_state <=1 then
		Q_discharging = 0;
	elseif process_state == 2 then
		Q_discharging = if ramp_order == 0 then Q_schedule else fr_ramp_blk * Q_schedule;
	elseif process_state == 4 then
		Q_discharging = fr_ramp_blk * Q_schedule;
	else
		Q_discharging = Q_schedule;
	end if;

annotation(
    Documentation(info = "<html>
<p>
<b>GenericControl</b> models the control logic to run the dispatch of energy from the thermal energy storage.
</p>
<p>
The <b>GenericControl</b> model includes the following parameters and connectors:
</p>
<ul>
<li> Parameters:
  <ul>
    <li> <b>level_on</b>: Fraction of storage capacity (Emax) to start discharge.</li>
    <li> <b>level_off</b>: Fraction of storage capacity (Emax) to stop discharge.</li>
    <li> <b>level_curtailment_on</b>: Fraction of storage capacity (Emax) to start curtailment.</li>
    <li> <b>level_curtailment_off</b>: Fraction of storage capacity (Emax) to stop curtailment.</li>
  </ul>
</li>
<li> Connectors:
  <ul>
    <li> <b>m_flow_schedule</b>: Scheduled discharge mass flow rate.</li>
    <li> <b>m_flow_pump_charging</b>: Mass flow rate of the pump charging the tank.</li>
    <li> <b>tank_level</b>: Instantaneous tank level.</li>
    <li> <b>curtailment_logic</b>: Algorithm to activate/deactivate curtailment.</li>
    <li> <b>logic</b>: Algorithm to calculate the discharging mass flow rate.</li>
    <li> <b>curtailment</b>: Curtailment signal to power input.</li>
    <li> <b>m_flow_pump_discharging</b>: Mass flow rate of the pump discharging the tank.</li>
    <li> <b>W_loss</b>: Pumping parasitic power due to discharge.</li>
  </ul>
</li>
</ul>
</html>", revisions = "<html>
<ul>
  <li><i>September 2023</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
  Created documentation for HotPumpControl.</li>
</ul>
</html>"),
    Icon(graphics = {Text(origin = {-10, 254}, lineColor = {0, 0, 255}, extent = {{-149, -114}, {151, -154}}, textString = "%name")}));
end GenericControl;