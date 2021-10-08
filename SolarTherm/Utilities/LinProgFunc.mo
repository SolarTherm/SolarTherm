within SolarTherm.Utilities;

function LinProgFunc
 input Real price[:];
 input Integer horison;
 input Real dt;
 input Real time_simul;
 input Real DNI[:];
 input Real etaC[:];
 input Real etaR[:];
 input Real etaG;
 input Real DEmax;
 input Real SLmax;
 input Real SLinit;
 input Real SLminrel;
 input Real Ahelio;
 output Real Dispatch;
 external "C" Dispatch = st_linprog(price, horison, dt, time_simul,
									DNI, etaC, etaR, etaG, DEmax,
									SLmax, SLinit, SLminrel, Ahelio);
                                  
 annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
            Include="#include \"st_linprog.c\"",
            Library = "glpk");

end LinProgFunc;
