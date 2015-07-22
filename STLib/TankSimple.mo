within STLib;
model TankSimple "Energy tank"
	import SI = Modelica.SIunits;
	import STLib.PortSimple;
	parameter SI.Energy emax = 1000 "Maximum energy";
	parameter SI.Energy e0 = 0 "Starting energy";
	SI.Energy e(start=e0, fixed=true, min=0, max=emax) "Energy in tank";
	PortSimple port1;
	PortSimple port2;
initial equation
equation
	der(e) = port1.p + port2.p;
end TankSimple;
