within SolarTherm.Utilities.Finances.Equipment;

function FCI_Vessel_SS "Inputs = vessel volume (m3), year"
  input Real V "Volume of vessel (m3)";
  input Real year = 2022 "Year basis A.D.";
  output Real FCI "Total cost of vessel (USD_year)";
algorithm
  FCI := FOB_Vessel_SS(V,year) * 1.05 * 4.0 * F_adj_hand(2.1);
annotation(
    Documentation(info = "<html><head></head><body>Information:<div><br></div><div>Fixed-Capital-Investment cost of bins for solids-handling system provided by Seider for Carbon Steel at atmospheric pressure with a reference CEPCI index of 500. When converted to SI units, the FOB cost relationship is:</div><div><br></div><div>FOB = (CEPCI/500.0) * F_m * 570 * (35.315 * V)^0.46</div><div><br></div><div>where:</div><div><br></div><div>F_m = 2.1 (Stainless Steel)</div><div><br></div><div>0.2832 &lt;= V (m3) &lt;= 2832</div><div><br></div><div><br></div><div><div>The FCI cost relationship is:</div><div><br></div><div>FCI = FOB * 1.05 * F_hand * F_adj</div><div><br></div><div>where:</div><div><br></div><div>1.05 factor for delivery</div><div>F_hand = 4.0 for pressure vessels/tanks</div><div>F_adj = f(2.1) for stainless steel</div><div><br></div><div><br></div></div></body></html>"));
end FCI_Vessel_SS;