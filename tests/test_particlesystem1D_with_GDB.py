#! /bin/env python

from __future__ import division
import unittest

#import cleantest
from solartherm import simulation
from solartherm import postproc

import os
import shutil
import cleantest
import subprocess as sp
from DyMat import DyMatFile as D
#@pytest.mark.skip(reason="Broken?")

class TestParticleSystem1DSurrogate(unittest.TestCase):
	def setUp(self):
		fn = '../examples/PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate.mo'
		shutil.copy(fn,".")
		
		sp.call("ST_DEBUG=1 st simulate --nosim PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate.mo SM=0.5",shell=True)
		
		sp.call('gdb -ex run ./PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate', shell=True)

		self.status = 0

		data = D("PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate_res_0.mat")
		
		abscissa = data.abscissa("R_spot",valuesOnly=True)
		t_end = abscissa[-1]
		print("The simulation reach time: %s seconds\n"%(t_end))

		if abs(t_end - 604800.0) > 1:
			self.status = 1

		else:
			self.status = 0		

	def test_particle_system_1D_surrogate_with_GDB(self):
		#Start comparing the perf with pre-run numbers
		assert(self.status==0)
		cleantest.clean('PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate')
		try:
			os.remove("PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate_res_0.mat")
			os.remove("PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate.mo")
		except:
			pass

if __name__ == '__main__':
	unittest.main()
	
	
	
	
	


