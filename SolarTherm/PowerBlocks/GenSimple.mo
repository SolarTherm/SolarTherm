within SolarTherm.PowerBlocks;
model GenSimple "Simple Generator"
	import SI = Modelica.SIunits;
	import SolarTherm.Interfaces.Energy.Port;
	parameter SI.Efficiency eff = 0.9 "Efficiency of generator";
	parameter SI.Power pnom = 400 "Generator power";
	input Boolean on(start=false) "Whether or not generator is on";
	output SI.Power p;
	Port port1;
equation
	port1.p = if (on) then pnom else 0;
	p = eff*port1.p;
end GenSimple;
