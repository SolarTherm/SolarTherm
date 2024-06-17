#include "linprog/linprog.h"

#include <glpk.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#define ST_LINPROG_DEBUG

#ifdef ST_LINPROG_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
# define MSG1(FMT,...) fprintf(stdout,"%s:%d: " FMT,__FILE__,__LINE__,##__VA_ARGS__)
# define MSG2(FMT,...) fprintf(stdout,FMT,##__VA_ARGS__)
# define MSGL fprintf(stdout,"\n")
#else
# define MSG(...) ((void)0)
# define MSG1(...) ((void)0)
# define MSG2(...) ((void)0)
# define MSGL ((void)0)
#endif

#define ERR(FMT,...) fprintf(stderr,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)

#define ST_ERRVAL (-999999.)

double st_mip(
         MotabData *pvd
        ,MotabData *wnd
        ,double P_elec_max_pv
        ,double P_elec_max_wind
        ,double P_elec_pv_ref_size
        ,double P_elec_wind_ref_size
        ,int horizon // Time horizon for the optimization
        ,double dt // Time step duration
        ,double t0 // Initial time
        ,double eff_heater // Efficiency of the heater
        ,double eff_process // Efficiency of the process
        ,double DEmax // Maximum dispatched energy
        ,double SLmax // Maximum stored energy (storage limit)
        ,double SLinit // Initial stored energy
        ,double SLmin // Minimum stored energy
        ,double ramp_up_fraction // Fraction of DEmax allowed for ramping up
        ,double ramp_dw_fraction // Fraction of DEmax allowed for ramping up
        ,double P_elec_max // Maximum electrical power
        ,double upper_threshold // Minimum energy delivery to the process
        ,double pre_dispatched_heat // Initially pre-dispatched heat
){
    MSG("\n\nt = %f",t0);

    double pvdstep, wndstep;
    assert(0 == motab_check_timestep(pvd,&pvdstep));
    assert(0 == motab_check_timestep(wnd,&wndstep));
    
    static MotabData *pvdcache, *wndcache;
    if(pvdcache != pvd){
        pvdcache = pvd;
        if(pvdstep != dt)ERR("Warning: pv file timestep is %f s, different"
            " from forecasting timestep %f s (message is only shown once)",pvdstep, dt);
    }
    if(wndcache != wnd){
        wndcache = wnd;
        if(wndstep != dt)ERR("Warning: wind file timestep is %fs, different"
            " from forecasting timestep %fs (message is only shown once)",wndstep, dt);
    }

    // check that pvd and wnd can cover the required time range

    double LCOH = 78.0; // Levelized cost of heat
    double MaxRUP = ramp_up_fraction * DEmax; // Maximum ramp-up rate
    double MaxRDW = ramp_dw_fraction * DEmax; // Maximum ramp-down rate
    double MinRUP = 0.0; // Minimum ramp-up rate
    double MinRDW = 0.0; // Minimum ramp-down rate
    double UPT = upper_threshold * DEmax;
    double LPT = 0.05 * DEmax;
    double M = 10*DEmax; // Big M value

    // Print the initial values for debugging purposes
    MSG("t                = %.2f s", t0);
    MSG("dt               = %.2f s", dt);
    MSG("P_elec_max       = %.2f MWt", P_elec_max);
    MSG("eff_heater       = %.2f MWt", eff_heater);
    MSG("eff_process      = %.2f MWt", eff_process);
    MSG("DEmax            = %.2f MWth", DEmax);
    MSG("SLmax            = %.2f MWhth", SLmax);
    MSG("SLinit           = %.2f MWhth", SLinit);
    MSG("SLmin            = %.2f MWhth", SLmin);
    MSG("ramp_up_fraction = %.2f", ramp_up_fraction);
    MSG("Max ramp-up rate = %.2f", MaxRUP);
    MSG("Max ramp-dw rate = %.2f", MaxRDW);
    MSG("DEinit           = %.2f", pre_dispatched_heat);

    if(NULL==pvd)return ST_ERRVAL;
    if(NULL==wnd)return ST_ERRVAL;

    MSG("nrows pvd = %d",pvd->nrows);
    
    //assert(wnd->nrows == 8760);
    //assert(pvd->nrows == 8760);
    
    int wind_col = motab_find_col_by_label(wnd,"power");
    assert(wind_col != -1);

    int pv_col = motab_find_col_by_label(pvd,"power");
    assert(pv_col != -1);

#define WND(I) (\
    /*MSG("WND(%d) at t=%f",I,t0+((I)-1)*dt),*/\
    1e-6*P_elec_max_wind / P_elec_wind_ref_size*motab_get_value_wraparound(wnd,    t0+(I)*dt,wind_col)\
    )
/** as noted above, PV for the ith period (counting from 1) is at t0+i*dt */
#define PV(I) (\
    /*MSG("PV(%d) at t=%f",(I),t0+(I)*dt),*/\
    1e-6*P_elec_max_pv / P_elec_pv_ref_size*motab_get_value_wraparound(pvd,    t0+(I)*dt,pv_col)\
    )

    // Initialize the problem object lp
    glp_prob *P = glp_create_prob();

    // Define the number of steps in the horizon
    #define N (horizon)
    // Define macros for variable indexing
    #define SL(I) (I) // Stored energy
    #define DE(I) (SL(N) + I) // Dispatched energy
    #define SE(I) (DE(N) + I) // State of energy
    #define XE(I) (SE(N) + I) // Auxiliary variable for energy
    #define YON(I) (XE(N) + I) // Disjunct mode for ON state
    #define YOFF(I) (YON(N) + I)
    #define YPAR(I) (YOFF(N) + I)

    // Add columns for variables, including binary variables
    int cols = YPAR(N);
    glp_add_cols(P, cols);

    MSG("Number of cols = %d", cols);

    // Set column names for readability
    #define NAMEMAX 255
    char sss[NAMEMAX];
    for(int i = 1; i <= N; ++i) {
        snprintf(sss, NAMEMAX, "SL%02d", i); glp_set_col_name(P, SL(i), sss); // Stored energy
        snprintf(sss, NAMEMAX, "DE%02d", i); glp_set_col_name(P, DE(i), sss); // Dispatched energy
        snprintf(sss, NAMEMAX, "SE%02d", i); glp_set_col_name(P, SE(i), sss); // State of energy
        snprintf(sss, NAMEMAX, "XE%02d", i); glp_set_col_name(P, XE(i), sss); // Auxiliary variable for energy
        snprintf(sss, NAMEMAX, "YON%02d", i); glp_set_col_name(P, YON(i), sss); // Disjunct mode for ON state
        snprintf(sss, NAMEMAX, "YOFF%02d", i); glp_set_col_name(P, YOFF(i), sss);
        snprintf(sss, NAMEMAX, "YPAR%02d", i); glp_set_col_name(P, YPAR(i), sss);
    }

    // Set the objective function to maximize
    glp_set_obj_dir(P, GLP_MAX);
    for(int i = 1; i <= N; ++i) {
        glp_set_obj_coef(P, DE(i), eff_process * LCOH);
    }

    /* VARIABLE BOUNDS */
    MSG("      \t pvd_i \t wnd_i");
    for(int i = 1; i <= N; ++i) {
        double pvd_i = PV(i);
        double wnd_i = WND(i);
        double p_heat_i = (pvd_i + wnd_i) * eff_heater;
        p_heat_i = fmin(p_heat_i, P_elec_max); 
/*        MSG("%3d: \t %.2f \t %.2f", i, pvd_i, wnd_i); */

        glp_set_col_bnds(P, SL(i), GLP_DB, SLmin, SLmax); // Stored energy bounds
        glp_set_col_bnds(P, DE(i), GLP_DB, 0, DEmax); // Dispatched energy bounds

        if (pvd_i <= 0 && wnd_i <= 0) {
            glp_set_col_bnds(P, SE(i), GLP_FX, 0.0, 0.0); // State of energy bounds for no input
            glp_set_col_bnds(P, XE(i), GLP_FX, 0.0, 0.0); // Auxiliary variable bounds for no input
        } else {
            glp_set_col_bnds(P, SE(i), GLP_DB, 0, p_heat_i); // State of energy bounds
            glp_set_col_bnds(P, XE(i), GLP_DB, 0, p_heat_i); // Auxiliary variable bounds
        }

        // Set bounds for binary variables
        glp_set_col_bnds(P, YON(i), GLP_DB, 0, 1); // Auxiliary variable bounds
        glp_set_col_kind(P, YON(i), GLP_BV); // Set variable as binary

        glp_set_col_bnds(P, YOFF(i), GLP_DB, 0, 1); // Auxiliary variable bounds
        glp_set_col_kind(P, YOFF(i), GLP_BV); // Set variable as binary

        glp_set_col_bnds(P, YPAR(i), GLP_DB, 0, 1); // Auxiliary variable bounds
        glp_set_col_kind(P, YPAR(i), GLP_BV); // Set variable as binary
    }

    /* CONSTRAINTS */

    // Mapping the constraint equations
    #define SEB(I) (I)    // Stored energy balance, 1..N
    #define EDX(I) (I+N)  // Energy stored and dumped, N+1...2N
    #define LEB    (1+EDX(N)) // Long-term energy balance, 2N+1

    glp_add_rows(P, LEB);

    MSG("Number of rows = %d", LEB);

    /*
    1. Dispatched energy balance (N equations)
        SLi - SLi-1 = SEi - DEi        
        Change in storage level equals net (stored minus dispatched) energy.
    */
    for (unsigned i = 1; i <= N; ++i) {
        double pvd_i = PV(i);
        double wnd_i = WND(i);
        double p_heat_i = (pvd_i + wnd_i) * eff_heater;
        p_heat_i = fmin(p_heat_i, P_elec_max);  

        if (i == 1) {
            glp_set_mat_row(P, SEB(i), 3,
            (const int[]){0, SL(i), SE(i), DE(i)},
            (const double[]){0, +1.0, -1.0, +1.0});
            glp_set_row_bnds(P, SEB(i), GLP_FX, SLinit, SLinit);
        } else {
            glp_set_mat_row(P, SEB(i), 4,
            (const int[]){0, SL(i), SL(i - 1), SE(i), DE(i)},
            (const double[]){0, +1.0, -1.0, -1.0, +1.0});
            glp_set_row_bnds(P, SEB(i), GLP_FX, 0.0, 0.0);
        }
        snprintf(sss, NAMEMAX, "SEB%02d", i); glp_set_row_name(P, SEB(i), sss);

        /*
        2. Stored energy balance (N equations)
            SEi + XEi = ηH·(PVi + WNDi)·Δt       
            Collected energy is either stored (SE) or dumped (XE).
        */
        glp_set_mat_row(P, EDX(i), 2,
            (const int[]){0, SE(i), XE(i)},
            (const double[]){0, +1.0, +1.0});
        glp_set_row_bnds(P, EDX(i), GLP_FX, p_heat_i, p_heat_i);
        snprintf(sss, NAMEMAX, "EDX%02d", i); glp_set_row_name(P, EDX(i), sss);
    }

    /*
    3. Long-term energy balance (1 equation)
        ∑(DEi - SEi) = 0       
        No net change in storage level over the forecast interval.
        -- or --
        SL(N) = SLinit.
    */
    glp_set_mat_row(P, LEB, 1,
        (const int[]){0, SL(N)},
        (const double[]){0, +1.0});
    glp_set_row_bnds(P, LEB, GLP_FX, SLinit, SLinit);
    glp_set_row_name(P, LEB, "LEB");


    for (unsigned i = 1; i <= N; ++i) {
        /*
        3. Disjunct modes for x[i] = DE[i]/DEmax
        */
        glp_add_rows(P, 1);
        glp_set_mat_row(P, glp_get_num_rows(P), 2,
            (const int[]){0, DE(i), YON(i)},
            (const double[]){0, 1.0, -M});
        glp_set_row_bnds(P, glp_get_num_rows(P), GLP_LO, UPT-M, 0.0);

        glp_add_rows(P, 1);
        glp_set_mat_row(P, glp_get_num_rows(P), 2,
            (const int[]){0, DE(i), YPAR(i)},
            (const double[]){0, 1.0, +M});
        glp_set_row_bnds(P, glp_get_num_rows(P), GLP_UP, 0.0, UPT+M);

        glp_add_rows(P, 1);
        glp_set_mat_row(P, glp_get_num_rows(P), 2,
            (const int[]){0, DE(i), YPAR(i)},
            (const double[]){0, 1.0, -M});
        glp_set_row_bnds(P, glp_get_num_rows(P), GLP_LO, LPT-M, 0.0);

        glp_add_rows(P, 1);
        glp_set_mat_row(P, glp_get_num_rows(P), 2,
            (const int[]){0, DE(i), YOFF(i)},
            (const double[]){0, 1.0, +M});
        glp_set_row_bnds(P, glp_get_num_rows(P), GLP_UP, 0.0, LPT+M);
    }

    glp_add_rows(P, 1);
    glp_set_mat_row(P, glp_get_num_rows(P), 1,
        (const int[]){0, DE(1)},
        (const double[]){0, +1.0});
    glp_set_row_bnds(P, glp_get_num_rows(P), GLP_UP, 0.0, MaxRUP+pre_dispatched_heat);

    for(int i = 2; i <= N; ++i) {
        glp_add_rows(P, 1);
        glp_set_mat_row(P, glp_get_num_rows(P), 2,
            (const int[]){0, DE(i), DE(i-1)},
            (const double[]){0, +1.0, -1.0});
        glp_set_row_bnds(P, glp_get_num_rows(P), GLP_UP, 0.0, MaxRUP);
    }

    for (unsigned i = 1; i <= N; ++i) {
        glp_add_rows(P, 1);
        glp_set_mat_row(P, glp_get_num_rows(P), 3,
            (const int[]){0, YON(i), YOFF(i), YPAR(i)},
            (const double[]){0, 1.0, 1.0, 1.0});
        glp_set_row_bnds(P, glp_get_num_rows(P), GLP_FX, 1.0, 1.0);
    }

    // Message attribute
    glp_iocp parm;
    glp_init_iocp(&parm);
#ifdef ST_LINPROG_DEBUG
    parm.msg_lev = GLP_MSG_ALL; // GLP_MSG_ERR;
#else
    parm.msg_lev = GLP_MSG_OFF;
#endif

    // Solve the MIP problem using glp_intopt
    parm.presolve = GLP_ON;
    int res = glp_intopt(P, &parm);
    int printres = 0;
    char *msg;

    if(res == 0){
        MSG("MIP successfully solved");
        printres = 1;
    }else{
        switch(res){
        case GLP_EBADB: msg = "Invalid initial basis"; break;
        case GLP_ESING: msg = "Singular matrix"; break;
        case GLP_ECOND: msg = "Ill-conditioned matrix"; break;
        case GLP_EBOUND: msg = "Incorrect bounds"; break;
        case GLP_EFAIL: msg = "Solver failure"; break;
        case GLP_ENOPFS: msg = "MIP instance has no primal feasible solution"; break;
        case GLP_ENODFS: msg = "MIP problem instance has no dual feasible solution"; break;
        default: msg = "unrecognized error code";
        }

        MSG("glp_intopt returned error code %d (%s)", res, msg);
        printres = 1;
        return 0;
    }

    if(printres){
        //glp_print_sol(P,"glpksolution.txt");

        // Get the value of the optimal obj. function
        MSG("OPTIMAL OBJ FUNCTION = %f USD",glp_get_obj_val(P));

    }

    double optimalDispatch = glp_mip_col_val(P, DE(1));

#ifdef ST_LINPROG_DEBUG
    MSG("      \t SL \t SE \t XE \t DE \t YON \t YOFF \t YPAR");
    for(int i = 1; i <= N; ++i){
        MSG("%3d: \t %.1f \t %.1f \t %.1f \t %.1f \t %.1f \t %.1f \t %.1f", i,
        glp_mip_col_val(P, SL(i)),
        glp_mip_col_val(P, SE(i)),
        glp_mip_col_val(P, XE(i)),
        glp_mip_col_val(P, DE(i)),
        glp_mip_col_val(P, YON(i)),
        glp_mip_col_val(P, YOFF(i)),
        glp_mip_col_val(P, YPAR(i))
        );
    }
#endif

    MSG("OPTIMAL DISPATCH FOR THE NEXT HOUR: %f", optimalDispatch);

    /* Free all the memory used in this script */
    glp_delete_prob(P);
    glp_free_env();

    if(res){
        MSG("GLPK error %d: %s", res, msg);
        return -987654321;
    }

    /* End of the code */
    return optimalDispatch;
}

// vim: ts=4:sw=4:noet:tw=80
