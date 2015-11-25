within SolarTherm.Optics;
partial block FluxMap "Map from sun postition to flux per unit direct irradiance"
	import SI = Modelica.SIunits;
	parameter Integer nelem = 1 "Number of aperture elements";
	input SI.Angle alt "Sun altitude";
	input SI.Angle azi "Sun azimuth";
	output Real flux[nelem](each min=0) "Flux per unit direct irradiance";
end FluxMap;
