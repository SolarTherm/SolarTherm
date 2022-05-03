# -*- coding: utf-8 -*-
from solartherm import simulation
from solartherm import postproc
from solartherm import params
from solartherm.optimisation import *
import multiprocessing as mp
import functools
from scipy import optimize as sciopt
import os
import shutil
from sys import path
from time import time
import DyMat
import math
import numpy as np

def simulate(sim, wd, scale, offset, index, par_n, par_val):
	os.chdir(wd)
	par_v = [str(v*scale[i] + offset[i]) for i, v in enumerate(par_val)]
	sim.update_pars(par_n, par_v)
	sim.simulate(start=0, stop='1y', step='300s',solver='dassl', nls='homotopy')
	mat = DyMat.DyMatFile('TroughDrySystem_res_%s.mat'%(index))
	eff_conv = mat.data('eff_conv')[0]
	Q_bp_des = mat.data('Q_bp_des')[0]
	C_cap = mat.data('C_cap')[0]
	solar_mult = mat.data('SM')[0]
	t_storage = mat.data('t_storage')[0]
	pri_stor = mat.data('pri_storage')[0]
	E_cap = mat.data('E_cap')[0]
	tpy = mat.data('m')[-1]/1000
	tpd = tpy/365
	toh = tpy/(eff_conv*3.6*Q_bp_des)
	pri_elec = mat.data('pri_om_flow_iron')[0]
	C_hx_ref = mat.data('C_hx_ref')[0]
	C_fbd_ref = mat.data('C_fbd_ref')[0]
	C_bcs_ref = mat.data('C_bcs_ref')[0]
	f_hx = mat.data('f_hx')[0]
	f_fbd = mat.data('f_fbd')[0]
	f_bcs = mat.data('f_bcs')[0]
	f_field = mat.data('f_field')[0]
	f_stor = mat.data('f_stor')[0]
	capf = tpy/(8760*eff_conv*3.6*Q_bp_des)*100
	ii = mat.data('r_disc')[0]
	n = mat.data('t_life')[0]
	crf = ii*(1+ii)**n/((1+ii)**n-1)
	c_fix_year = math.ceil(tpd/100)*2*139000*0.7285 + 0.02*C_cap + 0.02*C_cap
	c_var_year = toh*pri_elec
	c_cap_year = crf*C_cap
	lcod = (c_fix_year + c_var_year + c_cap_year)/(tpy)
	print('optimisation_%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s'%(index, solar_mult, t_storage, lcod, eff_conv, Q_bp_des, C_hx_ref, C_fbd_ref, C_bcs_ref, pri_elec, pri_stor, E_cap, f_hx, f_fbd, f_bcs, f_field, f_stor))
	return lcod

def optimise(estor, index, x):
	io = int(x[0])
	Q_bp_des = str(x[1])
	f_hx = str(x[2])
	f_fbd = str(x[3])
	f_bcs = str(x[4])
	f_field = str(x[5])
	f_stor = str(x[6])
	if io == 1:
		eff_conv = '3.56e-6'
		C_hx_ref = '58946070'
		C_fbd_ref = '24255986.0'
		C_bcs_ref = '13491551.0'
		pri_om_flow_iron = '438.1'
	elif io == 2:
		eff_conv = '6.2e-6'
		C_hx_ref = '110970925.0'
		C_fbd_ref = '32088823.0'
		C_bcs_ref = '17060409.0'
		pri_om_flow_iron = '633.2'
	if estor:
		kroger = 'true'
	else:
		kroger = 'false'
	vals = [[1,5.2],[1,40]]
	par_n = ['SM','t_storage']
	par_b = [[0,1],[0,1]]
	par_0 = []
	LB = []
	UB = []
	offset = []
	scale = []
	for i in vals:
		lb = i[0]
		ub = i[1]
		p0 = (ub + lb)/2
		offset.append(lb)
		scale.append((ub - lb))
		par_0.append((p0 - lb)/(ub - lb))
	wd = '../examples'
	os.chdir(wd)
	sim = simulation.Simulator('TroughDrySystem.mo', suffix=str(index))
	mcargs = ['-d=nonewInst']
	print('Compiling model')
	sim.compile_model(args=mcargs)
	sim.compile_sim(args=['-s'])
	sim.load_init()
	fix_par_n = ['eff_conv','C_hx_ref','C_fbd_ref','C_bcs_ref','pri_om_flow_iron','Q_bp_des','kroger','f_hx','f_fbd','f_bcs','f_field','f_stor']
	fix_par_v = [ eff_conv , C_hx_ref , C_fbd_ref , C_bcs_ref , pri_om_flow_iron , Q_bp_des , kroger , f_hx , f_fbd , f_bcs , f_field , f_stor ]
	sim.update_pars(fix_par_n, fix_par_v)
	objfunc = functools.partial(simulate, sim, wd, scale, offset, index, par_n)
	res, cand = st_ga1(objfunc, par_b, par_n, scale, offset)
	print("Optimal design parameters: ", cand)
	print("Optimal objective function: ", res)
	return res,cand

def simulation_callback(txt,io,estor,index,res):
	txt.write('optimisation_%s,iron ore %s,%s,%s,%s, kroger%s\n'%(index,io, res[0], res[1][0], res[1][1], estor))
	return None

def optimizar(index,io):
	txt = open('results_io_%s_%s.txt'%(io,index),'w+')
	estor = True
	if index == 0:
		optpar = [[io,50e6,0.5,1,1,1,1],[io,50e6,1.5,1,1,1,1]]
	elif index == 1:
		optpar = [[io,50e6,1,0.5,1,1,1],[io,50e6,1,1.5,1,1,1]]
	elif index == 2:
		optpar = [[io,50e6,1,1,0.5,1,1],[io,50e6,1,1,1.5,1,1]]
	elif index == 3:
		optpar = [[io,50e6,1,1,1,0.5,1],[io,50e6,1,1,1,1.5,1]]
	else:
		optpar = [[io,50e6,1,1,1,1,0.5],[io,50e6,1,1,1,1,1.5]]
	for i,vals in enumerate(optpar):
		res = optimise(estor, i, vals)
		simulation_callback(txt,vals[0],estor,i,res)
	txt.close()
	return None

def optimizar_Qbp(io):
	wd = '../examples'
	os.chdir(wd)
	txt = open('results_io_%s.txt'%io,'w+')
	estor = True
	optpar = [[io,100e6,1,1,1,1,1],[io,200e6,1,1,1,1,1],[io,300e6,1,1,1,1,1],[io,400e6,1,1,1,1,1],[io,500e6,1,1,1,1,1],[io,600e6,1,1,1,1,1]]
	for i,vals in enumerate(optpar):
		res = optimise(estor, i, vals)
		simulation_callback(txt,vals[0],estor,i,res)
	txt.close()
	return None

if __name__=='__main__':
	#IO1
	optimizar(0,1)
	optimizar(1,1)
	optimizar(2,1)
	optimizar(3,1)
	optimizar(4,1)
	#IO2
	optimizar(0,2)
	optimizar(1,2)
	optimizar(2,2)
	optimizar(3,2)
	optimizar(4,2)
	#LCOD vs Qpb
	optimizar_Qbp(1)
	optimizar_Qbp(2)
