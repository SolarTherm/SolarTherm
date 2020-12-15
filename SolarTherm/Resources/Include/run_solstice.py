from __future__ import print_function

import os
import time
import numpy as np
import solsticepy
from solsticepy.design_crs import CRS
from solsticepy.input import Parameters
from solsticepy.output_motab import output_matadata_motab, output_motab, read_motab, output_matadata_motab_multi_aperture, append_oelts
from solsticepy.design_multi_aperture import MultiApertureConfiguration

def set_param(inputs={}):
	'''
	set parameters
	'''

	pm=Parameters()
	for k, v in inputs.iteritems():
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
	for k, v in inputs.iteritems():
		print(k, '=', getattr(pm, k))
	print('')
	print('')

	pm.num_aperture=int(pm.num_aperture)
	if pm.num_aperture>1:
		pm.H_rcv=[]
		pm.W_rcv=[]
		for i in range(pm.num_aperture):
			pm.H_rcv.append(getattr(pm, 'H_rcv_%s'%(i+1)))
			pm.W_rcv.append(getattr(pm, 'W_rcv_%s'%(i+1)))

		mac=MultiApertureConfiguration(n=pm.num_aperture, gamma=pm.gamma, H_tower=pm.H_tower, W_rcv=pm.W_rcv, H_rcv=pm.H_rcv)
		pm.Z_rcv=[]

		for i in range(pm.num_aperture):
			lv=int(mac.get_lv_index(i))
			zi=mac.get_elev_height(lv)
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
		crs=CRS(latitude=pm.lat, casedir=casedir, nproc=int(pm.n_procs), verbose=False)
		crs.receiversystem(receiver=pm.rcv_type, rec_w=pm.W_rcv, rec_h=pm.H_rcv, rec_x=pm.X_rcv, rec_y=pm.Y_rcv, rec_z=pm.Z_rcv, rec_tilt=pm.tilt_rcv, rec_grid_w=int(pm.n_W_rcv), rec_grid_h=int(pm.n_H_rcv), rec_abs=pm.alpha_rcv, num_aperture=pm.num_aperture, gamma=pm.gamma)
		
		if pm.method==1:
			crs.heliostatfield(field=pm.field_type, hst_rho=pm.helio_refl, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios, R1=pm.R1, fb=pm.fb, dsep=pm.dsep)
		else:
			crs.heliostatfield(field=pm.field_type, hst_rho=pm.helio_refl, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios*2, R1=pm.R1, fb=pm.fb, dsep=pm.dsep)

		crs.yaml(dni=1000, sunshape=pm.sunshape, csr=pm.crs, half_angle_deg=pm.half_angle_deg, std_dev=pm.std_dev)

		if pm.field_type[-3:]=='csv':
			# simulate the oelt of an existing heliostat field
			oelt, A_land=crs.annual_oelt(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt))
		else:
			# design a new heliostat field
			oelt, A_land=crs.field_design_annual(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt), weafile=pm.wea_file, method=pm.method, Q_in_des=pm.Q_in_rcv, n_helios=pm.n_helios, zipfiles=False, gen_vtk=False, plot=False)

		if (A_land==0):    
			tablefile=None
		else:                          
			A_helio=pm.H_helio*pm.W_helio
			if pm.num_aperture==1:
				output_matadata_motab(table=oelt, field_type=pm.field_type, aiming='single', n_helios=crs.n_helios, A_helio=A_helio, eff_design=crs.eff_des, eff_annual=crs.eff_annual, H_rcv=pm.H_rcv, W_rcv=pm.W_rcv, H_tower=pm.H_tower, Q_in_rcv=pm.Q_in_rcv, A_land=A_land, savedir=tablefile)
			else:
				output_matadata_motab_multi_aperture(TABLE=oelt, eff_design = crs.eff_des, eff_annual = crs.eff_annual, A_land = A_land, H_tower= pm.H_tower, A_helio    = A_helio, n_helios_total = crs.n_helios, Q_in_rcv_total = crs.Q_in_rcv, num_aperture= pm.num_aperture, Q_in_rcv= crs.Q_in_rcv_i, n_helios=crs.n_helios_i, H_rcv=pm.H_rcv, W_rcv= pm.W_rcv, Z_rcv= pm.Z_rcv, mac=mac, savedir= tablefile)


		if pm.windy_optics:
			crs.slope=pm.slope_error_windy
			crs.casedir=pm.casedir+'/windy_optics'
			if not os.path.exists(crs.casedir):
				os.makedirs(crs.casedir)
			crs.yaml(dni=1000, sunshape=pm.sunshape, csr=pm.crs, half_angle_deg=pm.half_angle_deg, std_dev=pm.std_dev)

			oelt_windy, A_land=crs.annual_oelt(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt))	
			append_oelts(table=oelt_windy, identifier='windy', motabfile=tablefile, mac=mac)		

	end=time.time()
	print('')
	print('total time %.2f'%((end-start)/60.), 'min')
	np.savetxt(casedir+'/time.csv', np.r_[pm.n_rays, end-start], fmt='%.4f', delimiter=',')

	return tablefile



if __name__=='__main__':
	# tests
	case="test-single-aperture"

	if case=='test-single-aperture':
		num_aperture=1
		rcv_type='flat'    
		field_type='polar' 
		Q_in_rcv=64227613.194 #W
		W_helio=12.0156148407
		H_helio=12.0156148407
		H_tower=200.
		n_row_oelt=3
		n_col_oelt=6
		R1=80.
		fb=0.6
		windy_optics=1
		n_W_rcv=17.3205080757
		n_H_rcv=17.3205080757
		n_rays=10e6
		n_procs=2
		wea_file='../../SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab'
		inputs={'casedir': case, 'Q_in_rcv':Q_in_rcv, 'num_aperture': num_aperture, 'H_helio':H_helio,'W_helio':W_helio, 'H_tower':H_tower, 'wea_file':wea_file, 'n_row_oelt':n_row_oelt, 'n_col_oelt': n_col_oelt, 'rcv_type': rcv_type, 'R1':R1, 'fb':fb, 'field_type': field_type,"n_W_rcv":n_W_rcv,"n_H_rcv":n_H_rcv, "n_rays":n_rays, "windy_optics":windy_optics, "n_procs": n_procs }

	elif case=='test-multi-aperture':
		num_aperture=3
		angular_range=180
		rcv_type='multi-aperture'    
		field_type='multi-aperture' 
		Q_in_rcv=64227613.194 #W
		W_helio=12.0156148407
		H_helio=12.0156148407
		H_tower=200.
		n_row_oelt=3
		n_col_oelt=6
		R1=80.
		fb=0.6
		windy_optics=1
		W_rcv_1=17.3205080757
		H_rcv_1=17.3205080757
		W_rcv_2=17.3205080757
		H_rcv_2=17.3205080757
		W_rcv_3=17.3205080757
		H_rcv_3=17.3205080757
		n_W_rcv=17.3205080757
		n_H_rcv=17.3205080757
		n_rays=10e6
		wea_file='../../SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab'
		inputs={'casedir': case, 'Q_in_rcv':Q_in_rcv, 'num_aperture': num_aperture, 'W_rcv_1':W_rcv_1, 'H_rcv_1':H_rcv_1, 'W_rcv_2':W_rcv_2, 'H_rcv_2':H_rcv_2,'W_rcv_3':W_rcv_3, 'H_rcv_3':H_rcv_3,'H_helio':H_helio,'W_helio':W_helio, 'H_tower':H_tower, 'wea_file':wea_file, 'n_row_oelt':n_row_oelt, 'n_col_oelt': n_col_oelt, 'rcv_type': rcv_type, 'R1':R1, 'fb':fb, 'field_type': field_type,"n_W_rcv":n_W_rcv,"n_H_rcv":n_H_rcv, "n_rays":n_rays , "windy_optics":windy_optics, "angular_range":angular_range }

	run_simul(inputs)


