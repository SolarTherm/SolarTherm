#! /bin/env python

from __future__ import division
import unittest

import cleantest
from solartherm import simulation
from solartherm import postproc

import os

class TestSimpleSystem(unittest.TestCase):
	def setUp(self):
		fn = '../examples/Small_Scale_Dish_system.mo'
		self.sim = simulation.Simulator(fn)
		self.sim.compile_model()
		self.sim.compile_sim(args=['-s'])



	def test_31p5kWe_system(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		self.sim.simulate(start=0, stop='1y', step='900s', solver='dassl', nls='homotopy')
		res = postproc.SimResultElec(self.sim.res_fn)
		perf = res.calc_perf()
		print('index, epy (MWh/year),lcoe peaker ($/MWh),capf (%),srev ($')
		print(perf);
		self.assertTrue(abs(perf[1]- 241.19)/241.19<0.0005) # LCOE
		self.assertTrue(abs(perf[2]- 85.22)/85.22<0.0005) # Capacity factor
		cleantest.clean('Small_Scale_Dish_system')

	@unittest.skip("need to solve TODO")
	#TODO need to change the Cycle to the corresponding scale
	# in the system model
	def test_100kWe_system(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		par_n=['P_name']
		par_v=['100e3']
		self.sim.update_pars(par_n, par_v)
		self.sim.simulate(start=0, stop='1y', step='900s', solver='dassl', nls='homotopy')
		res = postproc.SimResultElec(self.sim.res_fn)
		perf = res.calc_perf()
		print('index, epy (MWh/year),lcoe peaker ($/MWh),capf (%),srev ($')
		print(perf);
		self.assertTrue(abs(perf[1]- 209.78)/209.78<0.0005) # LCOE
		self.assertTrue(abs(perf[2]- 85.59)/85.59<0.0005) # Capacity factor

	@unittest.skip("need to solve TODO")
	def test_200kWe_system(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		par_n=['P_name']
		par_v=['200e3']
		self.sim.update_pars(par_n, par_v)
		self.sim.simulate(start=0, stop='1y', step='900s', solver='dassl', nls='homotopy')
		res = postproc.SimResultElec(self.sim.res_fn)
		perf = res.calc_perf()
		print('index, epy (MWh/year),lcoe peaker ($/MWh),capf (%),srev ($')
		print(perf);
		self.assertTrue(abs(perf[1]- 195.27)/195.27<0.0005) # LCOE
		self.assertTrue(abs(perf[2]- 85.61)/85.61<0.0005) # Capacity factor

	@unittest.skip("need to solve TODO")
	def test_300kWe_system(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		par_n=['P_name']
		par_v=['300e3']
		self.sim.update_pars(par_n, par_v)
		self.sim.simulate(start=0, stop='1y', step='900s', solver='dassl', nls='homotopy')
		res = postproc.SimResultElec(self.sim.res_fn)
		perf = res.calc_perf()
		print('index, epy (MWh/year),lcoe peaker ($/MWh),capf (%),srev ($')
		print(perf);
		self.assertTrue(abs(perf[1]- 187.78)/187.78<0.0005) # LCOE
		self.assertTrue(abs(perf[2]- 86.91)/86.91<0.0005) # Capacity factor

	@unittest.skip("need to solve TODO")
	def test_400kWe_system(self):
		# Note these are set to the values for what is thought to be a working
		# version.  They are not validated against anything or independently
		# calculated.
		par_n=['P_name']
		par_v=['400e3']
		self.sim.update_pars(par_n, par_v)
		self.sim.simulate(start=0, stop='1y', step='900s', solver='dassl', nls='homotopy')
		res = postproc.SimResultElec(self.sim.res_fn)
		perf = res.calc_perf()
		print('index, epy (MWh/year),lcoe peaker ($/MWh),capf (%),srev ($')
		print(perf);
		self.assertTrue(abs(perf[1]- 183.16)/183.16<0.0005) # LCOE
		self.assertTrue(abs(perf[2]- 86.94)/86.94<0.0005) # Capacity factor
	




if __name__ == '__main__':
	unittest.main()

# vim: ts=4:sw=4:noet:tw=80
