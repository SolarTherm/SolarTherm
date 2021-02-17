within SolarTherm.Systems;

model TestSBPCM
  package Medium = SolarTherm.Media.Sodium.Sodium_ph;
  SolarTherm.Models.Storage.PCM.DirectContact.SB_PCMStorage2 storage annotation(
    Placement(visible = true, transformation(origin = {-1, 1}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink pbSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink recvSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-94, -26}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15)  annotation(
    Placement(visible = true, transformation(origin = {-46, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_ph sourceRecv(redeclare package Medium = Medium,h = 1.6e7, nPorts = 1, p = 20638)  annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_ph sourcePB(redeclare package Medium = Medium,h = 1.45e7, nPorts = 1, p = 20638)  annotation(
    Placement(visible = true, transformation(origin = {114, -24}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpRecv(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-74, 20}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpPB(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {74, -26}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = 10)  annotation(
    Placement(visible = true, transformation(origin = {-84, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_PB(y = 5)  annotation(
    Placement(visible = true, transformation(origin = {70, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(storage.fluid_bp, pbSink.port_a) annotation(
    Line(points = {{36, 20}, {80, 20}, {80, 20}, {80, 20}}, color = {0, 127, 255}));
  connect(recvSink.port_a, storage.fluid_br) annotation(
    Line(points = {{-74, -26}, {-40, -26}, {-40, -24}, {-38, -24}}, color = {0, 127, 255}));
  connect(Tamb.y, storage.T_amb) annotation(
    Line(points = {{-34, 72}, {0, 72}, {0, 30}, {-2, 30}}, color = {0, 0, 127}));
  connect(pumpPB.fluid_b, storage.fluid_ap) annotation(
    Line(points = {{66, -26}, {38, -26}, {38, -24}, {36, -24}}, color = {0, 127, 255}));
  connect(sourcePB.ports[1], pumpPB.fluid_a) annotation(
    Line(points = {{104, -24}, {82, -24}, {82, -26}, {82, -26}}, color = {0, 127, 255}));
  connect(sourceRecv.ports[1], pumpRecv.fluid_a) annotation(
    Line(points = {{-102, 20}, {-82, 20}, {-82, 20}, {-82, 20}}, color = {0, 127, 255}));
  connect(pumpRecv.fluid_b, storage.fluid_ar) annotation(
    Line(points = {{-66, 20}, {-38, 20}, {-38, 20}, {-38, 20}}));
  connect(m_flow_Recv.y, pumpRecv.m_flow) annotation(
    Line(points = {{-72, 48}, {-64, 48}, {-64, 32}, {-74, 32}, {-74, 26}, {-74, 26}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpPB.m_flow) annotation(
    Line(points = {{82, 4}, {86, 4}, {86, -12}, {74, -12}, {74, -20}, {74, -20}}, color = {0, 0, 127}));
end TestSBPCM;