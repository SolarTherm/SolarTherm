within SolarTherm.Optics;
partial block FluxMap "Map from sun postition to flux per unit direct irradiance"
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	parameter Integer nelem = 1 "Number of aperture elements";
	input nSI.Angle_deg alt "Sun altitude";
	input nSI.Angle_deg azi "Sun azimuth";
	output Real flux[nelem](each min=0) "Flux per unit direct irradiance";
end FluxMap;
