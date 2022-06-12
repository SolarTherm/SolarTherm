within SolarTherm.Utilities;
function ReceiverStartupEnergy
	input Integer nsteps;
	input Real H_rcv;
	input Real D_rcv;
	input Real ab;
	input Real em;
	input Real dni[nsteps];
	input Real eta_op[nsteps];
	input Real Tamb[nsteps];
	input Real Wspd[nsteps];
	input Real CL[4];
	input Real C4L[4];
	input Real CH[5];
	input Real A_field;
	input Real dt;
	output Real E;
	external "C" E = energy(H_rcv, D_rcv, ab, em, dni, eta_op, Tamb, Wspd, CL, C4L, CH, A_field, dt, nsteps);
        
      annotation(Library="st_receiver_startup_energy");
                          
 //annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
   //         Include="#include \"st_receiver_startup_energy.c\"");

end ReceiverStartupEnergy;
