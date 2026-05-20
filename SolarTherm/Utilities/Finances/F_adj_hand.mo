within SolarTherm.Utilities.Finances;

function F_adj_hand "Input: {Material cost factor}"
  input Real F_m "Material (alloy) cost factor";
  output Real F_adj "Hand method adjustment factor";
algorithm
  F_adj := Modelica.Math.exp(-0.57166*Modelica.Math.log(F_m) + 0.08588*((Modelica.Math.log(F_m))^2.0));
annotation(
    Documentation(info = "<html><head></head><body><b>Methodology:</b><div><br></div><div>FCI cost can be calculated based on FOB costs, delivery factor of 1.05, the Hand factor and and adjustment factor.</div><div><br></div><div>FCI = FOB * 1.05 * F_hand * F_adj</div><div><br></div><div>The adjustment factor F_adj is needed when a piece of equipment is not carbon steel (F_m = 1.0). This adjustment is required to account for costs which are independent of metallurgy e.g. engineering and construction overheads.</div><div><br></div><div>The function F_adj = f(F_m) was approximated using the equation:</div><div><br></div><div>F_adj = exp( -0.57166 ln(F_m) + 0.08588 [ln(F_m)]^2 )</div><div><br></div><div><b>References:</b></div><div><br></div><div>T. Brown. 2016. Engineering Economics and Economic Design for Process Engineers, CRC Press.</div></body></html>"));
end F_adj_hand;