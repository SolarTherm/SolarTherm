within SolarTherm.Calculators;

model Heat_Sink
  function CV_Location
      input Integer N_A;
      input Integer N_B;
      input Real dz_A;
      input Real dz_B;
      output Real z[N_A+N_B+2]; //Array of element centroids
  protected
      Real L;
      Integer N;
  algorithm
      z[1] := 0.0;
      z[N_A+N_B+2] := N_A*dz_A + N_B*dz_B;
      for i in 1:N_A loop
        z[i+1] := (i-0.5)*dz_A;
      end for;
      for i in 1:N_B loop
        z[i+1+N_A] := N_A*dz_A + (i-0.5)*dz_B;
      end for;
  end CV_Location;

  import Tables = Modelica.Blocks.Tables;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  //Material Properties
  replaceable package Inco_Pkg = SolarTherm.Materials.Inconel625;
  replaceable package Cu_Pkg = SolarTherm.Materials.Copper;
  
  //Studied Variables
  parameter Real flux_factor = 1.0 "Multiplier to the 1000kW/m2 flux input";
  parameter Real flowrate_factor = 7.7 "Multiplier to the 400L/min (divided by 6) lab air-flow input";
  parameter Real pressure_factor = 1.0 "Multiplier to the assumed 1 atm air-flow freestream pressure";
  parameter Integer N = 50 "Number of discrete inconel and copper elements (try 32,40,50)";
  //Parameters
  //Heat Source Parameters
  parameter SI.Irradiance flux_field = flux_factor*1.00e6 "W/m^2"; //default 1.0e6
  //parameter SI.HeatFlowRate q_field = flux_field*A "W";
  //Common Properties
  parameter SI.Length L_y = 30.0e-3 "Coupon height (m)";
  parameter SI.Length L_x = 30.0e-3 "Coupon length (m), also fin width";
  parameter SI.Area A = L_y*L_x "Cross sectional area m2";
  parameter SI.Temperature T_amb = 298.15 "Ambient temperature (K)";
  //Pyromark Properties
  parameter Real ab = 0.98 "Pyromark Absorptivity";
  parameter Real em = 0.91 "Pyromark Emissivity";
  //Inconel 625 Coupon Properties
  parameter SI.Length L_A = 3.0e-3 "Thickness of Inconel (m)";
  parameter SI.Density rho_A = Inco_Pkg.rho_Tf(298.15,0.0) "Density of Inconel (constant anyway)";
  parameter Integer N_A = N "Number of discrete Inconel elements";
  parameter SI.Length dz_A = L_A/N_A "Thickness of each Inconel element";
  parameter SI.Mass m_A = rho_A*(dz_A*A) "Mass of each Inconel element";

  //Copper Base
  parameter SI.Length L_B = 3.5e-3 "Thickness of copper (m)";
  parameter SI.Density rho_B = Cu_Pkg.rho_Tf(298.15,0.0) "Density of Copper (constant anyway)";
  parameter Integer N_B = N "Number of discrete Copper elements";
  parameter SI.Length dz_B = L_B/N_B "Thickness of each Inconel element";
  parameter SI.Mass m_B = rho_B*(dz_B*A) "Mass of each Inconel element";
  //Copper Fins
  parameter Real N_fins = 14.0 "Number of fins per quadrant";
  parameter SI.Length t_fin = 5.0e-3 "Thickness of fin in the y direction(m)";
  parameter SI.Length w_fin = L_x "Width of fin in the x direction (m)";
  parameter SI.Length L_fin = 16.5e-3 "Length of fins in the z direction (m)";
  parameter SI.Length L_c = L_fin + 0.5*t_fin "Corrected length of fins (m)";
  parameter SI.Area A_b = (L_y - N_fins*t_fin) * w_fin "Non-fin area (m)";
  parameter SI.Area A_fin = 2.0*w_fin*L_c "Total fin area (m2)";
  parameter SI.Area A_t = N_fins*A_fin + A_b "Total fin surface (m2)";
  //Air Jet
  parameter SI.Pressure p_air = pressure_factor*101325.0 "Air jet Pressure (Pa)";
  parameter SI.Length L_nozzle_y = 30.0e-3 "Width of air nozzle in y-direction (m)";
  parameter SI.Length L_nozzle_z = 17.0e-3 "Width of air nozzle in z-direction (m)"; //slightly more than fin length
  parameter SI.VolumeFlowRate V_flow_lab = 400.0*(1e-3)/60.0 "Total volumetric flow rate available to the lab (m3/s)";
  parameter Integer N_coupon = 6 "Number of coupons tested";
  parameter SI.VolumeFlowRate V_flow_one = flowrate_factor*V_flow_lab/N_coupon "Volumetric air flow rate for one coupon";
  parameter SI.Velocity u_air = V_flow_one/(L_nozzle_y*L_nozzle_z) "Free-stream velocity of air";
  parameter SI.Temperature T_air = T_amb "Air jet temperature";
  
  //Variables
  Tables.CombiTable1Ds Air_Film(tableOnFile = true, tableName = "table_1", columns = 2:8, fileName = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/Air_Extended.txt"));
  Inco_Pkg.State Inco_State[N_A](each h(start=Inco_Pkg.h_Tf(298.15,0.0))) "Inconel State";
  Cu_Pkg.State Copper_State[N_B](each h(start=Cu_Pkg.h_Tf(298.15,0.0))) "Copper State";
  
  //Air properties
  SI.ThermalConductivity k_air "Thermal conductivity of air around the pipe, W/mK";
  Real Pr_air "Prandtl number";
  SI.ThermalDiffusivity alpha_air "Thermal diffusivity of air around the pipe, m2/s";
  SI.KinematicViscosity nu_air "Kinematic viscosity of air around the pipe, m2/s";
  
  //Convection properties
  Real Nu_air "Nusselt";
  Real Re_air "Reynolds";
  SI.CoefficientOfHeatTransfer h_base "Base convective heat transfer coeff with no fins";
  SI.HeatFlowRate q_t "Total heat loss from the fin and base to the air flow";
  
  //Fin Properties
  Real eff_fin "Fin efficiency";
  Real m_fin "Fin m parameter";
  
  //Surface Temperatures
  SI.Temperature T_surf(start = 298.15) "Irradiated surface temperature";
  SI.Temperature T_base(start = 298.15) "Base of fin temperature";
  
  //Inconel States
  SI.Temperature T_A[N_A] "Inconel element Temperature";
  SI.SpecificEnthalpy h_A[N_A] "Inconel element specific enthalpy";
  SI.ThermalConductivity k_A[N_A] "Inconel element thermal conductivity";
  
  //Copper States
  SI.Temperature T_B[N_B] "Copper element Temperature";
  SI.SpecificEnthalpy h_B[N_B] "Copper element specific enthalpy";
  SI.ThermalConductivity k_B[N_B] "Copper element thermal conductivity";
  
  //Pyromark Surface Energy Balance
  SI.HeatFlowRate q_abs "Net absorbed energy";
  
  //Inconel Heat Flows, in flow from the left, out the right
  SI.HeatFlowRate q_A_in[N_A];  

  
  //Copper Heat Flows, in flow from the left, out the right
  SI.HeatFlowRate q_B_in[N_B];  
  SI.HeatFlowRate q_B_out;
 
  
  //Plotting
  Real T_z_degC[N_A+N_B+2](start = fill(25.0,N_A+N_B+2));
  parameter SI.Length z[N_A+N_B+2]=CV_Location(N_A,N_B,dz_A,dz_B);
  Real T_surf_degC;
   
equation
  //Air Properties
  Air_Film.u = 0.5 * (T_base + T_air);
  k_air = Air_Film.y[5];
  Pr_air = Air_Film.y[7];
  alpha_air = Air_Film.y[6];
  nu_air = Air_Film.y[4]*(101325.0/p_air); //Inversely proportional to pressure
  //Dimensionless Numbers
  Re_air = abs(u_air*w_fin/nu_air);
  Nu_air = 0.664*(Re_air^0.5)*(Pr_air^(1/3));
  h_base = Nu_air*k_air/w_fin;
  
  //Fin calculation
  //m_fin = (2.0*h_base/(k_fin*t_fin))^0.5;
  m_fin = (2.0*h_base/(k_B[N_B]*t_fin))^0.5;
  eff_fin = tanh(m_fin*L_c)/(m_fin*L_c);
  q_t = h_base*A_t*(1.0-(((N_fins*A_fin)/(A_t))*(1.0-eff_fin)))*(T_base-T_air);
  
  //Inconel Properties
  for i in 1:N_A loop
    Inco_State[i].h = h_A[i];
    T_A[i] = Inco_State[i].T;
    k_A[i] = Inco_State[i].k;
  end for;
  for i in 1:N_B loop
    Copper_State[i].h = h_B[i];
    T_B[i] = Copper_State[i].T;
    k_B[i] = Copper_State[i].k;
  end for;
  
  //Heat Transfer calculation
  q_abs = flux_field*ab*A - CN.sigma*em*A*((T_surf^4.0)-(T_amb^4.0)); //Irradiated surface balance
  
  //Heat Flow rates
  q_A_in[1] = (2.0*A/dz_A)*k_A[1]*(T_surf-T_A[1]);
  for i in 2:N_A loop
    q_A_in[i] = (2.0*A/dz_A)*(k_A[i-1]*k_A[i]/(k_A[i-1]+k_A[i]))*(T_A[i-1]-T_A[i]);
  end for;
  
  q_B_in[1] = (2.0*A)*((k_A[N_A]*k_B[1])/(k_A[N_A]*dz_B+k_B[1]*dz_A))*(T_A[N_A]-T_B[1]);
  for i in 2:N_B loop  
    q_B_in[i] = (2.0*A/dz_B)*(k_B[i-1]*k_B[i]/(k_B[i-1]+k_B[i]))*(T_B[i-1]-T_B[i]);
  end for;
  q_B_out = (2.0*A/dz_B)*k_B[N_B]*(T_B[N_B]-T_base); //The furthest right element
  
  //Energy Balance
  for i in 1:(N_A-1) loop
    der(h_A[i]) = (q_A_in[i]-q_A_in[i+1])/m_A;
  end for;
  der(h_A[N_A]) = (q_A_in[N_A]-q_B_in[1])/m_A;
  for i in 1:(N_B-1) loop
    der(h_B[i]) = (q_B_in[i]-q_B_in[i+1])/m_B;
  end for;
  der(h_B[N_B]) = (q_B_in[N_B]-q_B_out)/m_B;
  
  //Surface nodes
  q_abs = q_A_in[1];
  q_B_out = q_t;
  
  //Plotting
  T_z_degC[1] = T_surf - 273.15;
  T_z_degC[N_A+N_B+2] = T_base - 273.15;
  for i in 1:N_A loop
    T_z_degC[i+1] = T_A[i] - 273.15;
  end for;
  for i in 1:N_B loop
    T_z_degC[i+1+N_A] = T_B[i] - 273.15;
  end for;
  T_surf_degC = T_surf - 273.15;
annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end Heat_Sink;