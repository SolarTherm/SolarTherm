import os
import pandas as pd
import numpy as np
from DyMat import DyMatFile as D
from solartherm import simulation
import libgatherdata as lib
import shutil

def gendata(inputs):

    moname = "ParticleReceiver1DCalculator"

    SolarTherm_path = inputs["SolarTherm_path"]
    trainingdir = inputs["trainingdir"]

    H_drop_design = inputs["H_drop"]
    T_HTF_in_design = inputs["T_HTF_in_des"]
    T_HTF_out_des = inputs["T_HTF_out_des"]
    numdata = inputs["numdata"]
    status_config = inputs["status_config"]

    simdir = "%s/Resources/Include/simulation"%(SolarTherm_path)
    model = "%s/Models/CSP/CRS/Receivers/%s.mo"%(SolarTherm_path,moname)

    if not os.path.exists(model):
        raise IOError("Modelica model file doesn't exist")
        return -1
        
    #Copy model to simulation dir
    shutil.copy(model,simdir)
    
    #Writedown the receiver design configuration
    configdir = "%s/Resources/Include/configurations"%(SolarTherm_path)
    fnconfig = "%s/configParticleReceiver0.txt"%(configdir)
    index = 0

    if status_config == 1:
        while os.path.exists(fnconfig):
            index+=1
            fnconfig = "%s/configParticleReceiver%s.txt"%(configdir,index)	
		#Writing a new config file
        f = open(fnconfig,'w')
        f.write('H_drop_existing,T_HTF_in_des,T_HTF_out_des\n')
        f.write('%s,%s,%s\n'%(H_drop_design,T_HTF_in_design,T_HTF_out_des))
        f.close()

    if not os.path.exists(trainingdir):
        os.makedirs(trainingdir)
    
    fnres = "%s/training_data.csv"%(trainingdir)
    print(fnres)

    if not os.path.exists(fnres):
        f = open(fnres,'w')
        write="Q_in_rcv,T_in_design,T_amb_design,Wspd_design,Wspd_dir,eta_rec\n"
        f.write(write)
        f.close()

    #Change dir to simdir
    os.chdir(simdir)

    #compile simulation
    sim = simulation.Simulator("%s.mo"%moname,suffix="0")
    sim.compile_model()
    sim.compile_sim()

    modelicavarname = [
        "H_drop_design","m_design","T_in_design",
        "T_out_design","T_amb_design","Wspd_design","Wspd_dir",
        "Q_in_rcv_calculated", "particleReceiver1D.eta_rec"
        ]

    #Generate Training Data
    UB = [4000,T_HTF_in_design+20,50+273.15,40,360]
    LB = [100,T_HTF_in_design-30,-20+273.15,0,0]

    LHS = lib.generate_lhs(UB,LB,len(UB),numdata)

    for op_param in LHS:
        par_n =[]
        for index in range(len(modelicavarname)):
            if index == 7:
                break
            else:
                par_n.append(modelicavarname[index])

        par_v = []
        par_v.append(str(H_drop_design))
        par_v.append(str(op_param[0]))          #mdes
        par_v.append(str(op_param[1]))          #T_in
        par_v.append(str(T_HTF_out_des))        #T_out
        par_v.append(str(op_param[2]))          #Tamb
        par_v.append(str(op_param[3]))          #Wspd
        par_v.append(str(op_param[4]))          #Wdir

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
        mdot_array = data.data('particleReceiver1D.mdot')
        assert(mdot_array[-1]==op_param[0])

        if len(mdot_array)==0:
            Q_in_rcv_calculated = 0
            write='%s,%s,%s,%s,%s,%s\n'%(Q_in_rcv_calculated,
                op_param[1], op_param[2],op_param[3],op_param[4],0)
        else:
            eff = data.data('particleReceiver1D.eta_rec')[-1]
            Q_in_rcv_calculated = data.data('Q_in_rcv_calculated')[-1]
            write='%s,%s,%s,%s,%s,%s\n'%(Q_in_rcv_calculated/1e6,
                op_param[1], op_param[2],op_param[3],op_param[4],eff)
        
        f = open(fnres,'a')
        f.write(write)
        f.close()

    #Generate validation data
    numdata_val = int(0.15*LHS.shape[0])

    fnval = "%s/validation_data.csv"%(trainingdir)
    
    if not os.path.exists(fnval):
        f = open(fnval,'w')
        write="Q_in_rcv,T_in_design,T_amb_design,Wspd_design,Wspd_dir,eta_rec\n"
        f.write(write)
        f.close()

    UB = [4000,T_HTF_in_design+20,50+273.15,40,360]
    LB = [100,T_HTF_in_design-30,-20+273.15,0,0]

    LHS = lib.generate_lhs(UB,LB,len(UB),numdata_val)

    for op_param in LHS:
        par_n =[]
        for index in range(len(modelicavarname)):
            if index == 7:
                break
            else:
                par_n.append(modelicavarname[index])

        par_v = []
        par_v.append(str(H_drop_design))
        par_v.append(str(op_param[0]))          #mdes
        par_v.append(str(op_param[1]))          #T_in
        par_v.append(str(T_HTF_out_des))        #T_out
        par_v.append(str(op_param[2]))          #Tamb
        par_v.append(str(op_param[3]))          #Wspd
        par_v.append(str(op_param[4]))          #Wdir

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
        mdot_array = data.data('particleReceiver1D.mdot')
        assert(mdot_array[-1]==op_param[0])

        if len(mdot_array)==0:
            Q_in_rcv_calculated = 0
            write='%s,%s,%s,%s,%s,%s\n'%(Q_in_rcv_calculated,
                op_param[1], op_param[2],op_param[3],op_param[4],0)
        else:
            eff = data.data('particleReceiver1D.eta_rec')[-1]
            Q_in_rcv_calculated = data.data('Q_in_rcv_calculated')[-1]
            write='%s,%s,%s,%s,%s,%s\n'%(Q_in_rcv_calculated/1e6,
                op_param[1], op_param[2],op_param[3],op_param[4],eff)
        
        f = open(fnval,'a')
        f.write(write)
        f.close()
    
    os.chdir("%s/Resources/Include"%(SolarTherm_path))

  

