within examples;
model FlowPathStress
	// Importing modules
	extends Modelica.Icons.Example;
	import SI = Modelica.SIunits;
	import Modelica.SIunits.Conversions.*;
	import Modelica.Constants.pi;
	import SolarTherm.Utilities.NASHTubeStress;
	import SolarTherm.Utilities.FluxInterpolation;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	
	// Parameters
	parameter Integer coolant = 2 "Heat transfer fluid (i.e. 1: Nitrate salt, 2: Liquid sodium)";
	parameter String fileName = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flow_paths.csv");
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Daggett_Ca_TMY32.motab");
	// Geometry
	parameter SI.Radius tb_r_i = 60.33/2000 "Tube inner radius";
	parameter SI.Radius tb_r_o = 57.93/2000 "Tube outer radius";
	final parameter SI.Diameter tb_d_o = 2*tb_r_o "Tube outer diameter";
	parameter SI.Height H_rec = 24.0 "Length of tubes in panel (i.e. height of the receiver)";
	parameter SI.Diameter D_rec = 16.0 "Diameter of receiver";
	final parameter SI.Radius R_rec = D_rec/2 "Radius of receiver";
	parameter Integer n_pa = 16 "Number of panels";
	parameter SI.Length gap_tb = 1/1000 "Gap between tubes in a panel";
	// Discretisation
	parameter Integer nt = 91;
	parameter Integer N = 100 "Number of tube segments in flowpath";
	parameter Integer n_tb_fp = 2 "Number of tubes per flow path";
	final parameter SI.Length dz = n_tb_fp*H_rec/N "Longitude of the pipe segment";
	final parameter Integer n_tubes_pa = integer(R_rec*sin(2*pi/n_pa)/(tb_d_o + gap_tb)) "Number of tubes per panel";
	final parameter Integer n_tubes = integer(n_tubes_pa*n_pa) "Longitude of the pipe segment";
	// Flow
	parameter SI.Temperature T_rec_in = from_degC(290) "Receiver inlet temperature (Celsius)";
	parameter SI.ThermalResistance R_fouling = 0;
	SI.MassFlowRate m_flow_tb "Tube mass flow rate";

	// Coating
	parameter SI.Efficiency ab = 0.94 "Coating absorptance";
	parameter SI.Efficiency em = 0.88 "Coating emmisivity";
	// Metal properties
	parameter SI.ThermalConductivity kp = 21 "Thermal conductivity of pipe metal";
	parameter SI.LinearExpansionCoefficient alpha = 18.5e-6 "Linear expansion coefficient of pipe metal";
	parameter SI.Stress E = 165e9 "Young's modulus of elasticity of pipe metal";
	parameter Real nu = 0.31 "Coefficient of Poisson for pipe metal";
	parameter SI.CoefficientOfHeatTransfer h_ext = 30 "Heat transfer coefficiente due to external convection";

	// Models
	SolarTherm.Models.Sources.DataTable.DataTable data(
		file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Daggett_Ca_TMY32.motab"), 
		lat = 34.85, 
		lon = -116.78, 
		t_zone = -8, 
		year = 2008) annotation(
		Placement(visible = false, transformation(origin = {-82, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	SolarTherm.Models.Sources.SolarModel.Sun sun(
		lon = -116.78,
		lat = 34.85,
		t_zone = -8,
		year = 1996)
	annotation(Placement(visible = false, transformation(origin = {-20, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression DNI(y = dni_mflow_table.y[2]) annotation(
	Placement(visible = false, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}})));

	SI.Stress stress_fpath[N] "Thermo-elastic stress";
	SI.Temperature T_crown_fpath[N] "Surface temperature at tube crown";
	SI.Temperature T_fluid_fpath[N] "Fluid temperature";
	SI.HeatFlux CG[N] "Solar flux distribution along flowpath";
	SI.HeatFlux qcoefs[N,8] "Coefficients for net flux";

	// Flux files
	parameter String tableNames[N] = {"flux_" + String(i) for i in 1:N};
	parameter String file_dni0 = 
		Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_sodium_FP1_DNIr0.motab");
	parameter String file_dni1 = 
		Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_sodium_FP1_DNIr1.motab");
	parameter String file_dni2 = 
		Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_sodium_FP1_DNIr2.motab");
	parameter String file_dni3 = 
		Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_sodium_FP1_DNIr3.motab");
	
	Modelica.Blocks.Tables.CombiTable2D flux_dni0[N](
		each fileName = file_dni0, 
		each tableOnFile = true, 
		each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
		tableName = tableNames);
	Modelica.Blocks.Tables.CombiTable2D flux_dni1[N](
		each fileName = file_dni1, 
		each tableOnFile = true, 
		each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
		tableName = tableNames);
	Modelica.Blocks.Tables.CombiTable2D flux_dni2[N](
		each fileName = file_dni2, 
		each tableOnFile = true, 
		each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
		tableName = tableNames);
	Modelica.Blocks.Tables.CombiTable2D flux_dni3[N](
		each fileName = file_dni3, 
		each tableOnFile = true, 
		each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
		tableName = tableNames);
	
	Modelica.Blocks.Sources.RealExpression u1(y = Modelica.SIunits.Conversions.to_deg(sun.dec));
	Modelica.Blocks.Sources.RealExpression u2(y = Modelica.SIunits.Conversions.to_deg(sun.hra));
	SI.Angle ele;
	parameter String dni_mflow_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/dni_mflow.motab");
	Modelica.Blocks.Sources.CombiTimeTable dni_mflow_table(
		columns = 2:3,
		fileName = dni_mflow_file,
		smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
		tableName = "data",
		tableOnFile=true);


equation
	ele = SolarTherm.Models.Sources.SolarFunctions.elevationAngle(sun.dec,sun.hra,sun.lat);
	for i in 1:N loop
		connect(u1.y, flux_dni0[i].u1);
		connect(u2.y, flux_dni0[i].u2);
		connect(u1.y, flux_dni1[i].u1);
		connect(u2.y, flux_dni1[i].u2);
		connect(u1.y, flux_dni2[i].u1);
		connect(u2.y, flux_dni2[i].u2);
		connect(u1.y, flux_dni3[i].u1);
		connect(u2.y, flux_dni3[i].u2);
		CG[i] = max(0, FluxInterpolation(flux_dni3[i].y*1e3, flux_dni2[i].y*1e3, flux_dni1[i].y*1e3, flux_dni0[i].y*1e3, ele, sun.dni));
	end for;

	connect(DNI.y, sun.dni);
	m_flow_tb = n_tb_fp*dni_mflow_table.y[1]/n_tubes;

	(T_crown_fpath, T_fluid_fpath, stress_fpath, qcoefs) = NASHTubeStress(coolant, tb_r_i, tb_r_o, dz, m_flow_tb, T_rec_in, data.Tdry, CG, nt, N, R_fouling, ab, em, kp, h_ext, alpha, E, nu);
	annotation(experiment(StartTime=0.0, StopTime=86400, Interval=1800, Tolerance=1e-06));
end FlowPathStress;
