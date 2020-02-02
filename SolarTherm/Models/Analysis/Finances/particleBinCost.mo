within SolarTherm.Models.Analysis.Finances;
function particleBinCost "Capital cost per unit area a vertical cylindrical bin for storing solid particles"
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Models.Analysis.Finances;

	extends Modelica.Icons.Function;

	input SI.Temperature T "Bin target temperature";
	output FI.AreaPrice C_cap "Cost per unit area"; // in USD

algorithm
	C_cap := 1.23*(1000 + 0.3*(T-600)/400);

end particleBinCost;
