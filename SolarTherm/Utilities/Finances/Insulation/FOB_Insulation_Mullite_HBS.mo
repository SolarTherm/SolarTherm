within SolarTherm.Utilities.Finances.Insulation;

function FOB_Insulation_Mullite_HBS "Free-on-board intermal mullite insulation cost based on regression. Inputs are {max temp (K), U_loss (W/mK), A_surf (m2),year}"
  input Real T_max "Maximum TES temperature (K)";
  input Real U_loss "Heat loss coefficient (W/m2K)";
  input Real A_surf "Outer surface area (m2)";
  input Real year = 2022 "Year basis (Anno Domini)";
  output Real C_FOB "Total cost of tank shell (USD_year)";
protected
  Real CEPCI "CEPCI Index for the year chosen (-)";
  //Regression Axes variables
  Real R "R = 1/U (m2K/W)";
  Real t "theta = T_max/(298.15K) (dimensionless)";
  //Regression coefficient
  constant Real a[5] = {-1.062801,8.9680086,-8.8589974e-6,-0.0005982358,1.5262318};
  Real x[5] "Regression axis array";
algorithm
  //CEPCI index for chosen year
  CEPCI := SolarTherm.Utilities.Finances.CEPCI(year);
  //calculate Regression Axes
  R := 1.0/U_loss;
  t := T_max/298.15;
  x := {1.0,R,R^2.0,t^2.0,R*t};
  C_FOB := (CEPCI/795.4)*A_surf*sum(a.*x); //Regression was based on USD_2024, index it to 2022.
end FOB_Insulation_Mullite_HBS;