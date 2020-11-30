#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc
from DyMat import DyMatFile as D

from math import pi
import os

class TestLinprog(unittest.TestCase):
	def setUp(self):
		fn = './TestLinprog.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='90000s', step='3600s', solver='dassl', nls='homotopy')
		self.data = D('TestLinprog_res.mat')

	def test_linprog(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		self.DE = self.data.data("optimalDispatch")
		self.sumEnergy = 0
		for i in range(len(self.DE)):
			self.sumEnergy += self.DE[i]

		self.assertAlmostEqual(self.sumEnergy, 3060, 2) 

		print("Total dispatched energy in 24 hours is %s [MWh]"%(self.sumEnergy))

		files_in_directory = os.listdir(".")
		filtered_files = [file for file in files_in_directory if file.endswith((".mat",".o",".c",".h",".xml",".json","makefile"))]
		for file in filtered_files:
			if file[0:11]=="TestLinprog":
				os.remove(file)
		os.remove("TestLinprog")




if __name__ == '__main__':
	unittest.main()
