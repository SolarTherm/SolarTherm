within SolarTherm.Optics;
block IdealInc "Concentrator with fixed incline that tracks sun azimuth"
	extends SolarTherm.Optics.Concentrator;
	// Tracks sun azimuth perfectly and conentrates all received energy into
	// focal aperture.
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import Modelica.Math.cos;
	parameter SI.Angle alt = CN.pi/2 "Fixed concentrator altitude";
equation
	R_foc = if track then wbus.dni*A_con*cos(alt - wbus.alt) else 0;
end IdealInc;
