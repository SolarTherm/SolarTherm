#include <glpk.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

//#define ST_LINPROG_DEBUG
//#define ST_LINPROG_GIF

#ifdef ST_LINPROG_DEBUG
#define MSG(FMT, ...) fprintf(stdout, "%s:%d: " FMT "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#define MSG1(FMT, ...) fprintf(stdout, "%s:%d: " FMT, __FILE__, __LINE__, ##__VA_ARGS__)
#define MSG2(FMT, ...) fprintf(stdout, FMT, ##__VA_ARGS__)
#define MSGL fprintf(stdout, "\n")
#else
#define MSG(...) ((void)0)
#define MSG1(...) ((void)0)
#define MSG2(...) ((void)0)
#define MSGL ((void)0)
#endif

#define ERR(FMT, ...) fprintf(stderr, "%s:%d: " FMT "\n", __FILE__, __LINE__, ##__VA_ARGS__)

#define ST_ERRVAL (-999999.)
/*
    Calculate the optimal dispatch strategy of the TES and H₂ storage by
    minimising the penalty for a certain forecast horizon with the objective function as follows:
            F = - c0 H₂,ᵣ + C₁ H₂,ᵥ
    where it essentially is minimising the burning of the H₂ (H₂,ᵥ) to pre-heat the H₂ going to the reactor (H₂,ᵣ).

    ******* General parameters
    @param t0, double                       Initial time (s)
    @param c0, double                       Rewards for producing H₂
    @param c1, double                       Penalty for burning H₂ to generate heat for H₂,ᵣ
    @param c2, double                       Penalty for dumping solar field heat
    @param c3, double                       Penalty for dumping PV
    @param horizon, int                     Forecast horizon (hours)
    @param dt,double                        Time stepping of the linear programming (hours)
    @param c_ratio, double                  Ratio between H₂ recycled and H₂,ᵣ (-)

    ******* Efficiencies
    @param etaPB, double                    Power block design point efficiency (-)
    @param etaSF, double*                   Solar field efficiency for the next forecast horizon. Passed as an array with
                                            length == forecast horizon (-)
    @param etaRCV, double                   Receiver net thermal efficiency at design point (-)
    @param etaAEL, double                   Electrolyser efficiency at design point (-)
    @param etaBurner, double                H₂ burner efficiency (-)
    @param etaResistive, double             Resistive heater efficiency (-)

    ******* Weather data
    @param dni, double*                     DNI for the next forecast horizon (W/m²)

    ******* Electrolyser
    @param P_AEL_nameplate, double          Nameplate of the electrolyser (MW)

    ******* Solar field parameters
    @param A_sf, double                     Solar field total area (m²)

    ******* Net PV energy in
    @param P_PV_in_z, double*               PV energy in -- given by Modelica as an array [MWe]

    ******* PB and TES parameters
    @param PB_size, double                  Power block nameplate (MW)
    @param TES_capacity, double             Thermal energy storage capacity (MWhth)
    @param Q_TES_HX_max, double             Maximum dispatchable thermal power from the TES to the TES-heater to heat-up
                                            H₂,ᵣ + H₂ recycled (MW)
    @param E_TES_init, double               Initial TES level, passed on by SolarTherm (MWhth)
    @param E_TES_min, double                Minimum allowable energy in TES (MWhth)

    ******* H₂ storage parameters
    @param Q_H2_reactor_max, double         Maximum heat from the H₂ storage to the reactor (MWth) -- caried by the H₂,ᵣ
    @param LHV, double                      Lower heating value of the H₂ (MJ)
    @param delta_h_H2, double               Enthalpy change of the H₂ before and after the pre-heating (MJ/kg)
    @param H2stg_capacity, double           Maximum capacity of the H₂ storage (MWhth)
    @param H2stg_init, double               Initial H₂ storage level, passed on by SolarTherm (MWhth)
    @param H2stg_min, double                Minimum allowable energy in H₂ (MWhth)
*/

void st_linprog_dualtank(
    double c0, double c1, double c2, double c3, int horizon, double dt, double c_ratio,
    double etaPB, double etaSF[], double etaRCV[], double etaAEL, double etaBurner, double etaResistive,
    double dni[], double P_PV_in_z[], double P_AEL_nameplate, double A_sf,
    double PB_size, double TES_capacity, double Q_TES_HX_max, double E_TES_init, double E_TES_min,
    double Q_H2_reactor_max, double LHV, double delta_h_H2, double H2stg_capacity, double H2stg_init, double H2stg_min,
    double t0, double* optimalSolution
)
{
    //*************** Printing some stuff
    MSG("Optimisation at time = %f s with time step = %f h", t0, dt);
    MSG("Forecast horizon = %d h", horizon);    
    MSG("Reward of producing H2 = %f", c0);
    MSG("Penalty of burning H2 = %f", c1);

    MSG("Initial TES level = %.3f MWhth, %.3f \%", E_TES_init, E_TES_init / TES_capacity * 100);
    MSG("TES capacity = %.3f MWhth", TES_capacity);
    MSG("Minimum TES capacity = %.3f, %.3f \%", E_TES_min, E_TES_min/TES_capacity * 100);

    MSG("Maximum TES heat to PB = %.3f MWth", PB_size / etaPB);
    MSG("Maximum TES heat to TES-heater = %.3f MWth", Q_TES_HX_max);

    MSG("Initial hyrdogen storage level = %.3f MWhth, %.3f \%", H2stg_init, H2stg_init / H2stg_capacity * 100);
    MSG("Hydrogen storage capacity = %.3f MWhth", H2stg_capacity);
    MSG("Minimum hydrogen storage capacity = %.3f, %.3f \% ", H2stg_min, H2stg_min/  H2stg_capacity*100);

    MSG("Maximum hydrogen heat to reactor = %.3f MWth", Q_H2_reactor_max);
    MSG("Maximum hydrogen heat to burner = %.3f", Q_TES_HX_max / etaBurner);

    #ifdef ST_LINPROG_DEBUG
        fprintf(stderr,"c0 = %f\nc1 = %f\nc_ratio = %f\netaPB = %f\n",c0,c1,c_ratio,etaPB);

        fprintf(stderr,"\netaSF:\n");

        for(int i=0; i<horizon;i++){
            fprintf(stderr,"%f,",etaSF[i]);
        }
        fprintf(stderr,"\netaRCV = %.3f\n",etaRCV);
        fprintf(stderr,"etaAEL = %.3f\n",etaAEL);
        fprintf(stderr,"etaBurner = %.3f\n",etaBurner);
        fprintf(stderr,"etaResistive = %.3f\n",etaResistive);

        fprintf(stderr,"DNI:\n");

        for(int i=0; i<horizon;i++){
            fprintf(stderr,"%1f,",dni[i]);
        }

        fprintf(stderr,"\nPV_in:\n");

        for(int i=0; i<horizon;i++){
            fprintf(stderr,"%1f,",P_PV_in_z[i]);
        }

        fprintf(stderr,"\nP_AEL_nameplate = %.3f\n",P_AEL_nameplate);
        fprintf(stderr,"A_sf = %.3f\n",A_sf);
        fprintf(stderr,"PB_size = %.3f\n",PB_size);

        fprintf(stderr,"TES capacity = %.3f MWhth\n", TES_capacity);
        fprintf(stderr,"Q_TES_HX_max = %.3f MWhth\n", Q_TES_HX_max);
        fprintf(stderr,"Initial TES level = %.3f MWhth, %.3f \%\n", E_TES_init, E_TES_init / TES_capacity * 100);
        fprintf(stderr,"Minimum TES capacity = %.3f, %.3f \%\n", E_TES_min, E_TES_min/TES_capacity * 100);

        fprintf(stderr,"LHV = %.3f\n",LHV);
        fprintf(stderr,"Q_H2_reactor_max = %.3f MWth\n", Q_H2_reactor_max);
        fprintf(stderr,"delta_h_h2 = %.3f MWth\n", delta_h_H2);
        fprintf(stderr,"Hydrogen storage capacity = %.3f MWhth\n", H2stg_capacity);
        fprintf(stderr,"Initial hyrdogen storage level = %.3f MWhth, %.3f \%\n", H2stg_init, H2stg_init / H2stg_capacity * 100);
        fprintf(stderr,"Minimum hydrogen storage capacity = %.3f, %.3f \%\n", H2stg_min, H2stg_min/  H2stg_capacity*100);

        fprintf(stderr,"Maximum TES heat to PB = %.3f MWth\n", PB_size / etaPB);
        fprintf(stderr,"Maximum TES heat to TES-heater = %.3f MWth\n", Q_TES_HX_max);
        fprintf(stderr,"Maximum hydrogen heat to burner = %.3f\n", Q_TES_HX_max / etaBurner);
    #endif


    //*************** Initialise the GLP problem
    glp_prob *P = glp_create_prob();

    /*
    Variables in the problem

    There are 12 variables in the problem

        1. Q_H2_reactor     : Heat sent to the reactor by the H₂ storage (carried by H₂,ᵣ) (MWth)
        2. Q_H2_burner      : Heat sent to the H₂ burner by H₂ storage to heat-up H₂,ᵣ + H₂ recycle (MWth)
        3. E_TES            : Level of TES (MWhth)
        4. E_H2stg          : Level of H₂ storage (MWhth)
        5. Q_TES_PB         : Heat sent to the PB by TES (MWth)
        6. Q_TES_HX         : Heat sent to the TES-heater to heat-up H₂,ᵣ + H₂ recycled (MWth)
        7. Q_SF_TES         : Heat sent to the TES by the solar field (MWth)
        8. Q_SF_dumped      : Heat dumped by the solar field (MWth)
        9. P_PV_TES         : Power sent by PV array to TES to heat-up the hot particles (MWe)
        10. P_PV_AEL        : Power sent by PV array to electrolyser to produce H₂ (MWe)
        11. P_PV_dumped     : Power dumped by PV array (MWe)
        12. P_AEL           : Power sent to the H₂ storage (before electrolyser losses) by the electrolyser (MWe)
    */

    #define NAMEMAX 255

    //*************** Indexing the weather and SF efficiency data -- since GLPK index starts at 1 --> weird!!!???
    #define DNI(I) (I - 1)
    #define PVZI(I) (I - 1)
    #define ETASF(I) (I - 1)

    //*************** Definine some intermediate functions for indexing the GLP matrices
    #define N ((int)(horizon/dt))
    #define i_Q_H2_reactor(I) (I)
    #define i_Q_H2_burner(I) (I + i_Q_H2_reactor(N))
    #define i_E_TES(I) (I + i_Q_H2_burner(N))
    #define i_E_H2stg(I) (I + i_E_TES(N))
    #define i_Q_TES_PB(I) (I + i_E_H2stg(N))
    #define i_Q_TES_HX(I) (I + i_Q_TES_PB(N))
    #define i_Q_SF_TES(I) (I + i_Q_TES_HX(N))
    #define i_Q_SF_dumped(I) (I + i_Q_SF_TES(N))
    #define i_P_PV_TES(I) (I + i_Q_SF_dumped(N))
    #define i_P_PV_AEL(I) (I + i_P_PV_TES(N))
    #define i_P_PV_dumped(I) (I + i_P_PV_AEL(N))
    #define i_P_AEL(I) (I + i_P_PV_dumped(N))

    //**************************** Adding columns
    glp_add_cols(
        P, i_P_AEL(N)
    );

    //**************************** Naming the GLP columns
    char sss[NAMEMAX];
    for (int i = 1; i <= N; i++)
    {
        snprintf(sss, NAMEMAX, "Q_H2_reactor_%02d", i);
        glp_set_col_name(P, i_Q_H2_reactor(i), sss);
        snprintf(sss, NAMEMAX, "Q_H2_burner_%02d", i);
        glp_set_col_name(P, i_Q_H2_burner(i), sss);
        snprintf(sss, NAMEMAX, "E_TES_%02d", i);
        glp_set_col_name(P, i_E_TES(i), sss);
        snprintf(sss, NAMEMAX, "E_H2stg_%02d", i);
        glp_set_col_name(P, i_E_H2stg(i), sss);
        snprintf(sss, NAMEMAX, "Q_TES_PB_%02d", i);
        glp_set_col_name(P, i_Q_TES_PB(i), sss);
        snprintf(sss, NAMEMAX, "Q_TES_HX_%02d", i);
        glp_set_col_name(P, i_Q_TES_HX(i), sss);
        snprintf(sss, NAMEMAX, "Q_SF_TES_%02d", i);
        glp_set_col_name(P, i_Q_SF_TES(i), sss);
        snprintf(sss, NAMEMAX, "Q_SF_dumped_%02d", i);
        glp_set_col_name(P, i_Q_SF_dumped(i), sss);
        snprintf(sss, NAMEMAX, "P_PV_TES_%02d", i);
        glp_set_col_name(P, i_P_PV_TES(i), sss);
        snprintf(sss, NAMEMAX, "P_PV_AEL_%02d", i);
        glp_set_col_name(P, i_P_PV_AEL(i), sss);
        snprintf(sss, NAMEMAX, "P_PV_dumped_%02d", i);
        glp_set_col_name(P, i_P_PV_dumped(i), sss);
        snprintf(sss, NAMEMAX, "P_AEL_%02d", i);
        glp_set_col_name(P, i_P_AEL(i), sss);
    }
	/*
    MSG("COLUMN NAMES");
    for (int i = 1; i <= i_P_AEL(N); i++)
    {
        MSG("%3d: %s", i, glp_get_col_name(P, i));
    }
    */

    /*
    SET THE OBJECTIVE FUNCTIONS

        max ∑(c0 Q_H2_reactor - c1 Q_H2_burner)     Maximise the H₂ production to the reactor while penalising
                                                    the burning of H₂ in the H₂ burner
    */

    glp_set_obj_dir(P, GLP_MAX);

    for (int i = 1; i <= N; ++i)
    {
        glp_set_obj_coef(P, i_Q_H2_reactor(i), 1 * c0);      	// Rewarding the production of H₂
        glp_set_obj_coef(P, i_Q_H2_burner(i), -1 * c1);      	// Penalising the burning of H₂

        //*********************** Variables that do not affect the obj func -- set coeff == 0
        glp_set_obj_coef(P, i_E_TES(i),       0); 
        glp_set_obj_coef(P, i_E_H2stg(i),     0); 
        glp_set_obj_coef(P, i_Q_TES_PB(i),    0); 
        glp_set_obj_coef(P, i_Q_TES_HX(i),    0); 
        glp_set_obj_coef(P, i_Q_SF_TES(i),    0); 
        glp_set_obj_coef(P, i_Q_SF_dumped(i), -1 * c2);
        glp_set_obj_coef(P, i_P_PV_TES(i),    0); 
        glp_set_obj_coef(P, i_P_PV_AEL(i),    0); 
        glp_set_obj_coef(P, i_P_PV_dumped(i), -1 * c3);
        glp_set_obj_coef(P, i_P_AEL(i),       0); 
    }

    /*Printing coefficient for debugging
    #ifdef ST_LINPROG_DEBUG
    MSG("Printing the objective function coefficient");
    for (int i = 1; i <= i_P_AEL(N); ++i){
        double v = glp_get_obj_coef(
            P,i
        );
        fprintf(stderr, "%.0f,",v);
        if(i%N==0){
            fprintf(stderr, "\n",v);
        }
    }        
    #endif
    */

    /*
    SET THE VARIABLE BOUNDS

        0           ≤         Q_H2_reactor        ≤ Q_H2_reactor_max
        0           ≤         Q_H2_burner         ≤ Q_TES_HX_max/etaBurner
        E_TES_min   ≤         E_TES               ≤ TES_capacity
        H2stg_min   ≤         E_H2stg             ≤ H2stg_capacity
        0           ≤         Q_TES_PB            ≤ PB_size/etaPB
        0           ≤         Q_TES_HX            ≤ Q_TES_HX_max
        0           ≤         Q_SF_TES            ≤ dni * A_sf * etaSF * etaRCV / 1e6 [Convert to MWth]
        0           ≤         Q_SF_dumped         ≤ dni * A_sf * etaSF * etaRCV / 1e6 [Convert to MWth]
        0           ≤         P_PV_TES            ≤ P_PV_in_z
        0           ≤         P_PV_AEL            ≤ P_PV_in_z
        0           ≤         P_PV_dumped         ≤ P_PV_in_z
        0           ≤         P_AEL               ≤ P_AEL_nameplate
    */

   for(int i=1; i<=N; i++){
        /*Grab the DNI, GHI and etaSF from the array supplied by SolarTherm*/
        double dni_i = dni[DNI(i)];
        double eta_rcv_i = etaRCV[DNI(i)];
        double pvz_i = P_PV_in_z[PVZI(i)];
        double etaSF_i = etaSF[ETASF(i)];

        glp_set_col_bnds(
            P, i_Q_H2_reactor(i), GLP_DB, 0, Q_H2_reactor_max
        );
        glp_set_col_bnds(
            P, i_Q_H2_burner(i), GLP_DB, 0, Q_TES_HX_max/etaBurner
        );
        glp_set_col_bnds(
            P, i_E_TES(i), GLP_DB, E_TES_min, TES_capacity
        );
        glp_set_col_bnds(
            P, i_E_H2stg(i), GLP_DB, H2stg_min, H2stg_capacity
        );
        glp_set_col_bnds(
            P, i_Q_TES_PB(i), GLP_DB, 0, PB_size/etaPB
        );
        glp_set_col_bnds(
            P, i_Q_TES_HX(i), GLP_DB, 0, Q_TES_HX_max
        );

        double cons_sf = dni_i * A_sf * etaSF_i * eta_rcv_i / 1e6;
        double cons_pv = pvz_i;

        if(cons_sf == 0){
            glp_set_col_bnds(
                P, i_Q_SF_TES(i), GLP_FX, 0.0, 0.0
            );
            glp_set_col_bnds(
                P, i_Q_SF_dumped(i), GLP_FX, 0.0, 0.0
            );
        }else{
            glp_set_col_bnds(
                P, i_Q_SF_TES(i), GLP_DB, 0.0, cons_sf
            );
            glp_set_col_bnds(
                P, i_Q_SF_dumped(i), GLP_DB, 0.0, cons_sf
            );
        };

        if(cons_pv == 0){
            glp_set_col_bnds(
                P, i_P_PV_TES(i), GLP_FX, 0.0, 0.0
            );
            glp_set_col_bnds(
                P, i_P_PV_AEL(i), GLP_FX, 0.0,  0.0
            );
            glp_set_col_bnds(
                P, i_P_PV_dumped(i), GLP_FX, 0.0,  0.0
            ); 

        }else{
            glp_set_col_bnds(
                P, i_P_PV_TES(i), GLP_DB, 0.0, cons_pv
            );
            glp_set_col_bnds(
                P, i_P_PV_AEL(i), GLP_DB, 0.0,  cons_pv
            );
            glp_set_col_bnds(
                P, i_P_PV_dumped(i), GLP_DB, 0.0,  cons_pv
            );            
        }

        glp_set_col_bnds(
            P, i_P_AEL(i), GLP_DB, 0,  P_AEL_nameplate
        );        
   }

    /*PROBLEM FORMULATION*/

    /*
     There are 6N+1 energy balance equations which are:
        ----> N numbers for TES energy balance
        ----> N numbers for solar field energy balance
        ----> N numbers for PV energy balance
        ----> N numbers for H₂ stroage energy balance
        ----> N numbers for heat exchanger energy balance
        ----> N numbers for electrolyser energy balance
        ----> 1 for long-term TES energy balance where the level of TES at the end of the forecast doesn't change
              in relative to the initial value
   */

    //*********************** Intermediate functions for constraint matrix indexing
    #define TES_EB_REV(I) (I)                           // TES energy balance
    #define TES_EB(I) (I + N*1)                         // TES energy balance
    #define SF_EB_REV(I) (I + N*2)                      // Solar field energy balance
    #define SF_EB(I) (I + N*3)                          // Solar field energy balance
    #define PV_EB_REV(I) (I + N*4)                      // PV energy balance
    #define PV_EB(I) (I + N*5)                          // PV energy balance
    #define AEL_EB_REV(I) (I + N*6)                     // Electrolyser energy balance
    #define AEL_EB(I) (I + N*7)                         // Electrolyser energy balance
    #define H2stg_EB_REV(I) (I + N*8)                   // H₂ storage energy balance
    #define H2stg_EB(I) (I + N*9)                       // H₂ storage energy balance
    #define HTR_EB_REV(I) (I +N*10)                     // H₂ heating energy balance
    #define HTR_EB(I) (I + N*11)                        // H₂ heating energy balance
    #define TES_LEB(I) (I + N*12)                       // Long term energy balance for TES

    //********************** Adding rows to the GLP problem
    //glp_add_rows(P, TES_LEB(N));
    glp_add_rows(P, HTR_EB(N));
    //MSG("Number of rows = %d",TES_LEB(N));
    MSG("Number of rows = %d",HTR_EB(N));
    MSG("Number of cols = %d",i_P_AEL(N));

    //********************** Populating the rows
    for (unsigned i = 1; i <= N; i++)
    {
        //************** Grab the array data (dni, ghi, etaSF)
        double dni_i = dni[DNI(i)];
        double eta_rcv_i = etaRCV[DNI(i)];
        double pvz_i = P_PV_in_z[PVZI(i)];
        double etaSF_i = etaSF[ETASF(i)];

        /*
        0. TES energy balance reversed
                -E_TES[i] + E_TES[i-1] + Q_SF_TES Δt + P_PV_TES etaResistive Δt - Q_TES_PB Δt - Q_TES_HX Δt = 0
                    -1         +1             +dt              +etaResistive dt           -dt         -dt
                i == 1, E_TES[i-1] = -E_TES_init

        8. H₂ storage energy balance reversed
                -E_H2stg[i] + E_H2stg[i-1] + P_AEL etaAEL Δt - Q_H2_burner Δt - Q_H2_reactor Δt = 0
                    -1            +1            etaAEL +dt            -dt             -dt
                i == 0, E_H2stg[i-1] = -H2stg_init
        */

        if (i == 1){
            //****************************** Deal with the LHS of the equation
            /*
                -E_TES[i]  + Q_SF_TES Δt + P_PV_TES etaResistive Δt - Q_TES_PB Δt - Q_TES_HX Δt = -E_TES_init
                    -1           +dt            +etaResistive dt           -dt         -dt   
            */
            glp_set_mat_row(
                P, TES_EB_REV(i), 5,
                   (int[]){0 , i_E_TES(i), i_Q_SF_TES(i),  i_P_PV_TES(i)            , i_Q_TES_PB(i)  ,i_Q_TES_HX(i)},
                (double[]){0 ,     -1    ,      +dt     ,  etaResistive * +dt       ,     -dt        ,      -dt     }
            );

            /*
                -E_H2stg[i] +  P_AEL etaAEL Δt - Q_H2_burner Δt - Q_H2_reactor Δt = -H2stg_init
                     -1            etaAEL +dt            -dt             -dt
            */
            glp_set_mat_row(
                P, H2stg_EB_REV(i), 4,
                   (int[]){0 , i_E_H2stg(i),   i_P_AEL(i)      , i_Q_H2_burner(i), i_Q_H2_reactor(i)},
                (double[]){0 ,     -1      ,     etaAEL * +dt  ,        -dt      ,      -dt         }
            );

            //****************************** Deal with the RHS of the equation
            glp_set_row_bnds(
                P, TES_EB_REV(i), GLP_UP, 0.0, -E_TES_init
            );

            glp_set_row_bnds(
                P, H2stg_EB_REV(i), GLP_UP, 0.0, -H2stg_init
            );
        }
        else{
            //****************************** Deal with the LHS of the equation
            /*
                -E_TES[i] + E_TES[i-1]  + Q_SF_TES Δt + P_PV_TES etaResistive Δt - Q_TES_PB Δt - Q_TES_HX Δt = 0
                    -1          +1            +dt            +etaResistive dt           -dt         -dt   
            */
            glp_set_mat_row(
                P, TES_EB_REV(i), 6,
                   (int[]){0 , i_E_TES(i), i_E_TES(i)-1,  i_Q_SF_TES(i), i_P_PV_TES(i)    , i_Q_TES_PB(i) , i_Q_TES_HX(i)},
                (double[]){0 ,     -1    ,     +1      ,       +dt     ,etaResistive * +dt,     -dt        ,     -dt     }
            );

            /*
                -E_H2stg[i] + E_H2stg[i-1] + P_AEL etaAEL Δt - Q_H2_burner Δt - Q_H2_reactor Δt = 0
                     -1            +1          etaAEL +dt            -dt             -dt
            */

            glp_set_mat_row(
                P, H2stg_EB_REV(i), 5,
                   (int[]){0 , i_E_H2stg(i), i_E_H2stg(i)-1,  i_P_AEL(i)    , i_Q_H2_burner(i), i_Q_H2_reactor(i)},
                (double[]){0 ,     -1      ,       +1      ,  etaAEL * +dt  ,        -dt      ,      -dt         }
            );
            
            //****************************** Deal with the RHS of the equation 
            glp_set_row_bnds(
                P, TES_EB_REV(i), GLP_UP, 0.0, 0.0
            );

            glp_set_row_bnds(
                P, H2stg_EB_REV(i), GLP_UP, 0.0, 0.0
            );
        }

        //Naming the rows
        snprintf(sss,NAMEMAX,"TES_EB_REV%02d",i); glp_set_row_name(P,TES_EB_REV(i),sss);
        snprintf(sss,NAMEMAX,"H2stg_EB_REV%02d",i); glp_set_row_name(P,H2stg_EB_REV(i),sss);


        /*
        1. TES energy balance
                E_TES[i] - E_TES[i-1] - Q_SF_TES Δt - P_PV_TES etaResistive Δt + Q_TES_PB Δt + Q_TES_HX Δt = 0
                i == 1, TES_l[i-1] = E_TES_init

        9. H₂ storage energy balance
                E_H2stg[i] - E_H2stg[i-1] - P_AEL etaAEL Δt + Q_H2_burner Δt + Q_H2_reactor Δt = 0
                i == 0, E_H2stg[i-1] = H2stg_init
        */

        if (i == 1){
            //****************************** Deal with the LHS of the equation
            /*
                E_TES[i] - Q_SF_TES Δt - P_PV_TES etaResistive Δt + Q_TES_PB Δt + Q_TES_HX Δt = E_TES_init
                    +1         -dt            -etaResistive dt           +dt         +dt   
            */
            glp_set_mat_row(
                P, TES_EB(i), 5,
                   (int[]){0 , i_E_TES(i), i_Q_SF_TES(i),      i_P_PV_TES(i)    , i_Q_TES_PB(i) ,i_Q_TES_HX(i)},
                (double[]){0 ,     +1    ,      -dt     ,  etaResistive * -dt   ,    +dt        ,     +dt     }
            );

            /*
                E_H2stg[i] - P_AEL etaAEL Δt + Q_H2_burner Δt + Q_H2_reactor Δt = H2stg_init
                    +1          -etaAEL dt           dt                dt
            */
            glp_set_mat_row(
                P, H2stg_EB(i), 4,
                   (int[]){0 , i_E_H2stg(i),     i_P_AEL(i)   , i_Q_H2_burner(i), i_Q_H2_reactor(i)},
                (double[]){0 ,     +1      ,     -dt *etaAEL  ,         dt      ,       dt         }
            );

            //****************************** Deal with the RHS of the equation 
            glp_set_row_bnds(
                P, TES_EB(i), GLP_UP, 0.0, E_TES_init
            );

            glp_set_row_bnds(
                P, H2stg_EB(i), GLP_UP, 0.0, H2stg_init
            );
        }
        else{
            //****************************** Deal with the LHS of the equation
            /*
                E_TES[i] -  E_TES[i-1] - Q_SF_TES Δt - P_PV_TES etaResistive Δt + Q_TES_PB Δt + Q_TES_HX Δt = 0
                    +1         -1            -dt            -etaResistive dt           +dt         +dt   
            */
            glp_set_mat_row(
                P, TES_EB(i), 6,
                   (int[]){0 , i_E_TES(i), i_E_TES(i)-1,  i_Q_SF_TES(i), i_P_PV_TES(i)   , i_Q_TES_PB(i) , i_Q_TES_HX(i)},
                (double[]){0 ,     +1    ,     -1      ,       -dt     ,-dt *etaResistive,     dt        ,       dt     }
            );

            /*
                E_H2stg[i] - E_H2stg[i-1] - P_AEL etaAEL Δt + Q_H2_burner Δt + Q_H2_reactor Δt = 0
                    +1             -1         -etaAEL dt           dt                dt
            */
            glp_set_mat_row(
                P, H2stg_EB(i), 5,
                   (int[]){0 , i_E_H2stg(i), i_E_H2stg(i)-1,  i_P_AEL(i)   , i_Q_H2_burner(i), i_Q_H2_reactor(i)},
                (double[]){0 ,     +1      ,       -1      ,  -dt *etaAEL  ,         dt      ,       dt         }
            );
            
            //****************************** Deal with the RHS of the equation
            glp_set_row_bnds(
                P, TES_EB(i), GLP_UP, 0.0, 0.0
            );

            glp_set_row_bnds(
                P, H2stg_EB(i), GLP_UP, 0.0, 0.0
            );
        }

        //Naming the rows
        snprintf(sss,NAMEMAX,"TES_EB_%02d",i); glp_set_row_name(P,TES_EB(i),sss);
        snprintf(sss,NAMEMAX,"H2stg_EB_%02d",i); glp_set_row_name(P,H2stg_EB(i),sss);

        /*
        2. SF energy balance reversed
            -Q_SF_TES Δt  - Q_SF_dump Δt =  -A_sf * etaSF * etaRcv * DNI Δt

        ****************************** Deal with the LHS of the equation
            -Q_SF_TES Δt  - Q_SF_dump Δt =  -A_sf * etaSF * etaRcv * DNI Δt
                -dt             -dt               
        */
        glp_set_mat_row(
            P, SF_EB_REV(i), 2,
               (int[]){0,   i_Q_SF_TES(i),    i_Q_SF_dumped(i)},
            (double[]){0,      -dt       ,         -dt        }
        );

        //****************************** Deal with the RHS of the equation
        glp_set_row_bnds(
            P, SF_EB_REV(i), GLP_UP, 
            0.0, -A_sf * etaSF_i * eta_rcv_i * dni_i * dt /1e6
        );

        //Naming the rows
        snprintf(sss,NAMEMAX,"SF_EB_REV%02d",i); glp_set_row_name(P,SF_EB_REV(i),sss);

        /*
        3. SF energy balance 
            Q_SF_TES Δt + Q_SF_dump Δt =  A_sf * etaSF * etaRcv * DNI Δt

        ****************************** Deal with the LHS of the equation
             Q_SF_TES Δt + Q_SF_dump Δt =  A_sf * etaSF * etaRcv * DNI Δt
                +dt             +dt               
        */
        glp_set_mat_row(
            P, SF_EB(i), 2,
               (int[]){0,  i_Q_SF_TES(i),   i_Q_SF_dumped(i)},
            (double[]){0,      dt       ,         dt        }
        );

        //****************************** Deal with the RHS of the equation
        glp_set_row_bnds(
            P, SF_EB(i), GLP_UP, 
            0.0, A_sf * etaSF_i * eta_rcv_i * dni_i * dt/1e6
        );

        //Naming the rows
        snprintf(sss,NAMEMAX,"SF_EB_%02d",i); glp_set_row_name(P,SF_EB(i),sss);

        /*
        4. PV energy balance reversed
            -P_PV_TES Δt - P_PV_dump Δt - P_PV_AEL Δt = - P_PVPin_z Δt

        ****************************** Deal with the LHS of the equation
            -P_PV_TES Δt - P_PV_dump Δt - P_PV_AEL Δt = - P_PVPin_z Δt
                -dt             -dt         -dt
        */
        glp_set_mat_row(
            P, PV_EB_REV(i), 3,
               (int[]){0,  i_P_PV_TES(i),   i_P_PV_dumped(i),   i_P_PV_AEL(i)},
            (double[]){0,      -dt      ,        -dt        ,       -dt      }
        );

        //****************************** Deal with the RHS of the equation
        glp_set_row_bnds(
            P, PV_EB_REV(i), GLP_UP, 
            0.0, -pvz_i *dt
        );
        
        //Naming the rows
        snprintf(sss,NAMEMAX,"PV_EB_REV%02d",i); glp_set_row_name(P,PV_EB_REV(i),sss);

        /*
        5. PV energy balance
                P_PV_TES Δt + P_PV_dump Δt + P_PV_AEL Δt = P_PVPin_z Δt

        ****************************** Deal with the LHS of the equation
            P_PV_TES Δt + P_PV_dump Δt + P_PV_AEL Δt = P_PVPin_z Δt
                 +dt          +dt           +dt
        
        */
        glp_set_mat_row(
            P, PV_EB(i), 3,
               (int[]){0,  i_P_PV_TES(i),   i_P_PV_dumped(i),   i_P_PV_AEL(i)},
            (double[]){0,      dt       ,         dt        ,        dt      }
        );

        //Deal with the RHS
        glp_set_row_bnds(
            P, PV_EB(i), GLP_UP, 
            0.0, pvz_i *dt
        );
        
        //Naming the rows
        snprintf(sss,NAMEMAX,"PV_EB_%02d",i); glp_set_row_name(P,PV_EB(i),sss);

        /*
        6. Electrolyser energy balance reversed
                -Q_TES_PB etaPB Δt - P_PV_AEL Δt + P_AEL Δt = 0

        ****************************** Deal with the LHS of the equation
                -Q_TES_PB etaPB Δt - P_PV_AEL Δt + P_AEL Δt = 0
                       -etaPB dt         -dt          +dt
        */
        glp_set_mat_row(
            P, AEL_EB_REV(i), 3,
               (int[]){0,  i_Q_TES_PB(i)   ,   i_P_PV_AEL(i)    ,   i_P_AEL(i)},
            (double[]){0,   -etaPB * dt    ,       -dt          ,       +dt   }
        );

        //****************************** Deal with the RHS
        glp_set_row_bnds(
            P, AEL_EB_REV(i), GLP_UP, 
            0.0, 0.0
        );
        
        //Naming the rows
        snprintf(sss,NAMEMAX,"AEL_EB_REV%02d",i); glp_set_row_name(P,AEL_EB_REV(i),sss);   

        /*
        7. Electrolyser energy balance 
                Q_TES_PB etaPB Δt + P_PV_AEL Δt - P_AEL Δt = 0
        
        ****************************** Deal with the LHS of the equation
                Q_TES_PB etaPB Δt + P_PV_AEL Δt - P_AEL Δt = 0
                    +etaPB dt          +dt          -dt
        */
        glp_set_mat_row(
            P, AEL_EB(i), 3,
               (int[]){0,  i_Q_TES_PB(i)   ,   i_P_PV_AEL(i)    ,   i_P_AEL(i)},
            (double[]){0,  +etaPB * dt     ,       dt       ,         -dt      }
        );

        //****************************** Deal with the RHS
        glp_set_row_bnds(
            P, AEL_EB(i), GLP_UP, 
            0.0, 0.0
        );
        
        //Naming the rows
        snprintf(sss,NAMEMAX,"AEL_EB_%02d",i); glp_set_row_name(P,AEL_EB(i),sss);   

        /*
        10. Heater energy balance reversed
                (Q_H2_reactor/LHV * -c_ratio) * Δh_H2 dt + Q_H2_burner * etaBurner dt + Q_TES_HX dt = 0
        
        //****************************** Deal with the LHS
                (Q_H2_reactor/LHV * -c_ratio) * Δh_H2 dt + Q_H2_burner * etaBurner dt + Q_TES_HX dt = 0
                        -c_ratio/LHV * Δh_H2 dt                     +etaBurner dt           dt
        */
        glp_set_mat_row(
            P, HTR_EB_REV(i), 3,
               (int[]){0,   i_Q_H2_reactor(i)               ,   i_Q_H2_burner(i)            ,   i_Q_TES_HX(i)},
            (double[]){0,  -c_ratio/LHV*delta_h_H2*dt       ,   +dt * etaBurner             ,       +dt      }
        );

        //****************************** Deal with the RHS
        glp_set_row_bnds(
            P, HTR_EB_REV(i), GLP_UP, 
            0.0, 0.0
        );
        
        //Naming the rows
        snprintf(sss,NAMEMAX,"HTR_EB_REV%02d",i); glp_set_row_name(P,HTR_EB_REV(i),sss);


        /*
        11. Heater energy balance 
                (Q_H2_reactor/LHV * c_ratio) * Δh_H2 dt - Q_H2_burner * etaBurner dt - Q_TES_HX dt = 0
        
        //****************************** Deal with the LHS
                (Q_H2_reactor/LHV * c_ratio) * Δh_H2 dt - Q_H2_burner * etaBurner dt - Q_TES_HX dt = 0
        */
        glp_set_mat_row(
            P, HTR_EB(i), 3,
               (int[]){0,  i_Q_H2_reactor(i)                ,   i_Q_H2_burner(i)            ,   i_Q_TES_HX(i)},
            (double[]){0,  c_ratio/LHV*delta_h_H2*dt        ,   -dt * etaBurner             ,       -dt      }
        );

        //****************************** Deal with the RHS
        glp_set_row_bnds(
            P, HTR_EB(i), GLP_UP, 
            0.0, 0.0
        );
        
        //Naming the rows
        snprintf(sss,NAMEMAX,"HTR_EB_%02d",i); glp_set_row_name(P,HTR_EB(i),sss);

        

        /*
        12. Long term TES energy balance
                E_TES[N] = E_TES_init
                 Σ(Q_TES_PB + Q_TES_HX - Q_SF - P_PV_TES) = 0

        //****************************** Deal with the LHS
                 Σ(Q_TES_PB + Q_TES_HX - Q_SF - P_PV_TES) = 0
                      +1         +1        -1       -1
        */
        //Deal with the LHS
        //for(int j=1;j<=N;j++){
        //    glp_set_mat_row(
        //        P, TES_LEB(i), 4,
        //        (int[]){0,  i_Q_TES_PB(i), i_Q_TES_HX(i), i_Q_SF_TES(i), i_P_PV_TES(i)},
        //        (double[]){0,      1,           1       ,   -1          ,   -1        }
        //    );
        //}
        //
//
        //////Deal with the RHS
        //glp_set_row_bnds(
        //    P, TES_LEB(i), GLP_UP, 
        //    0.0, 0.0
        //);

        //Set row name
        //glp_set_row_name(P,TES_LEB,"TES_LEB");    
    }


    //Message attributes
	glp_smcp parm;
	glp_init_smcp(&parm);

    #ifdef ST_LINPROG_DEBUG
	    parm.msg_lev = GLP_MSG_ALL; // GLP_MSG_ERR;
    #else
	    parm.msg_lev = GLP_MSG_OFF;
    #endif

    //Solve the LP problem
    int res  = glp_simplex(
        P, &parm
    );

	int printres = 0;
	char *msg;
	if(res == 0){
		MSG("LP successfully solved");
	}else{
		switch(res){
		case GLP_EBADB: msg = "Invalid initial basis";break;
		case GLP_ESING: msg = "Singular matrix";break;
		case GLP_ECOND: msg = "Ill-conditioned matrix";break;
		case GLP_EBOUND:msg = "Incorrect bounds";break;
		case GLP_EFAIL: msg = "Solver failure";break;
		default: msg = "unrecognised error code";
		}

		printres = 1;
	}

    /*
    Grab the results, which are:
        - P_PV_AEL                  How much PV electricity used to run the electrolyser
        - P_PV_TES                  How much PV electricity used to charge TES
        - Q_TES_PB                  How much TES heat used to run PB
        - Q_TES_HX                  How much TES heat used to heat H₂
        - Q_H2_reactor              How much hot H₂ production
        - Q_H2_burner               How much hot H₂ got burned
    */

    double P_PV_AEL     = glp_get_col_prim(P,i_P_PV_AEL(1));
    double P_PV_TES     = glp_get_col_prim(P,i_P_PV_TES(1));
    double P_PV_dumped  = glp_get_col_prim(P,i_P_PV_dumped(1));
    double Q_TES_PB     = glp_get_col_prim(P,i_Q_TES_PB(1));
    double Q_TES_HX     = glp_get_col_prim(P,i_Q_TES_HX(1));
    double Q_H2_reactor = glp_get_col_prim(P,i_Q_H2_reactor(1));
    double Q_H2_burner  = glp_get_col_prim(P,i_Q_H2_burner(1));
    double H2level      = glp_get_col_prim(P,i_E_H2stg(1))/H2stg_capacity*100;
    double TES_level    = glp_get_col_prim(P,i_E_TES(1))/TES_capacity*100;
    double Q_SF_TES     = glp_get_col_prim(P,i_Q_SF_TES(1));
    double Q_SF_dumped  = glp_get_col_prim(P,i_Q_SF_dumped(1));

    MSG("OPTIMAL DISPATCH FOR THE NEXT HOUR");
    MSG("P_PV_AEL: %.3f MWe", P_PV_AEL);
    MSG("P_PV_TES: %.3f MWe", P_PV_TES);
    MSG("Q_TES_PB: %.3f MWe", Q_TES_PB);
    MSG("Q_TES_HX: %.3f MWe", Q_TES_HX);
    MSG("Q_H2_reactor: %.3f MWe", Q_H2_reactor);
    MSG("Q_H2_burner: %.3f MWe", Q_H2_burner);

    if(res){
		//ERR("GLPK error %d: %s",res,msg);
		optimalSolution[0] = -987654321;
		optimalSolution[1] = -987654321;
		optimalSolution[2] = -987654321;
		optimalSolution[3] = -987654321;
		optimalSolution[4] = -987654321;
		optimalSolution[5] = -987654321;
		optimalSolution[6] = -987654321;
		optimalSolution[7] = -987654321;
		optimalSolution[8] = -987654321;
    }else{
        //fprintf(stderr, "\n\nLP is solved with status %d at t = %.2f s\n", res, t0);
        double Q_SF_TES = glp_get_col_prim(P,i_Q_SF_TES(1));
        double Q_SF_dumped = glp_get_col_prim(P,i_Q_SF_dumped(1));
        double Q_SF_in = Q_SF_TES + Q_SF_dumped;
        
        /*fprintf(
            stderr,
            "===============================\nTES capacity: %.3f MWhth\nP_PV_in: %.3f MWe\nP_PV_AEL: %.3f MWe\nP_PV_TES: %.3f MWe\nP_PV_dumped: %.3f MWe\nQ_SF_in: %.3f MWth\nQ_SF_TES: %.3f MWth\nQ_SF_dumped: %.3f MWth\nQ_TES_PB: %.3f MWth\nQ_TES_HX: %.3f MWth\nQ_TES_HX_max: %.3f MWth\nH2 stg level: %.2f \%\nTES init: %.2f \%\nTES level: %.2f \%\nQ_H2_reactor: %.3f MWth\nQ_H2_reactor_max: %.3f MWth\nQ_H2_burner: %.3f MWth\nQ_H2_burner_max: %.3f MWth\nt0: %.2f s\n===============================\n",
            TES_capacity, P_PV_in_z[0] ,P_PV_AEL, P_PV_TES, P_PV_dumped, Q_SF_in, Q_SF_TES, Q_SF_dumped, Q_TES_PB, Q_TES_HX, Q_TES_HX_max, H2level, E_TES_init/TES_capacity*100,TES_level, Q_H2_reactor, Q_H2_reactor_max, Q_H2_burner, Q_TES_HX_max/etaBurner,t0
        );*/
        

        double PV_in = P_PV_AEL + P_PV_TES + P_PV_dumped;

        if(PV_in==0){
            optimalSolution[0] = 0;
            optimalSolution[1] = 0;
            optimalSolution[2] = 0;
        }else{
            optimalSolution[0] = P_PV_AEL/(PV_in);
            optimalSolution[1] = P_PV_TES/(PV_in);
            optimalSolution[2] = P_PV_dumped/(PV_in);

        }
        optimalSolution[3] = Q_TES_PB/(PB_size/etaPB);
        optimalSolution[4] = Q_TES_HX/(Q_TES_HX_max);
        optimalSolution[5] = Q_H2_reactor/(Q_H2_reactor_max);
        optimalSolution[6] = Q_H2_burner/(Q_TES_HX_max/etaBurner);

        
        if(Q_SF_in==0){
            optimalSolution[7] = 0;
            optimalSolution[8] = 0;
        }else{
            optimalSolution[7] = Q_SF_TES/Q_SF_in;
            optimalSolution[8] = Q_SF_dumped/Q_SF_in;
        }
    }

    /*Print time series data to CSV*/
    #ifdef ST_LINPROG_DEBUG
        FILE* fpt2;
        fpt2 = fopen("./optimal_solution.csv","w+");
        fprintf(
            fpt2, "time,Q_SF_in [MWth],Q_SF_TES [MWth],Q_SF_dumped [MWth],P_PV_in [MWe],P_PV_TES [MWe],P_PV_dumped [MWe],P_PV_AEL [MWe],Q_TES_PB [MWth], Q_TES_HX [MWth],P_AEL [MWe],Q_AEL_H2stg [MWth],E_TES [\%],E_H2stg [%],Q_H2_reactor [MJ],Q_H2_burner [MJ],Balance SF [MWth],Balance PV [MWe],Balance AEL [MWe],Balance HX [MWth],Balance H2 stg [MWth],Balance TES [MWth]\n"
        );

        for(int i=1;i<=N;i++){
            double t_ = (i-1) * 3600;
            double Q_SF_in = dni[DNI(i)] * A_sf * etaSF[ETASF(i)] * etaRCV[ETASF(i)] /1e6;
            double Q_SF_TES = glp_get_col_prim(P,i_Q_SF_TES(i));
            double Q_SF_dumped = glp_get_col_prim(P,i_Q_SF_dumped(i));
            double P_PV_in = P_PV_in_z[PVZI(i)];
            double P_PV_TES = glp_get_col_prim(P,i_P_PV_TES(i));
            double P_PV_dumped = glp_get_col_prim(P,i_P_PV_dumped(i));
            double P_PV_AEL = glp_get_col_prim(P,i_P_PV_AEL(i));
            double Q_TES_PB = glp_get_col_prim(P,i_Q_TES_PB(i));
            double Q_TES_HX = glp_get_col_prim(P,i_Q_TES_HX(i));
            double P_AEL = glp_get_col_prim(P,i_P_AEL(i));
            double Q_AEL_H2stg = P_AEL * etaAEL;
            double E_TES = glp_get_col_prim(P,i_E_TES(i))/TES_capacity * 100;
            double E_H2stg = glp_get_col_prim(P,i_E_H2stg(i))/H2stg_capacity * 100;
            double Q_H2_reactor = glp_get_col_prim(P, i_Q_H2_reactor(i));
            double Q_H2_burner = glp_get_col_prim(P, i_Q_H2_burner(i));

            //Energy balance
            double balance_SF = Q_SF_in  - Q_SF_TES - Q_SF_dumped;
            double balance_PV = P_PV_in - P_PV_TES - P_PV_dumped - P_PV_AEL;
            double balance_ael = P_AEL - Q_TES_PB * etaPB - P_PV_AEL;
            double balance_hx = Q_H2_reactor / LHV * c_ratio * delta_h_H2 - Q_TES_HX - Q_H2_burner * etaBurner;

            double balance_TES;
            double balance_H2stg;

            if(i==1){
                balance_TES = glp_get_col_prim(P,i_E_TES(i)) - E_TES_init - Q_SF_TES - P_PV_TES + Q_TES_PB + Q_TES_HX;
                balance_H2stg = glp_get_col_prim(P,i_E_H2stg(i)) - H2stg_init - P_AEL * etaAEL + Q_H2_burner + Q_H2_reactor;
            }else{
                balance_TES = glp_get_col_prim(P,i_E_TES(i)) - glp_get_col_prim(P,i_E_TES(i)-1) - Q_SF_TES - P_PV_TES + Q_TES_PB + Q_TES_HX;
                balance_H2stg = glp_get_col_prim(P,i_E_H2stg(i)) - glp_get_col_prim(P,i_E_H2stg(i)-1) - P_AEL * etaAEL + Q_H2_burner + Q_H2_reactor;
            }
            fprintf(
                fpt2, 
                "%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f, %.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n",
                t_, Q_SF_in, Q_SF_TES, Q_SF_dumped, P_PV_in, P_PV_TES, P_PV_dumped, P_PV_AEL, Q_TES_PB, Q_TES_HX, P_AEL, Q_AEL_H2stg, E_TES, E_H2stg, Q_H2_reactor, Q_H2_burner, balance_SF, balance_PV, balance_ael, balance_hx, balance_TES, balance_H2stg
            );
        }
        fclose(fpt2);
    #endif
    /*
    #ifdef ST_LINPROG_GIF
        //Check if the file has been created
        char* fname = "./dispatch_optimisation.csv";
        int maxchar = 200000;
        char* to_fill = malloc(sizeof(char) * maxchar);

        if(fopen(fname,"r") == NULL){
            //File doesn't exist so create the file
            FILE* fp_gif_new = fopen(fname,"a");

            //Appending the first column
            char sss[maxchar];
            snprintf(sss,maxchar,"%s,","time");
            strcpy(to_fill,sss);

            for(int i=1;i<=N;i++){
                snprintf(sss,maxchar,"P_PV_AEL%02d,",i);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                snprintf(sss,maxchar,"P_PV_TES%02d,",i);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                snprintf(sss,maxchar,"P_PV_dumped%02d,",i);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                snprintf(sss,maxchar,"Q_SF_TES%02d,",i);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                snprintf(sss,maxchar,"Q_SF_dumped%02d,",i);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                snprintf(sss,maxchar,"Q_TES_HX%02d,",i);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                if(i<N){
                    snprintf(sss,maxchar,"Q_TES_PB%02d,",i);
                    strcat(to_fill,sss);
                }else{
                    snprintf(sss,maxchar,"Q_TES_PB%02d\n",i);
                    strcat(to_fill,sss);
                }
            };
            fprintf(
                fp_gif_new, 
                to_fill
            );
            fclose(fp_gif_new);

        }else{
            FILE* fp_gif_append = fopen(fname,"a");

            //Appending the first value which is time
            char sss[maxchar];
            snprintf(sss,maxchar,"%.0f,",t0);
            strcpy(to_fill,sss);

            //Looping the value we wish to make the gif out of
            for(int i=1;i<=N;i++){
                double val = glp_get_col_prim(P,i_P_PV_AEL(i));
                snprintf(sss,maxchar,"%.1f,",val);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                double val = glp_get_col_prim(P,i_P_PV_TES(i));
                snprintf(sss,maxchar,"%.1f,",val);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                double val = glp_get_col_prim(P,i_P_PV_dumped(i));
                snprintf(sss,maxchar,"%.1f,",val);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                double val = glp_get_col_prim(P,i_Q_SF_TES(i));
                snprintf(sss,maxchar,"%.1f,",val);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                double val = glp_get_col_prim(P,i_Q_SF_dumped(i));
                snprintf(sss,maxchar,"%.1f,",val);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                double val = glp_get_col_prim(P,i_Q_TES_HX(i));
                snprintf(sss,maxchar,"%.1f,",val);
                strcat(to_fill,sss);
            };
            for(int i=1;i<=N;i++){
                if(i<N){
                    double val = glp_get_col_prim(P,i_Q_TES_PB(i));
                    snprintf(sss,maxchar,"%.1f,",val);
                    strcat(to_fill,sss);
                }else{
                    double val = glp_get_col_prim(P,i_Q_TES_PB(i));
                    snprintf(sss,maxchar,"%.1f\n",val);
                    strcat(to_fill,sss);
                }
            };
            fprintf(stderr, "READY to store!!\n");
            fprintf(stderr, "%s\n", to_fill);

            fprintf(
                fp_gif_append, 
                to_fill
            );
            fclose(fp_gif_append);

        }
    #endif
    */

    #ifdef ST_LINPROG_GIF

        int maxchar = 200000;
        char fname[maxchar];
        snprintf(fname,maxchar,"./disp/dispatch_optimisation_%.0f.csv",t0);
        FILE* fp_gif_new = fopen(fname,"w+");

        //Tending the column
        char sss2[maxchar];
        char* to_fill = malloc(sizeof(char) * maxchar);
        
        snprintf(sss2,maxchar,"%s,","time");
        strcpy(to_fill,sss2);

        for(int i=1;i<=N;i++){
            snprintf(sss2,maxchar,"P_PV_AEL%02d,",i);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            snprintf(sss2,maxchar,"P_PV_TES%02d,",i);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            snprintf(sss2,maxchar,"P_PV_dumped%02d,",i);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            snprintf(sss2,maxchar,"Q_SF_TES%02d,",i);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            snprintf(sss2,maxchar,"Q_SF_dumped%02d,",i);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            snprintf(sss2,maxchar,"Q_TES_HX%02d,",i);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            snprintf(sss2,maxchar,"E_TES%02d,",i);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            snprintf(sss2,maxchar,"E_H2stg%02d,",i);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            if(i<N){
                snprintf(sss2,maxchar,"Q_TES_PB%02d,",i);
                strcat(to_fill,sss2);
            }else{
                snprintf(sss2,maxchar,"Q_TES_PB%02d\n",i);
                strcat(to_fill,sss2);
            }
        };

        //Appending the rows
        snprintf(sss2,maxchar,"%.0f,",t0);
        strcat(to_fill,sss2);

        //Looping the value we wish to make the gif out of
        for(int i=1;i<=N;i++){
            double val = glp_get_col_prim(P,i_P_PV_AEL(i));
            snprintf(sss2,maxchar,"%.1f,",val);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            double val = glp_get_col_prim(P,i_P_PV_TES(i));
            snprintf(sss2,maxchar,"%.1f,",val);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            double val = glp_get_col_prim(P,i_P_PV_dumped(i));
            snprintf(sss2,maxchar,"%.1f,",val);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            double val = glp_get_col_prim(P,i_Q_SF_TES(i));
            snprintf(sss2,maxchar,"%.1f,",val);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            double val = glp_get_col_prim(P,i_Q_SF_dumped(i));
            snprintf(sss2,maxchar,"%.1f,",val);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            double val = glp_get_col_prim(P,i_Q_TES_HX(i));
            snprintf(sss2,maxchar,"%.1f,",val);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            double val = glp_get_col_prim(P,i_E_TES(i));
            snprintf(sss2,maxchar,"%.1f,",val);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            double val = glp_get_col_prim(P,i_E_H2stg(i));
            snprintf(sss2,maxchar,"%.1f,",val);
            strcat(to_fill,sss2);
        };
        for(int i=1;i<=N;i++){
            if(i<N){
                double val = glp_get_col_prim(P,i_Q_TES_PB(i));
                snprintf(sss2,maxchar,"%.1f,",val);
                strcat(to_fill,sss2);
            }else{
                double val = glp_get_col_prim(P,i_Q_TES_PB(i));
                snprintf(sss2,maxchar,"%.1f\n",val);
                strcat(to_fill,sss2);
            }
        };
        fprintf(stderr, "READY to store!!\n");
        fprintf(stderr, "%s\n", to_fill);

        fprintf(
            fp_gif_new, 
            to_fill
        );

        fclose(fp_gif_new);
    #endif

	/*Free all the memory used in this script*/
	glp_free_env();
}
