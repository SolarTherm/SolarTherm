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
		print(perf)
		self.assertTrue(abs(perf[1]- 241.19)/241.19<0.0005) # LCOE
		self.assertTrue(abs(perf[2]- 85.22)/85.22<0.0005) # Capacity factor
		cleantest.clean('Small_Scale_Dish_system')


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
		print(perf)
		details=postproc.SimResult(self.sim.res_fn)
		C_PB_total=details.get_values('powerBlock.C_PB_total')[0]
		cycle_a1=details.get_values('powerBlock.cycle.a_1')[0]
		cycle_b1=details.get_values('powerBlock.cycle.b_1')[0]
		self.assertTrue(C_PB_total==671699.) 
		self.assertTrue(cycle_a1==-169.975) 
		self.assertTrue(cycle_b1==14.5255) 
		self.assertTrue(abs(perf[1]- 209.78)/209.78<0.0005) # LCOE
		self.assertTrue(abs(perf[2]- 86.25)/86.25<0.0005) # Capacity factor


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
		print(perf)
		details=postproc.SimResult(self.sim.res_fn)
		C_PB_total=details.get_values('powerBlock.C_PB_total')[0]
		cycle_a1=details.get_values('powerBlock.cycle.a_1')[0]
		cycle_b1=details.get_values('powerBlock.cycle.b_1')[0]
		self.assertTrue(C_PB_total==1156751.0) 
		self.assertTrue(cycle_a1==-169.991) 
		self.assertTrue(cycle_b1==14.5255) 
		self.assertTrue(abs(perf[1]- 195.57)/195.57<0.0005) # LCOE
		self.assertTrue(abs(perf[2]- 86.7)/86.7<0.0005) # Capacity factor


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
		print(perf)
		details=postproc.SimResult(self.sim.res_fn)
		C_PB_total=details.get_values('powerBlock.C_PB_total')[0]
		cycle_a1=details.get_values('powerBlock.cycle.a_1')[0]
		cycle_b1=details.get_values('powerBlock.cycle.b_1')[0]
		self.assertTrue(C_PB_total==1594470.0) 
		self.assertTrue(cycle_a1==-170.014) 
		self.assertTrue(cycle_b1==14.5213) 
		self.assertTrue(abs(perf[1]- 188.72)/188.72<0.0005) # LCOE
		self.assertTrue(abs(perf[2]- 86.83)/86.83<0.0005) # Capacity factor

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
		print(perf)
		details=postproc.SimResult(self.sim.res_fn)
		C_PB_total=details.get_values('powerBlock.C_PB_total')[0]
		cycle_a1=details.get_values('powerBlock.cycle.a_1')[0]
		cycle_b1=details.get_values('powerBlock.cycle.b_1')[0]
		self.assertTrue(C_PB_total==2004984.0 ) 
		self.assertTrue(cycle_a1==-169.969) 
		self.assertTrue(cycle_b1==14.5159) 
		self.assertTrue(abs(perf[1]- 184.17)/184.17<0.0005) # LCOE
		self.assertTrue(abs(perf[2]- 86.98)/86.98<0.0005) # Capacity factor
	




if __name__ == '__main__':
	unittest.main()

# vim: ts=4:sw=4:noet:tw=80
