#! /bin/env python2
# -*- coding: utf-8 -*-
from __future__ import division
import unittest
from solartherm import simulation, postproc
import os.path

PLOTME=0
RUNSIM=1
VERBOSE=0

class TestParticleReceiver1DStandalone(unittest.TestCase):
	def test1(self):
		global VERBOSE, RUNSIM, PLOTME
		fn = 'ParticleReceiver1D_standalone.mo'
		if VERBOSE: print "RUNNING SETUP"
		sim = simulation.Simulator(fn)
		resfn = sim.model + '_res.mat'
		if RUNSIM=='if-needed':
			RUNSIM = (not os.path.exists(resfn)) or os.path.getctime(resfn) < os.path.getctime(fn)
			print "RUNSIM = %s ('if-needed' test)"%(RUNSIM,)
		if RUNSIM:
			if VERBOSE: print "COMPILING MODEL"
			sim.compile_model(args=['-d=bltdump'])
			if VERBOSE: print "COMPILING SIM"
			sim.compile_sim(args=['-s'])
			if VERBOSE: print "SOLVING MODEL"
			sim.simulate(start=0, stop='1s', step='1s'
				,solver='dassl',nls=None
				#,lv='LOG_DEBUG,LOG_NLS,LOG_SOLVER'#,LOG_NLS_V'
			)
		self.res = postproc.SimResult(resfn)


		def getval(n):
			return self.res.interpolate(n,1)

		N = getval('N')
		if VERBOSE:
			print "RESULTS"
			vl = ['N','T_s__[1]','T_s__[%d]'%(N+1,), 'mdot', 'q_solar','A_ap'
				,'eta_rec','eps_c[%d]'%(N,),'mdot_check','Qdot_check'
				,'H_drop','w_c','t_c_in']
			for v in vl:
				print '%s = %f' %(v,getval(v))
			for v in ['Qdot_rec','Qdot_inc']:
				print '%s = %f MW'%(v,getval(v)/1e6)
			for T in ['T_in','T_out']:
				print '%s = %f°C'%(T,getval(T)-273.15)

		if PLOTME:
			import matplotlib; matplotlib.use('GTKCairo')
			import matplotlib.pyplot as pl
			nr = 1; nc = 7; sp=0
			dx = getval('dx')
			#x = [dx*(i+1) for i in range(N)]
			x = [getval('x__[%d]'%(i+1,)) for i in range(N+2)]
			x1 = x[1:int(N+1)]

			fig = pl.figure()
			sp+=1; ax1 = pl.subplot(nr,nc,sp)
			for vn in ['v_s__']:
				val = [getval('%s[%d]'%(vn,i+1)) for i in range(N+1)]
				pl.plot(val,x[:-1],label=vn,marker='o',markerfacecolor=None)
			pl.legend()
			pl.ylabel('Vertical position / [m]')
			pl.xlabel('Velocity / [m/s]')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			for vn in ['t_c__']:
				val = [getval('%s[%d]'%(vn,i+1))*100 for i in range(N+1)]
				pl.plot(val,x[:-1],label=vn,marker='o',markerfacecolor=None)
			pl.legend()
			pl.xlim(0,max(val))
			pl.xlabel('Thickness / [cm]')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			Qdot_new_c = [getval('q_net_c[%d]'%(i+1))/1000. for i in range(N)]
			pl.xlabel('$\dot{Q}_\mathrm{net,c}$ / [kW/m2]')
			pl.plot(Qdot_new_c,x1,'ro-',label='backwall')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			for vn in ['phi_s__']:
				val = [getval('%s[%d]'%(vn,i+1)) for i in range(N+1)]
				pl.plot(val,x[:-1],label=vn,marker='o',markerfacecolor=None)
			pl.legend()
			pl.xlim(0,0.03)
			pl.xlabel('Fraction / [1]')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			for vn in ['eps_c','abs_c','tau_c']:
				Qdotdd = [getval('%s[%d]'%(vn,i+1)) for i in range(N)]
				pl.plot(Qdotdd,x1,label=vn,marker='o',fillstyle='none')
			pl.legend()
			pl.xlim(0,1)
			pl.xlabel('Fraction / [1]')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			for vn in ['gc_b','g_w','jc_f','jc_b','j_w']:
				Qdotdd = [getval('%s[%d]'%(vn,i+1))/1000. for i in range(N)]
				pl.plot(Qdotdd,x1,label=vn,marker='o')
			pl.legend()
			pl.xlabel('Heat flux / [kW/m2]')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			T_s = [getval('T_s__[%d]'%(i+1))-273.15 for i in range(N+1)]
			pl.plot(T_s,x[:-1],'ko-',label='particle')
			T_w = [getval('T_w__[%d]'%(i+1))-273.15 for i in range(N+2)]
			#x_w = [getval('x__[%d]'%(i+1)) for i in range(N+2)]
			pl.ylim(max(x),0)
			pl.plot(T_w,x,'ro-',label='backwall')
			pl.xlabel('Temperature / [°C]')
			pl.legend()

			pl.show()

		self.assertAlmostEqual(getval('q_solar'),1200*788.8,delta=1.)
		self.assertAlmostEqual(getval('A_ap'),593.7,delta=30)
		self.assertAlmostEqual(getval('T_in'),580.3+273.15,delta=2)
		#self.assertAlmostEqual(getval('mdot'),1827,delta=100)
		self.assertAlmostEqual(getval('T_out'),800+273.15,delta=0.5)
		self.assertAlmostEqual(getval('Qdot_rec'),497690e3,delta=1e6)
		self.assertAlmostEqual(getval('eta_rec'),0.8568,delta=0.01)

if __name__ == '__main__':
	PLOTME=1
	VERBOSE=1
	#RUNSIM='if-needed'
	unittest.main()
