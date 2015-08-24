within SolarTherm.Optics;
block IdealAzi "Ideal azimuth axis tracker (fixed altitude)"
	extends SolarTherm.Optics.Concentrator;
	import SI = Modelica.SIunits;
	// Tracks sun azimuth perfectly and conentrates all received energy into
	// focal aperture.
	import Modelica.Math.cos;
	parameter SI.Angle alt "Fixed concentrator altitude";
equation
	R_foc = wbus.dni*A_con*cos(alt - wbus.alt);
end IdealAzi;
