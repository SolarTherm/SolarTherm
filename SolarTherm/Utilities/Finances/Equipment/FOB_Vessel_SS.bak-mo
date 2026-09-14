within SolarTherm.Utilities.Finances.Equipment;

function FOB_Vessel_SS "Inputs = vessel volume (m3), year"
  input Real V "Volume of vessel (m3)";
  input Real year = 2022 "Year basis A.D.";
  output Real FOB "Total cost of tank shell (USD_year)";
protected
  Real CEPCI "CEPCI Index for the year chosen (-)";
algorithm
  CEPCI := SolarTherm.Utilities.Finances.CEPCI(year);
  FOB := (CEPCI/500.0) * 2.1 * 570.0 * ((35.315 * V)^0.46); //CEPCI = (816.0 for year 2022)
annotation(
    Documentation(info = "<html><head></head><body>Information:<div><br></div><div>Free-on-board of bins for solids-handling system provided by Seider for stainless steel at atmospheric pressure with a reference CEPCI index of 500. When converted to SI units, the FOB cost relationship is:</div><div><br></div><div>FOB = (CEPCI/500.0) * F_m * 570 * (35.315 * V)^0.46</div><div><br></div><div>where:</div><div><br></div><div>F_m = 2.1 (Stainless Steel)</div><div><br></div><div>0.2832 &lt;= V (m3) &lt;= 2832</div></body></html>"));
end FOB_Vessel_SS;