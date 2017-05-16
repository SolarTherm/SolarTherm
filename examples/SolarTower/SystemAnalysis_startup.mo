within SolarTherm.Examples.SolarTower;
model SystemAnalysis_startup
  extends Modelica.Icons.Example;
  parameter String file = "Data/mat_SAM_results.mat";

  Models.Sources.SolarModel.Sun       sun(
    lon=data.lon,
    lat=data.lat,
    t_zone=data.t_zone,
    year=data.year,
    redeclare function solarPosition =
        Models.Sources.SolarFunctions.PSA_Algorithm)
                                          annotation(Placement(transformation(extent={{-82,60},
            {-62,80}})));
  Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(
    n_h=6377,
    lon=data.lon,
    lat=data.lat,
    ele_min(displayUnit="deg") = 0.13962634015955,
    Wspd_max=15,
    use_wind=true,
    he_av=0.99,
    use_on=true,
    use_defocus=true,
    A_h=144.375,
    Q_min=165000000,
    Q_defocus=330000000,
    redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table (
          file=file))
    annotation (Placement(transformation(extent={{-88,2},{-56,36}})));

  Models.CSP.CRS.Receivers.ReceiverSimple3 receiver(          em = 0.88,
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    H_rcv=18.67,
    D_rcv=15,
    N_pa=20,
    t_tb=1.25e-3,
    D_tb=40e-3,
    ab=0.94)                                                                                                                                  annotation(Placement(transformation(extent={{-46,4},
            {-10,40}})));
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(Placement(transformation(extent={{-126,60},
            {-106,80}})));
  Modelica.Blocks.Sources.RealExpression Tamb_input(y=data.Tdry)   annotation(Placement(transformation(extent={{140,70},
            {120,90}})));
  Models.Storage.Tank.Tank tankHot(
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    T_start=from_degC(574),
    L_start=30,
    alpha=3,
    use_p_top=true,
    enable_losses=true,
    use_L=true,
    T_set=from_degC(500))
    annotation (Placement(transformation(extent={{16,40},{36,60}})));
  Models.Fluid.Pumps.PumpSimple pumpHot(redeclare package Medium =
        Media.MoltenSalt.MoltenSalt_base)                                                            annotation(Placement(transformation(extent={{66,38},
            {78,50}})));
  Models.Storage.Tank.Tank tankCold(
    redeclare package Medium = Media.MoltenSalt.MoltenSalt_base,
    T_start=from_degC(290),
    L_start=70,
    alpha=3,
    use_p_top=true,
    enable_losses=true,
    use_L=true,
    T_set=from_degC(280))
    annotation (Placement(transformation(extent={{64,-28},{44,-8}})));
  Models.Fluid.Pumps.PumpSimple pumpCold(redeclare package Medium =
        Media.MoltenSalt.MoltenSalt_base, k_loss=0.15e3)                                              annotation(Placement(transformation(extent={{10,-30},
            {-2,-18}})));
  Models.Sources.DataTable.DataTable data(file = file, t_zone=9.5)
                                                       annotation(Placement(
        transformation(extent={{-128,-28},{-98,0}})));
  Models.Fluid.Sensors.Temperature          temperature(redeclare package
      Medium = Media.MoltenSalt.MoltenSalt_base)                                                                            annotation(Placement(transformation(extent={{-14,60},
            {-4,50}})));
  Modelica.Blocks.Sources.RealExpression Pres_input(y=data.Pres)
    annotation (Placement(transformation(extent={{76,10},{56,30}})));
  Models.Control.HotControl controlHot(
    L_off=5,
    L_df_on=95,
    L_df_off=93,
    m_flow_on=682.544,
    L_on=20) annotation (Placement(transformation(extent={{48,68},{60,58}})));
  Models.Control.ColdControl controlCold(
    T_ref=from_degC(574),
    m_flow_max=1400,
    y_start=1000,
    L_off=5) annotation (Placement(transformation(extent={{24,-10},{10,4}})));
  Models.PowerBlocks.PowerBlockModel
                                  powerBlock(
    enable_losses=true,
    redeclare model Cycle = Models.PowerBlocks.Correlation.Rankine,
    nu_min=0.6,
    p_bo=10000000,
    T_des=316.15)
    annotation (Placement(transformation(extent={{86,4},{122,42}})));
  Modelica.Blocks.Sources.RealExpression Wspd_input(y=data.Wspd) annotation(Placement(transformation(extent={{-130,20},
            {-104,40}})));
  Models.Analysis.Market market(
    W_base=0.0055*111e6,
    external_parasities=true,
    redeclare model Price = Models.Analysis.EnergyPrice.Constant)
    annotation (Placement(transformation(extent={{128,12},{148,32}})));

  Modelica.Blocks.Sources.RealExpression parasities_input(y=heliostatsField.W_loss
         + pumpHot.W_loss + pumpCold.W_loss + tankHot.W_loss + tankCold.W_loss)
    annotation (Placement(transformation(
        extent={{-13,-10},{13,10}},
        rotation=-90,
        origin={139,56})));

equation

  connect(sun.solar, heliostatsField.solar) annotation(Line(points={{-72,60},{
          -72,36}},                                                                          color = {255, 128, 0}));
  connect(heliostatsField.heat, receiver.heat) annotation(Line(points={{-55.68,
          27.5},{-54.82,27.5},{-54.82,27.4},{-46,27.4}},                                                                               color = {191, 0, 0}));
  connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(Line(points={{36,43},{36,
          44},{36,43.88},{66,43.88}},                                                                             color = {0, 127, 255}));
  connect(receiver.fluid_a, pumpCold.fluid_b) annotation(Line(points={{-24.4,
          5.8},{-14.2,5.8},{-14.2,-24},{-2,-24}},                                                                            color = {0, 127, 255}));
  connect(pumpCold.fluid_a, tankCold.fluid_b) annotation(Line(points={{10,
          -24.12},{10,-24.12},{10,-25},{44,-25}},                                                                         color = {0, 127, 255}));
  connect(receiver.fluid_b, temperature.fluid_a) annotation (Line(points={{-21.88,
          30.64},{-21.88,30},{-20,30},{-16,30},{-16,55},{-14,55}},
                                                              color={0,127,255}));
  connect(controlHot.m_flow, pumpHot.m_flow)
    annotation (Line(points={{60.72,63},{72,63},{72,49.16}}, color={0,0,127}));
  connect(controlCold.m_flow, pumpCold.m_flow) annotation (Line(points={{9.16,-3},
          {4,-3},{4,-18.84}},         color={0,0,127}));
  connect(temperature.T, controlCold.T_mea) annotation (Line(points={{-9,49.9},
          {-10,49.9},{-10,24},{38,24},{38,1.2},{24.7,1.2}},  color={0,0,127}));
  connect(controlCold.L_mea, tankCold.L) annotation (Line(points={{24.56,-3},{
          38,-3},{38,-13.6},{43.8,-13.6}},
                                       color={0,0,127}));
  connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation (Line(points={{78,44},
          {86,44},{86,29.46},{96.08,29.46}},          color={0,127,255}));
  connect(tankHot.L,controlHot. L_mea) annotation (Line(points={{36.2,54.4},{40,
          54.4},{40,63},{47.52,63}},    color={0,0,127}));
  connect(heliostatsField.on, controlCold.sf_on) annotation (Line(points={{-72,2},
          {-72,2},{-72,-36},{32,-36},{32,-6},{24.7,-6},{24.7,-7.2}},
                                                                color={255,0,255}));
  connect(DNI_input.y, sun.dni) annotation (Line(
      points={{-105,70},{-102,70},{-102,69.8},{-82.6,69.8}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation (Line(
      points={{-102.7,30},{-100,30},{-100,29.54},{-87.68,29.54}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(Pres_input.y, tankCold.p_top) annotation (Line(
      points={{55,20},{50,20},{49.5,20},{49.5,-8.3}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(Pres_input.y, tankHot.p_top) annotation (Line(
      points={{55,20},{46,20},{46,28},{8,28},{8,76},{30.5,76},{30.5,59.7}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(Tamb_input.y, powerBlock.T_amb) annotation (Line(
      points={{119,80},{104,80},{104,34.4}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(Tamb_input.y, tankHot.T_amb) annotation (Line(
      points={{119,80},{68,80},{21.9,80},{21.9,59.7}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(receiver.Tamb, tankHot.T_amb) annotation (Line(
      points={{-28,36.04},{-28,80},{21.9,80},{21.9,59.7}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(tankCold.T_amb, powerBlock.T_amb) annotation (Line(
      points={{58.1,-8.3},{58.1,-4},{124,-4},{124,46},{124,48},{104,48},{104,
          34.4}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(powerBlock.W_cy, market.W_el) annotation (Line(points={{113.18,22.05},
          {121.59,22.05},{121.59,21.8},{128,21.8}}, color={0,0,127}));
  connect(powerBlock.fluid_b, tankCold.fluid_a) annotation (Line(points={{93.56,
          14.64},{78,14.64},{78,-13},{64,-13}}, color={0,127,255}));
  connect(temperature.fluid_b, tankHot.fluid_a)
    annotation (Line(points={{-4,55},{-4,55},{16,55}}, color={0,127,255}));
  connect(parasities_input.y, market.parasities) annotation (Line(
      points={{139,41.7},{138,41.7},{138,31},{137.8,31}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(controlHot.defocus, heliostatsField.defocus) annotation (Line(points=
          {{54,68.6},{54,68.6},{54,86},{-98,86},{-98,8},{-87.68,8},{-87.68,8.8}},
        color={255,0,255}));
  annotation(Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}),
        graphics={
        Text(
          extent={{4,92},{40,90}},
          lineColor={217,67,180},
          fontSize=9,
          textString="defocus strategy"),
        Text(
          extent={{-50,-40},{-14,-40}},
          lineColor={217,67,180},
          fontSize=9,
          textString="on/off strategy"),
        Text(
          extent={{-52,8},{-4,-12}},
          lineColor={0,0,0},
          fontSize=10,
          textString="Receiver"),
        Text(
          extent={{-110,4},{-62,-16}},
          lineColor={0,0,0},
          fontSize=10,
          textString="Heliostats
Field"),Text(
          extent={{-80,86},{-32,66}},
          lineColor={0,0,0},
          fontSize=10,
          textString="Sun"),
        Text(
          extent={{2,44},{50,24}},
          lineColor={0,0,0},
          fontSize=10,
          textString="Hot Tank"),
        Text(
          extent={{30,-24},{78,-44}},
          lineColor={0,0,0},
          fontSize=10,
          textString="Cold Tank"),
        Text(
          extent={{80,12},{128,-8}},
          lineColor={0,0,0},
          fontSize=10,
          textString="Power Block"),
        Text(
          extent={{116,16},{164,-4}},
          lineColor={0,0,0},
          fontSize=10,
          textString="Market"),
        Text(
          extent={{-6,20},{42,0}},
          lineColor={0,0,0},
          fontSize=8,
          textString="Receiver
Control"),
        Text(
          extent={{30,62},{78,42}},
          lineColor={0,0,0},
          fontSize=8,
          textString="Power Block
Control"),
        Text(
          extent={{-136,-22},{-88,-42}},
          lineColor={0,0,0},
          fontSize=10,
          textString="Data Source")}),                                       Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})), experiment(
      StopTime=3.1536e+007,
      Interval=60,
      __Dymola_Algorithm="Lsodar"),                                                                                         __Dymola_experimentSetupOutput);
end SystemAnalysis_startup;
