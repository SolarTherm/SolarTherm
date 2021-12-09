within examples;
model FlowPathStress
	// Importing modules
	extends Modelica.Icons.Example;
	import SI = Modelica.SIunits;
	import Modelica.SIunits.Conversions.*;
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
	// Discretisation
	parameter Integer nt = 91;
	parameter Integer N = 100 "Number of tube segments in flowpath";
	parameter SI.Height H_rec = 24.0 "Length of tubes in panel (i.e. height of the receiver)";
	parameter Integer n_tb_fp = 2 "Number of tubes per flow path";
	final parameter SI.Length dz = n_tb_fp*H_rec/N "Longitude of the pipe segment";
	// Flow
	parameter SI.Temperature T_rec_in = from_degC(290) "Receiver inlet temperature (Celsius)";
	parameter SI.ThermalResistance R_fouling = 0;
	parameter SI.MassFlowRate m_flow_tb = 3.5269595732913426 "Tube mass flow rate";
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

	Modelica.Blocks.Sources.RealExpression DNI(y = data.DNI) annotation(
	Placement(visible = false, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}})));

	// Thermo-elastic stress
	Real stress_fpath[N];

	// Surface temperature at tube crown
	Real T_crown_fpath[N];

	// Surface temperature at tube crown
	Real T_fluid_fpath[N];

	// Solar flux distribution along flowpath
	SI.HeatFlux CG[N];

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
		tableName = tableNames);
	Modelica.Blocks.Tables.CombiTable2D flux_dni1[N](
		each fileName = file_dni1, 
		each tableOnFile = true, 
		tableName = tableNames);
	Modelica.Blocks.Tables.CombiTable2D flux_dni2[N](
		each fileName = file_dni2, 
		each tableOnFile = true, 
		tableName = tableNames);
	Modelica.Blocks.Tables.CombiTable2D flux_dni3[N](
		each fileName = file_dni3, 
		each tableOnFile = true, 
		tableName = tableNames);
	
	Modelica.Blocks.Sources.RealExpression u1(y = Modelica.SIunits.Conversions.to_deg(sun.dec));
	Modelica.Blocks.Sources.RealExpression u2(y = Modelica.SIunits.Conversions.to_deg(sun.hra));
	SI.Angle ele;

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

	(T_crown_fpath, T_fluid_fpath, stress_fpath) = NASHTubeStress(coolant, tb_r_i, tb_r_o, dz, m_flow_tb, T_rec_in, data.Tdry, CG, nt, N, R_fouling, ab, em, kp, h_ext, alpha, E, nu);
	annotation(experiment(StartTime=0.0, StopTime=31536000, Interval=1800, Tolerance=1e-06));
end FlowPathStress;
