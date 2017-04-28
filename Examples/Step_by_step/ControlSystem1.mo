within Examples.Step_by_step;
model ControlSystem1
  extends Modelica.Icons.Example;
  parameter String file = "Data/mat_Australia NT Alice Springs Airport 1996 (TMY3).mat";

  Models.Sources.SolarModel.Sun sun(
    lon=data.lon,
    lat=data.lat,
    t_zone=data.t_zone,
    year=data.year,
    redeclare function solarPosition =
        Models.Sources.SolarFunctions.PSA_Algorithm)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(
    A_h=144.375,
    n_h=5150,
    redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Constant (
         k=0.9*0.6),
    use_defocus=false,
    ele_min=from_deg(8),
    lon=data.lon,
    lat=data.lat,
    use_on=true)
    annotation (Placement(transformation(extent={{-86,2},{-54,36}})));
  Models.CSP.CRS.Receivers.ReceiverSimple receiver(ab = 0.94, em = 0.88, A = pi * 15 * 18.67, redeclare
      package Medium =
        Media.MoltenSalt.MoltenSalt_base)                                                                                                     annotation(Placement(transformation(extent={{-42,4},
            {-6,40}})));
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(Placement(transformation(extent={{-116,60},
            {-96,80}})));
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdew) annotation(Placement(transformation(extent={{-48,46},
            {-28,66}})));
  Models.Storage.Tank.TankPressure tankHot(
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    L_start=30,
    T_start=from_degC(574))
                annotation (Placement(transformation(extent={{16,40},{36,60}})));
  Models.Fluid.Pumps.PumpSimple pumpHot(redeclare package Medium =
        Media.MoltenSalt.MoltenSalt_base)                                                            annotation(Placement(transformation(extent={{66,38},
            {78,50}})));
  Models.Storage.Tank.TankPressure tankCold(
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    T_start=from_degC(290),
    L_start=70)
    annotation (Placement(transformation(extent={{64,-28},{44,-8}})));
  Models.Fluid.Pumps.PumpSimple pumpCold(redeclare package Medium =
        Media.MoltenSalt.MoltenSalt_base)                                                             annotation(Placement(transformation(extent={{4,-30},
            {-8,-18}})));
  Models.Sources.DataTable.DataTable data(file = file) annotation(Placement(transformation(extent={{-126,
            100},{-96,128}})));
  Models.Fluid.Sensors.Temperature          temperature(redeclare package
      Medium = Media.MoltenSalt.MoltenSalt_base)                                                                            annotation(Placement(transformation(extent={{-16,64},
            {-4,46}})));
  Modelica.Blocks.Sources.RealExpression Pres_input(y=data.Pres)
    annotation (Placement(transformation(extent={{-24,60},{-4,80}})));
  Models.Control.HotPumpControl hotControl(m_flow_on=685, L_on=40)
    annotation (Placement(transformation(extent={{44,58},{56,68}})));
  Models.Control.ColdPumpControl4 coldPumpControl(
                                                 T_ref=from_degC(574),
      m_flow_max=1400,
    L_off=2)
    annotation (Placement(transformation(extent={{26,-2},{12,12}})));
  Models.PowerBlocks.PBregresion powerBlock
    annotation (Placement(transformation(extent={{92,2},{128,40}})));
equation
  connect(sun.solar, heliostatsField.solar) annotation(Line(points={{-70,60},
          {-70,36}},                                                                         color = {255, 128, 0}));
  connect(heliostatsField.heat, receiver.heat) annotation(Line(points={{-53.68,
          27.5},{-54.82,27.5},{-54.82,27.4},{-42,27.4}},                                                                               color = {191, 0, 0}));
  connect(sun.dni, DNI_input.y) annotation(Line(points={{-80.6,69.8},{-86,
          69.8},{-86,70},{-95,70}},                                                                              color = {0, 0, 127}));
  connect(Tamb_input.y, receiver.Tamb) annotation(Line(points={{-27,56},{-24,56},
          {-24,36.04}},                                                                               color = {0, 0, 127}));
  connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(Line(points={{36,43},{42,
          43},{42,43.88},{66,43.88}},                                                                             color = {0, 127, 255}));
  connect(receiver.fluid_a, pumpCold.fluid_b) annotation(Line(points={{-20.4,
          5.8},{-14.2,5.8},{-14.2,-24},{-8,-24}},                                                                            color = {0, 127, 255}));
  connect(pumpCold.fluid_a, tankCold.fluid_b) annotation(Line(points={{4,-24.12},
          {10,-24.12},{10,-25},{44,-25}},                                                                                 color = {0, 127, 255}));
  connect(receiver.fluid_b, temperature.fluid_a) annotation (Line(points={{-17.88,
          30.64},{-17.88,42},{-18,42},{-18,54},{-16,54},{-16,55}},
                                                              color={0,127,255}));
  connect(temperature.fluid_b, tankHot.fluid_a)
    annotation (Line(points={{-4,55},{16,55}},            color={0,127,255}));
  connect(Pres_input.y, tankHot.p_top)
    annotation (Line(points={{-3,70},{25.9,70},{25.9,59.9}},color={0,0,127}));
  connect(Pres_input.y, tankCold.p_top) annotation (Line(points={{-3,70},{0,70},
          {0,32},{54.1,32},{54.1,-8.1}},    color={0,0,127}));
  connect(tankHot.L, hotControl.L_mea) annotation (Line(points={{36.2,54.4},{
          36.2,63.2},{43.52,63.2},{43.52,63}},
                                        color={0,0,127}));
  connect(hotControl.m_flow, pumpHot.m_flow)
    annotation (Line(points={{56.72,63},{72,63},{72,49.16}}, color={0,0,127}));
  connect(coldPumpControl.m_flow, pumpCold.m_flow) annotation (Line(points={{11.16,5},
          {-2,5},{-2,0},{-2,-18.84}},                 color={0,0,127}));
  connect(temperature.T, coldPumpControl.T_mea) annotation (Line(points={{-10,
          45.82},{-10,45.82},{-10,22},{38,22},{38,9.2},{26.7,9.2}},color={0,0,
          127}));
  connect(coldPumpControl.L_mea, tankCold.L) annotation (Line(points={{26.56,5},
          {38,5},{38,-13.6},{43.8,-13.6}},  color={0,0,127}));
  connect(tankCold.fluid_a, powerBlock.fluid_b) annotation (Line(points={{64,
          -13},{81,-13},{81,12.64},{99.56,12.64}}, color={0,127,255}));
  connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation (Line(points={{78,44},
          {86,44},{86,42},{86,27.46},{102.08,27.46}}, color={0,127,255}));
  connect(heliostatsField.on, coldPumpControl.sf_on) annotation (Line(points=
          {{-70,2},{-70,2},{-70,-38},{26,-38},{34,-38},{34,0.8},{26.7,0.8}},
        color={255,0,255}));
  annotation(Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}})), Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})), experiment(
      StopTime=3e+007,
      __Dymola_NumberOfIntervals=10000,
      __Dymola_Algorithm="Lsodar"),                                                                                                    __Dymola_experimentSetupOutput);
end ControlSystem1;
