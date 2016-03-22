within SolarTherm.Receivers;
partial model EnergyRC "Solar receiver with energy interface"
	extends SolarTherm.Receivers.Receiver;
	import SI = Modelica.SIunits;

	SolarTherm.Fluid.Interfaces.EnergyPort p;
end EnergyRC;
