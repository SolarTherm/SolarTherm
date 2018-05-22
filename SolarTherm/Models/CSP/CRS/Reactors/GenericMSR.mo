within SolarTherm.Models.CSP.CRS.Reactors;
model GenericMSR
	"A simple methanol synthesis reactor"
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import FI = SolarTherm.Models.Analysis.Finances;

	//Parameters:
	//****************
	parameter SI.EnergyFlowRate E_sg_des "Energy flow to methanol reactor at design";
	parameter SI.EnergyFlowRate E_sg_min "Minimum syngas energy flow rate to start MSR"; // the lower band used in regression to get the polynomial equation

	parameter SI.Time t_msr_on_delay = 30*60 "Delay until MSR starts";
	parameter SI.Time t_msr_off_delay = 30*60 "Delay until MSR shuts off";
	parameter SI.Time t_msr_trans_delay = 15*60 "Transition time when the syngas supply flow changes";

	parameter Integer ramp_order_sg(min=0, max=2) "Ramping filter order for syngas supply to MSR";
	parameter Integer ramp_order_elec(min=0, max=2) "Ramping filter order for electricity supply to MSR";
	parameter Integer ramp_order_CO2(min=0, max=2) "Ramping filter order for CO2 dump/release from MSR";
	parameter Integer ramp_order_prod(min=0, max=2) "Ramping filter order for products production from MSR";

	parameter Integer trans_order_sg(min=0, max=2) "Transitioning filter order for syngas supply to MSR while MSR is on";
	parameter Integer trans_order_elec(min=0, max=2) "Transitioning filter order for electricity supply to MSR while MSR is on";
	parameter Integer trans_order_CO2(min=0, max=2) "Transitioning filter order for CO2 dump/release from MSR while MSR is on";
	parameter Integer trans_order_prod(min=0, max=2) "Transitioning filter order for products production from MSR while MSR is on";

	parameter Real cvf_methanol[:] "Volumetric flow rate coefficients for methanol production in MSR";
	parameter Real cwc_msr[:] "Compressor power coefficients in MSR";
	parameter Real cq_msr[:] "Heat flow coefficients in MSR";

	parameter Real cm_CO2_msr[:] "Mass flow rate coefficients for CO2 dumped/released from MSR";

	//Variables:
	//****************
	input SI.EnergyFlowRate E_sg(min=0) "Syngas energy flow rate to MSR";
	output SI.VolumeFlowRate v_flow_methanol(min=0) "Volumetric flow rate of methanol produced in MSR";

	SI.VolumeFlowRate v_flow_fuel_des(min=0) "Volumetric flow rate of methanol produced in MSR at design";

	SI.Power P_C(min=0) "Compressor power consumption";

	SI.MassFlowRate m_flow_CO2(min=0) "Mass flow rate of CO2 dumped/released from MSR";

	SI.EnergyFlowRate E_sg_in(min=0) "Syngas energy flow rate at MSR";
	SI.MassFlowRate m_flow_sg_in(min=0) "Mass flow rate of syngas at MSR";

	SI.EnergyFlowRate E_sg_trans_pre(min=0) "Syngas energy flow rate at the MSR right before transition event";
	SI.EnergyFlowRate E_sg_trans_after(min=0) "Syngas energy flow rate at the MSR right after transition event";
	SI.MassFlowRate m_flow_sg_trans_pre(min=0) "Syngas mass flow rate at the MSR right before transition event";
	SI.MassFlowRate m_flow_sg_trans_after(min=0) "Syngas mass flow rate at the MSR right after transition event";

	Boolean trans "true if the syngas supply flow changes";
	Boolean trend "ture if the change is incremental and false if the change is decremental";
	Boolean useful_prod(start=false) "true if energy/mass supply is converted to useful product i.e. fuel";

	SI.HeatFlowRate Q_flow_msr "Heat flow produced in MSR";

	SI.MassFlowRate m_flow_methanol(min=0) "Mass flow rate of methanol";

	SI.EnergyFlowRate E_flow_methanol(min=0) "Energy flow rate of methanol leaving MSR";

	Integer state(min=1, max=5) "MSR state";
	SI.Time t_msr_w_now "Time of MSR current warm-up event";
	SI.Time t_msr_w_next "Time of MSR next warm-up event";
	SI.Time t_msr_c_now "Time of MSR current cool-down event";
	SI.Time t_msr_c_next "Time of MSR next cool-down event";
	SI.Time t_msr_trans_now "Time of MSR current transition event";
	SI.Time t_msr_trans_next "Time of MSR next transition event";

	SI.EnergyFlowRate E_sg_in_waste(min=0) "Syngas energy flow rate wasted at MSR";
	SI.MassFlowRate m_flow_sg_in_waste(min=0) "Mass flow rate of syngas supply wasted at MSR";
	SI.Power P_C_waste(min=0) "Compressor power consumption wasted";

	SI.MassFlowRate m_flow_CO2_waste(min=0) "Mass flow rate of CO2 dumped/released from MSR when the products are rubbish";

	// Ramping-related variables: 
	SolarTherm.Utilities.Transition.Ramp ramp_up_sg(ramp_order=ramp_order_sg, t_dur= t_msr_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_sg(ramp_order=ramp_order_sg, t_dur= t_msr_off_delay, up=false);
	Real fr_ramp_sg(min=0, max=1) "Ramping transition rate for syngas supply to MSR";

	SolarTherm.Utilities.Transition.Ramp ramp_up_elec(ramp_order=ramp_order_elec, t_dur= t_msr_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_elec(ramp_order=ramp_order_elec, t_dur= t_msr_off_delay, up=false);
	Real fr_ramp_elec(min=0, max=1) "Ramping transition rate for electricity supply to MSR";

	SolarTherm.Utilities.Transition.Ramp ramp_up_CO2(ramp_order=ramp_order_CO2, t_dur= t_msr_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_CO2(ramp_order=ramp_order_CO2, t_dur= t_msr_off_delay, up=false);
	Real fr_ramp_CO2(min=0, max=1) "Ramping transition rate for CO2 dump/release from MSR";

	SolarTherm.Utilities.Transition.Ramp ramp_up_prod(ramp_order=ramp_order_prod, t_dur= t_msr_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_prod(ramp_order=ramp_order_prod, t_dur= t_msr_off_delay, up=false);
	Real fr_ramp_prod(min=0, max=1) "Ramping transition rate for products production from MSR";

	// Transitioning-related variables: 
	SolarTherm.Utilities.Transition.Ramp trans_up_sg(ramp_order=trans_order_sg, t_dur= t_msr_trans_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp trans_down_sg(ramp_order=trans_order_sg, t_dur= t_msr_trans_delay, up=false);
	Real fr_trans_sg(min=0, max=1) "Transitioning rate for syngas supply to MSR while MSR is on";

	SolarTherm.Utilities.Transition.Ramp trans_up_elec(ramp_order=trans_order_elec, t_dur= t_msr_trans_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp trans_down_elec(ramp_order=trans_order_elec, t_dur= t_msr_trans_delay, up=false);
	Real fr_trans_elec(min=0, max=1) "Transitioning rate for electricity supply to MSR while MSR is on";

	SolarTherm.Utilities.Transition.Ramp trans_up_CO2(ramp_order=trans_order_CO2, t_dur= t_msr_trans_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp trans_down_CO2(ramp_order=trans_order_CO2, t_dur= t_msr_trans_delay, up=false);
	Real fr_trans_CO2(min=0, max=1) "Transitioning rate for CO2 dump/release from MSR while MSR is on";

	SolarTherm.Utilities.Transition.Ramp trans_up_prod(ramp_order=trans_order_prod, t_dur= t_msr_trans_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp trans_down_prod(ramp_order=trans_order_prod, t_dur= t_msr_trans_delay, up=false);
	Real fr_trans_prod(min=0, max=1) "Transition rate for products production from MSR while MSR is on";

	// Timer variables:
	Modelica.Blocks.Logical.Timer timer "Timer measuring the times that the MSR is on";
	discrete SI.Time time_on(start=0, fixed=true) "Time marking when the MSR starts running";
	discrete SI.Time dt_on(start=0, fixed=true) "Time duration of everytime the MSR is on";
	discrete SI.Time tot "Total operating time of the MSR";
	Boolean on(start=false, fixed=true) "the MSR on/off signal";

protected
	constant SI.SpecificEnthalpy LHV_sg = 24.193742112158110e06 "Lower heating value of syngas";

	constant SI.Density rho_methanol = 784.805 "Petrol density at 32C & 1bar";

	constant SI.SpecificEnthalpy h_methanol = 7.5106379894e6 "Specific enthalpy of methanol at 32C & 1bar";

	parameter SI.MassFlowRate m_flow_sg_des(min=0) = E_sg_des / LHV_sg;
	parameter SI.MassFlowRate m_flow_sg_min(min=0) = E_sg_min / LHV_sg;

	SolarTherm.Utilities.Polynomial.Poly vf_methanol(c=cvf_methanol);

	SolarTherm.Utilities.Polynomial.Poly vf_methanol_des(c=cvf_methanol);

	SolarTherm.Utilities.Polynomial.Poly p_c(c=cwc_msr);

	SolarTherm.Utilities.Polynomial.Poly q_msr(c=cq_msr);

	SolarTherm.Utilities.Polynomial.Poly FR_CO2_dump(c=cm_CO2_msr);

initial equation
	pre(tot) = 0;
	state = 1;
	t_msr_w_now = 0;
	t_msr_w_next = 0;
	t_msr_c_now = 0;
	t_msr_c_next = 0;
	t_msr_trans_now = 0;
	t_msr_trans_next = 0;
	E_sg_trans_pre = E_sg;
	E_sg_trans_after = E_sg;
	m_flow_sg_trans_pre = E_sg / LHV_sg;
	m_flow_sg_trans_after = E_sg / LHV_sg;

algorithm
	when state == 1 and E_sg >= E_sg_min and t_msr_on_delay > 0 then
		state := 2; // MSR warming up
	elsewhen state == 1 and E_sg >= E_sg_min and t_msr_on_delay <= 0 then
		state := 3; // MSR operating (no warm-up)
	elsewhen state == 2 and time >= t_msr_w_next then
		state := 3; // MSR operating
	elsewhen state == 3 and trans and t_msr_trans_delay > 0 then
		state := 4; // MSR in transition
	elsewhen state == 4 and time >= t_msr_trans_next then
		state := 3; // MSR operating
	elsewhen state == 4 and E_sg < E_sg_min and t_msr_off_delay > 0 then
		state := 5; // MSR cooling down
	elsewhen state == 4 and E_sg < E_sg_min and t_msr_off_delay <= 0 then
		state := 1; // MSR off(no cool-down)
	elsewhen state == 5 and time >= t_msr_c_next then
		state := 1; // MSR off
	elsewhen state == 2 and E_sg < E_sg_min then
		state := 1; // MSR off
	elsewhen state == 3 and E_sg < E_sg_min and t_msr_off_delay > 0 then
		state := 5; // MSR cooling down
	elsewhen state == 3 and E_sg < E_sg_min and t_msr_off_delay <= 0 then
		state := 1; // MSR off(no cool-down)
	end when;

	when state == 2 then
		t_msr_w_now := time;
		t_msr_w_next := time + t_msr_on_delay;
	end when;

	when state == 4 then
		t_msr_trans_now := time;
		t_msr_trans_next := time + t_msr_trans_delay;
		E_sg_trans_pre := pre(E_sg);
		E_sg_trans_after := E_sg;
		m_flow_sg_trans_pre := pre(E_sg) / LHV_sg;
		m_flow_sg_trans_after := E_sg / LHV_sg;
	end when;

	when state == 5 then
		t_msr_c_now := time;
		t_msr_c_next := time + t_msr_off_delay;
	end when;

	if state == 2 then
		fr_ramp_sg := if ramp_order_sg == 0 then 1 else abs(ramp_up_sg.y);
		fr_ramp_elec := if ramp_order_elec == 0 then 1 else abs(ramp_up_elec.y);
		fr_ramp_CO2 := if ramp_order_CO2 == 0 then 1 else abs(ramp_up_CO2.y);
		fr_ramp_prod := if ramp_order_prod == 0 then 0 else abs(ramp_up_prod.y);
	elseif state == 5 then
		fr_ramp_sg := if ramp_order_sg == 0 then 0 else abs(ramp_down_sg.y);
		fr_ramp_elec := if ramp_order_elec == 0 then 0 else abs(ramp_down_elec.y);
		fr_ramp_CO2 := if ramp_order_CO2 == 0 then 0 else abs(ramp_down_CO2.y);
		fr_ramp_prod := if ramp_order_prod == 0 then 0 else abs(ramp_down_prod.y);
	elseif state == 4 then
		if trend then
			fr_trans_sg := if trans_order_sg == 0 then 1 else abs(trans_up_sg.y);
			fr_trans_elec := if trans_order_elec == 0 then 1 else abs(trans_up_elec.y);
			fr_trans_CO2 := if trans_order_CO2 == 0 then 1 else abs(trans_up_CO2.y);
			fr_trans_prod := if trans_order_prod == 0 then 0 else abs(trans_up_prod.y);
		else
			fr_trans_sg := if trans_order_sg == 0 then 1 else abs(trans_down_sg.y);
			fr_trans_elec := if trans_order_elec == 0 then 1 else abs(trans_down_elec.y);
			fr_trans_CO2 := if trans_order_CO2 == 0 then 1 else abs(trans_down_CO2.y);
			fr_trans_prod := if trans_order_prod == 0 then 0 else abs(trans_down_prod.y);
		end if;
	else
		fr_ramp_sg := 0;
		fr_ramp_elec := 0;
		fr_ramp_CO2 := 0;
		fr_ramp_prod := 0;

		fr_trans_sg := 0;
		fr_trans_elec := 0;
		fr_trans_CO2 := 0;
		fr_trans_prod := 0;
	end if;

	if state == 1 then
		useful_prod := false;
	elseif state == 2 then
		useful_prod := if ramp_order_prod == 0 then false else true;
	elseif state == 5 then
		useful_prod := if ramp_order_prod == 0 then false else true;
	elseif state == 4 then
		useful_prod := if trans_order_prod == 0 then false else true;
	else
		useful_prod := true;
	end if;

	on := if state == 3 or state == 4 then true else false;

	when on then
		time_on := time;
	end when;

equation
	(trans, trend) = SolarTherm.Utilities.ToleranceTest.compareReal(pre(E_sg), E_sg);

	ramp_up_sg.x = t_msr_w_now;
	ramp_down_sg.x = t_msr_c_now;

	ramp_up_elec.x = t_msr_w_now;
	ramp_down_elec.x = t_msr_c_now;

	ramp_up_CO2.x = t_msr_w_now;
	ramp_down_CO2.x = t_msr_c_now;

	ramp_up_prod.x = t_msr_w_now;
	ramp_down_prod.x = t_msr_c_now;

	trans_up_sg.x = t_msr_trans_now;
	trans_down_sg.x = t_msr_trans_now;

	trans_up_elec.x = t_msr_trans_now;
	trans_down_elec.x = t_msr_trans_now;

	trans_up_CO2.x = t_msr_trans_now;
	trans_down_CO2.x = t_msr_trans_now;

	trans_up_prod.x = t_msr_trans_now;
	trans_down_prod.x = t_msr_trans_now;

	v_flow_fuel_des = vf_methanol_des.y;
	vf_methanol_des.x = m_flow_sg_des;

	if state <= 1 then
		E_sg_in = 0;
		m_flow_sg_in = 0;

		vf_methanol.x = 0;
		v_flow_methanol = 0;

		p_c.x = 0;
		P_C = 0;

		q_msr.x = 0;
		Q_flow_msr = 0;

		FR_CO2_dump.x = 0;
		m_flow_CO2 = 0;

		m_flow_methanol = rho_methanol * v_flow_methanol;

		E_flow_methanol = m_flow_methanol * h_methanol;
	elseif state == 2 or state == 5 then
		E_sg_in = fr_ramp_sg * E_sg;
		m_flow_sg_in = E_sg_in / LHV_sg;

		vf_methanol.x = if ramp_order_prod == 0 then 0 else m_flow_sg_in/(fr_ramp_sg + 1e-10);
		v_flow_methanol = fr_ramp_prod * max(vf_methanol.y,0);

		p_c.x = m_flow_sg_in/(fr_ramp_sg + 1e-10);
		P_C = fr_ramp_elec * max(p_c.y*1e6,0);

		q_msr.x = if ramp_order_prod == 0 then 0 else m_flow_sg_in/(fr_ramp_sg + 1e-10);
		Q_flow_msr = fr_ramp_prod * max(q_msr.y*1e6,0);

		FR_CO2_dump.x = m_flow_sg_in/(fr_ramp_sg + 1e-10);
		m_flow_CO2 = fr_ramp_CO2 * max(FR_CO2_dump.y,0);

		m_flow_methanol = rho_methanol * v_flow_methanol;

		E_flow_methanol = m_flow_methanol * h_methanol;
	elseif state == 4 then
		if trend then
			E_sg_in = E_sg_trans_pre + fr_trans_sg * (E_sg_trans_after - E_sg_trans_pre);
			m_flow_sg_in = E_sg_in / LHV_sg;

			vf_methanol.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			v_flow_methanol = if trans_order_prod == 0 then 0 else max(vf_methanol.y,0);

			p_c.x = if trans_order_elec == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			P_C = max(p_c.y*1e6,0);

			q_msr.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			Q_flow_msr = if trans_order_prod == 0 then 0 else max(q_msr.y*1e6,0);

			FR_CO2_dump.x = if trans_order_CO2 == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			m_flow_CO2 = max(FR_CO2_dump.y,0);

			m_flow_methanol = rho_methanol * v_flow_methanol;

			E_flow_methanol = m_flow_methanol * h_methanol;
		else
			E_sg_in = if trans_order_sg == 0 then E_sg_trans_after else E_sg_trans_pre - (1 - fr_trans_sg) * (E_sg_trans_pre - E_sg_trans_after);
			m_flow_sg_in = E_sg_in / LHV_sg;

			vf_methanol.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			v_flow_methanol = if trans_order_prod == 0 then 0 else max(vf_methanol.y,0);

			p_c.x = if trans_order_elec == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			P_C = max(p_c.y*1e6,0);

			q_msr.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			Q_flow_msr = if trans_order_prod == 0 then 0 else max(q_msr.y*1e6,0);

			FR_CO2_dump.x = if trans_order_CO2 == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			m_flow_CO2 = max(FR_CO2_dump.y,0);

			m_flow_methanol = rho_methanol * v_flow_methanol;

			E_flow_methanol = m_flow_methanol * h_methanol;
		end if;
	else
		E_sg_in = E_sg;
		m_flow_sg_in = E_sg_in / LHV_sg;

		vf_methanol.x = m_flow_sg_in;
		v_flow_methanol = max(vf_methanol.y,0);

		p_c.x = m_flow_sg_in;
		P_C = max(p_c.y*1e6,0);

		q_msr.x = m_flow_sg_in;
		Q_flow_msr = max(q_msr.y*1e6,0);

		FR_CO2_dump.x = m_flow_sg_in;
		m_flow_CO2 = max(FR_CO2_dump.y,0);

		m_flow_methanol = rho_methanol * v_flow_methanol;

		E_flow_methanol = m_flow_methanol * h_methanol;
	end if;

	if useful_prod then
		E_sg_in_waste = 0;
		m_flow_sg_in_waste = 0;
		P_C_waste = 0;
		m_flow_CO2_waste = 0;
	else
		E_sg_in_waste = E_sg_in;
		m_flow_sg_in_waste = m_flow_sg_in;
		P_C_waste = P_C;
		m_flow_CO2_waste = m_flow_CO2;
	end if;

	timer.u = on;
	dt_on = timer.y;

	when dt_on <= 0 then
		tot = pre(tot) + pre(dt_on);
	end when;

	when terminal() then
		reinit(tot, pre(tot) + dt_on);
	end when;

end GenericMSR;
