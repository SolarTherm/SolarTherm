within SolarTherm.Models.CSP.CRS.Reactors;
model GenericFT
	"A simple Fischer–Tropsch process"
	// FT efficiency has been assumed to be fixed at 90%, which should change later as a function of inlet syngas
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	//Parameters:
	//****************
	parameter SI.EnergyFlowRate E_sg_des "Energy flow to fischer tropsch reactor at design";
	parameter SI.EnergyFlowRate E_sg_min "Minimum syngas energy flow rate to start FT"; // the lower band used in regression to get the polynomial equation
	parameter Real fuel_conv_ratio "Conversion ratio of diesel to petrol";

	parameter SI.Time t_ft_on_delay = 60*60 "Delay until FT starts";
	parameter SI.Time t_ft_off_delay = 90*60 "Delay until FT shuts off";

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

	parameter SI.Time t_trans = 1*60 "Transition time (= 0.0 gives a Step)";

	//Variables:
	//****************
	input SI.EnergyFlowRate E_sg "Syngas energy flow rate to FT";
	output SI.VolumeFlowRate v_flow_petrol "Volumetric flow rate of petrol produced in FT";
	output SI.VolumeFlowRate v_flow_diesel "Volumetric flow rate of diesel produced in FT";


	SI.VolumeFlowRate v_flow_petrol_des "Volumetric flow rate of petrol produced in FT at design";
	SI.VolumeFlowRate v_flow_diesel_des "Volumetric flow rate of diesel produced in FT at design";
	SI.VolumeFlowRate v_flow_fuel_des "Volumetric flow rate of fuel produced in FT at design";

	SI.Power P_C "Compressor power consumption";
	SI.Power P_T "Turbine power production";
	SI.Power P_pumps "Pumps power consumption";

	SI.MassFlowRate m_flow_H2_pv "Mass flow rate of H2 required from PV";
	SI.MassFlowRate m_flow_O2 "Mass flow rate of O2 produced in FT";
	SI.MassFlowRate m_flow_water "Mass flow rate of water required in FT";
	SI.MassFlowRate m_flow_CO2 "Mass flow rate of CO2 dumped/released from FT";

	SI.MassFlowRate m_flow_sg "Mass flow rate of syngas";
	Modelica.Blocks.Continuous.CriticalDamping cd(n=2, f=1/t_trans, normalized = true, initType=Modelica.Blocks.Types.Init.SteadyState) "defines a transfer function between the input and the output as an n-th order filter with critical damping characteristics and cut-off frequency f";

	SI.HeatFlowRate Q_flow_ft "Heat flow produced in FT";

	SI.MassFlowRate m_flow_petrol "Mass flow rate of petrol";
	SI.MassFlowRate m_flow_diesel "Mass flow reate of diesel";

	SI.EnergyFlowRate E_flow_petrol "Energy flow rate of petrol leaving FT";
	SI.EnergyFlowRate E_flow_diesel "Energy flow rate of diesel leaving FT";

	Integer ft_state(min=1, max=4) "FT state";
	SI.Time t_ft_w_next "Time of next FT event to warm up";
	SI.Time t_ft_c_next "Time of next FT event to cool down";

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

	parameter SI.MassFlowRate m_flow_sg_des = E_sg_des / LHV_sg;
	parameter SI.MassFlowRate m_flow_sg_min = E_sg_min / LHV_sg;

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
	ft_state = 1;
	t_ft_w_next = 0;
	t_ft_c_next = 0;

algorithm
	when ft_state == 1 and E_sg >= E_sg_min then
		ft_state := 2; // FT warming up
	elsewhen ft_state == 2 and time >= t_ft_w_next then
		ft_state := 3; // FT working
	elsewhen ft_state == 4 and time >= t_ft_c_next then
		ft_state := 1; // FT cooling down
	elsewhen ft_state == 2 and E_sg < E_sg_min then
		ft_state := 1; // FT off
	elsewhen ft_state == 3 and E_sg < E_sg_min then
		ft_state := 4; // FT off
	end when;

	when ft_state == 2 then
		t_ft_w_next := time + t_ft_on_delay;
	end when;

	when ft_state == 4 then
		t_ft_c_next := time + t_ft_off_delay;
	end when;

	on := if ft_state == 3 then true else false;

	when on then
		time_on := time;
	end when;

equation
	v_flow_petrol_des = vf_petrol_des.y;
	vf_petrol_des.x = m_flow_sg_des;

	v_flow_diesel_des = vf_diesel_des.y;
	vf_diesel_des.x = m_flow_sg_des;

v_flow_fuel_des = v_flow_petrol_des + (fuel_conv_ratio * v_flow_diesel_des);

	if ft_state <= 2 or ft_state > 3 then
		cd.u = E_sg / LHV_sg;
		m_flow_sg = cd.y;

		v_flow_petrol = 0;
		vf_petrol.x = 0;

		v_flow_diesel = 0;
		vf_diesel.x = 0;

		P_C = if ft_state == 2 then p_c.y * 1e6 else 0;
		p_c.x = if ft_state == 2 then m_flow_sg else 0;

		P_pumps = if ft_state == 2 then p_p.y * 1e3 else 0;
		p_p.x = if ft_state == 2 then m_flow_sg else 0;

		P_T = 0;
		p_t.x = 0;

		Q_flow_ft = 0;
		q_ft.x = 0;

		m_flow_H2_pv = 0;
		FR_H2_pv.x = 0;

		m_flow_O2 = 0;
		FR_O2.x = 0;

		m_flow_water = 0;
		FR_water.x = 0;

		m_flow_CO2 = 0;
		FR_CO2_dump.x = 0;

		m_flow_petrol = rho_petrol * v_flow_petrol;
		m_flow_diesel = rho_diesel * v_flow_diesel;

		E_flow_petrol = m_flow_petrol * h_petrol;
		E_flow_diesel = m_flow_diesel * h_diesel;
	else
		cd.u = E_sg / LHV_sg;
		m_flow_sg = cd.y;

		v_flow_petrol = vf_petrol.y;
		vf_petrol.x = m_flow_sg;

		v_flow_diesel = vf_diesel.y;
		vf_diesel.x = m_flow_sg;

		P_C = p_c.y * 1e6;
		p_c.x = m_flow_sg;

		P_pumps = p_p.y * 1e3;
		p_p.x = m_flow_sg;

		P_T = p_t.y * 1e6;
		p_t.x = m_flow_sg;

		Q_flow_ft = q_ft.y * 1e6;
		q_ft.x = m_flow_sg;

		m_flow_H2_pv = FR_H2_pv.y;
		FR_H2_pv.x = m_flow_sg;

		m_flow_O2 = FR_O2.y;
		FR_O2.x = m_flow_sg;

		m_flow_water = FR_water.y;
		FR_water.x = m_flow_sg;

		m_flow_CO2 = FR_CO2_dump.y;
		FR_CO2_dump.x = m_flow_sg;

		m_flow_petrol = rho_petrol * v_flow_petrol;
		m_flow_diesel = rho_diesel * v_flow_diesel;

		E_flow_petrol = m_flow_petrol * h_petrol;
		E_flow_diesel = m_flow_diesel * h_diesel;
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
