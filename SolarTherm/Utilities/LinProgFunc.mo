within SolarTherm.Utilities;

function LinProgFunc
 input String filepathDNI;
 input String filepathPrice;
 input Integer horison;
 input Real dt;
 input Real time_simul;
 input Real etaC;
 input Real etaG;
 input Real t_stg;
 input Real DEmax;
 input Real SLmax;
 input Real SLinit;
 input Real SLminrel;
 input Real Ahelio;
 output Real Dispatch;
 external "C" Dispatch = st_linprog(filepathDNI,filepathPrice,
                                    horison,dt,time_simul,etaC,
                                    etaG,t_stg,DEmax,SLmax,SLinit,
                                    SLminrel,Ahelio);
                                    
 annotation(Library ={"linprog","glpk"},
            LibraryDirectory="modelica://SolarTherm/Resources/Include/lib");

end LinProgFunc;