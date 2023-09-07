within SolarTherm.Models.Sources;
model GridInput
	parameter String pv_file "File with the reference PV farm output";
	parameter String wind_file "File with the reference Wind farm output";
	parameter Modelica.SIunits.Power P_elec_min = 25e6 "Minimum power input";
	parameter Modelica.SIunits.Power P_elec_max = 100e6 "Maximum power input";
	parameter Modelica.SIunits.Efficiency pv_fraction = 0.5 "PV fraction of renewable input at design";
	parameter Modelica.SIunits.Power P_elec_pv_ref_size = 50e6 "PV farm reference size";
	parameter Modelica.SIunits.Power P_elec_wind_ref_size = 50e6 "Wind farm reference size";
	final parameter Modelica.SIunits.Power P_elec_max_pv = pv_fraction*P_elec_max "Maximum PV capacity";
	final parameter Modelica.SIunits.Power P_elec_max_wind = (1-pv_fraction)*P_elec_max "Maximum Wind farm capacity";

	Modelica.Blocks.Sources.CombiTimeTable P_elec_ref_pv(fileName = pv_file, tableName = "Power", tableOnFile = true);
	Modelica.Blocks.Sources.CombiTimeTable P_elec_rec_wind(fileName = wind_file, tableName = "Power", tableOnFile = true);

	Modelica.Blocks.Sources.RealExpression P_elec_net_switch1(y = P_elec_net) annotation(
		Placement(visible = true, transformation(origin = {-50, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression P_elec_curtail_switch1(y = P_schedule) annotation(
		Placement(visible = true, transformation(origin = {-50, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Logical.Switch switch1 annotation(
		Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

	Modelica.Blocks.Interfaces.BooleanInput curtail annotation(
		Placement(visible = true, 
		transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealInput P_schedule annotation(
		Placement(visible = true, 
		transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {-100, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealOutput electricity annotation(
		Placement(visible = true, 
		transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {100, 2.66454e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

	Modelica.Blocks.Interfaces.BooleanOutput on_renewable annotation (
		Placement(transformation(extent={{20,-20},{-20,20}},rotation=90,origin={0,-114})));

	Modelica.SIunits.Power P_elec_net;
	Modelica.SIunits.Power P_elec_raw;
	Modelica.SIunits.Power P_elec_raw_pv;
	Modelica.SIunits.Power P_elec_raw_wind;

initial equation   
	on_renewable = P_elec_raw > P_elec_min;

equation
	P_elec_raw_pv = P_elec_max_pv / P_elec_pv_ref_size * P_elec_ref_pv.y[1];
	P_elec_raw_wind = P_elec_max_wind / P_elec_wind_ref_size * P_elec_rec_wind.y[1];
	
	P_elec_raw = min(P_elec_raw_pv + P_elec_raw_wind, P_elec_max);

	on_renewable = P_elec_raw > P_elec_min;
	
	P_elec_net = if on_renewable then P_elec_raw else 0.0;

  connect(P_elec_curtail_switch1.y, switch1.u1) annotation(
    Line(points = {{-39, -30}, {-25.5, -30}, {-25.5, -8}, {-12, -8}}, color = {0, 0, 127}));
  connect(curtail, switch1.u2) annotation(
    Line(points = {{-100, 0}, {-12, 0}}, color = {255, 0, 255}));
  connect(P_elec_net_switch1.y, switch1.u3) annotation(
    Line(points = {{-38, 30}, {-26, 30}, {-26, 8}, {-12, 8}}, color = {0, 0, 127}));
  connect(switch1.y, electricity) annotation(
    Line(points = {{12, 0}, {100, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Line(points = {{40, 20}, {-40, -20}, {-40, 20}, {40, -20}, {40, 20}}), Line(origin = {0, -100}, points = {{-80, 0}, {80, 0}}), Line(origin = {0, -60.17}, points = {{-80, -40}, {-40, 40}, {40, 40}, {80, -40}}), Line(points = {{-40, -20}, {60, -60}, {-60, -60}, {40, -20}}), Line(points = {{-60, -60}, {80, -100}}), Line(points = {{60, -60}, {-80, -100}}), Line(origin = {0.17, 39.78}, points = {{-40.1708, -19.7764}, {39.8292, -19.7764}, {39.8292, 20.2236}, {-40.1708, -19.7764}, {-40.1708, 20.2236}, {39.8292, -19.7764}}), Line(origin = {0, 80}, points = {{-40, -20}, {0, 20}, {40, -20}, {-40, -20}}), Line(origin = {-70, 40}, points = {{30, -20}, {-30, 0}, {30, 20}}), Line(origin = {70, 40}, points = {{-30, 20}, {30, 0}, {-30, -20}}), Text(origin = {-10, 254}, lineColor = {0, 0, 255}, extent = {{-149, -114}, {151, -154}}, textString = "%name")}));
end GridInput;