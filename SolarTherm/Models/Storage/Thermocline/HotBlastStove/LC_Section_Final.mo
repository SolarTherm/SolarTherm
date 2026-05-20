within SolarTherm.Models.Storage.Thermocline.HotBlastStove;

model LC_Section_Final
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;
  //Initialize Material Packages
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial "Fluid Package";
  replaceable package Filler_Package = SolarTherm.Materials.PartialMaterial "Filler Package";
  replaceable package Tank_Package = SolarTherm.Materials.SS316L "Tank Package (steel shell)"; //Not Used Anyway
  
  //Fluid Material States
  Fluid_Package.State fluid_in "Model which calculates state properties at inlet of the section";
  Fluid_Package.State fluid_out "Model which calculates state properties at outlet of the section";
  //Fluid-Filler heat transfer Settings
  parameter Integer Correlation = 1 "1: Internal Flow, Gas";
  
  //Storage Design Parameters
  parameter SI.Energy E_max = 144e9 "Ideal storage capacity, assuming complete utilisation fluid and filler heat capacity between T_min and T_max (J)";
  parameter Real ar = 4.82 "Tank Aspect ratio H/D (-)";
  parameter Real epsilon = 0.30 "Geometrical porosity of the checkerbrick, cross-sectional area of holes divided by cross-sectional area of the checkerbrick hexagon (-)";
  parameter Real d_p = 0.02 "Hydraulic diameter of the checkerbrick air channels (m)";
  parameter SI.Length E_roughness = 3.045e-3 "Checkerbrick surface roughness (m)";
  
  //Pressure drop and pumping loss parameters
  parameter Real eff_pump = 1.00 "Pump electricity to work efficiency (-)"; //Set this to 100%, deal with pumping efficiency in post-processing

  
  parameter SI.CoefficientOfHeatTransfer U_loss_top = 0.698 "Overall heat loss coefficient at the top of the tank (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_loss_bot = 1.22 "Overall heat loss coefficient at the bottom of the tank (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_loss_array[N_f] = Set_Linear_Insulation(U_loss_bot,U_loss_top,H_tank,z_f,N_f) "Linear distribution of overall heat loss coefficient throughout the vertical tank axis (W/m2K)"; 
  
  //Height offset for plotting purposes
  parameter SI.Length z_offset = 0.0 "Amount of height offset if there is a tank below it (m)";
  
  //Temperature Bounds
  parameter SI.Temperature T_min = 350.0 + 273.15 "Minimum temperature of the TES (K)";
  parameter SI.Temperature T_max = 1100.0 + 273.15 "Maximum temperature of the TES (K)";
  parameter SI.Temperature T_start = T_min "Initial (uniform) temperature of all components in the TES, defaults to T_min (K)";
  
  //Calculated Tank Design Parameters
  parameter SI.Length H_tank = (4 * E_max / (CN.pi * (1 / ar) ^ 2 * (rho_f_avg * (h_f_max - h_f_min) * epsilon + rho_p * (h_p_max - h_p_min) * (1.0 - epsilon)))) ^ (1 / 3) "TES height, z-axis (m)";
  parameter SI.Diameter D_tank = H_tank / ar "TES diameter (m)";
  parameter SI.Area A = CN.pi * D_tank * D_tank / 4.0 "Cross sectional area of TES (m2)";
  parameter SI.Area A_loss_tank = CN.pi * D_tank * D_tank * 0.5 + CN.pi * D_tank * H_tank "Total heat loss area (m2)";
  parameter SI.Area A_loss_wall_i = CN.pi*D_tank*dz "Surface area of the side of each element for heat loss calculations (m2)";
  parameter Real E_div_d = E_roughness/d_p "Ratio of surface roughness to hydraulic diameter, this is the roughness ratio (-)";
  
  //Derived geometrical parameters
  parameter SI.Length L_char_solid = 0.25*d_p*(1.0-epsilon)/epsilon "Characteristic length of the solid media, also the ratio of solid volume to contact-surface-area, used for Biot number calculation (m)";

  //Initialised temperature and enthalpy arrays for the fluid (f) and filler (p) elements.
  parameter SI.Temperature T_f_start[N_f] = fill(T_start, N_f) "Initial fluid temperature profile (K)";
  parameter SI.Temperature T_p_start[N_f] = fill(T_start, N_f) "Initial filler temperature profile (K)";

  parameter SI.SpecificEnthalpy h_f_start[N_f] = fill(Fluid_Package.h_Tf(T_start, 0.0), N_f) "Initial fluid enthalpy profile, default uniform profile (J/kg)";
  parameter SI.SpecificEnthalpy h_p_start[N_f] = fill(Filler_Package.h_Tf(T_start, 0.0), N_f) "Initial filler enthalpy profile, default uniform profile (J/kg)";
  
  //Fluid and filler properties at the minimum and maximum temperature bounds
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0) "Specific enthalpy of fluid at T_min (J/kg)";
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 0) "Specific enthalpy of fluid at T_max (J/kg)";
  parameter SI.Density rho_f_Tmin = Fluid_Package.rho_Tf(T_min, 0) "Density of fluid at T_min (kg/m3)";
  parameter SI.Density rho_f_Tmax = Fluid_Package.rho_Tf(T_max, 0) "Density of fluid at T_max (kg/m3)";
  parameter SI.Density rho_f_avg = (rho_f_Tmin + rho_f_Tmax) / 2.0 "Averaged fluid density (kg/m3)";

  parameter SI.SpecificEnthalpy h_p_min = Filler_Package.h_Tf(T_min, 0.0) "Specific enthalpy of filler at T_min (J/kg)";
  parameter SI.SpecificEnthalpy h_p_max = Filler_Package.h_Tf(T_max, 1.0) "Specific enthalpy of filler at T_max (J/kg)";

  parameter SI.Density rho_p_Tmin = Filler_Package.rho_Tf(T_min, 0.0) "Density of filler at T_min (kg/m3)";
  parameter SI.Density rho_p_Tmax = Filler_Package.rho_Tf(T_max, 1.0) "Density of filler at T_max (kg/m3)";
  parameter SI.Density rho_p = min(rho_p_Tmin, rho_p_Tmax) "Density of filler used to calculate TES geometry, the lower value (kg/m3)";

  //Discretization of filler and fluid phasesMasses of each particle
  parameter Integer N_f = 25 "Number of fluid finite-volume elements in the vertical z axis (-)";
  parameter Integer N_p = 1 "Number of filler finite-volume elements in the radial axis, set to 1 for lumped capacitance assumption (-)";
  
  parameter SI.Length dz = H_tank / N_f "Length of each finite-volume element in the z axis (m)";

  //Vertical positions and masses of finite-volume elements
  parameter SI.Length z_f[N_f] = Z_position(H_tank, N_f) .+ z_offset "z-positions of each vertical element, used for plotting (m)";
  parameter Real ZDH[N_f] = Relative_Tank_Axes(H_tank, N_f) "Non-dimensional z-position of each vertical element, used for plotting (-)";
  parameter SI.Mass m_p[N_f] = fill((1.0-epsilon)*CN.pi*D_tank*D_tank*H_tank*rho_p/(4.0*N_f), N_f) "Mass of each finite volume filler element (kg)";
  
  //Costing parameters of the TES and intermediate calculations (all indexed to USD_2022)
  parameter Real C_fluid = 0.0 "FOB cost of fluid, set to zero as air is free (USD_2022)";
  parameter Real C_insulation = SolarTherm.Utilities.Finances.Insulation.FOB_Insulation_Mullite_HBS(T_max,U_loss_top,A_insulation) "FOB Cost of tank insulation, calculated via a regression function (USD_2022)";
  parameter Real C_tank = SolarTherm.Utilities.Finances.Equipment.Bins.FOB_Bin_CS(V_vessel) "FOB cost of a carbon steel bin based on Seider (USD_2022)"; 
  parameter Real C_filler = sum(m_p)*Filler_Package.cost*SolarTherm.Utilities.Finances.r_CEPCI(2022,Filler_Package.year) "FOB cost of checkerbrick material (USD_2022)";
  parameter Real C_encapsulation = 0.0 "FOB cost of encapsulation material, set to zero as no filler encapsulation is used (USD_2022)";
  

  
  parameter Real C_section = C_fluid + C_filler + C_insulation + C_tank + C_encapsulation "Total FOB cost of this TES section (USD_2022)";
  

  
  //Thickness and surface area of insulation material
  parameter SI.Length t_insulation = SolarTherm.Utilities.Finances.Insulation.Thickness_Insulation_Mullite_HBS(T_max,U_loss_top) "Thickness of insulation (m)";
  
  parameter SI.Area A_insulation = 0.5*CN.pi*(D_tank+2.0*t_insulation)^2 + CN.pi*(D_tank+2.0*t_insulation)*(H_tank+2.0*t_insulation) "Outer surface area of insulation (m2)";
  
  parameter SI.Volume V_vessel = 0.25*CN.pi*((D_tank+2.0*t_insulation)^2)*(H_tank+2.0*t_insulation) "Volume of the metal vessel after considering insulation (m3)";

  //Variables
  //Fluid Property Arrays
  SI.Temperature T_f[N_f] "Fluid temperature array (K)";
  SI.SpecificEnthalpy h_f[N_f] "Fluid enthalpy array (J/kg)";
  
  //Filler Property Arrays
  SI.Temperature T_p[N_f](start = T_p_start) "Filler temperature array (K)";
  SI.SpecificEnthalpy h_p[N_f] "Filler enthalpy array (J/kg)";
  Real f_p[N_f] "Filler liquid mass fraction, for PCMs (-)";
  
  //Fluid Mechanics and Heat Transfer
  Real Bi[N_f] "Biot Number array (-)";  
  Real Re[N_f] "Reynolds Number array (-)";
  Real Nu[N_f] "Nusselt Number array (-)";  
  Real Pr[N_f] "Prandtl Number array (-)";
  
  Real f_Darcy[N_f] "Darcy Friction factor array(-)";
  SI.PressureDifference p_drop[N_f] "Pressure drop across each mesh element (Pa)";
  SI.CoefficientOfHeatTransfer h_c[N_f] "Convective heat transfer coefficient array of internal flow (W/m2K)";
  SI.Temperature T_s[N_f](start = T_f_start) "Temperature of the fluid-filler interface (K)"; //Set equal to checkerbrick temperature for the lumped capacitance case
  SI.PressureDifference p_drop_total "Total pressure drop along the TES (Pa)";
  
  //Inlets and Outlets
  SI.SpecificEnthalpy h_in "Fluid inlet enthalpy, depends on mass flow direction (J/kg)";
  SI.SpecificEnthalpy h_out "Fluid outlet enthalpy, depends on mass flow direction (J/kg)";
  SI.Temperature T_in "Fluid inlet temperature, depends on mass flow direction";
  SI.Temperature T_out "Fluid outlet temperature, depends on mass flow direction";
  
  //Mass flow rates and fluid averaged velocity
  SI.MassFlowRate m_flow(start = 0.0) "Inlet and outlet fluid flow rate, -ve if charging, +ve if discharging (kg/s)";
  SI.Velocity u_flow "Inlet and outlet fluid flow velocity, -ve if charging, +ve if discharging (m/s)";
  
  //Operational Controls
  Integer State(start = 2) "Operational state of TES. 1 = Charging, 2 = Standby, 3 = Discharging";

  //Analytics
  SI.Energy E_stored(start = 0.0) "Stored energy, correct if TES starts at T_min (J)";
  Real Level(start = 0.0) "TES level, state of charge, correct if TES starts at T_min, ranges from 0 to 1 (-)";
  SI.HeatFlowRate Q_dot_loss_total "Total heat loss rate from this TES section (J/s)";
  SI.Power W_dot_loss_pump "Total pumping power consumption to overcome pressure drop (W)";
  
  //Ambient conditions
  SI.Temperature T_amb "Ambient temperature (K)";
  
protected
  //Variables located in the "protected" section are not saved in  the result file.
  //Fluid Variable Arrays
  Fluid_Package.State fluid[N_f] "Array of fluid state models";
  SI.ThermalConductivity k_f[N_f] "Fluid thermal conductivity array (W/mK)";
  SI.DynamicViscosity mu_f[N_f] "Fluid dynamic viscosity array (Pa.s)";
  SI.SpecificHeatCapacity c_pf[N_f] "Fluid specific heat capacity array, only used to estimate heat transfer coefficient (J/kgK)";
  
  //Filler Variable Arrays
  Filler_Package.State filler[N_f] "Array of filler state models";
  SI.ThermalConductivity k_p[N_f] "Filler thermal conductivity array (W/mK)";
  SI.ThermalConductance U_p_up[N_f] "Thermal conductance between a filler element and the one on top of it, position i + 1 (K/W)";
  
  //Thermal Losses
  SI.HeatFlowRate Q_dot_loss_wall[N_f] "Heat loss from cylinder";
  SI.HeatFlowRate Q_dot_loss_top "Heat loss from the top";
  SI.HeatFlowRate Q_dot_loss_bot "Heat loss from the bottom";
  
  //Fluid Properties
  Real der_h_f[N_f] "rate of change of h_f calculated explicitly in the algorithm section to speed up calculations (J/kg.s)";

algorithm
  //Fluid advection-conduction equations solved explicitly in the algorithm section
  
  if State == 1 then
    der_h_f[1] := ((-2.0 * k_f[1] * k_f[2]) * (T_f[1] - T_f[2]) / ((k_f[1] + k_f[2]) * dz * dz) + rho_f_avg * u_flow * (h_f[1] - h_f[2]) / dz - 4.0 * h_c[1] * (T_f[1] - T_s[1]) / (d_p)) / rho_f_avg;
    h_out := h_f[1];
    for i in 2:N_f - 1 loop
      der_h_f[i] := (2.0 * k_f[i - 1] * k_f[i] * (T_f[i - 1] - T_f[i]) / ((k_f[i - 1] + k_f[i]) * dz * dz) - 2.0 * k_f[i] * k_f[i + 1] * (T_f[i] - T_f[i + 1]) / ((k_f[i] + k_f[i + 1]) * dz * dz) + rho_f_avg * u_flow * (h_f[i] - h_f[i + 1]) / dz - 4.0 * h_c[i] * (T_f[i] - T_s[i]) / (d_p)) / rho_f_avg;
    end for;
    der_h_f[N_f] := (2.0 * k_f[N_f - 1] * k_f[N_f] * (T_f[N_f - 1] - T_f[N_f]) / ((k_f[N_f - 1] + k_f[N_f]) * dz * dz) + rho_f_avg * u_flow * (h_f[N_f] - h_in) / dz - 4.0 * h_c[N_f] * (T_f[N_f] - T_s[N_f]) / (d_p)) / rho_f_avg;
  else
    der_h_f[1] := ((-2.0 * k_f[1] * k_f[2] * (T_f[1] - T_f[2]) / ((k_f[1] + k_f[2]) * dz * dz)) + rho_f_avg * u_flow * (h_in - h_f[1]) / dz - 4.0 * h_c[1] * (T_f[1] - T_s[1]) / (d_p)) / rho_f_avg;
    for i in 2:N_f - 1 loop
      der_h_f[i] := (2.0 * k_f[i - 1] * k_f[i] * (T_f[i - 1] - T_f[i]) / ((k_f[i - 1] + k_f[i]) * dz * dz) - 2.0 * k_f[i] * k_f[i + 1] * (T_f[i] - T_f[i + 1]) / ((k_f[i] + k_f[i + 1]) * dz * dz) + rho_f_avg * u_flow * (h_f[i - 1] - h_f[i]) / dz - 4.0 * h_c[i] * (T_f[i] - T_s[i]) / (d_p)) / rho_f_avg;
    end for;
    der_h_f[N_f] := (2.0 * k_f[N_f - 1] * k_f[N_f] * (T_f[N_f - 1] - T_f[N_f]) / ((k_f[N_f - 1] + k_f[N_f]) * dz * dz) + rho_f_avg * u_flow * (h_f[N_f - 1] - h_f[N_f]) / dz - 4.0 * h_c[N_f] * (T_f[N_f] - T_s[N_f]) / (d_p)) / rho_f_avg;
    h_out := h_f[N_f];
  end if;

initial equation
  for i in 1:N_f loop
    fluid[i].h = h_f_start[i]; //Set initial enthalpy array of the fluid
    filler[i].h = h_p_start[i]; //Set initial enthalpy array of the filler
  end for;
  
equation
  //These calculations are performed for every element in the vertical direction
  for i in 1:N_f loop
    //Evaluate properties of fluid based on specific enthalpy h_f (J/kg)
    fluid[i].h = h_f[i];
    T_f[i] = fluid[i].T;
    c_pf[i] = fluid[i].cp;
    k_f[i] = fluid[i].k;
    mu_f[i] = fluid[i].mu;
    //Evaluate properties of filler based on specific enthalpy h_p (J/kg)
    filler[i].h = h_p[i];
    T_p[i] = filler[i].T;
    f_p[i] = filler[i].f;
    k_p[i] = filler[i].k;
    //Set the time-derivative of fluid enthalpy for each vertical element to that calculated explicitly in the algorithm section
    der(h_f[i]) = der_h_f[i];
    //Set the Fluid-filler interface surface temperature in each vertical element to that of the filler, this is a result of the lumped capacitance assumption.
    T_s[i] = T_p[i];
    //Pressure drop is calculated based on SwameeJain approximation of the CoolBrook equation
    f_Darcy[i] = SolarTherm.Utilities.HeatTransfer.TubeRough.f_Darcy_SwameeJain(Re[i],E_div_d);
    p_drop[i] = 0.5*f_Darcy[i]*dz*rho_f_avg*u_flow*u_flow/d_p;
    //Convective Heat-Transfer Equations
    //Biot Number estimation
    Bi[i] = h_c[i]*L_char_solid/k_p[i];
    Pr[i] = c_pf[i] * mu_f[i] / k_f[i];
    //Treat Reynolds number as zero if fluid velocity is very small
    if abs(u_flow) > 1e-12 then
      Re[i] = rho_f_avg * d_p * abs(u_flow) / mu_f[i];
      Nu[i] = SolarTherm.Utilities.HeatTransfer.TubeRough.Nusselt_SwameeJain_GowenSmith(Re[i],Pr[i],E_div_d);
    else
      Re[i] = 0;
      Nu[i] = 3.66;
    end if;
    //Calculate convective heat transfer coefficient based on Nusselt number
    h_c[i] = Nu[i]*k_f[i]/d_p;
  end for;

  //Calculate averaged fluid velocity
  u_flow = m_flow / (epsilon * rho_f_avg * A);

  //Filler Heat Transfer equations
  //Calculate vertical thermal conductance (W/K) between element i and i+1
  for i in 1:N_f-1 loop
    U_p_up[i] = 0.5*k_p[i]*k_p[i+1]*(1.0-epsilon)*CN.pi*D_tank*D_tank/((k_p[i]+k_p[i+1])*dz);
  end for;
  U_p_up[N_f] = 0.0; //There is nothing on top of it

  //Energy balance in each filler element
  //Bottom element
  m_p[1] * der(h_p[1]) = -1.0*U_p_up[1]*(T_p[1]-T_p[2]) +
    h_c[1] * D_tank * D_tank * epsilon * CN.pi * dz * (T_f[1] - T_s[1]) / d_p - U_loss_array[1]*A_loss_wall_i*(T_p[1]-T_amb) - U_loss_bot*A*(T_p[1]-T_amb);
  //Middle elements
  for i in 2:N_f-1 loop
    m_p[i] * der(h_p[i]) = U_p_up[i-1]*(T_p[i-1]-T_p[i]) - U_p_up[i]*(T_p[i]-T_p[i+1]) + h_c[i] * D_tank * D_tank * epsilon* CN.pi * dz * (T_f[i] - T_s[i]) / d_p -U_loss_array[i]*A_loss_wall_i*(T_p[i]-T_amb);
  end for;
  //Top element
  m_p[N_f] * der(h_p[N_f]) = U_p_up[N_f-1]*(T_p[N_f-1]-T_p[N_f]) + h_c[N_f] * D_tank * D_tank * epsilon* CN.pi * dz * (T_f[N_f] - T_s[N_f]) / d_p -U_loss_array[N_f]*A_loss_wall_i*(T_p[N_f]-T_amb) - U_loss_top*A*(T_p[N_f]-T_amb);

  //Control Equations
  //Operational State is determined based on the direction of mass flow
  if m_flow < 0.0 then //mass is flowing downwards so charging
    State = 1;
  else //mass is flowing upwards so discharging, also includes the zero mass flow case
    State = 3;
  end if;

  //Analytics
  //Determine inlet and outlet fluid properties based on enthalpy
  fluid_in.h = h_in;
  fluid_out.h = h_out;
  fluid_in.T = T_in;
  fluid_out.T = T_out;

  //Determine the rate of heat loss from top, bottom and side walls of the TES cylinder
  Q_dot_loss_top = U_loss_top*A*(T_p[N_f]-T_amb);
  Q_dot_loss_bot = U_loss_bot*A*(T_p[1]-T_amb);
  for i in 1:N_f loop
    Q_dot_loss_wall[i] = U_loss_array[i]*A_loss_wall_i*(T_p[i]-T_amb);
  end for;
  //Calculate total heat loss rate for the entire TES
  Q_dot_loss_total = Q_dot_loss_top + sum(Q_dot_loss_wall) + Q_dot_loss_bot;

  //The rate of change of stored TES energy is calculated using energy balance equation
  der(E_stored) = abs(m_flow) * (h_in - h_out) - Q_dot_loss_total;
  
  //State of charge is the stored energy divided by ideal storage capacity
  Level = E_stored / E_max;

  //Calculate total pressure drop and total pumping power required to overcome it
  p_drop_total = sum(p_drop);
  W_dot_loss_pump = (abs(m_flow) / rho_f_avg) * (p_drop_total / eff_pump);
  annotation(
    Documentation(revisions = "<html>
		<p>By Zebedee Kee on 03/12/2020</p>
		</html>", info = "<html><head></head><body><p><b>Model Description</b></p><p>Heat transfer model of a thermal energy storage (TES) component based on a the checkerwork (checkerbrick stack) in a hot-blast-stove regenerator.</p><p><b>Discretisation Scheme</b></p><p>Fluid: 1D convection-advection in the vertical (z) axis.</p><p>Filler: 1D conduction in the vertical (z) axis. Lumped in the radial direction</p><p>Fluid-Filler heat transfer: Nusselt-number correlation for internal flow through rough pipes.</p><p><b>Assumptions</b></p><p>Averaged fluid density, inlet/outlet fluid mass flow rates are always equal to each other.</p>
		</body></html>"));
end LC_Section_Final;