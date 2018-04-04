within SolarTherm.Models.CSP.CRS.Reactors;
model GenericRX
	"A simple cavity reactor consisting of supercritical water gasification (SCWG) and steam methane reforming (SMR) processes"
	extends SolarTherm.Models.CSP.CRS.Receivers.Receiver;
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	type MoleFraction = Real (unit="1", min=0, max=1) "Type for mole fraction";

	//Parameters:
	//****************
	parameter Real fr_heat_SCWG = 0.6488 "Fraction of inlet heat flow to SCWG";

	parameter SI.RadiantPower R_min = 0.3 * 1000 * 50 * 1000 "Minimum sun heat duty to start the reactor"; // 0.3 * I_des * A * CR

	parameter SI.Time t_rx_on_delay = 30*60 "Delay until reactor starts";
	parameter SI.Time t_rx_off_delay = 30*60 "Delay until reactor shuts off";

	parameter Integer ramp_order_heat(min=0, max=2) "ramping filter order for heat supply to the reactor";
	parameter Integer ramp_order_algae(min=0, max=2) "ramping filter order for algae supply to the reactor";
	parameter Integer ramp_order_CO2(min=0, max=2) "ramping filter order for CO2 dump/release from the reactor";
	parameter Integer ramp_order_elec(min=0, max=2) "ramping filter order for electricity supply to the reactor";
	parameter Integer ramp_order_sg(min=0, max=2) "ramping filter order for syngas production from the reactor";

	parameter Real cf_SCWG[:] "SCWG heat loss efficiency coefficients";
	parameter Real cf_SMR[:] "SMR heat loss efficiency coefficients";
	parameter Real cf_rx[:] "Reactor energy efficiency coefficients";
	parameter Real cfII_rx[:] "Reactor exergy efficiency coefficients";

	parameter Real cm_algae[:] "Algae mass flow rate coefficients";

	parameter Real cn_H2_rx[:] "Molar flow rate coefficients for H2 produced in the reactor";
	parameter Real cn_CH4[:] "Molar flow rate coefficients for CH4 produced in the reactor";
	parameter Real cn_CO[:] "Molar flow rate coefficients for CO produced in the reactor";
	parameter Real cn_CO2[:] "Molar flow rate coefficients for CO2 produced in the reactor";

	parameter Real cwp_rx[:] "Pump power coefficients in the reactor";

	parameter Real cm_CO2_rx[:] "Mass flow rate coefficients for CO2 dumped/released from the reactor";

	parameter SI.Mass m_nickel_rx = 7546.89 "Mass of Nickel/Aluminum Oxide catalyst required in reactor at design for a three-year of operation";

	parameter Boolean pv = false "true if extra H2 is added from PV panels";

	//Variables:
	//****************
	Modelica.Blocks.Interfaces.BooleanInput rx_on(start=false) "true if the recator is to run";

	output SI.EnergyFlowRate E_flow "Energy flow rate of syngas leaving the reactor";

	SI.HeatFlowRate Q_flow_loss_SCWG "Heat loss at SCWG";
	SI.HeatFlowRate Q_flow_loss_SMR "Heat loss at SMR";

	SI.Efficiency eff_I_SCWG(min=0, max=1) "Reactor energy efficiency";
	SI.Efficiency eff_I_SMR(min=0, max=1) "SMR energy loss efficiency";
	SI.Efficiency eff_I_rx(min=0, max=1) "Reactor energy efficiency";
	SI.Efficiency eff_II_rx(min=0, max=1) "Reactor exergy efficiency";

	SI.MassFlowRate m_flow_algae(min=0) "Mass flow rate of algea";
	SI.MassFlowRate m_flow_water(min=0) "Mass flow rate of water";
	SI.MassFlowRate m_flow_sg(min=0) "Mass flow rate of syngas";
	SI.MassFlowRate m_flow_H2_pv(min=0) "Mass flow rate of H2 required from PV";
	SI.MassFlowRate m_flow_CO2(min=0) "Mass flow rate of CO2 dumped/released from the reactor";

	SI.Power P_pump(min=0) "Pump power consumption";

	Integer state(min=1, max=4) "Reactor state";
	SI.Time t_rx_w_now "Time of reactor current warm-up event";
	SI.Time t_rx_w_next "Time of reactor next warm-up event";
	SI.Time t_rx_c_now "Time of reactor current cool-down event";
	SI.Time t_rx_c_next "Time of reactor next cool-down event";

	SolarTherm.Utilities.Transition.Ramp ramp_up_heat(ramp_order=ramp_order_heat, t_dur= t_rx_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_heat(ramp_order=ramp_order_heat, t_dur= t_rx_off_delay, up=false);
	Real fr_ramp_heat(min=0, max=1) "Ramping transition rate for heat supply to the reactor";

	SolarTherm.Utilities.Transition.Ramp ramp_up_algae(ramp_order=ramp_order_algae, t_dur= t_rx_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_algae(ramp_order=ramp_order_algae, t_dur= t_rx_off_delay, up=false);
	Real fr_ramp_algae(min=0, max=1) "Ramping transition rate for algae supply to the reactor";

	SolarTherm.Utilities.Transition.Ramp ramp_up_CO2(ramp_order=ramp_order_CO2, t_dur= t_rx_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_CO2(ramp_order=ramp_order_CO2, t_dur= t_rx_off_delay, up=false);
	Real fr_ramp_CO2(min=0, max=1) "Ramping transition rate for CO2 dump/release from the reactor";

	SolarTherm.Utilities.Transition.Ramp ramp_up_elec(ramp_order=ramp_order_elec, t_dur= t_rx_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_elec(ramp_order=ramp_order_elec, t_dur= t_rx_off_delay, up=false);
	Real fr_ramp_elec(min=0, max=1) "Ramping transition rate for electricity supply to the reactor";

	SolarTherm.Utilities.Transition.Ramp ramp_up_sg(ramp_order=ramp_order_sg, t_dur= t_rx_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_sg(ramp_order=ramp_order_sg, t_dur= t_rx_off_delay, up=false);
	Real fr_ramp_sg(min=0, max=1) "Ramping transition rate for syngas production from the reactor";

	Modelica.Blocks.Logical.Timer timer "Timer measuring the times that the reactor is on";
	discrete SI.Time time_on(start=0, fixed=true) "Time marking when the reactor starts running";
	discrete SI.Time dt_on(start=0, fixed=true) "Time duration of everytime the reactor is on";
	discrete SI.Time tot "Total operating time of the reactor";
	Boolean on(start=false, fixed=true) "the reactor on/off signal";

	Boolean useful_prod(start=false) "true if energy/mass supply is converted to useful product i.e. syngas";

	SI.MassFlowRate m_flow_algae_waste(min=0) "Mass flow rate of algea supply wasted";
	SI.MassFlowRate m_flow_water_waste(min=0) "Mass flow rate of water supply wasted";
	SI.MassFlowRate m_flow_H2_pv_waste(min=0) "Mass flow rate of H2 supply wasted";
	SI.MassFlowRate m_flow_CO2_waste(min=0) "Mass flow rate of CO2 dumped/released from the reactor when the products are rubbish";
	SI.Power P_pump_waste(min=0) "Pump power consumption waste";

protected
	constant Real molarRatio_H2_CO = 2.1 "Molar ratio of H2 to CO at the outlet of SMR";
	constant Real massRatio_w_a = 3.0 "Mass ratio of water to algae";

	constant SI.MolarMass MM_H2 = 0.0020 "Molar mass of H2";
	constant SI.MolarMass MM_CH4 = 0.0160 "Molar mass of CH4";
	constant SI.MolarMass MM_CO = 0.0280 "Molar mass of CO";
	constant SI.MolarMass MM_CO2 = 0.0440 "Molar mass of CO2";

	constant SI.SpecificEnthalpy LHV_H2 = 120.21e6 "Lower heating value of H2";
	constant SI.SpecificEnthalpy LHV_CH4 = 50e6 "Lower heating value of CH4";
	constant SI.SpecificEnthalpy LHV_CO = 10.11e6 "Lower heating value of CO";
	constant SI.SpecificEnthalpy LHV_CO2 = 0.0 "Lower heating value of CO2";
	
	constant SI.MolarEnthalpy mLHV_H2 = MM_H2 * LHV_H2 "Molar lower heating value of H2";
	constant SI.MolarEnthalpy mLHV_CH4 = MM_CH4 * LHV_CH4 "Molar lower heating value of CH4";
	constant SI.MolarEnthalpy mLHV_CO = MM_CO * LHV_CO "Molar lower heating value of CO";
	constant SI.MolarEnthalpy mLHV_CO2 = MM_CO2 * LHV_CO2 "Molar lower heating value of CO";

	parameter Real R_mean = 37.5 "Mean value of R used in the polynomials centre and scale method";
	parameter Real R_std = 15.14 "Standard deviation of R used in the polynomials centre and scale method";

	SI.HeatFlowRate Q_flow_SCWG "Inlet heat flow to SCWG";
	SI.HeatFlowRate Q_flow_SMR "Inlet heat flow to SMR";

	SI.MolarFlowRate n_flow_H2_rx "Molar flow rate of H2 produced in the reactor";
	SI.MolarFlowRate n_flow_CH4 "Molar flow rate of CH4 produced in the reactor";
	SI.MolarFlowRate n_flow_CO "Molar flow rate of CO produced in the reactor";
	SI.MolarFlowRate n_flow_CO2 "Molar flow rate of CO2 produced in the reactor";
	SI.MolarFlowRate n_flow_H2_pv "Molar flow rate of H2 required from PV";
	SI.MolarFlowRate n_flow_H2 "Total molar flow rate of H2";
	SI.MolarFlowRate n_flow_sg "Molar flow rate of syngas";

	MoleFraction y_H2 "Molar fraction of H2 in syngas flow";
	MoleFraction y_CH4 "Molar fraction of CH4 in syngas flow";
	MoleFraction y_CO "Molar fraction of CO in syngas flow";
	MoleFraction y_CO2 "Molar fraction of CO2 in syngas flow";

	SI.MolarMass MM_sg "Molar mass of syngas";

	SI.MolarEnthalpy mLHV_sg "Molar lower heating value of syngas";
	SI.SpecificEnthalpy LHV_sg "Lower heating value of syngas";

	SolarTherm.Utilities.Polynomial.Poly eff_SCWG(c=cf_SCWG);
	SolarTherm.Utilities.Polynomial.Poly eff_SMR(c=cf_SMR);
	SolarTherm.Utilities.Polynomial.Poly eff_rx(c=cf_rx);
	SolarTherm.Utilities.Polynomial.Poly exff_rx(c=cfII_rx);

	SolarTherm.Utilities.Polynomial.Poly FR_algae(c=cm_algae);

	SolarTherm.Utilities.Polynomial.Poly FR_H2_rx(c=cn_H2_rx);
	SolarTherm.Utilities.Polynomial.Poly FR_CH4(c=cn_CH4);
	SolarTherm.Utilities.Polynomial.Poly FR_CO(c=cn_CO);
	SolarTherm.Utilities.Polynomial.Poly FR_CO2(c=cn_CO2);

	SolarTherm.Utilities.Polynomial.Poly p_p(c=cwp_rx);

	SolarTherm.Utilities.Polynomial.Poly FR_CO2_dump(c=cm_CO2_rx);


initial equation
	pre(tot) = 0;
	state = 1;
	t_rx_w_now = 0;
	t_rx_w_next = 0;
	t_rx_c_now = 0;
	t_rx_c_next = 0;

algorithm
	when state == 1 and sum(R) >= R_min and rx_on and t_rx_on_delay > 0 then
		state := 2; // Reactor warming up
	elsewhen state == 1 and sum(R) >= R_min and rx_on and t_rx_on_delay <= 0 then
		state := 3; // Reactor working (no warm-up)
	elsewhen state == 2 and time >= t_rx_w_next then
		state := 3; // Reactor working
	elsewhen state == 4 and time >= t_rx_c_next then
		state := 1; // Reactor off
	elsewhen state == 2 and (sum(R) < R_min or not rx_on) then
		state := 1; // Reactor off
	elsewhen state == 3 and (sum(R) < R_min or not rx_on) and t_rx_off_delay > 0 then
		state := 4; // Reactor cooling down
	elsewhen state == 3 and (sum(R) < R_min or not rx_on) and t_rx_off_delay <= 0 then
		state := 1; // Reactor off (no cooling down)
	end when;

	when state == 2 then
		t_rx_w_now := time;
		t_rx_w_next := time + t_rx_on_delay;
	end when;

	when state == 4 then
		t_rx_c_now := time;
		t_rx_c_next := time + t_rx_off_delay;
	end when;

	if state == 2 then
		fr_ramp_heat := if ramp_order_heat == 0 then 1 else abs(ramp_up_heat.y);
		fr_ramp_algae := if ramp_order_algae == 0 then 1 else abs(ramp_up_algae.y);
		fr_ramp_CO2 := if ramp_order_CO2 == 0 then 1 else abs(ramp_up_CO2.y);
		fr_ramp_elec := if ramp_order_elec == 0 then 1 else abs(ramp_up_elec.y);
		fr_ramp_sg := if ramp_order_sg == 0 then 0 else abs(ramp_up_sg.y);
	elseif state == 4 then
		fr_ramp_heat := if ramp_order_heat == 0 then 0 else abs(ramp_down_heat.y);
		fr_ramp_algae := if ramp_order_algae == 0 then 0 else abs(ramp_down_algae.y);
		fr_ramp_CO2:= if ramp_order_CO2 == 0 then 0 else abs(ramp_down_CO2.y);
		fr_ramp_elec:= if ramp_order_elec == 0 then 0 else abs(ramp_down_elec.y);
		fr_ramp_sg:= if ramp_order_sg == 0 then 0 else abs(ramp_down_sg.y);
	else
		fr_ramp_heat := 0;
		fr_ramp_algae := 0;
		fr_ramp_CO2 := 0;
		fr_ramp_elec := 0;
		fr_ramp_sg := 0;
	end if;

	if state == 1 then
		useful_prod := false;
	elseif state == 2 or state == 4 then
		useful_prod := if ramp_order_sg == 0 then false else true;
	else
		useful_prod := true;
	end if;

	on := if state == 3 then true else false;

	when on then
		time_on := time;
	end when;

equation
	ramp_up_heat.x = t_rx_w_now;
	ramp_down_heat.x = t_rx_c_now;

	ramp_up_algae.x = t_rx_w_now;
	ramp_down_algae.x = t_rx_c_now;

	ramp_up_CO2.x = t_rx_w_now;
	ramp_down_CO2.x = t_rx_c_now;

	ramp_up_elec.x = t_rx_w_now;
	ramp_down_elec.x = t_rx_c_now;

	ramp_up_sg.x = t_rx_w_now;
	ramp_down_sg.x = t_rx_c_now;

	if state <= 1 then
		Q_flow_loss_SCWG = 0;
		eff_I_SCWG = 0;
		Q_flow_SCWG = 0;
		eff_SCWG.x = 0;

		Q_flow_loss_SMR = 0;
		eff_I_SMR = 0;
		Q_flow_SMR = 0;
		eff_SMR.x = 0;

		eff_rx.x = 0;
		eff_I_rx = 0;

		exff_rx.x = 0;
		eff_II_rx = 0;

		FR_algae.x = 0;
		m_flow_algae = 0;
		m_flow_water = m_flow_algae * massRatio_w_a;

		FR_H2_rx.x = 0;
		n_flow_H2_rx = 0;

		FR_CH4.x = 0;
		n_flow_CH4 = 0;

		FR_CO.x = 0;
		n_flow_CO = 0;

		FR_CO2.x = 0;
		n_flow_CO2 = 0;

		n_flow_H2_pv = 0;
		n_flow_H2 = 0;

		FR_CO2_dump.x = 0;
		m_flow_CO2 = 0;

		n_flow_sg = 0;

		y_H2 = 0.674099570184096;
		y_CH4 = 0.002461218329356;
		y_CO = 0.319084098180880;
		y_CO2 = 0.004355113305667;

		MM_sg = 0.010513556314215649;

		m_flow_sg = 0;
		m_flow_H2_pv = n_flow_H2_pv * MM_H2;

		mLHV_sg = 2.543623134148470e05;
		LHV_sg = 24.193742112158110e06;
		E_flow = 0;

		p_p.x = 0;
		P_pump = 0;
	elseif state == 2 or state == 4 then
		eff_SCWG.x = if ramp_order_heat == 0 then 0 else (sum(R)/1e6 - R_mean) / R_std;
		eff_I_SCWG = if ramp_order_heat == 0 then 0 else max(eff_SCWG.y,0);

		Q_flow_SCWG = fr_ramp_heat * fr_heat_SCWG * sum(R);
		Q_flow_loss_SCWG = (1 - eff_I_SCWG) * Q_flow_SCWG;

		eff_SMR.x = if ramp_order_heat == 0 then 0 else (sum(R)/1e6 - R_mean) / R_std;
		eff_I_SMR = if ramp_order_heat == 0 then 0 else max(eff_SMR.y,0);

		Q_flow_SMR = fr_ramp_heat * (1 - fr_heat_SCWG) * sum(R);
		Q_flow_loss_SMR = (1 - eff_I_SMR) * Q_flow_SMR;

		eff_rx.x = if ramp_order_heat == 0 then 0 else (sum(R)/1e6 - R_mean) / R_std;
		eff_I_rx = if ramp_order_heat == 0 then 0 else max(eff_rx.y,0);

		exff_rx.x = if ramp_order_heat == 0 then 0 else (sum(R)/1e6 - R_mean) / R_std;
		eff_II_rx = if ramp_order_heat == 0 then 0 else max(exff_rx.y,0);

		FR_algae.x = sum(R)/1e6;
		m_flow_algae = fr_ramp_algae * max(FR_algae.y,0);

		m_flow_water = m_flow_algae * massRatio_w_a;

		FR_H2_rx.x = if ramp_order_sg == 0 then 0 else sum(R)/1e6;
		n_flow_H2_rx = fr_ramp_sg * max(FR_H2_rx.y,0) * 1000;

		FR_CH4.x = if ramp_order_sg == 0 then 0 else sum(R)/1e6;
		n_flow_CH4 = fr_ramp_sg * max(FR_CH4.y,0) * 1000;

		FR_CO.x = if ramp_order_sg == 0 then 0 else sum(R)/1e6;
		n_flow_CO = fr_ramp_sg * max(FR_CO.y,0) * 1000;

		FR_CO2.x = if ramp_order_sg == 0 then 0 else sum(R)/1e6;
		n_flow_CO2 = fr_ramp_sg * max(FR_CO2.y,0) * 1000;

		if pv then
			n_flow_H2_pv = molarRatio_H2_CO * n_flow_CO - n_flow_H2_rx;
		else
			n_flow_H2_pv = 0;
		end if;
		n_flow_H2 = n_flow_H2_rx + n_flow_H2_pv;

		FR_CO2_dump.x = sum(R)/1e6;
		m_flow_CO2 = fr_ramp_CO2 * max(FR_CO2_dump.y,0);

		n_flow_sg = n_flow_H2 + n_flow_CH4 + n_flow_CO+n_flow_CO2;

		y_H2 = 0.674099570184096;
		y_CH4 = 0.002461218329356;
		y_CO = 0.319084098180880;
		y_CO2 = 0.004355113305667;

		MM_sg = 0.010513556314215649;

		m_flow_sg = n_flow_sg * MM_sg;
		m_flow_H2_pv = n_flow_H2_pv * MM_H2;

		mLHV_sg = 2.543623134148470e05;
		LHV_sg = 24.193742112158110e06;

		E_flow = n_flow_sg * mLHV_sg;

		p_p.x = (sum(R)/1e6 - R_mean) / R_std;
		P_pump = fr_ramp_elec * max(p_p.y*1e3,0);
	else
		eff_SCWG.x = (sum(R)/1e6 - R_mean) / R_std;
		eff_I_SCWG = max(eff_SCWG.y,0);
		Q_flow_loss_SCWG = (1 - eff_I_SCWG) * Q_flow_SCWG;
		Q_flow_SCWG = fr_heat_SCWG * sum(R);

		eff_SMR.x = (sum(R)/1e6 - R_mean) / R_std;
		eff_I_SMR = max(eff_SMR.y,0);
		Q_flow_loss_SMR = (1 - eff_I_SMR) * Q_flow_SMR;
		Q_flow_SMR = (1 - fr_heat_SCWG) * sum(R);

		eff_rx.x = (sum(R)/1e6 - R_mean) / R_std;
		eff_I_rx = max(eff_rx.y,0);

		exff_rx.x = (sum(R)/1e6 - R_mean) / R_std;
		eff_II_rx = max(exff_rx.y,0);

		FR_algae.x = sum(R)/1e6;
		m_flow_algae = max(FR_algae.y,0);
		m_flow_water = m_flow_algae * massRatio_w_a;

		FR_H2_rx.x = sum(R)/1e6;
		n_flow_H2_rx = max(FR_H2_rx.y,0) * 1000;

		FR_CH4.x = sum(R)/1e6;
		n_flow_CH4 = max(FR_CH4.y,0) * 1000;

		FR_CO.x = sum(R)/1e6;
		n_flow_CO = max(FR_CO.y,0) * 1000;

		FR_CO2.x = sum(R)/1e6;
		n_flow_CO2 = max(FR_CO2.y,0) * 1000;

		if pv then
			n_flow_H2_pv = molarRatio_H2_CO * n_flow_CO - n_flow_H2_rx;
		else
			n_flow_H2_pv = 0;
		end if;
		n_flow_H2 = n_flow_H2_rx + n_flow_H2_pv;

		FR_CO2_dump.x = sum(R)/1e6;
		m_flow_CO2 = max(FR_CO2_dump.y,0);

		n_flow_sg = n_flow_H2 + n_flow_CH4 + n_flow_CO+n_flow_CO2;

		y_H2 = n_flow_H2 / (n_flow_sg + 1e-10);
		y_CH4 = n_flow_CH4 / (n_flow_sg + 1e-10);
		y_CO = n_flow_CO / (n_flow_sg + 1e-10);
		y_CO2 = n_flow_CO2 / (n_flow_sg + 1e-10);

		MM_sg = y_H2 * MM_H2 + y_CH4 * MM_CH4 + y_CO * MM_CO + y_CO2 * MM_CO2;

		m_flow_sg = n_flow_sg * MM_sg;
		m_flow_H2_pv = n_flow_H2_pv * MM_H2;

		mLHV_sg = y_H2 * mLHV_H2 + y_CH4 * mLHV_CH4 + y_CO * mLHV_CO + y_CO2 * mLHV_CO2;
		LHV_sg = mLHV_sg / MM_sg;

		E_flow = n_flow_sg * mLHV_sg;

		p_p.x = (sum(R)/1e6 - R_mean) / R_std;
		P_pump = max(p_p.y*1e3,0);
	end if;

	if useful_prod then
		m_flow_algae_waste = 0;
		m_flow_water_waste = 0;
		m_flow_H2_pv_waste = 0;
		m_flow_CO2_waste = 0;
		P_pump_waste = 0;
	else
		m_flow_algae_waste = m_flow_algae;
		m_flow_water_waste = m_flow_water;
		m_flow_H2_pv_waste = m_flow_H2_pv;
		m_flow_CO2_waste = m_flow_CO2;
		P_pump_waste = P_pump;
	end if;

	timer.u = on;
	dt_on = timer.y;

	when dt_on <= 0 then
		tot = pre(tot) + pre(dt_on);
	end when;

	when terminal() then
		reinit(tot, pre(tot) + dt_on);
	end when;

end GenericRX;
