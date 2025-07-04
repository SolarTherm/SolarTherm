within SolarTherm.Utilities.Costs;

function C_FOB_Shell_Seider "Free-on-board carbon steel vessel cost based on Seider 2008. Inputs are {year, shell volume (m3)}"
  input Real year "Year basis (Anno Domini)";
  input Real V "Volume of shell (m3)";
  output Real C_FOB "Total cost of tank shell (USD_year)";
protected
  Real CEPCI "CEPCI Index for the year chosen (-)";
algorithm
  CEPCI := SolarTherm.Utilities.Costs.CEPCI(year);
  C_FOB := (CEPCI/500.0)* 570.0 * ((35.315 * V)^0.46); //CEPCI = (816.0 for year 2022)
end C_FOB_Shell_Seider;