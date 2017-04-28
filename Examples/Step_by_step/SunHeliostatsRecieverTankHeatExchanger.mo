within Examples.Step_by_step;
model SunHeliostatsRecieverTankHeatExchanger
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
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=2000,
    T=673.15) annotation (Placement(transformation(extent={{110,2},{90,22}})));
  Modelica.Fluid.Sources.Boundary_pT sink(
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    nPorts=1,
    p=1000000,
    T=847.15)  annotation (Placement(transformation(extent={{110,48},{90,68}})));
  Modelica.Blocks.Sources.RealExpression Tamb_input(y=data.Tdew)
    annotation (Placement(transformation(extent={{-36,40},{-16,60}})));
  Models.Storage.Tank.TankSimple tankHot(
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    medium(
    p =      1000000),
    T_start=from_degC(574),
    L_start=70)       annotation (Placement(transformation(extent={{16,34},{36,54}})));
  Models.Fluid.Pumps.PumpSimple pump(redeclare package Medium =
        Media.MoltenSalt.MoltenSalt_base)
    annotation (Placement(transformation(extent={{44,44},{56,32}})));
  Modelica.Blocks.Sources.RealExpression m_flow_input(y=1484.76)
    annotation (Placement(transformation(extent={{72,10},{52,30}})));
  Models.Fluid.HeatExchangers.SHE sHE(
    redeclare package MA = Media.MoltenSalt.MoltenSalt_base,
    redeclare package MB = Media.MoltenSalt.MoltenSalt_base,
    A=50) annotation (Placement(transformation(extent={{62,20},{86,50}})));
  Models.Storage.Tank.TankSimple tankCold(
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    T_start=from_degC(290),
    medium(
    p =      1000000),
    L_start=70)       annotation (Placement(transformation(extent={{48,-12},{28,8}})));
  Models.Fluid.Pumps.PumpSimple pump1(redeclare package Medium =
        Media.MoltenSalt.MoltenSalt_base)
    annotation (Placement(transformation(extent={{16,-6},{4,6}})));
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
  connect(Tamb_input.y, receiver.Tamb)
    annotation (Line(points={{-15,50},{-12,50},{-12,30.04}},
                                                        color={0,0,127}));
  connect(receiver.fluid_b, tankHot.fluid_a) annotation (Line(points={{-5.88,
          24.64},{4,24.64},{4,49},{16,49}}, color={0,127,255}));
  connect(tankHot.fluid_b, pump.fluid_a) annotation (Line(points={{36,37},{40,
          37},{40,38.12},{44,38.12}}, color={0,127,255}));
  connect(sHE.port_a_in, pump.fluid_b) annotation (Line(points={{66.44,38.75},{
          66.44,38},{56,38}}, color={0,127,255}));
  connect(receiver.fluid_a, pump1.fluid_b) annotation (Line(points={{-8.4,-0.2},
          {-2.2,-0.2},{-2.2,0},{4,0}}, color={0,127,255}));
  connect(pump1.fluid_a, tankCold.fluid_b) annotation (Line(points={{16,-0.12},
          {22,-0.12},{22,-9},{28,-9}}, color={0,127,255}));
  connect(tankCold.fluid_a, sHE.port_a_out) annotation (Line(points={{48,3},{80,
          3},{80,6},{80,18},{81.56,18},{81.56,34.25}}, color={0,127,255}));
  connect(sink.ports[1], sHE.port_b_out) annotation (Line(points={{90,58},{76,
          58},{70.52,58},{70.52,41.75}}, color={0,127,255}));
  connect(source.ports[1], sHE.port_b_in) annotation (Line(points={{90,12},{
          77.24,12},{77.24,30.95}}, color={0,127,255}));
  connect(pump.m_flow, m_flow_input.y) annotation (Line(points={{50,32.84},{50,
          32.84},{50,20},{51,20}}, color={0,0,127}));
  connect(m_flow_input.y, pump1.m_flow)
    annotation (Line(points={{51,20},{10,20},{10,5.16}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{120,100}})),
    experiment(StopTime=1e+006),
    __Dymola_experimentSetupOutput);
end SunHeliostatsRecieverTankHeatExchanger;
