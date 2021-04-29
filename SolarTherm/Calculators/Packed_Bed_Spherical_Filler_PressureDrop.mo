within SolarTherm.Calculators;

model Packed_Bed_Spherical_Filler_PressureDrop
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  
  package Fluid_Package = SolarTherm.Materials.Sodium_Table_20K;
  parameter SI.Temperature T_min = 510 + 273.15 "Minimum temperature";
  parameter SI.Temperature T_max = 720 + 273.15 "Maximum temperature";
  
  //Design Parameters
  parameter Real eta = 0.26 "Porosity";
  parameter SI.Length H_tank = 30.0 "Tank height (m)";
  parameter SI.Length D_tank = 15.0 "Tank Diameter (m)";
  parameter SI.MassFlowRate m_flow = 20.0 "Mass flow rate (kg/s)";
  parameter SI.Length d_p = 0.10 "Filler diameter (m)";
  
  //Derived calculations
  parameter SI.DynamicViscosity mu = 0.5*(Fluid_Package.mu_T(T_min) + Fluid_Package.mu_T(T_max)) "Average dynamic viscosity of fluid";
  parameter SI.Density rho = 0.5*(Fluid_Package.rho_Tf(T_min,0.0)+Fluid_Package.rho_Tf(T_max,0.0)) "Average density of fluid";
  
  //Outputs
  SI.Pressure p_drop "Total pressure drop (Pa)";
  SI.Power P_pump "Pumping power assuming 100% pump effifiency (W)";
  
equation
  p_drop = ( 600.0*((1-eta)^2)*mu*m_flow*H_tank )/( (d_p^2)*(eta^3)*rho*CN.pi*(D_tank^2) ) + ( 28.0*(1-eta)*(m_flow^2)*H_tank )/( (eta^3)*d_p*rho*(CN.pi^2)*(D_tank^4) );
  P_pump = (m_flow/rho)*p_drop;
annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end Packed_Bed_Spherical_Filler_PressureDrop;