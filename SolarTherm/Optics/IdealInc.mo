within SolarTherm.Optics;
block IdealInc "Concentrator with fixed incline that tracks sun azimuth"
	extends SolarTherm.Optics.Concentrator;
	// Tracks sun azimuth perfectly and conentrates all received energy into
	// focal aperture.
	import SI = Modelica.SIunits;
	import Modelica.Math.cos;
	parameter SI.Angle alt = 0 "Fixed concentrator altitude";
equation
	R_foc = if track then wbus.dni*A_con*cos(alt - wbus.alt) else 0;
end IdealInc;
