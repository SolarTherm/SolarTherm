#! /bin/env python2
# -*- coding: utf-8 -*-
from __future__ import division
import unittest
from solartherm import simulation, postproc
import os.path

PLOTME=0
RUNSIM=1
VERBOSE=0

class TestParameterGames(unittest.TestCase):
	def test1(self):
		fn = 'ParameterGames.mo'
		global VERBOSE, RUNSIM, PLOTME
		if VERBOSE: print "RUNNING SETUP"
		sim = simulation.Simulator(fn)
		resfn = sim.model + '_res.mat'
		if RUNSIM=='if-needed':
			RUNSIM = not os.path.exists(resfn) or (os.path.getctime(resfn) < os.path.getctime(fn))
			print "RUNSIM = %s ('if-needed' test)"%(RUNSIM,)
		if RUNSIM:
			if VERBOSE: print "COMPILING MODEL"
			sim.compile_model(args=['-d=initialization'])#args=['-d=bltdump'])
			if VERBOSE: print "COMPILING SIM"
			sim.compile_sim(args=['-s'])
			if VERBOSE: print "SOLVING MODEL"
			sim.simulate(start=0, stop='7.2d', step='1h'
				,solver='dassl',nls=None
				#,lv='LOG_DEBUG,LOG_NLS,LOG_SOLVER'#,LOG_NLS_V'
			)
		self.res = postproc.SimResult(resfn)

		def gettmax(n):
			return self.res.get_time(n)[-1]
		def getval(n):
			return self.res.interpolate(str(n),gettmax(n))

		if VERBOSE:
			#print "RESULTS"
			vl = self.res.get_names()
			#print vl
			for v in vl:
				#print "looking for '%s'"%(v,)
				print '%s = %f' %(v,getval(v))

			print "\nt_end = %f d" %(simulation.convert_val(gettmax('E'),'s','d'));
			print "E = %f GWh" %(simulation.convert_val(getval('E'),'J','GWh'))
			print "Qnet = %f MW" % (simulation.convert_val(getval('R1.Qnet'),'W','MW'));
if __name__ == '__main__':
	PLOTME=1
	VERBOSE=1
	RUNSIM='if-needed'
	unittest.main()
