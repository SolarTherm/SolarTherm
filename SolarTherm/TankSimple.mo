within SolarTherm;
model TankSimple "Energy tank"
	import SI = Modelica.SIunits;
	import SolarTherm.PortSimple;
	parameter SI.Energy emax = 1000 "Maximum energy";
	parameter SI.Energy e0 = 0 "Starting energy";
	SI.Energy e(start=e0, fixed=true, min=0, max=emax) "Energy in tank";
	PortSimple port1;
	PortSimple port2;
initial equation
equation
	der(e) = port1.p + port2.p;
annotation(Icon(graphics={
	Rectangle(
		extent={{-100, -100}, {100, 100}},
		fillColor={0, 200, 200},
		fillPattern=FillPattern.Solid,
		pattern=LinePattern.None),
	Rectangle(
		extent={{-100, -100}, {100, -100 + 200*(e/emax)}},
		fillColor={100, 100, 200},
		fillPattern=FillPattern.Solid,
		pattern=LinePattern.None)
	}));
end TankSimple;
