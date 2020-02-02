#! /bin/env python2
# -*- coding: utf-8 -*-
from __future__ import division
import unittest
from solartherm import simulation, postproc
import os.path

PLOTME=0
RUNSIM=1
VERBOSE=0

class TestParticleReceiver1D_2_original_code(unittest.TestCase):
	def test1(self):
		global VERBOSE, RUNSIM, PLOTME
		fn = 'TestParticleReceiver1D_2_original_code.mo'
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
		
		receiver = 'particleReceiver1D'
		N = getval('%s.N'%(receiver))
		if VERBOSE:
			print "RESULTS"
			vl = ['N','T_s[1]','T_s[%d]'%(N+1,), 'mdot', 'q_solar','A_ap'
				,'eta_rec','eps_c[%d]'%(N,)
				,'H_drop','W_rcv','t_c_in']
			for v in vl:
				print '%s = %f' %(v,getval('%s.%s'%(receiver,v)))
			for v in ['Qdot_rec','Qdot_inc']:
				print '%s = %f MW' %(v,getval('%s.%s'%(receiver,v))/1e6)
			#for T in ['T_in','T_out']:
				#print '%s = %f°C'%(T,getval('revOneDPGv2LookUpTable.%s'%(T,))-273.15)
			print 'T_in = %f°C'%(getval('%s.T_s[1]'%(receiver))-273.15)
			print 'T_out= %f°C'%(getval('%s.T_s[%d]'%(receiver,N+1))-273.15)

		if PLOTME:
			import matplotlib; matplotlib.use('GTKCairo')
			import matplotlib.pyplot as pl
			nr = 1; nc = 7; sp=0
			dx = getval('%s.dx'%(receiver))
			#x = [dx*(i+1) for i in range(N)]
			x = [getval('%s.x[%d]'%(receiver,i+1)) for i in range(N+2)]
			x1 = x[1:int(N+1)]

			fig = pl.figure()
			sp+=1; ax1 = pl.subplot(nr,nc,sp)
			for vn in ['vp']:
				val = [getval('%s.%s[%d]'%(receiver, vn,i+1)) for i in range(N+1)]
				pl.plot(val,x[:-1],label=vn,marker='o',markerfacecolor=None)
			pl.legend()
			pl.ylabel('Vertical position / [m]')
			pl.xlabel('Velocity / [m/s]')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			for vn in ['t_c']:
				val = [getval('%s.%s[%d]'%(receiver,vn,i+1))*100 for i in range(N+1)]
				pl.plot(val,x[:-1],label=vn,marker='o',markerfacecolor=None)
			pl.legend()
			pl.xlim(0,max(val))
			pl.xlabel('Thickness / [cm]')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			Qdot_new_c = [getval('%s.q_net[%d]'%(receiver,i+1))/1000. for i in range(N)]
			pl.xlabel('$\dot{Q}_\mathrm{net,c}$ / [kW/m2]')
			pl.plot(Qdot_new_c,x1,'ro-',label='backwall')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			for vn in ['phi']:
				val = [getval('%s.%s[%d]'%(receiver,vn,i+1)) for i in range(N+1)]
				pl.plot(val,x[:-1],label=vn,marker='o',markerfacecolor=None)
			pl.legend()
			pl.xlim(0,0.03)
			pl.xlabel('Fraction / [1]')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			for vn in ['eps_c','abs_c','tau_c']:
				Qdotdd = [getval('%s.%s[%d]'%(receiver,vn,i+1)) for i in range(N)]
				pl.plot(Qdotdd,x1,label=vn,marker='o',fillstyle='none')
			pl.legend()
			pl.xlim(0,1)
			pl.xlabel('Fraction / [1]')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			for vn in ['gc_b','g_w','jc_f','jc_b','j_w']:
				Qdotdd = [getval('%s.%s[%d]'%(receiver,vn,i+1))/1000. for i in range(N)]
				pl.plot(Qdotdd,x1,label=vn,marker='o')
			pl.legend()
			pl.xlabel('Heat flux / [kW/m2]')

			sp+=1; pl.subplot(nr,nc,sp,sharey=ax1)
			T_s = [getval('%s.T_s[%d]'%(receiver,i+1))-273.15 for i in range(N+1)]
			pl.plot(T_s,x[:-1],'ko-',label='particle')
			T_w = [getval('%s.T_w[%d]'%(receiver,i+1))-273.15 for i in range(N+2)]
			
			pl.ylim(max(x),0)
			pl.plot(T_w,x,'ro-',label='backwall')
			pl.xlabel('Temperature / [°C]')
			pl.legend()

			pl.show()
			#pl.savefig(open('/home/philgun/Desktop/ParticleReceiver1DVariablesTestRun.png','w'))

		self.assertAlmostEqual(getval('particleReceiver1D.q_solar'),1200*788.8,delta=1.)
		self.assertAlmostEqual(getval('particleReceiver1D.A_ap'),593.7,delta=30)
		self.assertAlmostEqual(getval('particleReceiver1D.T_s[1]'),580.3+273.15,delta=2)
		#self.assertAlmostEqual(getval('revOneDPGv2LookUpTable.mdot'),1827,delta=100)
		self.assertAlmostEqual(getval('particleReceiver1D.T_s[%d]'%(N+1,)),800+273.15,delta=1)
		self.assertAlmostEqual(getval('particleReceiver1D.Qdot_rec'),497690e3,delta=1e6)
		self.assertAlmostEqual(getval('particleReceiver1D.eta_rec'),0.8568,delta=0.001)

if __name__ == '__main__':
	PLOTME=1
	VERBOSE=1
	#RUNSIM='if-needed'
	unittest.main()
