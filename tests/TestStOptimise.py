#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
import DyMat
import os
from math import pi
import re

class TestStOptimise(unittest.TestCase):
	'''
	// Use Rosenbrock function to test st_optimise
	// ref: https://en.wikipedia.org/wiki/Rosenbrock_function
	// also DAKOTA users-6.10.0, page 32 
	// the unique optimal point is (x, y)=(1, 1), where f=0
	'''	

	def setUp(self):
		# single-objective optimisation
		fn = 'TestStOptimise.mo'
		self.outfile='TestStOptimise_results.txt'
		os.system('st_optimise --outfile_f %s --start 0 --stop 1 --objective f --method ga2 --maxiter 100 %s x=-2,2,1 y=-2,2,-1.5'%(self.outfile, fn))
	

	def test_simple_system(self):
	
		with open(self.outfile) as f:
			content= f.read().splitlines()
		f.close()
		params=re.findall("[-+]?[.]?[\d]+(?:,\d\d\d)*[\.]?\d*(?:[eE][-+]?\d+)?", content[0])
		objs=re.findall("[-+]?[.]?[\d]+(?:,\d\d\d)*[\.]?\d*(?:[eE][-+]?\d+)?", content[1])
		obj=float(objs[0])
		x=float(params[0])
		y=float(params[1])

		#print ''
		#print obj, x, y
		self.assertTrue(abs(obj)  < 1)
		self.assertTrue(abs(x-1.) < 1)
		self.assertTrue(abs(y-1.) < 1)



if __name__ == '__main__':
	unittest.main()





