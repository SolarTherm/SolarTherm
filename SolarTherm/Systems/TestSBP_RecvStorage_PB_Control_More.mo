within SolarTherm.Systems;

model TestSBP_RecvStorage_PB_Control_More
  package Medium = SolarTherm.Media.Sodium.Sodium_ph;
  // Weather data
  parameter String file_weather = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  SolarTherm.Models.Storage.PCM.DirectContact.SB_PCMStorage2 storage annotation(
    Placement(visible = true, transformation(origin = {-1, 1}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15)  annotation(
    Placement(visible = true, transformation(origin = {-46, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpRecv(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-74, -24}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpPB(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {74, 22}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.SB_Receiver sB_Receiver(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-108, 8}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
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
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField annotation(
    Placement(visible = true, transformation(origin = {-161, -9}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(visible = true, transformation(extent = {{-206, 54}, {-186, 74}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(visible = true, transformation(extent = {{-206, 14}, {-180, 34}}, rotation = 0)));
  SolarTherm.Models.Sources.SolarModel.Sun sun(lat = data.lat, lon = data.lon, t_zone = data.t_zone, year = data.year) annotation(
    Placement(visible = true, transformation(extent = {{-172, 38}, {-152, 58}}, rotation = 0)));
  SolarTherm.Models.Sources.DataTable.DataTable data(file = file_weather, lat = lat, lon = lon, t_zone = t_zone, year = year) annotation(
    Placement(visible = true, transformation(extent = {{-98, -78}, {-68, -50}}, rotation = 0)));
equation
  connect(Tamb.y, storage.T_amb) annotation(
    Line(points = {{-34, 72}, {0, 72}, {0, 30}, {-2, 30}}, color = {0, 0, 127}));
  connect(Tamb.y, sB_Receiver.Tamb) annotation(
    Line(points = {{-34, 72}, {-30, 72}, {-30, 34}, {-108, 34}, {-108, 24}}, color = {0, 0, 127}));
  connect(Tamb.y, powerBlockModel.T_amb) annotation(
    Line(points = {{-34, 72}, {120, 72}, {120, 30}, {120, 30}}, color = {0, 0, 127}));
  connect(parasit.y, powerBlockModel.parasities) annotation(
    Line(points = {{154, 58}, {158, 58}, {158, 36}, {132, 36}, {132, 30}, {132, 30}}, color = {0, 0, 127}));
  connect(sB_Control.T_stor, storage.T_storage) annotation(
    Line(points = {{-10, 94}, {-24, 94}, {-24, 54}, {58, 54}, {58, 34}, {38, 34}, {38, 34}}, color = {0, 0, 127}));
  connect(sB_Control.m_flow_rec_guess, sB_Receiver.m_flow_guess) annotation(
    Line(points = {{-10, 90}, {-92, 90}, {-92, 8}, {-103, 8}}, color = {0, 0, 127}));
  connect(sB_Control.m_flow_recv, pumpRecv.m_flow) annotation(
    Line(points = {{12, 96}, {32, 96}, {32, 50}, {-74, 50}, {-74, -17}}, color = {0, 0, 127}));
  connect(sB_Control.m_flow_PB, pumpPB.m_flow) annotation(
    Line(points = {{12, 92}, {74, 92}, {74, 29}}, color = {0, 0, 127}));
  connect(sB_Receiver.fluid_b, loop_breaker.port_a) annotation(
    Line(points = {{-101, 18}, {-90, 18}}, color = {0, 127, 255}));
  connect(loop_breaker.port_b, storage.fluid_ar) annotation(
    Line(points = {{-54, 18}, {-40, 18}, {-40, 20}, {-38, 20}}, color = {0, 127, 255}));
  connect(storage.fluid_br, pumpRecv.fluid_a) annotation(
    Line(points = {{-38, -24}, {-66, -24}, {-66, -24}, {-66, -24}}, color = {0, 127, 255}));
  connect(pumpRecv.fluid_b, sB_Receiver.fluid_a) annotation(
    Line(points = {{-82, -24}, {-95, -24}, {-95, -10}, {-104, -10}}, color = {0, 127, 255}));
  connect(storage.fluid_bp, pumpPB.fluid_a) annotation(
    Line(points = {{36, 20}, {54, 20}, {54, 22}, {66, 22}, {66, 22}}, color = {0, 127, 255}));
  connect(pumpPB.fluid_b, powerBlockModel.fluid_a) annotation(
    Line(points = {{82, 22}, {112, 22}, {112, 20}, {112, 20}}, color = {0, 127, 255}));
  connect(powerBlockModel.fluid_b, loop_breaker2.port_a) annotation(
    Line(points = {{108, -4}, {98, -4}, {98, -20}, {90, -20}, {90, -20}}, color = {0, 127, 255}));
  connect(storage.fluid_ap, loop_breaker2.port_b) annotation(
    Line(points = {{36, -24}, {58, -24}, {58, -20}, {58, -20}}, color = {0, 127, 255}));
  connect(heliostatsField.heat, sB_Receiver.heat) annotation(
    Line(points = {{-142, 0}, {-137, 0}, {-137, 14}, {-128, 14}}, color = {191, 0, 0}));
  connect(heliostatsField.on, sB_Control.helio_on) annotation(
    Line(points = {{-160, -28}, {-160, -28}, {-160, -34}, {-190, -34}, {-190, 86}, {-10, 86}, {-10, 86}}, color = {255, 0, 255}));
  connect(sB_Control.defocus, heliostatsField.defocus) annotation(
    Line(points = {{10, 88}, {22, 88}, {22, 100}, {-196, 100}, {-196, -20}, {-180, -20}, {-180, -20}}, color = {255, 0, 255}));
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-184, 64}, {-180, 64}, {-180, 48}, {-172, 48}, {-172, 48}}, color = {0, 0, 127}));
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-162, 38}, {-162, 38}, {-162, 10}, {-160, 10}}, color = {0, 127, 255}));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-178, 24}, {-176, 24}, {-176, 10}, {-186, 10}, {-186, 2}, {-180, 2}, {-180, 2}}, color = {0, 0, 127}));
end TestSBP_RecvStorage_PB_Control_More;