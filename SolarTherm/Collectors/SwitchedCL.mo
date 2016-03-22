within SolarTherm.Collectors;
block SwitchedCL "Collector that can be switched on/off sun"
	extends SolarTherm.Collectors.Collector;
	import SI = Modelica.SIunits;

	replaceable model OptEff = SolarTherm.Collectors.OptEff; // should replace

	input Boolean track "Set to true to start tracking";

	OptEff oeff(nelem=nelem);
equation
	connect(wbus, oeff.wbus);
	for i in 1:nelem loop
		R_foc[i] = if track then max(oeff.eff[i]*wbus.dni*A, 0) else 0;
	end for;
end SwitchedCL;
