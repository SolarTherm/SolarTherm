#! /bin/env python2
# -*- coding: utf-8 -*-
from __future__ import division
import unittest
from solartherm import simulation, postproc
import os.path
import DyMat
import numpy as np
from solartherm import postproc


#>>> data = DyMat.DyMatFile('abc_res.mat')
#>>> names = data.names()
#>>> for n in names:	    #####################			
#...     if 'optical' in n: ##################### This is for inspecting keys inside the data
#...             print (n)  #####################
#print(result)
#print type(result)
#print np.shape(result)
#print (resmatfile)

PLOTME=0
RUNSIM=1
VERBOSE=0


class FunctionTestPhysicalParticleCO21D(unittest.TestCase):
	def test1(self):
		global VERBOSE, RUNSIM, PLOTME
		file_name = 'PhysicalParticleCO21D'
		#file_name = 'PhysicalParticleSystem1D'
		fn = ('%s.mo'%(file_name,))
		print "Modelica File Name = " + fn
		sim = simulation.Simulator(fn)
		resfn = sim.model + '_res.mat'
		print "Modelica File Result Name = " + resfn

		if VERBOSE: print "RUNNING SETUP"


		if RUNSIM ==1:
			if VERBOSE: print "COMPILING MODEL"
			sim.compile_model(args=['-d=bltdump'])
			if VERBOSE: print "COMPILING SIM"
			sim.compile_sim(args=['-s'])
			if VERBOSE: print "SOLVING MODEL"
			reporting_interval = 1800
			step_string = '%fs'%(reporting_interval)
			stop_time  = 365*24*3600
			stop_string = '%fs'%(stop_time)
			sim.simulate(start=0, stop=stop_string, step=step_string, maxStep= '300s'
				,solver='dassl',nls=None
				#,lv='LOG_DEBUG,LOG_NLS,LOG_SOLVER'#,LOG_NLS_V'
			)
		
		self.res = postproc.SimResult(resfn)		
		
		resmatfile = '/home/philgun/solartherm/examples/%s' %(resfn) #getting the res_mat file
		data = DyMat.DyMatFile(resmatfile) #getting the value inside the resmat file
		data2 = DyMat.DyMatFile('/home/philgun/solartherm/examples/%s'%('PhysicalParticleCO21D_res.mat'))
				
		if file_name == 'PhysicalParticleSystem0D':
			rcv = 'receiver.'
		elif file_name == 'PhysicalParticleCO21D_v11':
			rcv = 'particleReceiver1D_v11.'	
		else:
			rcv = 'particleReceiver1D.'
		pb = 'powerBlock.'

		if file_name == 'PhysicalParticleSystem1D' or file_name =='PhysicalParticleCO21D':
			N = data.data(rcv + 'N')[1] #getval(rcv + 'N') # getval('%s.N' %(rcv,))
			print 'Particle Receiver Discretization = %f cells' %(N)



		if VERBOSE:
			print ("SYSTEM'S RESULTS %s"%(file_name))
			print ""
			
			name_var = 'A_field'
			var = data.data(name_var)
			print 'Heliostat Field Area (m.sq) = %f'%(var[1])

			name_var = 'E_elec'
			var = data.data(name_var) #getval (name_var)   #('%s.%s' %(sys,name_var))
			print 'Energy Per Year (MWh/year) = %f'%(var[-1]*2.778e-10)

			name_var = 'E_total_loses_optical'
			var = data.data('heliostatsField.E_total_loses_optical')[-1] #getval (name_var)   #('%s.%s' %(sys,name_var))
			print 'Energy losses due to optical (MWh/year) = %f'%(var*2.778e-10)
			
			name_var = 'H_tower'
			var = data.data(name_var)
			print 'Tower height (m) = %f'%(var[1])

			print ""

			print "Receiver's Geometry"

			name_var = 'A_rcv'
			var = data.data(name_var)
			print 'Total receiver area (m.sq) = %f'%(var[1])

			name_var = 'H_rcv'
			var = data.data(name_var)
			print 'Receiver height (m) = %f'%(var[1])

			name_var = 'A_rcv'
			var = data.data(name_var)
			print 'Receiver aperture area (m.sq) = %f'%(var[1])
			print ""
			
			print "PLANT'S ANALYTICS" #two type curtailments 1 shutdown the heliostat 2 defocusing
			print""
			print "Energy Analytics"
			name_var = 'E_resource'
			var = data.data(name_var)
			print "Annual Sun's Energy coming to the heliostat field before cosine loses and curtailment  (MWh/year) = %f"%(var[-1]*2.778e-10)

			name_var = 'E_helio_incident'
			var = data.data(name_var)[-1]
			print "Annual energy incident of the heliostat field after curtailment due to low DNI / high windspeed  (MWh/year) = %f"%(var*2.778e-10)

			name_var = 'E_helio_raw'
			var = data.data(name_var)[-1]
			print "Annual energy delivered by the heliostat field before defocusing curtailment (MWh/year) = %f"%(var*2.778e-10)

			name_var = 'E_helio_net'
			var = data.data(name_var)[-1]
			print "Annual energy delivered by the heliostat to the receiver after every curtailments (MWh/year) = %f"%(var*2.778e-10)

			name_var = 'E_recv_incident'
			var = data.data(name_var)[-1]
			print "Annual energy delivered to the receiver by heliostat (MWh/year) = %f"%(var*2.778e-10)

			name_var = 'E_recv_net'
			var = data.data(name_var)[-1]
			print "Annual energy absorbed by the working fluid in the receiver (MWh/year) = %f"%(var*2.778e-10)

			name_var = 'E_pb_input'
			var = data.data(name_var)[-1]
			print "Annual energy delivered to the power block  (MWh/year) = %f"%(var*2.778e-10)

			name_var = 'E_pb_gross'
			var = data.data(name_var)[-1]
			print "Annual energy produced by the turbine's shaft  (MWh/year) = %f"%(var*2.778e-10)

			name_var = 'E_pb_net'
			var = data.data(name_var)[-1]
			print "Annual net energy produced by the system (MWh/year) = %f"%(var*2.778e-10)
			print '#################################################################################################################'
			print""
			print "Efficiency Analytics"

			name_var = 'eta_curtail_off'
			var = data.data(name_var)[-1]
			print "Annual Efficiency of the heliostat due to low DNI/high windspeed curtailment = %f"%(var)	

			name_var = 'eta_optical'
			var = data.data(name_var)[-1]
			print "Annual Efficiency of the heliostat due to field efficiency = %f"%(var)

			name_var = 'he_av_design'
			var = data.data(name_var)[1]
			print "Annual Efficiency of the heliostat due availability = %f"%(var)	

			name_var = 'eta_curtail_defocus'
			var = data.data(name_var)[-1]
			print "Annual Efficiency of the heliostat due to defocus curtailment = %f"%(var)
			
			if resfn == 'PhysicalParticleCO21D_res.mat' or resfn == 'PhysicalParticleSystem1D._res.mat':
				print "Annual Efficiency of the receiver due to absorption = %s"%('N/A')
			else:
				name_var = 'eta_recv_abs'
				var = data.data(name_var)[-1]
				print "Annual Efficiency of the receiver due to absorption = %s"%('N/A')

			name_var = 'eta_recv_thermal'
			var = data.data(name_var)[-1]
			print "Annual Efficiency of the receiver due to heat losses and physics phenomena in the receiver = %f"%(var)

			name_var = 'eta_storage'
			var = data.data(name_var)[-1]
			print "Annual Efficiency of the storage due to losses in the storage system = %f"%(var)		

			name_var = 'eta_pb_gross'
			var = data.data(name_var)[-1]
			print "Annual Efficiency of the power block (ratio between power gross power block / heat input to the heat exchanger) = %f"%(var)

			name_var = 'eta_pb_net'
			var = data.data(name_var)[-1]
			print "Annual Efficiency of the power block (ratio between net power produced by power block sub system / power produced by turbine shaft)  = %f"%(var)	

			name_var = 'eta_solartoelec'
			var = data.data(name_var)[-1]
			print "Annual Efficiency of system (solar energy / generated electrical energy) = %f"%(var)
			
			print '#################################################################################################################'
			print "TOTAL PLANT'S COST (million AUD) = %f "%(data.data('C_cap')[1] / 1e6)
			print "TOTAL EQUIPMENTS COST (million AUD) = %f "%(data.data('C_cap_total')[1] / 1e6)
			print "Contingency, indirect and construction cost constants = %f"%((data.data('r_contg')[1]+1) * (data.data('r_indirect')[1]+1) * (data.data('r_cons')[1]+1))
			print ""
			print "Annual OnM (million AUD) = %f "%(data.data('C_year')[1] / 1e6)
	
			print '#################################################################################################################'
			print ""
			
			print "Site's, land and heliostat field's cost (million AUD) = %f"%((data.data('C_field')[1]+data.data('C_site')[1]+data.data('C_land')[1])/1e6)

			name_var = 'C_field'
			var =  data.data(name_var)[1]
			print 'Capital cost of the solar field (million AUD) = %f'%((var)/1e6)

			name_var = 'C_site'
			var =  data.data(name_var)[1]
			print 'Capital cost of site improvement work (million AUD) = %f'%((var)/1e6)

			name_var = 'C_land'
			var =  data.data(name_var)[1]
			print 'Capital cost of land (million AUD) = %f'%((var)/1e6)

			print '#################################################################################################################'
			print ""
			
			print "Falling particle receiver sub-system cost (million AUD)= %f"%((data.data('C_receiver')[1])/1e6)

			name_var = 'C_tower'
			var = data.data(name_var)[1]
			print 'Capital cost of the tower (million AUD) = %f'%((var)/1e6)

			name_var = 'C_fpr'
			var =data.data(name_var)[1]
			print 'Capital cost of the falling particle receiver (million AUD) = %f'%((var)/1e6)

			name_var = 'C_lift_rec'
			var = data.data(name_var)[1]
			print 'Capital cost of the receiver lift (million AUD) = %f'%((var)/1e6)

			print '#################################################################################################################'
			print ""

			print 'Storage Tank / Bin costs (million AUD)= %f'%((data.data('C_storage')[1])/1e6)

			name_var = 'C_bins'
			var = data.data(name_var)[1]
			print 'Total capital cost hot and cold storage bins (million AUD) = %f'%((var)/1e6)

			name_var = 'C_particles'
			var = data.data(name_var)[1]
			print 'Total capital cost of the particles (million AUD) = %f'%((var)/1e6)

			name_var = 'C_lift_hx'
			var = data.data(name_var)[1]
			print 'Capital cost of the heat exchanger lift (power block) (million AUD) = %f'%((var)/1e6)

			name_var = 'C_lift_cold'
			var = data.data(name_var)[1]
			print 'Capital cost of the cold storage lift (million AUD) = %f'%((var)/1e6)

			print '#################################################################################################################'
						
			if fn == 'PhysicalParticleSystem1D.mo' or fn =='PhysicalParticleSystem0D.mo':
				
				print 'Power Block sub-system cost (million AUD)= %f'%((data.data('C_pb')[1])/1e6)	
			
			else:

				print 'Power Block sub-system cost (million AUD)= %f'%((data.data('C_block')[1])/1e6)		

				name_var = 'C_LTR'
				var = data.data(pb + name_var)[1]
				print 'Capital cost of the low temperature recuperator (million AUD) = %f'%((var)/1e6)

				name_var = 'C_HTR'
				var = data.data(pb + name_var)[1]
				print 'Capital cost of the high temperature recuperator (million AUD) = %f'%((var)/1e6)

				name_var = 'C_cooler'
				var = data.data(pb + name_var)[1]
				print 'Capital cost of the air-cooler CO2 (million AUD) = %f'%(var/1e6)

				name_var = 'C_exchanger'
				var = data.data(pb + name_var)[1]
				print 'Capital cost of the main heat exchager (between CO2 and Particle) (million AUD) = %f'%((var)/1e6)

				name_var = 'C_generator'
				var = data.data(pb + name_var)[1]
				print 'Capital cost of the generator (million AUD) = %f'%((var)/1e6)	

				name_var = 'C_mainCompressor'
				var = data.data(pb + name_var)[1]
				print 'Capital cost of the main compressor (million AUD) = %f'%((var)/1e6)

				name_var = 'C_reCompressor'
				var = data.data(pb + name_var)[1]
				print 'Capital cost of the recompressor (million AUD) = %f'%((var)/1e6)

				name_var = 'C_turbine'
				var = data.data(pb + name_var)[1]
				print 'Capital cost of the turbine (million AUD) = %f'%((var)/1e6)
			print '#################################################################################################################'
			print ""
		resultclass = postproc.SimResultElec #calling the class of SimResultElec in postproc.py
		res = resultclass(resfn) #passing the resmatfile into resultclass (postproc.SimResultElec)
		result = res.calc_perf() #calculating result by calling calc_perf function inside the resultclass class

		print '#################################################################################################################'
		print "Energy Per Year(MWh/year) = %f, LCOE(USD/MWh) = %f, Capacity Factor(%%)= %f, Spot Market Revenue(million USD/year) = %f"%(result[0],result[1],result[2],result[3]/1e6) #printing the postproc result	
			
			#vl = ['N','T_s[1]','T_s[%d]'%(N+1,), 'mdot', 'q_solar','A_ap'
			#	,'eta_rec','eps_c[%d]'%(N,)
			#	,'H_drop','W_rcv','t_c_in']
			#for v in vl:
			#	print '%s = %f' %(v,getval('revOneDPGv2LookUpTable.%s'%(v,)))
			#for v in ['Qdot_rec','Qdot_inc']:
			#	print '%s = %f MW' %(v,getval('revOneDPGv2LookUpTable.%s'%(v,))/1e6)
			#for T in ['T_in','T_out']:
			#	#print '%s = %f°C'%(T,getval('revOneDPGv2LookUpTable.%s'%(T,))-273.15)
			#print 'T_in = %f°C'%(getval('revOneDPGv2LookUpTable.T_s[1]')-273.15)
			#print 'T_out= %f°C'%(getval('revOneDPGv2LookUpTable.T_s[%d]'%(N+1,))-273.15)

		if PLOTME:
			import matplotlib; matplotlib.use('GTKCairo')
			import matplotlib.pyplot as pl
			#nr = 1; nc = 1; sp=0 #nr = number of row , nc = nuber of column, sp = space between plot
			time = data.abscissa(rcv + 'eta_rec', valuesOnly=True)
			eta_rec_v11 = data.data (rcv + 'eta_rec')
			eta_rec_v9 = data2.data('particleReceiver1D.' + 'eta_rec')
			Qdot_rec_v11 = data.data (rcv + 'Qdot_rec')*100
			Qdot_rec_v9 = data2.data ('particleReceiver1D.' + 'Qdot_rec')*100
			#print type(y)
			#print np.shape(y)
			#print type(time)
			#print np.shape(time)
			#print '**********************************'
			#print ''
		
			fig = pl.figure()
			#sp+=1; ax1 = pl.subplot(nr,nc,sp) 
			pl.xlim(170*24*3600,173*24*3600)
			pl.plot(time,eta_rec_v11,label = 'v_11')
			pl.plot(time,eta_rec_v9, label = 'v_09')
			pl.legend(fontsize =20)
			pl.ylabel('Efficiency of the receiver', fontsize = 40)
			pl.xlabel('Time', fontsize = 40)
			pl.title('Receiver efficiency at day 170 to 172', fontsize = 40)
			pl.show()

			pl.xlim(170*24*3600,173*24*3600)
			pl.plot(time,Qdot_rec_v11,label = 'v_11')
			pl.plot(time,Qdot_rec_v9, label = 'v_09')
			pl.legend(fontsize =20)
			pl.ylabel('Energy (MW)', fontsize = 40)
			pl.xlabel('Time', fontsize = 40)
			pl.title('Energy absorbed by particle at day 170 to 172', fontsize = 40)
			pl.show()

			#time = data.abscissa(rcv + 'T_s[%d]'%(1), valuesOnly=True)
			#y = data.data (rcv + 'T_s[%d]'%(1))	
			#fig = pl.figure()
			#pl.plot(time,y,markerfacecolor=None)
			#pl.ylabel('Inlet Temperature Particle Receiver [K]')
			#pl.xlabel('Time')
			#pl.title('Inlet Temperature Particle Receiver vs Time')
			#pl.xlim(0,3.1536e7)
			#pl.show()

			#time = data.abscissa(rcv + 'fluid_a.m_flow', valuesOnly=True)
			#y = data.data (rcv + 'fluid_a.m_flow')	
			#fig = pl.figure()
			#pl.plot(time,y,markerfacecolor=None)
			#pl.ylabel('Inlet Mass Flow (kg/s)')
			#pl.xlabel('Time')
			#pl.title('Inlet Temperature Particle Receiver vs Time')
			#pl.xlim(0,3.1536e7)
			#pl.show()

			#pl.savefig(open('/home/philgun/Desktop/ParticleReceiver1DVariablesTestRun.png','w'))

	
if __name__ == '__main__':
	PLOTME=1
	VERBOSE=1
	RUNSIM=0
	unittest.main()
