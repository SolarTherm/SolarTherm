within SolarTherm.Models.CSP.CRS.HeliostatsField;
block SteeredCL "Collector that can be partially steered on sun"
	extends SolarTherm.Models.CSP.CRS.HeliostatsField.Collector;
	import SI = Modelica.SIunits;

	replaceable model OptEff =
		SolarTherm.Models.CSP.CRS.HeliostatsField.OptEff;   // should replace
	parameter Real steer_rate(min=0)
	"Speed of mirror steer as fraction of total mirrors per second";
	parameter Real target_error(min=0, max=1) = 0.01
	"Allowed error between target and actual";
	parameter Real actual_0(min=0, max=1) = 0 "Start position";

	parameter SI.Irradiance dni_start = 0.001 "DNI at which concentrator starts";
	parameter SI.Irradiance dni_stop = 0 "DNI at which concentrator stops";

	input Real target(min=0, max=1) "Target fraction of mirrors on sun";
	Real actual(min=0, max=1) "Actual fraction of mirrors on sun";

	OptEff oeff(nelem=nelem, orient_north=orient_north);

	Integer state(min=1, max=2) "Concentrator operating state";

initial equation
	actual = actual_0;
	state = 1;

	algorithm
	when state == 1 and wbus.dni >= dni_start then
		state := 2; // on sun
	elsewhen state == 2 and (wbus.dni <= dni_stop) then
		state := 1; // off sun
	end when;

equation
	connect(wbus, oeff.wbus);

	if actual > target + target_error then
		der(actual) = -steer_rate;
	elseif actual < target - target_error then
		der(actual) = steer_rate;
	else
		der(actual) = 0;
	end if;

	for i in 1:nelem loop
		if state == 2 then
			R_foc[i] = actual*oeff.eff[i]*wbus.dni*A;
		else
			R_foc[i] = 0;
		end if;
	end for;

end SteeredCL;
