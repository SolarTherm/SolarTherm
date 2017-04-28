within Examples.Step_by_step;
model ControlSystem2
  extends Modelica.Icons.Example;
  parameter String file = "Data/mat_Australia NT Alice Springs Airport 1996 (TMY3).mat";

  SI.Energy E_el(start=0);
  SI.Energy E_sf_raw(start=1e-8);
  SI.Energy E_sf_net(start=1e-8);
  Real sf_damping= (1-(E_sf_net/E_sf_raw))*100;
  Real sf_damping_instant= (1-(max(1e-8,heliostatsField.Q_net)/max(1e-8,heliostatsField.Q_raw)))*100;

  Models.Sources.SolarModel.Sun sun(
    lon=data.lon,
    lat=data.lat,
    t_zone=data.t_zone,
    year=data.year,
    redeclare function solarPosition =
        Models.Sources.SolarFunctions.PSA_Algorithm)
    annotation (Placement(transformation(extent={{-82,60},{-62,80}})));
  Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(
    A_h=144.375,
    Q_defocus=3.24e8,
    n_h=6377,
    lon=data.lon,
    lat=data.lat,
    ele_min(displayUnit="deg") = 0.13962634015955,
    Wspd_max=15,
    use_wind=true,
    use_defocus=true,
    he_av=0.99,
    use_on=true,
    redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table (
          file=data.file))
    annotation (Placement(transformation(extent={{-88,2},{-56,36}})));
  Models.CSP.CRS.Receivers.ReceiverSimple receiver(ab = 0.94, em = 0.88, A = pi * 15 * 18.67, redeclare
      package Medium =
        Media.MoltenSalt.MoltenSalt_base)                                                                                                     annotation(Placement(transformation(extent={{-42,4},
            {-6,40}})));
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(Placement(transformation(extent={{-136,60},
            {-116,80}})));
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdew) annotation(Placement(transformation(extent={{-48,46},
            {-28,66}})));
  Models.Storage.Tank.TankPressure tankHot(
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    T_start=from_degC(574),
    L_start=30) annotation (Placement(transformation(extent={{16,40},{36,60}})));
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
  Models.Control.HotPumpControl2 controlHot(
                                           m_flow_on=682.544,
    L_on=50,
    L_off=5,
    L_df_on=95,
    L_df_off=93)
    annotation (Placement(transformation(extent={{44,68},{56,58}})));
  Models.Control.ColdPumpControl4 controlCold(
    T_ref=from_degC(574),
    m_flow_max=1400,
    y_start=1000,
    DNI_min=0,
    L_off=5) annotation (Placement(transformation(extent={{26,-2},{12,12}})));
  Models.PowerBlocks.PBregresion powerBlock
    annotation (Placement(transformation(extent={{92,2},{128,40}})));
  Modelica.Blocks.Sources.RealExpression Wspd_input(y=data.Wspd) annotation(Placement(transformation(extent={{-136,20},
            {-110,40}})));
equation
  der(E_el)=powerBlock.W_cy;
  der(E_sf_raw)=heliostatsField.Q_raw;
  der(E_sf_net)=heliostatsField.Q_net;

  connect(sun.solar, heliostatsField.solar) annotation(Line(points={{-72,60},{
          -72,36}},                                                                          color = {255, 128, 0}));
  connect(heliostatsField.heat, receiver.heat) annotation(Line(points={{-55.68,
          27.5},{-54.82,27.5},{-54.82,27.4},{-42,27.4}},                                                                               color = {191, 0, 0}));
  connect(sun.dni, DNI_input.y) annotation(Line(points={{-82.6,69.8},{-86,
          69.8},{-86,70},{-115,70}},                                                                             color = {0, 0, 127}));
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
  connect(controlHot.m_flow, pumpHot.m_flow)
    annotation (Line(points={{56.72,63},{72,63},{72,49.16}}, color={0,0,127}));
  connect(controlCold.m_flow, pumpCold.m_flow) annotation (Line(points={{11.16,5},
          {-2,5},{-2,0},{-2,-18.84}}, color={0,0,127}));
  connect(temperature.T, controlCold.T_mea) annotation (Line(points={{-10,45.82},
          {-10,45.82},{-10,22},{38,22},{38,9.2},{26.7,9.2}}, color={0,0,127}));
  connect(controlCold.L_mea, tankCold.L) annotation (Line(points={{26.56,5},{38,
          5},{38,-13.6},{43.8,-13.6}}, color={0,0,127}));
  connect(tankCold.fluid_a, powerBlock.fluid_b) annotation (Line(points={{64,
          -13},{81,-13},{81,12.64},{99.56,12.64}}, color={0,127,255}));
  connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation (Line(points={{78,44},
          {86,44},{86,42},{86,27.46},{102.08,27.46}}, color={0,127,255}));
  connect(tankHot.L,controlHot. L_mea) annotation (Line(points={{36.2,54.4},{
          38,54.4},{38,63},{43.52,63}}, color={0,0,127}));
  connect(heliostatsField.on, controlCold.sf_on) annotation (Line(points={{-72,2},
          {-72,2},{-72,-42},{32,-42},{32,-6},{32,0.8},{30,0.8},{26.7,0.8}},
                                                                color={255,0,255}));
  connect(heliostatsField.defocus,controlHot. defocus) annotation (Line(
        points={{-87.68,8.8},{-100,8.8},{-100,90},{50,90},{50,68.6}},
                                                                    color={
          255,0,255}));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation (Line(points={{
          -108.7,30},{-87.68,30},{-87.68,29.54}}, color={0,0,127}));
  annotation(Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}})), Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})), experiment(
      StopTime=3.1536e+007,
      Interval=60,
      __Dymola_Algorithm="Lsodar"),                                                                                         __Dymola_experimentSetupOutput);
end ControlSystem2;
