import os
import time
import numpy as np

import solsticepy
from solsticepy.design_crs import CRS
#from solsticepy.design_crs_aimingstrategy import *
from solsticepy.input import Parameters
from solsticepy.output_motab import output_matadata_motab, output_motab, read_motab

def set_param(inputs={}):
    '''
    set parameters
    '''

    pm=Parameters()
    for k, v in inputs.iteritems():

        if hasattr(pm, k):
            setattr(pm, k, v)
        else:
            raise RuntimeError("invalid paramter '%s'"%(k,)) 

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
    print ''
    print ''

    TIME=np.array([])
    print('')

    casedir=pm.casedir
    pm.saveparam(casedir)
    tablefile=casedir+'/OELT_Solstice.motab'
    if os.path.exists(tablefile):    
        print('')
        print('Load exsiting OELT')

    else:
        start=time.time()

        if pm.aimingstrategy:
            tablefile=design_crs_aimingstrategy(pm)
        else:
            tablefile=design_crs(pm)

        end=time.time()
        print('')
        print('total time %.2f'%((end-start)/60.), 'min')
        np.savetxt(casedir+'/time.csv', np.r_[pm.n_rays, end-start], fmt='%.4f', delimiter=',')

    return tablefile

def design_crs(pm):
    '''
    Design a central receiver system without sophisticated aiming strategy
    Steps:
	    1) Generate an oversized heliostat field
	    2) Perform annual optical simulations, obtain and save the annual performance of each individual heliostats
	    3) Rank the heliostats according to their annual optical efficiency
	    4) Adding the heat output of each heliostat at desin point until it reaches the system requied heat to the receiver
	    5) Post processing the performance of the selected heliostats, obtain the optical efficiency lookup table (OELT)

    Argument: 
	    pm: class, the Parameter class that contains all the parameters for the system

    Return:
	    tablefile: str, the directory that the OELT is saved

    '''
    crs=CRS(latitude=pm.lat, casedir=pm.casedir)

    crs.receiversystem(receiver=pm.rcv_type, rec_w=float(pm.W_rcv), rec_h=float(pm.H_rcv), rec_x=float(pm.X_rcv), rec_y=float(pm.Y_rcv), rec_z=float(pm.Z_rcv), rec_tilt=float(pm.tilt_rcv), rec_grid_w=int(pm.n_W_rcv), rec_grid_h=int(pm.n_H_rcv), rec_abs=float(pm.alpha_rcv))

    if pm.method==1:
        crs.heliostatfield(field=pm.field_type, hst_rho=pm.helio_refl, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios, R1=pm.R1, fb=pm.fb, dsep=pm.dsep)
    else:
        crs.heliostatfield(field=pm.field_type, hst_rho=pm.rho_helio, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios*2, R1=pm.R1, fb=pm.fb, dsep=pm.dsep)

    crs.yaml(dni=1000, sunshape=pm.sunshape, csr=pm.crs, half_angle_deg=pm.half_angle_deg, std_dev=pm.std_dev)

    if pm.field_type[-3:]=='csv':
        oelt, A_land=crs.annual_oelt(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt))

    else:
        oelt, A_land=crs.field_design_annual(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt), weafile=pm.wea_file, method=pm.method, Q_in_des=pm.Q_in_rcv, n_helios=pm.n_helios, zipfiles=False, gen_vtk=False, plot=False)

    if (A_land==0):    
        tablefile=None
    else:
        tablefile=pm.casedir+'/OELT_Solstice.motab'                                      
        A_helio=pm.H_helio*pm.W_helio
        output_matadata_motab(table=oelt, field_type=pm.field_type, aiming='single', n_helios=crs.n_helios, A_helio=A_helio, eff_annual=crs.eff_annual, eff_design=crs.eff_des, H_rcv=pm.H_rcv, W_rcv=pm.W_rcv, H_tower=pm.H_tower, Q_in_rcv=pm.Q_in_rcv, A_land=A_land, savedir=tablefile)


    return tablefile
    
    
def design_crs_aimingstrategy(pm):
	'''
	Design a central receiver system that requires a sophisticated aiming strategy, like molten salt or sodium systems
	MDBA method
	TBD...

	'''
	casedir=pm.casedir	
	tablefile=casedir+'/OELT_Solstice.motab'

	if not os.path.exists(casedir):
		os.makedirs(casedir)

	from Field_receiver_model.one_key_co_optimisation import one_key_start
	from Field_receiver_model.cal_sun import SunPosition
	from Field_receiver_model.cal_layout_r import radial_stagger, aiming_cylinder
	from Field_receiver_model.Deviation_aiming_new3 import aiming
	from Field_receiver_model.Open_CSPERB import eval_v_max, Cyl_receiver
	from Field_receiver_model.Open_CSPERB_plots import tower_receiver_plots
	from Field_receiver_model.HC import Na
	from Field_receiver_model.Tube_materials import Inconel740H
	from Field_receiver_model.Flux_reader import read_data
	from Field_receiver_model.Loss_analysis import receiver_correlation
	from Field_receiver_model.output_motab import output_motab, output_matadata_motab
	from Field_receiver_model.python_postprocessing import proces_raw_results, get_heliostat_to_receiver_data
	from Field_receiver_model.SOLSTICE import SolsticeScene

	Model=one_key_start(casedir=casedir, 
		tower_h=pm.H_tower, 
		delta_r2=pm.delta_r2,
		delta_r3=pm.delta_r3,
		r_diameter=pm.W_rcv,
		r_height=pm.H_rcv,
		SM=pm.SM,
		oversizing=pm.f_oversize, 
		fluxlimitpath=pm.fluxlimitpath,
		hst_w=pm.W_helio,
		hst_h=pm.H_helio,
		mirror_reflectivity=pm.helio_refl,
		slope_error=pm.slope_error,
		num_rays=int(pm.n_rays),
		latitude=pm.lat,
		)

	Model.big_field_generation()
	Model.annual_big_field()
	Model.determine_field()
	Model.flow_path()
	Model.annual_trimmed_field()	

	return tablefile


if __name__=='__main__':
	case="test-aiming"
	fluxlimitpath='../../Data/Optics/sodium/fluxlimit'
	wea_file='../../Data/Weather/Daggett_Ca_TMY32.motab'
	aimingstrategy=True
	r_diameter=19.012482 # receiver diameter
	r_height=19.810327 # receiver height
	tower_h=188.567344 # tower height
	delta_r2=0.871037 # field expanding for zone2
	delta_r3=1.992501 # field expanding for zone3
	oversizing=1.245606 # oversizing factor
	SM=2.717882 # Solar multiple
	num_rays=5000
	print r_diameter,r_height,tower_h,delta_r2,delta_r3,oversizing,SM

	inputs={'casedir': case, 
			'aimingstrategy':aimingstrategy, 
			'H_tower': tower_h, 
			'delta_r2': delta_r2,
			'delta_r3': delta_r3,
			'W_rcv': r_diameter,
			'H_rcv': r_height,
			'SM': SM,
			'f_oversize': oversizing,
			'fluxlimitpath': fluxlimitpath,
			'n_rays':num_rays}

	run_simul(inputs)


