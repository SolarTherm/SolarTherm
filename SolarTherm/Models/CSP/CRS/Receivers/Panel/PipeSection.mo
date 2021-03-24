within SolarTherm.Models.CSP.CRS.Receivers.Panel;
model PipeSection
  import Modelica.Math.*;
  import Modelica.SIunits.Conversions.*;
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;

  parameter SI.Height H_rcv = 10.5 "Receiver height"; //Gemasolar solar power tower https://doi.org/10.1016/j.solener.2015.12.055
  parameter SI.Diameter D_rcv = 8.5 "Receiver diameter"; //Gemasolar solar power tower https://doi.org/10.1016/j.solener.2015.12.055
  parameter Modelica.SIunits.Radius Ri = 21e-3 "Inner tube radius";
  parameter Modelica.SIunits.Radius Ro = 22.5e-3 "Outer tube radius";
  parameter Real Pi = Modelica.Constants.pi;
  parameter Real sigma = Modelica.Constants.sigma "Steffan-Boltzmann constant";
  parameter Modelica.SIunits.Efficiency ab = 0.93 "Coating absorptance";
  parameter Modelica.SIunits.Efficiency em = 0.87 "Coating emmisivity";
  parameter Modelica.SIunits.Efficiency ab_eff = ab/(ab + 2/Pi*(1-ab)) "Coating absorptance";
  parameter Modelica.SIunits.Efficiency em_eff = em/(em + 2/Pi*(1-em)) "Coating emmisivity";  
  parameter Modelica.SIunits.Temperature Tamb = from_degC(35);
  parameter Modelica.SIunits.Temperature Tsky = from_degC(30);
  parameter Modelica.SIunits.Efficiency em_sky = 0.895 "Sky emmisivity";
  parameter Modelica.SIunits.Efficiency em_gr = 0.955 "Ground emmisivity";
  parameter Modelica.SIunits.Temperature Ta = ((em_sky * Tsky ^ 4 + em_gr * Tamb ^ 4) / (em_gr + em_sky)) ^ 0.25;
  parameter Modelica.SIunits.Length dz = 0.42 "Longitude of the pipe segment";
  parameter Modelica.SIunits.MassFlowRate m_dot = 4.2;
  parameter Integer N_tb_pa = 1;
  // ************ Parameters external heat transfer coefficients ***************//
  Modelica.SIunits.CoefficientOfHeatTransfer hc "External coefficient of heat transfer due to forced convection";
  parameter SI.Velocity v_wind = 5 "Wind speed";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_a=1006 "Specific heat capacity of air at ambient temperature";
  parameter Modelica.SIunits.ThermalConductivity k_a=0.026 "Thermal conductivity of air at ambient temperature";
  parameter Modelica.SIunits.Density rho_a=1.184 "Density of air at ambient temperature";
  parameter Modelica.SIunits.DynamicViscosity mu_a=1.845e-5 "Dynamic viscosity at ambient temperature";
  parameter Modelica.SIunits.LinearExpansionCoefficient beta_a=0.003363 "Thermal expansion coefficient at ambient temperature";
  parameter Real Re_a = rho_a*v_wind*D_rcv/mu_a "Reynolds number of air at current wind speed";
  parameter Real Pr_a = cp_a*mu_a/k_a "Prandtl number of air at ambient temperature";
  parameter Modelica.SIunits.KinematicViscosity nu_a = mu_a/rho_a "Kinematic viscosity of air at ambient temperature";
  Real Gr_H "Grashof number for air at ambient temperature";
  Real Nu_nc "Nusselt number for air at ambient temperature";
  Modelica.SIunits.CoefficientOfHeatTransfer h_nc "Coefficient of heat transfer for ambient air due to natural convection";
  parameter Real Nu_fc = if v_wind > 0 then 0.3 + 0.62*Re_a^0.5*Pr_a^0.33/(1+(0.4/Pr_a)^(2/3))^(1/4)*(1+(Re_a/282000)^(5/8))^(4/5) else 0 "Nusselt number due to forced convection";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h_fc = Nu_fc*k_a/(D_rcv) "Coefficient of heat transfer for ambient air due to forced convection";
  // ************ End parameters external heat transfer coefficients ***************//

  Real Bif(start=3) "Internal Biot number";
  Real Nu "Internal Nusselt number";
  Real Re "Reynolds number";
  Real Pr "Prandtl number";
  Modelica.SIunits.Density rho "HTF density";
  Modelica.SIunits.ThermalConductivity kf "HTF thermal conductivity";
  Modelica.SIunits.DynamicViscosity muf "HTF dynamic viscosity";
  Modelica.SIunits.Velocity vf "HTF velocity";
  Modelica.SIunits.SpecificHeatCapacity Cp "HTF Specific heat capacity";
  Modelica.SIunits.ThermalConductivity k "Pipe wall thermal conductivity";
  Real f "Darcy friction factor";
  Real A0(start=500);
  Real B0(start=500);
  parameter Integer N = 6 "Number of terms in analytical solution";
  Real An[N](each start=500);
  Real gn[N];
  Real gpn[N];
  Real K_r "Coefficient to account radial temperature difference in thermal stress";
  Real K_theta "Coefficient to account circumferencial temperature difference in thermal stress";
  
  // ***************** Mechanical parameters *********************
  parameter Modelica.SIunits.LinearExpansionCoefficient lambda = 18.5e-6 "Coefficient of linear thermal expansion receiver tube material";
  parameter Modelica.SIunits.Stress E = 165e9 "Young's Modulus receiver tube material";
  parameter Modelica.SIunits.Efficiency poisson = 0.3 "Poisson ratio of receiver tube material";
  parameter Real K_safe = 0.9 "Security factor";
  parameter Real A(final unit="1/(Pa^0.66.s)") = 2.688e-45 "Structure-dependent constant";
  parameter Real n = 6.6 "Stress exponent in Norton-Bailey equation";
  parameter Real m = 0 "Time exponent in Norton-Bailey equation";
  parameter Real Q(final unit="J/(mol)") = 322e3 "Activation energy for creep";
  parameter Real R(final unit="J/(mol.K)") = Modelica.Constants.R "Molar gas constant (previous value: 8.314472)";
  parameter Modelica.SIunits.Time t_stab = 108000 "Relaxation time";

  Modelica.SIunits.Stress sigma_theta;
  Modelica.SIunits.Stress sigma_z;
  Modelica.SIunits.Stress sigma_eq;
  //Modelica.SIunits.Stress sigma_creep;

  Modelica.SIunits.CoefficientOfHeatTransfer hf "Internal coefficient of heat transfer due to forced convection";
  Modelica.SIunits.Temperature Ts;
  Modelica.SIunits.Temperature Ti;
  Modelica.SIunits.Temperature Tin;
  Modelica.SIunits.Temperature Tout;
  Modelica.SIunits.SpecificEnthalpy hin;
  Modelica.SIunits.SpecificEnthalpy hout;
  Modelica.SIunits.SpecificEnthalpy hm;
  Modelica.SIunits.Temperature Tm;
  Modelica.SIunits.Temperature Tprom;
  Modelica.SIunits.Temperature T_theta;
  Modelica.SIunits.HeatFlux q0;
algorithm
  hc := if v_wind > 0 then (h_nc^3.2 + h_fc^3.2)^(1/3.2) else h_nc;
  
  // ************ Stress **************//
  K_r := (0.5*An[1] * gn[1] + 0.5*An[1] * g(Ri, 1, Ri, Bif))/log(Ro/Ri);
  K_theta := An[1]*Ri^2*(1 - Bif)/(1 + Bif)*Ro/(Ri^2 + Ro^2);	
  T_theta := sum(An[j] * gn[j] for j in 1:N);

  sigma_theta := lambda*E/(2*(1-poisson))*(K_r*(1 - 2*Ri^2/(Ro^2 - Ri^2)*log(Ro/Ri)) + K_theta*(2 - 2*Ri^2/Ro^2));
  sigma_z := poisson*(sigma_theta) + lambda*E*T_theta;
  sigma_eq := (((sigma_theta - sigma_z)^2 + (sigma_theta)^2 + (sigma_z)^2)/2)^0.5;

equation
  k = 0.0163914878 * Ti + 6.8703621459;
  
  // **** Begin external convection  ******//
  Gr_H = Modelica.Constants.g_n*beta_a*(Tprom-Tamb)*H_rcv/nu_a^2;
  Nu_nc = 0.098*Pi/2*(Gr_H^(1/3))*((Tprom/Tamb)^(-0.14));
  h_nc = Nu_nc*k_a/(H_rcv);
  // **** End external convection  ******//
  
  hout = hin + 2*Pi*k*B0*dz/m_dot;
  hm = hin + Pi*k*B0*dz/m_dot;
  hin = Medium.h_T(Tin);
  hout = Medium.h_T(Tout);
  hm = Medium.h_T(Tm);
  hf = Nu * kf / (2 * Ri) / (1 + Nu * kf / (2 * Ri) * 8.808e-5);
  rho = Medium.rho_T(Tm);
  kf = Medium.lamda_T(Tm);
  muf = Medium.eta_T(Tm);
  vf = m_dot / (N_tb_pa * rho * Pi * Ri ^ 2);
  Cp = Medium.cp_T(Tm);
  Re = max(1, vf * rho * 2 * Ri / muf);
  Pr = max(0, muf * Cp / kf);
  f=(1.82*log10(Re)-1.64)^(-2);
  Nu = (f/8)*(Re-1000)*Pr/(1+12.7*(f/8)^0.5*((Pr^0.66)-1));
  Bif = hf * Ri / k;
  B0 = Bif * (A0 - Tm) / (1 - Bif * log(Ri));
  gn = {g(Ro, j, Ri, Bif) for j in 1:N};
  gpn = {gp(Ro, j, Ri, Bif) for j in 1:N};

  -((ab*q0)/k) + (B0*Pi)/Ro + (hc*Pi*(A0 - Ta + B0*log(Ro)) + Pi*em*sigma*(Tprom^4 - Ta^4))/k = 0;
  -((ab*Pi*q0)/(4*k)) + (hc*Pi*An[1]*gn[1])/(2*k) + (1/2)*Pi*An[1]*gpn[1] = 0;
  -((ab*q0)/(3*k)) + (hc*Pi*An[2]*gn[2])/(2*k) + (1/2)*Pi*An[2]*gpn[2] = 0;
  (hc*Pi*An[3]*gn[3])/(2*k) + (1/2)*Pi*An[3]*gpn[3] = 0;
  (ab*q0)/(15*k) + (hc*Pi*An[4]*gn[4])/(2*k) + (1/2)*Pi*An[4]*gpn[4] = 0;
  (hc*Pi*An[5]*gn[5])/(2*k) + (1/2)*Pi*An[5]*gpn[5] = 0;
  -((ab*q0)/(35*k)) + (hc*Pi*An[6]*gn[6])/(2*k) + (1/2)*Pi*An[6]*gpn[6] = 0;

  Ts = A0 + B0 * log(Ro) + sum(An[j] * gn[j] for j in 1:N);
  Ti = A0 + B0 * log(Ri) + sum(An[j] * g(Ri, j, Ri, Bif) for j in 1:N);
  Tprom = A0 + B0 * log(Ro);
  
  //sigma_creep = E*((1-n)*((sigma_eq/E)^(1-n)/(1-n) - A*E^n*exp(-Q/(R*923))*t_stab)^(1/(1-n)))/K_safe;
  
end PipeSection;
