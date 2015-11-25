within SolarTherm.Optics;
block IdealInc "Concentrator with fixed incline that tracks sun azimuth"
	extends SolarTherm.Optics.Concentrator(final nelem=1);
	// Tracks sun azimuth perfectly and conentrates all received energy into
	// focal aperture.
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import Modelica.Math.cos;
	parameter SI.Area A_con "Area of concentrator aperture";
	parameter SI.Angle alt = CN.pi/2 "Fixed concentrator altitude";
	input Boolean track "Set to true to start tracking";
equation
	R_foc[1] = if track then max(wbus.dni*A_con*cos(alt - wbus.alt), 0) else 0;
end IdealInc;
