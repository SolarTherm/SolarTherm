within SolarTherm.Interfaces;
connector EnergyPort "Energy Port"
	// Will through warnings because it has no "potential" variable
	import SI = Modelica.SIunits;
	flow SI.Power P;
end EnergyPort;
