within SolarTherm.Models.CSP.CRS.Receivers;

model ParticleReceiver1d_StandAlone

"Falling particle flow and energy model"
	/* FIXME this model uses fixed c_p in the finite different equations, but
	   nonlinear h(T) for the inlet/outlet, leading to inconsistencies. But it
	   solves! */

	/* FIXME model is lacking connectors etc so is not yet ready for integration
	   into larger models. */

	import SI = Modelica.SIunits;
	import CONST = Modelica.Constants;
	import Modelica.SIunits.Conversions.*;
	import SolarTherm.Media;

	// Medium
	replaceable package Medium = Media.SolidParticles.CarboHSP_ph;

	// Model configuratoin
	constant Boolean fixed_geometry = false "If true, specified H_drop, t_c and calculate T_out, mdot. If false, vice versa";
    constant Boolean with_wall_conduction = false "Whether to model vertical conduction in backwall"; // FIXME may need to revisit this
	constant Boolean fixed_cp = false "If false, use the Medium model. If true, use simplified cp=const approx";
	constant Boolean with_isothermal_backwall = false "If true, fix the backwall temperature to uniform value (controlled cooling)";
	constant Boolean with_uniform_curtain_props = false "If true, ignore effect of phi_c on curtain emi/abs/tau";
	constant SI.SpecificHeatCapacity cp_s = 1200. "solid specific heat capacity [J/kg-K]";

	//Discretisation
	parameter Integer N = 20 "Number of vertical elements";

	// temperature used to initialise screen
	parameter SI.Temperature T_ref = from_degC(580.3);
	parameter SI.SpecificEnthalpy h_0 = (
			if fixed_cp then 0
			else Medium.specificEnthalpy(Medium.setState_pTX(p_des,T_ref))
		);

	// Solid particle geometry
	parameter SI.Length d_p = 280e-6 "particle diameter [m]" annotation(Dialog(group="Technical data"));
	parameter SI.Area a = 0.25 * CONST.pi * d_p^2 "cross sectional particle area [m2]";

	// Medium properties
	parameter SI.Efficiency eps_s = 0.86 "Particle emissivity";
	parameter SI.Efficiency abs_s = 0.92 "Particle absorptivity";
	parameter SI.Density rho_s = 3300. "Particle density [kg/m3]";
	parameter Real phi_s_max = 0.6 "Maximum achievable particle volume fraction";

	// Environment
	parameter SI.Temperature T_amb = from_degC(25) "Ambient temperature [K]";
	parameter SI.CoefficientOfHeatTransfer h_conv = 100. "Convective heat transfer coefficient (back of backwall) [W/m^2-K]";

	//Wall properties
	parameter SI.Efficiency eps_w = 0.8 "Receiver wall emissivity";
	parameter SI.ThermalConductivity k_w = 0.2 "Backwall thermal conductivity [W/m-K]";
	parameter SI.Length t_w = 0.05 "Backwall thickness [m]";

	// Design conditions (should be used during initialisation)
	parameter SI.Temperature T_in_des = from_degC(580.3) "Inlet temperature [K]";
	parameter SI.Temperature T_out_des = from_degC(800.) "Outlet temperature [K]";
	parameter SI.Pressure p_des = from_bar(1) "Design pressure, Pa";
	parameter SI.Velocity v_s_in = 0.25 "Inlet curtain velocity [m/s]";
	parameter Real AR = 1 "Receiver aspect ratio";
	parameter SI.Angle theta_c = from_deg(0.) "representative angle of rays incident on the particle screen (0=normal)";

	// Receiver geometry
	SI.Length t_c_in (start=1887.76/(0.6*1200*0.25*24.37)) "Curtain thicknesss at the inlet";
	SI.Length H_drop "Receiver drop height [m]";
	SI.Area A_ap "Receiver aperture area [m2]";
	SI.Length w_c "Aperture (curtain) width [m], w_curtain";
	SI.Length dx "Vertical step size [m]";

	SI.Temperature T_out(start=T_out_des) "Outlet temperature [K]";
	SI.Temperature T_in(start=T_in_des) "Inlet temperature [K]";
	SI.MassFlowRate mdot(start=1600,nominal=1000) "Inlet mass flow rate [kg/s]";

	// Distributed variables for the particle curtain
	Real phi_s__[N+1] (start=fill(0.5,N+1),min=zeros(N+1),max=fill(1,N+1)) "Curtain packing factor (volume fraction)";
	SI.Length x__[N+2] (min=zeros(N+2),max=fill(100.,N+2)) "Vertical positions of nodes";
	SI.Velocity v_s__[N+1] (start=fill(1.5*v_s_in,N+1),min=fill(v_s_in,N+1),max=fill(1000,N+1)) "Particles velocity [m/s]";
	SI.Length t_c__[N+2] "Receiver depth";
	SI.Temperature T_s__[N+1] (start = fill(T_in_des,N+1), max=fill(3000.,N+1)) "Curtain Temperature";
	SI.SpecificEnthalpy h_s__[N+1] (start = fill(h_0,N+1), max=fill(cp_s*(2000-T_ref),N+1)) "Curtain enthalpy";
	SI.Temperature T_w__[N+2] (start = fill(T_amb+1.,N+2), max=fill(3000.,N+2)) "Receiver wall temperature";
	// NOTE variables with a '__' appended to the name needed a [0] index in EES. Hence they are index with [i+1] in this code.

	//Curtain radiation properties
	SI.Efficiency eps_c[N] (start=fill(0.5,N),max=fill(1.,N),min=fill(0.,N)) "Curtain emissivity";
	SI.Efficiency tau_c[N] (start=fill(0.5,N),max=fill(1.,N),min=fill(0.,N)) "Curtain tramittance";
	SI.Efficiency abs_c[N] (start=fill(0.5,N),max=fill(1.,N),min=fill(0.,N)) "Curtain absorptance";

	//Radiation heat fluxes
	SI.HeatFlux q_solar "Uniform solar flux [W/m2]";
	SI.HeatFlux gc_f[N] (min=zeros(N)) "Curtain radiation gain at the front";
	SI.HeatFlux jc_f[N] (min=zeros(N)) "Curtain radiation loss at the front";
	SI.HeatFlux gc_b[N] (min=zeros(N)) "Curtain radiation gain at the back";
	SI.HeatFlux jc_b[N] (min=zeros(N)) "Curtain radiation loss at the back";
	SI.HeatFlux g_w[N] (min=zeros(N)) "Wall radiation gain from the front";
	SI.HeatFlux j_w[N] (min=zeros(N)) "Wall radiosity (outwards to the front)";
	SI.HeatFlux q_conv[N] "Heat flux lost through backwall by conduction/convection";
	SI.HeatFlux q_net_c[N] "Net heat flux gained by curtain";

	//Overall performance
	SI.HeatFlowRate Qdot_rec "Total heat rate absorbed by the receiver";
	SI.HeatFlowRate Qdot_inc "Total heat rate incident upon the receiver (before losses)";
	Real eta_rec(min=0, max=1) "Receiver efficiency";

	SI.MassFlowRate mdot_check "Mass balance check";
	SI.HeatFlowRate Qdot_check "Heat balance check";
equation
	dx * N = H_drop;
	AR * H_drop = w_c;
	A_ap = H_drop * w_c;

	q_solar = 1200 * 788.8; //q_solar=DNI*CR

	if fixed_geometry then
		// Off-design mode: T_in, H_drop, t_c are fixed, calculate T_out,mdot.
		// FIXME still need to implement curtain width control (t_c)
		T_in = T_in_des;
		H_drop = 24.37;
		t_c_in = 1887.76/(0.6*1200*0.25*24.37);
		// note that mass flow rate is calculated from v_s_in, t_c, w_c.
	else
		// Design mode: mdot,T_in,T_out are fixed, calculate H_drop,t_c.
		mdot = 1827.;
		T_in = T_in_des;
		T_s__[N+1] = T_out_des;
	end if;

	// Boundary conditions
	phi_s__[1] = phi_s_max;
	v_s__[1] = v_s_in;
	T_s__[1] = T_in;
	T_s__[N+1] = T_out;
	T_w__[1] = T_w__[2];
	T_w__[N+2]=T_w__[N+1];

	// Node locations
	x__[1] = 0;
	for i in 2:N+1 loop
		x__[i] = dx*(1./2 + (i-2));
	end for;
	x__[N+2] = H_drop;

	for i in 1:N+2 loop
		// Curtain thickness
		t_c__[i] = t_c_in + 0.0087*x__[i]; // Oles and Jackson (Sol. En. 2015), Eq 18.
	end for;

	for i in 1:N+1 loop
		// Particle enthalpy
		h_s__[i] = if fixed_cp then cp_s*(T_s__[i]-T_ref)
			else Medium.specificEnthalpy(Medium.setState_pTX(p_des,T_s__[i]));

		// Mass balance
		mdot = phi_s__[i]*rho_s*v_s__[i]*t_c__[i]*w_c;
	end for;

	for i in 2:N+1 loop
		// Curtain momentum balance (gravity causing decreased curtain opacity)
		mdot*(v_s__[i] - v_s__[i-1]) = dx*w_c*phi_s__[i]*t_c__[i]*rho_s* CONST.g_n;
	end for;

	for i in 1:N loop
		if with_uniform_curtain_props then
			eps_c[i] = eps_s;
			abs_c[i] = abs_s;
			tau_c[i] = 0.4; //exp(-3*phi_s__[i+1]*t_c__[i+1]/(2*d_p));
		else
			// Curtain radiation properties
			// Can't find a clear reference for these equations...
			eps_c[i]*(1-tau_c[i]) = function_1(eps_s * 6*phi_s__[i+1]/(CONST.pi*d_p^3) * t_c__[i+1] * a);
			abs_c[i]*(1-tau_c[i]) = function_1(abs_s * 6*phi_s__[i+1]/(CONST.pi*d_p^3) * t_c__[i+1] * a);
			//tau_c[i] = exp(-3*phi_s__[i+1]*t_c__[i+1]/(2*d_p)); // Oles & Jackson (Sol. En., 2015), Eq 31.
			tau_c[i] = exp(-3*phi_s__[i+1]*t_c__[i+1]/(2*d_p)/cos(theta_c)); // Oles & Jackson (Sol. En., 2015), Eq 31.
			// FIXME note that tau_c should have an adjustment for cos(theta) of rays.
		end if;

		// Curtain energy balance
		q_net_c[i] =  gc_f[i] - jc_f[i] + gc_b[i] - jc_b[i] - h_conv*(T_s__[i+1]-T_amb);

		//q_net_c[i]*dx = phi_s__[i+1]*t_c__[i+1]*rho_s*v_s__[i+1]*h_s__[i+1] - phi_s__[i]*t_c__[i]*rho_s*v_s__[i]*h_s__[i];
		q_net_c[i]*dx*w_c = mdot*(h_s__[i+1] - h_s__[i]);

		// Curtain-wall radiation heat fluxes (W/m²)
		gc_f[i] = q_solar;
		jc_f[i] = (1-tau_c[i])*(eps_c[i] * CONST.sigma * T_s__[i+1]^4 + (1-abs_c[i])*q_solar) + tau_c[i]*gc_b[i];
		gc_b[i] = j_w[i];
		jc_b[i] = (1-tau_c[i])*(eps_c[i] * CONST.sigma * T_s__[i+1]^4 + (1-eps_c[i])*gc_b[i]) + tau_c[i]*q_solar;
		g_w[i] = jc_b[i];
		j_w[i] = eps_w * CONST.sigma * T_w__[i+1]^4 + (1-eps_w)*g_w[i];

		// Back wall energy balance
		if with_isothermal_backwall then
			// wall is at ambient temperature, absorbed heat lost as convection+radiation
			T_w__[i+1] = T_amb;
			q_conv[i] + j_w[i] = g_w[i];
		else
			q_conv[i] = (T_w__[i+1] - T_amb) / (1/h_conv + t_w/k_w);
			0 = (
					if with_wall_conduction
					then -k_w*(((T_w__[i+2]-T_w__[i+1])/(x__[i+2]-x__[i+1])) - ((T_w__[i+1]-T_w__[i])/(x__[i+1]-x__[i])))*t_w
					else 0
				) - (g_w[i]-(eps_w * CONST.sigma * T_w__[i+1]^4 + (1-eps_w)*g_w[i]))*dx
				+ (q_conv[i])*dx;
		end if;
	end for;

	mdot_check = phi_s__[1]*rho_s*v_s__[1]*w_c*t_c__[1]  -  phi_s__[N+1]*rho_s*v_s__[N+1]*w_c*t_c__[N+1];

	Qdot_inc = q_solar * A_ap;
	Qdot_rec = mdot * (h_s__[N+1] - h_s__[1]);
	eta_rec = Qdot_rec / Qdot_inc;

	Qdot_check = Qdot_rec - sum(dx*w_c*q_net_c[i] for i in 1:N);

	annotation (Documentation(info="<html>
<p>Model based on an EES-based model written by Kevin Albrecht at Sandia
National Laboratories.</p></html>", revisions="<html>
<dl>
<dt>Armando Fontalvo:<dd>Initial development as a stand-alone model.
<dt>John Pye:<dd>Expanded model with various binary switches plus variable geometry mode.
</ul>
<h4>References</h4>
<ol>
<li>Oles and Jackson, Sol. En. 2015. http://dx.doi.org/10.1016/j.solener.2015.08.009.
<li>Roger et al, JSEE 2011. https://doi.org/10.1115/1.4004269
</ol>
</html>"));
end ParticleReceiver1d_StandAlone;