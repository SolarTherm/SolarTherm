#! /bin/env python2

import unittest
import os

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
	C_rcv = data.data("C_fpr")[-1]
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

for i in range(5):
	#Iterate fb and R1 for each case
	fb_val=list() #N/A
	R1_val=list() #m
	UA_val=list() #kW/K
	C_heliostat_val = list() #USD
	C_rcv_val=list() #USD
	C_HX_val=list() #USD
	C_cycle_val=list() #USD
	C_storage_val=list() #USD
	C_equipment_val=list() #USD
	C_total_val= list() #USD
	EPY_val=list() #kJ
	LCOE_val=list() #USD/kWh
	for fb in np.arange(0.1,1.0,0.1):
		for R1 in np.arange(50, 160, 10):
			A_helio_total = set_params[i][0]
			A_rcv = set_params[i][1]
			ab_particle = set_params[i][2]
			t_storage = set_params[i][3]
			pinch = set_params[i][4]
			print('Start Simulating Case %s'%(i+1))
			r = get_result(A_helio_total, A_rcv, fb, R1, ab_particle, t_storage, pinch)
			fb_val.append(r[0])
			R1_val.append(r[1])
			UA_val.append(r[2])
			C_heliostat_val.append(r[3])
			C_rcv_val.append(r[4])
			C_HX_val.append(r[5])
			C_cycle_val.append(r[6])
			C_storage_val.append(r[7])
			C_equipment_val.append(r[8])
			C_total_val.append(r[9])
			EPY_val.append(r[10])
			LCOE_val.append(r[11])
			newname = 'solsticeresult_case%s_fb%s_R1%s'%(i+1,fb,R1)
			newresmatname = 'benchmark_res_case%s_fb%s_R1%s.mat'%(i+1,fb,R1)
			#in super computer the directory of your home is /scratch/xa1/username/
			os.system('mv /home/philgun/.local/lib/omlibrary/SolarTherm/solsticeresult /home/philgun/result/benchmark/solstice/%s'%(newname))
			os.system('mv /home/philgun/solartherm-particle/examples/PhysicalParticleCO21D_2ndApproach_res_0.mat /home/philgun/result/benchmark/resmat/%s'%(newresmatname))
			os.system('rm -rf *.c *.o *.h *.json *.xml *.makefile *.cmake *.bakmo *.mat')
			print(fb_val)
			print(R1_val)
	LCOE_min = min(LCOE_val)
	index_min = LCOE_val.index(min(LCOE_val))
	txt_name = 'result_case_%s.txt'%(i+1)
	f = open(txt_name,'w')
	f.write("UA=%s [kW/K], Heliostat=%s [USD], Receiver=%s [USD], HX=%s [USD], Cycle=%s [USD], TES=%s [USD], Total cost=%s [USD], EPY=%s [kJ], LCOE_real=%s [USD/kWh]\n"%(UA_val[index_min],C_heliostat_val[index_min],C_rcv_val[index_min],C_HX_val[index_min],C_cycle_val[index_min],C_storage_val[index_min],C_total_val[index_min],EPY_val[index_min],LCOE_min))
	f.write("Optimal field configuration fb=%s R1=%s [m]"%(fb_val[index_min],R1_val[index_min]))
	f.close()
	print("Finished Case %s"%(i+1))
print("Finished all cases")		
