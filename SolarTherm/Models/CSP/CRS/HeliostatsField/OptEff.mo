within SolarTherm.Models.CSP.CRS.HeliostatsField;
partial block OptEff "Map from sun postition to optical efficiency"
	// Optical efficiency is relative to a field aperture
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	parameter Boolean orient_north = true "Orient system toward north else south";
	parameter Integer nelem = 1 "Number of aperture elements";
	input SolarTherm.Interfaces.Connectors.WeatherBus wbus;
	output SI.Efficiency eff[nelem]
		"Optical efficiency (relative to field aperture)";
end OptEff;
