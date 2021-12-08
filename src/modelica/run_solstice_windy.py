from __future__ import print_function

import sys

import os
import time
import argparse
import numpy as np
import solsticepy
from solsticepy.design_crs import CRS
from solsticepy.input import Parameters
from solsticepy.output_motab import output_metadata_motab, output_motab, read_motab, output_metadata_motab_multi_aperture, append_oelts

from solsticepy.design_multi_aperture import MultiApertureConfiguration


sys.stderr.write("Done with imports...\n");

def set_param(inputs={}):
	'''
	set parameters
	'''

	pm=Parameters()
	for k, v in inputs.items():
		setattr(pm, k, v)

	pm.dependent_par()

	return pm

def run_simul(inputs={}):
	'''
	design the field base on performance of annual performance
	the annual performance is TMY DNI weighted
	'''
	pm=set_param(inputs)

	print('')
	print('Test inputs')
	for k, v in inputs.items():
		print(k, '=', getattr(pm, k))
	print('')
	print('')

	pm.num_aperture=int(pm.num_aperture)
	if pm.num_aperture>1:
		# the sequence of the multi-aperture is (left, right, centre) or (lv1, lv2, lv3) 
		H_rcv={}
		W_rcv={}
		for i in range(pm.num_aperture):
			H_rcv['lv_%.0f'%(i+1)]=getattr(pm, 'H_rcv_%s'%(i+1))
			W_rcv['lv_%.0f'%(i+1)]=getattr(pm, 'W_rcv_%s'%(i+1))

		if pm.rcv_type=='multi-aperture-parallel':
			parallel=True
		else:
			parallel=False		
		mac=MultiApertureConfiguration(n=pm.num_aperture, gamma=pm.gamma, H_tower=pm.H_tower, R_tower=pm.R_tower, W_rcv=W_rcv, H_rcv=H_rcv, parallel=parallel)
		pm.W_rcv=mac.W_rcv
		pm.H_rcv=mac.H_rcv
		pm.Z_rcv=[]

		for i in range(pm.num_aperture):
			xi, yi, zi=mac.get_cood_pos(i)
			pm.Z_rcv.append(zi)
	else:
		mac=None

	start=time.time()
	casedir=pm.casedir
	pm.saveparam(casedir)

	tablefile=casedir+'/OELT_Solstice.motab'
	if os.path.exists(tablefile):    
		print('')
		print('Load exsiting OELT')

	else:
		crs=CRS(latitude=pm.lat, casedir=casedir, nproc=int(pm.n_procs), verbose=pm.verbose)
		crs.receiversystem(receiver=pm.rcv_type, rec_w=pm.W_rcv, rec_h=pm.H_rcv, rec_x=pm.X_rcv, rec_y=pm.Y_rcv, rec_z=pm.Z_rcv, rec_tilt=pm.tilt_rcv, rec_grid_w=int(pm.n_W_rcv), rec_grid_h=int(pm.n_H_rcv), rec_abs=pm.alpha_rcv, mac=mac)
	
		if pm.method==1:
			crs.heliostatfield(field=pm.field_type, hst_rho=pm.helio_refl, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios, R1=pm.R1, fb=pm.fb, dsep=pm.dsep, mac=mac)
		else:
			crs.heliostatfield(field=pm.field_type, hst_rho=pm.helio_refl, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios*2, R1=pm.R1, fb=pm.fb, dsep=pm.dsep, mac=mac)

		crs.yaml(dni=1000, sunshape=pm.sunshape, csr=pm.csr, half_angle_deg=pm.half_angle_deg, std_dev=pm.std_dev)

		if pm.field_type[-3:]=='csv':
			# simulate the oelt of an existing heliostat field
			oelt, A_land=crs.annual_oelt(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt))
			crs.eff_des=0
			crs.eff_annual=0
		else:
			# design a new heliostat field
			#oelt, A_land=crs.field_design_annual(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt), weafile=pm.wea_file, method=pm.method, Q_in_des=pm.Q_in_rcv, n_helios=pm.n_helios, zipfiles=False, gen_vtk=pm.gen_vtk, plot=False)
			oelt, A_land=crs.field_design_annual(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt), weafile=pm.wea_file, method=pm.method, Q_in_des=pm.Q_in_rcv, n_helios=pm.n_helios, zipfiles=False, gen_vtk=pm.gen_vtk, plot=pm.verbose)			

		if (A_land==0):    
			tablefile=None
		else:                          
			A_helio=pm.H_helio*pm.W_helio
			if pm.num_aperture==1:
				output_metadata_motab(table=oelt, field_type=pm.field_type, aiming='single', n_helios=crs.n_helios, A_helio=A_helio, eff_design=crs.eff_des, eff_annual=crs.eff_annual, H_rcv=pm.H_rcv, W_rcv=pm.W_rcv, H_tower=pm.H_tower, Q_in_rcv=pm.Q_in_rcv, A_land=A_land, savedir=tablefile)
			else:
				output_metadata_motab_multi_aperture(TABLE=oelt, eff_design = crs.eff_des, eff_annual = crs.eff_annual, A_land = A_land, H_tower= pm.H_tower, A_helio    = A_helio, n_helios_total = crs.n_helios, Q_in_rcv_total = crs.Q_in_rcv, num_aperture= pm.num_aperture, Q_in_rcv= crs.Q_in_rcv_i, n_helios=crs.n_helios_i, H_rcv=pm.H_rcv, W_rcv= pm.W_rcv, Z_rcv= pm.Z_rcv, mac=mac, savedir= tablefile)
		


		if pm.windy_optics:
			print("Running the windy OELT now!!!.........................")
			crs.slope=pm.slope_error_windy
			crs.casedir=pm.casedir+'/windy_optics'
			if not os.path.exists(crs.casedir):
				os.makedirs(crs.casedir)
			crs.yaml(dni=1000, sunshape=pm.sunshape, csr=pm.csr, half_angle_deg=pm.half_angle_deg, std_dev=pm.std_dev)

			oelt_windy, A_land=crs.annual_oelt(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt))	
			append_oelts(table=oelt_windy, identifier='windy', motabfile=tablefile, mac=mac)

				

	end=time.time()
	print('')
	print('total time %.2f'%((end-start)/60.), 'min')
	np.savetxt(casedir+'/time.csv', np.r_[pm.n_rays, end-start], fmt='%.4f', delimiter=',')
	
	tablefile=tablefile.encode('utf-8')
	return tablefile


def convert_list(alist, delimiter=','):
	c=[]
	tmp=''
	for l in alist:
		if l==delimiter:
			c.append(tmp)
			tmp=''
		else:
			tmp+=l
	return c
	
if __name__=='__main__':
	'''
	# tests
	case="test-multi-aperture"

	if case=='test-single-aperture':
		num_aperture=1
		rcv_type='flat'    
		field_type='polar' 
		Q_in_rcv=64227613.194 #W
		W_helio=12.0156148407
		H_helio=12.0156148407
		H_tower=200.
		R_tower=20.
		n_row_oelt=3
		n_col_oelt=6
		R1=80.
		fb=0.6
		windy_optics=1
		n_W_rcv=10
		n_H_rcv=10
		n_rays=10e6
		n_procs=1
		verbose=True
		gen_vtk=True
		wea_file='../../SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab'
		inputs={'casedir': case, 'Q_in_rcv':Q_in_rcv, 'num_aperture': num_aperture, 'H_helio':H_helio,'W_helio':W_helio, 'H_tower':H_tower,'R_tower':R_tower, 'wea_file':wea_file, 'n_row_oelt':n_row_oelt, 'n_col_oelt': n_col_oelt, 'rcv_type': rcv_type, 'R1':R1, 'fb':fb, 'field_type': field_type,"n_W_rcv":n_W_rcv,"n_H_rcv":n_H_rcv, "n_rays":n_rays, "windy_optics":windy_optics, "n_procs": n_procs, "verbose": verbose, "gen_vtk": gen_vtk }

	elif case=='test-multi-aperture':
		verbose=False
		gen_vtk=False
		num_aperture=3
		angular_range=180
		method = 1
		rcv_type='multi-aperture-parallel'    
		field_type='multi-aperture' 
		Q_in_rcv=642276136.194 #W
		W_helio=12.0156148407
		H_helio=12.0156148407
		H_tower=200.
		R_tower=12.5
		R1=80.
		fb=0.6
		windy_optics=1
		W_rcv_1=17.3205080757
		H_rcv_1=17.3205080757
		W_rcv_2=17.3205080757
		H_rcv_2=17.3205080757
		W_rcv_3=17.3205080757
		H_rcv_3=17.3205080757
		slope_error_windy = 0.002
		slope_error = 0.00153
		n_W_rcv=10
		n_H_rcv=10
		n_rays=5000000.0
		helio_refl = 0.875425
		windy_optics = False
		wea_file='../../SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab'
		tilt_rcv = 0
		n_procs = 0
		n_row_oelt = 3
		n_col_oelt = 6
		inputs={'casedir': case, 'Q_in_rcv':Q_in_rcv, 'num_aperture': num_aperture, 'W_rcv_1':W_rcv_1, 'H_rcv_1':H_rcv_1, 'W_rcv_2':W_rcv_2, 'H_rcv_2':H_rcv_2,'W_rcv_3':W_rcv_3, 'H_rcv_3':H_rcv_3,'H_helio':H_helio,'W_helio':W_helio, 'H_tower':H_tower, 'R_tower':R_tower, 'wea_file':wea_file, 'rcv_type': rcv_type, 'R1':R1, 'fb':fb, 'field_type': field_type,"n_W_rcv":n_W_rcv,"n_H_rcv":n_H_rcv, "n_rays":n_rays , "windy_optics":windy_optics, "verbose": verbose, "gen_vtk": gen_vtk, "helio_refl":helio_refl, "windy_optics":windy_optics,"slope_error_windy":slope_error_windy,"slope_error":slope_error, "method":method, "gamma":angular_range, "tilt_rcv":tilt_rcv, "n_procs":n_procs}#,"n_row_oelt":n_row_oelt,"n_col_oelt":n_col_oelt }

	run_simul(inputs)
	print("Finish execution.......")

	'''
	parser = argparse.ArgumentParser()
	parser.add_argument('--casedir', type=str)
	parser.add_argument('--wea_file', type=str)
	parser.add_argument('--field_type', type=str)
	parser.add_argument('--rcv_type', type=str)
	parser.add_argument('--sunshape', type=str)	
	parser.add_argument('--num_args', type=int, default=0, 
			help="number of float arguments")
	parser.add_argument('--var_names', type=list)
	parser.add_argument('--var_vals', type=list)
		
	args = parser.parse_args()
	args.var_names=convert_list(args.var_names)
	args.var_vals=convert_list(args.var_vals)
	inputs=vars(args)
	
	for i in range(args.num_args):
		i=int(i)
		n=args.var_names[i]
		v=float(args.var_vals[i])
		inputs[n]=v
			
	del inputs['num_args']
	del inputs['var_names']
	del inputs['var_vals']

	run_simul(inputs)
	
	
