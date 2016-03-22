within SolarTherm.Receivers;
model OnePipeRC "Receiver with single pipe"
	extends SolarTherm.Receivers.FluidRC;
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;

	replaceable model Elem = SolarTherm.Receivers.Elem; // must be replaced
	Elem elem[nelem](redeclare package Medium=Medium);
equation
	connect(port_a, elem[1].port_a);
	connect(elem[nelem].port_b, port_b);
	for i in 1:(nelem-1) loop
		connect(elem[i].port_b, elem[i+1].port_a);
	end for;

	for i in 1:nelem loop
		connect(wbus, elem[i].wbus);
		connect(R[i], elem[i].R);
	end for;
end OnePipeRC;
