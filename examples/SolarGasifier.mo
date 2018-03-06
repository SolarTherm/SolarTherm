model SolarGasifier
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import SolarTherm.Types.Solar_angles;

	extends Modelica.Icons.Example;

	// Input Parameters
	// *********************

	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/AUS_WA_Geraldton_Airport_944030_RMY.motab");
	parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/troughwagner_opt_eff.motab") "Optical efficiency file";

	parameter Integer ramp_order_con(min=0, max=2) = 1 "ramping filter order for the concentrator";

	parameter Integer ramp_order_rx_heat(min=0, max=2) = 1 "ramping filter order for heat supply to the reactor";
	parameter Integer ramp_order_rx_algae(min=0, max=2) = 1 "ramping filter order for algae supply to the reactor";
	parameter Integer ramp_order_rx_CO2(min=0, max=2) = 1 "ramping filter order for CO2 dump/release from the reactor";
	parameter Integer ramp_order_rx_elec(min=0, max=2) = 1 "ramping filter order for electricity supply to the reactor";
	parameter Integer ramp_order_rx_sg(min=0, max=2) = 1 "ramping filter order for syngas production from the reactor";

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

	// Info for sizing the solar field
	parameter SI.Efficiency eff_opt = 0.7449
	"Efficiency of optics at design point (max in opt_file)";
	parameter SI.Irradiance dni_des = 1000 "DNI at design point";
	parameter Real C = 1000 "Concentration ratio";
	parameter SI.Area A_rec = 50 "Reactor area";

	// Calculated Parameters
	// *********************
	parameter SI.HeatFlowRate Q_flow_des = A_rec * dni_des * C "Heat to the reactor at design point";
	parameter SI.RadiantPower R_des = Q_flow_des "Input power for reactor at design point";
	parameter SI.Area A_field = (R_des/eff_opt)/dni_des "Field area";

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

	Modelica.Blocks.Continuous.Integrator m_sg_prod(y_start=0) "Mass of syngas produced by the reactor";
	Modelica.Blocks.Continuous.Integrator E_rx_prod(y_start=0) "Energy of syngas produced by the reactor";

	// Variables
	// *********************
	Boolean clock(start=false) "Clock ticks for sampling daily energy produced by the reactor";
	discrete SI.Energy E_rx_prod_smpl(start=0,fixed=true) "Sampled energy of syngas produced by the reactor";
	discrete SI.Energy E_rx_prod_dly(start=0,fixed=true) "Daily energy of syngas produced by the reactor";

	// Equations
	// *********************
equation
	connect(wea.wbus, CL.wbus);
	connect(wea.wbus, RX.wbus);
	connect(CL.R_foc, RX.R);

	CL.track = true;
	RX.rx_on = true;
	CL.defocus = false;
	CL.R_dfc = 0;

	m_sg_prod.u = RX.m_flow_sg;
	E_rx_prod.u = RX.E_flow;

	clock = sample(0,24.0*3600);
	when clock then
		E_rx_prod_smpl = E_rx_prod.y;
		E_rx_prod_dly = E_rx_prod_smpl - pre(E_rx_prod_smpl);
	end when;
	annotation(experiment(StartTime=0.0, StopTime=31536000.0, Interval=60, Tolerance=1e-06));
end SolarGasifier;
