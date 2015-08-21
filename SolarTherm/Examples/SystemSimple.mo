within SolarTherm.Examples;
model SystemSimple "Simple system with control"
	import SI = Modelica.SIunits;
	import SolarTherm.Optics.SolarSimple;
	import SolarTherm.Storage.TankSimple;
	import SolarTherm.PowerBlocks.GenSimple;
	parameter Real upper(min=0, max=1, unit="1") = 0.8 "Frac for solar shutdown";
	parameter Real lower (min=0, max=1, unit="1") = 0.2 "Frac for gen shutdown";
	parameter Real band (min=0, max=1, unit="1") = 0.05 "Band for hysteresis";
	SolarSimple sol;
	TankSimple tank;
	GenSimple gen;
initial equation
	sol.on = true;
	gen.on = false;
equation
	connect(sol.port1, tank.port1);
	connect(tank.port2, gen.port1);
	//sol.on = (tank.e <= upper*tank.emax);
	//gen.on = (tank.e >= lower*tank.emax);
algorithm
	when tank.e > (upper + band)*tank.emax then
		sol.on := false;
	end when;
	when tank.e < (upper - band)*tank.emax then
		sol.on := true;
	end when;
	when tank.e > (lower + band)*tank.emax then
		gen.on := true;
	end when;
	when tank.e < (lower - band)*tank.emax then
		gen.on := false;
	end when;
end SystemSimple;
