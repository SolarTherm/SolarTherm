within SolarTherm.Utilities.Finances.Insulation;

function Thickness_Insulation_Mullite_HBS "Free-on-board intermal mullite insulation cost based on regression. Inputs are {max temp (K), U_loss (W/mK), A_surf (m2),year}"
  input Real T_max "Maximum TES temperature (K)";
  input Real U_loss "Heat loss coefficient (W/m2K)";
  output Real thickness "Total cost of tank shell (USD_year)";
protected
  //Regression Axes variables
  Real R "R = 1/U (m2K/W)";
  Real t "theta = T_max/(298.15K) (dimensionless)";
  //Regression coefficient
  constant Real a[5] = {-0.010371504,0.08759921,-9.24046e-8,-6.05415e-6,0.014908402};
  Real x[5] "Regression axis array";
algorithm
  //Calculate Regression Axes
  R := 1.0/U_loss;
  t := T_max/298.15;
  x := {1.0,R,R^2.0,t^2.0,R*t};
  thickness := sum(a.*x);
end Thickness_Insulation_Mullite_HBS;