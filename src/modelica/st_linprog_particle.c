#include <glpk.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "linprog_particle/linprog.h"
//#include "linprog_particle/linprog.c"

/*METRIC OF THE INPUTS
horizon = hour
dt = hour
time_simul = second
etaC = scalar
etaG = scalar
t_stg = hour
DEmax = MW
SLmax = MWh
SL0rel = scalar
SLminrel = scalar
Ahelio = m.sq
*/

double st_linprog_particle(int horizon, double dt, double time_simul,
                  double etaC[], double DNI[], double price[], //====> field eff., DNI, and price for this forecast horizon
                  double etaG, double t_stg,
                  double DEmax, double SLmax, double SLinit, 
                  double SLminrel, double Ahelio)
{
    const int vars = 4; // variables in this problem SLn, SEn, DEn, XE
    const double index_simul = time_simul / 3600;
    //const float SLinit = SL0rel * SLmax;
    const double SLmin = SLminrel * SLmax;

    printf("time_simul [s], time_index: %f, %f\n",time_simul,index_simul);
    printf("DEmax [MWth]: %f\n",DEmax);
    printf("SLmax [MWh_th]: %f\n",SLmax);
    printf("SLinit [MWh_th]: %f\n",SLinit);
    printf("SLmin [MWh_th]: %f\n",SLmin);

    // Initialise variable for GLPK
    int solution_length = (int)(horizon/dt); // if dt = 1 (hour) then solution length == horizon
    int var = 4; //SL,DE,DE,XE
    int row = 5 * solution_length;
    int col = var * solution_length;
    int ia[1+row*col], ja[1+row*col];
    double ar[1+row*col], z, x[solution_length];

    // Create dummy matrix A - set the values to zeros
    double dummyA[row][col];

    for(size_t i=0;i<row;i++)
    {
        for(size_t j=0;j<col;j++)
        {
            dummyA[i][j]=0;
        }
    }

    //GLPK matrix starts at index 1, s.t. index
    for(size_t i=0;i<solution_length;i++)
    {
        //-SLn + SL n-1 + SEn.Δt - DEn.Δt = 0
        if(i>0)
        {
            dummyA[i][i-1] = 1;
        }
        dummyA[i][i] = -1;
        dummyA[i][i+solution_length] = -dt;
        dummyA[i][i+2*solution_length] = dt;

        //SLn - SL n-1 - SEn.Δt + DEn.Δt = 0
        if(i>0)
        {
            dummyA[i+solution_length][i-1] = -1;
        }
        dummyA[i+solution_length][i] = 1;
        dummyA[i+solution_length][i+solution_length] = dt;
        dummyA[i+solution_length][i+2*solution_length] = -dt;

        //-SEn.Δt - XEn.Δt = -A * ηC * DNIn.Δt
        dummyA[i+2*solution_length][i+2*solution_length] = -dt;
        dummyA[i+2*solution_length][i+3*solution_length] = -dt;

        //SEn.Δt + XEn.Δt = A * ηC * DNIn.Δt
        dummyA[i+3*solution_length][i+2*solution_length] = dt;
        dummyA[i+3*solution_length][i+3*solution_length] = dt;
    }
    
    for(size_t i=0;i<solution_length;i++)
    {
        for(size_t j=0;j<solution_length;j++)
        {
            //∑(DEn-SEn) = 0
            dummyA[i+4*solution_length][j+solution_length]=1;
            dummyA[i+4*solution_length][j+2*solution_length]=-1;
        }
    }

    // Initialise problem object lp
    glp_prob* lp;
    lp = glp_create_prob();

    // Initialise the type of the problem, MAXIMISATION
    glp_set_obj_dir(lp,GLP_MAX);

    // Populate the Right Hand Side of equalities
    glp_add_rows(lp,row);

    for(size_t i=1;i<solution_length+1;i++)
    {
        if(i==1) 
        {   
            //-SL0 + SE0.Δt - DE0.Δt ≤ -SLinit  --> Upper bound
            glp_set_row_bnds(lp,(int)i,GLP_UP,0.0,-SLinit);
            //SL0 - SE0.Δt + DE0.Δt ≤ SLinit  --> Upper bound
            glp_set_row_bnds(lp,(int)i+solution_length,GLP_UP,0,SLinit);           
        }
        else
        {   //-SLn + SL n-1 + SEn.Δt - DEn.Δt ≤ 0 --> Upper bound
            glp_set_row_bnds(lp,(int)i,GLP_UP,0,0);
            //SLn - SL n-1 - SEn.Δt + DEn.Δt ≤ 0 --> Upper bound
            glp_set_row_bnds(lp,(int)i+solution_length,GLP_UP,0,0);
        }
        //-SEn.Δt - XEn.Δt ≤ -A * ηC * DNIn.Δt --> Upper bound
        glp_set_row_bnds(lp,(int)i+2*solution_length,GLP_UP,0.0,-Ahelio*etaC[i-1]*DNI[i-1]*dt/1e6) /*converting from Wh to MWh*/;

        //SEn.Δt + XEn.Δt ≤ A * ηC * DNIn.Δt --> Upper bound
        glp_set_row_bnds(lp,(int)i+3*solution_length,GLP_UP,0.0,Ahelio*etaC[i-1]*DNI[i-1]*dt/1e6) /*converting from Wh to MWh*/;

        //∑(DEn-SEn) ≤ 0 --> Upper bound
        glp_set_row_bnds(lp,(int)i+4*solution_length,GLP_UP,0.0,0.0);
    }

    // Populate the column (variables) in respect to each boundaries
    glp_add_cols(lp,col);

    for(size_t i=1;i<solution_length+1;i++)
    {
        /*SLn ==> SLmin ≤ SLn ≤ SLmax n = 1 -> horizon*/
        glp_set_col_bnds(lp,(int)i,GLP_DB,SLmin,SLmax);
        glp_set_obj_coef(lp,(int)i,0); //==> coefficient of objective function

        /*DEn ==> 0 ≤ DEn ≤ DEmax n = horizon + 1 -> 2 * horizon*/
        glp_set_col_bnds(lp,(int)i+solution_length,GLP_DB,0.0,DEmax);
        glp_set_obj_coef(lp,(int)i+solution_length,etaG*price[i-1]); //==> coefficient of objective function

        /*SEn ==> 0 ≤ SEn ≤ A * ηC * DNIn n = 2 * horizon + 1 -> 3 horizon*/
        double cons = Ahelio*etaC[i]*DNI[i-1];
        if (cons != 0)
        {
            glp_set_col_bnds(lp,(int)i+2*solution_length,GLP_DB,0.0,cons);
            glp_set_col_bnds(lp,(int)i+3*solution_length,GLP_DB,0.0,cons);
        }
        else
        {
            glp_set_col_bnds(lp,(int)i+2*solution_length,GLP_FX,0.0,0.0);
            glp_set_col_bnds(lp,(int)i+3*solution_length,GLP_FX,0.0,0.0);
        }
        
        /*SEn ==> 0 ≤ SEn ≤ A * ηC * DNIn*/
        glp_set_obj_coef(lp,(int)i+2*solution_length,0); //==> objective function

        /*XEn ==> 0 ≤ XEn ≤ A * ηC * DNIn*/
        glp_set_obj_coef(lp,(int)i+3*solution_length,0); //==> objective function
    }

    // Populate the array
    for (size_t i = 1; i < row+1; i++)
    {
        size_t iterator = 1;
        while(iterator<col+1)
        {
            ia[(i-1)*col+iterator]=(int)i;
            iterator++;
        }
    }

    for (size_t i = 1; i < row+1; i++)
    {
        size_t iterator = 1;
        while(iterator<col+1)
        {
            ja[(i-1)*col+iterator]=(int)iterator;
            iterator++;
        }
    }

    for(size_t i=0;i<row;i++)
    {
        for(size_t j=0;j<col;j++)
        {
            ar[i*col+j+1]= dummyA[i][j];
        }
    }
    
    // Load the matrix to lp
    glp_load_matrix(lp,row*col,ia,ja,ar);

    // Message attribute
    glp_smcp parm;
    glp_init_smcp(&parm);
    parm.msg_lev = GLP_MSG_ERR;

    // Solve the lp
    glp_simplex(lp,NULL);

    // Get the value of the optimal obj. function
    z = glp_get_obj_val(lp);
    printf("OPTIMAL OBJ FUNCTION = %f USD\n",z);
	
    printf("DNI [W/m.sq] :\n");
    for(size_t i=1;i<solution_length+1;i++)
    {
        printf("[%.1f] ", DNI[i-1]);      
    }

    printSpace();
	
	printf("Optical efficiency :\n");
    for(size_t i=1;i<solution_length+1;i++)
    {
        printf("[%.4f] ", etaC[i-1]);      
    }
	
	printSpace();

    printf("Optimal Dispatch Energy DE [MWth] :\n");
    for(size_t i=1;i<solution_length+1;i++)
    {
        x[i-1] = glp_get_col_prim(lp,(int)i+solution_length);
        printf("[%.2f]", x[i-1]);      
    }

    printSpace();
    printf("Price [USD/MWh] :\n");
    for(size_t i=1;i<solution_length+1;i++)
    {
        printf("[%.2f]", price[i-1]);      
    }

    printSpace();
    double optimalDispatch = x[0];

	printf("OPTIMAL DISPATCH FOR THE NEXT HOUR: %f\n\n",optimalDispatch);

    /*Free all the memory used in this script*/

    glp_free_env();

    /*end of the code*/

    return optimalDispatch;
}

void printSpace()
{
    printf("\n");
}



