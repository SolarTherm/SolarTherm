within SolarTherm.Optics;
block SteeredConc "Concentrator that can be partially steered on and off sun"
	extends SolarTherm.Optics.Concentrator;
	import SI = Modelica.SIunits;

	replaceable model FluxMap = SolarTherm.Optics.FluxMap; // should replace FluxMap

	parameter Real steer_rate(min=0) "Speed of mirror steer as fraction of total mirrors per second";
	parameter Real target_error(min=0, max=1) = 0.01 "Allowed error between target and actual";

	input Real target(min=0, max=1) "Target fraction of mirrors on sun";
	Real actual(min=0, max=1) "Actual fraction of mirrors on sun";

	TrackingFlux tflux(
		redeclare model FluxMap=FluxMap,
		nelem=nelem
		);
initial equation
	actual = 0;
equation
	connect(wbus.alt, tflux.alt);
	connect(wbus.azi, tflux.azi);
	connect(wbus.dni, tflux.dni);

	if actual > target + target_error then
		der(actual) = -steer_rate;
	elseif actual < target - target_error then
		der(actual) = steer_rate;
	else
		der(actual) = 0;
	end if;

	R_foc = actual*tflux.R;
end SteeredConc;
