#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

class TestLcoePeaker(unittest.TestCase):
	def setUp(self):

		#fn = '../examples/Reference_2.mo'
		#TODO this part is currently hard coded.
		# It will be replaced by the peaker plant model (when it is ready)
		# that generates the new_LCOE_base.mat 
		
		res_fn='/media/yewang/Data/data-gen3p3-particle/study-peaker/new_LCOE_base.mat'
		res=postproc.SimResultElec(res_fn)
		self.perf = res.calc_perf(peaker=True)


	def test_lcoe_p(self):

		epy=self.perf[0]
		lcoe_p=self.perf[1]
		capf=self.perf[2]
		srev=self.perf[3]

		self.assertAlmostEqual(epy, 117148.559,3)
		self.assertAlmostEqual(lcoe_p, 85.207,3)
		self.assertAlmostEqual(capf, 66.8656,4)
		self.assertAlmostEqual(srev, 223908.262,3)


if __name__ == '__main__':
	unittest.main()

