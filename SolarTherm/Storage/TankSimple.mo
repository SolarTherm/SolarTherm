within SolarTherm.Storage;
model TankSimple "Energy tank"
	import SI = Modelica.SIunits;
	import SolarTherm.Interfaces.Energy.Port;
	parameter SI.Energy E_max = 1000 "Maximum energy";
	parameter SI.Energy E_0 = 0 "Starting energy";
	parameter SolarTherm.Utilities.Finances.Money C_cap = 0 "Capital costs";
	parameter SolarTherm.Utilities.Finances.MoneyPerYear C_main = 0 "Maintenance costs";
	SI.Energy E(start=E_0, fixed=true, min=0, max=E_max) "Energy in tank";
	Port port1;
	Port port2;
initial equation
equation
	der(E) = port1.P + port2.P;
annotation(Icon(graphics={
	Rectangle(
		extent={{-100, -100}, {100, 100}},
		fillColor={0, 200, 200},
		fillPattern=FillPattern.Solid,
		pattern=LinePattern.None),
	Rectangle(
		extent={{-100, -100}, {100, -100 + 200*(E/E_max)}},
		fillColor={100, 100, 200},
		fillPattern=FillPattern.Solid,
		pattern=LinePattern.None)
	}));
end TankSimple;
