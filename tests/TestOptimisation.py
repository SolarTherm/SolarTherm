#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc
import os

class TestOptimisation(unittest.TestCase):
	def setUp(self):
		fn = 'TestOptimisation.mo'
		model = 'AO'
		sim = simulation.Simulator(fn, model=model)
		# For some reason won't compile with Modelica library
		sim.compile_model(libs=[], args=['-g=Optimica'])
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=1, step=0.02, solver='optimization')
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_optimum(self):

		self.assertTrue(abs(self.res.interpolate('x1', 0)-1.0)/1.0<0.01)
		self.assertTrue(abs(self.res.interpolate('x2', 0)-0.0)<0.01)
		self.assertTrue(abs(self.res.interpolate('u', 1)-2.48)/2.48<0.01)

		os.system('rm AO_*')
		os.system('rm AO')
		os.system('rm AO.c')
		os.system('rm AO.o')
		os.system('rm AO.makefile')

if __name__ == '__main__':
	unittest.main()
