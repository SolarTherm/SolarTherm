within SolarTherm.Utilities.Costs;

function C_FOB_Shell_Seider_2022 "Free-on-board carbon steel vessel cost based on Seider 2008, indexed to the year 2022. Inputs are {Shell volume (m3)}"
  input Real V "Volume of shell (m3)";
  output Real C_FOB_2022 "Total cost of tank shell (USD_2022)";
algorithm
  C_FOB_2022 := (816.0/500.0)* 570.0 * ((35.315 * V)^0.46); //CEPCI = (816.0 for year 2022)
end C_FOB_Shell_Seider_2022;