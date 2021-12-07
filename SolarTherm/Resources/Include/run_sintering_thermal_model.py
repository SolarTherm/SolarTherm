import ascpy
import numpy as np
import pylab as pl
import os
import csv
from string import Template
#from matplotlib.sankey import Sankey
#import matplotlib.pyplot as plt
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
	sys.stderr.write("Reading inputs...\n\n")

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

	solstice_wd = inputs["solstice_wd"] #path to solstice
	fmfile = inputs["fmfile"]
	st_path = inputs["SolarTherm_path"]
	iron_sample = inputs["iron_sample"]

	seg = int(np.genfromtxt(fmfile,delimiter=",")[0])
	
	for key in inputs:
		sys.stderr.write("%s : %s\n"%(key, inputs[key]))

	sys.stderr.write("\nDone reading inputs...\n")
	sys.stderr.write("Running function for iron sample : %s\n\n"%(iron_sample))
	
	#Since it is on design calculation, flux_multiple_on == 1
	flux_multiple_on = 1

	#Reading the flux multiplier based on DNI ratio
	flux = 1

	#Open ASCEND model
	try:
		t = open("%s/Resources/Include/Sinter_HX_n.a4c"%(st_path)).read()
	except Exception as e:
		sys.stderr.write(str(e))

	sys.stderr.write("Done reading ASCEND model...\n\n")

	assert os.path.isfile(fmfile)

	# READ THE number of segments
	seg = int(np.genfromtxt(fmfile, delimiter=",")[0])

	#Parse the simulation parameters
	P_1 = Template(t).safe_substitute(
		N_SEGMENTS_SUBST_1 = k_s, N_SEGMENTS_SUBST_2 = alpha,N_SEGMENTS_SUBST_3 = T_sky, N_SEGMENTS_SUBST_4 = h_ext
		,N_SEGMENTS_SUBST_6 = T_i_g_HX1, N_SEGMENTS_SUBST_7 = T_o_s_HX1, N_SEGMENTS_SUBST_8 = T_i_s_HX1, N_SEGMENTS_SUBST_9 = d_p_HX1
		,N_SEGMENTS_SUBST_10 = H_HX1, N_SEGMENTS_SUBST_11 = W_HX1, N_SEGMENTS_SUBST_12 = t_wall_HX1, N_SEGMENTS_SUBST_13 = T_i_g_HX2
		,N_SEGMENTS_SUBST_14 = T_o_s_HX2, N_SEGMENTS_SUBST_15 = T_i_s_HX2, N_SEGMENTS_SUBST_16 = d_p_HX2, N_SEGMENTS_SUBST_17 = W_HX2
		,N_SEGMENTS_SUBST_18 = eps
		,N_SEGMENTS_SUBST_19 = int(seg)
		,N_SEGMENTS_SUBST_20 = flux
		,N_SEGMENTS_SUBST_21 = flux_multiple_on
		,FLUXMAP_FILENAME = fmfile
		,IRON_SAMPLE = iron_sample
	)
	
	#Write ascend models into solstice path
	sys.stderr.write("solstice wd: %s\n"%(solstice_wd))
	filename = "%s/testname.a4c"%(solstice_wd)
	sys.stderr.write(
		"Modify the model code and save it as: %s\n"%(
			filename
		)
	)

	f2 = open(filename,"w")
	f2.write(P_1)
	f2.close()

	sys.stderr.write(
		"Done modifying ASCEND model. Written to %s...\n"%(
			filename
		)
	)

	modelname = 'HX_all'
	L = ascpy.Library()

	#Grab modelica wd
	modelica_wd = os.getcwd()
	sys.stderr.write("modelica wd: %s\n"%(modelica_wd))

	#change dir to solstice_wd
	#sys.stderr.write("change dir to solstice_wd: %s\n"%(solstice_wd))

	#os.chdir(solstice_wd)
	#sys.stderr.write("done change dir to solstice_wd. current dir: %s\n"%(os.getcwd()))

	sys.stderr.write("Loading the modified ASCEND file: %s\n"%(filename))

	L.load(filename)

	sys.stderr.write("Done loading modified ASCEND file: %s\n"%(filename))

	#Execute the model
	sys.stderr.write("Execute the model %s\n"%(filename))

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
				'A_material_HX1','A_material_HX2','V_material_HX1','V_material_HX2','eta_th','A_HX_1', 'A_HX_2'
			]
		)

		L.clear()
		sys.stderr.write("mdot ore: %f kg/s \n\n"%(R['mdot_s_HX2']))
		os.remove("HX_DESIGN_RESULTS_0.csv")
		mdot_ore = R['mdot_s_HX2']
		V_HX_1 = R['V_material_HX1']
		V_HX_2 = R['V_material_HX2']
		A_HX_1 = R['A_HX_1']
		A_HX_2 = R['A_HX_2']
	except Exception as e:
		L.clear()
		sys.stderr.write("%s\n"%(str(e)))
		sys.stderr.write("Not converging. mdot ore: %f kg/s \n\n"%(0.0))
		mdot_ore = 0
		V_HX_1 = 10000000000000
		V_HX_2 = 10000000000000
		A_HX_1 = 10000000000000
		A_HX_2 = 10000000000000

	sys.stderr.write("Done execute the model %s\n"%(filename))

	#sys.stderr.write("Change back to modelica wd %s\n"%(modelica_wd))
	
	#Get back to modelica_wd
	#os.chdir(modelica_wd)
	#sys.stderr.write("Done change back to modelica wd. Current wd: %s\n"%(os.getcwd()))

	#Make sure we get back to modelica wd
	#assert(
	#	os.getcwd() == modelica_wd
	#)

	sys.stderr.write("A_HX1: %lf, A_HX2: %lf\n"%(A_HX_1, A_HX_2))

	with open("%s/des_point_calc.csv"%(solstice_wd),"w") as f:
		f.write('%s,%s,%s'%(mdot_ore,A_HX_1, A_HX_2))

'''
	Function to run sintering thermal model for given parameters, and records the mdot_ore
'''
def run_thermalSinteringModelOffDesign(inputs):
	sys.stderr.write("Entering python function run_thermalSinteringModelOffDesign to generate training data for surrogate models\n\n")
	sys.stderr.write("Reading inputs...\n\n")

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

	solstice_wd = inputs["solstice_wd"] #path to solstice
	fmfile = inputs["fmfile"]
	st_path = inputs["SolarTherm_path"]
	iron_sample = inputs["iron_sample"]
	
	#Reading the flux multiplier based on DNI ratio
	#FIXME flux_multiple_off should be SAMPLED
	#flux_multiple_off = inputs["flux_multiple_off"]
	flux_multiple_off = np.linspace(start=0.7, stop=1.1, num=5)
	flux_multiple_on = 1
	
	arr = np.genfromtxt(fmfile,delimiter=",")
	seg = int(arr[0])
	angle_1 = arr[1]
	angle_2 = arr[2]
	
	sys.stderr.write("Done reading inputs...\n\n")

	if not os.path.exists("%s/sintering_performance_data.csv"%(solstice_wd)):
		f = open("%s/sintering_performance_data.csv"%(solstice_wd),"w")
		f.write("angle_1,angle_2,flux_multiple_off,res\n")
		f.close()
	
	sys.stderr.write(
		"Flux map file: '%s'\n"%(fmfile)
	)
	for flux in flux_multiple_off:
		sys.stderr.write(
			"Running ASCEND model for:\nsun angle 1: %lf\nsun angle 2: %lf\nFlux multiplier: %lf\n"%(angle_1, angle_2, flux)
		)

		#Open the default ascend model located in SolarTherm/Resources/Include
		try:
			t = open("%s/Resources/Include/Sinter_HX_n.a4c"%(st_path)).read()
		except Exception as e:
			sys.stderr.write(str(e))

		sys.stderr.write("Done reading ASCEND model...\n\n")

		#Parse the simulation parameters
		P_1 = Template(t).safe_substitute(
			N_SEGMENTS_SUBST_1 = k_s, N_SEGMENTS_SUBST_2 = alpha,N_SEGMENTS_SUBST_3 = T_sky, N_SEGMENTS_SUBST_4 = h_ext
			,N_SEGMENTS_SUBST_6 = T_i_g_HX1, N_SEGMENTS_SUBST_7 = T_o_s_HX1, N_SEGMENTS_SUBST_8 = T_i_s_HX1, N_SEGMENTS_SUBST_9 = d_p_HX1
			,N_SEGMENTS_SUBST_10 = H_HX1, N_SEGMENTS_SUBST_11 = W_HX1, N_SEGMENTS_SUBST_12 = t_wall_HX1, N_SEGMENTS_SUBST_13 = T_i_g_HX2
			,N_SEGMENTS_SUBST_14 = T_o_s_HX2, N_SEGMENTS_SUBST_15 = T_i_s_HX2, N_SEGMENTS_SUBST_16 = d_p_HX2, N_SEGMENTS_SUBST_17 = W_HX2
			,N_SEGMENTS_SUBST_18 = eps
			,N_SEGMENTS_SUBST_19 = int(seg)
			,N_SEGMENTS_SUBST_20 = flux
			,N_SEGMENTS_SUBST_21 = flux_multiple_on
			,FLUXMAP_FILENAME = fmfile
			,IRON_SAMPLE = iron_sample
		)

		#Save the model to solstice_wd
		sys.stderr.write("solstice wd: %s\n"%(solstice_wd))
		filename = "%s/testname.a4c"%(solstice_wd)

		sys.stderr.write(
			"Modify the model code and save it as: %s\n"%(
				filename
			)
		)

		f2 = open(filename,"w")
		f2.write(P_1)
		f2.close()

		sys.stderr.write(
			"Done modifying ASCEND model. Written to %s...\n\n"%(
				filename
			)
		)

		modelname = 'HX_all'
		L = ascpy.Library()

		#Grab modelica wd
		modelica_wd = os.getcwd()
		sys.stderr.write("modelica wd: %s\n"%(modelica_wd))

		#Change directory to solstice wd
		#os.chdir(solstice_wd)

		try:
			sys.stderr.write("Load: %s\n"%(filename))
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
					'A_material_HX1','A_material_HX2','V_material_HX1','V_material_HX2','eta_th','A_HX_1', 'A_HX_2'
				]
			)

			L.clear()
			sys.stderr.write("mdot ore: %f kg/s \n\n"%(R['mdot_s_HX2']))
			os.remove("%s/HX_DESIGN_RESULTS_0.csv"%(solstice_wd))
			mdot_ore = R['mdot_s_HX2']
		except Exception as e:
			L.clear()
			sys.stderr.write(str(e))
			sys.stderr.write("Not converging. mdot ore: %f kg/s \n\n"%(0.0))
			mdot_ore = 0
		
		#os.remove(filename)

		#Get back to modelica_wd
		#os.chdir(modelica_wd)

		#Make sure we get back to modelica wd
		#assert(
		#	os.getcwd() == modelica_wd
		#)

		#Append the data
		f = open("%s/sintering_performance_data.csv"%(solstice_wd),"a")
		f.write("%s,%s,%s,%s\n"%(angle_1, angle_2, flux, mdot_ore))
		f.close()

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
	solstice_wd = inputs["dir_save"]
	declination = inputs["declination"]
	sunhour = inputs["sunhour"]
	flux_multiple = inputs["flux"]

	X_new = np.array(
		[declination, sunhour, flux_multiple]
	)

	fn_name = "%s/sintering_performance_data.csv"%(solstice_wd)
	
	#Read df
	try:
		df = pd.read_csv(fn_name)
	except Exception as e:
		sys.stderr.write("%s\n"%(e))
		raise IOError("No training data. Should be saved as %s"%(fn_name))

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


def do_test_case():
	filename = "/home/philgun/test_solartherm/test_st_simulate_sintering/optic/testname.a4c"
	modelname = 'HX_all'
	assert os.path.isfile(filename)

	sys.stderr.write("Initialising ASCEND library...\n")
	L = ascpy.Library()
	sys.stderr.write("Loading the modified ASCEND file: %s\n"%(filename))
	L.load(filename)

	sys.stderr.write("Execute the model %s\n"%(filename))
	W_HX1 = 8.0
	H_HX1 = 0.05
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
				'A_material_HX1','A_material_HX2','V_material_HX1','V_material_HX2','eta_th','A_HX_1', 'A_HX_2'
			]
		)

		L.clear()
		sys.stderr.write("mdot ore: %f kg/s \n\n"%(R['mdot_s_HX2']))
		os.remove("HX_DESIGN_RESULTS_0.csv")
		mdot_ore = R['mdot_s_HX2']
		V_HX_1 = R['V_material_HX1']
		V_HX_2 = R['V_material_HX2']
	except Exception as e:
		L.clear()
		sys.stderr.write("%s\n"%(str(e)))
		sys.stderr.write("Not converging. mdot ore: %f kg/s \n\n"%(0.0))
		mdot_ore = 0
		V_HX_1 = 10000000000000
		V_HX_2 = 10000000000000

	sys.stderr.write("V_HX1: %lf, V_HX2: %lf\n"%(V_HX_1, V_HX_2))

if __name__ == '__main__':
	parser = argparse.ArgumentParser()

	parser.add_argument('--which_run', type=str)

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


	parser.add_argument('--solstice_wd', type=str)
	parser.add_argument('--fmfile', type=str)
	parser.add_argument('--SolarTherm_path', type=str)
	parser.add_argument('--iron_sample', type=str)
	
	#Off design arguments
	parser.add_argument('--flux_multiple_off', type=float)

	args = parser.parse_args()

	which_run = args.which_run
	
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

	inputs["solstice_wd"] = args.solstice_wd
	inputs["fmfile"] = args.fmfile
	inputs["SolarTherm_path"] = args.SolarTherm_path
	inputs["iron_sample"] = args.iron_sample

	if which_run == "on_design":
		print(which_run)
		run_thermalSinteringModelDesignPoint(inputs)
	elif which_run == "off_design":
		run_thermalSinteringModelOffDesign(inputs)
	elif which_run == "testing":
		do_test_case()

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

# vim: ts=4:noet
