model SolarGasifier
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;

	extends Modelica.Icons.Example;

	// Input Parameters
	// *********************

	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Mildura_Real2010_Created20130430.motab");

	// Polynomilas coeffs for SCWG+SMR
	parameter Real cf_SCWG[:] = {0.861548846435547, 0.040890337613260, -0.016377240668398, 0.006300210850991, -0.002949360411857, 0.001198974859965, -2.674495240684157e-05, 2.803482204959359e-04, -2.451620638315131e-04} "SCWG efficiency coefficients";
	parameter Real cf_SMR[:] = {0.768282037316067, 0.093488773366821, -0.037724819862177, 0.015670722458670, -0.006367262777059, 0.001640716559506, -6.287807751796056e-04, 9.317070447512179e-04, -3.842549181678559e-04} "SMR efficiency coefficients";
	parameter Real cf_RX[:] = {0.692020111787560, 0.020351037993914, -0.009106939175471, 0.004151066255149, -0.001838896518136, 3.664631622414798e-04, -1.408078265714309e-04, 4.547504047117000e-04, -2.148557896485679e-04} "Reactor efficiency coefficients";
	parameter Real cfII_RX[:] = {0.428893751687588, 0.023224745709671, -0.009960353967087, 0.003960847783229, -0.001309541111636, 3.991708829014157e-04, -4.178423876727377e-04, 3.509612038492967e-04, -9.680693142572159e-05} "Reactor exergy efficiency coefficients";
	parameter Real cm_algae[:] = {-0.336311659959542, 0.058965230256690, -6.029406419946405e-06, 1.174050185963997e-07, -7.655692283089016e-10} "Algae mass flow rate coefficients";
	parameter Real cn_H2_RX[:] = {-0.021458552473695, 0.003761949335154, -4.664958360383574e-07, 9.172954716881305e-09, -6.100663753610024e-11} "Molar flow rate coefficients for H2";
	parameter Real cn_CH4[:] = {-9.028017779162898e-05, 1.582732045409562e-05, -1.948231489377354e-09, 3.832698601631692e-11, -2.549796560386340e-13} "Molar flow rate coefficients for CH4";
	parameter Real cn_CO[:] = {-0.014522345113851, 0.002545957711618, -3.144660488641577e-07, 6.186989045992461e-09, -4.116731422254504e-11} "Molar flow rate coefficients for CO";
	parameter Real cwp_Rx[:] = {3.173924673592048e02, 1.513157852003044e02, -0.182585159567672, -1.485890800446029, 1.070967705285818, 2.496661324962723, -1.688960557651844, -1.120193917395694, 0.748181209809828} "Pump power coefficients in reactor";
	parameter Real cr_sg[:] = {5.707675744917130, 0.495934873026427, 2.103479682521452e-05, -2.530020300388292e-07, 9.854806702096966e-10} "Radiation power coefficients";

	// Info for sizing the solar field
	parameter SI.Efficiency eff_opt = 1
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
		redeclare model OptEff=SolarTherm.Models.CSP.CRS.HeliostatsField.IdealIncOE(alt_fixed=45),
		A=A_field
		);

	SolarTherm.Models.CSP.CRS.Reactors.GenericRX RX(
			cf_SCWG=cf_SCWG,
			cf_SMR=cf_SMR,
			cf_RX=cf_RX,
			cfII_RX=cfII_RX,
			cm_algae=cm_algae,
			cn_H2_RX=cn_H2_RX,
			cn_CH4=cn_CH4,
			cn_CO=cn_CO,
			cwp_Rx=cwp_Rx);

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

end SolarGasifier;
