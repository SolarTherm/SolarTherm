import os
import pandas as pd
import numpy as np
from DyMat import DyMatFile as D
from solartherm import simulation
import libgatherdata as lib
import shutil

def gendata(inputs):

    SolarTherm_path = inputs["SolarTherm_path"]
    H_drop_design = inputs["H_drop"]
    T_HTF_in_design = inputs["T_HTF_in_des"]
    T_HTF_out_des = inputs["T_HTF_out_des"]
    trainingdir = inputs["trainingdir"]

    simdir = "%s/Resources/Include/Simulation"%(SolarTherm_path)
    moname = "ParticleReceiver1DCalculator"
    model = "%s/%s.mo"%(SolarTherm_path)

    shutil.copy(model,simdir)

    #UB and LB - Size,Q_in_rcv,T_HTF_in,T_HTF_out_des,T_amb,Wspd,Wdir
    os.chdir(simdir)

    sim = simulation.Simulator("%s.mo"%moname,suffix="0")
    sim.compile_model()
    sim.compile_sim()

    modelicavarname = [
        "H_drop_design","m_design","T_in_design",
        "T_out_design","T_amb_design","Wspd_design","Wspd_dir",
        "Q_in_rcv_calculated", "particleReceiver1D.eta_rec"
        ]


    fnres = "%s/training_data_receiver.csv"%(trainingdir)

    f = open(fnres,'w')
    write="H_drop_design,Q_in_rcv,T_out_design,T_in_design,T_amb_design,Wspd_design,Wspd_dir,eta_rec\n"
    f.write(write)
    f.close()

    UB = [5000,T_HTF_in_design+20,50,40,360]
    LB = [50,T_HTF_in_design-30,-20,0,0]

    LHS = lib.generate_lhs(UB,LB,len(UB),1000)

    for op_param in LHS:
        par_n =[]
        for index in range(len(modelicavarname)):
            if index == 7:
                break
            else:
                par_n.append(modelicavarname[index])

        par_v = []
        par_v.append(str(H_drop_design))
        par_v.append(str(op_param[0]))
        par_v.append(str(op_param[1]))
        par_v.append(str(T_HTF_out_des))
        par_v.append(str(op_param[2]))
        par_v.append(str(op_param[3]))
        par_v.append(str(op_param[4]))

        par_v.append(str(val))

        print(par_n)
        print(par_v)
        
        #Updating parameters
        sim.load_init()
        sim.update_pars(par_n,par_v)

        #Start simulation
        sim.simulate(start="0",stop="1",step="1",tolerance="1e-06",integOrder="5",solver="dassl",nls="homotopy")

        #Read data
        data = D('%s_res_0.mat'%moname)

        #Check validity
        Q_array = data.data('particleReceiver1D.mdot')
        assert(Q_array[-1]==op_param[0])

        if len(Q_array)==0:
            write="H_drop_design,Q_in_rcv,T_out_design,T_in_design,T_amb_design,Wspd_design,Wspd_dir,eta_rec\n"
            write='%s,%s,%s,%s,%s,%s,%s,%s\n'%(H_drop_design,0,
                T_HTF_out_des,op_param[1], op_param[2],op_param[3],op_param[4],0)
        else:
            eff = data.data('particleReceiver1D.eta_rec')[-1]
            Q_in_rcv_calculated = data.data('Q_in_rcv_calculated')[-1]
            write='%s,%s,%s,%s,%s,%s,%s,%s\n'%(H_drop_design,Q_in_rcv_calculated,
                T_HTF_out_des,op_param[1], op_param[2],op_param[3],op_param[4],eff)
        
        f = open(fnres,'a')
        f.write(write)
        f.close()

