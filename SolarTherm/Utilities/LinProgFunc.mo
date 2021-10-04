within SolarTherm.Utilities;

// FIXME rename this to OptDispatch or similar... name is not representative.

function LinProgFunc
    import SolarTherm.Utilities.Tables.STMotab;

    input STMotab.STMotab wea_motab;
    input STMotab.STMotab pri_motab;
    input Integer horizon;
    input Real dt;
    input Real time_simul;
    input Real etaC[:];
    input Real etaG;
    input Real t_stg;
    input Real DEmax;
    input Real SLmax;
    input Real SLinit;
    input Real SLminrel;
    input Real Ahelio;
    output Real Dispatch;
    external "C" Dispatch = st_linprog(wea_motab,pri_motab
            ,horizon,dt,time_simul
            ,etaC,etaG
            ,t_stg,DEmax,SLmax,SLinit,SLminrel
            ,Ahelio
        );
    annotation(Library="st_linprog");
// annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
//            Include="#include \"st_linprog.c\"",
//            Library = "glpk");

end LinProgFunc;

// vim: ts=4:sw=4:et:tw=80
