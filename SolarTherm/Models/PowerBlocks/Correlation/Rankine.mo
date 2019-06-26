within SolarTherm.Models.PowerBlocks.Correlation;
model Rankine "Rankine cycle regresion model"
	extends Cycle;
equation
	k_q=(-0.054078*T_ND^2 + 1.060131*T_ND - 0.006011);
	k_w=(-0.007885*T_ND^2 + 1.036423*T_ND - 0.027262);
end Rankine;
