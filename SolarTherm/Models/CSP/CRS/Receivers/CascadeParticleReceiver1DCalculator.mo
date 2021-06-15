within SolarTherm.Models.CSP.CRS.Receivers;

model CascadeParticleReceiver1DCalculator
  import SI = Modelica.SIunits;
  import Utils = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  import Modelica.Math.*;

  //******************************** Mediums
  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
  
  //********************* Particle Receiver Design Parameters
  parameter SI.Area A_ap_lv1 = 400 "Aperture area of the 1st receiver";
  parameter SI.Area A_ap_lv2 = 400 "Aperture area of the 2nd receiver";
  parameter SI.Area A_ap_lv3 = 400 "Aperture area of the 3rd receiver";
  
  parameter Real ar_rec_lv1 = 1 "Aspect ratio for the 1st receiver";
  parameter Real ar_rec_lv2 = 1 "Aspect ratio for the 2nd receiver";
  parameter Real ar_rec_lv3 = 1 "Aspect ratio for the 3rd receiver";
    
  parameter SI.Length H_drop_design_lv1 = sqrt(A_ap_lv1*ar_rec_lv1) "1st receiver's height";
  parameter SI.Length H_drop_design_lv2 = sqrt(A_ap_lv2*ar_rec_lv2) "2nd receiver's height";
  parameter SI.Length H_drop_design_lv3 = sqrt(A_ap_lv3*ar_rec_lv3) "2nd receiver's height";
  
  //********************* Heat Trasnfer Properties
  parameter SI.Length th_w = 0.05 "Backwall thickness of the receiver";
  parameter SI.ThermalConductance k_w = 0.2 "Thermal conductance of the back wall of the receiver";
  parameter SI.CoefficientOfHeatTransfer h_conv_curtain = 32. "Convective heat transfer coefficient (curtain) [W/m^2-K]";
  parameter SI.CoefficientOfHeatTransfer h_conv_backwall = 10. "Convective heat transfer coefficient (backwall) [W/m^2-K]";
  
  //********************* Thermophysical Properties of the working fluid
  parameter SI.Length d_p = 0.00035 "Particle diameter [m]";
  parameter SI.SpecificHeatCapacity cp_s = 1200 "particle specific heat capacity [J/kgK]";
  parameter SI.Density rho_s = 3300 "Particle density [kg/m3]";
  parameter Real eps_s = 0.9 "Particle emmisivity";
  parameter Real abs_s = 0.9 "Particle absorptivity";
  parameter Real F = 0.54 "View Factor of the particle curtain";
  parameter Real eps_w = 0.8 "Receiver wall emmisivity";
  parameter Real phi_max = 0.6;
  
  //********************* Ambient Condition
  parameter SI.Temperature T_amb_design = 273.15 "Ambient temperature at design point [K]";
  parameter Real Wdir =  270 "Wind direction [degree]";
  parameter SI.Velocity Wspd = 25 "Wind speed [m/s]";
  
  parameter SI.Temperature T_in = 550 + 273.15 "Inlet particle temperature to the 1st receiver [K]";
  parameter SI.Temperature T_out_target = 800 + 273.15 "Outlet target temperature from the 3rd receiver [K]";
  
  parameter Real delta_T_lv1 = (T_out_target-T_in) * A_ap_lv1 / (A_ap_lv1+A_ap_lv2+A_ap_lv3);
  parameter Real delta_T_lv2 = (T_out_target-T_in) * A_ap_lv2 / (A_ap_lv1+A_ap_lv2+A_ap_lv3);
  parameter Real delta_T_lv3 = (T_out_target-T_in) * A_ap_lv3 / (A_ap_lv1+A_ap_lv2+A_ap_lv3);
  
  parameter SI.HeatFlowRate Q_in_lv1 = 100e6;
  parameter SI.HeatFlowRate Q_in_lv2 = 100e6;
  parameter SI.HeatFlowRate Q_in_lv3 = 100e6;
  
  parameter SI.MassFlowRate m_in = 1000;
  
  //********************* Simulation Set up
  parameter Boolean test_mode = false;
  parameter Boolean with_detail_h_ambient = true "using size dependent advection heat transfer coefficient";
  parameter Boolean with_wind_effect = true "using wind effect (direction and speed)";
  parameter Boolean fixed_geometry = true "true H_drop = H_drop_design, false T_out = T_out_design ";
  parameter Boolean iterate_Q_flow = false "true T_out=T_out_design else heat.Q_flow / A_ap";
  parameter Boolean with_iterate_mdot = false "true T_out = T_out_design, false mdot = fluid_a.m_flow";
  parameter Boolean with_pre_determined_eta = false "true eta_rec = eta_rec_determined, false eta_rec = Qnet/Qtotal";
  parameter Boolean with_iterate_mdot_outer_loop = false;
  
  //********************* Variables
  SI.MassFlowRate mdot(start=500,min=10,max=4e3,nominal=500) "Iterated mass flow to reach T_out_target";
  SI.Temperature T_out "Particle outlet temperature from receiver 3";
  SI.Efficiency eta_rcv "Net thermal efficiency of the cascade receiver";
  
  SI.HeatFlowRate Q_rcv_lv1_calculated;
  SI.HeatFlowRate Q_rcv_lv2_calculated;
  SI.HeatFlowRate Q_rcv_lv3_calculated;
  
  //********************* Component Instantiation
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D_lv1(
      N = 20, 
      fixed_cp = false, 
      test_mode = false, 
      with_isothermal_backwall = false, 
      with_uniform_curtain_props = false, 
      with_wall_conduction = true, 
      Q_in = Q_in_lv1, 
      h_conv_backwall = h_conv_backwall, 
      h_conv_curtain = h_conv_curtain, 
      H_drop_design = H_drop_design_lv1, 
      phi_max = phi_max, 
      T_amb = T_amb_design, 
      eps_w = eps_w, 
      th_w = th_w, 
      k_w = k_w, 
      F = F, 
      d_p = d_p, 
      cp_s = cp_s, 
      rho_s = rho_s, 
      eps_s = eps_s, 
      abs_s = abs_s, 
      AR=ar_rec_lv1, 
      T_out_design = T_in + delta_T_lv1, 
      with_detail_h_ambient = with_detail_h_ambient, 
      with_wind_effect = with_wind_effect, 
      fixed_geometry = fixed_geometry, 
      iterate_Q_flow = iterate_Q_flow, 
      iterate_mdot = with_iterate_mdot, 
      eta_rec_determined = 1, 
      with_pre_determined_eta = with_pre_determined_eta) annotation(
    Placement(visible = true, transformation(origin = {-19, -63}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));

  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D_lv2(
      N = 20, 
      fixed_cp = false, 
      test_mode = false, 
      with_isothermal_backwall = false, 
      with_uniform_curtain_props = false, 
      with_wall_conduction = true, 
      Q_in = Q_in_lv2, 
      h_conv_backwall = h_conv_backwall, 
      h_conv_curtain = h_conv_curtain, 
      H_drop_design = H_drop_design_lv2, 
      phi_max = phi_max, 
      T_amb = T_amb_design, 
      eps_w = eps_w, 
      th_w = th_w, 
      k_w = k_w, 
      F = F, 
      d_p = d_p, 
      cp_s = cp_s, 
      rho_s = rho_s, 
      eps_s = eps_s,
      abs_s = abs_s, 
      AR=ar_rec_lv2, 
      T_out_design = T_in + delta_T_lv1 + delta_T_lv2, 
      with_detail_h_ambient = with_detail_h_ambient, 
      with_wind_effect = with_wind_effect, 
      fixed_geometry = fixed_geometry, 
      iterate_Q_flow = iterate_Q_flow, 
      iterate_mdot = with_iterate_mdot, 
      eta_rec_determined = 1, 
      with_pre_determined_eta = with_pre_determined_eta)
       annotation(
    Placement(visible = true, transformation(origin = {-18, -7.10543e-15}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D_lv3(
      N = 20, 
      fixed_cp = false, 
      test_mode = false, 
      with_isothermal_backwall = false, 
      with_uniform_curtain_props = false, 
      with_wall_conduction = true, 
      Q_in = Q_in_lv3, 
      h_conv_backwall = h_conv_backwall, 
      h_conv_curtain = h_conv_curtain, 
      H_drop_design = H_drop_design_lv3, 
      phi_max = phi_max, 
      T_amb = T_amb_design, 
      eps_w = eps_w, 
      th_w = th_w, 
      k_w = k_w, 
      F = F, 
      d_p = d_p, 
      cp_s = cp_s, 
      rho_s = rho_s, 
      eps_s = eps_s, 
      abs_s = abs_s, 
      AR=ar_rec_lv3, 
      T_out_design = T_out_target, 
      with_detail_h_ambient = with_detail_h_ambient, 
      with_wind_effect = with_wind_effect, 
      fixed_geometry = fixed_geometry, 
      iterate_Q_flow = iterate_Q_flow, 
      iterate_mdot = with_iterate_mdot, 
      eta_rec_determined = 1, 
      with_pre_determined_eta = with_pre_determined_eta) annotation(
    Placement(visible = true, transformation(origin = {-18, 60}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  
  Modelica.Fluid.Sources.FixedBoundary source(
      redeclare package Medium = Medium, 
      T = T_in, 
      nPorts = 1, 
      p = 1e5, 
      use_T = true, 
      use_p = false)  annotation(
    Placement(visible = true, transformation(origin = {72, -96}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  
  Modelica.Fluid.Sources.FixedBoundary sink(
      redeclare package Medium = Medium, 
      T = 300.0, 
      d = 3300, 
      nPorts = 1, 
      p = 1e5, 
      use_T = true)  annotation(
    Placement(visible = true, transformation(origin = {66, 92}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Sources.RealExpression Wind_speed(y=Wspd) annotation(
    Placement(visible = true, transformation(origin = {-108, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Sources.RealExpression Wind_direction(y=Wdir) annotation(
    Placement(visible = true, transformation(origin = {-108, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Sources.BooleanExpression always_on(y = true)  annotation(
    Placement(visible = true, transformation(origin = {-108, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Q_in_rcv_lv1(
    Q_flow = Q_in_lv1,
    T_ref = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-106, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Q_in_rcv_lv2(
    Q_flow = Q_in_lv2,
    T_ref = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-108, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Q_in_rcv_lv3(
  Q_flow = Q_in_lv3,
  T_ref = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-108, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Sources.RealExpression Ambient(y=T_amb_design) annotation(
    Placement(visible = true, transformation(origin = {-108, 138}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftSimple(cont_m_flow = true, use_input = true)  annotation(
    Placement(visible = true, transformation(origin = {30, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  T_out = particleReceiver1D_lv3.T_out;
  
  if with_iterate_mdot_outer_loop then
    T_out = T_out_target;
  else
    mdot = m_in;
  end if;
  
  Q_rcv_lv1_calculated = A_ap_lv1 * particleReceiver1D_lv1.q_solar;
  Q_rcv_lv2_calculated = A_ap_lv2 * particleReceiver1D_lv2.q_solar;
  Q_rcv_lv3_calculated = A_ap_lv3 * particleReceiver1D_lv3.q_solar;
    
  liftSimple.m_flow = mdot;
  
  eta_rcv = mdot * (Utils.h_T(T_out) - Utils.h_T(T_in)) / (Q_in_lv1 + Q_in_lv2 + Q_in_lv3);
  
  connect(particleReceiver1D_lv1.fluid_b, particleReceiver1D_lv2.fluid_a) annotation(
    Line(points = {{-13, -55}, {8, -55}, {8, -16}, {-14, -16}}, color = {0, 127, 255}));
  connect(particleReceiver1D_lv2.fluid_b, particleReceiver1D_lv3.fluid_a) annotation(
    Line(points = {{-12, 9}, {8, 9}, {8, 46}, {-14, 46}}, color = {0, 127, 255}));
  connect(particleReceiver1D_lv3.fluid_b, sink.ports[1]) annotation(
    Line(points = {{-12, 68}, {8, 68}, {8, 92}, {56, 92}, {56, 92}}, color = {0, 127, 255}));
  connect(Wind_speed.y, particleReceiver1D_lv3.Wspd) annotation(
    Line(points = {{-97, 116}, {-18, 116}, {-18, 72}}, color = {0, 0, 127}));
  connect(Wind_direction.y, particleReceiver1D_lv3.Wdir) annotation(
    Line(points = {{-97, 94}, {-22, 94}, {-22, 72}}, color = {0, 0, 127}));
  connect(Wind_direction.y, particleReceiver1D_lv2.Wdir) annotation(
    Line(points = {{-97, 94}, {-22, 94}, {-22, 14}}, color = {0, 0, 127}));
  connect(Wind_direction.y, particleReceiver1D_lv1.Wdir) annotation(
    Line(points = {{-97, 94}, {-22, 94}, {-22, -50}, {-24, -50}}, color = {0, 0, 127}));
  connect(always_on.y, particleReceiver1D_lv1.on) annotation(
    Line(points = {{-96, -90}, {-78, -90}, {-78, -78}, {-22, -78}, {-22, -78}}, color = {255, 0, 255}));
  connect(always_on.y, particleReceiver1D_lv2.on) annotation(
    Line(points = {{-96, -90}, {-30, -90}, {-30, -16}, {-22, -16}, {-22, -16}}, color = {255, 0, 255}));
  connect(always_on.y, particleReceiver1D_lv3.on) annotation(
    Line(points = {{-96, -90}, {-30, -90}, {-30, 46}, {-20, 46}, {-20, 46}}, color = {255, 0, 255}));
  connect(Q_in_rcv_lv1.port, particleReceiver1D_lv1.heat) annotation(
    Line(points = {{-96, -58}, {-36, -58}}, color = {191, 0, 0}));
  connect(Q_in_rcv_lv2.port, particleReceiver1D_lv2.heat) annotation(
    Line(points = {{-98, 6}, {-36, 6}}, color = {191, 0, 0}));
  connect(Q_in_rcv_lv3.port, particleReceiver1D_lv3.heat) annotation(
    Line(points = {{-98, 66}, {-34, 66}, {-34, 64}}, color = {191, 0, 0}));
  connect(Ambient.y, particleReceiver1D_lv3.Tamb) annotation(
    Line(points = {{-97, 138}, {-14, 138}, {-14, 72}}, color = {0, 0, 127}));
  connect(Ambient.y, particleReceiver1D_lv2.Tamb) annotation(
    Line(points = {{-97, 138}, {-14, 138}, {-14, 14}}, color = {0, 0, 127}));
  connect(Ambient.y, particleReceiver1D_lv1.Tamb) annotation(
    Line(points = {{-97, 138}, {-14, 138}, {-14, -50}}, color = {0, 0, 127}));
  connect(source.ports[1], liftSimple.fluid_a) annotation(
    Line(points = {{62, -96}, {34, -96}, {34, -96}, {34, -96}}, color = {0, 127, 255}));
  connect(liftSimple.fluid_b, particleReceiver1D_lv1.fluid_a) annotation(
    Line(points = {{26, -96}, {-16, -96}, {-16, -78}, {-16, -78}}, color = {0, 127, 255}));
  connect(Wind_speed.y, particleReceiver1D_lv2.Wspd) annotation(
    Line(points = {{-96, 116}, {-18, 116}, {-18, 14}, {-18, 14}}, color = {0, 0, 127}));
  connect(Wind_speed.y, particleReceiver1D_lv1.Wspd) annotation(
    Line(points = {{-96, 116}, {-18, 116}, {-18, -50}, {-18, -50}}, color = {0, 0, 127}));
end CascadeParticleReceiver1DCalculator;
