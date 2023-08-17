within examples;

model WindPVsaltTESsystem
  extends Modelica.Icons.Example;
  import Modelica.SIunits.Conversions.*;
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;
  parameter String elec_input = "/home/arfontalvo/solartherm-master/examples/pv_electricity.motab";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable pv_wind(fileName = elec_input, tableName = "p_pelec", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-86, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe(redeclare package Medium = Medium, diameter = 0.254, length = 1, modelStructure = Modelica.Fluid.Types.ModelStructure.a_vb, nNodes = 1, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {-16, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  inner Modelica.Fluid.System system(T_start = from_degC(290), allowFlowReversal = false, p_start = Medium.p_default) annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary hotTank(nPorts = 1, redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {70, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-16, 30}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {30, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary coldTank(redeclare package Medium = Medium, T = from_degC(290), nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {70, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_cold(y = 100) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {50, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression zero_flow(y = 0) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression bool(y = on_pv) annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Boolean on_pv;
  Integer state_con(start = 1);
  SolarTherm.Models.Control.ReceiverControl controlCold(Kp = -1000, T_ref = from_degC(565))  annotation(
    Placement(visible = true, transformation(origin = {50, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression L_mea(y = 50)  annotation(
    Placement(visible = true, transformation(origin = {14, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
  when state_con == 1 and pv_wind.y[1] > 1e-3 then
    state_con := 2;
  elsewhen state_con == 2 and pv_wind.y[1] < 1e-3 then
    state_con := 1;
  end when;
equation
  if state_con == 1 then
    on_pv = false;
  else
    on_pv = true;
  end if;
  connect(heater.port, pipe.heatPorts[1]) annotation(
    Line(points = {{-40, 0}, {-20, 0}}, color = {191, 0, 0}));
  connect(pv_wind.y[1], heater.Q_flow) annotation(
    Line(points = {{-74, 0}, {-60, 0}}, color = {0, 0, 127}));
  connect(pipe.port_b, temperature.fluid_a) annotation(
    Line(points = {{-16, 10}, {-16, 20}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, pipe.port_a) annotation(
    Line(points = {{20, -70}, {-16, -70}, {-16, -10}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_a, coldTank.ports[1]) annotation(
    Line(points = {{40, -70}, {60, -70}}, color = {0, 127, 255}));
  connect(temperature.fluid_b, hotTank.ports[1]) annotation(
    Line(points = {{-16, 40}, {-16, 50}, {60, 50}}, color = {0, 127, 255}));
  connect(bool.y, switch1.u2) annotation(
    Line(points = {{80, -20}, {62, -20}}, color = {255, 0, 255}));
  connect(temperature.T, controlCold.T_mea) annotation(
    Line(points = {{-6, 30}, {39, 30}}, color = {0, 0, 127}));
  connect(L_mea.y, controlCold.L_mea) annotation(
    Line(points = {{26, 24}, {40, 24}}, color = {0, 0, 127}));
  connect(zero_flow.y, switch1.u3) annotation(
    Line(points = {{80, -40}, {74, -40}, {74, -28}, {62, -28}}, color = {0, 0, 127}));

  connect(bool.y, controlCold.sf_on) annotation(
    Line(points = {{80, -20}, {68, -20}, {68, 6}, {18, 6}, {18, 18}, {40, 18}}, color = {255, 0, 255}));
  connect(controlCold.m_flow, pumpCold.m_flow) annotation(
    Line(points = {{62, 24}, {124, 24}, {124, -52}, {30, -52}, {30, -62}}, color = {0, 0, 127}));
  connect(m_cold.y, switch1.u1) annotation(
    Line(points = {{80, 0}, {62, 0}, {62, -12}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 3.1536e+07, Tolerance = 1e-06, Interval = 300));
end WindPVsaltTESsystem;