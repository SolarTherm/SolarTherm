within SolarTherm.Models.CSP.CRS.Receivers;
partial model EnergyRC "Solar receiver with energy interface"
 extends SolarTherm.Models.CSP.CRS.Receivers.Receiver;
 import SI = Modelica.SIunits;

  SolarTherm.Models.Fluid.Interfaces.EnergyPort p;
end EnergyRC;
