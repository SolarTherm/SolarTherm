within SolarTherm.Utilities;
function ReceiverStartupTime
	extends Modelica.Icons.Function;
	input Integer nsteps;
	input Real dni[nsteps];
	input Real eta_op[nsteps];
	input Real A_field;
	input Real dt;
	input Real Q_min;
	output Real t;
	external "C" t = energy(dni, eta_op, A_field, dt, nsteps, Q_min);
      annotation(Library="st_receiver_startup_time");                                  
 //annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
  //          Include="#include \"st_receiver_startup_time.c\"");

end ReceiverStartupTime;
