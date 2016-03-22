within SolarTherm.Collectors;
block SteeredConc "Collector that can be partially steered on sun"
	extends SolarTherm.Collectors.Collector;
	import SI = Modelica.SIunits;

	replaceable model OptEff = SolarTherm.Collectors.OptEff; // should replace

	parameter SI.Area A_con "Area of concentrator aperture";

	parameter Real steer_rate(min=0) "Speed of mirror steer as fraction of total mirrors per second";
	parameter Real target_error(min=0, max=1) = 0.01 "Allowed error between target and actual";
	parameter Real actual_0(min=0, max=1) = 0 "Start position";

	input Real target(min=0, max=1) "Target fraction of mirrors on sun";
	Real actual(min=0, max=1) "Actual fraction of mirrors on sun";

	OptEff oeff(nelem=nelem);
initial equation
	actual = actual_0;
equation
	connect(wbus, oeff.wbus);

	if actual > target + target_error then
		der(actual) = -steer_rate;
	elseif actual < target - target_error then
		der(actual) = steer_rate;
	else
		der(actual) = 0;
	end if;

	R_foc = actual*oeff.eff*wbus.dni*A_con;
end SteeredConc;
