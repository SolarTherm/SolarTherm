from pyDOE import *
import numpy as np
import os
import argparse

def generate_matrix(inputs):
    UB_1 = inputs["UB_1"]
    UB_2 = inputs["UB_2"]
    UB_3 = inputs["UB_3"]
    
    LB_1 = inputs["LB_1"]
    LB_2 = inputs["LB_2"]
    LB_3 = inputs["LB_3"]

    UB = [UB_1,UB_2,UB_3]
    LB = [LB_1,LB_2,LB_3]

    num_inputs = inputs["num_inputs"]
    numdata = inputs["numdata"]

    LHS = lhs(num_inputs,samples=numdata,criterion='maximin')
    for i in range(LHS.shape[0]):
        for j in range(LHS.shape[1]):
            val = LHS[i,j]
            ub = UB[j]
            lb = LB[j]
            real_val = val * (ub - lb) + lb
            LHS[i,j] = real_val

    trainingdir = inputs["trainingdir"]
    if not os.path.exists(trainingdir):
        os.makedirs(trainingdir)
    np.savetxt("%s/OD_matrix.csv"%(trainingdir),LHS,delimiter=",")
    
    f = open("%s/OD_matrix.csv"%(trainingdir),"a")
    f.write("%s,%s,%s\n"%(inputs["T_HTF_des"],inputs["load_des"],inputs["T_amb_des"]))
    f.close()

def generate_matrix_factorial(inputs):
    T_in_ref_blk = inputs["T_HTF_des"]
    load_des = inputs["load_des"]
    T_amb_des = inputs["T_amb_des"]

    T_in = np.linspace(T_in_ref_blk-50,T_in_ref_blk+5,50)
    load_in = np.linspace(0.45,load_des+0.25,50)
    T_amb_in = np.linspace(-20,50,50)

    res_matrix = []

    #OAT MATRIX ==> 75 data
    for i in range(len(T_in)):
        a = [T_in[i],load_des,T_amb_des]
        res_matrix.append(a)
    for i in range(len(load_in)):
        a = [T_in_ref_blk,load_in[i],T_amb_des]
        res_matrix.append(a)
    for i in range(len(T_amb_in)):
        a = [T_in_ref_blk,load_des,T_amb_in[i]]
        res_matrix.append(a)
    
    #Varying two variables ==> 125

    T_in = np.linspace(T_in_ref_blk-50,T_in_ref_blk+5,7)
    load_in = np.linspace(0.45,load_des+0.25,6)
    T_amb_in = np.linspace(-20,50,6)

    for t_amb in T_amb_in:
        for load in load_in:
            for T in T_in:
                a = [T,load,t_amb]
                res_matrix.append(a)
    
    #Appending design point at the very end of the OD matrix
    a = [T_in_ref_blk,load_des,T_amb_des]
    res_matrix.append(a)

    #Save the list of list as CSV
    res_matrix = np.array(res_matrix)

    trainingdir = inputs["trainingdir"]
    if not os.path.exists(trainingdir):
        os.makedirs(trainingdir)

    np.savetxt("%s/OD_matrix.csv"%(trainingdir),res_matrix,delimiter=",")
    return


def generate_matrix_validation(inputs):
    T_in_ref_blk = inputs["T_HTF_des"]
    load_des = inputs["load_des"]
    T_amb_des = inputs["T_amb_des"]

    T_in = np.linspace(T_in_ref_blk-50,T_in_ref_blk+5,5)
    load_in = np.linspace(0.45,load_des+0.25,5)
    T_amb_in = np.linspace(-20,50,5)

    res_matrix = []

    #OAT MATRIX ==> 15 data
    '''for i in range(len(T_in)):
        a = [T_in[i],load_des,T_amb_des]
        res_matrix.append(a)
    for i in range(len(load_in)):
        a = [T_in_ref_blk,load_in[i],T_amb_des]
        res_matrix.append(a)
    for i in range(len(T_amb_in)):
        a = [T_in_ref_blk,load_des,T_amb_in[i]]
        res_matrix.append(a)'''
    
    #Varying two variables ==> 27

    T_in = np.linspace(T_in_ref_blk-50,T_in_ref_blk+5,3)
    load_in = np.linspace(0.45,load_des+0.25,3)
    T_amb_in = [-5,10,30]

    for t_amb in T_amb_in:
        for load in load_in:
            for T in T_in:
                a = [T,load,t_amb]
                res_matrix.append(a)
    
    #Appending design point at the very end of the OD matrix
    a = [T_in_ref_blk,load_des,T_amb_des]
    res_matrix.append(a)

    #Save the list of list as CSV
    res_matrix = np.array(res_matrix)

    trainingdir = inputs["trainingdir"]
    if not os.path.exists(trainingdir):
        os.makedirs(trainingdir)

    np.savetxt("%s/OD_matrix.csv"%(trainingdir),res_matrix,delimiter=",")
    return

if __name__=="__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '--UB1',
        help = 'Upper Boundary of T_HTF_des',
        type = float
    )

    parser.add_argument(
        '--UB2',
        help = 'Upper Boundary of load_des',
        type = float
    )

    parser.add_argument(
        '--UB3',
        help = 'Upper Boundary of T_amb_des',
        type = float
    )

    parser.add_argument(
        '--LB1',
        help = 'Lower Boundary of T_HTF_des',
        type = float
    )

    parser.add_argument(
        '--LB2',
        help = 'Lower Boundary of load_des',
        type = float
    )

    parser.add_argument(
        '--LB3',
        help = 'Lower Boundary of T_amb_des',
        type = float
    )

    parser.add_argument(
        '--T_HTF_des',
        help = 'T_HTF_des',
        type = float
    )

    parser.add_argument(
        '--load_des',
        help = 'load_des',
        type = float
    )

    parser.add_argument(
        '--T_amb_des',
        help = 'T_amb_des',
        type = float
    )

    parser.add_argument(
        '--numinputs',
        help = 'number of inputs',
        type = int
    )

    parser.add_argument(
        '--numdata',
        help = 'number of data',
        type = int
    )

    parser.add_argument(
        '--trainingdir',
        help = 'trainingdir',
        type = str
    )

    parser.add_argument(
        '--type',
        help = 'type',
        type = str
    )

    args = parser.parse_args()
    type_func = args.type
    
    inputs = {}

    inputs["UB_1"] = args.UB1
    inputs["UB_2"] = args.UB2
    inputs["UB_3"] = args.UB3

    inputs["LB_1"] = args.LB1
    inputs["LB_2"] = args.LB2
    inputs["LB_3"] = -args.LB3

    inputs["T_HTF_des"] = args.T_HTF_des
    inputs["load_des"] = args.load_des
    inputs["T_amb_des"] = args.T_amb_des

    inputs["num_inputs"] = args.numinputs
    inputs["numdata"] = args.numdata

    inputs["trainingdir"] = args.trainingdir
    
    if type_func == 'training':
        generate_matrix_factorial(inputs)
    elif type_func == 'validation':
        generate_matrix_validation(inputs)
    elif type_func == 'LHS':
        generate_matrix(inputs)
    else:
        raise TypeError("Function type either training, validation or LHS. Your type: %s\n"%(type_func))
