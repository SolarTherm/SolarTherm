within SolarTherm.Optics;
block TrackingFlux "Flux on elements when tracking sun"
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	parameter Integer nelem = 1 "Number of aperture elements";
	parameter Boolean use_input_eff = false "Used adjustable efficiency";
	parameter SI.Efficiency eff_fixed(min=0, max=1) = 1 "Fixed efficiency when no input used";
	input nSI.Angle_deg alt "Sun altitude";
	input nSI.Angle_deg azi "Sun azimuth";
	input SI.Irradiance dni(min=0) "Direct normal irradiance";
	input SI.Efficiency eff(min=0, max=1) if use_input_eff "Efficiency";
	output SI.RadiantPower R[nelem](each min=0) "Radiant power on focal apertures";

	replaceable model FluxMap = SolarTherm.Optics.FluxMap; // Must be replaced
	FluxMap fluxmap(nelem=nelem);
equation
	connect(alt, fluxmap.alt);
	connect(azi, fluxmap.azi);
	for i in 1:nelem loop
		if use_input_eff then
			R[i] = eff*(dni/1000)*fluxmap.flux[i];
		else
			R[i] = eff_fixed*(dni/1000)*fluxmap.flux[i];
		end if;
	end for;
end TrackingFlux;
