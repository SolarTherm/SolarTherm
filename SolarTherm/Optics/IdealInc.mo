within SolarTherm.Optics;
block IdealInc "Concentrator with fixed incline that tracks sun azimuth"
	extends SolarTherm.Optics.Concentrator(final nelem=1);
	// Tracks sun azimuth perfectly and conentrates all received energy into
	// focal aperture.
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import Modelica.SIunits.Conversions.from_deg;
	import Modelica.Math.cos;
	parameter SI.Area A_con "Area of concentrator aperture";
	parameter nSI.Angle_deg alt_fixed = 45 "Fixed concentrator altitude";
	input Boolean track "Set to true to start tracking";
equation
	R_foc[1] = if track then max(wbus.dni*A_con*cos(from_deg(alt_fixed - wbus.alt)), 0) else 0;
end IdealInc;
