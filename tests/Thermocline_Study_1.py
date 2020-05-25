#! /bin/env python2

import unittest
import os

from solartherm import simulation
#from solartherm import postproc
import DyMat
import numpy as np

#resultfile = open("Thermocline_1_results.txt","a")
#filepath = 'ahsdsa.mat'
#data = DyMat.DyMatFile(filepath)
#data.data('thermoclinestorage.Q_net')[-1]
#data.abscissa('thermoclinestorage.Q_net',valuesOnly=True)

def get_result(ar,dp):
	fn = 'SolarTherm/Systems/Publications/Constant_Charging.mo'
	os.system('st_simulate --stop 475200 --maxStep 300s --step 1800s ar=%f d_p=%f'%(ar,dp))
	#sim = simulation.Simulator(fn)
	#sim.compile_model()
	#sim.compile_sim(args=['-s'])
	#sim.simulate(start=0, stop=475200, step=1800)
	#resultpath = sim.model + '_res.mat'
	data = DyMat.DyMatFile(resultpath)
	eff = data.data("eff_storage")
	cost_fluid = data.abscissa("C_fluid",valuesOnly=True)
	cost_filler = data.abscissa("C_filler",valuesOnly=True)
	cost_total = cost_fluid + cost_filler
	ar_result = data.abscissa("ar",valuesOnly=True)
	d_p_result =  data.abscissa("d_p",valuesOnly=True)
	return [ar_result,d_p_result,eff,cost_fluid,cost_filler,cost_total]

for ar in np.linspace(0.5,2.0,10):
	for d_p in np.linspace(10e-3, 100e-3, 10):
		get_result(ar,d_p)


#class Thermocline_Study(unittest.TestCase):
	#def setUp(self):
		#fn = 'SolarTherm/Systems/Publications/Constant_Charging.mo'
		#sim = simulation.Simulator(fn)
		#sim.compile_model()
		#sim.compile_sim(args=['-s'])
		#sim.simulate(start=0, stop=475200, step=1800)
		#self.res = postproc.SimResult(sim.model + '_res.mat')

	#def test_table(self):
		#self.assertAlmostEqual(self.res.interpolate('linear.y[1]', 0.5), 2.5)
		#self.assertAlmostEqual(self.res.interpolate('linear.y[1]', 0.5), 2.5)
		#self.assertAlmostEqual(self.res.interpolate('linear.y[1]', 1.5), 2)
		#self.assertAlmostEqual(self.res.interpolate('linear.y[1]', 2.5), 2.5)
		#self.assertAlmostEqual(self.res.interpolate('cderiv.y[1]', 0), 3)
		#self.assertAlmostEqual(self.res.interpolate('cderiv.y[1]', 1), 2)
		#self.assertAlmostEqual(self.res.interpolate('cderiv.y[1]', 2), 2)
		#self.assertAlmostEqual(self.res.interpolate('cderiv.y[1]', 3), 3)
		#self.assertAlmostEqual(self.res.interpolate('cseg.y[1]', 0.5), 3)
		#self.assertAlmostEqual(self.res.interpolate('cseg.y[1]', 1.5), 2)
		#self.assertAlmostEqual(self.res.interpolate('cseg.y[1]', 2.5), 2)

#if __name__ == '__main__':
	#unittest.main()
