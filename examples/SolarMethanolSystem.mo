within examples;
model SolarMethanolSystem
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
	parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/solar_fuel_opt_eff.motab") "Optical efficiency file";
	parameter String sch_fcst_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Forecasts/forecast_data.motab") if storage and not const_dispatch;
	parameter Integer n_night = 1 "Number of nights that the storage should have enough energy for as part of forecasting";
	parameter String sch_fixed_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_solar_fuel.motab") if storage and not const_dispatch and not forecast_scheduler;

	parameter Boolean H2_makeup = false "true if there is H2 makeup";

	parameter SI.Time t_con_on_delay = 30 "Delay until heliostat field starts";
	parameter SI.Time t_con_off_delay = 30 "Delay until heliostat field shuts off";

	parameter SI.Time t_rx_on_delay = 30*60 "Delay until reactor starts";
	parameter SI.Time t_rx_off_delay = 30*60 "Delay until reactor shuts off";

	parameter SI.Time t_msr_on_delay = 1.5*60*60 "Delay until MSR starts";
	parameter SI.Time t_msr_trans_delay = 1.5*60*60 "Transition time when the syngas supply flow changes";
	parameter SI.Time t_msr_off_delay = 1.5*60*60 "Delay until MSR shuts off";

	parameter Integer ramp_order_con(min=0, max=2) = 1 "ramping filter order for the concentrator";

	parameter Integer ramp_order_rx_heat(min=0, max=2) = 1 "ramping filter order for heat supply to the reactor";
	parameter Integer ramp_order_rx_algae(min=0, max=2) = 1 "ramping filter order for algae supply to the reactor";
	parameter Integer ramp_order_rx_CO2(min=0, max=2) = 1 "ramping filter order for CO2 dump/release from the reactor";
	parameter Integer ramp_order_rx_elec(min=0, max=2) = 1 "ramping filter order for electricity supply to the reactor";
	parameter Integer ramp_order_rx_sg(min=0, max=2) = 1 "ramping filter order for syngas production from the reactor";

	parameter Integer ramp_order_msr_sg(min=0, max=2) = 1 "ramping filter order for syngas supply to MSR";
	parameter Integer ramp_order_msr_elec(min=0, max=2) = 1 "ramping filter order for electricity supply to MSR";
	parameter Integer ramp_order_msr_CO2(min=0, max=2) = 1 "ramping filter order for CO2 dump/release from MSR";
	parameter Integer ramp_order_msr_prod(min=0, max=2) = 1 "ramping filter order for products production from MSR";

	parameter Integer trans_order_msr_sg(min=0, max=2) = 1 "Transitioning filter order for syngas supply to MSR while MSR is on";
	parameter Integer trans_order_msr_elec(min=0, max=2) = 1 "Transitioning filter order for electricity supply to MSR while MSR is on";
	parameter Integer trans_order_msr_CO2(min=0, max=2) = 1 "Transitioning filter order for CO2 dump/release from MSR while MSR is on";
	parameter Integer trans_order_msr_prod(min=0, max=2) = 1 "Transitioning filter order for products production from MSR while MSR is on";

	// Polynomilas coeffs for SCWG+methane reforming reactor

	// Coefficients for SMR with CO2 dumped:
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

	// Coefficients for SMR with H2 make-up:
	//parameter Real cf_SCWG[:] = {0.861548846435547, 0.040890337613260, -0.016377240668398, 0.006300210850991, -0.002949360411857, 0.001198974859965, -2.674495240684157e-05, 2.803482204959359e-04, -2.451620638315131e-04} "SCWG efficiency coefficients";
	//parameter Real cf_SMR[:] = {0.768282037326182, 0.093488773418409, -0.037724820032708, 0.015670722323667, -0.006367262395985, 0.001640716680835, -6.287810457842271e-04, 9.317070127963413e-04, -3.842548570574841e-04} "SMR efficiency coefficients";
	//parameter Real cf_rx[:] = {0.687025594611737, 0.021431016489290, -0.009918028145347, 0.005228896505506, -0.002648352476403, -6.868599112458954e-05, 2.112000484161840e-04, 9.100872044658880e-04, -4.887469300572853e-04} "Reactor efficiency coefficients";
	//parameter Real cfII_rx[:] = {0.431119708281740, 0.024676534855107, -0.010792719118631, 0.005124108830129, -0.002420528092795, 2.622140185849018e-04, 1.883967269845761e-05, 6.434684732893853e-04, -3.363129426621995e-04} "Reactor exergy efficiency coefficients";
	//parameter Real cm_algae[:] = {-0.473161279150002, 0.070525907955420, -4.097745858339394e-04, 6.284176107925915e-06, -3.577159037296405e-08} "Algae mass flow rate coefficients";
	//parameter Real cn_H2_rx[:] = {-0.030582575757576, 0.004558319752007, -2.651910256410351e-05, 4.067736337736557e-07, -2.315643615643777e-09} "Molar flow rate coefficients for H2";
	//parameter Real cn_CH4[:] = {-9.733721548821562e-05, 1.450788340240011e-05, -8.458620014245290e-08, 1.298337952171353e-09, -7.395221445221981e-12} "Molar flow rate coefficients for CH4";
	//parameter Real cn_CO[:] = {-0.020143153198653, 0.003002342636838, -1.746453671328680e-05, 2.678840110506809e-07, -1.524980574980601e-09} "Molar flow rate coefficients for CO";
	//parameter Real cn_CO2[:] = {-3.437720244107729e-04, 5.124008856729678e-05, -2.973984799922276e-07, 4.558611542778197e-09, -2.593609168609168e-11} "Molar flow rate coefficients for CO2";
	//parameter Real cwp_rx[:] = {3.148488841047790e02, 1.511300409667773e02, -0.389043498507857, 0.105363118972932, -0.196827420513049, 0.121325803744551, 0.098676758960660, 0.013863241278019, -0.051864629997255} "Pump power coefficients in reactor";
	//parameter Real cr_sg[:] = {7.015720194048859, 0.443071425171402, 0.001213367730478, -1.080548794540187e-05, 3.566904682826104e-08} "Radiation power coefficients";
	//parameter Real cm_CO2_rx[:] = {0, 0} "Mass flow rate coefficients for CO2 dumped/released from the reactor";

	// Coefficients for ATR with H2 make-up:
	//parameter Real cf_SCWG[:] = {0.861548846435547, 0.040890337613260, -0.016377240668398, 0.006300210850991, -0.002949360411857, 0.001198974859965, -2.674495240684157e-05, 2.803482204959359e-04, -2.451620638315131e-04} "SCWG efficiency coefficients";
	//parameter Real cf_SMR[:] = {0.768282037326182, 0.093488773418409, -0.037724820032708, 0.015670722323667, -0.006367262395985, 0.001640716680835, -6.287810457842271e-04, 9.317070127963413e-04, -3.842548570574841e-04} "SMR efficiency coefficients";
	//parameter Real cf_rx[:] = {0.696396908610051, 0.017928635336211, -0.008266951169057, 0.004344008304303, -0.002185717683978, -7.229528836104134e-05, 1.482704123290864e-04, 7.695327419764168e-04, -4.026339214968672e-04} "Reactor efficiency coefficients";
	//parameter Real cfII_rx[:] = {0.441893492653477, 0.020912246703955, -0.009177594003639, 0.004322582090546, -0.002191423185768, 2.789495746872515e-04, 9.512319056539256e-05, 5.740079719418247e-04, -3.264943946335905e-04} "Reactor exergy efficiency coefficients";
	//parameter Real cm_algae[:] = {-0.498174365095458, 0.078411623398637, -4.497368722756696e-04, 6.976050480420177e-06, -4.015493354312776e-08} "Algae mass flow rate coefficients";
	//parameter Real cn_H2_rx[:] = {-0.028652543350168, 0.004509642643313, -2.592167233229654e-05, 4.023241172407741e-07, -2.317191142191098e-09} "Molar flow rate coefficients for H2";
	//parameter Real cn_CH4[:] = {-1.027260774410767e-05, 1.616568248726575e-06, -9.370312095311857e-09, 1.458338945005574e-10, -8.423724423724177e-13} "Molar flow rate coefficients for CH4";
	//parameter Real cn_CO[:] = {-0.021407725168350, 0.003369491880558, -1.933052800440401e-05, 2.998427134594017e-07, -1.725901320901470e-09} "Molar flow rate coefficients for CO";
	//parameter Real cn_CO2[:] = {-2.534988425925936e-04, 3.990510193818547e-05, -2.270436399249016e-07, 3.511795950962867e-09, -2.015300440300616e-11} "Molar flow rate coefficients for CO2";
	//parameter Real cwp_rx[:] = {3.559542361264907e02, 1.688099984254838e02, -0.378275748099016, 0.168682417113760, -0.170622147652501, 0.045153222426341, 0.045123060727875, 0.039283686884855, -0.038839038209280} "Pump power coefficients in reactor";
	//parameter Real cr_sg[:] = {6.633771582967861, 0.394544619753353, 9.666766326999010e-04, -7.698436512304350e-06, 2.272377287564413e-08} "Radiation power coefficients";
	//parameter Real cm_CO2_rx[:] = {0,0} "Mass flow rate coefficients for CO2 dumped/released from the reactor";

	// Coefficients for PODR with H2 make-up:
	//parameter Real cf_SCWG[:] = {0.861548846435547, 0.040890337613260, -0.016377240668398, 0.006300210850991, -0.002949360411857, 0.001198974859965, -2.674495240684157e-05, 2.803482204959359e-04, -2.451620638315131e-04} "SCWG efficiency coefficients";
	//parameter Real cf_SMR[:] = {0.768282037326182, 0.093488773418409, -0.037724820032708, 0.015670722323667, -0.006367262395985, 0.001640716680835, -6.287810457842271e-04, 9.317070127963413e-04, -3.842548570574841e-04} "SMR efficiency coefficients";
	//parameter Real cf_rx[:] = {0.712878880020749, 0.008907306041831, -0.003785699730558, 0.001637658430799, -0.001002577977438, 2.896157934164272e-04, 9.450292831824031e-05, 1.376579114797136e-04, -1.126873242030549e-04} "Reactor efficiency coefficients";
	//parameter Real cfII_rx[:] = {0.445830125285907, 0.010474867200685, -0.004496668769385, 0.001811636973897, -7.526741304551024e-04, 3.426839004968730e-04, -1.276409540301475e-04, 1.251077532207179e-04, -6.398810419356095e-05} "Reactor exergy efficiency coefficients";
	//parameter Real cm_algae[:] = {-0.356535600819693, 0.090707540844623, -2.951466684081717e-07, 1.311386705516475e-08, -8.184184149238017e-11} "Algae mass flow rate coefficients";
	//parameter Real cn_H2_rx[:] = {-0.014665128787879, 0.003731068657731, -1.975621600827403e-08, 6.965811966252525e-10, -4.726754727078410e-12} "Molar flow rate coefficients for H2";
	//parameter Real cn_CH4[:] = {-1.375550925925921e-06, 3.500406004489336e-07, -4.203088578096711e-12, 1.186005352675481e-13, -9.388759388789998e-16} "Molar flow rate coefficients for CH4";
	//parameter Real cn_CO[:] = {-0.015041125420875, 0.003826492526763, -1.709077958819327e-08, 6.070102736323043e-10, -3.574203573924458e-12} "Molar flow rate coefficients for CO";
	//parameter Real cn_CO2[:] = {-4.653257323232308e-04, 1.183582922170423e-04, -2.888662263745366e-10, 1.207588707612732e-11, -3.328153328344878e-14} "Molar flow rate coefficients for CO2";
	//parameter Real cwp_rx[:] = {5.165097377065779e02, 2.330790820527035e02, 0.342703194387771, -0.416510724656649, -0.810581334750472, 0.375187277505359, 0.632826393692572, -0.095015293632266, -0.149658157438693} "Pump power coefficients in reactor";
	//parameter Real cr_sg[:] = {3.930169506060433, 0.330404401596025, -3.452392727089805e-07, -6.638790936857809e-10} "Radiation power coefficients";
	//parameter Real cm_CO2_rx[:] = {0,0} "Mass flow rate coefficients for CO2 dumped/released from the reactor";

	// Polynomilas coeffs for MSR
	parameter Real cvf_methanol[:] = {-4.295280186314835e-09, 0.001229898347413} "Volumetric flow rate coefficients for methanol production in MSR";
	parameter Real cwc_msr[:] = {-6.495030514919800e-06, 1.847556974672308} "Compressor power coefficients in MSR";
	parameter Real cq_msr[:] = {-3.190095897092109e-05, 3.038537025564585} "Heat flow coefficients in MSR";
	parameter Real cm_CO2_msr[:] = {-1.598620420802186e-07, 0.005622766560931} "Mass flow rate coefficients for CO2 dumped/released from MSR";

	// Info for sizing the solar field
	parameter SI.Efficiency eff_opt = 0.71776
	"Efficiency of optics at design point (max in opt_file)";
	parameter SI.Irradiance dni_des = 1000 "DNI at design point";
	parameter Real C = 1000 "Concentration ratio";
	parameter SI.Area A_rec = 50 "Reactor area";
	parameter Real SM = 4.0 "Solar multiple"; //Potential design variable
	parameter Real land_mult = 1 "Land area multiplier";
	parameter SI.MassFlowRate m_flow_rx_des = 3.0 "Mass flow rate from RX at design point"; // i.e. the size of RX. SMR with CO2 dumping: 3.0, SMR with H2 makeup: 3.65, ATR: 4.11, PODR: 5.93

	parameter Real fr_min_msr = 0.2 "Minium fraction of the nominal mass flow to start the MSR";

	constant SI.SpecificEnthalpy LHV_sg = 24.193742112158110e06 "Lower heating value of syngas";
	constant SI.Density rho_sg = 1.08974 "Syngas density at 75C & 3bar"; // at 1bar and 75C: 0.363548, at 20bar and 75C: 7.21335

	parameter Real t_storage(unit="h") = 15 "Hours of storage"; //Potential design variable
	parameter Real ini_frac(min=0, max=1) = 0.1 "Initial fraction charged";

	parameter Real tnk_min_start = 0.1 "Minimum fraction of tank to start dispatch";

	parameter Boolean storage = true "Storage component present";

	parameter Real msr_disp = 0.2 "Min fraction of energy flow to MSR";// i.e. 0.19 kg/s of syngas, the minimum flow rate to start the MSR
	parameter Boolean const_dispatch = false "Constant dispatch of energy"; // if true, MSR operates either at 0 or full load
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

	parameter SI.MassFlowRate m_flow_msr_des = m_flow_rx_des / SM "Mass flow rate to MSR at design point"; //Showing the size of the MSR
	parameter SI.EnergyFlowRate E_flow_msr_des = m_flow_msr_des * LHV_sg "Energy flow to MSR at design point";
	parameter SI.EnergyFlowRate E_flow_msr_min = fr_min_msr * E_flow_msr_des "Minimum energy flow to start the MSR";

	parameter SI.Energy E_max = t_storage * 3600 * E_flow_msr_des "Maximum tank stored energy";
	parameter SI.Volume V_max = E_max / (LHV_sg * rho_sg) "Tank volume";

	// Cost data
	parameter Real r_disc = 0.05 "Discount rate";
	parameter Real r_i = 0.03 "Inflation rate";
	parameter Real t_life(unit="year") = 30 "Lifetime of plant";
	parameter Real t_cons(unit="year") = 2 "Years of construction";

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
	parameter FI.VolumePrice pri_catalyst = 76.5776467725205 "Cost of Cu/ZnO/Al2O3 catalyst per m3";

	parameter FI.MassPrice pri_water = 2.6*(1e-3) "Cost of water per kilogram"; // Ref: http://www.teampoly.com.au/knowledge-base/water-prices-in-australia/index.html
	parameter FI.MassPrice pri_algae = 0.61025 "Cost of algae per kilogram";
	parameter FI.MassPrice pri_H2 = 9.721883 "Cost of hydrogen per kilogram"; // Ref: TEA of a PV-based hydrogen electrolyser plant by Mahesh Venkataraman
	parameter FI.MassPrice pri_CO2 = 25.4*(1e-3) "Penalty cost for CO2 emissions per kilogram";
	parameter FI.EnergyPrice_kWh pri_elec = 0.25 "Cost of grid electricity per kWh";

	parameter FI.VolumePrice pri_spot = 0.569778128e3 "Fuel spot price";

	//parameter FI.AreaPrice pri_land = 10000/4046.86 "Land cost per area";
	//parameter FI.Money C_land = pri_land * A_land "Land cost";

	parameter FI.AreaPrice pri_field = 120+15 "Field cost per design aperture area";
	parameter FI.Money C_field = f_bm_sf * (pri_field * A_field) "Solar field capital cost";

	parameter FI.PowerPrice pri_tower = 0.051 "Tower cost per design power";
	parameter FI.Money C_tower = f_bm_sf * (pri_tower * R_des) "Tower capital cost";

	parameter FI.PowerPrice pri_rx = 0.354024491010332 "Receiver cost per design power"; // SMR with dumping : 0.354024491010332, SMR with H2 makeup: 0.347677539618532, ATR with H2 makeup: 0.467861912430237, PODR with H2 makeup: 0.546079626560444
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

	parameter FI.Money C_ds_rx(fixed=false) "Methaol synthesis (downstream) reactor cost";
	parameter Real fr_c_ds_rx[6](each fixed=false) "MSR components cost fraction";

	parameter FI.Money C_tbm = (1 - f_Subs) * (C_field + C_tower + C_rx + C_st + C_ds_rx) "Total bare module investment cost";
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
	parameter Integer n_labor = FI.nLabour_m_sg_msr(m_flow_msr_des) "Number of labor working at the plant";
	parameter FI.MoneyPerYear C_labor = pri_labor * n_labor "Labor annual cost in AUD";

	parameter FI.MoneyPerYear C_insur = f_insur * C_tci "Insurance and local taxes cost for each year in AUD";
	parameter FI.MoneyPerYear C_om = C_insur + (f_om * C_tci) "Operational and maintenance cost for each year in AUD";

	// System components
	// *********************
	SolarTherm.Models.Sources.Weather.WeatherSource wea(file=wea_file);

	SolarTherm.Models.CSP.CRS.HeliostatsField.SwitchedCL_2 CL(
		redeclare model OptEff=SolarTherm.Models.CSP.CRS.HeliostatsField.FileOE(
		angles=Solar_angles.ele_azi, file=opt_file),
		orient_north=wea.orient_north,
		A=A_field,
		t_con_on_delay=t_con_on_delay,
		t_con_off_delay=t_con_off_delay,
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
			pv=H2_makeup,
			t_rx_on_delay=t_rx_on_delay,
			t_rx_off_delay=t_rx_off_delay,
			ramp_order_heat=ramp_order_rx_heat,
			ramp_order_algae=ramp_order_rx_algae,
			ramp_order_CO2=ramp_order_rx_CO2,
			ramp_order_elec=ramp_order_rx_elec,
			ramp_order_sg=ramp_order_rx_sg);

	SolarTherm.Models.Storage.Tank.SimpleST ST(
			E_max=E_max,
			E_0=E_max*ini_frac) if storage;

	SolarTherm.Models.CSP.CRS.Reactors.GenericMSR MSR(
			E_sg_des = E_flow_msr_des,
			E_sg_min = E_flow_msr_min,
			cvf_methanol=cvf_methanol,
			cwc_msr=cwc_msr,
			cq_msr=cq_msr,
			cm_CO2_msr=cm_CO2_msr,
			t_msr_on_delay=t_msr_on_delay,
			t_msr_off_delay=t_msr_off_delay,
			t_msr_trans_delay=t_msr_trans_delay,
			ramp_order_sg=ramp_order_msr_sg,
			ramp_order_elec=ramp_order_msr_elec,
			ramp_order_CO2=ramp_order_msr_CO2,
			ramp_order_prod=ramp_order_msr_prod,
			trans_order_sg=trans_order_msr_sg,
			trans_order_elec=trans_order_msr_elec,
			trans_order_CO2=trans_order_msr_CO2,
			trans_order_prod=trans_order_msr_prod);

	SolarTherm.Models.Control.SyngasTankDispatch dis(
		full_lb=tnk_full_lb*E_max,
		full_ub=tnk_full_ub*E_max,
		empty_lb=tnk_empty_lb*E_max,
		empty_ub=tnk_empty_ub*E_max,
		crit_lb=tnk_crit_lb*E_max,
		crit_ub=tnk_crit_ub*E_max,
		level_start=tnk_min_start*E_max,
		disp_min=msr_disp*E_flow_msr_des,
		cr_sg=cr_sg) if storage;

	SolarTherm.Models.Sources.DataTable.ForecastTable forecast(
			file=sch_fcst_file,
			startTime=-24*3600) if storage and not const_dispatch and forecast_scheduler;

	SolarTherm.Models.Sources.Schedule.ForecastScheduler sch_fcst(
			final n_sched_states=2,
			E_flow_des=E_flow_msr_des,
			fr_min=fr_min_msr,
			E_max=E_max,
			n_night=n_night,
			dt_ramp=t_msr_on_delay
			) if storage and not const_dispatch and forecast_scheduler;

	SolarTherm.Models.Sources.Schedule.Scheduler sch_fixed(
			file = sch_fixed_file,
			ndaily = 3,
			wmap={{2,2,2,2,2,2,2}},
			mmap={1,1,1,1,1,1,1,1,1,1,1,1}
			) if storage and not const_dispatch and not forecast_scheduler;

	Modelica.Blocks.Continuous.Integrator R_req(y_start=0) "Sun heat duty to the reactor"; // [J]
	Modelica.Blocks.Continuous.Integrator m_alg_req(y_start=0) "Mass of algae required by the reactor"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_sg_prod(y_start=0) "Mass of syngas produced by the reactor"; // [kg]
	Modelica.Blocks.Continuous.Integrator E_rx_prod(y_start=0) "Energy of syngas produced by the reactor"; // [J]
	Modelica.Blocks.Continuous.Integrator m_sg_req(y_start=0) "Mass of syngas required by the MSR"; // [kg]
	Modelica.Blocks.Continuous.Integrator E_rx_req(y_start=0) "Energy of syngas required by the MSR"; // [J]
	Modelica.Blocks.Continuous.Integrator v_methanol_prod(y_start=0) "Volume of methanol produced in MSR";  // [m3]
	Modelica.Blocks.Continuous.Integrator m_w_req(y_start=0) "Mass of water required"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_H2_req(y_start=0) "Mass of H2 required from PV"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_CO2_emiss(y_start=0) "Mass of CO2 released/dumped to environment"; // [kg]
	Modelica.Blocks.Continuous.Integrator E_elec_cons(y_start=0) "Plant electricity consumption"; // [J]

	Modelica.Blocks.Continuous.Integrator R_waste(y_start=0) "Sun heat duty wasted at the reactor"; // [J]
	Modelica.Blocks.Continuous.Integrator m_alg_waste(y_start=0) "Mass of algae supply wasted at the reactor"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_sg_waste(y_start=0) "Mass of Syngas supply wasted at MSR"; // [kg]
	Modelica.Blocks.Continuous.Integrator E_sg_waste(y_start=0) "Syngas energy wasted at MSR"; // [J]
	Modelica.Blocks.Continuous.Integrator m_water_waste(y_start=0) "Mass of water supply wasted at the reactor and MSR"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_H2_pv_waste(y_start=0) "Mass of H2 supply wasted at the reactor and MSR"; // [kg]
	Modelica.Blocks.Continuous.Integrator m_CO2_waste(y_start=0) "Mass of CO2 dumped/released from the reactor and MSR when the products are rubbish"; // [kg]
	Modelica.Blocks.Continuous.Integrator E_elec_waste(y_start=0) "Plant electricity consumption wasted at the reactor and MSR"; // [J]

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
	FI.Money C_catalyst(start=0) "Catalysts cost for each year of operation in AUD";
	FI.Money C_op(start=0) "Operating costs";
	FI.Money R_spot(start=0) "Spot market revenue";

	SI.VolumeFlowRate v_flow_fuel_des(min=0) "Volumetric flow rate of fuel produced at the MSR at design";
	// Equations
	// *********************
initial equation
	(n_st, C_st) = FI.pressureVesselCost_V(V_max, f_bm_st);
	(C_ds_rx, fr_c_ds_rx) = FI.methanolReactorCost_m_sg(m_flow_msr_des);

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
		connect(ST.E_flow_out, MSR.E_sg);
		connect(ST.E_flow_in, dis.flow_in);
		connect(ST.E, dis.level);
		dis.flow_tar = sched*E_flow_msr_des;
		ST.E_flow_set = abs(dis.flow_dis);
		connect(dis.full,CL.defocus);
		connect(dis.R_tar, CL.R_dfc);
	else
		connect(RX.E_flow, MSR.E_sg);
		CL.defocus = false;
		CL.R_dfc = 0;
	end if;

	// Cumulative performance-related results:
	R_req.u = sum(RX.R);
	m_alg_req.u = RX.m_flow_algae;
	m_sg_prod.u = RX.m_flow_sg;
	E_rx_prod.u = RX.E_flow;
	m_sg_req.u = MSR.m_flow_sg_in;
	E_rx_req.u = MSR.E_sg_in;
	v_methanol_prod.u = MSR.v_flow_methanol;
	V_fuel = v_methanol_prod.y;
	m_w_req.u = RX.m_flow_water;
	m_H2_req.u = RX.m_flow_H2_pv;
	m_CO2_emiss.u = RX.m_flow_CO2 + MSR.m_flow_CO2;
	E_elec_cons.u = MSR.P_C + RX.P_pump;

	R_waste.u = RX.R_waste;
	m_alg_waste.u = RX.m_flow_algae_waste;
	m_sg_waste.u = MSR.m_flow_sg_in_waste;
	E_sg_waste.u = MSR.E_sg_in_waste;
	m_water_waste.u = RX.m_flow_water_waste;
	m_H2_pv_waste.u = RX.m_flow_H2_pv_waste;
	m_CO2_waste.u = RX.m_flow_CO2_waste + MSR.m_flow_CO2_waste;
	E_elec_waste.u = RX.P_pump_waste + MSR.P_C_waste;

	v_flow_fuel_des = MSR.v_flow_fuel_des;

	// Variable cost calculation:
	C_water = m_w_req.y * pri_water;
	C_algae = m_alg_req.y * pri_algae;
	C_H2 = m_H2_req.y * pri_H2;
	C_CO2 = m_CO2_emiss.y * pri_CO2;
	C_O2 = 0;
	C_elec = ((E_elec_cons.y)/(3.6e6)) * pri_elec;
	C_op = C_water + C_algae + C_H2 + C_CO2 - C_O2 + C_elec;

	C_catalyst = (pri_nickel * RX.m_nickel_rx/3.0) + (pri_catalyst * V_fuel/3.0);


	R_spot = V_fuel * pri_spot;

	der(dni_int) = wea.wbus.dni;
	when terminal() then
		dni_mean = dni_int / CL.tot;
	end when;
	annotation(experiment(StartTime=0.0, StopTime=31536000.0, Interval=60, Tolerance=1e-06));
end SolarMethanolSystem;
