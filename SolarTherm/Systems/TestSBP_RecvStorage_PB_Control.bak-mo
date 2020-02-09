within SolarTherm.Systems;

model TestSBP_RecvStorage_PB_Control
  package Medium = SolarTherm.Media.Sodium.Sodium_ph;
  SolarTherm.Models.Storage.PCM.DirectContact.SB_PCMStorage2 storage annotation(
    Placement(visible = true, transformation(origin = {-1, 1}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15)  annotation(
    Placement(visible = true, transformation(origin = {-46, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpRecv(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-74, -24}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpPB(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {74, 22}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.SB_Receiver sB_Receiver(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-112, -6}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow = 50000)  annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-72, 18}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.SB_PowerBlockModel powerBlockModel(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {126, 10}, extent = {{-32, -32}, {32, 32}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.loop_breaker loop_breaker2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {74, -20}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression parasit annotation(
    Placement(visible = true, transformation(origin = {142, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.SB_Control sB_Control annotation(
    Placement(visible = true, transformation(origin = {0, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant annotation(
    Placement(visible = true, transformation(origin = {-108, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Tamb.y, storage.T_amb) annotation(
    Line(points = {{-34, 72}, {0, 72}, {0, 30}, {-2, 30}}, color = {0, 0, 127}));
  connect(Tamb.y, sB_Receiver.Tamb) annotation(
    Line(points = {{-34, 72}, {-30, 72}, {-30, 34}, {-112, 34}, {-112, 10}, {-112, 10}}, color = {0, 0, 127}));
  connect(fixedHeatFlow.port, sB_Receiver.heat) annotation(
    Line(points = {{-150, 0}, {-130, 0}, {-130, 0}, {-132, 0}}, color = {191, 0, 0}));
  connect(Tamb.y, powerBlockModel.T_amb) annotation(
    Line(points = {{-34, 72}, {120, 72}, {120, 30}, {120, 30}}, color = {0, 0, 127}));
  connect(parasit.y, powerBlockModel.parasities) annotation(
    Line(points = {{154, 58}, {158, 58}, {158, 36}, {132, 36}, {132, 30}, {132, 30}}, color = {0, 0, 127}));
  connect(sB_Control.T_stor, storage.T_storage) annotation(
    Line(points = {{-10, 94}, {-24, 94}, {-24, 54}, {58, 54}, {58, 34}, {38, 34}, {38, 34}}, color = {0, 0, 127}));
  connect(sB_Control.m_flow_rec_guess, sB_Receiver.m_flow_guess) annotation(
    Line(points = {{-10, 90}, {-92, 90}, {-92, -6}, {-106, -6}, {-106, -6}}, color = {0, 0, 127}));
  connect(sB_Control.m_flow_recv, pumpRecv.m_flow) annotation(
    Line(points = {{12, 96}, {32, 96}, {32, 50}, {-74, 50}, {-74, -17}}, color = {0, 0, 127}));
  connect(sB_Control.m_flow_PB, pumpPB.m_flow) annotation(
    Line(points = {{12, 92}, {74, 92}, {74, 29}}, color = {0, 0, 127}));
  connect(booleanConstant.y, sB_Control.helio_on) annotation(
    Line(points = {{-96, 92}, {-62, 92}, {-62, 86}, {-10, 86}, {-10, 88}}, color = {255, 0, 255}));
  connect(sB_Receiver.fluid_b, loop_breaker.port_a) annotation(
    Line(points = {{-106, 4}, {-96, 4}, {-96, 18}, {-90, 18}, {-90, 18}}, color = {0, 127, 255}));
  connect(loop_breaker.port_b, storage.fluid_ar) annotation(
    Line(points = {{-54, 18}, {-40, 18}, {-40, 20}, {-38, 20}}, color = {0, 127, 255}));
  connect(storage.fluid_br, pumpRecv.fluid_a) annotation(
    Line(points = {{-38, -24}, {-66, -24}, {-66, -24}, {-66, -24}}, color = {0, 127, 255}));
  connect(pumpRecv.fluid_b, sB_Receiver.fluid_a) annotation(
    Line(points = {{-82, -24}, {-108, -24}, {-108, -24}, {-108, -24}}, color = {0, 127, 255}));
  connect(storage.fluid_bp, pumpPB.fluid_a) annotation(
    Line(points = {{36, 20}, {54, 20}, {54, 22}, {66, 22}, {66, 22}}, color = {0, 127, 255}));
  connect(pumpPB.fluid_b, powerBlockModel.fluid_a) annotation(
    Line(points = {{82, 22}, {112, 22}, {112, 20}, {112, 20}}, color = {0, 127, 255}));
  connect(powerBlockModel.fluid_b, loop_breaker2.port_a) annotation(
    Line(points = {{108, -4}, {98, -4}, {98, -20}, {90, -20}, {90, -20}}, color = {0, 127, 255}));
  connect(storage.fluid_ap, loop_breaker2.port_b) annotation(
    Line(points = {{36, -24}, {58, -24}, {58, -20}, {58, -20}}, color = {0, 127, 255}));
end TestSBP_RecvStorage_PB_Control;