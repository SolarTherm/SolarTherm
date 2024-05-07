within SolarTherm.Utilities;

// FIXME rename this to OptDispatch or similar... name is not representative.
// FIXME place this in a folder near other dispatch strategy routines...

function LinProgFuncVariability
    import SolarTherm.Utilities.Tables.STMotab;

    input STMotab.STMotab wea_motab;
    input STMotab.STMotab pri_motab;
    input Integer horizon;
    input Real dt;
    input Real time_simul;
    input Real etaC;
    input Real etaG;
    input Real DEmax;
    input Real SLmax;
    input Real SLinit;
    input Real SLmin;
    input Real Ahelio;
    output Real Dispatch;
    external "C" Dispatch = st_linprog_variability(wea_motab,pri_motab
            ,horizon,dt,time_simul
            ,etaC,etaG
            ,DEmax,SLmax,SLinit,SLmin
            ,Ahelio
        );
    annotation(Library="st_linprog");
end LinProgFuncVariability;

