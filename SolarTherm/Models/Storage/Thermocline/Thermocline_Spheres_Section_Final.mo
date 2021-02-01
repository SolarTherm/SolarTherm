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

  //Fluid Material States
  Fluid_Package.State fluid_in "Model which calculates properties at inlet of the section";
  Fluid_Package.State fluid_out "Model which calculates properties at outlet of the section";

  //Interfacial heat transfer Settings
  parameter Integer Correlation = 2 "1=WakaoKaguei, 2=MelissariArgyropolus, 3=Conservative, 4=Bellan, 5=Laminar, 6=Laminar+Turbulent, 7 = Nie";
  
  //Height offset for plotting purposes
  parameter SI.Length z_offset = 0.0 "Amount of height offset if there is a tank below it";
  
  //Tank Design parameters
  parameter SI.Energy E_max = 144e9 "Design storage capacity";
  parameter Real ar = 2.0 "Tank Aspect ratio H/D";
  parameter Real eta = 0.22 "Porosity";
  parameter Real d_p = 0.015 "Diameter of filler (particle) (m)";
  
  //Temperature Bounds
  parameter SI.Temperature T_min = CV.from_degC(620) "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = CV.from_degC(820) "Design hot Temperature of everything in the tank (K)";
  
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
  parameter SI.Temperature T_f_start[N_f] = fill(T_min,N_f);
  parameter SI.Temperature T_p_start[N_f,N_p] = fill(fill(T_min, N_p), N_f);
  parameter SI.SpecificEnthalpy h_f_start[N_f] = fill(h_f_min, N_f);
  parameter SI.SpecificEnthalpy h_p_start[N_f,N_p] = fill(fill(h_p_min, N_p), N_f);
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
    //Discretization
  parameter SI.Length dz = H_tank / N_f "discretization vertical length of fluid";
  parameter SI.Length dr = 0.5 * d_p / N_p "discretization radial length of particle";
  parameter Integer N_f = 25 "Number of finite volume elements in fluid";
  parameter Integer N_p = 5 "Number of finite volume elements in particles";

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
  SI.Velocity u_flow "m/s";
  
  //Analytics
  SI.Energy E_stored(start = 0.0) "Make sure the tank starts from T_min for this to be correct";
  Real Level(start = 0.0) "Tank energy charging level (0-1)";
  SI.HeatFlowRate Q_loss_total "Heat loss from the entire surface area";
  
  //Initialise Particle
  SI.Temperature T_p[N_f, N_p](start = T_p_start) "Temperature of particle elements";
  
  //Calculated Pumping Losses
  parameter Real eff_pump = 1.00 "Pump electricity to work efficiency";
  SI.Pressure p_drop_total "Sum of all pressure drops";
  SI.Power W_loss_pump "losses due to pressure drop";
  
  //Cost breakdown
  parameter Real C_fluid = min(rho_f_max,rho_f_min)*eta*(CN.pi*D_tank*D_tank*H_tank/4.0)*Fluid_Package.cost;
  parameter Real C_filler = min(rho_p_max,rho_p_min)*(1.0-eta)*(CN.pi*D_tank*D_tank*H_tank/4.0)*Filler_Package.cost;
  parameter Real C_section = C_fluid + C_filler + C_insulation + C_tank;
  parameter Real C_insulation = if U_loss_tank > 1e-3 then (16.72/U_loss_tank + 0.04269)*A_loss_tank else 0.0;
  parameter Real C_tank = C_shell(max(rho_f_max,rho_f_min),H_tank,D_tank,Tank_Package.sigma_yield(T_max),Tank_Package.rho_Tf(298.15,0.0),4.0);

  //Filler Surface Area Correction
  parameter Real f_surface = 1.0 "Don't touch this";
  
protected  
  //Convection Properties
  Real Re[N_f] "Reynolds";
  Real Pr[N_f] "Prandtl";
  Real Nu[N_f] "Nusselt";
  Real h_v[N_f] "Volumetric heat transfer coeff (W/m3K)";
  SI.ThermalConductance U_in[N_f, N_p] "K/W";
  SI.ThermalConductance U_out[N_f, N_p] "K/W";
  
  //Filler Properties
  SI.SpecificEnthalpy h_p[N_f, N_p](start = h_p_start) "J/kg";
  SI.ThermalConductivity k_p[N_f, N_p] "W/mK";
  
  //Initialise Filler surface temperature
  SI.Temperature T_s[N_f](start = T_f_start);
  
  //Filler Geometry
  parameter Real N_spheres_total = (N_f*6*(1-eta)*A*dz/(CN.pi*(d_p^3)));
  parameter SI.Length r_p[N_f, N_p] = fill(Particle_Radii(d_p, N_p), N_f) "Radii of each particle element centre";
  parameter SI.Mass m_p[N_f, N_p] = fill(Particle_Masses(d_p, N_p, rho_p), N_f) "Masses of each particle element";
  
  //Pressure Drop
  SI.Pressure p_drop[N_f] "Pressure drop across each mesh element";
  
  //Thermal Losses
  SI.HeatFlowRate Q_loss_wall[N_f] "Heat loss from the wall";
  SI.HeatFlowRate Q_loss_top "Heat loss from the top";
  SI.HeatFlowRate Q_loss_bot "Heat loss from the bottom";
  
  //Fluid Properties
  SI.ThermalConductivity k_f[N_f] "W/mK";
  SI.ThermalConductivity k_eff[N_f] "W/mK";
  SI.DynamicViscosity mu_f[N_f] "Pa.s";
  SI.SpecificHeatCapacity c_pf[N_f] "J/kgK";
  Fluid_Package.State fluid[N_f](each h_start = h_f_min) "Fluid object array";
  
  //Filler mass-liquid fraction
  Real f_p[N_f, N_p](start=fill(fill(0.0,N_p),N_f)) "Mass liquid fraction of filler";

initial equation
  for i in 1:N_f loop
    fluid[i].h = h_f_start[i];
  end for;
equation

  //Determine which operational state: In this version, standby and discharge are lumped.
  if m_flow < 0.0 then //mass is flowing downwards so charging
    State = 1;
  else //mass is flowing upwards so discharging
    State = 3;
  end if;

  u_flow = m_flow / (eta * rho_f_avg * A); //positive if flowing upwards (discharge)

  //Fluid inlet and outlet properties
  fluid_in.h = h_in;
  fluid_out.h = h_out;
  fluid_in.T = T_in;
  fluid_out.T = T_out;

  //Fluid Equations
  if State == 1 then
  //Charging (Mass flows top to bottom)
  //Bottom Charging Fluid Node
    rho_f_avg * der(h_f[1]) =
    (-2.0*k_eff[1]*k_eff[2])*(T_f[1]-T_f[2])/((k_eff[1]+k_eff[2])*dz*dz*eta)
    + (rho_f_avg*u_flow)*(h_f[1]-h_f[2])/dz
    - h_v[1]*(T_f[1] - T_s[1])/eta
    - U_bot*CN.pi*D_tank*D_tank*0.25*(T_f[1]-T_amb)/(eta*A*dz) 
    - U_wall*CN.pi*D_tank*(T_f[1]-T_amb)/(eta*A);
    
    h_out = h_f[1];
  //End Bottom Charging Fluid Node
  //Middle Charging Fluid Nodes
    for i in 2:N_f - 1 loop
      rho_f_avg*der(h_f[i]) = 
      2.0*k_eff[i - 1]*k_eff[i]*(T_f[i-1]-T_f[i])/((k_eff[i-1]+k_eff[i])*dz*dz*eta)
      - 2.0*k_eff[i]*k_eff[i+1]*(T_f[i]-T_f[i + 1])/((k_eff[i]+k_eff[i+1])*dz*dz*eta)
      + (rho_f_avg*u_flow)*(h_f[i]-h_f[i+1])/dz
      - h_v[i]*(T_f[i]-T_s[i])/eta
      - U_wall*CN.pi*D_tank*(T_f[i]-T_amb)/(eta*A);
    end for;
  //End Middle Charging Fluid Nodes
  //Top Charging Fluid Node
    rho_f_avg*der(h_f[N_f]) = 
    2.0*k_eff[N_f-1]*k_eff[N_f]*(T_f[N_f-1]-T_f[N_f])/((k_eff[N_f-1]+k_eff[N_f])*dz*dz*eta)
    + (rho_f_avg*u_flow)*(h_f[N_f]-h_in)/dz
    - h_v[N_f]*(T_f[N_f]-T_s[N_f])/eta
    - U_wall*CN.pi*D_tank*(T_f[N_f]-T_amb)/(eta*A)
    - U_top*CN.pi*D_tank*D_tank*0.25*(T_f[N_f]-T_amb)/(eta*A*dz);
  //End Top Charging Fluid Node
  else
  //Discharge (Mass flows bottom to top)
  //Bottom Discharge Node
    rho_f_avg*der(h_f[1]) =
    -2.0*k_eff[1]*k_eff[2]*(T_f[1]-T_f[2])/((k_eff[1]+k_eff[2])*dz*dz*eta)
    + (rho_f_avg*u_flow)*(h_in-h_f[1])/dz
    - h_v[1]*(T_f[1]-T_s[1])/eta
    - U_bot*CN.pi*D_tank*D_tank*0.25*(T_f[1]-T_amb)/(eta*A*dz)
    - U_wall*CN.pi*D_tank*(T_f[1]-T_amb)/(eta*A);
  //End Bottom Discharge Node
  //Middle Discharge Nodes
    for i in 2:N_f - 1 loop
      rho_f_avg*der(h_f[i]) =
      2.0*k_eff[i-1]*k_eff[i]*(T_f[i-1]-T_f[i])/((k_eff[i-1]+k_eff[i])*dz*dz*eta)
      - 2.0*k_eff[i]*k_eff[i + 1]*(T_f[i]-T_f[i+1])/((k_eff[i]+k_eff[i+1])*dz*dz*eta)
      + (rho_f_avg*u_flow)*(h_f[i-1]-h_f[i])/dz
      - h_v[i]*(T_f[i]-T_s[i])/eta
      - U_wall*CN.pi*D_tank*(T_f[i]-T_amb)/(eta*A);
    end for;
  //End Middle Discharge Nodes
  //Top Discharge Node
    rho_f_avg*der(h_f[N_f]) =
    2.0*k_eff[N_f-1]*k_eff[N_f]*(T_f[N_f-1]-T_f[N_f])/((k_eff[N_f-1]+k_eff[N_f])*dz*dz*eta)
    + (rho_f_avg*u_flow)*(h_f[N_f-1]-h_f[N_f])/dz
    - h_v[N_f]*(T_f[N_f]-T_s[N_f])/eta
    - U_wall*CN.pi*D_tank*(T_f[N_f]-T_amb)/(eta*A)
    - U_top*CN.pi*D_tank*D_tank*0.25*(T_f[N_f]-T_amb)/(eta*A*dz);
    
    h_out = h_f[N_f];
  end if;
  //Fluid Property evaluation SolarSalt
  for i in 1:N_f loop
    h_f[i] = fluid[i].h;
    T_f[i] = fluid[i].T;
    c_pf[i] = fluid[i].cp;
    k_f[i] = fluid[i].k;
    k_eff[i] = eta*fluid[i].k; //Effective thermal conductivity of fluid (weighted by porosity)
    mu_f[i] = fluid[i].mu;
  end for;
  //Particle Property evaluation quartzite and sand
  for i in 1:N_f loop
    for j in 1:N_p loop
      (T_p[i,j],f_p[i,j]) = Filler_Package.Tf_h(h_p[i,j]);
      k_p[i,j] = Filler_Package.k_Tf(T_p[i,j],f_p[i,j]);     
    end for;
  end for;
  //Convection Equations
  for i in 1:N_f loop
    if abs(u_flow) > 1e-12 then //There is actually mass flowing
      Re[i] = rho_f_avg * d_p * abs(u_flow) / mu_f[i];
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
  //Inner Particle Shell (actually just a sphere)
    U_in[i, 1] = 0.0;
  //nothing in there
    U_out[i, 1] = 
    (f_surface)*4.0*k_p[i, 1]*k_p[i, 2]*CN.pi*r_p[i, 1]*(r_p[i,1]+dr)*(2.0*r_p[i, 1]+dr)/(dr*(k_p[i,2]*dr+k_p[i,1]*r_p[i, 1]+k_p[i, 2]*r_p[i, 1]));
    m_p[i, 1]*der(h_p[i, 1]) = U_out[i, 1]*(T_p[i, 2]-T_p[i, 1]);
  //End Inner Particle Shell
  //Middle Particle Shells
    for j in 2:N_p - 1 loop
      U_in[i, j] = (f_surface)*4.0*k_p[i, j - 1]*k_p[i, j]*CN.pi*r_p[i, j]*(2.0*r_p[i, j]-dr)*(dr-r_p[i, j])/(dr*(k_p[i,j-1]*dr-k_p[i,j-1]*r_p[i,j]-k_p[i,j]*r_p[i,j]));
      U_out[i,j] = (f_surface)*4.0*k_p[i, j]*k_p[i,j+1]*CN.pi*r_p[i,j]*(r_p[i,j]+dr)*(2.0*r_p[i,j]+dr)/(dr*(k_p[i,j+1]*dr+k_p[i,j]*r_p[i,j]+k_p[i,j+1]*r_p[i, j]));
      m_p[i, j]*der(h_p[i,j]) = U_out[i,j]*(T_p[i,j+1]-T_p[i,j]) - U_in[i,j]*(T_p[i,j]-T_p[i,j-1]);
    end for;
  //End Middle Particle Shells
  //Outer Particle Shell
    U_in[i,N_p] = (f_surface)*4.0*k_p[i,N_p-1]*k_p[i,N_p]*CN.pi*r_p[i,N_p]*(2.0*r_p[i,N_p]-dr)*(dr-r_p[i,N_p])/(dr*(k_p[i,N_p-1]*dr-k_p[i,N_p-1]*r_p[i,N_p]-k_p[i,N_p]*r_p[i,N_p]));
    U_out[i,N_p] = (f_surface)*8.0*CN.pi*k_p[i,N_p]*r_p[i,N_p]*(r_p[i,N_p]+0.5*dr)/dr;
    m_p[i,N_p]*der(h_p[i,N_p]) = U_out[i, N_p]*(T_s[i]-T_p[i, N_p]) - U_in[i, N_p]*(T_p[i, N_p]-T_p[i,N_p-1]);
  end for;
  //Particle Surface equations energy balance
  for i in 1:N_f loop
    U_out[i, N_p] * (T_s[i] - T_p[i, N_p]) = CN.pi * d_p ^ 3 * h_v[i] * (T_f[i] - T_s[i]) / (6.0 * (1.0 - eta));
  end for;

  //Heat loss calculations, different form than the equations above as they were in terms of rho*dh/dt not m*dh/dt
  Q_loss_top = U_top*CN.pi*D_tank*D_tank*0.25*(T_f[N_f]-T_amb);
  Q_loss_bot = U_bot*CN.pi*D_tank*D_tank*0.25*(T_f[1]-T_amb);
  for i in 1:N_f loop
    Q_loss_wall[i] = U_wall*CN.pi*D_tank*(T_f[i]-T_amb)*dz;
  end for;
  Q_loss_total = Q_loss_top + sum(Q_loss_wall) + Q_loss_bot;
  //End heat loss calculations

  //Analyics
  der(E_stored) = abs(m_flow) * (h_in - h_out) - Q_loss_total;
  Level = E_stored / E_max;
  
  //Calculated Pumping losses
  for i in 1:N_f loop
    p_drop[i] = dz*(((600*((1-eta)^2)*mu_f[i]*abs(m_flow))/((eta^3)*(d_p^2)*rho_f_avg*CN.pi*(D_tank^2)))+((28*(1-eta)*(m_flow^2))/((eta^3)*d_p*rho_f_avg*CN.pi*CN.pi*(D_tank^4))));
  end for;
  p_drop_total = sum(p_drop);
  W_loss_pump = (abs(m_flow)/rho_f_avg)*p_drop_total/eff_pump;
  
  annotation (Documentation(revisions ="<html>
		<p>By Zebedee Kee on 03/12/2020</p>
		</html>",info="<html>
		<p>This model contains the heat-transfer calculations of a thermocline packed bed storage tank with spherical filler geometry. This model does not contain any fluid connectors, for the CSP component with connectors, see Thermocline_Spheres_SingleTank. Variables fluid_top and fluid_bot provides the enthalpy-temperature relationship of the fluid material. Depending on whether m_flow is positive (discharging, fluid flowing upwards) or negative (charging, fluid flowing downwards), the charging/discharging equations are applied. In this iteration of the model, discharging and standby are lumped into one state.</p>
		</html>"));

end Thermocline_Spheres_Section_Final;