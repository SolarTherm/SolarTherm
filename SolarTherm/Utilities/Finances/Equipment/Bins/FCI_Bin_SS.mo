within SolarTherm.Utilities.Finances.Equipment.Bins;

function FCI_Bin_SS "Inputs = {Volume of bin (m3)}. CAPEX of a stainless steel bin indexed to USD_2022."
  input Real V "Volume of bin (m3)";
  output Real FCI "Total cost of tank shell (USD_2022)";
protected
  //Free-on-board purchase cost
  Real FOB "Free-on-board purchase cost (USD_2022)";
  //Hand-factor conversions
  Real F_d "Equipment delivery factor";
  Real F_m "Equipment material factor";
  Real F_Hand "Hand factor";
  Real F_adj "Hand-factor adjustment factor";

algorithm
  F_d := 1.05;
  F_m := 2.1; //Material factor SS = 2.1
  F_Hand := 4.0;
  F_adj := SolarTherm.Utilities.Finances.F_adj_hand(F_m);


  FOB := (816.0/500.0) * F_m * 570.0 * ((35.315 * V)^0.46); //CEPCI = (816.0 for year 2022)
  FCI := FOB * F_d * F_Hand * F_adj;

annotation(
    Documentation(info = "<html><head></head><body><p style=\"font-size: 12px;\"><span style=\"font-family: 'DejaVu Sans Mono';\">Fixed-Capital-Investment cost of bins for solids-handling system provided by Seider for Stainless Steel at atmospheric pressure with a reference CEPCI index of 500. When converted to SI units, the FOB cost relationship is:</span></p><div class=\"htmlDoc\" style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><div><br></div><div>FOB = (CEPCI/500.0) * F_m * 570 * (35.315 * V)^0.46</div><div><br></div><div>where:</div><div><br></div><div>F_m = 2.1 (Stainless Steel)</div><div><br></div><div>0.2832 &lt;= V (m3) &lt;= 2832</div><div><br></div><div>CEPCI_2022 = 816.0</div><div><br></div><div><div>The FCI cost relationship is:</div><div><br></div><div>FCI = FOB * 1.05 * F_hand * F_adj</div><div><br></div><div>where:</div><div><br></div><div>1.05 factor for delivery</div><div>F_hand = 4.0 for pressure vessels/tanks</div><div>F_adj = Adjusted for stainless steel</div></div><div><br></div></div></body></html>"));
end FCI_Bin_SS;