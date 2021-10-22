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
		fn = './TestDomeStorageRCalc.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1', step='1', solver='dassl', nls='homotopy')
		self.data = D('TestDomeStorageRCalc_res.mat')

	def test_linprog(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		self.R_external_cylinder = self.data.data("R_external_cylinder")[-1]
		self.R_external_hemisphere = self.data.data("R_external_hemisphere")[-1]
		self.R_integrated_cylinder = self.data.data("R_integrated_cylinder")[-1]
		self.R_integrated_hemisphere = self.data.data("R_integrated_hemisphere")[-1]

		self.assertAlmostEqual(self.R_external_cylinder, 0.00425102, 4) 
		self.assertAlmostEqual(self.R_external_hemisphere, 0.169303, 4) 
		self.assertAlmostEqual(self.R_integrated_cylinder, 0.0025497, 4) 
		self.assertAlmostEqual(self.R_integrated_hemisphere, 0.125403, 4) 


		files_in_directory = os.listdir(".")
		filtered_files = [file for file in files_in_directory if file.endswith((".mat",".o",".c",".h",".xml",".json","makefile"))]
		for file in filtered_files:
			if file[0:20]=="TestDomeStorageRCalc":
				os.remove(file)
		os.remove("TestDomeStorageRCalc")


if __name__ == '__main__':
	unittest.main()
