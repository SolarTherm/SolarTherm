within SolarTherm.Models.CSP.CRS.Receivers;

model ParticleReceiver1D_Iterate_QFlow
  /* ============================================== MODEL INFO =================================================

                                Max N (discretisation) = 30     Based on Version 9 EES Model by SANDIA
                                THIS MODEL IS FOR CALCULATING THE MINIMUM Q S.T. 10 kg/s of PARTICLE CAN BE HEATED TO 
                                T_out_design TEMPERATURE

        =============================================== END OF MODEL INFO ==============================================
        */
  extends SolarTherm.Icons.ToDo;
  
  //Model Parameters
  parameter SI.Temperature T_out_design = 1454.288084 "Temperature target";
  parameter SI.Temperature T_in_design = 1302.833673 "The lowest possible cold tank temperature";
  parameter SI.Temperature Tamb = from_degC(-20) "The coldest ambient temperature";
  parameter SI.Length H_drop_design = 20.690760 "Receiver drop height";
  parameter SI.MassFlowRate mdot = 100 "Inlet mass flow rate [kg/s]";
  
  // Medium properties
  parameter SI.Efficiency eps_s = 0.9 "Particle emissivity";
  parameter SI.Efficiency abs_s = 0.9 "Particle absorptivity";
  parameter SI.Efficiency tau_s = 5.75335e-8 "Particle transmitivity";
  parameter SI.Density rho_s = 3300. "Particle density [kg/m3]";
  parameter Real phi_max = 0.6 "Maximum achievable particle volume fraction";
  
  // Environment
  parameter SI.CoefficientOfHeatTransfer h_conv_curtain = 32. "Convective heat transfer coefficient (curtain) [W/m^2-K]";
  parameter SI.CoefficientOfHeatTransfer h_conv_backwall = 10. "Convective heat transfer coefficient (backwall) [W/m^2-K]";
  parameter Real C = 1200;
  
  SI.HeatFlowRate Q_flow(start = 100e6) "Minimal heat to reach the target temperature";
  
  parameter Real Wdir = 240;
  parameter Real Wspd = 10;
  import SI = Modelica.SIunits;
  import CONST = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import SolarTherm.Media;
  import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  import log = Modelica.Math.log10;
  extends SolarTherm.Icons.ReceiverModel;
  // Ports Declaration
  // Medium
  replaceable package Medium = Media.SolidParticles.CarboHSP_ph;
  // Model configuration
  parameter Boolean test_mode = true "If true, q_solar = 1200 * 788.8. If False q_solar = Q_in / (W_rcv*H_drop)";
  parameter Boolean fixed_geometry = false "If true, specified H_drop, t_c_in and calculate T_out. 
      //  If false, T_out = T_out_design, calculate H_drop and t_c_in 
      //  mdot and T_in are given by the inlet port
      //  Always use true for annual simulation, use false only when you want to run the particle 1d receiver in test rig";
  parameter Boolean with_wall_conduction = true "Whether to model vertical conduction in backwall";
  parameter Boolean fixed_cp = false "If false, use the Medium model. If true, use simplified cp=const approx";
  parameter Boolean with_isothermal_backwall = false "If true, fix the backwall temperature to uniform value (controlled cooling)";
  parameter Boolean with_uniform_curtain_props = false "If true, ignore effect of phi_c on curtain emi/abs/tau";
  parameter Boolean with_detail_h_ambient = false;
  parameter SI.SpecificHeatCapacity cp_s = 1200. "solid specific heat capacity [J/kg-K]";
  parameter Boolean with_wind_effect = false;
  //Discretisation
  parameter Integer N = 15 "Number of vertical elements";
  parameter SI.Temperature T_ref = from_degC(580.3);
  parameter SI.SpecificEnthalpy h_0 = Util.h_T(T_ref);
  // Solid particle geometry
  parameter SI.Length d_p = 0.00035 "particle diameter [m]" annotation(
    Dialog(group = "Technical data"));
  parameter SI.Area a = 0.25 * CONST.pi * d_p ^ 2 "cross sectional particle area [m2]";

  parameter SI.HeatFlux dni_des = 200;
  parameter SI.Efficiency F = 0.54 "view factor from rev-12 EES code sandia ==> value is taken from CFD analysis done by Brantley
     Mills";
  parameter SI.Density rho_air = 1 "density of ambient air";
  parameter SI.HeatFlowRate Q_in = 100;
  //Wall properties
  parameter SI.Efficiency eps_w = 0.8 "Receiver wall emissivity";
  parameter SI.ThermalConductivity k_w = 0.2 "Backwall thermal conductivity [W/m-K]";
  parameter SI.Length th_w = 0.05 "Backwall thickness [m]";
  // Wind speed regression coefficient to calculate advection percentage losses
  parameter Real C0 = 0.2948569285 "Intercept";
  parameter Real C1 = -1.4098e-3 "Q[MW] coeff";
  parameter Real C2 = -2.0534e-5 "mdot coeff";
  parameter Real C3 = 2.3131e-6 "Qsquare [MW^2] coeff";
  parameter Real C4 = 1.1709E-02 "Wspd * Wdir coeff";
  // Design conditions
  parameter SI.Velocity vp_in = 0.25 "Inlet curtain velocity [m/s]";
  parameter Real AR = 1 "Receiver aspect ratio";
  parameter SI.Angle theta_c = from_deg(0.) "representative angle of rays incident on the particle screen (0=normal)";
  SI.Length t_c_in(start = 0.16539, nominal = 0.1) "Curtain thicknesss at the inlet";
  // Receiver geometry
  SI.Length H_drop(start = 30, min = 1) "Receiver drop height [m]";
  SI.Length W_rcv;
  SI.Area A_ap "Receiver aperture area [m2]";
  SI.Length dx "Vertical step size [m]";
  // Distributed variables for the particle curtain
  Real phi[N + 1](start = fill(0.5, N + 1), min = fill(0., N + 1), max = fill(1, N + 1)) "Curtain packing factor (volume fraction)";
  SI.Length x[N + 2](min = zeros(N + 2), max = fill(100., N + 2)) "Vertical positions of nodes";
  SI.Velocity vp[N + 1](start = fill(1.5 * vp_in, N + 1), min = fill(vp_in, N + 1), max = fill(1000, N + 1)) "Particles velocity [m/s]";
  SI.Length t_c[N + 2] "Receiver depth";
  SI.Temperature T_s[N + 1](start = linspace(T_ref, 1351, N + 1), max = fill(2000., N + 1), min = fill(299., N + 1)) "Curtain Temperature";
  SI.SpecificEnthalpy h_s[N + 1](start = linspace(h_0, Util.h_T(1351), N + 1), max = fill(1224994, N + 1), min = fill(735., N + 1)) "Curtain enthalpy";
  SI.Temperature T_w[N + 2](start = linspace(T_ref, 1351, N + 2), max = fill(2000., N + 2), min = fill(299., N + 2)) "Receiver wall temperature";
  //Curtain radiation properties
  SI.Efficiency eps_c[N](start = linspace(0.999, 0.971, N), max = fill(1., N), min = fill(0., N)) "Curtain emissivity";
  SI.Efficiency tau_c[N](start = linspace(1e-19, 0.004, N), max = fill(1., N), min = fill(0., N)) "Curtain tramittance";
  SI.Efficiency abs_c[N](start = linspace(0.999, 0.972, N), max = fill(1., N), min = fill(0., N)) "Curtain absorptance";
  //Radiation heat fluxes
  SI.HeatFlux q_solar "Uniform solar flux [W/m2]";
  SI.HeatFlux gc_f[N](min = zeros(N)) "Curtain radiation gain at the front";
  SI.HeatFlux jc_f[N](min = zeros(N)) "Curtain radiation loss at the front";
  SI.HeatFlux gc_b[N](min = zeros(N)) "Curtain radiation gain at the back";
  SI.HeatFlux jc_b[N](min = zeros(N)) "Curtain radiation loss at the back";
  SI.HeatFlux g_w[N](min = zeros(N)) "Wall radiation gain from the front";
  SI.HeatFlux j_w[N](min = zeros(N)) "Wall radiosity (outwards to the front)";
  SI.HeatFlux q_conv_wall[N] "Heat flux lost through backwall by conduction/convection";
  SI.HeatFlux q_conv_curtain[N] "Heat flux lost through backwall by conduction/convection";
  SI.HeatFlux q_net[N] "Net heat flux gained by curtain";
  // Advection losses variables
  Real Nu "Nusselt number evaluate";
  Real Re "Reynolds number";
  Real Pr "Prandtl number";
  Real miu "Dynamic viscocity of air";
  Real F_wind_nom(min = 0);
  Real F_wind_denom(min = 0);
  Real F_wind(min = 1);
  Real W_dir_mod;
  SI.SpecificHeatCapacity Cp_air "Cp air ==> evaluated at film temperature";
  SI.ThermalConductance k_air "thermal conductance of air ==> evaluated at film temperature";
  SI.CoefficientOfHeatTransfer h_ambient "coefficient of heat transfer convection to ambient air from the curtain";
  // Heat variables
  SI.HeatFlowRate Qloss_conv_wall_discrete[N];
  SI.HeatFlowRate Qloss_conv_curtain_discrete[N];
  SI.HeatFlowRate Qloss_jcf_discrete[N];
  SI.HeatFlowRate Qloss_jcb_discrete[N];
  SI.HeatFlowRate Qgain_gcb_discrete[N];
  SI.HeatFlowRate Qabsorbed;
  SI.HeatFlowRate Qloss_conv_wall;
  SI.HeatFlowRate Qloss_conv_curtain;
  SI.HeatFlowRate Qloss_jcf;
  SI.HeatFlowRate Qloss_jcb;
  SI.HeatFlowRate Qgain_gcb;
  SI.HeatFlowRate Q_check_curtain;
  //Overall performance
  SI.HeatFlowRate Qdot_rec "Total heat rate absorbed by the receiver";
  SI.HeatFlowRate Qdot_inc "Total heat rate incident upon the receiver (before losses)";
  Real eta_rec(min = 0, max = 1) "Receiver efficiency, Make it inner so it can be accessed by every component in the system";
  //Declaring the table TAB for h (output) and T (input), ditching out the h_T enthalpy function
  parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/CarboHSP/CarboHSP_hT.txt");
  import Tables = Modelica.Blocks.Tables;
  Tables.CombiTable1Ds Tab[N + 1](each tableOnFile = true, each tableName = "CarboHSP_hT", each columns = 2:2, each fileName = table_file);
  SI.SpecificEnthalpy h_out = Util.h_T(T_out_design);
  SI.SpecificEnthalpy h_in = Util.h_T(T_in_design);
equation
  q_solar = Q_flow / A_ap;
  W_rcv = H_drop * AR;
  A_ap = H_drop * W_rcv;
  dx = H_drop / N;
  H_drop = H_drop_design;
//Boundary conditions
  phi[1] = phi_max;
  vp[1] = vp_in;
  x[1] = 0;
  T_s[1] = T_in_design;
  T_s[N + 1] = T_out_design;
  T_w[1] = T_w[2];
  T_w[N + 2] = T_w[N + 1];
  
// Node locations
  for i in 2:N + 1 loop
    x[i] = dx * (1. / 2 + i - 2);
  end for;
  x[N + 2] = H_drop;
  t_c_in = mdot / (phi_max * vp_in * W_rcv * rho_s);
  if mdot > 1e-6 then
    for i in 1:N + 2 loop
// Curtain thickness
      t_c[i] = t_c_in + 0.0087 * x[i];
// Oles and Jackson (Sol. En. 2015), Eq 18.
    end for;
    for i in 2:N + 1 loop
// Curtain momentum balance (gravity causing decreased curtain opacity)
      vp[i] = (vp[i - 1] ^ 2 + 2 * (x[i] - x[i - 1]) * CONST.g_n) ^ 0.5;
// Mass balance
      phi[i] = mdot / (rho_s * vp[i] * t_c[i] * W_rcv);
    end for;
  else
    for i in 1:N + 2 loop
// Curtain thickness
      t_c[i] = 0;
// Oles and Jackson (Sol. En. 2015), Eq 18.
    end for;
    for i in 2:N + 1 loop
// Curtain momentum balance (gravity causing decreased curtain opacity)
      vp[i] = 0;
// Mass balance
      phi[i] = 0;
    end for;
  end if;
//Properties in the connectors
//Assigning values to the TAB lookup table
  for i in 1:N + 1 loop
//Temperature (input)
    Tab[i].u = T_s[i];
//Enthalpy (output)
    Tab[i].y[1] = h_s[i];
  end for;
//Advection variables calculation
  k_air = (32.1e-3 - 25.9e-3) / (100 - 20) * ((T_in_design + T_out_design) / 2 - 273.15) + 25.9e-3 "Heat transfer in a particle curtain falling through a horizontally-flowing gas stream, Chrestella Wardjiman , Martin Rhodes, Powder Technology 191 (2009) 247–253";
  miu = (21.9e-6 - 18.16e-6) / (100 - 20) * ((T_in_design + T_out_design) / 2 - 273.15) + 18.16e-6 "Heat transfer in a particle curtain falling through a horizontally-flowing gas stream, Chrestella Wardjiman ⁎ , Martin Rhodes, Powder Technology 191 (2009) 247–253";
  Cp_air = 1000;
  Re = vp[end] * H_drop * rho_air / miu;
  Pr = miu * Cp_air / k_air;
  Nu = (-758.9) + 0.05737 * Re ^ (6 / 7) "Correlation from Brantley Mills CFD ";
//"Ranz-Marshall correlation Heat transfer in a particle curtain falling through a horizontally-flowing gas stream, Chrestella Wardjiman ⁎ , Martin Rhodes, Powder Technology 191 (2009) 247–253";
  h_ambient = Nu * k_air / H_drop;
  W_dir_mod = Modelica.Math.exp(-1 * ((abs(Wdir - 180) - 115) / 25) ^ 2);
  F_wind_nom = C0 + C1 * Q_flow / 1e6 + C2 * mdot + C3 * (Q_flow / 1e6) ^ 2 + C4 * (W_dir_mod * Wspd);
  F_wind_denom = C0 + C1 * Q_flow / 1e6 + C2 * mdot + C3 * (Q_flow / 1e6) ^ 2 + C4 * (W_dir_mod * 0);
  if with_wind_effect then
    F_wind = F_wind_nom / F_wind_denom;
  else
    F_wind = 1;
  end if;
//Curtain radiative properties calculation
  for i in 1:N loop
    if with_uniform_curtain_props then
      eps_c[i] = eps_s;
      abs_c[i] = abs_s;
      tau_c[i] = 0.4;
    else
      if mdot < 1e-6 then
        eps_c[i] = 0;
        abs_c[i] = 0;
        tau_c[i] = 0;
      else
// Curtain radiation properties
        eps_c[i] * (1 - tau_c[i]) = SolarTherm.Models.CSP.CRS.function_1(eps_s * 6 * phi[i + 1] / (CONST.pi * d_p ^ 3) * t_c[i + 1] * a);
        abs_c[i] * (1 - tau_c[i]) = SolarTherm.Models.CSP.CRS.function_1(abs_s * 6 * phi[i + 1] / (CONST.pi * d_p ^ 3) * t_c[i + 1] * a);
        tau_c[i] = exp(-3 * phi[i + 1] * t_c[i + 1] / (2 * d_p) / cos(theta_c)) "Oles & Jackson (Sol. En., 2015), Eq 31.";
      end if;
    end if;
//Curtain energy balance
    q_conv_curtain[i] = if with_detail_h_ambient then F_wind * h_ambient * (T_s[i + 1] - Tamb) else F_wind * h_conv_curtain * (T_s[i + 1] - Tamb);
    q_net[i] = gc_f[i] - jc_f[i] + gc_b[i] - jc_b[i] - q_conv_curtain[i] "should I include view factor here multiply by jc_f?";
    q_net[i] * dx * W_rcv = mdot * (h_s[i + 1] - h_s[i]);
//Curtain-wall radiation heat fluxes (W/m²)
    gc_f[i] = q_solar;
    jc_f[i] = F * (1 - tau_c[i]) * (eps_c[i] * CONST.sigma * T_s[i + 1] ^ 4 + (1 - abs_c[i]) * q_solar) + tau_c[i] * gc_b[i] "before view factor";
    gc_b[i] = j_w[i];
    jc_b[i] = (1 - tau_c[i]) * (eps_c[i] * CONST.sigma * T_s[i + 1] ^ 4 + (1 - eps_c[i]) * gc_b[i]) + tau_c[i] * q_solar;
    g_w[i] = jc_b[i];
    j_w[i] = eps_w * CONST.sigma * T_w[i + 1] ^ 4 + (1 - eps_w) * g_w[i];
//Back wall energy balance
    if with_isothermal_backwall then
      T_w[i + 1] = Tamb;
      q_conv_wall[i] + j_w[i] = g_w[i];
    else
      q_conv_wall[i] = (T_w[i + 1] - Tamb) / (1 / h_conv_backwall + th_w / k_w);
      0 = (if with_wall_conduction then -k_w * ((T_w[i + 2] - T_w[i + 1]) / (x[i + 2] - x[i + 1]) - (T_w[i + 1] - T_w[i]) / (x[i + 1] - x[i])) * th_w else 0) - (g_w[i] - (eps_w * CONST.sigma * T_w[i + 1] ^ 4 + (1 - eps_w) * g_w[i])) * dx + q_conv_wall[i] * dx;
    end if;
  end for;
// Overall Performance
  Qdot_rec = max(mdot * (h_s[N + 1] - h_s[1]), 0);
  eta_rec = max(Qdot_rec / Qdot_inc, 0);
  for i in 1:N loop
    Qloss_conv_wall_discrete[i] = q_conv_wall[i] * dx * W_rcv;
    Qloss_conv_curtain_discrete[i] = q_conv_curtain[i] * dx * W_rcv;
    Qloss_jcf_discrete[i] = jc_f[i] * dx * W_rcv;
    Qloss_jcb_discrete[i] = jc_b[i] * dx * W_rcv;
    Qgain_gcb_discrete[i] = gc_b[i] * dx * W_rcv;
  end for;
  Qdot_inc = q_solar * A_ap;
  Qloss_conv_wall = sum(Qloss_conv_wall_discrete);
  Qloss_conv_curtain = sum(Qloss_conv_curtain_discrete);
  Qloss_jcf = sum(Qloss_jcf_discrete);
  Qloss_jcb = sum(Qloss_jcb_discrete);
  Qgain_gcb = sum(Qgain_gcb_discrete);
  Qabsorbed = abs(mdot * h_s[1] - mdot * h_s[N + 1]);
  Q_check_curtain = Qabsorbed - sum(dx * W_rcv * q_net[i] for i in 1:N);
  annotation(
    experiment(StartTime = 0, StopTime = 140000, Tolerance = 1e-06, Interval = 1818.18));
end ParticleReceiver1D_Iterate_QFlow;