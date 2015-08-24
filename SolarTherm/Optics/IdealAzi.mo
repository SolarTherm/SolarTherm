within SolarTherm.Optics;
block IdealAzi "Ideal azimuth axis tracker (fixed altitude)"
	extends SolarTherm.Optics.Concentrator;
	// Tracks sun azimuth perfectly and conentrates all received energy into
	// focal aperture.
	import SI = Modelica.SIunits;
	import Modelica.Math.cos;
	parameter SI.Angle alt "Fixed concentrator altitude";
equation
	R_foc = if track then wbus.dni*A_con*cos(alt - wbus.alt) else 0;
end IdealAzi;
