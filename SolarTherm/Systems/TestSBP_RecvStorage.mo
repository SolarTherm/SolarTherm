within SolarTherm.Systems;

model TestSBP_RecvStorage
  package Medium = SolarTherm.Media.Sodium.Sodium_ph;
  SolarTherm.Models.Storage.PCM.SB_PCMStorage2 storage annotation(
    Placement(visible = true, transformation(origin = {-1, 1}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink pbSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15)  annotation(
    Placement(visible = true, transformation(origin = {-46, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_ph sourcePB(redeclare package Medium = Medium,h = 300000, nPorts = 1, p = 60000)  annotation(
    Placement(visible = true, transformation(origin = {114, -24}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpRecv(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-74, 14}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpPB(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {74, -26}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_PB(y = 25)  annotation(
    Placement(visible = true, transformation(origin = {70, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.SB_Receiver sB_Receiver(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-112, -6}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow = 50000)  annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 25) annotation(
    Placement(visible = true, transformation(origin = {-88, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Models.Fluid.HeatExchangers.loop_breaker loop_breaker annotation(
    Placement(visible = true, transformation(origin = {-72, -24}, extent = {{14, -14}, {-14, 14}}, rotation = 0)));
equation
  connect(storage.fluid_bp, pbSink.port_a) annotation(
    Line(points = {{36, 20}, {80, 20}, {80, 20}, {80, 20}}, color = {0, 127, 255}));
  connect(Tamb.y, storage.T_amb) annotation(
    Line(points = {{-34, 72}, {0, 72}, {0, 30}, {-2, 30}}, color = {0, 0, 127}));
  connect(pumpPB.fluid_b, storage.fluid_ap) annotation(
    Line(points = {{66, -26}, {38, -26}, {38, -24}, {36, -24}}, color = {0, 127, 255}));
  connect(sourcePB.ports[1], pumpPB.fluid_a) annotation(
    Line(points = {{104, -24}, {82, -24}, {82, -26}, {82, -26}}, color = {0, 127, 255}));
  connect(m_flow_PB.y, pumpPB.m_flow) annotation(
    Line(points = {{82, 4}, {86, 4}, {86, -12}, {74, -12}, {74, -20}, {74, -20}}, color = {0, 0, 127}));
  connect(Tamb.y, sB_Receiver.Tamb) annotation(
    Line(points = {{-34, 72}, {-30, 72}, {-30, 34}, {-112, 34}, {-112, 10}, {-112, 10}}, color = {0, 0, 127}));
  connect(fixedHeatFlow.port, sB_Receiver.heat) annotation(
    Line(points = {{-150, 0}, {-130, 0}, {-130, 0}, {-132, 0}}, color = {191, 0, 0}));
  connect(realExpression.y, pumpRecv.m_flow) annotation(
    Line(points = {{-77, 62}, {-62, 62}, {-62, -12}, {-74, -12}, {-74, 21}}, color = {0, 0, 127}));
  connect(sB_Receiver.fluid_b, pumpRecv.fluid_a) annotation(
    Line(points = {{-106, 4}, {-96, 4}, {-96, 14}, {-82, 14}, {-82, 14}}, color = {0, 127, 255}));
  connect(pumpRecv.fluid_b, storage.fluid_ar) annotation(
    Line(points = {{-66, 14}, {-56, 14}, {-56, 20}, {-38, 20}, {-38, 20}}, color = {0, 127, 255}));
  connect(loop_breaker.port_b, sB_Receiver.fluid_a) annotation(
    Line(points = {{-86, -24}, {-106, -24}, {-106, -24}, {-108, -24}}, color = {0, 127, 255}));
  connect(storage.fluid_br, loop_breaker.port_a) annotation(
    Line(points = {{-38, -24}, {-58, -24}, {-58, -24}, {-58, -24}}, color = {0, 127, 255}));
end TestSBP_RecvStorage;