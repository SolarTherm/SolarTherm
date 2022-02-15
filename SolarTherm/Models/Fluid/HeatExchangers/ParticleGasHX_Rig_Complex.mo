within SolarTherm.Models.Fluid.HeatExchangers;

model ParticleGasHX_Rig_Complex
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  replaceable package Med_PCL = SolarTherm.Media.SolidParticles.CarboHSP_ph;
  replaceable package Med_AIR = Modelica.Media.Air.ReferenceAir.Air_ph;
  
  /*General parameters*/
  parameter Integer num_seg = 6 "Segmentation of heat exchanger";
  parameter SI.Pressure p_working = 1e5 "Working pressure in Pa";
    
  /*On-design parameters*/
  parameter SI.Length D_particle = 0.00035 "Particle diameter in m";
  parameter SI.Length W_HX = 6.4942578200676 "Heat exchanger air manifold width in m";
  parameter SI.Length H_HX = 6.4942578200676 "Heat exchanger air manifold height in m";
  parameter SI.Temperature T_in_AIR_DP = 25 + 273.15 "Air inlet temperature at design point (K)";
  parameter SI.Temperature T_out_AIR_DP = 828.505745884826 "Air outlet temperature at design point (K)";
  parameter SI.MassFlowRate m_dot_AIR_DP = 1860.71496128477 "Desired mass flow rate of air at design point (kg/s)";
  parameter SI.Temperature T_in_PCL_DP = 1153.25160972278 "Particles inlet temperature at design point (K)";
  parameter SI.Temperature T_out_PCL_DP = 950.658597989703 "Particles outlet temperature at design point (K). Equals to the cold tank target temperature";
    
  /*Off design variable*/
  parameter SI.Temperature T_in_pcl = 1067.93312931368;
  parameter SI.Temperature T_in_air = 273.2969;
  parameter SI.MassFlowRate m_dot_pcl = 5456.25418372345;
  
  Modelica.Fluid.Sources.FixedBoundary source_pcl(redeclare package Medium = Med_PCL, T = T_in_pcl, nPorts = 1, p = p_working, use_T = true, use_p = false) annotation(
    Placement(visible = true, transformation(origin = {-138, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink_pcl(redeclare package Medium = Med_PCL, T = 300.0, d = 3300, nPorts = 1, p = p_working, use_T = true) annotation(
    Placement(visible = true, transformation(extent = {{144, 42}, {124, 62}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.LiftSimple lift(cont_m_flow = true, use_input = true, dh = 10, CF = 0, eff = 1, redeclare package Medium = Med_PCL) annotation(
    Placement(visible = true, transformation(origin = {-96, 48}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression L_hot_tank(y = 100) annotation(
    Placement(visible = true, transformation(origin = {-70, 122}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = m_dot_pcl) annotation(
    Placement(visible = true, transformation(origin = {-156, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.HeatExchanger_ParticleGas_Complex HX(D_particle = D_particle, H_HX = H_HX, T_in_AIR_DP = T_in_AIR_DP, T_in_PCL_DP = T_in_PCL_DP, T_out_AIR_DP = T_out_AIR_DP, T_out_PCL_DP = T_out_PCL_DP, W_HX = W_HX, num_seg = num_seg, p_working = p_working, m_dot_AIR_DP=m_dot_AIR_DP) annotation(
    Placement(visible = true, transformation(origin = {10, -24}, extent = {{-80, -80}, {80, 80}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = T_in_air) annotation(
    Placement(visible = true, transformation(origin = {-124, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
equation  
  connect(source_pcl.ports[1], lift.fluid_a) annotation(
    Line(points = {{-128, 50}, {-102, 50}, {-102, 50}, {-102, 50}}, color = {0, 127, 255}));
  connect(realExpression.y, lift.m_flow) annotation(
    Line(points = {{-145, 96}, {-98, 96}, {-98, 60}}, color = {0, 0, 127}));
  connect(L_hot_tank.y, HX.L_hot_tank) annotation(
    Line(points = {{-59, 122}, {2, 122}, {2, 12}, {28, 12}}, color = {0, 0, 127}));
  connect(HX.particle_port_out, sink_pcl.ports[1]) annotation(
    Line(points = {{66, 0}, {104, 0}, {104, 52}, {124, 52}}, color = {0, 127, 255}));
  connect(lift.fluid_b, HX.particle_port_in) annotation(
    Line(points = {{-90, 50}, {-59, 50}, {-59, 0}, {-46, 0}}, color = {0, 127, 255}));
  connect(realExpression1.y, HX.T_amb) annotation(
    Line(points = {{-113, 110}, {-10, 110}, {-10, 12}, {-8, 12}}, color = {0, 0, 127}));


  annotation(
    uses(SolarTherm(version = "0.2"), Modelica(version = "3.2.3")));
end ParticleGasHX_Rig_Complex;