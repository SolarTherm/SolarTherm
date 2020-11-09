from pyDOE import *
import numpy as np
import os

def generate_lhs(UB,LB,num_inputs,numdata):
    LHS = lhs(num_inputs,samples=numdata,criterion='maximin')
    for i in range(LHS.shape[0]):
        for j in range(LHS.shape[1]):
            val = LHS[i,j]
            ub = UB[j]
            lb = LB[j]
            real_val = val * (ub - lb) + lb
            LHS[i,j] = real_val
    return LHS

def generate_samples(UB,LB,num_inputs,numdata,num_data_operating):
    design_params_in = lhs(num_inputs,samples=numdata,criterion='maximin')
    for i in range(design_params_in.shape[0]):
        for j in range(design_params_in.shape[1]):
            val = design_params_in[i,j]
            ub = UB[j]
            lb = LB[j]
            real_val = val * (ub - lb) + lb
            design_params_in[i,j] = real_val
            
    for ins in design_params_in:
        to_write_1 = []
        for i in range(len(ins)):
            to_write_1.append(round(ins[i],2))

        thigh = ins[0]

        #UB and LB for load, T_HTF_in, T_amb_input - Operation param
        newUB = [1.06,thigh+1,325.15]
        newLB = [0.45,thigh-20,250.15]
        operating_conditions_in = generate_lhs(newUB,newLB,len(newUB),num_data_operating)

        for operation in operating_conditions_in:
            to_write_3 = []
            for j in range(len(operation)):
                to_write_3.append(round(operation[j],2))
            
            #Write to CSV
            written = ''
            for a in to_write_1:
                written += '%s,'%(a)

            for j in range(len(to_write_3)):
                a = to_write_3[j]
                if j == len(to_write_3)-1:
                    written += '%s\n'%(a)
                else:
                    written += '%s,'%(a)

def hackmofile(mofile,modir,P_net,index=25):
    fnmo = '%s%s.mo'%(modir,mofile)
    fnres = '%s_hacked.mo'%(mofile)

    g = open(fnres,'w')
    g.close()

    f = open(fnmo,'r')
    i=0
    for line in f:
        #print(i,line)
        if i == index:
            line = '  parameter SI.Power P_net = %s;\n'%(str(P_net))
        g = open(fnres,'a')
        g.write(line)
        g.close()
        i+=1

    f.close()
    os.system('rm -rf %s.mo'%(mofile))
    os.rename('./%s'%(fnres),'./%s.mo'%(mofile))
    print("Done hacking!")
