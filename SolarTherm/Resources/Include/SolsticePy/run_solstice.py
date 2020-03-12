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
        print 'Load exsited OELT'

    else:

        crs=CRS(latitude=pm.lat, casedir=casedir)

        crs.annualsolar(nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt), latitude=float(pm.lat), sunshape=pm.sunshape, sunsize=float(pm.sunsize))

        crs.heliostatfield(field=pm.field_type, hst_rho=pm.rho_helio, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios, R1=pm.R1, fb=pm.fb, dsep=pm.dsep)

        crs.receiversystem(receiver=pm.rcv_type, rec_w=float(pm.W_rcv), rec_h=float(pm.H_rcv), rec_x=float(pm.X_rcv), rec_y=float(pm.Y_rcv), rec_z=float(pm.Z_rcv), rec_tilt=float(pm.tilt_rcv), rec_grid=int(pm.n_H_rcv), rec_abs=float(pm.alpha_rcv))

        power, eff_des=crs.field_design(Q_in_des=pm.Q_in_rcv, latitude=pm.lat, dni_des=pm.dni_des, num_rays=pm.n_rays*10, genvtk_hst=True)
      
        annualfolder=casedir+'/annual'
        crs.run_annual(annualfolder, num_rays=pm.n_rays, genvtk_hst=False)
                                                                        
        A_helio=pm.H_helio*pm.W_helio
        output_matadata_motab(table=crs.table, field_type=pm.field_type, aiming='single', n_helios=crs.n_helios, A_helio=A_helio, eff_design=crs.eff_des, H_rcv=pm.H_rcv, W_rcv=pm.W_rcv, H_tower=pm.H_tower, lat=pm.lat, slope_error=pm.slope_error, savedir=tablefile)
        end=time.time()
        print ''
        print ''
        print 'Simulation', pm.n_rays , 'rays'
        print 'total time %.2f'%((end-start)/60.), 'min' 
        N.savetxt(casedir+'/time.csv', N.r_[pm.n_rays, end-start], fmt='%.4f', delimiter=',')

    return tablefile

    
    
if __name__=='__main__':
    case="./result/demo"
    Q_in_rcv=1e6 #W
    W_rcv=25.
    H_rcv=25.
    H_tower=200.
    inputs={'casedir': case, 'Q_in_rcv':Q_in_rcv, 'W_rcv':W_rcv, 'H_rcv':H_rcv, 'H_tower':H_tower}

    run_simul(inputs)


