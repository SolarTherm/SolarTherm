#! /bin/env python

from __future__ import division
import unittest
import pytest

#import cleantest
from solartherm import simulation
from solartherm import postproc

import os
import shutil
import cleantest
import subprocess as sp
from DyMat import DyMatFile
@pytest.mark.skip(reason="Already tested in test_particlesystem1D_surrogate.py")

class TestParticleSystem1DSurrogate(unittest.TestCase):
	def setUp(self):
		try:
			os.remove("./OELT_Solstice.motab")
		except:
			pass
		# FIXME no need to copy the modelica file
		fn = '../examples/PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate.mo'
		
		sp.run('st_simulate --stop 604800 %s SM=1'%(fn), shell=True, check=True)
		
		sp.run(
			'gdb -ex=run -ex=quit --args ./PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate -override startTime=0.0,stopTime=604800.0,stepSize=300.0,tolerance=1e-04 -s dassl -nls homotopy -maxIntegrationOrder 5 -lv -LOG_SUCCESS,-stdout -f PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate_init_0.xml -r PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate_res_0.mat',
			shell=True, check=True)

		self.status = 0

		matfile = "PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate_res_0.mat"
		assert os.path.isfile(matfile)
		data = DyMatFile(matfile)
		
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
		try:
			cleantest.clean('PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate')
			os.remove("PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate_res_0.mat")
			os.remove("PhysicalParticleCO21D_1stApproach_SurrogateReceiver_OnTheFlySurrogate.mo")
		except:
			pass
		cleantest.clean()

if __name__ == '__main__':
	unittest.main()
	
	
	
	
	


