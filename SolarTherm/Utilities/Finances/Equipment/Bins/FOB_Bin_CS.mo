within SolarTherm.Utilities.Finances.Equipment.Bins;

function FOB_Bin_CS "Inputs = {Volume of bin (m3)}. FOB purchase cost of a carbon steel bin indexed to USD_2022."
  input Real V "Volume of bin (m3)";
  output Real FOB "Total FOB purchase cost of tank shell (USD_2022)";
protected
  Real F_m "Equipment material factor";

algorithm
  F_m := 1.0; //Material factor CS = 1.0
  FOB := (816.0/500.0) * F_m * 570.0 * ((35.315 * V)^0.46); //CEPCI = (816.0 for year 2022)
  
annotation(
    Documentation(info = "<html><head></head><body><p style=\"font-size: 12px;\"><span style=\"font-family: 'DejaVu Sans Mono';\">FOB purchase cost of bins for solids-handling system provided by Seider for Carbon Steel at atmospheric pressure with a reference CEPCI index of 500. When converted to SI units, the FOB cost relationship is:</span></p><div class=\"htmlDoc\" style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><div><br></div><div>FOB = (CEPCI/500.0) * F_m * 570 * (35.315 * V)^0.46</div><div><br></div><div>where:</div><div><br></div><div>F_m = 1.0 (Carbon Steel)</div><div><br></div><div>0.2832 &lt;= V (m3) &lt;= 2832</div><div><br></div><div><br></div><div><br></div></div></body></html>"));
end FOB_Bin_CS;