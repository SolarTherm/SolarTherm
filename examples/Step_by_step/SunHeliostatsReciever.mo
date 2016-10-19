within SolarTherm.Examples.SolarTower.Step_by_step;
model SunHeliostatsReciever
  extends Modelica.Icons.Example;
    parameter String file = "Data/mat_Australia NT Alice Springs Airport 1996 (TMY3).mat";
//  parameter String file = "Alice_Springs_Real2000_Created20130430.motab";
//  input SI.Irradiance DNI;
//  input SI.Temp_C Tdew;

//  SI.Temperature Tamb=from_degC(Tdew);
  Models.Sources.SolarModel.Sun sun(
    lon=data.lon,
    lat=data.lat,
    t_zone=data.t_zone,
    year=data.year)
    annotation (Placement(transformation(extent={{-70,54},{-50,74}})));
  Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(
    n_h=6377,
    A_h=144.375,
    lon=data.lon,
    lat=data.lat,
    redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Constant (
         k=0.6),
    ele_min=0)
    annotation (Placement(transformation(extent={{-76,-4},{-44,30}})));
  Models.CSP.CRS.Receivers.ReceiverSimple receiver(
    ab=0.94,
    em=0.88,
    A=pi*15*18.67,
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base)
    annotation (Placement(transformation(extent={{-30,-2},{6,34}})));
  Modelica.Blocks.Sources.RealExpression DNI_input(y=data.DNI)
    annotation (Placement(transformation(extent={{-100,54},{-80,74}})));
  Modelica.Fluid.Sources.MassFlowSource_T source(
    nPorts=1,
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    m_flow=1484.76,
    T=673.15) annotation (Placement(transformation(extent={{32,-10},{12,10}})));
  Modelica.Fluid.Sources.Boundary_pT sink(
    nPorts=1,
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    p=1000000,
    T=847.15)  annotation (Placement(transformation(extent={{32,32},{12,52}})));
  Modelica.Blocks.Sources.RealExpression Tamb_input(y=data.Tdew)
    annotation (Placement(transformation(extent={{-36,40},{-16,60}})));
  Models.Sources.DataTable.DataTable data(file=file)
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
equation
  connect(sun.solar, heliostatsField.solar)
    annotation (Line(points={{-60,54},{-60,42},{-60,30}},
                                                 color={255,128,0}));
  connect(heliostatsField.heat, receiver.heat) annotation (Line(points={{-43.68,
          21.5},{-42.82,21.5},{-42.82,21.4},{-30,21.4}}, color={191,0,0}));
  connect(sun.dni, DNI_input.y) annotation (Line(points={{-70.6,63.8},{-74,63.8},
          {-74,64},{-79,64}}, color={0,0,127}));
  connect(source.ports[1], receiver.fluid_a) annotation (Line(points={{12,0},{4,
          0},{4,-0.2},{-8.4,-0.2}},    color={0,127,255}));
  connect(receiver.fluid_b, sink.ports[1]) annotation (Line(points={{-5.88,
          24.64},{2.06,24.64},{2.06,42},{12,42}},
                                             color={0,127,255}));
  connect(Tamb_input.y, receiver.Tamb)
    annotation (Line(points={{-15,50},{-12,50},{-12,30.04}},
                                                        color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{120,100}})),
    experiment(StopTime=1e+006),
    __Dymola_experimentSetupOutput);
end SunHeliostatsReciever;
