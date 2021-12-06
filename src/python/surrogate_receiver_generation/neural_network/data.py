'''
This script is part of the surrogate modelling package of the SolarTherm. The functionality of this script is to generate the training data

Make sure that you run this script under st env
'''
import os
import pandas as pd
import numpy as np
from DyMat import DyMatFile as D
try:
    from solartherm import simulation
except ImportError:
    raise ImportError("solartherm module can not be found make sure that you run this script under st env")

import sys
sys.path.append("../../modelica")

import libgatherdata as lib
import shutil

class Data(object):
    def __init__(self, simdir="./simulation_surrogate_receiver", ST_path="../../SolarTherm", moname="ParticleReceiver1DCalculator"):
        self.moname = moname
        self.simdir = os.path.abspath(simdir)
        self.ST_path = os.path.abspath(ST_path)
        self.fn_res = "%s/dataset.csv"%(self.simdir)

        #Create the simulation directory
        if not os.path.exists(self.simdir):
            os.makedirs(self.simdir)

        #Copy the model (stand-alone receiver) to simdir
        shutil.copy(
            "%s/Models/CSP/CRS/Receivers/%s.mo"%(self.ST_path, self.moname), 
            self.simdir
        )
        
        #Grab the CWD
        self.original_wd = os.getcwd()

    def generate_LHS(
        self, 
        numdata=100,
        modelicavarname=["H_drop_design","ar_rec","T_out_design","m_design","T_in_design","T_amb_design","Wspd_design","Wspd_dir"],
        UB = [45,0.25,950+273.15,3500,575+273.15,40+273.15,40,360], 
        LB = [2,3.25,600+273.15,50,400+273.15,-20+273.15,0,0]
    ):
        '''
            Function to generate Latin Hypercube Sampling. 
            input:
                1. numdata, int, number of LHS data, default = 100
                2. modelicavarname, list of string, modelica simulation parameters that are sampled
                3. UB and LB, list, range of sampling for each modelica varname. Order is important
        '''

        self.modelicavarname = modelicavarname
        
        try:
            assert(len(UB) == len(LB))
        except AssertionError:
            raise AssertionError("Len upper boundary UB is not the same as lower boundary LB")

        print("Generating LHS for %s data"%(numdata))
        self.LHS = lib.generate_lhs(UB, LB, len(UB), numdata)
        print("Generating LHS done")

        #Write files to store the data in self.simdir
        f = open(self.fn_res,'w')
        write = "H_drop_design, ar_rec, T_out_design, Q_in_rcv, T_in, T_amb, F_wind, eta_rec\n"
        f.write(write)
        f.close()

    def run(self):
        '''
            Function to run the data generation
        '''
        #Change directory to simulation directory
        os.chdir(self.simdir)

        sim = simulation.Simulator(
            "%s.mo"%(self.moname),
            suffix="0"
        )
        sim.compile_model(); sim.compile_sim()

        #Start running
        for i, op_param in enumerate(self.LHS):
            par_n = []
            par_v = []

            #Appending modelica variable name and value that will be simulated
            for name in self.modelicavarname:
                par_n.append(name)
            
            for val in op_param:
                par_v.append(
                    str(val)
                )

            #Update the simulation parameters
            sim.load_init(); sim.update_pars(par_n, par_v)
            
            sys.stderr.write(
                "Running simulation no %s from %s with:\nParameter names:%s\nParameter values:%s\n"%(
                    i,self.LHS.shape[0],par_n,par_v
                )
            )

            #Start the simulation
            sim.simulate(start="0",stop="1",step="1",tolerance="1e-06",integOrder="5",solver="dassl",nls="homotopy")

            #Reading the data
            data = D("%s_res_0.mat"%(self.moname))

            mdot_array = data.data('particleReceiver1D.mdot')

            #First lets check if the parameters are parsed successfully
            try:
                assert(
                    mdot_array[-1] == op_param[3]
                )
            except AssertionError:
                raise AssertionError(
                    "particle mass flow rate are not parsed successfully. Result from the model is %s kg/s, should be %s kg/s\n"%(mdot_array[-1],op_param[3])
                )

            if len(mdot_array) == 0: #model does not solve
                write='%s,%s,%s,%s,%s,%s,%s,%s\n'%(
                data.data("H_drop_design")[-1],                 
                data.data('ar_rec')[-1],                 
                data.data('T_out_design')[-1], 
                0,                                          #Q_in_rcv         
                data.data('T_in_design')[-1], 
                data.data('T_amb_design')[-1], 
                data.data('particleReceiver1D.F_wind')[-1], 
                0                                           #eta_rcv
            ) 
            else:
                write='%s,%s,%s,%s,%s,%s,%s,%s\n'%(
                data.data("H_drop_design")[-1],                 
                data.data('ar_rec')[-1],                 
                data.data('T_out_design')[-1],     
                data.data('Q_in_rcv_calculated')[-1],       #Q_in_rcv      
                data.data('T_in_design')[-1], 
                data.data('T_amb_design')[-1], 
                data.data('particleReceiver1D.F_wind')[-1], 
                data.data('particleReceiver1D.eta_rec')[-1]  #eta_rcv
            ) 

            with open(self.fn_res,"a") as f:
                f.write(write)


        #Change back directory to the original directory
        os.chdir(self.original_wd)

        return self.fn_res

if __name__ == '__main__':
    data = Data()
    data.generate_LHS(numdata=1000)
    data.run()






    

    


