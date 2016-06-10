within SolarTherm.Examples.CSP.CRS.Step_by_step;
model SunHeliostats
  extends Modelica.Icons.Example;
  parameter String file = "C:/Users/del155/Documents/Dymola/SolarTherm/SolarTherm/Data/mat_Australia NT Alice Springs Airport 1996 (TMY3).mat";
  Models.Sources.SolarModel.Sun simpleSun(
    lon=data.lon,
    lat=data.lat,
    t_zone=data.t_zone,
    year=data.year)
    annotation (Placement(transformation(extent={{-74,54},{-54,74}})));
  Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(
    n_h=6377,
    A_h=12*12,
    redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Constant (
         k=0.6),
    ele_min=0,
    lon=data.lon,
    lat=data.lat)
    annotation (Placement(transformation(extent={{-82,-8},{-46,30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
       1073.15)
    annotation (Placement(transformation(extent={{-14,14},{-26,26}})));
  Models.Sources.DataTable.DataTable data(file=file)
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Sources.RealExpression DNI_input(y=data.DNI)
    annotation (Placement(transformation(extent={{-100,54},{-80,74}})));
equation
  connect(simpleSun.solar, heliostatsField.solar) annotation (Line(points={{-64,54},
          {-64,30}},                   color={255,128,0}));
  connect(fixedTemperature.port, heliostatsField.heat) annotation (Line(
        points={{-26,20},{-26,20},{-26,20.5},{-45.64,20.5}}, color={191,0,0}));
  connect(DNI_input.y, simpleSun.dni) annotation (Line(points={{-79,64},{-74.6,
          64},{-74.6,63.8}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{120,100}})),
    experiment(StopTime=1e+006),
    __Dymola_experimentSetupOutput);
end SunHeliostats;
