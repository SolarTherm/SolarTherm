import os
import sys
import time

import numpy as N
import matplotlib.pyplot as plt
from uncertainties import ufloat
from scipy.interpolate import interp1d,interp2d
import matplotlib.cm as cm

from proces_raw import *
from cal_layout import radial_stagger
from cal_field import *
from cal_sun import *
from gen_YAML import gen_YAML
from gen_vtk import *
from input import Parameters
from master_crs import *
from output_solartherm import *

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

    print ''
    print 'Test inputs'
    for k, v in inputs.iteritems():
        print k, '=', getattr(pm, k)
    print ''
    print ''

    TIME=N.array([])
    print ''

    start=time.time()

    casedir=pm.casedir
    pm.saveparam(casedir)
    tablefile=casedir+'/OELT_Solstice.motab'
    if os.path.exists(tablefile):    
        print ''
        print 'Load exsiting OELT'

    else:

        crs=CRS(latitude=pm.lat, casedir=casedir)

        crs.receiversystem(receiver=pm.rcv_type, rec_w=float(pm.W_rcv), rec_h=float(pm.H_rcv), rec_x=float(pm.X_rcv), rec_y=float(pm.Y_rcv), rec_z=float(pm.Z_rcv), rec_tilt=float(pm.tilt_rcv), rec_grid_w=int(pm.n_W_rcv), rec_grid_h=int(pm.n_H_rcv), rec_abs=float(pm.alpha_rcv))

        if pm.method==1:
            crs.heliostatfield(field=pm.field_type, hst_rho=pm.rho_helio, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios, R1=pm.R1, fb=pm.fb, dsep=pm.dsep)
        else:
            crs.heliostatfield(field=pm.field_type, hst_rho=pm.rho_helio, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios*2, R1=pm.R1, fb=pm.fb, dsep=pm.dsep)

        if pm.field_type[-3:]=='csv':
            oelt, A_land=crs.run_annual_system(num_rays=int(pm.n_rays), nd=pm.n_row_oelt, nh=pm.n_col_oelt, zipfiles=False, genvtk_hst=False, plot=False)     

        else:
            oelt, A_land=crs.field_design_annual(method=pm.method, Q_in_des=pm.Q_in_rcv, n_helios=pm.n_helios, latitude=pm.lat, dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=pm.n_row_oelt, nh=pm.n_col_oelt, weafile=pm.wea_file, zipfiles=False, genvtk_hst=True, plot=False)         


        if (A_land==0):    
            tablefile=None
        else:                                                
            A_helio=pm.H_helio*pm.W_helio
            output_matadata_motab(table=oelt, field_type=pm.field_type, aiming='single', n_helios=crs.n_helios, A_helio=A_helio, eff_design=crs.eff_des, H_rcv=pm.H_rcv, W_rcv=pm.W_rcv, H_tower=pm.H_tower, Q_in_rcv=pm.Q_in_rcv, A_land=A_land, savedir=tablefile)
            end=time.time()
            print ''
            print 'total time %.2f'%((end-start)/60.), 'min' 
            N.savetxt(casedir+'/time.csv', N.r_[pm.n_rays, end-start], fmt='%.4f', delimiter=',')

    return tablefile

    
    
if __name__=='__main__':
    case="./test"
    Q_in_rcv=553e6 #W
    W_helio=12.015614841
    H_helio=12.015614841
    H_tower=183.331344997
    n_row_oelt=3
    n_col_oelt=5
    R1=40.
    fb=0.4
    W_rcv=14.9999995285
    H_rcv=18.6699994131
    n_W_rcv=50
    n_H_rcv=10
    n_rays=10e6

    #field_type='/media/yewang/Data/data-gen3p3-particle/study-uncertainty/model/SamplingDakota/default-case/optics/pos_and_aiming.csv'
    field_type='polar'
    wea_file='/home/yewang/solartherm-philipe/SolarTherm/Data/Weather/gen3p3_Daggett_TMY3.motab'
    inputs={'casedir': case, 'Q_in_rcv':Q_in_rcv, 'W_rcv':W_rcv, 'H_rcv':H_rcv, 'H_tower':H_tower, 'wea_file':wea_file, 'n_row_oelt':n_row_oelt, 'n_col_oelt': n_col_oelt, 'field_type':'surround', 'rcv_type': 'cylinder', 'R1':R1, 'fb':fb, 'field_type': field_type,"n_W_rcv":n_W_rcv,"n_H_rcv":n_H_rcv, "n_rays":n_rays }

    run_simul(inputs)


