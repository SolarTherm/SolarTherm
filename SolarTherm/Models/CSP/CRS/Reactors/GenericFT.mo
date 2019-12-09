within SolarTherm.Models.CSP.CRS.Reactors;
model GenericFT
	"A simple Fischer–Tropsch process"
	// FT efficiency has been assumed to be fixed at 90%, which should change later as a function of inlet syngas
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import FI = SolarTherm.Models.Analysis.Finances;

	//Parameters:
	//****************
	parameter SI.EnergyFlowRate E_sg_des "Energy flow to fischer tropsch reactor at design";
	parameter SI.EnergyFlowRate E_sg_min "Minimum syngas energy flow rate to start FT"; // the lower band used in regression to get the polynomial equation
	parameter Real fuel_conv_ratio "Conversion ratio of diesel to petrol";

	parameter SI.Time t_ft_on_delay = 120*60 "Delay until FT starts";
	parameter SI.Time t_ft_off_delay = 120*60 "Delay until FT shuts off";
	parameter SI.Time t_ft_trans_delay = 120*60 "Transition time when the syngas supply flow changes";

	parameter Integer ramp_order_sg(min=0, max=2) "Ramping filter order for syngas supply to FT";
	parameter Integer ramp_order_elec(min=0, max=2) "Ramping filter order for electricity supply to FT";
	parameter Integer ramp_order_H2_pv(min=0, max=2) "Ramping filter order for PV H2 supply to FT";
	parameter Integer ramp_order_water(min=0, max=2) "Ramping filter order for water supply to FT";
	parameter Integer ramp_order_CO2(min=0, max=2) "Ramping filter order for CO2 dump/release from FT";
	parameter Integer ramp_order_prod(min=0, max=2) "Ramping filter order for products production from FT";

	parameter Integer trans_order_sg(min=0, max=2) "Transitioning filter order for syngas supply to FT while FT is on";
	parameter Integer trans_order_elec(min=0, max=2) "Transitioning filter order for electricity supply to FT while FT is on";
	parameter Integer trans_order_H2_pv(min=0, max=2) "Transitioning filter order for PV H2 supply to FT while FT is on";
	parameter Integer trans_order_water(min=0, max=2) "Transitioning filter order for water supply to FT while FT is on";
	parameter Integer trans_order_CO2(min=0, max=2) "Transitioning filter order for CO2 dump/release from FT while FT is on";
	parameter Integer trans_order_prod(min=0, max=2) "Transitioning filter order for products production from FT while FT is on";

	parameter Real cvf_petrol[:] "Volumetric flow rate coefficients for petrol production in FT";
	parameter Real cvf_diesel[:] "Volumetric flow rate coefficients for diesel production in FT";
	parameter Real cwc_ft[:] "Compressor power coefficients in FT";
	parameter Real cwt_ft[:] "Turbine power coefficients in FT";
	parameter Real cwp_ft[:] "Pumps power coefficients in FT";
	parameter Real cq_ft[:] "Heat flow coefficients in FT";

	parameter Real cm_H2_pv[:] "Mass flow rate coefficients for H2 required from PV in FT";
	parameter Real cm_O2[:] "Mass flow rate coefficients for O2 produced in FT";
	parameter Real cm_water[:] "Mass flow rate coefficients for water required in FT";
	parameter Real cm_CO2_ft[:] "Mass flow rate coefficients for CO2 dumped/released from FT";

	parameter SI.Mass m_nickel_ft = FI.massNickel_ft_m_sg(m_flow_sg_des) "Mass of Nickel/Aluminum Oxide catalyst required in FT at design for a three-year of operation";
	parameter SI.Mass m_cobalt_ft = FI.massCobalt_ft_m_sg(m_flow_sg_des) "Mass of Cobalt catalyst required in FT at design for a three-year of operation";
	parameter SI.Mass m_platinum_ft = FI.massPlatinum_ft_m_sg(m_flow_sg_des) "Mass of Platinum catalyst required in FT at design for a three-year of operation";

	//Variables:
	//****************
	input SI.EnergyFlowRate E_sg(min=0) "Syngas energy flow rate to FT";
	output SI.VolumeFlowRate v_flow_petrol(min=0) "Volumetric flow rate of petrol produced in FT";
	output SI.VolumeFlowRate v_flow_diesel(min=0) "Volumetric flow rate of diesel produced in FT";

	SI.VolumeFlowRate v_flow_petrol_des(min=0) "Volumetric flow rate of petrol produced in FT at design";
	SI.VolumeFlowRate v_flow_diesel_des(min=0) "Volumetric flow rate of diesel produced in FT at design";
	SI.VolumeFlowRate v_flow_fuel_des(min=0) "Volumetric flow rate of fuel produced in FT at design";

	SI.Power P_C(min=0) "Compressor power consumption";
	SI.Power P_T(min=0) "Turbine power production";
	SI.Power P_pumps(min=0) "Pumps power consumption";

	SI.MassFlowRate m_flow_H2_pv(min=0) "Mass flow rate of H2 required from PV";
	SI.MassFlowRate m_flow_O2(min=0) "Mass flow rate of O2 produced in FT";
	SI.MassFlowRate m_flow_water(min=0) "Mass flow rate of water required in FT";
	SI.MassFlowRate m_flow_CO2(min=0) "Mass flow rate of CO2 dumped/released from FT";

	SI.EnergyFlowRate E_sg_in(min=0) "Syngas energy flow rate at FT";
	SI.MassFlowRate m_flow_sg_in(min=0) "Mass flow rate of syngas at FT";

	//Modelica.Blocks.Continuous.CriticalDamping cd(n=1, f=1/t_ft_trans_delay, normalized = true, initType=Modelica.Blocks.Types.Init.SteadyState) "Delays transition for the time given with and n-th order behaviour";

	SI.EnergyFlowRate E_sg_trans_pre(min=0) "Syngas energy flow rate at the FT right before transition event";
	SI.EnergyFlowRate E_sg_trans_after(min=0) "Syngas energy flow rate at the FT right after transition event";
	SI.MassFlowRate m_flow_sg_trans_pre(min=0) "Syngas mass flow rate at the FT right before transition event";
	SI.MassFlowRate m_flow_sg_trans_after(min=0) "Syngas mass flow rate at the FT right after transition event";

	Boolean trans "true if the syngas supply flow changes";
	Boolean trend "ture if the change is incremental and false if the change is decremental";
	Boolean useful_prod(start=false) "true if energy/mass supply is converted to useful product i.e. fuel";

	SI.HeatFlowRate Q_flow_ft "Heat flow produced in FT";

	SI.MassFlowRate m_flow_petrol(min=0) "Mass flow rate of petrol";
	SI.MassFlowRate m_flow_diesel(min=0) "Mass flow rate of diesel";

	SI.EnergyFlowRate E_flow_petrol(min=0) "Energy flow rate of petrol leaving FT";
	SI.EnergyFlowRate E_flow_diesel(min=0) "Energy flow rate of diesel leaving FT";

	Integer state(min=1, max=5) "FT state";
	SI.Time t_ft_w_now "Time of FT current warm-up event";
	SI.Time t_ft_w_next "Time of FT next warm-up event";
	SI.Time t_ft_c_now "Time of FT current cool-down event";
	SI.Time t_ft_c_next "Time of FT next cool-down event";
	SI.Time t_ft_trans_now "Time of FT current transition event";
	SI.Time t_ft_trans_next "Time of FT next transition event";

	SI.EnergyFlowRate E_sg_in_waste(min=0) "Syngas energy flow rate wasted at FT";
	SI.MassFlowRate m_flow_sg_in_waste(min=0) "Mass flow rate of syngas supply wasted at FT";
	SI.Power P_C_waste(min=0) "Compressor power consumption wasted";
	SI.Power P_pumps_waste(min=0) "Pumps power consumption wasted";
	SI.MassFlowRate m_flow_H2_pv_waste(min=0) "Mass flow rate of H2 supply wasted";

	SI.MassFlowRate m_flow_water_waste(min=0) "Mass flow rate of water supply wasted at FT";
	SI.MassFlowRate m_flow_CO2_waste(min=0) "Mass flow rate of CO2 dumped/released from FT when the products are rubbish";

	// Ramping-related variables: 
	SolarTherm.Utilities.Transition.Ramp ramp_up_sg(ramp_order=ramp_order_sg, t_dur= t_ft_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_sg(ramp_order=ramp_order_sg, t_dur= t_ft_off_delay, up=false);
	Real fr_ramp_sg(min=0, max=1) "Ramping transition rate for syngas supply to FT";

	SolarTherm.Utilities.Transition.Ramp ramp_up_elec(ramp_order=ramp_order_elec, t_dur= t_ft_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_elec(ramp_order=ramp_order_elec, t_dur= t_ft_off_delay, up=false);
	Real fr_ramp_elec(min=0, max=1) "Ramping transition rate for electricity supply to FT";

	SolarTherm.Utilities.Transition.Ramp ramp_up_H2_pv(ramp_order=ramp_order_H2_pv, t_dur= t_ft_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_H2_pv(ramp_order=ramp_order_H2_pv, t_dur= t_ft_off_delay, up=false);
	Real fr_ramp_H2_pv(min=0, max=1) "Ramping transition rate for PV H2 supply to FT";

	SolarTherm.Utilities.Transition.Ramp ramp_up_water(ramp_order=ramp_order_water, t_dur= t_ft_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_water(ramp_order=ramp_order_water, t_dur= t_ft_off_delay, up=false);
	Real fr_ramp_water(min=0, max=1) "Ramping transition rate for water supply to FT";

	SolarTherm.Utilities.Transition.Ramp ramp_up_CO2(ramp_order=ramp_order_CO2, t_dur= t_ft_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_CO2(ramp_order=ramp_order_CO2, t_dur= t_ft_off_delay, up=false);
	Real fr_ramp_CO2(min=0, max=1) "Ramping transition rate for CO2 dump/release from FT";

	SolarTherm.Utilities.Transition.Ramp ramp_up_prod(ramp_order=ramp_order_prod, t_dur= t_ft_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_prod(ramp_order=ramp_order_prod, t_dur= t_ft_off_delay, up=false);
	Real fr_ramp_prod(min=0, max=1) "Ramping transition rate for products production from FT";

	// Transitioning-related variables: 
	SolarTherm.Utilities.Transition.Ramp trans_up_sg(ramp_order=trans_order_sg, t_dur= t_ft_trans_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp trans_down_sg(ramp_order=trans_order_sg, t_dur= t_ft_trans_delay, up=false);
	Real fr_trans_sg(min=0, max=1) "Transitioning rate for syngas supply to FT while FT is on";

	SolarTherm.Utilities.Transition.Ramp trans_up_elec(ramp_order=trans_order_elec, t_dur= t_ft_trans_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp trans_down_elec(ramp_order=trans_order_elec, t_dur= t_ft_trans_delay, up=false);
	Real fr_trans_elec(min=0, max=1) "Transitioning rate for electricity supply to FT while FT is on";

	SolarTherm.Utilities.Transition.Ramp trans_up_H2_pv(ramp_order=trans_order_H2_pv, t_dur= t_ft_trans_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp trans_down_H2_pv(ramp_order=trans_order_H2_pv, t_dur= t_ft_trans_delay, up=false);
	Real fr_trans_H2_pv(min=0, max=1) "Transitioning rate for PV H2 supply to FT while FT is on";

	SolarTherm.Utilities.Transition.Ramp trans_up_water(ramp_order=trans_order_water, t_dur= t_ft_trans_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp trans_down_water(ramp_order=trans_order_water, t_dur= t_ft_trans_delay, up=false);
	Real fr_trans_water(min=0, max=1) "Transition rate for water supply to FT while FT is on";

	SolarTherm.Utilities.Transition.Ramp trans_up_CO2(ramp_order=trans_order_CO2, t_dur= t_ft_trans_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp trans_down_CO2(ramp_order=trans_order_CO2, t_dur= t_ft_trans_delay, up=false);
	Real fr_trans_CO2(min=0, max=1) "Transitioning rate for CO2 dump/release from FT while FT is on";

	SolarTherm.Utilities.Transition.Ramp trans_up_prod(ramp_order=trans_order_prod, t_dur= t_ft_trans_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp trans_down_prod(ramp_order=trans_order_prod, t_dur= t_ft_trans_delay, up=false);
	Real fr_trans_prod(min=0, max=1) "Transition rate for products production from FT while FT is on";

	// Timer variables:
	Modelica.Blocks.Logical.Timer timer "Timer measuring the times that the FT is on";
	discrete SI.Time time_on(start=0, fixed=true) "Time marking when the FT starts running";
	discrete SI.Time dt_on(start=0, fixed=true) "Time duration of everytime the FT is on";
	discrete SI.Time tot "Total operating time of the FT";
	Boolean on(start=false, fixed=true) "the FT on/off signal";

protected
	constant SI.SpecificEnthalpy LHV_sg = 24.193742112158110e06 "Lower heating value of syngas";

	constant SI.Density rho_petrol = 681.5868 "Petrol density at 35C & 3bar";
	constant SI.Density rho_diesel = 751.9214 "Petrol density at 35C & 3bar";

	constant SI.SpecificEnthalpy h_petrol = 2.165930736319661e6 "Specific enthalpy of petrol at 35C & 3bar";
	constant SI.SpecificEnthalpy h_diesel = 1.974827449313822e6 "Specific enthalpy of diesel at 35C & 3bar";

	parameter SI.MassFlowRate m_flow_sg_des(min=0) = E_sg_des / LHV_sg;
	parameter SI.MassFlowRate m_flow_sg_min(min=0) = E_sg_min / LHV_sg;

	SolarTherm.Utilities.Polynomial.Poly vf_petrol(c=cvf_petrol);
	SolarTherm.Utilities.Polynomial.Poly vf_diesel(c=cvf_diesel);

	SolarTherm.Utilities.Polynomial.Poly vf_petrol_des(c=cvf_petrol);
	SolarTherm.Utilities.Polynomial.Poly vf_diesel_des(c=cvf_diesel);

	SolarTherm.Utilities.Polynomial.Poly p_c(c=cwc_ft);
	SolarTherm.Utilities.Polynomial.Poly p_t(c=cwt_ft);
	SolarTherm.Utilities.Polynomial.Poly p_p(c=cwp_ft);

	SolarTherm.Utilities.Polynomial.Poly q_ft(c=cq_ft);

	SolarTherm.Utilities.Polynomial.Poly FR_H2_pv(c=cm_H2_pv);
	SolarTherm.Utilities.Polynomial.Poly FR_O2(c=cm_O2);
	SolarTherm.Utilities.Polynomial.Poly FR_water(c=cm_water);
	SolarTherm.Utilities.Polynomial.Poly FR_CO2_dump(c=cm_CO2_ft);

initial equation
	pre(tot) = 0;
	state = 1;
	t_ft_w_now = 0;
	t_ft_w_next = 0;
	t_ft_c_now = 0;
	t_ft_c_next = 0;
	t_ft_trans_now = 0;
	t_ft_trans_next = 0;
	E_sg_trans_pre = E_sg;
	E_sg_trans_after = E_sg;
	m_flow_sg_trans_pre = E_sg / LHV_sg;
	m_flow_sg_trans_after = E_sg / LHV_sg;

algorithm
	when state == 1 and E_sg >= E_sg_min and t_ft_on_delay > 0 then
		state := 2; // FT warming up
	elsewhen state == 1 and E_sg >= E_sg_min and t_ft_on_delay <= 0 then
		state := 3; // FT operating (no warm-up)
	elsewhen state == 2 and time >= t_ft_w_next then
		state := 3; // FT operating
	elsewhen state == 3 and trans and t_ft_trans_delay > 0 then
		state := 4; // FT in transition
	elsewhen state == 4 and time >= t_ft_trans_next then
		state := 3; // FT operating
	elsewhen state == 4 and E_sg < E_sg_min and t_ft_off_delay > 0 then
		state := 5; // FT cooling down
	elsewhen state == 4 and E_sg < E_sg_min and t_ft_off_delay <= 0 then
		state := 1; // FT off(no cool-down)
	elsewhen state == 5 and time >= t_ft_c_next then
		state := 1; // FT off
	elsewhen state == 2 and E_sg < E_sg_min then
		state := 1; // FT off
	elsewhen state == 3 and E_sg < E_sg_min and t_ft_off_delay > 0 then
		state := 5; // FT cooling down
	elsewhen state == 3 and E_sg < E_sg_min and t_ft_off_delay <= 0 then
		state := 1; // FT off(no cool-down)
	end when;

	when state == 2 then
		t_ft_w_now := time;
		t_ft_w_next := time + t_ft_on_delay;
	end when;

	when state == 4 then
		t_ft_trans_now := time;
		t_ft_trans_next := time + t_ft_trans_delay;
		E_sg_trans_pre := pre(E_sg);
		E_sg_trans_after := E_sg;
		m_flow_sg_trans_pre := pre(E_sg) / LHV_sg;
		m_flow_sg_trans_after := E_sg / LHV_sg;
	end when;

	when state == 5 then
		t_ft_c_now := time;
		t_ft_c_next := time + t_ft_off_delay;
	end when;

	if state == 2 then
		fr_ramp_sg := if ramp_order_sg == 0 then 1 else abs(ramp_up_sg.y);
		fr_ramp_elec := if ramp_order_elec == 0 then 1 else abs(ramp_up_elec.y);
		fr_ramp_H2_pv := if ramp_order_H2_pv == 0 then 1 else abs(ramp_up_H2_pv.y);
		fr_ramp_water := if ramp_order_water == 0 then 1 else abs(ramp_up_water.y);
		fr_ramp_CO2 := if ramp_order_CO2 == 0 then 1 else abs(ramp_up_CO2.y);
		fr_ramp_prod := if ramp_order_prod == 0 then 0 else abs(ramp_up_prod.y);
	elseif state == 5 then
		fr_ramp_sg := if ramp_order_sg == 0 then 0 else abs(ramp_down_sg.y);
		fr_ramp_elec := if ramp_order_elec == 0 then 0 else abs(ramp_down_elec.y);
		fr_ramp_H2_pv := if ramp_order_H2_pv == 0 then 0 else abs(ramp_down_H2_pv.y);
		fr_ramp_water := if ramp_order_water == 0 then 0 else abs(ramp_down_water.y);
		fr_ramp_CO2 := if ramp_order_CO2 == 0 then 0 else abs(ramp_down_CO2.y);
		fr_ramp_prod := if ramp_order_prod == 0 then 0 else abs(ramp_down_prod.y);
	elseif state == 4 then
		if trend then
			fr_trans_sg := if trans_order_sg == 0 then 1 else abs(trans_up_sg.y);
			fr_trans_elec := if trans_order_elec == 0 then 1 else abs(trans_up_elec.y);
			fr_trans_H2_pv := if trans_order_H2_pv == 0 then 1 else abs(trans_up_H2_pv.y);
			fr_trans_water := if trans_order_water == 0 then 1 else abs(trans_up_water.y);
			fr_trans_CO2 := if trans_order_CO2 == 0 then 1 else abs(trans_up_CO2.y);
			fr_trans_prod := if trans_order_prod == 0 then 0 else abs(trans_up_prod.y);
		else
			fr_trans_sg := if trans_order_sg == 0 then 1 else abs(trans_down_sg.y);
			fr_trans_elec := if trans_order_elec == 0 then 1 else abs(trans_down_elec.y);
			fr_trans_H2_pv := if trans_order_H2_pv == 0 then 1 else abs(trans_down_H2_pv.y);
			fr_trans_water := if trans_order_water == 0 then 1 else abs(trans_down_water.y);
			fr_trans_CO2 := if trans_order_CO2 == 0 then 1 else abs(trans_down_CO2.y);
			fr_trans_prod := if trans_order_prod == 0 then 0 else abs(trans_down_prod.y);
		end if;
	else
		fr_ramp_sg := 0;
		fr_ramp_elec := 0;
		fr_ramp_H2_pv := 0;
		fr_ramp_water := 0;
		fr_ramp_CO2 := 0;
		fr_ramp_prod := 0;

		fr_trans_sg := 0;
		fr_trans_elec := 0;
		fr_trans_H2_pv := 0;
		fr_trans_water := 0;
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

	ramp_up_sg.x = t_ft_w_now;
	ramp_down_sg.x = t_ft_c_now;

	ramp_up_elec.x = t_ft_w_now;
	ramp_down_elec.x = t_ft_c_now;

	ramp_up_H2_pv.x = t_ft_w_now;
	ramp_down_H2_pv.x = t_ft_c_now;

	ramp_up_water.x = t_ft_w_now;
	ramp_down_water.x = t_ft_c_now;

	ramp_up_CO2.x = t_ft_w_now;
	ramp_down_CO2.x = t_ft_c_now;

	ramp_up_prod.x = t_ft_w_now;
	ramp_down_prod.x = t_ft_c_now;

	trans_up_sg.x = t_ft_trans_now;
	trans_down_sg.x = t_ft_trans_now;

	trans_up_elec.x = t_ft_trans_now;
	trans_down_elec.x = t_ft_trans_now;

	trans_up_H2_pv.x = t_ft_trans_now;
	trans_down_H2_pv.x = t_ft_trans_now;

	trans_up_water.x = t_ft_trans_now;
	trans_down_water.x = t_ft_trans_now;

	trans_up_CO2.x = t_ft_trans_now;
	trans_down_CO2.x = t_ft_trans_now;

	trans_up_prod.x = t_ft_trans_now;
	trans_down_prod.x = t_ft_trans_now;

	v_flow_petrol_des = vf_petrol_des.y;
	vf_petrol_des.x = m_flow_sg_des;

	v_flow_diesel_des = vf_diesel_des.y;
	vf_diesel_des.x = m_flow_sg_des;

	v_flow_fuel_des = v_flow_petrol_des + (fuel_conv_ratio * v_flow_diesel_des);

	if state <= 1 then
		//cd.u = 0;
		E_sg_in = 0;
		m_flow_sg_in = 0;

		vf_petrol.x = 0;
		v_flow_petrol = 0;

		vf_diesel.x = 0;
		v_flow_diesel = 0;

		p_c.x = 0;
		P_C = 0;

		p_p.x = 0;
		P_pumps = 0;

		p_t.x = 0;
		P_T = 0;

		q_ft.x = 0;
		Q_flow_ft = 0;

		FR_H2_pv.x = 0;
		m_flow_H2_pv = 0;

		FR_O2.x = 0;
		m_flow_O2 = 0;

		FR_water.x = 0;
		m_flow_water = 0;

		FR_CO2_dump.x = 0;
		m_flow_CO2 = 0;

		m_flow_petrol = rho_petrol * v_flow_petrol;
		m_flow_diesel = rho_diesel * v_flow_diesel;

		E_flow_petrol = m_flow_petrol * h_petrol;
		E_flow_diesel = m_flow_diesel * h_diesel;
	elseif state == 2 or state == 5 then
		//cd.u = E_sg / LHV_sg;
		//m_flow_sg_in = fr_ramp_sg * max(cd.y,0);
		E_sg_in = fr_ramp_sg * E_sg;
		m_flow_sg_in = E_sg_in / LHV_sg;

		vf_petrol.x = if ramp_order_prod == 0 then 0 else m_flow_sg_in/(fr_ramp_sg + 1e-10);
		v_flow_petrol = fr_ramp_prod * max(vf_petrol.y,0);

		vf_diesel.x = if ramp_order_prod == 0 then 0 else m_flow_sg_in/(fr_ramp_sg + 1e-10);
		v_flow_diesel = fr_ramp_prod * max(vf_diesel.y,0);

		p_c.x = m_flow_sg_in/(fr_ramp_sg + 1e-10);
		P_C = fr_ramp_elec * max(p_c.y*1e6,0);

		p_p.x = m_flow_sg_in/(fr_ramp_sg + 1e-10);
		P_pumps = fr_ramp_elec * max(p_p.y*1e3,0);

		p_t.x = if ramp_order_prod == 0 then 0 else m_flow_sg_in/(fr_ramp_sg + 1e-10);
		P_T = fr_ramp_prod * max(p_t.y*1e6,0);

		q_ft.x = if ramp_order_prod == 0 then 0 else m_flow_sg_in/(fr_ramp_sg + 1e-10);
		Q_flow_ft = fr_ramp_prod * max(q_ft.y*1e6,0);

		FR_H2_pv.x = m_flow_sg_in/(fr_ramp_sg + 1e-10);
		m_flow_H2_pv = fr_ramp_H2_pv * max(FR_H2_pv.y,0);

		FR_O2.x = if ramp_order_prod == 0 then 0 else m_flow_sg_in/(fr_ramp_sg + 1e-10);
		m_flow_O2 = fr_ramp_prod * max(FR_O2.y,0);

		FR_water.x = m_flow_sg_in/(fr_ramp_sg + 1e-10);
		m_flow_water = fr_ramp_water * max(FR_water.y,0);

		FR_CO2_dump.x = m_flow_sg_in/(fr_ramp_sg + 1e-10);
		m_flow_CO2 = fr_ramp_CO2 * max(FR_CO2_dump.y,0);

		m_flow_petrol = rho_petrol * v_flow_petrol;
		m_flow_diesel = rho_diesel * v_flow_diesel;

		E_flow_petrol = m_flow_petrol * h_petrol;
		E_flow_diesel = m_flow_diesel * h_diesel;
	elseif state == 4 then
		if trend then
			E_sg_in = E_sg_trans_pre + fr_trans_sg * (E_sg_trans_after - E_sg_trans_pre);
			m_flow_sg_in = E_sg_in / LHV_sg;

			vf_petrol.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			v_flow_petrol = if trans_order_prod == 0 then 0 else max(vf_petrol.y,0);

			vf_diesel.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			v_flow_diesel = if trans_order_prod == 0 then 0 else max(vf_diesel.y,0);

			p_c.x = if trans_order_elec == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			P_C = max(p_c.y*1e6,0);

			p_p.x = if trans_order_elec == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			P_pumps = max(p_p.y*1e3,0);

			p_t.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			P_T = if trans_order_prod == 0 then 0 else max(p_t.y*1e6,0);

			q_ft.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			Q_flow_ft = if trans_order_prod == 0 then 0 else max(q_ft.y*1e6,0);

			FR_H2_pv.x = if trans_order_H2_pv == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			m_flow_H2_pv = max(FR_H2_pv.y,0);

			FR_O2.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			m_flow_O2 = if trans_order_prod == 0 then 0 else max(FR_O2.y,0);

			FR_water.x = if trans_order_water == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			m_flow_water = max(FR_water.y,0);

			FR_CO2_dump.x = if trans_order_CO2 == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			m_flow_CO2 = max(FR_CO2_dump.y,0);

			m_flow_petrol = rho_petrol * v_flow_petrol;
			m_flow_diesel = rho_diesel * v_flow_diesel;

			E_flow_petrol = m_flow_petrol * h_petrol;
			E_flow_diesel = m_flow_diesel * h_diesel;
		else
			E_sg_in = if trans_order_sg == 0 then E_sg_trans_after else E_sg_trans_pre - (1 - fr_trans_sg) * (E_sg_trans_pre - E_sg_trans_after);
			m_flow_sg_in = E_sg_in / LHV_sg;

			vf_petrol.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			v_flow_petrol = if trans_order_prod == 0 then 0 else max(vf_petrol.y,0);

			vf_diesel.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			v_flow_diesel = if trans_order_prod == 0 then 0 else max(vf_diesel.y,0);

			p_c.x = if trans_order_elec == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			P_C = max(p_c.y*1e6,0);

			p_p.x = if trans_order_elec == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			P_pumps = max(p_p.y*1e3,0);

			p_t.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			P_T = if trans_order_prod == 0 then 0 else max(p_t.y*1e6,0);

			q_ft.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			Q_flow_ft = if trans_order_prod == 0 then 0 else max(q_ft.y*1e6,0);

			FR_H2_pv.x = if trans_order_H2_pv == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			m_flow_H2_pv = max(FR_H2_pv.y,0);

			FR_O2.x = if trans_order_prod == 0 then 0 else m_flow_sg_in;
			m_flow_O2 = if trans_order_prod == 0 then 0 else max(FR_O2.y,0);

			FR_water.x = if trans_order_water == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			m_flow_water = max(FR_water.y,0);

			FR_CO2_dump.x = if trans_order_CO2 == 0 then m_flow_sg_trans_after else m_flow_sg_in;
			m_flow_CO2 = max(FR_CO2_dump.y,0);

			m_flow_petrol = rho_petrol * v_flow_petrol;
			m_flow_diesel = rho_diesel * v_flow_diesel;

			E_flow_petrol = m_flow_petrol * h_petrol;
			E_flow_diesel = m_flow_diesel * h_diesel;
		end if;
	else
		//cd.u = E_sg / LHV_sg;
		//m_flow_sg_in = max(cd.y,0);
		E_sg_in = E_sg;
		m_flow_sg_in = E_sg_in / LHV_sg;

		vf_petrol.x = m_flow_sg_in;
		v_flow_petrol = max(vf_petrol.y,0);

		vf_diesel.x = m_flow_sg_in;
		v_flow_diesel = max(vf_diesel.y,0);

		p_c.x = m_flow_sg_in;
		P_C = max(p_c.y*1e6,0);

		p_p.x = m_flow_sg_in;
		P_pumps = max(p_p.y*1e3,0);

		p_t.x = m_flow_sg_in;
		P_T = max(p_t.y*1e6,0);

		q_ft.x = m_flow_sg_in;
		Q_flow_ft = max(q_ft.y*1e6,0);

		FR_H2_pv.x = m_flow_sg_in;
		m_flow_H2_pv = max(FR_H2_pv.y,0);

		FR_O2.x = m_flow_sg_in;
		m_flow_O2 = max(FR_O2.y,0);

		FR_water.x = m_flow_sg_in;
		m_flow_water = max(FR_water.y,0);

		FR_CO2_dump.x = m_flow_sg_in;
		m_flow_CO2 = max(FR_CO2_dump.y,0);

		m_flow_petrol = rho_petrol * v_flow_petrol;
		m_flow_diesel = rho_diesel * v_flow_diesel;

		E_flow_petrol = m_flow_petrol * h_petrol;
		E_flow_diesel = m_flow_diesel * h_diesel;
	end if;

	if useful_prod then
		E_sg_in_waste = 0;
		m_flow_sg_in_waste = 0;
		P_C_waste = 0;
		P_pumps_waste = 0;
		m_flow_H2_pv_waste = 0;
		m_flow_water_waste = 0;
		m_flow_CO2_waste = 0;
	else
		E_sg_in_waste = E_sg_in;
		m_flow_sg_in_waste = m_flow_sg_in;
		P_C_waste = P_C;
		P_pumps_waste = P_pumps;
		m_flow_H2_pv_waste = m_flow_H2_pv;
		m_flow_water_waste = m_flow_water;
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

end GenericFT;
