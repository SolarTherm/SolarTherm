within SolarTherm.Utilities.Finances;

function r_CEPCI "CEPCI Ratio of: Numerator Year, Denominator Year"
  input Real Year_Numerator "Year A.D.";
  input Real Year_Denominator "Year A.D.";
  output Real r "CEPCI Composite Index ratio (-)";
algorithm
  r := CEPCI(Year_Numerator)/CEPCI(Year_Denominator);
end r_CEPCI;