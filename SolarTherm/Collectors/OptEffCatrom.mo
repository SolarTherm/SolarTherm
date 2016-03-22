within SolarTherm.Collectors;
block OptEffCatrom "Read in optical efficiency from file"
	extends SolarTherm.Collectors.OptEff(nelem=1);
	// Expects data in file to be for a particular location
	// Currently only set up to work with a single element
	import SI = Modelica.SIunits;
	import SolarTherm.Utilities.Tables;
	parameter String fileName "Optical efficiency table (relative to aperture area)";
	parameter Integer n "Number of segments for ecliptic longitude";
	parameter Integer m "Number of segments for hour angle";
	parameter String sym = "E";

	parameter Real x_step = 360./n;
	parameter Real y_step = 360./m;

	Tables.STTable table = Tables.STTable(fn=fileName, delim=",");
protected
	parameter Integer res(fixed=false);
initial algorithm
	res := Tables.tableGrid(table, n, m, sym);
equation
	eff[1] = max(Tables.tableCatromInterp(table, wbus.elo, wbus.hra, x_step, y_step), 0);
end OptEffCatrom;
