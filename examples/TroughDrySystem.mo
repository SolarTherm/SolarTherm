within examples;
model TroughDrySystem
	// Imports
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Models.Analysis.Finances;
	extends Modelica.Icons.Example;

	// Parameters
	parameter nSI.Angle_deg lon = 119.8 "Longitude (+ve East)";
	parameter nSI.Angle_deg lat = -23.42 "Latitude (+ve North)";
	parameter nSI.Time_hour t_zone = 8 "Local time zone (UCT=0)";
	parameter Integer year = 1993 "Meteorological year";

	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/AUS_WA.Newman.Airport.943170_RMY.motab");
	parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab");

	parameter SI.Irradiance dni_des = 950 "DNI at design";
	parameter Real SM  = 3.9 "Solar multiple";
	
	// Collector geometry
	parameter SI.Length L_col = 100 "Single-collector length";
	parameter SI.Length col_width = 5 "Single-collector aperture width";
	parameter SI.Area A_col = 470.3 "Single-collector aperture reflective area (m2)";
	parameter Real eta_track = 0.994 "Tracking error and twist";
	parameter Real eta_geom = 0.980 "Geometric accuracy";
	parameter Real eta_refl = 0.935 "Mirror reflectance";
	parameter Real eta_clean = 0.970 "Mirror cleanliness factor";
	parameter Real eta_env = 0.980 "Envelope cleanliness factor";
	parameter Real eta_av = 0.990 "Field availabilty";
	parameter Real eta_sb = 0.963 "Bellows shadow effect";
	parameter Real eta_tr = 0.963 "Envelope transmisivity";
	parameter Real eta_ab = 0.960 "Absorber absorption";
	parameter SI.Efficiency eta_opt = eta_track*eta_geom*eta_refl*eta_clean*eta_env*eta_sb*eta_tr*eta_ab "Optical efficiency of the collector at design";
	parameter SI.HeatFlux q_pip = 10 "Piping heat loss at design";

	// Solar field
	parameter SI.Length row_spacing = 15 "Row spacing, center to center (m)";
	parameter SI.Area A_field(fixed = false);
	parameter Integer n_col = integer(ceil(A_field/A_col));
	parameter Real land_mult = 1.4 "Non-solar field area multiplier";
	parameter SI.Area A_land = land_mult*A_field*row_spacing/col_width*0.0002471 "Land area (acres)";
	parameter SI.HeatFlowRate Q_dni_des = dni_des*A_field "Heat input to the solar field at design DNI";
	parameter SI.HeatFlowRate Q_opt_loss_des = dni_des*A_field*(1-eta_opt) "Field optical losses at design";
	parameter SI.HeatFlowRate Q_pip_des = q_pip*A_field "Field pipework (friction) losses at design";
	parameter SI.HeatFlowRate Q_thermal_des = collectors.HL_des/collectors.A_P*A_field "Field thermal losses at design";

	// Beneficiation process
	parameter Real eff_conv(unit="kg/s/W") = 3.56e-6 "Beneficiation process conversion";
	parameter Modelica.SIunits.HeatFlowRate Q_bp_des = 50e6 "Heat input to the beneficiation process at design";

	// Storage
	parameter Real t_storage(unit="h") = 22.7 "Hours of storage";
	parameter SI.Energy E_max = Q_bp_des*t_storage*3600 "Max stored energy";

	parameter SI.Energy E_up_u = 0.95*E_max "Upper energy limit";
	parameter SI.Energy E_up_l = 0.93*E_max "Upper energy limit";
	parameter SI.Energy E_low_u = 0.07*E_max "Lower energy limit";
	parameter SI.Energy E_low_l = 0.05*E_max "Lower energy limit";
	parameter SI.Irradiance dni_stop = 100 "DNI at which concentrator stops";
	parameter SI.Irradiance dni_start = 200 "DNI at which concentrator starts";

	parameter SI.Time t_con_on_delay = 20*60 "Delay until concentrator starts";
	parameter SI.Time t_con_off_delay = 15*60 "Delay until concentrator shuts off";
	parameter SI.Time t_blk_on_delay = 15*60 "Delay until power block starts";
	parameter SI.Time t_blk_off_delay = 10*60 "Delay until power block shuts off";

	parameter Integer ramp_order = 1 "ramping filter order";

	parameter Integer n_sched_states = 1 "Number of schedule states";
	parameter Integer sch_state_start(min=1, max=n_sched_states) = 1 "Starting schedule state";
	parameter SI.Time t_sch_next_start = 0 "Time to next schedule change";
	parameter SI.HeatFlowRate Q_flow_sched_val[n_sched_states] = {Q_bp_des} "Heat flow at schedule states";
	parameter SI.Time t_delta[n_sched_states] = {24*3600} "Time differences between schedule states";

	parameter Real r_disc = 0.05 "Discount rate";

	parameter Integer t_life(unit="year") = 20 "Lifetime of plant";
	parameter Integer t_cons(unit="year") = 0 "Years of construction";

	parameter FI.AreaPrice pri_field = 150 "Field cost per area ($/m2)";
	parameter FI.AreaPrice pri_site = 25 "Site improvements cost per area ($/m2)";
	parameter FI.EnergyPrice pri_htf_system = 60 "HTF system cost per area ($/m2)";
	parameter SI.Energy E_cap = Q_bp_des*t_storage/1e6 "Storage capacity (MWh)";
	parameter Boolean kroger = true "Use rock bed TES from Kroger";
	parameter FI.EnergyPrice pri_storage = if not kroger then 
		max(6.7219621085958437e1 -5.8435566255147648e1*log10(E_cap) + 1.2454460440741535e1*log10(E_cap)^2 + 3.2837516590788773*log10(E_cap)^3 - 1.5639809068016983*log10(E_cap)^4 + 1.5812648012467967e-1*log10(E_cap)^5, 4.3796273688)
		else
		max(7.6983578254517818e2 -1.2618259870107556e3*log10(E_cap) + 8.7459597623031095e2*log10(E_cap)^2 - 3.1101604101779969e2*log10(E_cap)^3 + 5.5894377895539073e1*log10(E_cap)^4 - 4.0220819724059202*log10(E_cap)^5, 7.0823628957)
		"Storage cost per energy capacity ($/kWh)";
	parameter FI.PowerPrice pri_backup = 0 "Fossil fuel backup cost per power capacity ($/MWe)";
	parameter Real pri_bop(unit = "$/kg/s") = 0 "Balance of plant cost per plant capacity";
	parameter Real pri_block(unit = "$/kg/s") = 910 "Beneficiation process cost per plant capacity";
	parameter FI.AreaPrice pri_land = 10000 "Land cost per area ($/acre)";
	parameter Real pri_om_name(unit = "$/kg/s/year") = 66 "Fixed O&M cost per capacity per year";
	parameter Real pri_om_flow_iron(unit = "$/h") = 438.1 "Variable O&M cost per production per year";
	
	parameter Modelica.SIunits.HeatFlowRate Q_hx_des = Q_bp_des;
	parameter Modelica.SIunits.HeatFlowRate Q_hx_des_ref = 50e6;

	parameter Real n = 0.65 "Cost scaling factor";

	parameter FI.Money C_hx_ref = 58946070 "Heat exchanger reference cost";
	parameter FI.Money C_fbd_ref = 24255986 "FBD reference cost";
	parameter FI.Money C_bcs_ref = 13491551 "Blower, cyclone and separator reference cost";

	parameter FI.Money C_field = pri_field*A_field "Field cost";
	parameter FI.Money C_site = pri_site*A_field "Site improvements cost";
	parameter FI.Money C_storage = pri_storage*E_max/1e3/3600 "Storage cost";

	parameter FI.Money C_hx = C_hx_ref*(Q_hx_des/Q_hx_des_ref)^n "Heat exchanger cost";
	parameter FI.Money C_fbd = C_fbd_ref*(Q_hx_des/Q_hx_des_ref)^n;
	parameter FI.Money C_bcs = C_bcs_ref*(Q_hx_des/Q_hx_des_ref)^n;
	parameter Real f_field = 1;
	parameter Real f_hx = 1;
	parameter Real f_fbd = 1;
	parameter Real f_bcs = 1;
	parameter Real f_stor = 1;

	parameter FI.Money C_cap_dir = f_field*C_field + f_field*C_site + f_hx*C_hx + f_fbd*C_fbd + f_bcs*C_bcs + f_stor*C_storage "Purchase equipment cost";

	parameter Real di_factor = 2.051784 "Added direct and indirect cost factor";
	
	parameter FI.Money C_cap = C_cap_dir*di_factor "Total capital investment";

	parameter FI.Money C_tax = 0.02*C_cap;
	parameter FI.Money C_om = 0.02*C_cap;

	parameter Boolean constrained = false "Constraint is present in optimisation if true";
	parameter Real distance = 0 "Distance to be added to a constant offset as added penalty when a constraint is not respected";

	// Variables/Models
	SolarTherm.Models.Sources.Weather.WeatherSource wea(file=wea_file);
	FI.SpotPriceTable pri(file=pri_file);

	SI.HeatFlowRate Q_flow_rec "Heat flow into receiver";
	SI.HeatFlowRate Q_flow_chg "Heat flow into tank";
	SI.HeatFlowRate Q_flow_dis "Heat flow out of tank";
	SI.MassFlowRate m_flow_iron "Output power of power block";

	Real fr_dfc(min=0, max=1) "Target energy fraction of the heliostat fistateld at the defocused state";
	Boolean full "True if the storage tank is full";

	SolarTherm.Utilities.Transition.Ramp ramp_up_con(ramp_order=ramp_order, t_dur= t_con_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_con(ramp_order=ramp_order, t_dur= t_con_off_delay, up=false);
	Real fr_ramp_con (min=0.0, max=1.0) "ramping transition rate for the concentrator";
	SolarTherm.Utilities.Transition.Ramp ramp_up_blk(ramp_order=ramp_order, t_dur= t_blk_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_blk(ramp_order=ramp_order, t_dur= t_blk_off_delay, up=false);
	Real fr_ramp_blk (min=0.0, max=1.0) "ramping transition rate for the power block";

	SI.Energy E(min=0, max=E_max) "Stored energy";
	SI.HeatFlowRate Q_flow_sched "Discharge schedule";

	Integer con_state(min=1, max=5) "Concentrator state";
	Integer blk_state(min=1, max=4) "Power block state";
	Integer sch_state(min=1, max=n_sched_states) "Schedule state";

	SI.Time  t_con_w_now "Time of concentrator current warm-up event";
	SI.Time  t_con_w_next "Time of concentrator next warm-up event";
	SI.Time  t_con_c_now "Time of concentrator current cool-down event";
	SI.Time  t_con_c_next "Time of concentrator next cool-down event";
	SI.Time  t_blk_w_now "Time of power block current warm-up event";
	SI.Time  t_blk_w_next "Time of power block next warm-up event";
	SI.Time  t_blk_c_now "Time of power block current cool-down event";
	SI.Time  t_blk_c_next "Time of power block next cool-down event";
	SI.Time  t_sch_next "Time of next schedule change";

	FI.Money R_spot(start=0, fixed=true)
		"Spot market revenue";

	Real C_prod "Variable O&M cost per production per year";
	Real C_fixed "Fixed O&M cost per production per year";

	SI.Mass m(start=0, fixed=true) "Production";

	Modelica.Blocks.Sources.RealExpression dni(y = wea.wbus.dni) 
		annotation(Placement(
		transformation(origin = {60,0}, extent={{-140,60},{-120,80}})));

	Modelica.Blocks.Sources.RealExpression Tamb(y=wea.wbus.Tdry) 
		annotation(Placement(
		transformation(origin = {-80, 45}, extent={{-10,-10},{10,10}})));

	Modelica.Blocks.Sources.RealExpression Wspd(y=wea.wbus.wspd)
		annotation(Placement(
		transformation(origin = {-80, 15}, extent={{-10,-10},{10,10}})));

	SolarTherm.Models.Sources.SolarModel.Sun sun(
		lon=lon,
		lat=lat,
		t_zone=t_zone,
		year=year,
		redeclare function solarPosition = SolarTherm.Models.Sources.SolarFunctions.PSA_Algorithm)
		annotation(Placement(
		transformation(origin = {-31,70}, extent={{-10,-10},{10,10}})));

	SolarTherm.Models.CSP.CRS.ParabolicTrough collectors(
		lat = lat,
		n_col = n_col,
		A_col = A_col,
		L_col = L_col)
		annotation(Placement(
		transformation(origin = {-31,30}, extent={{-20,-20},{20,20}})));

initial equation

	A_field = SM*Q_bp_des/(dni_des*eta_opt - collectors.HL_des/collectors.A_P - q_pip);
	
	E = E_low_l;
	Q_flow_sched = Q_flow_sched_val[sch_state_start];
	con_state = 1;
	blk_state = 1;
	sch_state = sch_state_start;
	t_con_w_now = 0;
	t_con_w_next = 0;
	t_con_c_now = 0;
	t_con_c_next = 0;
	t_blk_w_now = 0;
	t_blk_w_next = 0;
	t_blk_c_now = 0;
	t_blk_c_next = 0;
	t_sch_next = t_sch_next_start;

	if E > E_up_u then
		full = true;
	elseif E < E_up_l then
		full = false;
	else
		full = true;
	end if;

algorithm
	// Discrete equation system not yet supported (even though correct)
	// Putting in algorithm section instead
	when con_state == 2 and (wea.wbus.dni <= dni_stop or E >= E_up_u) then
		con_state := 1; // off sun
	elsewhen con_state == 3 and (wea.wbus.dni <= dni_stop) and t_con_off_delay > 0 then
		con_state := 5; // ramp down
	elsewhen con_state == 3 and (wea.wbus.dni <= dni_stop) and t_con_off_delay <= 0 then
		con_state := 1; // off sun(no ramp-down)
	elsewhen con_state == 3 and full then
		con_state := 4; // on sun at part load
	elsewhen con_state == 4 and not full then
		con_state := 3; // on sun at 2407.2full load
	elsewhen con_state == 4 and (wea.wbus.dni <= dni_stop) and t_con_off_delay > 0 then
		con_state := 5; // ramp down
	elsewhen con_state == 4 and (wea.wbus.dni <= dni_stop) and t_con_off_delay <= 0 then
		con_state := 1; // off sun (no ramp-down)
	elsewhen con_state == 1 and wea.wbus.dni >= dni_start and E <= E_up_l and t_con_on_delay > 0 then
		con_state := 2; // start onsteering (i.e. ramp up)
	elsewhen con_state == 1 and wea.wbus.dni >= dni_start and E <= E_up_l and t_con_on_delay <= 0 then
		con_state := 3; // on sun at full (no ramp-up)
	elsewhen con_state == 2 and time >= t_con_w_next then
		con_state := 3; // on sun at full load
	elsewhen con_state == 5 and time >= t_con_c_next then
		con_state := 1; // off sun
	end when;

	when blk_state == 2 and Q_flow_sched <= 0 then
		blk_state := 1; // turn off (or stop ramping) due to no demand
	elsewhen blk_state == 2 and E <= E_low_l then
		blk_state := 1; // turn off (or stop ramping) due to empty tank
	elsewhen blk_state == 3 and Q_flow_sched <= 0 and t_blk_off_delay > 0 then
		blk_state := 4; // ramp down due to no demand
	elsewhen blk_state == 3 and Q_flow_sched <= 0 and t_blk_off_delay <= 0 then
		blk_state := 1; // turn off (no ramp-down) due to no demand
	elsewhen blk_state == 3 and E <= E_low_l and t_blk_off_delay > 0 then
		blk_state := 4; // ramp down due to empty tank
	elsewhen blk_state == 3 and E <= E_low_l and t_blk_off_delay <= 0 then
		blk_state := 1; // turn off (no ramp down) due to empty tank
	elsewhen blk_state == 2 and time >= t_blk_w_next then
		blk_state := 3; // operational, ramp-up completed
	elsewhen blk_state == 1 and Q_flow_sched > 0 and E >= E_low_u  and t_blk_on_delay > 0 then
		blk_state := 2; // ramp up, demand and tank has capacity
	elsewhen blk_state == 1 and Q_flow_sched > 0 and E >= E_low_u  and t_blk_on_delay <= 0 then
		blk_state := 3; // operational (no ramp-up)
	elsewhen blk_state == 4 and time >= t_blk_c_next then
		blk_state := 1; // turn off after the ramp-down is complete
	end when;

	when time >= t_sch_next then
		sch_state := mod(pre(sch_state), n_sched_states) + 1;
	end when;

	when con_state == 2 then
		t_con_w_now := time;
		t_con_w_next := time + t_con_on_delay;
	end when;

	when con_state == 5 then
		t_con_c_now := time;
		t_con_c_next := time + t_con_off_delay;
	end when;

	when blk_state == 2 then
		t_blk_w_now := time;
		t_blk_w_next := time + t_blk_on_delay;
	end when;

	when blk_state == 4 then
		t_blk_c_now := time;
		t_blk_c_next := time + t_blk_off_delay;
	end when;

	for i in 1:n_sched_states loop
		when sch_state == i then
			Q_flow_sched := Q_flow_sched_val[i];
			t_sch_next := time + t_delta[i];
		end when;
	end for;

	when E > E_up_u then
		full := true;
	elsewhen E < E_up_l then
		full := false;
	end when;

	if con_state == 2 then
		fr_ramp_con := if ramp_order == 0 then 0.0 else abs(ramp_up_con.y);
	elseif con_state == 5 then
		fr_ramp_con := if ramp_order == 0 then 0.0 else abs(ramp_down_con.y);
	else
		fr_ramp_con := 0;
	end if;


	if blk_state == 2 then
		fr_ramp_blk := if ramp_order == 0 then 0.0 else abs(ramp_up_blk.y);
	elseif blk_state == 4 then
		fr_ramp_blk := if ramp_order == 0 then 0.0 else abs(ramp_down_blk.y);
	else
	 fr_ramp_blk := 0;
	end if;

equation

	connect(dni.y, sun.dni) annotation(Line(points={{-60,70},{-44,70}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(Tamb.y, collectors.Tamb) annotation(Line(points={{-70,45},{-50, 45}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(Wspd.y, collectors.Wspd) annotation(Line(points={{-70,15},{-50, 15}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(sun.solar, collectors.solar) annotation(Line(points={{-31,60},{-31,50}}, color={255,170,0}));
//	connect(collectors.heat, packedBed.E_flow_in) annotation(Line(points={{-11,30},{21,30}}, color={255,0,0}));

	ramp_up_con.x = t_con_w_now;
	ramp_down_con.x = t_con_c_now;

	ramp_up_blk.x = t_blk_w_now;
	ramp_down_blk.x = t_blk_c_now;

	Q_flow_chg = Q_flow_rec;

	der(E) = Q_flow_chg - Q_flow_dis;

	if con_state <= 1 then
		Q_flow_rec = 0;
		fr_dfc = 0;
	elseif con_state == 2 then
		Q_flow_rec = fr_ramp_con * max(collectors.Qf, 0);
		fr_dfc = if ramp_order == 0 then 0 else 1;
	elseif con_state == 5 then
		Q_flow_rec = fr_ramp_con * max(collectors.Qf, 0);
		fr_dfc = if ramp_order == 0 then 0 else 1;
	else
		if full then
			if (collectors.Qf) > Q_flow_dis then
				Q_flow_rec = min(Q_flow_dis, max(collectors.Qf, 0));
				fr_dfc = Q_flow_dis / (max(collectors.Qf, 0) + 1e-10);
			else
				Q_flow_rec = max(collectors.Qf, 0);
				fr_dfc = 1;
			end if;
		else
			Q_flow_rec = max(collectors.Qf, 0);
			fr_dfc = 1;
		end if;
	end if;

	if blk_state <=1 then
		Q_flow_dis = 0;
		m_flow_iron = 0;
	elseif blk_state == 2 then
		Q_flow_dis = if ramp_order == 0 then Q_flow_sched else fr_ramp_blk * Q_flow_sched;
		m_flow_iron = eff_conv*Q_flow_dis;
	elseif blk_state == 4 then
		Q_flow_dis = fr_ramp_blk * Q_flow_sched;
		m_flow_iron = eff_conv*Q_flow_dis;
	else
		Q_flow_dis = Q_flow_sched;
		m_flow_iron = eff_conv*Q_flow_dis;
	end if;

	der(m) = m_flow_iron;
	
	C_fixed = ceil(m/1000/365/100)*2*139000*0.7285 + C_tax + C_om;
	
	C_prod = m/(8760*eff_conv*Q_bp_des)*8760*pri_om_flow_iron;
	
	der(R_spot) = m_flow_iron*pri.price;
	annotation(experiment(StartTime=0.0, StopTime=31536000.0, Interval=1800, Tolerance=1e-06));
end TroughDrySystem;
