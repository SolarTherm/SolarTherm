within SolarTherm.Models.CSP.CRS.Receivers;

model ParticleReceiver1DCalculator_Approach2
  import SI = Modelica.SIunits;
  import CONST = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import SolarTherm.Media;
  import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  extends SolarTherm.Icons.ReceiverModel;
  // Ports Declaration
  // Medium
  replaceable package Medium = Media.SolidParticles.CarboHSP_ph;
  // Model configuration

  parameter Boolean with_wall_conduction = true "Whether to model vertical conduction in backwall";
  // FIXME may need to revisit this
  parameter Boolean fixed_cp = false "If false, use the Medium model. If true, use simplified cp=const approx";
  parameter Boolean with_isothermal_backwall = false "If true, fix the backwall temperature to uniform value (controlled cooling)";
  parameter Boolean with_uniform_curtain_props = false "If true, ignore effect of phi_c on curtain emi/abs/tau";
  constant SI.SpecificHeatCapacity cp_s = 1200. "solid specific heat capacity [J/kg-K]";
  //Discretisation
  parameter Integer N = 10 "Number of vertical elements";
  // temperature used to initialise screen
  parameter SI.Temperature T_ref = from_degC(580.3);
  parameter SI.SpecificEnthalpy h_0 = Util.h_T(T_ref);
  // Solid particle geometry
  parameter SI.Length d_p = 280e-6 "particle diameter [m]" annotation(
    Dialog(group = "Technical data"));
  parameter SI.Area a = 0.25 * CONST.pi * d_p ^ 2 "cross sectional particle area [m2]";
  // Medium properties
  parameter SI.Efficiency eps_s = 0.86 "Particle emissivity Sandia Rev 11";
  parameter SI.Efficiency abs_s = 0.9976785 "Particle absorptivity";
  parameter SI.Efficiency tau_s = 5.75335e-8 "Particle transmitivity";
  parameter SI.Density rho_s = 3300. "Particle density [kg/m3]";
  parameter Real phi_max = 0.6 "Maximum achievable particle volume fraction";
  // Environment
  parameter SI.Temperature T_amb = from_degC(25) "Ambient temperature [K]";
  parameter SI.CoefficientOfHeatTransfer h_conv = 100. "Convective heat transfer coefficient (back of backwall) [W/m^2-K]";
  parameter SI.Irradiance dni_des = 788.8;
  parameter Real CR = 1200;
  //Wall properties
  parameter SI.Efficiency eps_w = 0.8 "Receiver wall emissivity";
  parameter SI.ThermalConductivity k_w = 0.2 "Backwall thermal conductivity [W/m-K]";
  parameter SI.Length th_w = 0.05 "Backwall thickness [m]";
  // Design conditions
  parameter SI.Velocity vp_in = 0.25 "Inlet curtain velocity [m/s]";
  parameter Real AR = 1 "Receiver aspect ratio";
  parameter SI.Angle theta_c = from_deg(0.) "representative angle of rays incident on the particle screen (0=normal)";
  SI.Length t_c_in(start = 0.16539, nominal = 0.1) "Curtain thicknesss at the inlet";
  // Receiver geometry
  parameter Real prob_center = 6 / 12;
  parameter Real prob_side = 3 / 12;
  SI.Length W_rcv;
  SI.Length dx "Vertical step size [m]";
  SI.MassFlowRate mdot(start = 2000, nominal = 2000) "Inlet mass flow rate [kg/s]";
  // Distributed variables for the particle curtain
  Real phi[N + 1](start = fill(0.5, N + 1), min = fill(0., N + 1), max = fill(1, N + 1)) "Curtain packing factor (volume fraction)";
  SI.Length x[N + 2](min = zeros(N + 2), max = fill(100., N + 2)) "Vertical positions of nodes";
  SI.Velocity vp[N + 1](start = fill(1.5 * vp_in, N + 1), min = fill(vp_in, N + 1), max = fill(1000, N + 1)) "Particles velocity [m/s]";
  SI.Length t_c[N + 2] "Receiver depth";
  SI.Temperature T_s[N + 1](start = linspace(T_ref, 1351, N + 1), max = fill(2000., N + 1), min = fill(299., N + 1)) "Curtain Temperature";
  SI.SpecificEnthalpy h_s[N + 1](start = linspace(h_0, Util.h_T(1351), N + 1), max = fill(1224994, N + 1), min = fill(735., N + 1)) "Curtain enthalpy";
  SI.Temperature T_w[N + 2](start = linspace(T_in_design-100, 1000, N + 2), max = fill(2000., N + 2), min = fill(299., N + 2)) "Receiver wall temperature";
  //Curtain radiation properties  parameter SI.HeatFlowRate Q_in = 10;
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
  SI.Length L[N](min = zeros(N)) "Length of the side of the cube where 1 particle is";
  SI.Area phi_area[N](min = zeros(N)) "projected area of particle in a cube";
  Real N_layers[N](min = zeros(N)) "number of cubes in the thickness";
  Real A[N](min = zeros(N));
  Real B[N](min = zeros(N));
  Real C[N](min = zeros(N));
  Real A2[N](min = zeros(N));
  Real reflectivity_c[N];
  SI.HeatFlux q_conv_wall[N] "Heat flux lost through backwall by conduction/convection";
  SI.HeatFlux q_conv_curtain[N] "Heat flux lost through backwall by conduction/convection";
  SI.HeatFlux q_net[N] "Net heat flux gained by curtain";
  //Overall performance
  SI.HeatFlowRate Qdot_rec "Total heat rate absorbed by the receiver";
  SI.HeatFlowRate Qdot_inc "Total heat rate incident upon the receiver (before losses)";
  inner Real eta_rec(min = 0, max = 1) "Receiver efficiency, Make it inner so it can be accessed by every component in the system";
  //Declaring the table TAB for h (output) and T (input), ditching out the h_T enthalpy function
  parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/CarboHSP/CarboHSP_hT.txt");
  import Tables = Modelica.Blocks.Tables;
  Tables.CombiTable1Ds Tab[N + 1](each tableOnFile = true, each tableName = "CarboHSP_hT", each columns = 2:2, each fileName = table_file);
  //Thermodynamic Properties in Connectors
  parameter SI.Temperature Tamb = from_degC(25);
  parameter SI.Area A_ap = 34.64^2;
  parameter SI.Length H_drop_design = sqrt(A_ap);
  
  parameter SI.Temperature T_in_design = from_degC(580.3) "Inlet temperature [K]";
  parameter SI.SpecificEnthalpy h_in = Util.h_T(T_in_design);
  
  parameter SI.Temperature T_out_design=from_degC(800);
  parameter SI.SpecificEnthalpy h_out_design = Util.h_T(T_out_design);

  parameter SI.HeatFlowRate Q_in = 670e6;
  parameter Boolean on =true;
algorithm
  for i in 1:N loop
    if with_uniform_curtain_props then
      C[i] := 0;
      L[i] := 0;
      phi_area[i] := 0;
      N_layers[i] := 0;
      A[i] := 0;
      B[i] := 0;
      A2[i] := 0;
      eps_c[i] := eps_s;
      abs_c[i] := abs_s;
      tau_c[i] := 0.4;
      reflectivity_c[i] := 1 - abs_c[i] - tau_c[i];
    else
      if mdot < 1e-6 then
        C[i] := 0;
        L[i] := 0;
        phi_area[i] := 0;
        N_layers[i] := 0;
        A[i] := 0;
        B[i] := 0;
        A2[i] := 0;
        eps_c[i] := 0;
        abs_c[i] := 0;
        tau_c[i] := 0;
        reflectivity_c[i] := 0;
      else
        C[i] := 6 * phi[i] / (CONST.pi * d_p ^ 3);
        L[i] := (4 / 3 * CONST.pi * (d_p / 2) ^ 3 / phi[i]) ^ (1 / 3);
        phi_area[i] := CONST.pi * (d_p / 2) ^ 2 / L[i] ^ 2;
        N_layers[i] := t_c[i] / L[i];
        A[i] := prob_center * (1 - abs_s) * phi_area[i] + 2 * (prob_side * (1 - abs_s) * phi_area[i]) ^ 2 / phi_area[i] / (1 - (1 - abs_s));
        B[i] := min((1 - phi_area[i]) ^ 2, 0.99999);
        A2[i] := prob_center * (1 - eps_s) * phi_area[i] + 2 * (prob_side * (1 - eps_s) * phi_area[i]) ^ 2 / phi_area[i] / (1 - (1 - eps_s));
        eps_c[i] := eps_s;
        abs_c[i] := 1 - A[i] * (1 - B[i] ^ N_layers[i]) / (1 - B[i] - tau_c[i]);
        tau_c[i] := max((1 - phi_area[i]) ^ N_layers[i], 1e-30) "?? Reference";
        reflectivity_c[i] := 1 - abs_c[i] - tau_c[i];
      end if;
    end if;
  end for;
equation
  W_rcv = H_drop_design * AR;
  dx = H_drop_design / N;
  q_solar = Q_in / A_ap;
  
//Boundary conditions
  phi[1] = phi_max;
  vp[1] = vp_in;
  x[1] = 0;
  T_s[1] = T_in_design;
  T_s[N + 1] = T_out_design;
  T_w[1] = T_w[2];
  T_w[N + 2] = T_w[N + 1];
//  Tab[N + 1].y[1] = h_out;
// Node locations
  for i in 2:N + 1 loop
    x[i] = dx * (1. / 2 + i - 2);
  end for;
  x[N + 2] = H_drop_design;
  t_c_in = mdot / (phi_max * vp_in * W_rcv * rho_s);
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
//Assigning values to the TAB lookup table
  for i in 1:N + 1 loop
//Temperature (input)
    Tab[i].u = T_s[i];
//Enthalpy (output)
    Tab[i].y[1] = h_s[i];
  end for;
  if on then
    for i in 1:N loop
//Curtain-wall radiation heat fluxes (W/m²)
      gc_f[i] = q_solar;
      jc_f[i] = 0.54 * (eps_c[i] * CONST.sigma * T_s[i] ^ 4 + reflectivity_c[i] * gc_f[i] + tau_c[i] * gc_b[i]);
      gc_b[i] = j_w[i];
      jc_b[i] = eps_c[i] * CONST.sigma * T_s[i] ^ 4 + reflectivity_c[i] * gc_b[i] + tau_c[i] * gc_f[i];
      g_w[i] = jc_b[i];
      j_w[i] = eps_w * CONST.sigma * T_w[i + 1] ^ 4 + (1 - eps_w) * g_w[i];
// Curtain energy balance
      q_conv_curtain[i] = h_conv * (T_s[i + 1] - Tamb);
      q_net[i] = gc_f[i] - jc_f[i] + gc_b[i] - jc_b[i] - h_conv * (T_s[i + 1] - Tamb);
      q_net[i] * dx * W_rcv = mdot * (h_s[i + 1] - h_s[i]);
// Back wall energy balance
      if with_isothermal_backwall then
// wall is at ambient temperature, absorbed heat lost as convection+radiation
        T_w[i + 1] = Tamb;
        q_conv_wall[i] + j_w[i] = g_w[i];
      else
        q_conv_wall[i] = (T_w[i + 1] - Tamb) / (1 / h_conv + th_w / k_w);
//q loss conv wall
        0 = (if with_wall_conduction then -k_w * ((T_w[i + 2] - T_w[i + 1]) / (x[i + 2] - x[i + 1]) - (T_w[i + 1] - T_w[i]) / (x[i + 1] - x[i])) * th_w else 0) - (g_w[i] - (eps_w * CONST.sigma * T_w[i + 1] ^ 4 + (1 - eps_w) * g_w[i])) * dx + q_conv_wall[i] * dx;
      end if;
    end for;
  else
    for i in 1:N loop
//Curtain-wall radiation heat fluxes (W/m²)
      gc_f[i] = 0;
      jc_f[i] = 0;
      gc_b[i] = 0;
      jc_b[i] = 0;
      g_w[i] = 0;
      j_w[i] = 0;
// Curtain energy balance
      q_conv_curtain[i] = h_conv * (T_s[i + 1] - Tamb);
      q_net[i] = gc_f[i] - jc_f[i] + gc_b[i] - jc_b[i] - h_conv * (T_s[i + 1] - Tamb);
      q_net[i] * dx * W_rcv = mdot * (h_s[i + 1] - h_s[i]);
// Back wall energy balance
      if with_isothermal_backwall then
// wall is at ambient temperature, absorbed heat lost as convection+radiation
        T_w[i + 1] = Tamb;
        q_conv_wall[i] + j_w[i] = g_w[i];
      else
        q_conv_wall[i] = (T_w[i + 1] - Tamb) / (1 / h_conv + th_w / k_w);
//q loss conv wall
        0 = (if with_wall_conduction then -k_w * ((T_w[i + 2] - T_w[i + 1]) / (x[i + 2] - x[i + 1]) - (T_w[i + 1] - T_w[i]) / (x[i + 1] - x[i])) * th_w else 0) - (g_w[i] - (eps_w * CONST.sigma * T_w[i + 1] ^ 4 + (1 - eps_w) * g_w[i])) * dx + q_conv_wall[i] * dx;
      end if;
    end for;
  end if;
  Qdot_inc = q_solar * A_ap;
  if on == true then
    Qdot_rec = max(mdot * (h_s[N + 1] - h_s[1]), 0);
    eta_rec = max(Qdot_rec / Qdot_inc, 0);
  else
    Qdot_rec = 0;
    eta_rec = 0;
  end if;
end ParticleReceiver1DCalculator_Approach2;