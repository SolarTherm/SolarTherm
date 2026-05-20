within SolarTherm.Utilities.Finances.Equipment.HeatExchangers;

function FCI_SpiralPlateHX "Input = {A (m2)}"
  input Real A "Required heat exchanger area (m2)";
  output Real FCI "Total cost of heat exhanger(s) (USD_2022)";
protected
  //Quotient-remainder calcs
  Real A_max "Maximum size power (W)";
  Real N_quo "Number of maximum-sized units, can be zero (-)";
  Real A_rem "Size of remainder small unit (W)";
  
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
  A_max := 185.8;
  N_quo := div(A, A_max);
  A_rem := rem(A, A_max);

  F_d := 1.05;
  F_m := 2.0; //Material factor CS = 1.0
  F_Hand := 3.5;
  F_adj := SolarTherm.Utilities.Finances.F_adj_hand(F_m);
  //Note: the log() function in Modelica is natural logarithm ln
  FOB_quo := (816.0/500.0) * 6200.0 * (10.764 * A_max)^0.42; //FOB of one max sized unit
  FOB_rem := (816.0/500.0) * 6200.0 * (10.764 * A_rem)^0.42; //FOB of remaining small unit
  
  FOB := N_quo*FOB_quo + FOB_rem; //Total FOB cost of all units that when combined, satisfy A
  
  FCI := FOB * F_d * F_Hand * F_adj;

annotation(
    Documentation(info = "<html><head></head><body><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Fixed-Capital-Investment cost of spiral-plate heat-exchangers provided by Seider indexed to USD_2022. Note that the FOB cost already considers stainless-steel material. When converted to SI units, the FOB cost relationship is:</p><div class=\"htmlDoc\" style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><div>FOB = (CEPCI/500.0) * 6200 * (10.764 * A)^0.42</div><div><br></div><div>where:</div><div><br></div><div>F_m = 2.0 (stainless steel, not applied in FOB eqn)</div><div>CEPCI_2022 = 816.0</div><div><br></div><div>1.858 &lt;= A (m2) &lt;= 185.8</div><div><br></div><div><br></div><div><div>The FCI cost relationship is:</div><div><br></div><div>FCI = FOB * 1.05 * F_hand * F_adj</div><div><br></div><div>where:</div><div><br></div><div>1.05 factor for delivery</div><div>F_hand = 3.5 for heat exchangers</div><div>F_adj = Adjusted for F_m = 2.0</div></div></div></body></html>"));
end FCI_SpiralPlateHX;