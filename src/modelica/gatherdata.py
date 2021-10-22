import numpy as np
from DyMat import DyMatFile as D
import os
import libgatherdata as lib
import time
import shutil
import pandas as pd
from itertools import combinations, permutations
from scipy.optimize import curve_fit
from sklearn.preprocessing import MinMaxScaler
from matplotlib import pyplot as plt
from solartherm import simulation
from functools import partial
from solartherm import postproc
import itertools

def gather_data(inputs):
	start = time.time()

	modelicavarname = ['T_in_ref_blk','p_high','PR','pinch_PHX','dTemp_HTF_PHX','load','T_HTF_in','T_amb_input','eta_gross','eta_Q']
	
	#Reading input
	P_net = inputs["P_net"]
	T_in_ref_blk = inputs["T_in_ref_blk"]
	p_high = inputs["p_high"]
	PR = inputs["PR"]
	pinch_PHX = inputs["pinch_PHX"]
	dTemp_HTF_PHX = inputs["dTemp_HTF_PHX"]
	numdata = inputs["numdata"]
	dirres= inputs["dirres"]
	new_config = inputs["status_config"]
	SolarTherm_path = inputs["SolarTherm_path"]

	cwd = os.getcwd()
	resdir = "%s"%(dirres)
	simdir = "%s/simulation"%(cwd)
	
	#Writedown the PB design configuration
	configdir = "%s/configurations"%(cwd)
	fnconfig = "%s/config0.txt"%(configdir)
	index = 0

	if new_config == 1:
		while os.path.exists(fnconfig):
			index+=1
			fnconfig = "%s/config%s.txt"%(configdir,index)
			
		#Writing a new config file
		f = open(fnconfig,'w')
		f.write('P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX\n')
		f.write('%s,%s,%s,%s,%s,%s\n'%(P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX))
		f.close()

	#Writing the resfile
	if not os.path.exists(resdir):
		os.makedirs(resdir)
	
	fntrain = "%s/training_data.csv"%(resdir)

	#Change dir to simulationdir
	os.chdir(simdir)
	mofile = 'sCO2PBCalculator_Using_JPidea'

	#Range of variables
	UB = [1.25,T_in_ref_blk+20,322.9]
	LB = [0.46,T_in_ref_blk-30,260.9]
	LHS = lib.generate_lhs(UB,LB,3,numdata)

	#Copy the mofile to simulationdir
	shutil.copy("%s/Models/PowerBlocks/%s.mo"%(SolarTherm_path,mofile),".")

	#Hack mo file to change the P_net
	lib.hackmofile(mofile,'./',P_net,index=21)

	#Compile the mofile
	sim = simulation.Simulator("%s.mo"%mofile,suffix="0")
	sim.compile_model()
	sim.compile_sim()

	resultclass = postproc.SimResultElec
	
	#Gather training data
	simulation_engine(LHS,fntrain,modelicavarname,mofile,P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,sim)

	#Gather validation data
	datatrain = np.genfromtxt(fntrain, delimiter=',',skip_header=1)
	num = datatrain.shape[0]
	numval = int(0.3 * num)
	LHS = lib.generate_lhs(UB,LB,3,numval)
	fnval = "%s/validation_data.csv"%(resdir)

	simulation_engine(LHS,fnval,modelicavarname,mofile,P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,sim)

	inputpreprocessing = {}
	inputpreprocessing["fntrain"] = fntrain
	inputpreprocessing["resdir"] = resdir
 
	processing_data(inputpreprocessing)

	#return back to CWD
	os.chdir(cwd)

def processing_data(inputpreprocessing):
	fntrain = inputpreprocessing["fntrain"]
	resdir  = inputpreprocessing["resdir"]
		
	#Prep training data - Prep for NN training
	df = pd.read_csv(fntrain)
	rows = df.shape[0]
	load_base = df.iloc[-1].load
	T_in_base = df.iloc[-1].T_in_ref_blk
	T_amb_input_base = df.iloc[-1].T_amb_input
	eta_gross_base = df.iloc[-1].eta_gross
	eta_Q_base = df.iloc[-1].eta_Q
	
	df = df[df.columns[6:11]]

	df['deviation_load'] = load_base - df.load
	df['deviation_T_in'] = T_in_base - df.T_HTF_in
	df['deviation_T_amb_input'] = T_amb_input_base - df.T_amb_input
	df['deviation_eta_gross'] = eta_gross_base - df.eta_gross
	df['deviation_eta_Q'] = eta_Q_base - df.eta_Q

	df_deviation = df[df.columns[5:]]
	df_deviation.to_csv('%s/deviation.csv'%(resdir),index=False)

	df1 = df_deviation.drop(columns="deviation_eta_gross")
	df1.to_csv("%s/deviation_eta_Q.csv"%(resdir),index=False)
	df2 = df_deviation.drop(columns="deviation_eta_Q")
	df2.to_csv("%s/deviation_eta_gross.csv"%(resdir),index=False)

	#Prep training data - Prep for Kriging training
	bins = 25
	mm = MinMaxScaler().fit(df_deviation)
	np.savetxt('%s/max.txt'%(resdir),mm.data_max_)
	np.savetxt('%s/min.txt'%(resdir),mm.data_min_)

	df_scaled = pd.DataFrame(mm.transform(df_deviation),columns = df_deviation.columns)
	df_scaled.to_csv('%s/scaled_Kriging_training_data_deviation.csv'%(resdir),index=False)
	data = df_scaled.to_numpy()

	#Generate SIL, NUGGET and RANGE (Krig Params)
	combi = list(
		combinations(np.arange(0,data.shape[0],1),2)
	)
	  
	DIST = []
	VAR = []
	index_i = []
	index_j = []

	for index in [3,4]:
		for c in combi:
		    i = c[0]
		    j = c[1]

		    dist_square = 0    
		    for l in range(0,3):
		        dist_square += (data[i,l] - data[j,l])**2
		    
		    dist = (dist_square)**0.5

		    var = abs(data[i,index] - data[j,index])

		    DIST.append(dist)
		    VAR.append(var)
		    index_i.append(i)
		    index_j.append(j)

		fig,ax = plt.subplots()
		ax.scatter(DIST,VAR,s=0.5)
		ax.set_xlabel("Distance")
		ax.set_ylabel("Pairwise Difference")

		df = pd.DataFrame(zip(DIST,VAR,index_i,index_j),columns=['Distance','Difference','index_i','index_2'])
		df['DiffSquare'] = df.Difference**2

		dist_max = df.Distance.max()
		dist_min = df.Distance.min()
		print(dist_max)
		edge = np.linspace(dist_min,dist_max,bins)

		#Start filtering dataframe
		VARIOGRAM = []
		CENTERBIN = []
		for i in range(len(edge)-1):
		    lb = edge[i]
		    ub = edge[i+1]

		    df_filter = df[
		        (df.Distance >= lb) & (df.Distance < ub)
		    ]

		    if len(df_filter) !=0 :
		        variogram = sum(df_filter.DiffSquare) / (2 * len(df_filter))
		        centerbin = df_filter.Distance.mean()
		        VARIOGRAM.append(variogram)
		        CENTERBIN.append(centerbin)
		    else:
		        VARIOGRAM.append(0)
		        CENTERBIN.append(centerbin)


		fig,ax = plt.subplots()
		ax.plot(CENTERBIN,VARIOGRAM,marker='^')
		ax.set_xlabel("Lag ~ Distance")
		ax.set_ylabel("Variogram")
		if index==3:
		    ax.set_title("Variogram %s"%("eta_HX"))
		else:
		    ax.set_title("Variogram %s"%("eta_PB"))

		import math
		def func(x,c0,c1,c2,c3,c4,c5):
		    return(c5 * x**5 + c4 * x**4 + c3 * x**3 + c2 * x**2 + c1 * x + c0)

		y = func(np.array(CENTERBIN),1.1,1e-5,2.3e-3,1.5e-2,0.6,6.1)
		popt, pcov = curve_fit(func,CENTERBIN,VARIOGRAM)

		xin = np.linspace(min(CENTERBIN),max(CENTERBIN),50)
		ax.plot(xin,func(xin,*popt),'r-',marker='o',ls='--')

		nugget = func(min(CENTERBIN),*popt)

		delta = []

		y=0
		for i in range(len(xin)):
		    ynew = func(xin[i],*popt)
		    if i > 0:
		        d = ynew - y
		        y = ynew
		        delta.append(d)

		    else:
		        y = ynew
		    
		    if len(delta) > 40:
		        if abs(delta[-1] - delta[-2]) < 1e-6:
		            break

		sil = y

		if index==3:
			print("SIL eta_PB : %s" %sil)
			print("NUGGET eta_PB: %s"%(nugget))
			f = open("%s/Kriging_Param_eta_PB.txt"%(resdir),"w")
			f.write("%s,%s,%s"%(sil,nugget,dist_max))
			f.close()
		else:
			print("SIL eta_HX: %s" %sil)
			print("NUGGET eta_HX: %s"%(nugget))
			f = open("%s/Kriging_Param_eta_Q.txt"%(resdir),"w")
			f.write("%s,%s,%s"%(sil,nugget,dist_max))
			f.close()

	print("DATAMAX : ",mm.data_max_)
	print("DATAMIN : ",mm.data_min_)
	#plt.show()

def simulation_engine(LHS,fn,modelicavarname,mofile,P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,sim):
	#Check whether the file exist or not
	def FileCheck(fn):
		try:
			open(fn,"r")
			return 1
		except IOError:
			return 0
			
	#Create a file to dump the modelica simulation result -  write the heading if file doesn't exist
	existence = FileCheck(fn)
	if existence == 0:
		f = open(fn,'a')
		write = 'P_net,'
		for name in modelicavarname:
			write+='%s,'%name
		write+='\n'
		f.write(write)
		f.close()

	#Get the variable names that will be overwrite
	par_n = []	
	for index in range(len(modelicavarname)):
		par_n.append(modelicavarname[index])
		if index == 7:
			break
	
	for operation_param in LHS:
		par_v = []

		#Appending base variables
		par_v.append(str(T_in_ref_blk))
		par_v.append(str(p_high))
		par_v.append(str(PR))
		par_v.append(str(pinch_PHX))
		par_v.append(str(dTemp_HTF_PHX))

		for i in range(5,len(modelicavarname)-2):
			par_v.append(str(round(operation_param[i-5],2)))
		
		#Updating parameters
		sim.load_init()
		sim.update_pars(par_n,par_v)
		
		#Start simulation
		sim.simulate(start="0",stop="1",step="1",tolerance="1e-06",integOrder="5",solver="dassl",nls="homotopy")

		#Read Data
		data = D('%s_res_0.mat'%mofile)

		#Check validity
		eta_gross_array = data.data('eta_gross')
		eta_Q_array = data.data('eta_Q')

		#Write P_net
		write = '%s,'%(P_net)
		
		if len(eta_gross_array) == 0:
			for name in modelicavarname:
				val = 0
				write+='%s,'%(val)
		else:
			for name in modelicavarname:
				val = data.data(name)[-1]
				write+='%s,'%(val)
		write+='\n'

		f = open(fn,'a')
		f.write(write)
		f.close()

	#Simulating full load
	par_v = []

	#Appending base variables
	par_v.append(str(T_in_ref_blk))
	par_v.append(str(p_high))
	par_v.append(str(PR))
	par_v.append(str(pinch_PHX))
	par_v.append(str(dTemp_HTF_PHX))

	#Appending operational variables at design point, load = 1, T_HTF_IN = T_in_ref_blk, T_amb_des = 312.15, 
	par_v.append(str(1))
	par_v.append(str(T_in_ref_blk))
	par_v.append(str(312.15))
	
	#Updating parameters and run the simulation
	sim.load_init()
	sim.update_pars(par_n,par_v)
	sim.simulate(start="0",stop="1",step="1",tolerance="1e-06",integOrder="5",solver="dassl",nls="homotopy")

	#Read Data
	data = D('%s_res_0.mat'%mofile)

	#Check validity
	eta_gross_array = data.data('eta_gross')
	eta_Q_array = data.data('eta_Q')

	#Write P_net
	write = '%s,'%(P_net)
	if len(eta_gross_array) == 0:
		for name in modelicavarname:
			val = 0
			write+='%s,'%(val)

	else:
		for name in modelicavarname:
			val = data.data(name)[-1]
			write+='%s,'%(val)
	write+='\n'

	f = open(fn,'a')
	f.write(write)
	f.close()
		
if __name__ == "__main__":
	P_net = 2e7
	T_in_ref_blk = 1243.27
	p_high = 22707266.48
	PR = 2.98
	pinch_PHX = 23.67
	dTemp_HTF_PHX = 238.45
	numdata = 10
	dirres = "."
	new_config = 0
	
	inputs = {
		"P_net":P_net,"T_in_ref_blk":T_in_ref_blk,"p_high":p_high,"PR":PR,"pinch_PHX":pinch_PHX,"dTemp_HTF_PHX":dTemp_HTF_PHX,
		"numdata":numdata,"dirres":dirres,"status_config":new_config
		}
	gather_data(inputs)



	'''
	if OAT==True:
		#OAT variables
		loads = np.linspace(0.5,1.2,5)
		T_HTF_in = np.linspace(T_in_ref_blk-20,T_in_ref_blk+10,5)
		T_amb = [263,286.57,320.0]
		LHS = []

		for load in loads:
			for T_in in T_HTF_in:
				for T_amb_in in T_amb:
					offs = []
					offs.append(load)
					offs.append(T_in)
					offs.append(T_amb_in)
					LHS.append(offs)
	'''






	
