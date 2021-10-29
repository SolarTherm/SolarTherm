within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function p_rho "Pressure of Chloride Salt as a function of density"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Density rho "Density";
	output Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";

algorithm
	p := 1e5; // Constant pressure.
end p_rho;
