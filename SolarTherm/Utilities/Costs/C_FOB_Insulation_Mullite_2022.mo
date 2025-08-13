within SolarTherm.Utilities.Costs;

function C_FOB_Insulation_Mullite_2022 "Free-on-board intermal mullite insulation cost based on regression, indexed to the year 2022. Inputs are {Max Temp (K), U_loss (W/mK), A_surf (m2)}"
  input Real T_max "Maximum TES temperature (K)";
  input Real U_loss "Heat loss coefficient (W/m2K)";
  input Real A_surf "Outer surface area (m2)";
  output Real C_FOB_2022 "Total cost of tank shell (USD_2022)";
protected
  //Regression Axes variables
  Real R "R = 1/U (m2K/W)";
  Real t "theta = T_max/(298.15K) (dimensionless)";
  //Regression coefficient
  constant Real a[5] = {-1.062801,8.9680086,-8.8589974e-6,-0.0005982358,1.5262318};
  Real x[5] "Regression axis array";
algorithm
  //RCalc egression Axes
  R := 1.0/U_loss;
  t := T_max/298.15;
  x := {1.0,R,R^2.0,t^2.0,R*t};
  C_FOB_2022 := (816.0/795.1)*A_surf*sum(a.*x); //CEPCI = (816.0 for year 2022)
end C_FOB_Insulation_Mullite_2022;