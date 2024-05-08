within SolarTherm.Utilities;

// FIXME rename this to OptDispatch or similar... name is not representative.
// FIXME place this in a folder near other dispatch strategy routines...

function LinProgFuncVariability
    import SolarTherm.Utilities.Tables.STMotab;

    input STMotab.STMotab pv_motab;
    input STMotab.STMotab wnd_motab;
	input Real P_elec_max_pv;
	input Real P_elec_max_wind;
	input Real P_elec_pv_ref_size;
	input Real P_elec_wind_ref_size;
    input Integer horizon;
    input Real dt;
    input Real time_simul;
    input Real etaH;
    input Real etaG;
    input Real DEmax;
    input Real SLmax;
    input Real SLinit;
    input Real SLmin;
    input Real P_max;
    output Real Dispatch;
    external "C" Dispatch = st_linprog_variability(pv_motab,wnd_motab
			,P_elec_max_pv,P_elec_max_wind
			,P_elec_pv_ref_size,P_elec_wind_ref_size
            ,horizon,dt,time_simul
            ,etaH,etaG
            ,DEmax,SLmax,SLinit,SLmin
            ,P_max
        );
    annotation(Library="st_linprog");
end LinProgFuncVariability;

