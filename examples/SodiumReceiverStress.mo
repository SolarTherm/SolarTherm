within examples;
model SodiumReceiverStress
	extends Modelica.Icons.Example;
	import Modelica.SIunits.Conversions.*;

	replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;
		
	Modelica.Fluid.Sources.Boundary_pT source(
		T = from_degC(290),
		nPorts = 1,
		redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {-80, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	
	Modelica.Fluid.Sources.FixedBoundary sink(
		redeclare package Medium = Medium,
		nPorts = 1) annotation(
		Placement(visible = true, transformation(origin = {76, -16}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
	
	SolarTherm.Models.Sources.DataTable.DataTable data(
		file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Daggett_Ca_TMY32.motab"), 
		lat = 34.85, 
		lon = -116.78, 
		t_zone = -8, 
		year = 2008) annotation(
		Placement(visible = true, transformation(origin = {-82, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	
	Modelica.Blocks.Sources.RealExpression Wsped(y = data.Wspd) annotation(
		Placement(visible = true, transformation(origin = {-88, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	
	Modelica.Blocks.Sources.RealExpression T_amb(y = data.Tdry) annotation(
		Placement(visible = true, transformation(origin = {-88, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	
	Modelica.Blocks.Sources.RealExpression DNI(y = data.DNI) annotation(
		Placement(visible = true, transformation(origin = {-88, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	
	SolarTherm.Models.CSP.CRS.Receivers.PipeThermoMechanical pipe annotation(
		Placement(visible = true, transformation(origin = {2, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	SolarTherm.Models.Fluid.Pumps.PumpSimple pump(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {-38, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression m_flow(y = 3.2) annotation(
		Placement(visible = true, transformation(origin = {-56, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	
equation
	connect(T_amb.y, pipe.Tamb) annotation(
	Line(points = {{-76, 20}, {-4, 20}, {-4, -12}, {-4, -12}}, color = {0, 0, 127}));
	connect(Wsped.y, pipe.v_wind) annotation(
	Line(points = {{-76, 62}, {2, 62}, {2, -12}, {2, -12}}, color = {0, 0, 127}));
	connect(DNI.y, pipe.solar_flux) annotation(
	Line(points = {{-76, 86}, {8, 86}, {8, -12}, {8, -12}}, color = {0, 0, 127}));
	connect(source.ports[1], pump.fluid_a) annotation(
	Line(points = {{-70, -16}, {-48, -16}}, color = {0, 127, 255}));
	connect(pump.fluid_b, pipe.fluid_a) annotation(
	Line(points = {{-28, -16}, {-8, -16}}, color = {0, 127, 255}));
	connect(m_flow.y, pump.m_flow) annotation(
	Line(points = {{-44, 4}, {-38, 4}, {-38, -8}}, color = {0, 0, 127}));
	connect(pipe.fluid_b, sink.ports[1]) annotation(
	Line(points = {{12, -16}, {66, -16}}, color = {0, 127, 255}));	protected
	annotation(
	__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
	experiment(StartTime = 0, StopTime = 86400, Tolerance = 1e-06, Interval = 300));
end SodiumReceiverStress;