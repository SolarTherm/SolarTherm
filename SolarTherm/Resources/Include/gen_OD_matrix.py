from pyDOE import *
import numpy as np

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
    
    np.savetxt("%s/OD_matrix.csv"%(trainingdir),LHS,delimiter=",")
    
    f = open("%s/OD_matrix.csv"%(trainingdir),"a")
    f.write("%s,%s,%s\n"%(inputs["T_HTF_des"],inputs["load_des"],inputs["T_amb_des"]))
    f.close()

if __name__ == "__main__":
    inputs = {}

    inputs["UB_1"] = 1100 + 25
    inputs["UB_2"] = 1.25
    inputs["UB_3"] = 50

    inputs["LB_1"] = 950
    inputs["LB_2"] = 0.45
    inputs["LB_3"] = -20

    inputs["T_HTF_des"] = 1000
    inputs["load_des"] = 1
    inputs["T_amb_des"] = 41

    inputs["num_inputs"] = 3
    inputs["numdata"] = 500

    inputs["trainingdir"] = "."

    generate_matrix(inputs)