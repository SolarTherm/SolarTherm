# import the 'extpy' module for basic access to the ASCEND API
import extpy

# any stuff that might cause errors should be imported like this:
try:
	from mpl_toolkits.mplot3d import Axes3D
	from matplotlib import cm
	from pylab import *
	import numpy as np
	import matplotlib
	import matplotlib.pyplot as plt
	from StringIO import StringIO
	from matplotlib import ticker
	from math import *
	import sys
	import os.path
	import math
	import os,itertools
	import shutil
	import sys
	import csv #MODIF PG

	from matplotlib import rc
	rc('font',**{'family':'serif','serif':['Liberation Serif'],'size':14})
	from matplotlib.image import NonUniformImage
except:
	pass
 
# you can import standard ASCEND components, for example:
from solverreporter import *

def load_fluxmap(self):
	try:
		filename = self.fluxmap.getSymbolValue()
		if not isinstance(filename, str):
			filename = str(filename)

		sys.stderr.write("fluxmap: %s\n"%(filename))#PG
		sys.stderr.write("Loading flux data from '%s'.......\n"%(filename,))
		try:
			flux_seg_data = np.genfromtxt(filename, dtype='float', delimiter = ',')
			sys.stderr.write("Loading flux data done.......\n")
		except Exception as e:
			sys.stderr.write("Loading flux data failed.....\n")
			sys.stderr.write("%s\n%s\n"%(str(e),str(e.__class__)))
	except Exception as e:
		sys.stderr.write(str(e))
	return flux_seg_data

def set_x_y(self):
	flux_seg_data = load_fluxmap(self)
	n_sinter = self.Sinter.n.getIntValue()
	L = float(self.Sinter.L)
	W = float(self.Sinter.W)
	flux_multiple_on = float(self.flux_ratio_on)
	flux_seg_1 = np.reshape(flux_seg_data,(n_sinter+3,1))
	flux_seg = flux_seg_1[3:n_sinter+3]*flux_multiple_on
	for i in range(0,n_sinter):
		self.Sinter.seg[i].Q_sun.setRealValue(float(flux_seg[i]) * L * W / n_sinter)
		self.Sinter.seg[i].Q_sun.setFixed(True)		

def off_design_flux(self):
	flux_seg_data = load_fluxmap(self)
	n_sinter = self.Sinter.n.getIntValue()
	L = float(self.Sinter.L)
	W = float(self.Sinter.W)
	flux_multiple_off = float(self.flux_ratio_off)
	flux_seg_1 = np.reshape(flux_seg_data,(n_sinter+3,1))
	flux_seg = flux_seg_1[3:n_sinter+3]

	for i in range(0,n_sinter):
		self.Sinter.seg[i].Q_sun.setRealValue(float(flux_seg[i]) * flux_multiple_off * L * W / n_sinter)
		self.Sinter.seg[i].Q_sun.setFixed(True)	

def plot_x_y(self):
	'''
	print 'HX1.area', float(self.HX1.A_HX)
	print 'HX2.area', float(self.HX2.A_HX)
	print 'mdot_g', float(self.HX2.mdot_g)
	print 'mdot_s', float(self.HX2.mdot_s)
	print 'time required', float(self.time_required)
	print 'cross section area of air', float(self.HX1.seg[0].HX_g.inlet.A)
	print 'velocity of ore (HX1)', float(self.Vel_ore) 
	print 'velocity of air (HX1)', float(self.Vel_air) 
	print 'Length (HX1)', float(self.Length) 
	print 'Width (HX1)', float(self.width) 

	print 'velocity of ore (HX2)', float(self.Vel_ore_2) 
	print 'velocity of air (HX2)', float(self.Vel_air_2) 
	print 'Length (HX2)', float(self.Length_2) 
	print 'Width (HX2)', float(self.width_2) 
	'''
	results = np.array(())
	params = "HX1_T_i_g HX1_T_o_g HX1_T_i_s HX1_T_o_s Vel_ore Vel_air t_HX1 width_1 Length_1 time_required HX_A_1 A_material_HX1 V_material_HX1 HX2_T_i_g HX2_T_o_g HX2_T_i_s HX2_T_o_s Vel_ore_2 Vel_air_2 t_HX2 width_2 Length_2 HX_A_2 A_material_HX2 V_material_HX2 H_Sinter W_Sinter L_Sinter Q_sun Q_refl Q_ext_rad Q_ext_conv Q_net mdot_Sinter mdot_g_HX1".split()
	for i in range(len(params)):
		results = np.append(results,(params[i],'', float(getattr(self,params[i]))))

	results = results.reshape((len(params)),3)
	numbers = np.array(())
	numbers = results[:,2]
	numbers = np.reshape(numbers,((len(params)),1))
	myfile = os.path.exists("HX_DESIGN_RESULTS_0.csv")
	if myfile is False:
		with open("HX_DESIGN_RESULTS_0.csv", 'wb') as fp:
			writer = csv.writer(fp, delimiter = ',')
			writer.writerows(results)
	else:
		with open("HX_DESIGN_RESULTS_1.csv", 'wb') as fp:
			writer = csv.writer(fp ,delimiter = ',')
			writer.writerows(numbers)

		data = []
		expand = lambda it, size: it + [[' '] * len(it)] * size

		for n in range(0,2):
			with open('HX_DESIGN_RESULTS_' + str(n) + '.csv') as fp:
				d = list(csv.reader(fp))
				t = len(d) - len(data)
				data = d if not data else [
					x + y for x, y in itertools.izip_longest(
					    expand(data, t), expand(d, -t))]

		csv_out = open("HX_DESIGN_RESULTS_0.csv","wb")
		writer = csv.writer(csv_out)
		writer.writerows(data)
		csv_out.close()
		os.remove("HX_DESIGN_RESULTS_1.csv")


	n_HX1 = self.HX1.n.getIntValue()
	n_HX2 = self.HX2.n.getIntValue()
	n_sinter = self.Sinter.n.getIntValue()
	T_g_HX1 = np.zeros(n_HX1+1)
	T_s_HX1 = np.zeros(n_HX1+1)
	delta_T_HX1 = np.zeros(n_HX2+1)
	T_g_HX2 = np.zeros(n_HX2+1)
	T_s_HX2 = np.zeros(n_HX2+1)
	x_HX1 = np.arange(0,n_HX1+1,1)
	x_HX2 = np.arange(0,n_HX2+1,1)
	L = float(self.Sinter.L)
	x_sinter = np.linspace(0,L,n_sinter)

	T_top_sinter = np.zeros(n_sinter)
	T_f_sinter = np.zeros(n_sinter)

	h_g_HX1 = np.zeros(n_HX1+1)
	h_s_HX1 = np.zeros(n_HX1+1)
	h_g_HX2 = np.zeros(n_HX2+1)
	h_s_HX2 = np.zeros(n_HX2+1)

	for i in range(0,n_HX1+1):
		T_g_HX1[i] = float(self.HX1.node_g[i].T - 273.15)
		T_s_HX1[i] = float(self.HX1.node_s[i].T - 273.15)
		h_g_HX1[i] = float(self.HX1.node_g[i].h) / 1000.
		h_s_HX1[i] = float(self.HX1.node_s[i].h) / 1000.	
		delta_T_HX1[i] = T_g_HX1[i] - T_s_HX1[i]
	
	for ii in range(0,n_HX2+1):
		T_g_HX2[ii] = float(self.HX2.node_g[ii].T - 273.15)
		T_s_HX2[ii] = float(self.HX2.node_s[ii].T - 273.15)
		h_g_HX2[ii] = float(self.HX2.node_g[ii].h) / 1000.
		h_s_HX2[ii] = float(self.HX2.node_s[ii].h) / 1000.
	h_diff = np.where(delta_T_HX1 == min(delta_T_HX1))

	for ix in range(0,n_sinter):
		T_top_sinter[ix] = float(self.Sinter.seg[ix].T_ext - 273.15)
		T_f_sinter[ix] = float(self.Sinter.seg[ix].inlet.T - 273.15)

extpy.registermethod(set_x_y)
extpy.registermethod(off_design_flux)
extpy.registermethod(plot_x_y)

