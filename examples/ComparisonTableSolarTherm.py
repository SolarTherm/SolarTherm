# -*- coding: utf-8 -*-
#xmodmap -e "keycode 72 = dead_greek dead_greek dead_greek dead_greek"
import DyMat 
import numpy as np
from tabulate import tabulate
from solartherm import postproc

fn_1 = 'case3a'
resmat_1 = '/home/philgun/solartherm-particle/examples/%s_res.mat' %(fn_1)
data_1 = DyMat.DyMatFile(resmat_1)

fn_2 = None
if fn_2 is None :
	data_2 = data_1
else:
	resmat_2 = '/home/philgun/solartherm/examples/%s_res.mat' %(fn_2)
	data_2 = DyMat.DyMatFile(resmat_2)

if fn_2 is None:
	data_set = 1
else:
	data_set = 2

num_var = 20
num_parameter = 11



#item_1 = "Turbine / PB Design Efficiency " #powerBlock.turbine.eta_design or eff_blk
item_1 = "Total heliostat area" #SM
item_2 = "Receiver aperture area" #t_storage
item_3 = "Annual Curtailment Eff" #'eta_curtail_off'
item_4 = "Annual Heliostat Availability" #'he_av_design'
item_5 = "Annual Field Optical Eff" #'eta_optical'
item_6 =  "Annual Defocus Curtailment eff" #'eta_curtail_defocus'
item_7 = "Annual Rcv Abs. eff" #'eta_recv_abs'
item_8 = "Annual Rcv thermal eff" #'eta_recv_thermal'
item_9 = "Annual Storage eff" #'eta_storage'
item_10 = "Annual PB net eff" #'eta_pb_net'
item_11 = u"Annual Sol.to El efficiency" #'eta_solartoelec'
item_12 = "Total Cost" #%(data.data('C_cap')[1] / 1e6)
item_13 = "Solar Field sub-system cost" #C_field_total
item_14 = u"Rcv Sub-System cost" #%((data.data('C_receiver')[1])/1e6)
item_15 = "Tower Cost"#C_tower
item_16 = "Strg Sub-System cost" #%((data.data('C_storage')[1])/1e6)
item_17 = "PB Sub-System cost" #%((data.data('C_pb')[1])/1e6) or ((data.data('C_block')[1])/1e6)
item_18 = "LCOE"
item_19 = "Energy per Year"
item_20 = "Capacity factor"

parameter_1 = "Solar Multiple" #SM
parameter_2 = "Storage hours" #t_storage
parameter_3 = "Gross Power Output" #'eta_curtail_off'
parameter_4 = "Tower height" #'he_av_design'
parameter_5 = "Concentration ratio" #'eta_optical'
parameter_6 =  "DNI design" #'eta_curtail_defocus'
parameter_7 = "T_out rcv design" #'eta_recv_abs'
parameter_8 = "T_in rcv desing" #'eta_recv_thermal'
parameter_9 = "Rcv eff design" #'eta_storage'
parameter_10 = "PB block design eff" #'eta_pb_net'
parameter_11 = "Heliostat design eff" #'eta_solartoelec'




variable_code = (['A_field', 'A_rcv','eta_curtail_off','he_av_design','eta_optical','eta_curtail_defocus', 'eta_recv_abs','eta_recv_thermal','eta_storage','eta_pb_net','eta_solartoelec','C_cap_total','C_field_total','C_receiver','C_tower','C_storage','C_block'])

###,'SM', 't_storage','eta_curtail_off','he_av_design','eta_optical','eta_curtail_defocus', 'eta_recv_abs','eta_recv_thermal','eta_storage','eta_pb_net','eta_solartoelec','C_cap_total','C_field_total','C_receiver','C_tower','C_storage','C_block'])

parameter_code = ['SM', 't_storage', 'P_gross','H_tower', 'CR', 'dni_des', 'T_hot_set', 'T_cold_set', 'eta_rec_th_des', 'eff_blk','eff_opt']


resultclass = postproc.SimResultElec

res_1 = resultclass(resmat_1) #passing the resmatfile into resultclass (postproc.SimResultElec)
result_1 = res_1.calc_perf()
LCOE_1 = float('%.2f'%(result_1[1]))
EPY_1 = float('%.2f'%(result_1[0]))
CAPF_1 = float('%.2f'%(result_1[2]))
SREV_1 = float('%.2f'%(result_1[3]/1e6))

if fn_2 is None :
	LCOE_2 = LCOE_1
	EPY_2 = EPY_1
	CAPF_2 = CAPF_1
else:
	res_2 = resultclass(resmat_2) #passing the resmatfile into resultclass (postproc.SimResultElec)
	result_2 = res_2.calc_perf()
	LCOE_2 = float('%.2f'%(result_2[1]))
	EPY_2= float('%.2f'%(result_2[0]))
	CAPF_2 = float('%.2f'%(result_2[2]))
exit
data_value = np.zeros([data_set,num_var])
shape = np.shape(data_value)
parameter_value = np.zeros([data_set,num_parameter])
shape_2 = np.shape(parameter_value)

if shape [0] > 1 :
	for i in range (num_parameter):
		parameter_value[0,i] = data_1.data(parameter_code[i])[-1]
		parameter_value[1,i] = data_2.data(parameter_code[i])[-1]
	parameter_value[0,2] = np.around(parameter_value[0,2]/1e6, decimals=2)	
	parameter_value[0,5] = np.around(parameter_value[0,5], decimals=2)
	parameter_value[0,6] = np.around(parameter_value[0,6]-273.15, decimals=2)
	parameter_value[0,7] = np.around(parameter_value[0,7]-273.15, decimals=2)
	parameter_value[0,8] = np.around(parameter_value[0,8]*100, decimals=2)
	parameter_value[0,9] = np.around(parameter_value[0,9]*100, decimals=2)
	parameter_value[0,10] = np.around(parameter_value[0,10]*100, decimals=2)

	parameter_value[1,2] = np.around(parameter_value[1,2]/1e6, decimals=2)	
	parameter_value[1,5] = np.around(parameter_value[1,5], decimals=2)
	parameter_value[1,6] = np.around(parameter_value[1,6]-273.15, decimals=2)
	parameter_value[1,7] = np.around(parameter_value[1,7]-273.15, decimals=2)
	parameter_value[1,8] = np.around(parameter_value[1,8]*100, decimals=2)
	parameter_value[1,9] = np.around(parameter_value[1,9]*100, decimals=2)
	parameter_value[1,10] = np.around(parameter_value[1,10]*100, decimals=2)
	
	for i in range (num_var-3):
		data_value[0,i] = data_1.data(variable_code[i])[-1]
		data_value[data_set-1,i] = data_2.data(variable_code[i])[-1]
		
	data_value[0,num_var-3] = LCOE_1
	data_value[1,num_var-3] = LCOE_2
	data_value[0,num_var-2] = EPY_1
	data_value[1,num_var-2] = EPY_2
	data_value[0,num_var-1] = CAPF_1
	data_value[1,num_var-1] = CAPF_2

	
	#CONVERSION FROM USD TO MILL USD
	data_value[0,11] = np.around(data_value[0,11]/1e6,decimals=2)
	data_value[0,12] = np.around(data_value[0,12]/1e6,decimals=2)
	data_value[0,13] = np.around(data_value[0,13]/1e6,decimals=2)
	data_value[0,14] = np.around(data_value[0,14]/1e6,decimals=2)
	data_value[0,15] = np.around(data_value[0,15]/1e6,decimals=2)
	data_value[0,16] = np.around(data_value[0,16]/1e6,decimals=2)
	data_value[0,0] = np.around(data_value[0,0],decimals=2)
	data_value[0,1] = np.around(data_value[0,1],decimals=2)
	data_value[0,2] = np.around(data_value[0,2]*100,decimals=2)
	data_value[0,3] = np.around(data_value[0,3]*100,decimals=2)
	data_value[0,4] = np.around(data_value[0,4]*100,decimals=2)
	data_value[0,5] = np.around(data_value[0,5]*100,decimals=2)
	data_value[0,6] = np.around(data_value[0,6]*100,decimals=2)
	data_value[0,7] = np.around(data_value[0,7]*100,decimals=2)
	data_value[0,8] = np.around(data_value[0,8]*100,decimals=2)
	data_value[0,9] = np.around(data_value[0,9]*100,decimals=2)
	data_value[0,10] = np.around(data_value[0,10]*100,decimals=2)

	data_value[1,11] = np.around(data_value[1,11]/1e6,decimals=2)
	data_value[1,12] = np.around(data_value[1,12]/1e6,decimals=2)
	data_value[1,13] = np.around(data_value[1,13]/1e6,decimals=2)
	data_value[1,14] = np.around(data_value[1,14]/1e6,decimals=2)
	data_value[1,15] = np.around(data_value[1,15]/1e6,decimals=2)
	data_value[1,16] = np.around(data_value[1,16]/1e6,decimals=2)
	data_value[1,0] = np.around(data_value[1,0],decimals=2)
	data_value[1,1] = np.around(data_value[1,1],decimals=2)
	data_value[1,2] = np.around(data_value[1,2]*100,decimals=2)
	data_value[1,3] = np.around(data_value[1,3]*100,decimals=2)
	data_value[1,4] = np.around(data_value[1,4]*100,decimals=2)
	data_value[1,5] = np.around(data_value[1,5]*100,decimals=2)
	data_value[1,6] = np.around(data_value[1,6]*100,decimals=2)
	data_value[1,7] = np.around(data_value[1,7]*100,decimals=2)
	data_value[1,8] = np.around(data_value[1,8]*100,decimals=2)
	data_value[1,9] = np.around(data_value[1,9]*100,decimals=2)
	data_value[1,10] = np.around(data_value[1,10]*100,decimals=2)
	

else:
	for i in range (num_parameter):
		parameter_value[0,i] = data_1.data(parameter_code[i])[-1]
	parameter_value[0,2] = np.around(parameter_value[0,2]/1e6, decimals=2)
	parameter_value[0,5] = np.around(parameter_value[0,5], decimals=2)
	parameter_value[0,6] = np.around(parameter_value[0,6]-273.15, decimals=2)
	parameter_value[0,7] = np.around(parameter_value[0,7]-273.15, decimals=2)
	parameter_value[0,8] = np.around(parameter_value[0,8]*100, decimals=2)
	parameter_value[0,9] = np.around(parameter_value[0,9]*100, decimals=2)
	parameter_value[0,10] = np.around(parameter_value[0,10]*100, decimals=2)

	for i in range (num_var-3):
		data_value[0,i] = data_1.data(variable_code[i])[-1]
	data_value[0,num_var-3] = LCOE_1
	data_value[0,num_var-2] = EPY_1
	data_value[0,num_var-1] = CAPF_1

	#CONVERSION FROM USD TO MILL USD
	data_value[0,11] = np.around(data_value[0,11]/1e6,decimals=2)
	data_value[0,12] = np.around(data_value[0,12]/1e6,decimals=2)
	data_value[0,13] = np.around(data_value[0,13]/1e6,decimals=2)
	data_value[0,14] = np.around(data_value[0,14]/1e6,decimals=2)
	data_value[0,15] = np.around(data_value[0,15]/1e6,decimals=2)
	data_value[0,16] = np.around(data_value[0,16]/1e6,decimals=2)
	data_value[0,0] = np.around(data_value[0,0],decimals=2)
	data_value[0,1] = np.around(data_value[0,1],decimals=2)
	data_value[0,2] = np.around(data_value[0,2]*100,decimals=2)
	data_value[0,3] = np.around(data_value[0,3]*100,decimals=2)
	data_value[0,4] = np.around(data_value[0,4]*100,decimals=2)
	data_value[0,5] = np.around(data_value[0,5]*100,decimals=2)
	data_value[0,6] = np.around(data_value[0,6]*100,decimals=2)
	data_value[0,7] = np.around(data_value[0,7]*100,decimals=2)
	data_value[0,8] = np.around(data_value[0,8]*100,decimals=2)
	data_value[0,9] = np.around(data_value[0,9]*100,decimals=2)
	data_value[0,10] = np.around(data_value[0,10]*100,decimals=2)

fns = ['RESULTS',fn_1, fn_2]
items = ['RESULTS',item_1,item_2,item_3,item_4,item_5,item_6,item_7,item_8,item_9,item_10,item_11,item_12,item_13,item_14,item_15,item_16,item_17,item_18,item_19,item_20]
items_parameter = ['FIXED PARAMETERS', parameter_1, parameter_2, parameter_3, parameter_4, parameter_5, parameter_6, parameter_7, parameter_8, parameter_9, parameter_10, parameter_11]
items_metric = ['METRIC','m.sq', 'm.sq', '%', '%', '%', '%','%', '%', '%', '%', '%', 'M.USD', 'M.USD', 'M.USD', 'M.USD', 'M.USD', 'M.USD', 'USD/MWh', 'MWh/year', '%', 'M.USD']
parameters_metric = ['METRIC','N/A', 'hrs', 'MW', 'm', 'N/A', 'W/m.sq', 'deg C', 'deg C', '%', '%', '%']


#items = [i.decode('utf-8') for i in items]

table_result = np.zeros([num_var+1,data_set+2])
table_result = table_result.astype(str)
table_parameter = np.zeros([num_parameter+1,data_set+2])
table_parameter = table_parameter.astype(str)

for i in range (num_parameter+1):
	table_parameter [i,0] = items_parameter[i] #.decode('utf-8')
	table_parameter [i,data_set+1] = parameters_metric[i] #.decode('utf-8')

for i in range (1,data_set+1):
	table_parameter [0,i] = fns[i]

for j in range (1,data_set+1):	
	for i in range (1,num_parameter+1):
		table_parameter[i,j] = parameter_value[j-1,i-1]


for i in range (num_var+1):
	table_result [i,0] = items[i] #.decode('utf-8')
	table_result [i,data_set+1] = items_metric[i] #.decode('utf-8

for i in range (1,data_set+1):
	table_result [0,i] = fns[i]

for j in range (1,data_set+1):	
	for i in range (1,num_var+1):
		table_result [i,j] = data_value[j-1,i-1]
	
print (tabulate(table_result))
print (tabulate(table_parameter))





