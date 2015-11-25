within SolarTherm.Optics;
block FluxMapIdealInc "Concentrator with fixed incline that tracks sun azimuth"
	extends SolarTherm.Optics.FluxMap;
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import Modelica.Math.cos;

	parameter SI.Area A_con "Area of concentrator aperture";
	parameter SI.Angle alt_fixed = CN.pi/2 "Fixed concentrator altitude";
equation
	for i in 1:nelem loop
		flux[i] = max(A_con*cos(alt_fixed - alt)/nelem, 0);
	end for;
end FluxMapIdealInc;
