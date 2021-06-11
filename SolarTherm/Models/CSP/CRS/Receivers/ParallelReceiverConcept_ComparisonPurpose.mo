within SolarTherm.Models.CSP.CRS.Receivers;

model ParallelReceiverConcept_ComparisonPurpose
  import SI = Modelica.SIunits;
  import Utils = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  import FI = SolarTherm.Models.Analysis.Finances;
  import Modelica.Math.*;

  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";

  import metadata = SolarTherm.Utilities.Metadata_Optics_3Apertures;
  parameter String opt_file(fixed = false);
  parameter Real metadata_list[24] = metadata(opt_file);
  parameter String casefolder = "./optics" "[H&T] Folder to which the OELT_Solstice look-up table will be stored";
  parameter Real n_helios_total = metadata_list[6] "Number of heliostats";
  parameter SI.Area A_field = n_helios_total * metadata_list[5] "Heliostat field reflective area (m^2)";
  parameter Real A_land = metadata_list[3] "Land area consumed by the plant - calculated value by Solstice (m^2)";
  parameter Real etaC = metadata_list[1] "Efficiency of the field at design point";

  //********************* Particle Receiver Design Parameters
  parameter SI.Area A_rcv_total = A_rcv_centre+A_rcv_left+A_rcv_right "sum of receiver area";
  parameter SI.Area A_rcv_centre = 200 "Aperture area of the centre receiver";
  parameter SI.Area A_rcv_left = 300 "Aperture area of the sides receivers";
  parameter SI.Area A_rcv_right = A_rcv_left "Aperture area of the sides receivers";

  parameter Real ar_rec = 1 "Aspect ratio of the receiver";

  parameter Real ratio_left = A_rcv_left/A_rcv_total "Ratio of aperture area of the left rcv with total aperture area ";
  parameter Real ratio_centre = A_rcv_centre/A_rcv_total "Ratio of aperture area of the centre rcv with total aperture area --> controlled by Python";
  parameter Real ratio_right = A_rcv_right/A_rcv_total "Ratio of aperture area of the right rcv with total aperture area";







  //Operation parameters
  parameter SI.HeatFlowRate Q_in_total = 1e9 "Sum of the total heat flow rate [W] --> controlled by Python";
  parameter SI.HeatFlowRate Q_in_left = metadata_list[10] "Heat Flow Rate to the 1st receiver [W]";
  parameter SI.HeatFlowRate Q_in_centre = metadata_list[20] "Heat Flow Rate to the 2nd receiver [W]";
  parameter SI.HeatFlowRate Q_in_right = metadata_list[15] "Heat Flow Rate to the 3rd receiver [W]";

  parameter SI.MassFlowRate mdot_total = 1000 "mass flow rate total to the parallel receiver --> controlled by Python";

  parameter SI.MassFlowRate mdot_left = mdot_total * ratio_left "mass flow rate to the left receiver";
  parameter SI.MassFlowRate mdot_centre = mdot_total * ratio_centre "mass flow rate to the centre receiver";
  parameter SI.MassFlowRate mdot_right = mdot_total * ratio_right "mass flow rate to the right receiver";
    

  //********************* Heat Trasnfer Properties
  parameter SI.Length th_w = 0.05 "Backwall thickness of the receiver";
  parameter SI.ThermalConductance k_w = 0.2 "Thermal conductance of the back wall of the receiver";
  
  parameter SI.CoefficientOfHeatTransfer h_conv_backwall = 10. "Convective heat transfer coefficient (backwall) [W/m^2-K]";
  

  //********************* Thermophysical Properties of the working fluid
  parameter SI.Length d_p = 0.00035 "Particle diameter [m]";
  parameter SI.SpecificHeatCapacity cp_s = 1200 "particle specific heat capacity [J/kgK]";
  parameter SI.Density rho_s = 3550 "Particle density [kg/m3]";
  parameter Real eps_s = 0.87 "Particle emmisivity";
  parameter Real abs_s = 0.87 "Particle absorptivity";
  parameter Real F = 0.9 "View Factor of the particle curtain";
  parameter Real eps_w = 0.8 "Receiver wall emmisivity";
  parameter Real phi_max = 0.6;

  //********************* Ambient Condition
  parameter SI.Temperature T_amb_design = 273.15 "Ambient temperature at design point [K]";
  parameter Real Wdir =  270 "Wind direction [degree]";
  parameter SI.Velocity Wspd = 25 "Wind speed [m/s]";
 
  parameter SI.Temperature T_in = 550 + 273.15 "Inlet temperature to the parallel receiver from the cold tank";
  parameter SI.Temperature T_out_design = 800 + 273.15 "Outlet temperature at design point";






  //Simulation set-up
  parameter Boolean with_detail_h_ambient = true "using size dependent advection heat transfer coefficient";
  parameter Boolean with_wind_effect = true "using wind effect (direction and speed)";
  parameter Boolean test_mode = false;
  parameter Boolean fixed_geometry = true "true H_drop = H_drop_design, false T_out = T_out_design ";
  parameter Boolean iterate_Q_flow = false "true T_out=T_out_design else heat.Q_flow / A_ap";
  parameter Boolean with_iterate_mdot = true "true T_out = T_out_design, false mdot = fluid_a.m_flow";
  parameter Boolean with_pre_determined_eta = false "true eta_rec = eta_rec_determined, false eta_rec = Qnet/Qtotal";
  

  //********************* Solstice Optical simulations *******************************
  import SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticePyFunc;
  parameter String ppath = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include") "Absolute path to the Python script";
  parameter String pname = "run_solstice_dp" "Name of the Python script";
  parameter String pfunc = "run_simul" "Name of the Python functiuon"; 

  parameter String psave = casefolder "the directory for saving the results"; 
  parameter String field_type = "multi-aperture" "Other options are : surround";
  parameter String rcv_type = "multi-aperture-parallel" "other options are : flat, cylinder, stl"; 
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");  			
  parameter Integer argc =27 "Number of variables to be passed to the C function";


  //parameter Boolean single_field = true "True for single field, false for multi tower";
  //parameter Boolean concrete_tower = true "True for concrete, false for thrust tower";
  parameter Real method = 1 "method of the system deisng, 1 is design from the PB, and 2 is design from the field";
  parameter SI.HeatFlowRate Q_in_rcv = Q_in_total;
  parameter Integer num_aperture = 3 "number of apertures";
  parameter Real angular_range = 238.5 "Angular range of the multi-aperture configuration";

  parameter SI.Length H_rcv_left=sqrt(A_rcv_left*ar_rec) "Left-side receiver aperture height";
  parameter SI.Length W_rcv_left=H_rcv_left/ar_rec "Left-side receiver aperture width";

  parameter SI.Length H_rcv_centre=sqrt(A_rcv_centre*ar_rec)  "Centre receiver aperture height";
  parameter SI.Length W_rcv_centre=H_rcv_centre/ar_rec "Centre receiver aperture width";

  parameter SI.Length H_rcv_right=sqrt(A_rcv_right*ar_rec)  "Right-side receiver aperture height";
  parameter SI.Length W_rcv_right=H_rcv_right/ar_rec "Right-side receiver aperture width";

  parameter Real n_H_rcv=10 "num of grid in the vertical direction (for flux map)";
  parameter Real n_W_rcv=10 "num of grid in the horizontal/circumferetial direction (for flux map)";
  parameter SI.Angle tilt_rcv = 0 "tilt of receiver in degree relative to tower axis";
  parameter SI.Length W_helio = 12 "width of heliostat in m";
  parameter SI.Length H_helio = 12 "height of heliostat in m";
  parameter SI.Length H_tower = 221.2 "Tower height";
  parameter SI.Length R_tower = 25 "Tower diameter";
  parameter SI.Length R1=45 "distance between the first row heliostat and the tower";
  parameter Real fb=0.8 "factor to grow the field layout";
  parameter SI.Efficiency helio_refl = 0.875425 "The effective heliostat reflectance";
  parameter SI.Angle slope_error = 1.53e-3 "slope error of heliostats, in radiance";
  parameter SI.Angle slope_error_windy = 2e-3 "a larger optical error of heliostats under windy conditions, in radiance";
  parameter Real n_rays = 5e6 "number of rays for the optical simulation";
  parameter Real n_procs = 0 "number of processors, 0 is using maximum available num cpu, 1 is 1 CPU,i.e run in series mode";

  parameter Integer windy_optics=0 "simulate the windy oelt or not? 1 is yes, 0 is no";
  parameter Integer verbose=0  "save all the optical simulation details or not? 1 is yes, 0 is no";
  parameter Integer gen_vtk=0 "visualise the optical simulation scene or not? 1 is yes, 0 is no";

  parameter Real Euro_to_USD_exchange_rate = 1.21 "[USD/Euro]";
  parameter FI.Money C_extra_structure(fixed=false);

  parameter FI.Money C_tower = C_extra_structure  -1.992 * H_tower^2.747 + 523100 + (0.7452 * H_tower^3 - 148.25 * H_tower^2 + 37204*H_tower - 731236) * Euro_to_USD_exchange_rate + 1573 * H_tower; 


  //*********************** Analytics variables
  SI.HeatFlowRate Q_absorbed;
  SI.HeatFlowRate Q_loss_advection_curtain;
  SI.HeatFlowRate Q_loss_advection_backwall;
  SI.HeatFlowRate Q_loss_radiation;
  
  Real eta_rcv;
  Real eta_advection_curtain;
  Real eta_advection_backwall;
  Real eta_radiation;
  
  SolarTherm.Utilities.TowerExtraCostTimHarvey structureExtraCost(
    H_tower = H_tower,
    D_inner_tower = R_tower * 2
  );
  
  SI.Temperature T_out;






  //******************************** Components instantiation
  //Receivers
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D_left(
        N = 30, 
        fixed_cp = false, 
        test_mode = false, 
        with_isothermal_backwall = false, 
        with_uniform_curtain_props = false, 
        with_wall_conduction = true,
        h_conv_backwall = h_conv_backwall,
        H_drop_design = (A_rcv_left * ar_rec)^0.5, 
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
        AR=ar_rec, 
        T_out_design = T_out_design, 
        with_detail_h_ambient = with_detail_h_ambient, 
        with_wind_effect = with_wind_effect, 
        fixed_geometry = fixed_geometry, 
        iterate_Q_flow = iterate_Q_flow, 
        iterate_mdot = with_iterate_mdot,  
        with_pre_determined_eta = with_pre_determined_eta
  ) annotation(
    Placement(visible = true, transformation(origin = {-75, 13}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  


  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D_centre(
        N = 30, 
        fixed_cp = false, 
        test_mode = false, 
        with_isothermal_backwall = false, 
        with_uniform_curtain_props = false, 
        with_wall_conduction = true,
        h_conv_backwall = h_conv_backwall,
        H_drop_design = (A_rcv_centre * ar_rec)^0.5, 
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
        AR=ar_rec, 
        T_out_design = T_out_design, 
        with_detail_h_ambient = with_detail_h_ambient, 
        with_wind_effect = with_wind_effect, 
        fixed_geometry = fixed_geometry, 
        iterate_Q_flow = iterate_Q_flow, 
        iterate_mdot = with_iterate_mdot,  
        with_pre_determined_eta = with_pre_determined_eta
  ) annotation(
    Placement(visible = true, transformation(origin = {1, 13}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));




  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D_right(
        N = 30, 
        fixed_cp = false, 
        test_mode = false, 
        with_isothermal_backwall = false, 
        with_uniform_curtain_props = false, 
        with_wall_conduction = true,
        h_conv_backwall = h_conv_backwall,
        H_drop_design = (A_rcv_right * ar_rec)^0.5, 
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
        AR=ar_rec, 
        T_out_design = T_out_design, 
        with_detail_h_ambient = with_detail_h_ambient, 
        with_wind_effect = with_wind_effect, 
        fixed_geometry = fixed_geometry, 
        iterate_Q_flow = iterate_Q_flow, 
        iterate_mdot = with_iterate_mdot,  
        with_pre_determined_eta = with_pre_determined_eta
  ) annotation(
    Placement(visible = true, transformation(origin = {74, 12}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  


  //Source and sink
  Modelica.Fluid.Sources.FixedBoundary source(
        nPorts = 3,
        redeclare package Medium = Medium, 
        T = T_in, 
        p = 1e5, 
        use_T = true, 
        use_p = false
  )annotation(
    Placement(visible = true, transformation(origin = {0, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  
  Modelica.Fluid.Sources.FixedBoundary sink(
        nPorts = 3,
        redeclare package Medium = Medium, 
        T = 300.0, 
        d = 3300, 
        p = 1e5, 
        use_T = true
  )annotation(
    Placement(visible = true, transformation(origin = {0, 104}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  
  //Lift
  SolarTherm.Models.Fluid.Pumps.LiftSimple lift_left(cont_m_flow = true, use_input = true) annotation(
    Placement(visible = true, transformation(origin = {-72, -52}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  SolarTherm.Models.Fluid.Pumps.LiftSimple lift_centre(cont_m_flow = true, use_input = true) annotation(
    Placement(visible = true, transformation(origin = {4, -54}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  SolarTherm.Models.Fluid.Pumps.LiftSimple lift_right(cont_m_flow = true, use_input = true) annotation(
    Placement(visible = true, transformation(origin = {78, -54}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  
  //Booleans
  Modelica.Blocks.Sources.BooleanExpression alwaysOn_Left(y = true)  annotation(
    Placement(visible = true, transformation(origin = {-136, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression alwaysOn_Centre(y = true)  annotation(
    Placement(visible = true, transformation(origin = {-44, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression alwaysOn_Right(y = true)  annotation(
    Placement(visible = true, transformation(origin = {30, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  //Ambient conditions
  Modelica.Blocks.Sources.RealExpression T_amb(y=T_amb_design) annotation(
    Placement(visible = true, transformation(origin = {-128, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression wspd(y=Wspd) annotation(
    Placement(visible = true, transformation(origin = {-128, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression wdir(y=Wdir) annotation(
    Placement(visible = true, transformation(origin = {-128, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  //Input heat
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Q_flow_left(
    Q_flow = Q_in_left,
    T_ref = 298.15
  )annotation(
    Placement(visible = true, transformation(origin = {-152, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Q_flow_centre(
    Q_flow = Q_in_centre,
    T_ref = 298.15
  )annotation(
    Placement(visible = true, transformation(origin = {-44, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Q_flow_right(
    Q_flow = Q_in_right,
    T_ref = 298.15
  )annotation(
    Placement(visible = true, transformation(origin = {30, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  


initial equation
opt_file =  SolsticePyFunc(ppath, pname, pfunc, psave, field_type, rcv_type,  wea_file, argc, {"method", "num_aperture", "gamma","Q_in_rcv", "H_rcv_1", "W_rcv_1","H_rcv_2", "W_rcv_2","H_rcv_3", "W_rcv_3","n_H_rcv", "n_W_rcv", "tilt_rcv", "W_helio", "H_helio", "H_tower", "R_tower", "R1", "fb", "helio_refl", "slope_error", "slope_error_windy", "windy_optics",  "n_rays", "n_procs" ,"verbose", "gen_vtk"}, {method, num_aperture, angular_range, Q_in_rcv, H_rcv_left, W_rcv_left, H_rcv_right, W_rcv_right, H_rcv_centre, W_rcv_centre, n_H_rcv, n_W_rcv, tilt_rcv, W_helio, H_helio, H_tower, R_tower, R1, fb, helio_refl, slope_error, slope_error_windy, windy_optics, n_rays, n_procs, verbose, gen_vtk}); 

C_extra_structure = structureExtraCost.C_extra_structure_cost;

equation
if with_iterate_mdot == true then
    lift_left.m_flow = particleReceiver1D_left.mdot;
    lift_centre.m_flow = particleReceiver1D_centre.mdot;
    lift_right.m_flow = particleReceiver1D_right.mdot;
else
    lift_left.m_flow = mdot_left;
    lift_centre.m_flow = mdot_centre;
    lift_right.m_flow = mdot_right;
end if;
  
  T_out = SolarTherm.Media.SolidParticles.CarboHSP_utilities.T_h(
      (particleReceiver1D_left.h_out + particleReceiver1D_centre.h_out + particleReceiver1D_right.h_out)/3
  );





  Q_absorbed = particleReceiver1D_left.Qabsorbed + 
                                particleReceiver1D_centre.Qabsorbed + 
                                    particleReceiver1D_right.Qabsorbed;
                    
  Q_loss_advection_curtain = particleReceiver1D_left.Qloss_conv_curtain + 
                                particleReceiver1D_centre.Qloss_conv_curtain + 
                                    particleReceiver1D_right.Qloss_conv_curtain;
                                    
  Q_loss_advection_backwall = particleReceiver1D_left.Qloss_conv_wall + 
                                particleReceiver1D_centre.Qloss_conv_wall + 
                                    particleReceiver1D_right.Qloss_conv_wall;

  Q_loss_radiation = particleReceiver1D_left.Qloss_jcf + 
                        particleReceiver1D_centre.Qloss_jcf + 
                            particleReceiver1D_right.Qloss_jcf;
                    
  eta_rcv = Q_absorbed / Q_in_total;
  eta_advection_curtain = Q_loss_advection_curtain/Q_in_total;
  eta_advection_backwall = Q_loss_advection_backwall/Q_in_total;
  eta_radiation = 1 - eta_rcv - eta_advection_curtain - eta_advection_backwall;
  
  //eta_check = eta_rcv + eta_advection_curtain + eta_radiation + eta_advection_backwall - 1;

  connect(source.ports[1], lift_centre.fluid_a) annotation(
    Line(points = {{0, -76}, {6, -76}, {6, -58}, {6, -58}}, color = {0, 127, 255}));
  connect(source.ports[2], lift_left.fluid_a) annotation(
    Line(points = {{0, -76}, {-72, -76}, {-72, -56}, {-70, -56}}, color = {0, 127, 255}));
  connect(source.ports[3], lift_right.fluid_a) annotation(
    Line(points = {{0, -76}, {80, -76}, {80, -58}, {80, -58}}, color = {0, 127, 255}));
  connect(lift_left.fluid_b, particleReceiver1D_left.fluid_a) annotation(
    Line(points = {{-70, -48}, {-72, -48}, {-72, -4}, {-72, -4}}, color = {0, 127, 255}));
  connect(lift_centre.fluid_b, particleReceiver1D_centre.fluid_a) annotation(
    Line(points = {{6, -50}, {4, -50}, {4, -2}, {4, -2}}, color = {0, 127, 255}));
  connect(lift_right.fluid_b, particleReceiver1D_right.fluid_a) annotation(
    Line(points = {{80, -50}, {78, -50}, {78, -2}, {78, -2}}, color = {0, 127, 255}));
  connect(particleReceiver1D_left.fluid_b, sink.ports[1]) annotation(
    Line(points = {{-68, 22}, {-60, 22}, {-60, 60}, {0, 60}, {0, 94}}, color = {0, 127, 255}));
  connect(particleReceiver1D_centre.fluid_b, sink.ports[2]) annotation(
    Line(points = {{6, 22}, {18, 22}, {18, 60}, {0, 60}, {0, 94}}, color = {0, 127, 255}));
  connect(particleReceiver1D_right.fluid_b, sink.ports[3]) annotation(
    Line(points = {{80, 20}, {90, 20}, {90, 60}, {0, 60}, {0, 94}}, color = {0, 127, 255}));
  connect(alwaysOn_Left.y, particleReceiver1D_left.on) annotation(
    Line(points = {{-124, -4}, {-80, -4}, {-80, -4}, {-78, -4}}, color = {255, 0, 255}));
  connect(alwaysOn_Centre.y, particleReceiver1D_centre.on) annotation(
    Line(points = {{-32, -4}, {-2, -4}, {-2, -2}, {-2, -2}}, color = {255, 0, 255}));
  connect(alwaysOn_Right.y, particleReceiver1D_right.on) annotation(
    Line(points = {{42, -2}, {70, -2}, {70, -2}, {72, -2}}, color = {255, 0, 255}));
  connect(T_amb.y, particleReceiver1D_left.Tamb) annotation(
    Line(points = {{-116, 78}, {-70, 78}, {-70, 28}, {-70, 28}}, color = {0, 0, 127}));
  connect(T_amb.y, particleReceiver1D_centre.Tamb) annotation(
    Line(points = {{-116, 78}, {6, 78}, {6, 26}, {6, 26}}, color = {0, 0, 127}));
  connect(T_amb.y, particleReceiver1D_right.Tamb) annotation(
    Line(points = {{-116, 78}, {78, 78}, {78, 24}, {78, 24}}, color = {0, 0, 127}));
  connect(wspd.y, particleReceiver1D_left.Wspd) annotation(
    Line(points = {{-116, 60}, {-74, 60}, {-74, 28}, {-74, 28}}, color = {0, 0, 127}));
  connect(wspd.y, particleReceiver1D_centre.Wspd) annotation(
    Line(points = {{-116, 60}, {2, 60}, {2, 26}, {2, 26}}, color = {0, 0, 127}));
  connect(wspd.y, particleReceiver1D_right.Wspd) annotation(
    Line(points = {{-116, 60}, {74, 60}, {74, 24}, {74, 24}}, color = {0, 0, 127}));
  connect(wdir.y, particleReceiver1D_left.Wdir) annotation(
    Line(points = {{-116, 44}, {-80, 44}, {-80, 28}, {-80, 28}}, color = {0, 0, 127}));
  connect(wdir.y, particleReceiver1D_centre.Wdir) annotation(
    Line(points = {{-116, 44}, {-2, 44}, {-2, 26}, {-4, 26}}, color = {0, 0, 127}));
  connect(wdir.y, particleReceiver1D_right.Wdir) annotation(
    Line(points = {{-116, 44}, {70, 44}, {70, 24}, {70, 24}}, color = {0, 0, 127}));
  connect(Q_flow_left.port, particleReceiver1D_left.heat) annotation(
    Line(points = {{-142, 20}, {-94, 20}, {-94, 18}, {-94, 18}}, color = {191, 0, 0}));
  connect(Q_flow_centre.port, particleReceiver1D_centre.heat) annotation(
    Line(points = {{-34, 18}, {-16, 18}, {-16, 18}, {-16, 18}}, color = {191, 0, 0}));
  connect(Q_flow_right.port, particleReceiver1D_right.heat) annotation(
    Line(points = {{40, 18}, {58, 18}, {58, 16}, {58, 16}}, color = {191, 0, 0}));
end ParallelReceiverConcept_ComparisonPurpose;
