import ascpy
import numpy as np
import pylab as pl
import os
import csv
from string import Template
from matplotlib.sankey import Sankey
import matplotlib.pyplot as plt
import sys
import numpy as np
import argparse
import scipy
from scipy.interpolate import interpn, griddata, LinearNDInterpolator
import pandas as pd
import math

'''
This function is a wrapper to run ASCEND model
'''
def test_model(modelname,solvername='QRSlv',varvalues={},parameters={},retvars=[]):
	L = ascpy.Library()
	# find the MODEL that we want
	T = L.findType(modelname)

	# create the model
	M = T.getSimulation('sim',True) # runs 'on_load' as part of the setup

	# set some extra values
	#print "varvalues=",varvalues
	for k,v in varvalues.iteritems():
		getattr(M,k).setRealValueWithUnits(*v)
	M.solve(ascpy.Solver(solvername),ascpy.SolverReporter())
	M.run(T.getMethod('solve_T'))

	M.solve(ascpy.Solver(solvername),ascpy.SolverReporter())
	M.run(T.getMethod('solve_A'))
	M.solve(ascpy.Solver(solvername),ascpy.SolverReporter())
	M.run(T.getMethod('solve_mdot'))
	M.solve(ascpy.Solver(solvername),ascpy.SolverReporter())
	M.run(T.getMethod('solve_Q'))
	M.solve(ascpy.Solver(solvername),ascpy.SolverReporter())
	M.run(T.getMethod('identical_vel'))
	M.solve(ascpy.Solver(solvername),ascpy.SolverReporter())
	M.run(T.getMethod('off_design'))
	M.solve(ascpy.Solver(solvername),ascpy.SolverReporter())


	M.run(T.getMethod('plot_x_y'))

	# choose solver
	M.setSolver(ascpy.Solver(solvername))


	# set the solver parameters that we want
	for k,v in parameters.iteritems():
		M.setParameter(k,v)

	M.solve(ascpy.Solver(solvername),ascpy.SolverReporter())	

	# we can do more testing on the model, get some values etc
	R = {}
	for k in retvars:
		R[k] = float(getattr(M,k))

	del M
	return R

'''
	Function to run sintering thermal model for design point
'''
def run_thermalSinteringModelDesignPoint(inputs):
	sys.stderr.write("Entering python function run_thermalSinteringModelDesignPoint\n\n")

	#Reading the inputs
	T_sky = inputs["T_sky"]
	k_s = inputs["k_s"]
	alpha = inputs["alpha"]
	eps_r = inputs["eps_r"]
	h_ext = inputs["h_ext"]
	eps = inputs["eps"]

	T_i_s_HX1 = inputs["T_i_s_HX1"]
	T_o_s_HX1 = inputs["T_o_s_HX1"]
	T_i_g_HX1 = inputs["T_i_g_HX1"]
	d_p_HX1 = inputs["d_p_HX1"]
	H_HX1 = inputs["H_HX1"]
	W_HX1 = inputs["W_HX1"]
	t_wall_HX1 = inputs["t_wall_HX1"]

	T_i_s_HX2 = inputs["T_i_s_HX2"]
	T_o_s_HX2 = inputs["T_o_s_HX2"]
	T_i_g_HX2 = inputs["T_i_g_HX2"]
	W_HX2 = inputs["W_HX2"]
	d_p_HX2 = inputs["d_p_HX2"]

	dirsave = inputs["dir_save"]
	st_path = inputs["SolarTherm_path"]
	#Reading the flux multiplier based on DNI ratio
	flux = 1

	seg = inputs["seg"]
	
	sys.stderr.write("\n\nDone reading inputs...\n\n")


	#Open ASCEND model
	try:
		t = open("%s/Resources/Include/Sinter_HX_n.a4c"%(st_path)).read()
	except Exception as e:
		sys.stderr.write(str(e))

	sys.stderr.write("Done reading ASCEND model...\n\n")

	#Parse the simulation parameters
	P_1 = Template(t).safe_substitute(N_SEGMENTS_SUBST_1 = k_s, N_SEGMENTS_SUBST_2 = alpha,N_SEGMENTS_SUBST_3 = T_sky, N_SEGMENTS_SUBST_4 = h_ext, N_SEGMENTS_SUBST_6 = T_i_g_HX1, N_SEGMENTS_SUBST_7 = T_o_s_HX1, N_SEGMENTS_SUBST_8 = T_i_s_HX1, N_SEGMENTS_SUBST_9 = d_p_HX1, N_SEGMENTS_SUBST_10 = H_HX1, N_SEGMENTS_SUBST_11 = W_HX1, N_SEGMENTS_SUBST_12 = t_wall_HX1, N_SEGMENTS_SUBST_13 = T_i_g_HX2, N_SEGMENTS_SUBST_14 = T_o_s_HX2, N_SEGMENTS_SUBST_15 = T_i_s_HX2, N_SEGMENTS_SUBST_16 = d_p_HX2, N_SEGMENTS_SUBST_17 = W_HX2, N_SEGMENTS_SUBST_18 = eps,N_SEGMENTS_SUBST_19 = int(seg),N_SEGMENTS_SUBST_20 = flux)

	f2 = open("%s/Resources/Include/Sinter_HX_LOADME.a4c"%(st_path),"w")
	f2.write(P_1)
	f2.close()

	sys.stderr.write("Done modifying ASCEND model...\n\n")

	modelname = 'HX_all'
	L = ascpy.Library()

	#Grab modelica wd
	modelica_wd = os.getcwd()
	sys.stderr.write("modelica wd: %s\n"%(modelica_wd))

	#change dir to SolarTherm/Resources/Include
	os.chdir("%s/Resources/Include"%(st_path))

	thisdir = os.path.dirname(os.path.abspath(__file__))
	wd = os.getcwd()
	comm = os.path.commonprefix([thisdir,wd])

	filename = os.path.relpath(os.path.join(thisdir,'Sinter_HX_LOADME.a4c'),comm)

	try:
		L.load(filename)			
	except Exception as e:
		sys.stderr.write(str(e))
		return -1

	#Execute the model
	try:
		R = test_model(
			modelname,
			varvalues={'width_1':(W_HX1,'m'), 't_HX1':(H_HX1,'m')},
			parameters={'iterationlimit':20000},
			retvars=[
				'Vel_ore','Vel_air','Vel_ore_2','Vel_air_2','Length_1','width_1','Length_2',
				'width_2','HX_A_1','HX_A_2','time_required','t_HX1','t_HX2',
				'W_Sinter','L_Sinter','H_Sinter',
				'Q_sun','Q_refl','Q_ext_rad','Q_ext_conv','Q_net',
				'mdot_g_HX1','mdot_s_HX1','mdot_g_HX2','mdot_s_HX2','mdot_Sinter',
				'A_material_HX1','A_material_HX2','V_material_HX1','V_material_HX2','eta_th'
			]
		)

		L.clear()
		sys.stderr.write("mdot ore: %f kg/s \n\n"%(R['mdot_s_HX2']))
		os.remove("HX_DESIGN_RESULTS_0.csv")
		mdot_ore = R['mdot_s_HX2']
	except Exception as e:
		L.clear()
		sys.stderr.write(str(e))
		sys.stderr.write("Not converging. mdot ore: %f kg/s \n\n"%(0.0))
		mdot_ore = 0

	os.remove("Sinter_HX_LOADME.a4c")

	#Get back to modelica_wd
	os.chdir(modelica_wd)

	#Make sure we get back to modelica wd
	assert(
		os.getcwd() == modelica_wd
	)

	#Append the data
	return mdot_ore
		

'''
	Function to run sintering thermal model for given parameters, and records the mdot_ore
'''
def run_thermalSinteringModel(inputs):
	sys.stderr.write("Entering python function run_thermalSinteringModel\n\n")
	#Reading the inputs
	T_sky = inputs["T_sky"]
	k_s = inputs["k_s"]
	alpha = inputs["alpha"]
	eps_r = inputs["eps_r"]
	h_ext = inputs["h_ext"]
	eps = inputs["eps"]

	T_i_s_HX1 = inputs["T_i_s_HX1"]
	T_o_s_HX1 = inputs["T_o_s_HX1"]
	T_i_g_HX1 = inputs["T_i_g_HX1"]
	d_p_HX1 = inputs["d_p_HX1"]
	H_HX1 = inputs["H_HX1"]
	W_HX1 = inputs["W_HX1"]
	t_wall_HX1 = inputs["t_wall_HX1"]

	T_i_s_HX2 = inputs["T_i_s_HX2"]
	T_o_s_HX2 = inputs["T_o_s_HX2"]
	T_i_g_HX2 = inputs["T_i_g_HX2"]
	W_HX2 = inputs["W_HX2"]
	d_p_HX2 = inputs["d_p_HX2"]

	dirsave = inputs["dir_save"]
	st_path = inputs["SolarTherm_path"]

	angle_1 = inputs["angle1"]
	angle_2 = inputs["angle2"]
	
	#Reading the flux multiplier based on DNI ratio
	#FIXME flux_multiple_off should be SAMPLED
	#flux_multiple_off = inputs["flux_multiple_off"]
	flux_multiple_off = np.linspace(start=0.7, stop=1.1, num=5)

	seg = inputs["seg"]
	
	sys.stderr.write("Done reading inputs...\n\n")

	if not os.path.exists("%s/sintering_performance_data.csv"%(dirsave)):
		f = open("%s/sintering_performance_data.csv"%(dirsave),"w")
		f.write("angle_1,angle_2,flux_multiple_off,res\n")
		f.close()

	for flux in flux_multiple_off:
		sys.stderr.write(
			"Running ASCEND model for:\nsun angle 1: %lf\nsun angle 2: %lf\nFlux multiplier: %lf\n"%(angle_1, angle_2, flux)
		)
		#Open ascend model
		try:
			t = open("%s/Resources/Include/Sinter_HX_n.a4c"%(st_path)).read()
		except Exception as e:
			sys.stderr.write(str(e))

		sys.stderr.write("Done reading ASCEND model...\n\n")

		#Parse the simulation parameters
		P_1 = Template(t).safe_substitute(N_SEGMENTS_SUBST_1 = k_s, N_SEGMENTS_SUBST_2 = alpha,N_SEGMENTS_SUBST_3 = T_sky, N_SEGMENTS_SUBST_4 = h_ext, N_SEGMENTS_SUBST_6 = T_i_g_HX1, N_SEGMENTS_SUBST_7 = T_o_s_HX1, N_SEGMENTS_SUBST_8 = T_i_s_HX1, N_SEGMENTS_SUBST_9 = d_p_HX1, N_SEGMENTS_SUBST_10 = H_HX1, N_SEGMENTS_SUBST_11 = W_HX1, N_SEGMENTS_SUBST_12 = t_wall_HX1, N_SEGMENTS_SUBST_13 = T_i_g_HX2, N_SEGMENTS_SUBST_14 = T_o_s_HX2, N_SEGMENTS_SUBST_15 = T_i_s_HX2, N_SEGMENTS_SUBST_16 = d_p_HX2, N_SEGMENTS_SUBST_17 = W_HX2, N_SEGMENTS_SUBST_18 = eps,N_SEGMENTS_SUBST_19 = int(seg),N_SEGMENTS_SUBST_20 = flux)

		f2 = open("%s/Resources/Include/Sinter_HX_LOADME.a4c"%(st_path),"w")
		f2.write(P_1)
		f2.close()

		sys.stderr.write("Done modifying ASCEND model...\n\n")

		modelname = 'HX_all'
		L = ascpy.Library()

		#Grab modelica wd
		modelica_wd = os.getcwd()
		sys.stderr.write("modelica wd: %s\n"%(modelica_wd))

		#change dir to SolarTherm/Resources/Include
		os.chdir("%s/Resources/Include"%(st_path))

		thisdir = os.path.dirname(os.path.abspath(__file__))
		wd = os.getcwd()
		comm = os.path.commonprefix([thisdir,wd])

		filename = os.path.relpath(os.path.join(thisdir,'Sinter_HX_LOADME.a4c'),comm)

		try:
			L.load(filename)			
		except Exception as e:
			sys.stderr.write(str(e))
			return -1

		#Execute the model
		try:
			R = test_model(
				modelname,
				varvalues={'width_1':(W_HX1,'m'), 't_HX1':(H_HX1,'m')},
				parameters={'iterationlimit':20000},
				retvars=[
					'Vel_ore','Vel_air','Vel_ore_2','Vel_air_2','Length_1','width_1','Length_2',
					'width_2','HX_A_1','HX_A_2','time_required','t_HX1','t_HX2',
					'W_Sinter','L_Sinter','H_Sinter',
					'Q_sun','Q_refl','Q_ext_rad','Q_ext_conv','Q_net',
					'mdot_g_HX1','mdot_s_HX1','mdot_g_HX2','mdot_s_HX2','mdot_Sinter',
					'A_material_HX1','A_material_HX2','V_material_HX1','V_material_HX2','eta_th'
				]
			)

			L.clear()
			sys.stderr.write("mdot ore: %f kg/s \n\n"%(R['mdot_s_HX2']))
			os.remove("HX_DESIGN_RESULTS_0.csv")
			mdot_ore = R['mdot_s_HX2']
		except Exception as e:
			L.clear()
			sys.stderr.write(str(e))
			sys.stderr.write("Not converging. mdot ore: %f kg/s \n\n"%(0.0))
			mdot_ore = 0
		
		os.remove("Sinter_HX_LOADME.a4c")

		#Get back to modelica_wd
		os.chdir(modelica_wd)

		#Make sure we get back to modelica wd
		assert(
			os.getcwd() == modelica_wd
		)

		#Append the data
		f = open("%s/sintering_performance_data.csv"%(dirsave),"a")
		f.write("%s,%s,%s,%s\n"%(angle_1, angle_2, flux, mdot_ore))
		f.close()
		
		#FIXME: add section to write the output of this function as CSV into modelica working dir
		'''
		sun_angle_1			sun_angle_2		flux_multiple_off		mdot_ore
		'''

'''
	Function to interpolate. Input inputs is dictionary. Return double
	@params:
		- inputs, dtype dictionary, keys: 
			> dir_save --> path to where sintering_performance_data.csv
			> declination --> declination angle at time t
			> sunhour --> sun hour angle at time t
			> flux --> flux multiplier at time t (DNI(t)/1000)
'''
def run_interpolate(inputs):
	#sys.stderr.write("Entering python function run_interpolate\n\n")
	#sys.stderr.write("%lf,%lf,%lf\n"%(declination, sunhour, flux_multiple))
	modelica_wd = inputs["dir_save"]
	declination = inputs["declination"]
	sunhour = inputs["sunhour"]
	flux_multiple = inputs["flux"]

	X_new = np.array(
		[declination, sunhour, flux_multiple]
	)

	fn_name = "%s/sintering_performance_data.csv"%(modelica_wd)
	
	#Read df
	df = pd.read_csv(fn_name)

	#X and y from df
	X = df[['angle_1','angle_2','flux_multiple_off']].to_numpy()
	y = df['res'].to_numpy()

	#Insantiate interpolator
	interpolator = LinearNDInterpolator(X, y)

	value = interpolator(X_new)

	#Delete variable
	del X_new
	del fn_name
	del df
	del X
	del y
	del interpolator
	
	if math.isnan(value[0]):
		return 0
	else:
		return value[0]


if __name__ == '__main__':
	parser = argparse.ArgumentParser()

	parser.add_argument('--T_sky', type=float)
	parser.add_argument('--k_s', type=float)
	parser.add_argument('--alpha', type=float)
	parser.add_argument('--eps_r', type=float)
	parser.add_argument('--h_ext', type=float)
	parser.add_argument('--eps', type=float) 
	parser.add_argument('--T_i_s_HX1', type=float)
	parser.add_argument('--T_o_s_HX1', type=float)
	parser.add_argument('--T_i_g_HX1', type=float)
	parser.add_argument('--d_p_HX1', type=float)
	parser.add_argument('--H_HX1', type=float)
	parser.add_argument('--W_HX1', type=float)
	parser.add_argument('--t_wall_HX1', type=float)

	parser.add_argument('--T_i_s_HX2', type=float)
	parser.add_argument('--T_o_s_HX2', type=float)
	parser.add_argument('--T_i_g_HX2', type=float)
	parser.add_argument('--W_HX2', type=float)
	parser.add_argument('--d_p_HX2', type=float)

	parser.add_argument('--flux_multiple_off', type=float)
	parser.add_argument('--seg', type=int)

	parser.add_argument('--dir_save', type=str)
	parser.add_argument('--SolarTherm_path', type=str)

	parser.add_argument('--angle1', type=float)
	parser.add_argument('--angle2', type=float)

	args = parser.parse_args()

	inputs = {}
	inputs["T_sky"] = args.T_sky 
	inputs["k_s"] = args.k_s 
	inputs["alpha"] = args.alpha
	inputs["eps_r"] = args.eps_r
	inputs["h_ext"] = args.h_ext
	inputs["eps"] = args.eps

	inputs["T_i_s_HX1"] = args.T_i_s_HX1
	inputs["T_o_s_HX1"] = args.T_o_s_HX1
	inputs["T_i_g_HX1"] = args.T_i_g_HX1
	inputs["d_p_HX1"] = args.d_p_HX1
	inputs["H_HX1"] = args.H_HX1
	inputs["W_HX1"] = args.W_HX1
	inputs["t_wall_HX1"] = args.t_wall_HX1

	inputs["T_i_s_HX2"] = args.T_i_s_HX2
	inputs["T_o_s_HX2"] = args.T_o_s_HX2
	inputs["T_i_g_HX2"] = args.T_i_g_HX2
	inputs["W_HX2"] = args.W_HX2
	inputs["d_p_HX2"] = args.d_p_HX2

	inputs["flux_multiple_off"] = args.flux_multiple_off
	
	inputs["seg"] = args.seg
	inputs["dir_save"] = args.dir_save
	inputs["SolarTherm_path"] = args.SolarTherm_path
	inputs["angle1"] = args.angle1
	inputs["angle2"] = args.angle2

	run_thermalSinteringModel(inputs)




'''
if __name__=='__main__':

	myfile = os.path.exists('HX_DESIGN_RESULTS_0.csv')
	if myfile is True:
		os.remove('HX_DESIGN_RESULTS_0.csv')

	para = np.loadtxt("./ascend_models/test_data/parameters.csv", dtype = str, delimiter = ',')
	rows = sum(1 for row in para)
	for ix in xrange(0, rows):
		if para[ix][0] == 'SINTER_INPUT':
			if para[ix][1] == 'T_sky':
				T_sky = float(para[ix][2])
			if para[ix][1] == 'k_s':
				k_s = float(para[ix][2])
			if para[ix][1] == 'alpha':
				alpha = float(para[ix][2])
			if para[ix][1] == 'eps_r':
				eps_r = float(para[ix][2])
			if para[ix][1] == 'h_ext':
				h_ext = float(para[ix][2])
			if para[ix][1] == 'eps':
				eps = float(para[ix][2])
			#if para[ix][1] == 'segment':
				#seg = float(para[ix][2])

		if para[ix][0] == 'HX1_INPUT':
			if para[ix][1] == 'T_i_s':
				T_i_s_HX1 = float(para[ix][2])
			if para[ix][1] == 'T_o_s':
				T_o_s_HX1 = float(para[ix][2])
			if para[ix][1] == 'T_i_g':
				T_i_g_HX1 = float(para[ix][2])
			if para[ix][1] == 'd_p':
				d_p_HX1 = float(para[ix][2])
			if para[ix][1] == 'H':
				H_HX1 = float(para[ix][2])
			if para[ix][1] == 'W':
				W_HX1 = float(para[ix][2])
			if para[ix][1] == 't_wall':
				t_wall_HX1 = float(para[ix][2])
		if para[ix][0] == 'HX2_INPUT':
			if para[ix][1] == 'T_i_s':
				T_i_s_HX2 = float(para[ix][2])
			if para[ix][1] == 'T_o_s':
				T_o_s_HX2 = float(para[ix][2])
			if para[ix][1] == 'T_i_g':
				T_i_g_HX2 = float(para[ix][2])
			if para[ix][1] == 'W':
				W_HX2 = float(para[ix][2])
			if para[ix][1] == 'd_p':
				d_p_HX2 = float(para[ix][2])

	seg =40

	inputs = {}
	inputs["T_sky"] = T_sky 
	inputs["k_s"] = k_s 
	inputs["alpha"] = alpha
	inputs["eps_r"] = eps_r
	inputs["h_ext"] = h_ext
	inputs["eps"] = eps

	inputs["T_i_s_HX1"] = T_i_s_HX1
	inputs["T_o_s_HX1"] = T_o_s_HX1
	inputs["T_i_g_HX1"] = T_i_g_HX1
	inputs["d_p_HX1"] = d_p_HX1
	inputs["H_HX1"] = H_HX1
	inputs["W_HX1"] = W_HX1
	inputs["t_wall_HX1"] = t_wall_HX1

	inputs["T_i_s_HX2"] = T_i_s_HX2
	inputs["T_o_s_HX2"] = T_o_s_HX2
	inputs["T_i_g_HX2"] = T_i_g_HX2
	inputs["W_HX2"] = W_HX2
	inputs["d_p_HX2"] = d_p_HX2

	inputs["flux_multiple_off"] = 1
	
	inputs["seg"] = seg
	inputs["dir_save"] = "/tmp/OpenModelica_philgun/OMEdit"
	inputs["SolarTherm_path"] = "/home/philgun/solartherm-sintering/SolarTherm"


	for i in range(1,27):
		fname = '/tmp/OpenModelica_philgun/OMEdit/test/receiver_1D_FluxMap_sunpos_%s.csv'%(i)
		try:
			os.remove("/home/philgun/solartherm-sintering/SolarTherm/Resources/Include/ascend_models/test_data/fluxmap.csv")
		except:
			pass
		os.system('cp %s %s'%(fname, "/home/philgun/solartherm-sintering/SolarTherm/Resources/Include/ascend_models/test_data"))

		os.rename('./ascend_models/test_data/receiver_1D_FluxMap_sunpos_%s.csv'%(i),"./ascend_models/test_data/fluxmap.csv")

		flux_seg_data = np.genfromtxt("./ascend_models/test_data/fluxmap.csv",dtype='float', delimiter = ',')

		flux_seg_data = np.reshape(flux_seg_data,(43,1))
		inputs["angle1"] = flux_seg_data[1][0]
		inputs["angle2"] = flux_seg_data[2][0]

		mdot_ore = run_thermalSinteringModel(inputs)
'''
