#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

import numpy as np
import DyMat
import os

class TestFlowPathStress(unittest.TestCase):
	def setUp(self):
		fn = '../examples/FlowPathStress.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model(args=['-d=nonewInst'])
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='5m', solver='dassl', nls='homotopy')

	def test_simple_system(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.

		print('Simulation finished')
		print('Starting post-processing')
		data = DyMat.DyMatFile('FlowPathStress_res.mat')
		nz = int(data.data('N')[0])
		nt = int(data.data('nt')[0])
		times = data.abscissa('T_fluid_fpath[1]')[0]
		f = open('../examples/T_htf_input.csv','w+')
		s = '#time'
		for j in range(nz):
			s += ',Tf[%s]'%j
		f.write('%s\n'%s)
		theta = np.linspace(0, np.pi, nt)
		for i,t in enumerate(times):
			if i==0 or (t > times[i-1] and t%300==0):
				s = '%s'%t
				for k in range(nz):
					s += ',%s'%data.data('T_fluid_fpath[%s]'%(k+1))[i]
				f.write('%s\n'%s)
		f.close()
		os.system('cp FlowPathStress*.mat ../examples/')
		os.system('rm FlowPathStress*')


if __name__ == '__main__':
	unittest.main()

