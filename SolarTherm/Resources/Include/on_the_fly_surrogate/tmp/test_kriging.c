#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <dirent.h>
#include <unistd.h>
#include <limits.h>
#include "lib/ontheflysurrogate.h"

/*How to invert a matrix http://www.macapp.net/MyWikiThings/invertmatrix.c*/
//gcc test_kriging.c -lm -lgsl -lgslcblas -lpython2.7 -o kriging.out
//https://github.com/tensorflow/tensorflow/issues/7541

void check_session(Session_Props* , int , int );
void check_krigingstruct(Kriging_struct* , int , int );

int main()
{   
    /*this part is Modelica --- PB design parameters*/    
    double P_net = 2e7;
    double T_in_ref_blk = 1243.27;
    double p_high = 22707266.48;
    double PR = 2.98;
    double pinch_PHX = 23.67;
    double dTemp_HTF_PHX = 238.45;
    double load_base = 1;
    double T_amb_base = 39 + 273.15;
    int user_choice = 2; //-----------------------> 1 is kriging, 2 is ANN
    int which_ANN_model = 0; //-------------------> 0 is for ANN PB, 1 is for ANN HX
    char* base_path = "/home/philgun/Documents/coolstuff/coolstuff/GSL_Project";

    /*
    Real eta_gross_base(fixed=false);
    Real eta_Q_base(fixed=false);

    //******************** Kriging
    STKrigingOnTheFly Kriging_variables = constructKriging(
        P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,load_base,T_amb_base, 
        eta_gross_base,eta_Q_base,base_path, inputsize, outputsize
        ) ==> call C program, return:
          1) pointer to struct that contains Kriging training data if use Kriging 
          2) NN session if use ANN
    

    //******************** ANN
    int index_ANN_PB = 0;
    int index_ANN_HX = 1;

    STANNOnTheFly session_PB = constructANN(
        P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,load_base,T_amb_base, 
        eta_gross_base,eta_Q_base, index_ANN_PB, base_path, inputsize, outputsize);

    STANNOnTheFly session_HX = constructANN(
        P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,load_base,T_amb_base, 
        eta_gross_base,eta_Q_base, index_ANN_HX, base_path, inputsize, outputsize);

    //******************** Expensive model declaration
    SolarTherm.Models.PowerBlocks.ExpensiveModel sCO2SimonPB(P_net=P_net,T_in_ref,........)
    */

    //initial equation
    double eta_gross_base = 0.49991927091306; //************************eta_gross_base = sCO2SimonPB.eta_gross_design
    double eta_Q_base = 0.9998537337387947; //************************************eta_Q_base = sCO2SimonPB.eta_Q_design

    /*
    equation
    //**************** Kriging
    eta_gross = eta_gross_base - kriging(Kriging_variables, raw_inputs, "eta_gross", "spherical");
    eta_Q= eta_Q_base - kriging(Kriging_variables, raw_inputs, "eta_Q", "spherical");

    //**************** ANN
    eta_gross = eta_gross_base - predcit_ANN(session_PB, raw_inputs, index_ANN_PB);
    eta_Q = eta_Q_base - predcit_ANN(session_HX, raw_inputs, index_ANN_HX);
    */
    /*End of Modelica Program*/


    //******************** Kriging
    int inputsize = 3;
    int outputsize = 2;
    Kriging_struct* Kriging_variables = constructKriging(
      P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,load_base,T_amb_base, 
      eta_gross_base,eta_Q_base,base_path,inputsize, outputsize);

    printf("\n\nCheck Kriging Struct\n");
    check_krigingstruct(Kriging_variables, inputsize, outputsize);
    
    destructKriging(Kriging_variables);


    //******************** ANN PB
    Session_Props* session_PB = constructANN(
      P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,load_base,T_amb_base, 
      eta_gross_base,eta_Q_base, which_ANN_model, base_path, inputsize, outputsize);

    //******************** ANN HX
    which_ANN_model = 1;

    Session_Props* session_HX = constructANN(
      P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,load_base,T_amb_base, 
      eta_gross_base,eta_Q_base, which_ANN_model, base_path,inputsize, outputsize);

    printf("\n\nCheck Session HX\n");
    check_session(session_HX,inputsize,outputsize);
    printf("\n\nCheck Session PB\n");
    check_session(session_PB,inputsize,outputsize);

    destructANN(session_HX);
    destructANN(session_PB);
    
       
    return 0;
}


void check_session(Session_Props* session, int inputsize, int outputsize)
{
  printf("Check ANN struct values\n");

  printf("session memory address : %p\n",session->Session);
  printf("graph memory address : %p\n",session->Graph);
  printf("status memory address : %p\n",session->Status);
  printf("session options memory address : %p\n",session->SessionOpts);
  printf("run options memory address : %p\n",session->RunOpts);
  
  for(size_t i=0;i<inputsize;i++)
  {
    printf("X_max[%zu] = %lf\n",i,session->X_max[i]);
    printf("X_min[%zu] = %lf\n",i,session->X_min[i]);
    printf("base[%zu] = %lf\n",i,session->base_values[i]);
  }

  for(size_t i=0;i<outputsize;i++)
  {
    printf("y_max[%zu] = %lf\n",i,session->y_max[i]);
    printf("y_min[%zu] = %lf\n",i,session->y_min[i]);
  }

  printf("inputsize = %d\n",session->inputsize);
  printf("outputsize = %d\n",session->outputsize);

}

void check_krigingstruct(Kriging_struct* Kriging_variables, int inputsize, int outpusize)
{
  printf("rows = %d\n",Kriging_variables->rows);
  printf("inputsize = %d\n",Kriging_variables->inputsize);
  printf("outputsize = %d\n",Kriging_variables->outputsize);
  printf("Nugget PB = %lf\n",Kriging_variables->Nugget_PB);
  printf("Nugget HX = %lf\n",Kriging_variables->Nugget_HX);
  printf("Sill PB = %lf\n",Kriging_variables->sill_PB);
  printf("Sill HX = %lf\n",Kriging_variables->sill_HX);
  printf("Range PB = %lf\n",Kriging_variables->Range_PB);
  printf("Range HX = %lf\n",Kriging_variables->Range_HX);
  printf("load base = %lf\n",Kriging_variables->load_base);
  printf("T_in_ref = %lf\n",Kriging_variables->T_in_ref_blk);
  printf("T_amb_base = %lf\n",Kriging_variables->T_amb_base);

  printf("dev load max = %lf\n",Kriging_variables->deviation_load_max);
  printf("dev T in max = %lf\n",Kriging_variables->deviation_T_in_max);
  printf("dev T amb max = %lf\n",Kriging_variables->deviation_T_amb_max);
  printf("dev eta gross max = %lf\n",Kriging_variables->deviation_eta_gross_max);
  printf("dev eta Q max = %lf\n",Kriging_variables->deviation_eta_Q_max);

  printf("dev load min = %lf\n",Kriging_variables->deviation_load_min);
  printf("dev T in min = %lf\n",Kriging_variables->deviation_T_in_min);
  printf("dev T amb min = %lf\n",Kriging_variables->deviation_T_amb_min);
  printf("dev eta gross min = %lf\n",Kriging_variables->deviation_eta_gross_min);
  printf("dev eta Q min = %lf\n",Kriging_variables->deviation_eta_Q_min);


  for(size_t i=0;i<Kriging_variables->rows;i++)
  {
    printf(
      "%lf,%lf,%lf,%lf,%lf\n",
      Kriging_variables->trainingData[i][0],Kriging_variables->trainingData[i][1],
      Kriging_variables->trainingData[i][2],Kriging_variables->trainingData[i][3],
      Kriging_variables->trainingData[i][4]
    );
  }
}