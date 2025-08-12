within SolarTherm.Models.Storage.Thermocline.Annular;

model Annular_Storage_Section_SM //Stationary Momentum Version (SM)
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;
  //Initialize Material Packages
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial "Fluid Package";
  replaceable package Filler_Package = SolarTherm.Materials.PartialMaterial "Filler Package";
  replaceable package Tank_Package = SolarTherm.Materials.SS316L "Tank Package (steel shell)";
  //Fluid Material States
  Fluid_Package.State fluid_in "Model which calculates properties at inlet of the section";
  Fluid_Package.State fluid_out "Model which calculates properties at outlet of the section";
  //Interfacial heat transfer Settings
  parameter Integer Correlation = 1 "1=Smooth_Pipes, 2=SwameeJain_KawaseDe, 3=SwameeJain_GowenSmith, 4=SwameeJain_Gnielinski";
  parameter SI.Length E_roughness = 46.0e-6 "Pipe surface roughness (m)"; //{drawn tubing = 1.5e-6, commercial steel = 46.0e-6, cast iron = 260.0e-6, concrete = 300-3000e-6}
  parameter Real E_div_d = E_roughness/d_pipe;
  parameter SI.ThermalInsulance R_foul = 0.0 "Fouling factor (m2K/W)";
  parameter Real eff_pump = 1.0 "Pumping efficiency used to calculate pumping losses (-)";
  //Height offset for plotting purposes
  parameter SI.Length z_offset = 0.0 "Amount of height offset if there is a tank below it";
  //Tank Design parameters
  parameter SI.Energy E_max = 144e9 "Design storage capacity";
  parameter SI.Energy E_unit = rho_f_avg * V_fluid * (h_f_max - h_f_min) + rho_p * V_solid * (h_p_max - h_p_min);
  parameter SI.Energy E_unit_solid = rho_p * V_solid * (h_p_max - h_p_min) "This one assumes only storage in the solid phase";

  //Storage Geometry
  parameter SI.Length d_pipe = 0.10 "Air pipe diameter (m)";
  parameter SI.Length d_solid = 0.20 "Solid cylinder outer diameter (m)";
  parameter SI.Length L_pipe = 10.0 "Length of the pipe in x-axis (m)";
  parameter SI.Length L_char_solid = (d_solid*d_solid - d_pipe*d_pipe)/(4.0*d_pipe) "Characteristic length of the solid material for Biot number calculation (m)";
  
  parameter Real N_units = E_max / E_unit;
  //Temperature Bounds
  //Temperature Settings
  parameter SI.Temperature T_min = 100.0 + 273.15  "Minimum design temperature also initial T (K)";
  parameter SI.Temperature T_max = 300.0 + 273.15 "Maximum design temperature (K)";
  parameter SI.Temperature T_start = T_min "Initial (uniform) temperature of all components (K), defaults to T_min";
  //Calculated Tank Design Parameters
  parameter SI.Length r_pipe = 0.5 * d_pipe "Air pipe radius (m)";
  parameter SI.Length r_solid = 0.5 * d_solid "Solid cylinder outer radius (m)";
  parameter SI.Volume V_solid = CN.pi * (r_solid * r_solid - r_pipe * r_pipe) * L_pipe "Total volume of solid phase (m3)";
  parameter SI.Volume V_fluid = CN.pi * (r_pipe * r_pipe) * L_pipe "Total volume of fluid phase (m3)";
  
  //Thermal Losses
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.4 "Heat loss coeff of surfaces (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_wall = U_loss_tank "Cylinder wall heat loss coeff (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_side = U_loss_tank "Circle heat loss coeff (W/m2K)";
  
  //Inititalize temperature and enthalpy profile
  parameter SI.Temperature T_f_start[N_f] = fill(T_start, N_f);
  parameter SI.Temperature T_p_start[N_f, N_p] = fill(fill(T_start, N_p), N_f);
  //parameter SI.Temperature T_e_start = T_start;
  parameter SI.SpecificEnthalpy h_f_start[N_f] = fill(Fluid_Package.h_Tf(T_start, 0.0), N_f) "Defaults to uniform";
  parameter SI.SpecificEnthalpy h_p_start[N_f, N_p] = fill(fill(Filler_Package.h_Tf(T_start, 0.0), N_p), N_f) "Defaults to uniform";
  //Property bounds
  //Fluid
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0) "Starting enthalpy of the HTF";
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 0) "Starting enthalpy of the HTF";
  parameter SI.Density rho_f_min = Fluid_Package.rho_Tf(T_min, 0);
  parameter SI.Density rho_f_max = Fluid_Package.rho_Tf(T_max, 0);
  parameter SI.Density rho_f_avg = (rho_f_min + rho_f_max) / 2;

  //Filler
  parameter SI.SpecificEnthalpy h_p_max = Filler_Package.h_Tf(T_max, 1.0);
  parameter SI.SpecificEnthalpy h_p_min = Filler_Package.h_Tf(T_min, 0.0);
  parameter SI.Density rho_p_min = Filler_Package.rho_Tf(T_min, 0.0);
  parameter SI.Density rho_p_max = Filler_Package.rho_Tf(T_max, 1.0);
  parameter SI.Density rho_p = min(rho_p_min, rho_p_max) "kg/m3";

  //Discretization
  parameter Integer N_f = 10 "Number of finite volume elements in fluid";
  parameter Integer N_p = 5 "Number of finite volume elements in filler, including encapsulation";
  parameter SI.Length dz = L_pipe / N_f "discretization in the x-axis";
  parameter SI.Length dr = (r_solid - r_pipe) / N_p "discretization in the r-axis";
  
  //Initialise Fluid Array
  parameter SI.Length z_f[N_f] = Z_position(L_pipe, N_f);
  parameter SI.Area A_fx = CN.pi * r_pipe * r_pipe "Cross sectional area of the fluid column";
  parameter SI.Area A_fr = 2.0 * CN.pi * r_pipe * dz "Cylindrical area of the fluid column for one element";
  parameter SI.Volume dV_f = A_fx * dz "Volume of fluid element";
  parameter SI.Mass dm_f = rho_f_avg*dV_f "Mass of fluid element, using average density";
  SI.Temperature T_f[N_f] "(K)";
  SI.SpecificEnthalpy h_f[N_f](start = h_f_start) "J/kg";
  SI.Density rho_f[N_f] "kg/m3";
  //Plotting
  parameter Real ZDH[N_f] = Relative_Tank_Axes(L_pipe, N_f) "Non-dimensional tank vertical axis";
  //Operational Controls
  Integer State(start = 2) "operational state 2=standby, 3=discharge, 1=charge";
  //Inlet and outlet enthalpies and temperatures
  SI.SpecificEnthalpy h_in "Inlet Enthalpy depends on mass flow direction (J/kg)";
  SI.SpecificEnthalpy h_out "Outlet Enthalpy depends on mass flow direction (J/kg)";
  SI.Temperature T_in "Inlet Temperature depends on mass flow direction";
  SI.Temperature T_out "Outlet Temperature depends on mass flow direction";
  SI.Temperature T_amb;
  //Mass flow rates and superficial velocity
  SI.MassFlowRate m_flow(start = 0.0) "kg/s";
  SI.MassFlowRate m_flow_unit(start = 0.0) "kg/s";
  SI.Velocity u_flow[N_f] "Fluid velocity for each element, wrt the x-axis (m/s)";
  
  //Analytics
  SI.Energy E_stored(start = 0.0) "Make sure the tank starts from T_min for this to be correct";
  Real Level(start = 0.0) "Tank energy charging level (0-1)";
  

  Real f[N_f] "Friction factor of each fluid element";
  SI.Pressure p_drop[N_f] "Pressure drop for each fluid element (Pa)";
  SI.Pressure p_drop_total "Sum of all pressure drops (Pa)";
  SI.Power W_loss_pump "losses due to pressure drop (W)";
  
  //Initialise Particle
  SI.Temperature T_p[N_f, N_p](start = T_p_start) "Temperature of particle elements";
  //Filler Geometry
  
  parameter SI.Mass m_pj[N_p] = Annular.Annular_Masses(r_pipe, r_solid, dz, N_p, rho_p);
  parameter SI.Area A_px[N_p] = Annular.Annular_CSA(r_pipe, r_solid, N_p) "Annulus cross sectional area of each radial solid element";
  parameter SI.Length r_pj[N_p] = Annular.Annular_Radii(r_pipe, r_solid, N_p) "midpoint radius of each radial solid element";

  //Initialise Filler surface temperature
  SI.Temperature T_s[N_f](start = T_f_start);

  //Filler mass-liquid fraction
  Real f_p[N_f, N_p](start=fill(fill(0.0,N_p),N_f)) "Mass liquid fraction of filler";
  //Measured outlet temperature
  Real T_outlet_degC "Outlet temperature in degrees Celcius";
  //Convection Properties
  Real Pe[N_f] "Peclet Number";
  Real Bi[N_f] "Biot Number";
  Real Re[N_f] "Reynolds";
  Real Pr[N_f] "Prandtl";
  Real Nu[N_f] "Nusselt";
  Real h_c[N_f] "Heat transfer coefficient after considering the founling resistance(W/m2K)";
  Real h_clean[N_f] "Heat transfer coefficient without any fouling considered (W/m2K)";

  SI.ThermalConductance U_in[N_f, N_p] "K/W";
  SI.ThermalConductance U_right[N_f, N_p] "K/W";

  protected
  //Filler Properties
  SI.SpecificEnthalpy h_p[N_f, N_p](start = h_p_start) "J/kg";
  SI.ThermalConductivity k_p[N_f, N_p] "W/mK";

  //Fluid Properties
  SI.ThermalConductivity k_f[N_f] "W/mK";
  SI.DynamicViscosity mu_f[N_f] "Pa.s";
  SI.DynamicViscosity mu_f_wall[N_f] "Pa.s (for the wall surface for convection)";
  SI.SpecificHeatCapacity c_pf[N_f] "J/kgK";
  Fluid_Package.State fluid[N_f] "Fluid object array";
  Fluid_Package.State fluid_wall[N_f] "Fluid object array for the surface of the wall for convection calcs";
  //Try filler state "Remove this if using function-based calculation"
  Filler_Package.State filler[N_f, N_p] "Filler object array";

  Real der_h_f[N_f] "Rate of change of specific enthalpy of fluid";


algorithm
//Fluid equations
  if State == 1 then //Fluid is flowing downwards uflow is negative
    der_h_f[1] := 
    ((-2.0 * k_f[1] * k_f[2]) * (T_f[1] - T_f[2]) * A_fx / ((k_f[1] + k_f[2]) * dz) 
    +  m_flow_unit * (h_f[1] - h_f[2]) 
    - h_c[1] * (T_f[1] - T_s[1]) * A_fr ) / dm_f;
    h_out := h_f[1];
    for i in 2:N_f - 1 loop
      der_h_f[i] := 
      (2.0 * k_f[i - 1] * k_f[i] * (T_f[i - 1] - T_f[i]) * A_fx / ((k_f[i - 1] + k_f[i]) * dz) 
      - 2.0 * k_f[i] * k_f[i + 1] * (T_f[i] - T_f[i + 1]) * A_fx / ((k_f[i] + k_f[i + 1]) * dz) 
      + m_flow_unit * (h_f[i] - h_f[i + 1]) 
      - h_c[i] * (T_f[i] - T_s[i]) * A_fr) / dm_f;
    end for;
    der_h_f[N_f] := 
    (2.0 * k_f[N_f - 1] * k_f[N_f] * (T_f[N_f - 1] - T_f[N_f]) * A_fx / ((k_f[N_f - 1] + k_f[N_f]) * dz) 
    + m_flow_unit * (h_f[N_f] - h_in) 
    - h_c[N_f] * (T_f[N_f] - T_s[N_f]) * A_fr) / dm_f;
  else
    der_h_f[1] := 
    ((-2.0 * k_f[1] * k_f[2] * (T_f[1] - T_f[2]) * A_fx / ((k_f[1] + k_f[2]) * dz)) 
    + m_flow_unit * (h_in - h_f[1]) 
    - h_c[1] * (T_f[1] - T_s[1]) * A_fr) / dm_f;
    for i in 2:N_f - 1 loop
      der_h_f[i] := 
      (2.0 * k_f[i - 1] * k_f[i] * (T_f[i - 1] - T_f[i]) * A_fx / ((k_f[i - 1] + k_f[i]) * dz) 
      - 2.0 * k_f[i] * k_f[i + 1] * (T_f[i] - T_f[i + 1]) * A_fx / ((k_f[i] + k_f[i + 1]) * dz) 
      + m_flow_unit * (h_f[i - 1] - h_f[i]) 
      - h_c[i] * (T_f[i] - T_s[i]) * A_fr) / dm_f;
    end for;
    der_h_f[N_f] := 
    (2.0 * k_f[N_f - 1] * k_f[N_f] * (T_f[N_f - 1] - T_f[N_f]) * A_fx / ((k_f[N_f - 1] + k_f[N_f]) * dz) 
    + m_flow_unit * (h_f[N_f - 1] - h_f[N_f]) 
    - h_c[N_f] * (T_f[N_f] - T_s[N_f]) * A_fr) / dm_f;
    h_out := h_f[N_f];
  end if;
  
initial equation
  for i in 1:N_f loop
    fluid[i].h = h_f_start[i];
    for j in 1:N_p loop
      filler[i, j].h = h_p_start[i, j];
    end for;
//encapsulation[i].h = h_p_start[i,N_p];
  end for;
equation
  m_flow_unit = m_flow/N_units;
  for i in 1:N_f loop
    der_h_f[i] = der(h_f[i]);
    u_flow[i] = m_flow_unit / (rho_f[i] * A_fx);
    p_drop[i] = 0.5*f[i]*dz*rho_f[i]*u_flow[i]*u_flow[i]/d_pipe;
  end for;
  
  //for i in 1:N_f loop
    //for j in 1:N_p loop
      //der_h_p[i,j] = der(h_p[i,j]);
    //end for;
  //end for;
//Determine which operational state: In this version, standby and discharge are lumped.
  if m_flow < 0.0 then
//mass is flowing downwards so charging
    State = 1;
  else
//mass is flowing upwards so discharging
    State = 3;
  end if;
  //u_flow = m_flow / (rho_f_avg * A_fx);
//positive if flowing upwards (discharge)
//u_0 = u_flow*eta; //Velocity through empty cross-section
//Fluid inlet and outlet properties
  fluid_in.h = h_in;
  fluid_out.h = h_out;
  fluid_in.T = T_in;
  fluid_out.T = T_out;
//Wall surface properties for convection
  for i in 1:N_f loop
    fluid_wall[i].T = T_s[i];
    //mu_f_wall[i] = max(1.0e-8,fluid_wall[i].mu);
  end for;
//Fluid Property evaluation SolarSalt
  for i in 1:N_f loop
    h_f[i] = fluid[i].h;
    T_f[i] = fluid[i].T;
    c_pf[i] = fluid[i].cp;
    k_f[i] = fluid[i].k;
    rho_f[i] = fluid[i].rho; //added this for stationary momentum (SM) assumption
//k_eff[i] = eta*fluid[i].k; //Effective thermal conductivity of fluid (weighted by porosity)
    mu_f[i] = max(1.0e-8,fluid[i].mu);
    mu_f_wall[i] = max(1.0e-8,fluid_wall[i].mu);
  end for;
//Particle Property evaluation quartzite and sand
  for i in 1:N_f loop
    for j in 1:N_p loop
/*
      //Function-based calculation of filler state
      f_p[i,j] = Filler_Package.f_h(h_p[i,j]);
      T_p[i,j] = Filler_Package.T_h(h_p[i,j]);
      k_p[i,j] = Filler_Package.k_Tf(T_p[i,j],f_p[i,j]); 
      */
      filler[i, j].h = h_p[i, j];
      T_p[i, j] = filler[i, j].T;
      f_p[i,j] = filler[i,j].f;
      k_p[i, j] = filler[i, j].k;
    end for;

  end for;

  
//Convection Equations
  for i in 1:N_f loop
    
    Bi[i] = h_c[i] * L_char_solid / k_p[i, 1];
//Use outermost shell conductivity
    Pe[i] = Re[i] * Pr[i];
    Pr[i] = (c_pf[i] * mu_f[i]) / k_f[i];
    Re[i] = rho_f[i] * d_pipe * (abs(u_flow[i]) / mu_f[i]);
    
    
    if Correlation == 1 then //Smooth Tubes. Use f_Petukhov and Nu_Gnielinksi
      f[i] = SolarTherm.Utilities.HeatTransfer.TubeSmooth.f_Darcy_Petukhov(Re[i]);
      Nu[i] = SolarTherm.Utilities.HeatTransfer.TubeSmooth.Nusselt_Petukhov_Gnielinski(Re[i],Pr[i]);
      
    elseif Correlation == 2 then //Rough Tubes. Use f_SwameeJain and Nu_KawaseDe
      f[i] = SolarTherm.Utilities.HeatTransfer.TubeRough.f_Darcy_SwameeJain(Re[i], E_div_d);
      Nu[i] = SolarTherm.Utilities.HeatTransfer.TubeRough.Nusselt_SwameeJain_KawaseDe(Re[i],Pr[i],E_div_d);
      
    elseif Correlation == 3 then //Rough Tubes. Use f_SwameeJain and Nu_GowenSmith
      f[i] = SolarTherm.Utilities.HeatTransfer.TubeRough.f_Darcy_SwameeJain(Re[i], E_div_d);
      Nu[i] = SolarTherm.Utilities.HeatTransfer.TubeRough.Nusselt_SwameeJain_GowenSmith(Re[i],Pr[i], E_div_d);
      
    else //Rough Tubes. Use f_SwameeJain and Nu_Gnielinski (very bad)
      f[i] = SolarTherm.Utilities.HeatTransfer.TubeRough.f_Darcy_SwameeJain(Re[i], E_div_d);
      Nu[i] = SolarTherm.Utilities.HeatTransfer.TubeRough.Nusselt_SwameeJain_Gnielinski(Re[i],Pr[i], E_div_d);
    end if;
    
    
    h_clean[i] = Nu[i] * k_f[i] / d_pipe;
    h_c[i] = h_clean[i]/(1.0+R_foul*h_clean[i]);
    
  end for;

  //Solid Equations
  //Radial Conductance
  for i in 1:N_f loop
    U_in[i, 1] = 2.0 * CN.pi * dz / (log(r_pj[1] / (r_pj[1] - 0.5 * dr)) / k_p[i, 1]);
    for j in 2:N_p loop
      U_in[i, j] = 2.0 * CN.pi * dz / (log((r_pj[j] - 0.5 * dr) / (r_pj[j] - dr)) / k_p[i, j - 1] + log(r_pj[j] / (r_pj[j] - 0.5 * dr)) / k_p[i, j]);
    end for;
//
    U_in[i, 1] * (T_s[i] - T_p[i, 1]) = h_c[i] * A_fr * (T_f[i] - T_s[i]); //links fluid and filler equations
    //reconciles fluid and filler heat transfer
  end for;
//Axial Conductance
  for j in 1:N_p loop
    for i in 1:N_f - 1 loop
      U_right[i, j] = 2.0 * A_px[j] * k_p[i, j] * k_p[i + 1, j] / (dz * (k_p[i, j] + k_p[i + 1, j]));
    end for;
    U_right[N_f, j] = 2.0 * k_p[N_f, j] * A_px[j] / dz;
  end for;
  
  for i in 2:N_f - 1 loop
//not the ends of the pipe
//Innermost solid annulus
    der(h_p[i, 1]) = (U_in[i, 1] * (T_s[i] - T_p[i, 1]) - U_in[i, 2] * (T_p[i, 1] - T_p[i, 2]) + U_right[i - 1, 1] * (T_p[i - 1, 1] - T_p[i, 1]) - U_right[i, 1] * (T_p[i, 1] - T_p[i + 1, 1])) / m_pj[1];
//Middle solid annuli
    for j in 2:N_p - 1 loop
      der(h_p[i, j]) = (U_in[i, j] * (T_p[i, j - 1] - T_p[i, j]) - U_in[i, j + 1] * (T_p[i, j] - T_p[i, j + 1]) + U_right[i - 1, j] * (T_p[i - 1, j] - T_p[i, j]) - U_right[i, j] * (T_p[i, j] - T_p[i + 1, j])) / m_pj[j];
    end for;
//Outermost solid annulus
    der(h_p[i, N_p]) = (U_in[i, N_p] * (T_p[i, N_p - 1] - T_p[i, N_p]) + U_right[i - 1, N_p] * (T_p[i - 1, N_p] - T_p[i, N_p]) - U_right[i, N_p] * (T_p[i, N_p] - T_p[i + 1, N_p]) - U_wall * (T_p[i, N_p] - T_amb) * CN.pi * d_solid * dz) / m_pj[N_p];
  end for;
//Left end of the pipe i = 1
//Innermost solid annulus
  der(h_p[1, 1]) = (U_in[1, 1] * (T_s[1] - T_p[1, 1]) - U_in[1, 2] * (T_p[1, 1] - T_p[1, 2]) - U_right[1, 1] * (T_p[1, 1] - T_p[2, 1]) - U_side * (T_p[1, 1] - T_amb) * A_px[1]) / m_pj[1];
//Middle solid annuli
  for j in 2:N_p - 1 loop
    der(h_p[1, j]) = (U_in[1, j] * (T_p[1, j - 1] - T_p[1, j]) - U_in[1, j + 1] * (T_p[1, j] - T_p[1, j + 1]) - U_right[1, j] * (T_p[1, j] - T_p[2, j]) - U_side * (T_p[1, j] - T_amb) * A_px[j]) / m_pj[j];
  end for;
//Outermost solid annulus
  der(h_p[1, N_p]) = (U_in[1, N_p] * (T_p[1, N_p - 1] - T_p[1, N_p]) - U_right[1, N_p] * (T_p[1, N_p] - T_p[2, N_p]) - U_wall * (T_p[1, N_p] - T_amb) * CN.pi * d_solid * dz - U_side * (T_p[1, N_p] - T_amb) * A_px[N_p]) / m_pj[N_p];
//Right end of the pipe i = N_f
//Innermost solid annulus
  der(h_p[N_f, 1]) = (U_in[N_f, 1] * (T_s[N_f] - T_p[N_f, 1]) - U_in[N_f, 2] * (T_p[N_f, 1] - T_p[N_f, 2]) + U_right[N_f - 1, 1] * (T_p[N_f - 1, 1] - T_p[N_f, 1]) - U_side * (T_p[N_f, 1] - T_amb) * A_px[1]) / m_pj[1];
//Middle solid annuli
  for j in 2:N_p - 1 loop
    der(h_p[N_f, j]) = (U_in[N_f, j] * (T_p[N_f, j - 1] - T_p[N_f, j]) - U_in[N_f, j + 1] * (T_p[N_f, j] - T_p[N_f, j + 1]) + U_right[N_f - 1, j] * (T_p[N_f - 1, j] - T_p[N_f, j]) - U_side * (T_p[N_f, j] - T_amb) * A_px[j]) / m_pj[j];
  end for;
//Outermost solid annulus
  der(h_p[N_f, N_p]) = (U_in[N_f, N_p] * (T_p[N_f, N_p - 1] - T_p[N_f, N_p]) + U_right[N_f - 1, N_p] * (T_p[N_f - 1, N_p] - T_p[N_f, N_p]) - U_wall * (T_p[N_f, N_p] - T_amb) * CN.pi * d_solid * dz - U_side * (T_p[N_f, N_p] - T_amb) * A_px[N_p]) / m_pj[N_p];
//W_loss_pump =
//Q_loss_total =
//p_drop_total
  p_drop_total = sum(p_drop);
  W_loss_pump = sum(p_drop ./ rho_f ) * abs(m_flow)/eff_pump;  //(abs(m_flow) / rho_f_avg) * (p_drop_total / eff_pump);
  

//Analyics
  der(E_stored) = N_units*abs(m_flow_unit) * (h_in - h_out);
  Level = E_stored / (N_units*E_unit);
  if m_flow > 1.0e-3 then
//Discharging, outlet is the top
    T_outlet_degC = T_f[N_f] - 273.15;
  elseif m_flow < (-1.0e-3) then
//Charging, outlet is the bottom
    T_outlet_degC = T_f[1] - 273.15;
  else
//No flow, output reference temperature
    T_outlet_degC = 25.0;
  end if;
  annotation(
    Documentation(revisions = "<html><head></head><body><p>By Zebedee Kee on 07-Aug-2025</p>
		</body></html>", info = "<html><head></head><body><p>Heat-transfer calculations for an annular TES component. The \"Correlation\" parameter is used to set the Nusselt number correlation which calculates the convective heat transfer correlation between the fluid and solid elements.</p><p><u>Correlation Settings:</u></p><p><b>1. Smooth Pipes. f: Petukhov, Nu: Gnielinski</b></p><p>0.5 &lt; Pr &lt; 2000 (Gnielinski)</p><p>Re &lt; 5000000 (Gnielinski)</p><p><b>2. Rough Pipes. f: Swamee-Jain, Nu: Kawase-De.&nbsp;</b><b>High Prandtl number e.g oils or cool water.&nbsp;</b></p><p>0.0024 &lt; E/d &lt; 0.1 (Swamee-Jain &amp; Kawase-De combined restriction)</p><p>5.1 &lt; Pr &lt; 390 (Kawase-De)&nbsp;</p><p>Re &lt; 500000 (Kawase-De)</p><p><b>3. Rough Pipes. f: Swamee-Jain, Nu: Gowen-Smith. Med-Low Prandtl number e.g. cool water, gases.</b></p><p>0.021 &lt; E/d &lt; 0.095 (Gowen-Smith)</p><p>0.7 &lt; Pr &lt; 14.3 (Gowen-Smith)</p><p>Re &lt; 50000 (Gowen-Smith)</p><p><b>4. Rough Pipes. f: Swamee-Jain, Nu: Gnielinski. Smooth-pipe Nusselt number correlation but using a rough-tube friction factor. Not recommended due to overestimation of heat-transfer correlation</b></p><p>2.0e-8 &lt; E/d &lt; 0.1 (Swamee-Jain)</p><p>0.5 &lt; Pr &lt; 2000 (Gnielinski)</p><p>Re &lt; 5000000 (Gnielinski)</p><p><br></p><p><u>Fouling factors (Incropera p675):</u></p><p>None : 0.0000 m2K/W <b>(Default)</b></p><p>Seawater &amp; treated boiler feedwater &lt; 50degC : 0.0001 m2K/W</p><p>Seawater &amp; treated boiler feedwater &gt; 50degC : 0.0002 m2K/W</p><p>River water &lt; 50 degC : 0.0002 - 0.001 m2K/W</p><p>Fuel Oil : 0.0009 m2K/W</p><p>Refrigerating liquids : 0.0002 m2K/W</p><p>Steam (nonoil bearing) : 0.0001 m2K/W&nbsp;</p><p><br></p><p><br></p>
		</body></html>"));
end Annular_Storage_Section_SM;