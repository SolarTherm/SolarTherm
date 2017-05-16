within SolarTherm.Examples.SolarTower.Step_by_step;
model SunHeliostatsRecieverTank
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
    use_m_flow_in=true,
    T=673.15) annotation (Placement(transformation(extent={{32,-10},{12,10}})));
  Modelica.Fluid.Sources.Boundary_pT sink(
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    p=1000000,
    T=847.15,
    nPorts=1)  annotation (Placement(transformation(extent={{86,28},{66,48}})));
  Modelica.Blocks.Sources.RealExpression Tamb_input(y=data.Tdew)
    annotation (Placement(transformation(extent={{-36,40},{-16,60}})));
  Models.Storage.Tank.TankSimple  tank(
                                      redeclare package Medium =
        Media.MoltenSalt.MoltenSalt_base, medium(
                                          p =      1000000),
    L_start=70,
    T_start=847.15)
    annotation (Placement(transformation(extent={{16,34},{36,54}})));
  Models.Fluid.Pumps.PumpSimple pump(redeclare package Medium =
        Media.MoltenSalt.MoltenSalt_base)
    annotation (Placement(transformation(extent={{44,32},{56,44}})));
  Modelica.Blocks.Sources.RealExpression m_flow_input(y=1484.76)
    annotation (Placement(transformation(extent={{90,-2},{70,18}})));
  Models.Sources.DataTable.DataTable data(file=file)
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
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
  connect(Tamb_input.y, receiver.Tamb)
    annotation (Line(points={{-15,50},{-12,50},{-12,30.04}},
                                                        color={0,0,127}));
  connect(receiver.fluid_b, tank.fluid_a) annotation (Line(points={{-5.88,24.64},
          {4,24.64},{4,49},{16,49}}, color={0,127,255}));
  connect(tank.fluid_b, pump.fluid_a) annotation (Line(points={{36,37},{40,37},
          {40,37.88},{44,37.88}}, color={0,127,255}));
  connect(pump.fluid_b, sink.ports[1])
    annotation (Line(points={{56,38},{60,38},{66,38}}, color={0,127,255}));
  connect(m_flow_input.y, source.m_flow_in)
    annotation (Line(points={{69,8},{69,8},{32,8}}, color={0,0,127}));
  connect(m_flow_input.y, pump.m_flow) annotation (Line(points={{69,8},{60,8},{
          60,54},{50,54},{50,43.16}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{120,100}})),
    experiment(StopTime=1e+006),
    __Dymola_experimentSetupOutput);
end SunHeliostatsRecieverTank;
