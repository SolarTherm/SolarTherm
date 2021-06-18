within SolarTherm.Systems.PCMStorage;

model Test6_SinglePCMStorageTank
  package Medium = SolarTherm.Media.Sodium.Sodium_pT;  
  package Fluid_Package = SolarTherm.Media.Materials.Sodium; 
  package Wall_Package = SolarTherm.Media.Materials.SS316L;  
  package PCM_Package = SolarTherm.Media.Materials.PCM635_UniSA;  //Can investigate different PCM
  SolarTherm.Models.Fluid.Sources.FluidSink pbSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {64, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpRecv(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-74, 20}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = 0.075)  annotation(
    Placement(visible = true, transformation(origin = {-80, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Storage.PCMTubeInTank_Test.SinglePCMStorageTank SinglePCMTank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Wall_Package = Wall_Package, redeclare package PCM_Package = PCM_Package, L = 10, N_sec = 100, T_max = 750 + 273.15, T_min = 540 + 273.15) annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary_pT(redeclare package Medium=Medium, T = 750 + 273.15, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-116, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(m_flow_Recv.y, pumpRecv.m_flow) annotation(
    Line(points = {{-69, 64}, {-64, 64}, {-64, 32}, {-74, 32}, {-74, 26}}, color = {0, 0, 127}));
  connect(pumpRecv.fluid_b, SinglePCMTank.fluid_a) annotation(
    Line(points = {{-66, 20}, {-42, 20}, {-42, 28}, {0, 28}, {0, 28}}, color = {0, 127, 255}));
  connect(SinglePCMTank.fluid_b, pbSink.port_a) annotation(
    Line(points = {{0, -32}, {44, -32}, {44, -34}, {44, -34}}, color = {0, 127, 255}));
  connect(Tamb.y, SinglePCMTank.T_amb) annotation(
    Line(points = {{-58, -12}, {-42, -12}, {-42, -2}, {-18, -2}, {-18, -2}}, color = {0, 0, 127}));
  connect(boundary_pT.ports[1], pumpRecv.fluid_a) annotation(
    Line(points = {{-106, 20}, {-82, 20}, {-82, 20}, {-82, 20}}, color = {0, 127, 255}));

annotation(experiment(StopTime = 180000, StartTime = 0, Tolerance = 1e-3, Interval = 10.0));

annotation (Documentation(revisions ="<html>
  		<p>By Ming Liu on 11/06/2021</p>
  		<p>Similar to Test2_PCM635_Melting, this is an isolation test case for melting PCM635 (a phase change material with melting temperature of 635 deg. C) contained in the shell side. Initially, the PCM is at a temperature of 540 deg. C and liquid sodium enters the tube at 750 deg.C with a mass flow rate of 0.075 kg/s. </p>
  		</html>"));  
  		
end Test6_SinglePCMStorageTank;
