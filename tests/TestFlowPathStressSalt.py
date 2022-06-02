#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

import numpy as np
import scipy.io as sio
import DyMat
import os

class TestFlowPathStress(unittest.TestCase):
	def setUp(self):
		fn = '../examples/FlowPathStressSalt.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model(args=['-d=nonewInst'])
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='25h', step='5m', solver='dassl', nls='homotopy')

	def test_simple_system(self):
		print('Simulation finished')
		print('Starting post-processing')
#		data = DyMat.DyMatFile('FlowPathStressSalt_res.mat')
#		nz = int(data.data('N')[0]/2)
#		nt = int(data.data('nt')[0])

#		times = data.abscissa('T_fluid_fpath[1]')[0]
#		time_array = []
#		temp_array = []
#		for i,t in enumerate(times):
#			if i==0 or (t > times[i-1] and t%300==0):
#				time_array.append(t)
#				dummy_vectr = []
#				for k in range(nz):
#					dummy_var = data.data('T_fluid_fpath[%s]'%(k+1))[i]
#					dummy_vectr.append(dummy_var)
#				temp_array.append(dummy_vectr)

#		times = data.abscissa('qnet[1,1]')[0]
#		flux_array = []
#		for i,t in enumerate(times):
#			if i==0 or (t > times[i-1] and t%300==0):
#				dummy_array = []
#				for n in range(nt):
#					dummy_vectr = []
#					for k in range(nz):
#						dummy_var = data.data('qnet[%s,%s]'%(k+1,n+1))[i]
#						dummy_vectr.append(dummy_var)
#					dummy_array.append(dummy_vectr)
#				flux_array.append(dummy_array)
#		time_array = np.array(time_array)
#		temp_array = np.array(temp_array)
#		flux_array = np.array(flux_array)
#		flux_flip = flux_array[:,::-1,:]
#		flux_flip = flux_flip[:,0:-1,:]
#		flux_array = np.concatenate((flux_flip,flux_array), axis=1)
#		mdict = {"time": time_array, "flux": flux_array, "temperature": temp_array}
#		sio.savemat('../examples/srlife_input_salt.mat',mdict)

		os.system('cp FlowPathStressSalt*.mat ../examples/')
		os.system('rm FlowPathStressSalt*')


if __name__ == '__main__':
	unittest.main()

