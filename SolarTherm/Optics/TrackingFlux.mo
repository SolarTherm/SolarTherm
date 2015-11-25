within SolarTherm.Optics;
block TrackingFlux "Flux on elements when tracking sun"
	import SI = Modelica.SIunits;
	parameter Integer nelem = 1 "Number of aperture elements";
	input SI.Angle alt "Sun altitude";
	input SI.Angle azi "Sun azimuth";
	input SI.Irradiance dni(min=0) "Direct normal irradiance";
	output SI.RadiantPower R[nelem](each min=0) "Radiant power on focal apertures";

	replaceable model FluxMap = SolarTherm.Optics.FluxMap; // Must be replaced
	FluxMap fluxmap(nelem=nelem);
equation
	connect(alt, fluxmap.alt);
	connect(azi, fluxmap.azi);
	for i in 1:nelem loop
		R[i] = dni*fluxmap.flux[i];
	end for;
end TrackingFlux;
