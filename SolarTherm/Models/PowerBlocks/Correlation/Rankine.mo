within SolarTherm.Models.PowerBlocks.Correlation;
model Rankine "Rankine cycle regresion model"
	import SI = Modelica.SIunits;

	extends Cycle;

	parameter SI.AbsolutePressure p_bo=10e5 "Boiler operating pressure" annotation (Dialog(group="Design"));
	parameter SI.Temperature Tsat_ref=Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p_bo);

protected
	Real T_ND "Non-dimensional temperature";

equation
	T_ND=(T_in-Tsat_ref)/(T_in_ref-Tsat_ref);
	k_q=(-0.054078*T_ND^2 + 1.060131*T_ND - 0.006011);
	k_w=(-0.007885*T_ND^2 + 1.036423*T_ND - 0.027262);
end Rankine;
