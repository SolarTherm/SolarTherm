within STLib;
model GenSimple "Simple Generator"
	import SI = Modelica.SIunits;
	import STLib.PortSimple;
	parameter SI.Efficiency eff = 0.9 "Efficiency of generator";
	parameter SI.Power pnom = 400 "Generator power";
	PortSimple port1;
	SI.Power p;
	Boolean on(start=false) "Whether or not generator is on";
equation
	port1.p = if (on) then pnom else 0;
	p = eff*port1.p;
end GenSimple;
