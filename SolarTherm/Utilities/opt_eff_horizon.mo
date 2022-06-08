within SolarTherm.Utilities;

function opt_eff_horizon
	extends Modelica.Icons.Function;
		input Modelica.SIunits.Angle dec_horizon "Solar declination angle ";
		input Modelica.SIunits.Angle hra_horizon "Solar hour angle";
		input Modelica.Blocks.Types.ExternalCombiTable2D opt_eff "Table with the values to interpolate";
		output Real eta_opt "eta_optical for the next forecast horizon";
		external "C" eta_opt = ModelicaStandardTables_CombiTable2D_getValue(opt_eff, dec_horizon, hra_horizon) 
		annotation(Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
end opt_eff_horizon;