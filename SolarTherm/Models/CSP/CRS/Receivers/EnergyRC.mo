within SolarTherm.Models.CSP.CRS.Receivers;
partial model EnergyRC "Solar receiver with energy interface"
	import SI = Modelica.SIunits;
	extends SolarTherm.Models.CSP.CRS.Receivers.Receiver;
	SolarTherm.Models.Fluid.Interfaces.EnergyPort p;
end EnergyRC;
