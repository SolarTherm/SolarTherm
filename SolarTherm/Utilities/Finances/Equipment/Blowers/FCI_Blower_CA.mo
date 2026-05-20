within SolarTherm.Utilities.Finances.Equipment.Blowers;

function FCI_Blower_CA
  input Real P_c "Required blower power (W)";
  output Real FCI "Total cost of blower(s) (USD_2022)";
protected
  //Quotient-remainder calcs
  Real P_c_max "Maximum size power (W)";
  Real N_quo "Number of maximum-sized units, can be zero (-)";
  Real P_c_rem "Size of remainder small unit (W)";
  
  //Free-on-board purchase costs
  Real FOB_quo "Free-on-board purchase cost of maximum-sized units (USD_2022)";
  Real FOB_rem "Free-on-board purchase cost of remainder small unit (USD_2022)";
  Real FOB "Total Free-on-board purchase cost (USD_2022)";
  
  //Hand-factor conversions
  Real F_d "Equipment delivery factor";
  Real F_m "Equipment material factor";
  Real F_Hand "Hand factor";
  Real F_adj "Hand-factor adjustment factor";

algorithm
  P_c_max := 745700.0;
  N_quo := div(P_c, P_c_max);
  P_c_rem := rem(P_c, P_c_max);

  F_d := 1.05;
  F_m := 0.6; //Material factor Cast Aluminium = 0.60
  F_Hand := 4.0;
  F_adj := SolarTherm.Utilities.Finances.F_adj_hand(F_m);
  //Note: the log() function in Modelica is natural logarithm ln
  FOB_quo := (816.0/500.0) * F_m * exp(6.8929 + 0.79*(log(P_c_max/745.7))); //FOB of one max sized unit
  FOB_rem := (816.0/500.0) * F_m * exp(6.8929 + 0.79*(log(P_c_rem/745.7))); //FOB of remaining small unit
  
  FOB := N_quo*FOB_quo + FOB_rem; //Total FOB cost of all units that when combined, satisfy P_c
  
  FCI := FOB * F_d * F_Hand * F_adj;
annotation(
    Documentation(info = "<html><head></head><body><p style=\"font-size: 12px;\"><span style=\"font-family: 'DejaVu Sans Mono';\">Fixed-Capital-Investment cost of centrifugal blowers provided by Seider for Cast Aluminium with a reference CEPCI index of 500, indexed to USD_2022. When converted to SI units, the FOB cost relationship is:</span></p><div class=\"htmlDoc\" style=\"font-size: 12px; font-family: 'DejaVu Sans Mono';\"><div><br></div><div>FOB = (CEPCI/500.0) * F_m * exp{ 6.8929 + 0.79*[ln(P_c/745.7)]}</div><div><br></div><div>where:</div><div><br></div><div>F_m = 0.6 (Cast Aluminium)</div><div><br></div><div>3729 &lt;= P_c [W] &lt;= 745700</div><div><br></div><div>CEPCI_2022 = 816.0</div><div><br></div><div><div>The FCI cost relationship is:</div><div><br></div><div>FCI = FOB * F_d * F_hand * F_adj</div><div><br></div><div>where:</div><div><br></div><div>F_d = 1.05 factor for delivery</div><div>F_hand = 4.0 for pumps</div><div>F_adj = Adjusted for Cast Aluminium</div></div></div></body></html>"));
end FCI_Blower_CA;