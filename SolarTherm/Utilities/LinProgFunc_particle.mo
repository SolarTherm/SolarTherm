within SolarTherm.Utilities;

function LinProgFunc_particle
 //input String filepathDNI;
 //input String filepathPrice;
 input Integer horizon;
 input Real dt;
 input Real time_simul;
 input Real etaC[:];
 input Real DNI[:];
 input Real pri[:];
 input Real etaG;
 input Real t_stg;
 input Real DEmax;
 input Real SLmax;
 input Real SLinit;
 input Real SLminrel;
 input Real Ahelio;
 output Real Dispatch;
 external "C" Dispatch = st_linprog_particle(//filepathDNI,filepathPrice,
                                    horizon,dt,time_simul,etaC,DNI,pri,
                                    etaG,t_stg,DEmax,SLmax,SLinit,
                                    SLminrel,Ahelio);
 annotation(Library="st_linprog_particle");

end LinProgFunc_particle;
