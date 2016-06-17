within SolarTherm.Examples.SolarTower.Step_by_step;
model Sun
    parameter String file = "Data/mat_Australia NT Alice Springs Airport 1996 (TMY3).mat";
  extends Modelica.Icons.Example;
  Models.Sources.SolarModel.Sun simpleSun(
    lon=data.lon,
    lat=data.lat,
    t_zone=data.t_zone,
    year=data.year)
    annotation (Placement(transformation(extent={{-64,64},{-44,84}})));
//  Models.Sources.DataTable.DataTable data(
//    file=file,
//    use_dni_out=true,
//    use_wspd_out=false,
//    use_Tdry_out=false,
//    use_Tdew_out=false,
//    use_ghi_out=false,
//    delay={6600,6600,6600,6600,6600,6600,6600,6600})
//    annotation (Placement(transformation(extent={{-100,74},{-74,100}})));
    input SI.Irradiance DNI;
  Modelica.Blocks.Sources.RealExpression DNI_input(y=data.DNI)
    annotation (Placement(transformation(extent={{-100,66},{-80,86}})));
  Models.Sources.DataTable.DataTable data(file=file)
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
equation
  connect(DNI_input.y, simpleSun.dni) annotation (Line(points={{-79,76},{-70,76},
          {-70,73.8},{-64.6,73.8}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{120,100}})),
    experiment(StopTime=1e+006),
    __Dymola_experimentSetupOutput);
end Sun;
