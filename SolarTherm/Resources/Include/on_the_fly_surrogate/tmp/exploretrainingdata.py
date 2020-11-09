import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from itertools import combinations, permutations
from scipy.optimize import curve_fit
from sklearn.preprocessing import MinMaxScaler

def processing_data(inputs):
	#Create deviation training data
	fnraw = "%s/%s"%(inputs["datadir"],inputs["fnraw"])
	
	df = pd.read_csv(fnraw)
	df = df[df.columns[6:11]]
	
	load_base = inputs["load_base"]
	T_in_base = inputs["T_in_base"]	
	T_amb_input_base = inputs ["T_amb_input_base"]
	eta_gross_base = inputs["eta_gross_base"]
	eta_Q_base = inputs["eta_Q_base"]

	df['deviation_load'] = load_base - df.load
	df['deviation_T_in'] = T_in_base - df.T_HTF_in
	df['deviation_T_amb_input'] = T_amb_input_base - df.T_amb_input
	df['deviation_eta_gross'] = eta_gross_base - df.eta_gross
	df['deviation_eta_Q'] = eta_Q_base - df.eta_Q

	df_deviation = df[df.columns[5:]]
	df_deviation.to_csv('%s/deviation.csv'%(inputs["datadir"]),index=False)

	#Prep data for NN training
	df1 = df_deviation.drop(columns="deviation_eta_gross")
	df1.to_csv("%s/deviation_eta_Q.csv"%(inputs["datadir"]),index=False)
	df2 = df_deviation.drop(columns="deviation_eta_Q")
	df2.to_csv("%s/deviation_eta_gross.csv"%(inputs["datadir"]),index=False)

	bins = 25

	#Prep data for kriging training
	mm = MinMaxScaler().fit(df_deviation)
	np.savetxt('%s/max.txt'%(inputs["datadir"]),mm.data_max_)
	np.savetxt('%s/min.txt'%(inputs["datadir"]),mm.data_min_)

	df_scaled = pd.DataFrame(mm.transform(df_deviation),columns = df_deviation.columns)
	df_scaled.to_csv('%s/scaled_Kriging_training_data_deviation.csv'%(inputs["datadir"]),index=False)
	data = df_scaled.to_numpy()

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
		    ax.set_title("Variogram %s"%("$\eta_{HX}$"))
		else:
		    ax.set_title("Variogram %s"%("$\eta_{PB}$"))

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
			print("SIL $\eta_{PB}$ : %s" %sil)
			print("NUGGET $\eta_{PB}$: %s"%(nugget))
			f = open("%s/Kriging_Param_eta_PB.txt"%(inputs["datadir"]),"w")
			f.write("%s,%s,%s"%(sil,nugget,dist_max))
			f.close()
		else:
			print("SIL $\eta_{HX}$ : %s" %sil)
			print("NUGGET $\eta_{HX}$: %s"%(nugget))
			f = open("%s/Kriging_Param_eta_Q.txt"%(inputs["datadir"]),"w")
			f.write("%s,%s,%s"%(sil,nugget,dist_max))
			f.close()


	print("DATAMAX : ",mm.data_max_)
	print("DATAMIN : ",mm.data_min_)
	#plt.show()


if __name__ == "__main__":
	inputs = {
		"load_base":1,"T_in_base":1243.27,"T_amb_input_base":312.15,"eta_gross_base":0.4999192709,"eta_Q_base":0.9998537337,
		"datadir":"/home/philgun/Documents/codecodecode/codecodecode/GSL_Project/training_data/config0","fnraw":"trainingdata.csv"}
	processing_data(inputs)


