within SolarTherm.Optics;
block FluxMapIdealInc "Concentrator with fixed incline that tracks sun azimuth"
	extends SolarTherm.Optics.FluxMap;
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import Modelica.SIunits.Conversions.from_deg;
	import Modelica.Math.cos;

	parameter SI.Area A_con "Area of concentrator aperture";
	parameter nSI.Angle_deg alt_fixed = 45 "Fixed concentrator altitude";
equation
	for i in 1:nelem loop
		flux[i] = max(A_con*cos(from_deg(alt_fixed - alt))/nelem, 0);
	end for;
end FluxMapIdealInc;
