model SolarFuelSystem
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Models.Analysis.Finances;
	import SolarTherm.Types.Solar_angles;

	extends Modelica.Icons.Example;

	// Input Parameters
	// *********************
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/AUS_WA_Geraldton_Airport_944030_RMY.motab");
	parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/troughwagner_opt_eff.motab") "Optical efficiency file";
	parameter String sch_fcst_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Forecasts/forecast_data.motab") if storage and not const_dispatch;
	parameter String sch_fixed_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_solar_fuel.motab") if storage and not const_dispatch and not forecast_scheduler;

	parameter Integer ramp_order_con(min=0, max=2) = 1 "ramping filter order for the concentrator";

	parameter Integer ramp_order_rx_heat(min=0, max=2) = 1 "ramping filter order for heat supply to the reactor";
	parameter Integer ramp_order_rx_algae(min=0, max=2) = 1 "ramping filter order for algae supply to the reactor";
	parameter Integer ramp_order_rx_CO2(min=0, max=2) = 1 "ramping filter order for CO2 dump/release from the reactor";
	parameter Integer ramp_order_rx_elec(min=0, max=2) = 1 "ramping filter order for electricity supply to the reactor";
	parameter Integer ramp_order_rx_sg(min=0, max=2) = 1 "ramping filter order for syngas production from the reactor";

	parameter Integer ramp_order_ft_sg(min=0, max=2) = 1 "ramping filter order for syngas supply to FT";
	parameter Integer ramp_order_ft_elec(min=0, max=2) = 1 "ramping filter order for electricity supply to FT";
	parameter Integer ramp_order_ft_H2_pv(min=0, max=2) = 1 "ramping filter order for PV H2 supply to FT";
	parameter Integer ramp_order_ft_water(min=0, max=2) = 1 "ramping filter order for water supply to FT";
	parameter Integer ramp_order_ft_CO2(min=0, max=2) = 1 "ramping filter order for CO2 dump/release from FT";
	parameter Integer ramp_order_ft_prod(min=0, max=2) = 1 "ramping filter order for products production from FT";

	parameter Integer trans_order_ft_sg(min=0, max=2) = 1 "Transitioning filter order for syngas supply to FT while FT is on";
	parameter Integer trans_order_ft_elec(min=0, max=2) = 1 "Transitioning filter order for electricity supply to FT while FT is on";
	parameter Integer trans_order_ft_H2_pv(min=0, max=2) = 1 "Transitioning filter order for PV H2 supply to FT while FT is on";
	parameter Integer trans_order_ft_water(min=0, max=2) = 1 "Transitioning filter order for water supply to FT while FT is on";
	parameter Integer trans_order_ft_CO2(min=0, max=2) = 1 "Transitioning filter order for CO2 dump/release from FT while FT is on";
	parameter Integer trans_order_ft_prod(min=0, max=2) = 1 "Transitioning filter order for products production from FT while FT is on";

	// Polynomilas coeffs for SCWG+SMR
	parameter Real cf_SCWG[:] = {0.861548846435547, 0.040890337613260, -0.016377240668398, 0.006300210850991, -0.002949360411857, 0.001198974859965, -2.674495240684157e-05, 2.803482204959359e-04, -2.451620638315131e-04} "SCWG efficiency coefficients";
	parameter Real cf_SMR[:] = {0.768282037316067, 0.093488773366821, -0.037724819862177, 0.015670722458670, -0.006367262777059, 0.001640716559506, -6.287807751796056e-04, 9.317070447512179e-04, -3.842549181678559e-04} "SMR efficiency coefficients";
	parameter Real cf_rx[:] = { 0.640798255557369, 0.022098834006959, -0.010723851298492, 0.006750338487959, -3.460944058165703e-04, -0.001495651820584, -0.002071994901842, 0.001274509536169, 1.214843066972747e-04} "Reactor efficiency coefficients";
	parameter Real cfII_rx[:] = {0.239720740558951, 0.017717089768015, -0.007908665634978, 0.004564414831539, 3.723312779643871e-04, -9.934891086378645e-04, -0.001873185660747, 6.710472890737369e-04, 3.101812502901246e-04} "Reactor exergy efficiency coefficients";
	parameter Real cm_algae[:] = {-0.468224708356939, 0.070274163287345, -3.351528856151204e-04, 4.659387778067976e-06, -2.367028491892777e-08} "Algae mass flow rate coefficients";
	parameter Real cn_H2_rx[:] = {-0.035482292615410, 0.005324488630281, -3.586830751137109e-05, 5.831648981921393e-07, -3.515255572433898e-09} "Molar flow rate coefficients for H2";
	parameter Real cn_CH4[:] = {-1.295422230583035e-04, 1.943905192544214e-05, -1.308888391605432e-07, 2.127775120403135e-09, -1.282545613797826e-11} "Molar flow rate coefficients for CH4";
	parameter Real cn_CO[:] = {-0.016795474223253, 0.002520339127028, -1.697830945844060e-05, 2.760430906749691e-07, -1.663966476344280e-09} "Molar flow rate coefficients for CO";
	parameter Real cn_CO2[:] = {-2.292482118122781e-04, 3.440136345573267e-05, -2.318344313332857e-07, 3.769732738572897e-09, -2.272446118760488e-11} "Molar flow rate coefficients for CO2";
	parameter Real cwp_rx[:] = {3.214349160704963e02, 1.536790426747151e02, -1.135605222930574, 2.315935000530164, 3.333549397871687, -2.140229080818388, -3.339222243439558, 0.618459057856818, 0.848233555263823} "Pump power coefficients in reactor";
	parameter Real cr_sg[:] = {7.022488706961313, 0.529534167296794, 0.002088897277410, -2.423308450667479e-05, 1.040004504170970e-07} "Radiation power coefficients";
	parameter Real cm_CO2_rx[:] = {-0.138561262069788, 0.022687988241418} "Mass flow rate coefficients for CO2 dumped/released from the reactor";
	// Polynomilas coeffs for FT
	parameter Real cvf_petrol[:] = {-2.357698951348051e-09, 3.274254974192566e-04} "Volumetric flow rate coefficients for petrol production in FT";
	parameter Real cvf_diesel[:] = {-1.991676070439976e-09, 2.730994248604119e-04} "Volumetric flow rate coefficients for diesel production in FT";
	parameter Real cwc_ft[:] = {-2.885816443529007e-05, 1.164058460840140} "Compressor power coefficients in FT";
	parameter Real cwp_ft[:] = {-1.247610161757073e-05, 3.517701836361515} "Pumps power coefficients in FT";
	parameter Real cwt_ft[:] = {-3.634880001952640e-06, 0.781188945215679} "Turbine power coefficients in FT";
	parameter Real cq_ft[:] = {-4.244948478003601e-05, 5.528142103774671} "Heat flow coefficients in FT";
	parameter Real cm_H2_pv[:] = {-2.242211530720511e-06, 0.018744457967858} "Mass flow rate coefficients for H2 required from PV in FT";
	parameter Real cm_O2[:] = {-1.765190276268872e-05, 0.105121757554788} "Mass flow rate coefficients for O2 produced in FT";
	parameter Real cm_water[:] = {-5.455413565288881e-06, 1.742082041909433} "Mass flow rate coefficients for water required in FT";
	parameter Real cm_CO2_ft[:] = {1.632433704780866e-08, 0.036679737128161} "Mass flow rate coefficients for CO2 dumped/released from FT";

	// Info for sizing the solar field
	parameter SI.Efficiency eff_opt = 0.7449
	"Efficiency of optics at design point (max in opt_file)"; // Needs to change after the lookup table is made. 0.578161677 ----> Ref: SAM obtained by Alireza
	parameter SI.Irradiance dni_des = 1000 "DNI at design point";
	parameter Real C = 1000 "Concentration ratio";
	parameter SI.Area A_rec = 50 "Reactor area";
	parameter Real SM = 4.0 "Solar multiple"; //Potential design variable
	parameter Real land_mult = 1 "Land area multiplier";
	parameter SI.MassFlowRate m_flow_rx_des = 3.0 "Mass flow rate from RX at design point"; // i.e. the size of RX

	parameter Real fr_min_ft = 0.2 "Minium fraction of the nominal mass flow to start the FT";

	constant SI.SpecificEnthalpy LHV_sg = 24.193742112158110e06 "Lower heating value of syngas";
	constant SI.Density rho_sg = 1.08974 "Syngas density at 75C & 3bar"; // at 1bar and 75C: 0.363548, at 20bar and 75C: 7.21335

	parameter Real t_storage(unit="h") = 8 "Hours of storage"; //Potential design variable
	parameter Real ini_frac(min=0, max=1) = 0.1 "Initial fraction charged";

	parameter Real tnk_min_start = 0.1 "Minimum fraction of tank to start dispatch";

	parameter Boolean storage = true "Storage component present";

	parameter Real ft_disp = 0.2 "Min fraction of energy flow to FT";// i.e. 0.19 kg/s of syngas, the minimum flow rate to start the FT
	parameter Boolean const_dispatch = false "Constant dispatch of energy"; // if true, FT operates either at 0 or full load
	parameter Boolean forecast_scheduler = true "Forecasted dispatch of energy during the night"; // if true, the energy dispatch is determined based on energy forecast from next day

	parameter Real tnk_crit_lb(min=0, max=1) = 0.001;
	parameter Real tnk_crit_ub(min=0, max=1) = 0.02;
	parameter Real tnk_empty_lb(min=0, max=1) = 0.01;
	parameter Real tnk_empty_ub(min=0, max=1) = 0.02;
	parameter Real tnk_full_lb(min=0, max=1) = 0.98;
	parameter Real tnk_full_ub(min=0, max=1) = 0.99;

	// Calculated Parameters
	parameter SI.HeatFlowRate Q_flow_des = A_rec * dni_des * C "Heat to the reactor at design point";
	parameter SI.RadiantPower R_des = Q_flow_des "Input power for reactor at design point";
	parameter SI.Area A_field = (R_des/eff_opt)/dni_des "Field area";
	parameter SI.Area A_land = land_mult * A_field "Land area";

	parameter SI.MassFlowRate m_flow_ft_des = m_flow_rx_des / SM "Mass flow rate to FT at design point"; //Showing the size of the FT
	parameter SI.EnergyFlowRate E_flow_ft_des = m_flow_ft_des * LHV_sg "Energy flow to FT at design point";
	parameter SI.EnergyFlowRate E_flow_ft_min = fr_min_ft * E_flow_ft_des "Minimum energy flow to start the FT";

	parameter SI.Energy E_max = t_storage * 3600 * E_flow_ft_des "Maximum tank stored energy";
	parameter SI.Volume V_max = E_max / (LHV_sg * rho_sg) "Tank volume";

	// Cost data
	parameter Real r_disc = 0.05 "Discount rate";
	parameter Real r_i = 0.03 "Inflation rate";
	parameter Integer t_life(unit="year") = 30 "Lifetime of plant";
	parameter Integer t_cons(unit="year") = 2 "Years of construction";

	parameter Real f_site_prep = 0.15 "Site preparation factor";
	parameter Real f_serv_fac = 0.20 "Service facilities factor";
	parameter Real f_cont = 0.18 "Contingencies and contractor fee factor";
	parameter Real f_land = 0.02 "Land cost factor";
	parameter Real f_startup = 0.1 "Startup cost factor";
	parameter Real f_wc = 0.15 "Working capital factor";
	parameter Real f_insur = 0.02 "Insurance and local taxes factor";
	parameter Real f_om = 0.02 "Operational and maintenance cost factor";

	parameter Real f_Subs = 0.0 "Subsidies on initial investment costs";

	parameter Real f_bm_sf = 1.25 "Bare module factor for the solar field";
	parameter Real f_bm_st = 1.83 "Bare module factor for the syngas storage tank";

	parameter FI.MassPrice pri_nickel = 45.0 "Cost of Nickel catalyst per kilogram";
	parameter FI.MassPrice pri_cobalt = 45.0 "Cost of Cobalt catalyst per kilogram";
	parameter FI.MassPrice pri_platinum = 72.28 "Cost of Platinum catalyst per kilogram";

	parameter FI.MassPrice pri_water = 2.6*(1e-3) "Cost of water per kilogram"; // Ref: http://www.teampoly.com.au/knowledge-base/water-prices-in-australia/index.html
	parameter FI.MassPrice pri_algae = 1.2 "Cost of algae per kilogram";
	parameter FI.MassPrice pri_H2 = 18 "Cost of hydrogen per kilogram";
	parameter FI.MassPrice pri_CO2 = 25.4*(1e-3) "Penalty cost for CO2 emissions per kilogram";
	parameter FI.MassPrice pri_O2 = 115.57*(1e-3) "Cost of Oxygen to sell per kilogram";
	parameter FI.EnergyPrice_kWh pri_elec = 0.25 "Cost of grid electricity per kWh";

	parameter Real fuel_conv_ratio = 0.9 "Conversion ratio of diesel to petrol for price calculation";
	parameter FI.VolumePrice pri_spot = 1.31e3 "Fuel spot price";

	//parameter FI.AreaPrice pri_land = 10000/4046.86 "Land cost per area";
	//parameter FI.Money C_land = pri_land * A_land "Land cost";

	parameter FI.AreaPrice pri_field = 120+15 "Field cost per design aperture area";
	parameter FI.Money C_field = f_bm_sf * (pri_field * A_field) "Solar field capital cost";

	parameter FI.PowerPrice pri_tower = 0.051 "Tower cost per design power";
	parameter FI.Money C_tower = f_bm_sf * (pri_tower * R_des) "Tower capital cost";

	parameter FI.PowerPrice pri_rx = 0.39417294 "Receiver cost per design power";
	parameter FI.Money C_rx = pri_rx * R_des "Receiver capital cost";

	//If gasometer(gas holder) is used, then uncomment the follwing to estimate the cost of storage:
	//parameter SI.Volume V_lb = 4000 * 0.0283168 "Lower bound of tank volume in cost function";
	//parameter SI.Volume V_ub = 400000 * 0.0283168 "Upper bound of tank volume in cost function";
	//parameter Integer n_st = integer(ceil(V_max/V_ub)) "Number of storage tanks";
	//if V_max < V_lb then
		//V_unit := V_lb;
	//else
		//V_unit := V_max / n_st;
	//end if;
	//parameter FI.Money C_st = f_bm_st * (n_st * FI.gasHolderCost_V(V_unit)) "Storage tanks capital cost";

	//If the unit cost from Saw and Jim, then uncomment the following to estimate the cost of storage:
	//parameter FI.EnergyPrice pri_st = 9475/1e9 "Syngas storage cost per unit of energy";
	//parameter FI.Money C_st = f_bm_st * (pri_st * E_max) "Storage tanks capital cost";

	// If a horizontal cylindrical pressure vessel is used, then use the following to estimate the cost of storage:
	parameter Integer n_st(fixed = false) "Number of storage tanks";
	parameter FI.Money C_st(fixed = false) "Storage tanks capital cost";

	parameter FI.Money C_ft = FI.fischerTropschCost_m_sg(m_flow_ft_des) "fischer tropsch reactor cost";

	parameter FI.Money C_tbm = (1 - f_Subs) * (C_field + C_tower + C_rx + C_st + C_ft) "Total bare module investment cost";
	parameter FI.Money C_site = f_site_prep * C_tbm "Site preparation cost";
	parameter FI.Money C_serv = f_serv_fac * C_tbm "Service facilities cost";
	parameter FI.Money C_dpi = C_tbm + C_site + C_serv "Direct permanent investment cost";
	parameter FI.Money C_cont = f_cont * C_dpi "Contingencies and contractor fee";
	parameter FI.Money C_tdc = C_dpi + C_cont "Total depreciable capital cost";
	parameter FI.Money C_land = f_land * C_tdc "Cost of land";
	parameter FI.Money C_startup = f_startup * C_tdc "Cost of startup";
	parameter FI.Money C_tpi = C_tdc + C_land + C_startup "Total permanent investment cost";
	parameter FI.Money C_wc = f_wc * C_tpi "Working capital cost";
	parameter FI.Money C_tci = C_tpi + C_wc "Total capital investment cost";

	parameter FI.Money C_cap = C_tci "Total capital cost of the plant in AUD";

	parameter FI.MoneyPerYear pri_labor = 139000 "Cost of labour per person per year";
	parameter Integer n_labor = FI.nLabour_m_sg(m_flow_ft_des) "Number of labor working at the plant";
	parameter FI.MoneyPerYear C_labor = pri_labor * n_labor "Labor annual cost in AUD";

	parameter FI.Money C_catalyst = (pri_nickel * RX.m_nickel_rx/3.0) + (pri_nickel * FT.m_nickel_ft/3.0) + (pri_cobalt * FT.m_cobalt_ft/3.0) + (pri_platinum * FT.m_platinum_ft/3.0) "Catalysts cost for each year of operation in AUD";

	parameter FI.MoneyPerYear C_insur = f_insur * C_tci "Insurance and local taxes cost for each year in AUD";
	parameter FI.MoneyPerYear C_om = C_insur + (f_om * C_tci) "Operational and maintenance cost for each year in AUD";

	// System components
	// *********************
	SolarTherm.Models.Sources.Weather.WeatherSource wea(file=wea_file);

	SolarTherm.Models.CSP.CRS.HeliostatsField.SwitchedCL_2 CL(
		redeclare model OptEff=SolarTherm.Models.CSP.CRS.HeliostatsField.FileOE(
		angles=Solar_angles.ele_azi, file=opt_file, orient_north=if wea.lat < 0 then true else false),
		A=A_field,
		ramp_order=ramp_order_con
		);

	SolarTherm.Models.CSP.CRS.Reactors.GenericRX RX(
			cf_SCWG=cf_SCWG,
			cf_SMR=cf_SMR,
			cf_rx=cf_rx,
			cfII_rx=cfII_rx,
			cm_algae=cm_algae,
			cn_H2_rx=cn_H2_rx,
			cn_CH4=cn_CH4,
			cn_CO=cn_CO,
			cn_CO2=cn_CO2,
			cwp_rx=cwp_rx,
			cm_CO2_rx=cm_CO2_rx,
			pv=false,
			ramp_order_heat=ramp_order_rx_heat,
			ramp_order_algae=ramp_order_rx_algae,
			ramp_order_CO2=ramp_order_rx_CO2,
			ramp_order_elec=ramp_order_rx_elec,
			ramp_order_sg=ramp_order_rx_sg);

	SolarTherm.Models.Storage.Tank.SimpleST ST(
			E_max=E_max,
			E_0=E_max*ini_frac) if storage;

	SolarTherm.Models.CSP.CRS.Reactors.GenericFT FT(
			E_sg_des = E_flow_ft_des,
			E_sg_min = E_flow_ft_min,
			fuel_conv_ratio = fuel_conv_ratio,
			cvf_petrol=cvf_petrol,
			cvf_diesel=cvf_diesel,
			cwc_ft=cwc_ft,
			cwp_ft=cwp_ft,
			cwt_ft=cwt_ft,
			cq_ft=cq_ft,
			cm_H2_pv=cm_H2_pv,
			cm_O2=cm_O2,
			cm_water=cm_water,
			cm_CO2_ft=cm_CO2_ft,
			ramp_order_sg=ramp_order_ft_sg,
			ramp_order_elec=ramp_order_ft_elec,
			ramp_order_H2_pv=ramp_order_ft_H2_pv,
			ramp_order_water=ramp_order_ft_water,
			ramp_order_CO2=ramp_order_ft_CO2,
			ramp_order_prod=ramp_order_ft_prod,
			trans_order_sg=trans_order_ft_sg,
			trans_order_elec=trans_order_ft_elec,
			trans_order_H2_pv=trans_order_ft_H2_pv,
			trans_order_water=trans_order_ft_water,
			trans_order_CO2=trans_order_ft_CO2,
			trans_order_prod=trans_order_ft_prod);

	SolarTherm.Models.Control.SyngasTankDispatch dis(
		full_lb=tnk_full_lb*E_max,
		full_ub=tnk_full_ub*E_max,
		empty_lb=tnk_empty_lb*E_max,
		empty_ub=tnk_empty_ub*E_max,
		crit_lb=tnk_crit_lb*E_max,
		crit_ub=tnk_crit_ub*E_max,
		level_start=tnk_min_start*E_max,
		disp_min=ft_disp*E_flow_ft_des,
		cr_sg=cr_sg) if storage;

	SolarTherm.Models.Sources.DataTable.ForecastTable forecast(
			file=sch_fcst_file,
			startTime=-24*3600) if storage and not const_dispatch and forecast_scheduler;

	SolarTherm.Models.Sources.Schedule.ForecastScheduler sch_fcst(
			final n_sched_states=2,
			E_flow_des=E_flow_ft_des,
			fr_min=fr_min_ft,
			E_max=E_max
			) if storage and not const_dispatch and forecast_scheduler;

	SolarTherm.Models.Sources.Schedule.Scheduler sch_fixed(
			file = sch_fixed_file,
			ndaily = 3,
			wmap={{2,2,2,2,2,2,2}},
			mmap={1,1,1,1,1,1,1,1,1,1,1,1}
			) if storage and not const_dispatch and not forecast_scheduler;

	Modelica.Blocks.Continuous.Integrator m_alg_req(y_start=0) "Mass of algae required by the reactor"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_sg_prod(y_start=0) "Mass of syngas produced by the reactor"; // [J]
	Modelica.Blocks.Continuous.Integrator E_rx_prod(y_start=0) "Energy of syngas produced by the reactor";
	Modelica.Blocks.Continuous.Integrator v_petr_prod(y_start=0) "Volume of petrol produced in FT";  // [m3]
	Modelica.Blocks.Continuous.Integrator v_dies_prod(y_start=0) "Volume of diesel produced in FT";  // [m3]
	Modelica.Blocks.Continuous.Integrator m_O2_prod(y_start=0) "Mass of Oxygen produced in FT"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_w_req(y_start=0) "Mass of water required"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_H2_req(y_start=0) "Mass of H2 required from PV"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_CO2_emiss(y_start=0) "Mass of CO2 released/dumped to environment"; // [kg]
	Modelica.Blocks.Continuous.Integrator E_elec_cons(y_start=0) "Plant electricity consumption"; // [J]

	Modelica.Blocks.Continuous.Integrator m_alg_waste(y_start=0) "Mass of algae supply wasted at the reactor"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_sg_waste(y_start=0) "Mass of Syngas supply wasted at FT"; // [kg]
	Modelica.Blocks.Continuous.Integrator E_sg_waste(y_start=0) "Syngas energy wasted at FT"; // [J]
	Modelica.Blocks.Continuous.Integrator m_water_waste(y_start=0) "Mass of water supply wasted at the reactor and FT"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_H2_pv_waste(y_start=0) "Mass of H2 supply wasted at the reactor and FT"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_CO2_waste(y_start=0) "Mass of CO2 supply dumped/released from the reactor and FT when the products are rubbish"; // [kg]
	Modelica.Blocks.Continuous.Integrator E_elec_waste(y_start=0) "Plant electricity consumption wasted at the reactor and FT"; // [J]

	// Variables
	// *********************
	Real sched if storage;
	SolarTherm.Types.SurfaceEnergyDensity dni_int(start=0, fixed=true);
	SI.Irradiance dni_mean (start=0, fixed=true);
	SI.Volume V_fuel(start=0);
	FI.Money C_water(start=0) "Cost of water";
	FI.Money C_algae(start=0) "Cost of algae";
	FI.Money C_H2(start=0) "Cost of hydrogen";
	FI.Money C_CO2(start=0) "Cost of CO2 emissions";
	FI.Money C_O2(start=0) "Cost of Oxygen to sell";
	FI.Money C_elec(start=0) "Cost of electricity consumption";
	FI.Money C_op(start=0) "Operating costs";
	FI.Money R_spot(start=0) "Spot market revenue";
	// Equations
	// *********************
initial equation
	(n_st, C_st) = FI.pressureVesselCost_V(V_max, f_bm_st);

equation
	connect(wea.wbus, CL.wbus);
	connect(wea.wbus, RX.wbus);
	connect(CL.R_foc, RX.R);

	CL.track = true;
	RX.rx_on = true;

	if storage then
		if const_dispatch then
			sched = 1;
		else
			if forecast_scheduler then
				connect(ST.E,sch_fcst.level);
				connect(forecast.E_fcst,sch_fcst.forecast_prod);
				sched = sch_fcst.v;
			else
				connect(wea.wbus, sch_fixed.wbus);
				sched = sch_fixed.v;
			end if;
		end if;
		connect(RX.E_flow, ST.E_flow_in);
		connect(ST.E_flow_out, FT.E_sg);
		connect(ST.E_flow_in, dis.flow_in);
		connect(ST.E, dis.level);
		dis.flow_tar = sched*E_flow_ft_des;
		ST.E_flow_set = abs(dis.flow_dis);
		connect(dis.full,CL.defocus);
		connect(dis.R_tar, CL.R_dfc);
	else
		connect(RX.E_flow, FT.E_sg);
		CL.defocus = false;
		CL.R_dfc = 0;
	end if;

	// Cumulative performance-related results:
	m_alg_req.u = RX.m_flow_algae;
	m_sg_prod.u = RX.m_flow_sg;
	E_rx_prod.u = RX.E_flow;
	v_petr_prod.u = FT.v_flow_petrol;
	v_dies_prod.u = FT.v_flow_diesel;
	V_fuel = v_petr_prod.y + (fuel_conv_ratio * v_dies_prod.y);
	m_O2_prod.u = FT.m_flow_O2;
	m_w_req.u = RX.m_flow_water + FT.m_flow_water;
	m_H2_req.u = RX.m_flow_H2_pv + FT.m_flow_H2_pv;
	m_CO2_emiss.u = RX.m_flow_CO2 + FT.m_flow_CO2;
	E_elec_cons.u = FT.P_C - FT.P_T + RX.P_pump + FT.P_pumps;

	m_alg_waste.u = RX.m_flow_algae_waste;
	m_sg_waste.u = FT.m_flow_sg_in_waste;
	E_sg_waste.u = FT.E_sg_in_waste;
	m_water_waste.u = RX.m_flow_water_waste + FT.m_flow_water_waste;
	m_H2_pv_waste.u = RX.m_flow_H2_pv_waste + FT.m_flow_H2_pv_waste;
	m_CO2_waste.u = RX.m_flow_CO2_waste + FT.m_flow_CO2_waste;
	E_elec_waste.u = RX.P_pump_waste + FT.P_C_waste + FT.P_pumps_waste;

	// Variable cost calculation:
	C_water = m_w_req.y * pri_water;
	C_algae = m_alg_req.y * pri_algae;
	C_H2 = m_H2_req.y * pri_H2;
	C_CO2 = m_CO2_emiss.y * pri_CO2;
	C_O2 = m_O2_prod.y * pri_O2;
	C_elec = ((E_elec_cons.y)/(3.6e6)) * pri_elec;
	C_op = C_water + C_algae + C_H2 + C_CO2 - C_O2 + C_elec;

	R_spot = V_fuel * pri_spot;

	der(dni_int) = wea.wbus.dni;
	when terminal() then
		dni_mean = dni_int / CL.tot;
	end when;
	annotation(experiment(StartTime=0.0, StopTime=31536000.0, Interval=60, Tolerance=1e-06));
end SolarFuelSystem;
