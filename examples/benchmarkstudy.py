#! /bin/env python2

import unittest
import os
import numpy as np

from solartherm import simulation
from solartherm import postproc
import DyMat
import numpy as np

def get_result(A_helio_total, A_rcv, fb, R1, ab_particle, t_storage, pinch):
	os.system('st_simulate --stop 1y --maxStep 300s --step 3600s --np=0 PhysicalParticleCO21D_2ndApproach.mo n_row_oelt=9 n_col_oelt=25 A_helio_total=%f A_rcv=%f fb=%f R1=%f ab_particle=%f t_storage=%f pinch=%f'%(A_helio_total,A_rcv,fb,R1,ab_particle,t_storage,pinch))
	resmat = "PhysicalParticleCO21D_2ndApproach_res_0.mat"
	data = DyMat.DyMatFile(resmat)
	UA_HX = data.data("powerBlock.exchanger.UA_HX")[-1] / 1000
	C_heliostat = data.data("C_field")[-1]
	C_rcv = data.data("C_receiver")[-1]
	C_HX = data.data("powerBlock.C_exchanger")[-1]
	C_cycle = data.data("C_block")[-1] - C_HX
	C_storage = data.data("C_storage")[-1]
	C_equipment = data.data("C_cap_total")[-1]
	C_total = data.data("C_cap")[-1]
	EPY = data.data("E_elec")[-1]/1000 #in kJ
	resultclass = postproc.SimResultElec
	res_object = resultclass(resmat) #passing the resmatfile into resultclass (postproc.SimResultElec)
	result = res_object.calc_perf()
	LCOE = float('%.2f'%(result[1]))/1000
	return [fb,R1,UA_HX,C_heliostat,C_rcv,C_HX,C_cycle,C_storage,C_equipment,C_total,EPY,LCOE]

set_params= [[1450000,1208,0.9,18,15],[1200000,2000,0.9,18,15],[1450000,1208,0.9,6,15],[1450000,1208,0.5,18,15],[1450000,1208,0.9,18,50]]
fb_set=[0.7,0.8,0.6,0.7,0.7]
R1_set=[160,130,160,160,160]
for i in range(5):
	fb=round(fb_set[i],1)
	R1=R1_set[i]
	A_helio_total = set_params[i][0]
	A_rcv = set_params[i][1]
	ab_particle = set_params[i][2]
	t_storage = set_params[i][3]
	pinch = set_params[i][4]
	print('Start Simulating Case %s'%(i+1))
	os.system('cp /home/philgun/result-optimal/benchmark/param%s_fb%s_R1%s/OELT_Solstice.motab /home/philgun/solartherm-particle/examples/' %(i+1,round(fb,1),R1))
	r = get_result(A_helio_total, A_rcv, fb, R1, ab_particle, t_storage, pinch)
	#os.system('mkdir /home/philgun/solartherm-particle/examples/case%s'%(i+1))
	#os.system('mv *.csv /home/philgun/solartherm-particle/examples/case%s'%(i+1))
	os.system('cp /home/philgun/solartherm-particle/examples/PhysicalParticleCO21D_2ndApproach_res_0.mat /home/philgun/result-optimal/benchmark/param%s_fb%s_R1%s/'%(i+1,fb,R1))
	os.system('rm -rf OELT_Solstice.motab *.c *.o *.h *.json *.xml *.makefile *.cmake *.bakmo *.log *.mat *.csv')
	print('Finish')
print("Finished all cases")		
