# -*- coding: utf-8 -*-
from solartherm import simulation
from solartherm import postproc
from solartherm import params
import itertools
import xlsxwriter
import functools
import multiprocessing as mp
import os
import shutil
from sys import path
from time import time
import DyMat
import math
import numpy as np

class stcompile:
	def __init__(self,wd):
		os.chdir(wd)                                                                 # Changing working directory
		sim = simulation.Simulator('%s/TroughDrySystem.mo'%(wd))                     # Compilation of the modelica model
		print('Compiling model')
		mcargs = ['-d=nonewInst']
		sim.compile_model(args=mcargs)
		sim.compile_sim(args=['-s'])
		sim.load_init()                                                              # Generating the xml file

def simulate(wd, par_n, i, par_v):
	os.chdir(wd)                                                                     # Changing working directory
	sim = simulation.Simulator('%s/TroughDrySystem.mo'%(wd), suffix=str(i))          # Create simulator
	sim.load_init()
	sim.update_pars(par_n,par_v)                                                     # Parameters to update
	sim.simulate(start=0, stop='1y', step='300s',solver='dassl', nls='homotopy')     # Simulation of the model
	res = postprocess(wd,i)
	return res

class postprocess:
	def __init__(self,wd,i):
		mat = DyMat.DyMatFile('%s/TroughDrySystem_res_%s.mat'%(wd,i))                # Loading result file
		self.solar_mult = mat.data('SM')[0]                                          # Solar multiple
		self.t_storage = mat.data('t_storage')[0]                                    # Full load hours of storage
		self.pri_storage = mat.data('pri_storage')[0]                                # Price of storage
		self.eff_conv = mat.data('eff_conv')[0]*3.6                                  # tph per input W
		self.Q_bp_des = mat.data('Q_bp_des')[0]                                      # Beneficiation process heat input
		self.C_cap = mat.data('C_cap')[0]                                            # Capital expenditures
		self.A_field = mat.data('A_field')[0]                                        # Field area
		self.E_max = mat.data('E_max')[0]/1e3/3600                                   # Storage capacity (J)
		self.C_field = mat.data('C_field')[0]                                        # Field cost
		self.C_site = mat.data('C_site')[0]                                          # Site improvement cost
		self.C_storage = mat.data('C_storage')[0]                                    # Storage cost
		self.C_hx = mat.data('C_hx')[0]                                              # Heat exchanger cost
		self.C_fbd = mat.data('C_fbd')[0]                                            # Fluidised bed cost
		self.C_bcs = mat.data('C_bcs')[0]                                            # Blower, cyclone and separator cost
		self.kroger = mat.data('kroger')[0]                                          # Use rock bed TES from Kroger
		self.C_hx_ref = mat.data('C_hx_ref')[0]                                      # Heat exchanger reference cost
		self.C_fbd_ref = mat.data('C_fbd_ref')[0]                                    # Fluidised bed reference cost
		self.C_bcs_ref = mat.data('C_bcs_ref')[0]                                    # Blower, cyclone and separator reference cost
		self.tpy = mat.data('m')[-1]/1000                                            # Extracting the total production of iron ore (tpy)
		self.tpd = self.tpy/365                                                      # Average daily production (tons/day)
		self.toh = self.tpy/(self.eff_conv*self.Q_bp_des)                            # Total operation hours
		self.pri_elec = mat.data('pri_om_flow_iron')[0]                              # Price of electricitiy (O&M)
		self.capf = self.tpy/(8760*self.eff_conv*self.Q_bp_des)*100                  # Calculating capacity factor
		r = mat.data('r_disc')[0]                                                    # Real discount rate
		n = mat.data('t_life')[0]                                                    # Plant life
		crf = r*(1+r)**n/((1+r)**n-1)                                                # Calculating the capital recovery factor (crf)

		self.c_labour_year = math.ceil(self.tpd/100)*2*139000*0.7285                 # Labour cost per year
		self.c_fix_year = self.c_labour_year + 0.02*self.C_cap + 0.02*self.C_cap     # Fixed cost per year
		self.c_var_year = self.toh*self.pri_elec                                     # Variable cost per year
		self.c_cap_year = crf*self.C_cap                                             # Annualised cost per year
		self.E_elec = self.c_var_year/0.182

		self.lcod = (self.c_fix_year + self.c_var_year + self.c_cap_year)/(self.tpy)
		print('%s\t %s\t %s\t %s\t'%(self.solar_mult,self.t_storage,self.lcod,self.capf))
		os.system('rm -rf %s/TroughDrySystem_res_%s.mat'%(wd,i))

def simulation_callback(i,worksheet,res):
	k = 0
	worksheet.write(i+1,k,res.solar_mult); k = k + 1
	worksheet.write(i+1,k,res.t_storage); k = k + 1
	worksheet.write(i+1,k,res.lcod); k = k + 1
	worksheet.write(i+1,k,res.capf); k = k + 1
	worksheet.write(i+1,k,res.kroger); k = k + 1
	worksheet.write(i+1,k,res.toh); k = k + 1
	worksheet.write(i+1,k,res.tpy); k = k + 1
	worksheet.write(i+1,k,res.A_field); k = k + 1
	worksheet.write(i+1,k,res.E_max); k = k + 1
	worksheet.write(i+1,k,res.E_elec); k = k + 1
	worksheet.write(i+1,k,res.C_field); k = k + 1
	worksheet.write(i+1,k,res.C_site); k = k + 1
	worksheet.write(i+1,k,res.C_storage); k = k + 1
	worksheet.write(i+1,k,res.C_hx); k = k + 1
	worksheet.write(i+1,k,res.C_fbd); k = k + 1
	worksheet.write(i+1,k,res.C_bcs); k = k + 1
	worksheet.write(i+1,k,res.C_cap); k = k + 1
	worksheet.write(i+1,k,res.c_fix_year); k = k + 1
	worksheet.write(i+1,k,res.c_var_year); k = k + 1
	worksheet.write(i+1,k,res.eff_conv); k = k + 1
	worksheet.write(i+1,k,res.C_hx_ref); k = k + 1
	worksheet.write(i+1,k,res.C_fbd_ref); k = k + 1
	worksheet.write(i+1,k,res.C_bcs_ref); k = k + 1
	worksheet.write(i+1,k,res.pri_elec); k = k + 1
	worksheet.write(i+1,k,res.Q_bp_des);
	return None

class clean_comp_files:
	def __init__(self,wd):
		os.chdir(wd)
		os.system('rm -rf *.o *.c *.h *.json *.makefile *.xml TroughDrySystem')

def parameter_sweep(iron_ore,expensive_storage,Q_fbd_des):

	if iron_ore == 1:
		eff_conv = '3.56e-6'
		C_hx_ref = '58946070.0'
		C_fbd_ref = '24255986.0'
		C_bcs_ref = '13491551.0'
		pri_om_flow_iron = '438.1'
	elif iron_ore == 2:
		eff_conv = '6.2e-6'
		C_hx_ref = '110970925.0'
		C_fbd_ref = '32088823.0'
		C_bcs_ref = '17060409.0'
		pri_om_flow_iron = '633.2'

	Q_bp_des = str(Q_fbd_des)
	wd = '../examples'
	stcompile(wd)                                                                    # Compiling and initialising the simulation
	sol_multi = np.linspace(1,5,41)                                                  # Defining solar multiple to sweep
	t_storage = np.linspace(1,40,40)                                                 # Defining storage hours to sweep
	par_v = []
	if expensive_storage:
		kroger = 'true'
		storage = 'expensive'
	else:
		kroger = 'false'
		storage = 'cheaper'
	for i,j in enumerate(itertools.product(sol_multi,t_storage)):
		j = map(str,list(j))
		j.append(kroger)
		j.append(eff_conv)
		j.append(C_hx_ref)
		j.append(C_fbd_ref)
		j.append(C_bcs_ref)
		j.append(pri_om_flow_iron)
		j.append(Q_bp_des)
		par_v.append(j)

	par_n = ['SM','t_storage','kroger','eff_conv','C_hx_ref','C_fbd_ref','C_bcs_ref','pri_om_flow_iron','Q_bp_des']
	objfunc = functools.partial(simulate, wd, par_n)

	workbook = xlsxwriter.Workbook('iron_ore_%s_%s_storage.xlsx'%(iron_ore,storage)) # Writting results in text and xlsx files
	worksheet = workbook.add_worksheet()
	col = 0
	worksheet.write(0,col,'Solar multiple'); col += 1
	worksheet.write(0,col,'Full load hours of storage'); col += 1
	worksheet.write(0,col,'LCOD ($/ton)'); col += 1
	worksheet.write(0,col,'capf (%)'); col += 1
	worksheet.write(0,col,'kroger'); col += 1
	worksheet.write(0,col,'Total operation time (h/year)'); col += 1
	worksheet.write(0,col,'Total production per year (ton/year)'); col += 1
	worksheet.write(0,col,'Field area (m2)'); col += 1
	worksheet.write(0,col,'Storage capacity (kWh)'); col += 1
	worksheet.write(0,col,'Electricity consumption (kWh/year)'); col += 1
	worksheet.write(0,col,'Cost of field ($)'); col += 1
	worksheet.write(0,col,'Cost of site ($)'); col += 1
	worksheet.write(0,col,'Cost of storage ($)'); col += 1
	worksheet.write(0,col,'Cost of hx ($)'); col += 1
	worksheet.write(0,col,'Cost of fbd ($)'); col += 1
	worksheet.write(0,col,'Cost of bcs ($)'); col += 1
	worksheet.write(0,col,'Capital Cost ($)'); col += 1
	worksheet.write(0,col,'Fix cost per year ($)'); col += 1
	worksheet.write(0,col,'Variable cost per year ($)'); col += 1
	worksheet.write(0,col,'eff_conv'); col += 1
	worksheet.write(0,col,'C_hx_ref'); col += 1
	worksheet.write(0,col,'C_fbd_ref'); col += 1
	worksheet.write(0,col,'C_bcs_ref'); col += 1
	worksheet.write(0,col,'pri_om_flow_iron'); col += 1
	worksheet.write(0,col,'Q_bp_des'); col += 1

	pool = mp.Pool(processes=mp.cpu_count())
	t = time()
	print('solar mult.(-)\t t storage (h)\t lcod ($/ton)\t capf (%)')
	for i,vals in enumerate(par_v):
		pool.apply_async(objfunc, args=(i, vals), callback=functools.partial(simulation_callback, i, worksheet))
	pool.close()
	pool.join()

	print('Simulation time: %fs'%(time()-t))
	workbook.close()
	clean_comp_files(wd)
	return None

if __name__=="__main__":
	tinit = time()
	parameter_sweep(1,True,50e6)
	#parameter_sweep(2,True,50e6)
	seconds = time() - tinit
	m, s = divmod(seconds, 60)
	h, m = divmod(m, 60)
	print('Simulation time: {:d}:{:02d}:{:02d}'.format(int(h), int(m), int(s)))
