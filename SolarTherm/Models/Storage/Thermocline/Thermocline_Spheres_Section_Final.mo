within SolarTherm.Models.Storage.Thermocline;

model Thermocline_Spheres_Section_Final
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;

  //Initialize Material Packages
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial "Fluid Package";
  replaceable package Filler_Package = SolarTherm.Materials.PartialMaterial "Filler Package";
  replaceable package Tank_Package =  SolarTherm.Materials.SS316L "Tank Package (steel shell)";
  replaceable package Encapsulation_Package = Filler_Package "Encapsulation Package, default is the same as Filler package, effectively no encapsulation";

  //Fluid Material States
  Fluid_Package.State fluid_in "Model which calculates properties at inlet of the section";
  Fluid_Package.State fluid_out "Model which calculates properties at outlet of the section";

  //Interfacial heat transfer Settings
  parameter Integer Correlation = 3 "1=WakaoKaguei, 2=MelissariArgyropolus, 3=Conservative, 4=Bellan, 5=Laminar, 6=Laminar+Turbulent, 7 = Nie";
  
  //Height offset for plotting purposes
  parameter SI.Length z_offset = 0.0 "Amount of height offset if there is a tank below it";
  
  //Tank Design parameters
  parameter SI.Energy E_max = 144e9 "Design storage capacity";
  parameter Real ar = 2.0 "Tank Aspect ratio H/D";
  parameter Real eta = 0.22 "Porosity";
  parameter Real d_p = 0.015 "Diameter of sphere (particle) (m)";
  parameter Real t_e = d_p/(2.0*N_p) "Thickness of encapsulation, default is such that it is at a value that preserves equidistant radii discretizations (m)";
  
  //Temperature Bounds
  parameter SI.Temperature T_min = CV.from_degC(620) "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = CV.from_degC(820) "Design hot Temperature of everything in the tank (K)";
  parameter SI.Temperature T_start = T_min "Initial (uniform) temperature of all components (K), defaults to T_min";
  
  //Calculated Tank Design Parameters
  parameter SI.Length H_tank = (4 * E_max / (CN.pi * (1 / ar) ^ 2 * (rho_f_avg * (h_f_max - h_f_min) * eta + rho_p * (h_p_max - h_p_min) * (1.0 - eta)))) ^ (1 / 3);
  parameter SI.Diameter D_tank = H_tank / ar;
  parameter SI.Area A = CN.pi * D_tank * D_tank / 4.0 "Cross sectional area of tank";
  
  //Thermal Losses
  SI.Temperature T_amb;
  parameter SI.Area A_loss_tank = CN.pi*D_tank*D_tank*2.0 + CN.pi*D_tank*H_tank "Heat loss area (m2)";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1 "Heat loss coeff of surfaces (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_wall = U_loss_tank "Cylinder wall heat loss coeff (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_top = U_loss_tank "Top circle heat loss coeff (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_bot = U_loss_tank "Bottom circle heat loss coeff (W/m2K)";
  
  //Inititalize temperature and enthalpy profile
  parameter SI.Temperature T_f_start[N_f] = fill(T_start,N_f);
  parameter SI.Temperature T_p_start[N_f,N_p] = fill(fill(T_start, N_p), N_f);
  parameter SI.Temperature T_e_start = T_start;
  parameter SI.SpecificEnthalpy h_f_start[N_f] = fill(Fluid_Package.h_Tf(T_start, 0.0), N_f) "Defaults to uniform";
  parameter SI.SpecificEnthalpy h_p_start[N_f, N_p] = fill( cat(1,fill(Filler_Package.h_Tf(T_start, 0.0), N_p-1), {Encapsulation_Package.h_Tf(T_start, 0.0)}) , N_f) "Defaults to uniform";
  //Property bounds
    //Fluid
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min,0) "Starting enthalpy of the HTF";
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max,0) "Starting enthalpy of the HTF";
  parameter SI.Density rho_f_min = Fluid_Package.rho_Tf(T_min,0);
  parameter SI.Density rho_f_max = Fluid_Package.rho_Tf(T_max,0);
  parameter SI.Density rho_f_avg = (rho_f_min + rho_f_max) / 2;
    //Filler
  parameter SI.SpecificEnthalpy h_p_max = Filler_Package.h_Tf(T_max, 1.0);
  parameter SI.SpecificEnthalpy h_p_min = Filler_Package.h_Tf(T_min, 0.0);
  parameter SI.Density rho_p_min = Filler_Package.rho_Tf(T_min, 0.0);
  parameter SI.Density rho_p_max = Filler_Package.rho_Tf(T_max, 1.0);
  parameter SI.Density rho_p = min(rho_p_min,rho_p_max) "kg/m3";
    //Encapsulation
  parameter SI.SpecificEnthalpy h_e_max = Encapsulation_Package.h_Tf(T_max, 1.0);
  parameter SI.SpecificEnthalpy h_e_min = Encapsulation_Package.h_Tf(T_min, 0.0);
  parameter SI.Density rho_e_min = Encapsulation_Package.rho_Tf(T_min, 0.0);
  parameter SI.Density rho_e_max = Encapsulation_Package.rho_Tf(T_max, 1.0);
  parameter SI.Density rho_e = min(rho_e_min,rho_e_max) "kg/m3";
  
    //Discretization
  parameter SI.Length dz = H_tank / N_f "discretization vertical length of fluid";
  parameter SI.Length dr[N_p] = cat(1,fill(0.5 * ((d_p - 2.0*t_e) / (N_p - 1)),N_p-1),{t_e}) "radial thickness of each particle discretization, with last one being the encapsulation"; 

  parameter Integer N_f = 25 "Number of finite volume elements in fluid";
  parameter Integer N_p = 10 "Number of finite volume elements in filler, including encapsulation";

  //Initialise Fluid Array
  parameter SI.Length z_f[N_f] = Z_position(H_tank, N_f) .+ z_offset;
  SI.Temperature T_f[N_f] "(K)";
  SI.SpecificEnthalpy h_f[N_f](start = h_f_start) "J/kg";

  //Plotting
  parameter Real ZDH[N_f] = Relative_Tank_Axes(H_tank, N_f) "Non-dimensional tank vertical axis";
  
  //Operational Controls
  Integer State(start = 2) "operational state 2=standby, 3=discharge, 1=charge";

  //Inlet and outlet enthalpies and temperatures
  SI.SpecificEnthalpy h_in "Inlet Enthalpy depends on mass flow direction (J/kg)";
  SI.SpecificEnthalpy h_out "Outlet Enthalpy depends on mass flow direction (J/kg)";
  SI.Temperature T_in "Inlet Temperature depends on mass flow direction";
  SI.Temperature T_out "Outlet Temperature depends on mass flow direction";
  
  //Mass flow rates and superficial velocity
  SI.MassFlowRate m_flow(start=0.0) "kg/s";
  SI.Velocity u_flow "Fluid velocity in packed bed (m/s)";
  SI.Velocity u_0 "Fluid velocity through empty cross section = u_flow/eta (m/s)";
  
  //Analytics
  SI.Energy E_stored(start = 0.0) "Make sure the tank starts from T_min for this to be correct";
  Real Level(start = 0.0) "Tank energy charging level (0-1)";
  SI.HeatFlowRate Q_loss_total "Heat loss from the entire surface area";
  
  //Initialise Particle
  SI.Temperature T_p[N_f, N_p](start = T_p_start) "Temperature of particle elements";
  
  //Initialise Encapsulation
  //SI.Temperature T_e[N_f](start=T_e_start) "Temperature of encapsulation elements";
  //SI.SpecificEnthalpy h_e[N_f](start = h_e_min) "J/kg";
  //SI.ThermalConductivity k_e[N_f] "W/mK";
  
  //Calculated Pumping Losses
  parameter Real eff_pump = 1.00 "Pump electricity to work efficiency";
  SI.Pressure p_drop_total "Sum of all pressure drops";
  SI.Power W_loss_pump "losses due to pressure drop";
  
  //Cost breakdown
  parameter Real C_fluid = max(rho_f_max,rho_f_min)*eta*(CN.pi*D_tank*D_tank*H_tank/4.0)*Fluid_Package.cost;
  parameter Real C_section = C_fluid + C_filler + C_insulation + C_tank + C_encapsulation;
  //parameter Real C_insulation = if U_loss_tank > 1e-3 then (16.72/U_loss_tank + 0.04269)*A_loss_tank else 0.0;
  parameter Real C_insulation = if U_loss_tank > 1e-3 then CpA_external_insulation(T_max,U_loss_tank)*A_loss_tank else 0.0;
  
  parameter SI.Density rho_bulk = eta*max(rho_f_max,rho_f_min)+(1.0-eta)*rho_p "Bulk density used to calculate hydrostatic pressure";
  parameter Real C_tank = C_shell(max(rho_f_max,rho_f_min),H_tank,D_tank,Tank_Package.sigma_yield(T_max),Tank_Package.rho_Tf(298.15,0.0),Tank_Package.cost,4.0);
  
  parameter Real C_filler = (if abs(Filler_Package.MM - Encapsulation_Package.MM) < 1e-6 then rho_p*(1.0-eta)*(CN.pi*D_tank*D_tank*H_tank/4.0)*Filler_Package.cost else rho_p*(1.0-eta)*(CN.pi*D_tank*D_tank*H_tank/4.0)*Filler_Package.cost*(((d_p-2*t_e)/d_p)^3));
  parameter Real C_encapsulation = (if abs(Filler_Package.MM - Encapsulation_Package.MM) < 1e-6 then 0.0 else rho_e*(1.0-eta)*(CN.pi*D_tank*D_tank*H_tank/4.0)*Encapsulation_Package.cost*(1-(((d_p-2*t_e)/d_p)^3)));

  //Filler Surface Area Correction
  parameter Real f_surface = 1.0 "Don't touch this";
  
  //Initialise Filler surface temperature
  SI.Temperature T_s[N_f](start = T_f_start);
  
  parameter SI.Length r_p[N_p] = cat(1,Particle_Radii(d_p-2*t_e,N_p-1),{(d_p/2)-(t_e/2)}) "Radii of each particle element centre";
  //Filler mass-liquid fraction
  Real f_p[N_f, N_p](start=fill(fill(0.0,N_p),N_f)) "Mass liquid fraction of filler";

  
protected  
  //Convection Properties
  Real Pe[N_f] "Peclet Number";
  Real Bi[N_f] "Biot Number";
  Real Re[N_f] "Reynolds";
  Real Pr[N_f] "Prandtl";
  Real Nu[N_f] "Nusselt";
  Real h_v[N_f] "Volumetric heat transfer coeff (W/m3K)";
  //SI.ThermalConductance U_in[N_f, N_p] "K/W"; //Obsolete
  SI.ThermalConductance U_out[N_f, N_p] "K/W";
  //SI.ThermalConductance U_out_e[N_f] "K/W";
  
  //Filler Properties
  SI.SpecificEnthalpy h_p[N_f, N_p](start=h_p_start) "J/kg";
  SI.ThermalConductivity k_p[N_f, N_p] "W/mK";
  
  //Filler Geometry
  parameter Real N_spheres_total = (N_f*6*(1-eta)*A*dz/(CN.pi*(d_p^3))) "Total number of spheres in the tank";

  parameter SI.Mass m_p[N_f, N_p] = fill(cat(1,Particle_Masses(d_p-2*t_e, N_p-1, rho_p),{rho_e*(1/6)*CN.pi*((d_p^3)-((d_p-2*t_e)^3))}), N_f) "Masses of each particle element";
  //parameter SI.Mass m_e = rho_e*(1/6)*CN.pi*((d_p^3)-((d_p-2*t_e)^3)) "Masses of encapsulation in one particle";
  //Pressure Drop
  SI.Pressure p_drop[N_f] "Pressure drop across each mesh element";
  
  //Thermal Losses
  SI.HeatFlowRate Q_loss_wall[N_f] "Heat loss from the wall";
  SI.HeatFlowRate Q_loss_top "Heat loss from the top";
  SI.HeatFlowRate Q_loss_bot "Heat loss from the bottom";
  
  //Fluid Properties
  SI.ThermalConductivity k_f[N_f] "W/mK";
  //SI.ThermalConductivity k_eff[N_f] "W/mK";
  SI.DynamicViscosity mu_f[N_f] "Pa.s";
  SI.SpecificHeatCapacity c_pf[N_f] "J/kgK";
  Fluid_Package.State fluid[N_f](each h_start = h_f_min) "Fluid object array";
  
  //Try filler state "Remove this if using function-based calculation"
  Filler_Package.State filler[N_f,N_p-1] "Filler object array";
  
  Encapsulation_Package.State encapsulation[N_f] "Encapsulation object array";

  Real der_h_f[N_f] "Rate of change of specific enthalpy of fluid";
algorithm
  //Fluid equations
  if State == 1 then
  //Charging (Mass flows top to bottom)
  //Bottom Charging Fluid Node
    der_h_f[1] :=
    ( (-2.0*k_f[1]*k_f[2])*(T_f[1]-T_f[2])/((k_f[1]+k_f[2])*dz*dz)
    + (rho_f_avg*u_flow)*(h_f[1]-h_f[2])/dz
    - h_v[1]*(T_f[1] - T_s[1])/eta
    - U_bot*(T_f[1]-T_amb)/(eta*dz) 
    - U_wall*CN.pi*D_tank*(T_f[1]-T_amb)/(eta*A) ) / (rho_f_avg);
    
    h_out := h_f[1];
  //End Bottom Charging Fluid Node
  //Middle Charging Fluid Nodes
    for i in 2:N_f - 1 loop
      der_h_f[i] := 
      ( 2.0*k_f[i - 1]*k_f[i]*(T_f[i-1]-T_f[i])/((k_f[i-1]+k_f[i])*dz*dz)
      - 2.0*k_f[i]*k_f[i+1]*(T_f[i]-T_f[i + 1])/((k_f[i]+k_f[i+1])*dz*dz)
      + (rho_f_avg*u_flow)*(h_f[i]-h_f[i+1])/dz
      - h_v[i]*(T_f[i]-T_s[i])/eta
      - U_wall*CN.pi*D_tank*(T_f[i]-T_amb)/(eta*A) )/ (rho_f_avg);
    end for;
  //End Middle Charging Fluid Nodes
  //Top Charging Fluid Node
    der_h_f[N_f] := 
    (2.0*k_f[N_f-1]*k_f[N_f]*(T_f[N_f-1]-T_f[N_f])/((k_f[N_f-1]+k_f[N_f])*dz*dz)
    + (rho_f_avg*u_flow)*(h_f[N_f]-h_in)/dz
    - h_v[N_f]*(T_f[N_f]-T_s[N_f])/eta
    - U_wall*CN.pi*D_tank*(T_f[N_f]-T_amb)/(eta*A)
    - U_top*(T_f[N_f]-T_amb)/(eta*dz) ) / (rho_f_avg);
  //End Top Charging Fluid Node
  else
  //Discharge (Mass flows bottom to top)
  //Bottom Discharge Node
    der_h_f[1] :=
    (-2.0*k_f[1]*k_f[2]*(T_f[1]-T_f[2])/((k_f[1]+k_f[2])*dz*dz)
    + (rho_f_avg*u_flow)*(h_in-h_f[1])/dz
    - h_v[1]*(T_f[1]-T_s[1])/eta
    - U_bot*(T_f[1]-T_amb)/(eta*dz)
    - U_wall*CN.pi*D_tank*(T_f[1]-T_amb)/(eta*A) )/ (rho_f_avg);
  //End Bottom Discharge Node
  //Middle Discharge Nodes
    for i in 2:N_f - 1 loop
      der_h_f[i] :=
      ( 2.0*k_f[i-1]*k_f[i]*(T_f[i-1]-T_f[i])/((k_f[i-1]+k_f[i])*dz*dz)
      - 2.0*k_f[i]*k_f[i + 1]*(T_f[i]-T_f[i+1])/((k_f[i]+k_f[i+1])*dz*dz)
      + (rho_f_avg*u_flow)*(h_f[i-1]-h_f[i])/dz
      - h_v[i]*(T_f[i]-T_s[i])/eta
      - U_wall*CN.pi*D_tank*(T_f[i]-T_amb)/(eta*A) ) / (rho_f_avg);
    end for;
  //End Middle Discharge Nodes
  //Top Discharge Node
    der_h_f[N_f] :=
    ( 2.0*k_f[N_f-1]*k_f[N_f]*(T_f[N_f-1]-T_f[N_f])/((k_f[N_f-1]+k_f[N_f])*dz*dz)
    + (rho_f_avg*u_flow)*(h_f[N_f-1]-h_f[N_f])/dz
    - h_v[N_f]*(T_f[N_f]-T_s[N_f])/eta
    - U_wall*CN.pi*D_tank*(T_f[N_f]-T_amb)/(eta*A)
    - U_top*(T_f[N_f]-T_amb)/(eta*dz) ) / (rho_f_avg);
    
    h_out := h_f[N_f];
  end if;

initial equation
  for i in 1:N_f loop
    fluid[i].h = h_f_start[i];
    for j in 1:N_p-1 loop
      filler[i,j].h = h_p_start[i,j];
    end for;
    encapsulation[i].h = h_p_start[i,N_p];
  end for;
equation
  for i in 1:N_f loop
    der_h_f[i] = der(h_f[i]);
  end for;
  //Determine which operational state: In this version, standby and discharge are lumped.
  if m_flow < 0.0 then //mass is flowing downwards so charging
    State = 1;
  else //mass is flowing upwards so discharging
    State = 3;
  end if;

  u_flow = m_flow / (eta * rho_f_avg * A); //positive if flowing upwards (discharge)
  u_0 = u_flow*eta; //Velocity through empty cross-section
  //Fluid inlet and outlet properties
  fluid_in.h = h_in;
  fluid_out.h = h_out;
  fluid_in.T = T_in;
  fluid_out.T = T_out;


  //Fluid Property evaluation SolarSalt
  for i in 1:N_f loop
    h_f[i] = fluid[i].h;
    T_f[i] = fluid[i].T;
    c_pf[i] = fluid[i].cp;
    k_f[i] = fluid[i].k;
    //k_eff[i] = eta*fluid[i].k; //Effective thermal conductivity of fluid (weighted by porosity)
    mu_f[i] = fluid[i].mu;

  end for;
  //Particle Property evaluation quartzite and sand
  for i in 1:N_f loop
    for j in 1:N_p-1 loop
      /*
      //Function-based calculation of filler state
      f_p[i,j] = Filler_Package.f_h(h_p[i,j]);
      T_p[i,j] = Filler_Package.T_h(h_p[i,j]);
      k_p[i,j] = Filler_Package.k_Tf(T_p[i,j],f_p[i,j]); 
      */
      
      filler[i,j].h = h_p[i,j];
      T_p[i,j] = filler[i,j].T;
      f_p[i,j] = filler[i,j].f;
      k_p[i,j] = filler[i,j].k;
      
    end for;
    //encapsulation property evaluation
    encapsulation[i].h = h_p[i,N_p];
    T_p[i,N_p] = encapsulation[i].T;
    k_p[i,N_p] = encapsulation[i].k;
    f_p[i,N_p] = encapsulation[i].f;
  end for;
  //Convection Equations
  for i in 1:N_f loop
    Bi[i] = (Nu[i]*k_f[i])/(6.0*k_p[i,N_p]); //Use outermost shell conductivity
    Pe[i] = Re[i]*Pr[i];
    if abs(u_flow) > 1e-12 then //There is actually mass flowing
      Re[i] = rho_f_avg * d_p * abs(u_0) / mu_f[i]; //Use superficial velocity u_0 instead of intersitial velocity u_flow
      Pr[i] = c_pf[i] * mu_f[i] / k_f[i];
      if Correlation == 1 then 
        Nu[i] = 2.0 + 1.1 * (Re[i] ^ 0.6) * (Pr[i] ^ (1 / 3)); //Wakao and Kaguei
      elseif Correlation == 2 then
        Nu[i] = 2.0 + 0.47 * (Re[i] ^ 0.5) * (Pr[i] ^ 0.36);//Use Melissari and Argyropolus
      elseif Correlation == 3 then
        Nu[i] = 2.0; //Conservative
      elseif Correlation == 4 then
        Nu[i] = 2.0 + 0.664*(Re[i]^0.5)*(Pr[i]^(1/3)); //Only laminar
      elseif Correlation == 5 then //laminar plus turbulent
        Nu[i] = (1.0+1.5*(1.0-eta))*(2.0+((0.664*(Re[i]^0.5)*((Pr[i])^(1.0/3.0)))^2.0+((0.037*(Re[i]^0.8)*Pr[i])/(1.0+2.443*(Re[i]^(-0.1))*((Pr[i]^(2/3))-1)))^2)^0.5);
      elseif Correlation == 6 then//Nie
        Nu[i] = 0.052*(((1.0-eta)^0.14)/eta)*(Re[i]^0.86)*(Pr[i]^(1/3));
      else
        Nu[i] = (2.06/eta)*(Re[i]^0.425)*(Pr[i]^(1/3));
      end if;
    else
      Re[i] = 0;
      Pr[i] = 0;
      Nu[i] = 2.0;
    end if;
    h_v[i] = (f_surface)*6.0 * (1.0 - eta) * Nu[i] * k_f[i] / (d_p * d_p); //Note that filler surface area correction factor is applied elsewhere.
  end for;
  
  //Particle Equations
  for i in 1:N_f loop
    U_out[i, 1] = 4.0*k_p[i, 1]*k_p[i, 2]*CN.pi*r_p[1]*(r_p[1]+dr[1])*(2.0*r_p[1]+dr[1])/(dr[1]*(k_p[i,2]*dr[1]+k_p[i,1]*r_p[1]+k_p[i, 2]*r_p[1]));
    der(h_p[i, 1]) = (U_out[i, 1]*(T_p[i, 2]-T_p[i, 1])) / m_p[i, 1];
  //End Inner Particle Shell
  //Middle Particle Shells
    for j in 2:N_p - 1 loop
      U_out[i,j] = 4.0*k_p[i, j]*k_p[i,j+1]*CN.pi*r_p[j]*(r_p[j]+dr[j])*(2.0*r_p[j]+dr[j])/(dr[j]*(k_p[i,j+1]*dr[j]+k_p[i,j]*r_p[j]+k_p[i,j+1]*r_p[j]));
      der(h_p[i,j]) = (U_out[i,j]*(T_p[i,j+1]-T_p[i,j]) - U_out[i,j-1]*(T_p[i,j]-T_p[i,j-1])) / m_p[i, j];
    end for;
  //End Middle Particle Shells
  //Outer Particle Shell
    U_out[i,N_p] = 8.0*CN.pi*k_p[i,N_p]*r_p[N_p]*(r_p[N_p]+0.5*dr[N_p])/dr[N_p];
    der(h_p[i,N_p]) = (U_out[i, N_p]*(T_s[i]-T_p[i, N_p]) - U_out[i, N_p-1]*(T_p[i, N_p]-T_p[i,N_p-1])) / m_p[i,N_p];
  end for;
  //Particle Surface equations energy balance
  for i in 1:N_f loop
    U_out[i, N_p] * (T_s[i] - T_p[i, N_p]) = CN.pi * (d_p ^ 3) * h_v[i] * (T_f[i] - T_s[i]) / (6.0 * (1.0 - eta));
  end for;

  
  //Heat loss calculations, different form than the equations above as they were in terms of rho*dh/dt not m*dh/dt
  Q_loss_top = U_top*CN.pi*D_tank*D_tank*0.25*(T_f[N_f]-T_amb);
  Q_loss_bot = U_bot*CN.pi*D_tank*D_tank*0.25*(T_f[1]-T_amb);
  for i in 2:N_f-1 loop
    Q_loss_wall[i] = U_wall*CN.pi*D_tank*(T_f[i]-T_amb)*dz;
  end for;
  Q_loss_wall[1] = U_wall*CN.pi*D_tank*(T_f[1]-T_amb)*0.5*dz;
  Q_loss_wall[N_f] = U_wall*CN.pi*D_tank*(T_f[N_f]-T_amb)*0.5*dz;
  Q_loss_total = Q_loss_top + sum(Q_loss_wall) + Q_loss_bot;
  //End heat loss calculations
  
  //Calculated Pumping losses
  for i in 1:N_f loop
    p_drop[i] = dz*(((600*((1-eta)^2)*mu_f[i]*abs(m_flow))/((eta^3)*(d_p^2)*rho_f_avg*CN.pi*(D_tank^2)))+((28*(1-eta)*(m_flow^2))/((eta^3)*d_p*rho_f_avg*CN.pi*CN.pi*(D_tank^4))));
  end for;
  
  p_drop_total = sum(p_drop);
  W_loss_pump = (abs(m_flow)/rho_f_avg)*p_drop_total/eff_pump;
  
  //Analyics
  der(E_stored) = abs(m_flow) * (h_in - h_out) - Q_loss_total;
  Level = E_stored / E_max;
  
  annotation (Documentation(revisions ="<html>
		<p>By Zebedee Kee on 03/12/2020</p>
		</html>",info="<html>
		<p>This model contains the heat-transfer calculations of a thermocline packed bed storage tank with spherical filler geometry. This model does not contain any fluid connectors, for the CSP component with connectors, see Thermocline_Spheres_SingleTank. Variables fluid_top and fluid_bot provides the enthalpy-temperature relationship of the fluid material. Depending on whether m_flow is positive (discharging, fluid flowing upwards) or negative (charging, fluid flowing downwards), the charging/discharging equations are applied. In this iteration of the model, discharging and standby are lumped into one state.</p>
		</html>"));
		
end Thermocline_Spheres_Section_Final;