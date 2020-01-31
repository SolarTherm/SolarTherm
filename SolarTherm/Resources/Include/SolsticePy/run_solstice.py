import os
import sys
import time

import numpy as N
import matplotlib.pyplot as plt
from uncertainties import ufloat
from scipy.interpolate import interp1d,interp2d
import matplotlib.cm as cm

from repository.SolsticePy.proces_raw import *
from repository.SolsticePy.cal_layout import radial_stagger
from repository.SolsticePy.cal_field import *
from repository.SolsticePy.cal_sun import *
from repository.SolsticePy.gen_YAML import gen_YAML
from repository.SolsticePy.gen_vtk import *
from repository.SolsticePy.input import Parameters
from repository.SolsticePy.master_crs import *

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
    RAYS=N.r_[1e5]

    pm=set_param(inputs)

    print ''
    print 'Test inputs'
    for k, v in inputs.iteritems():
        print k, '=', getattr(pm, k)
    print ''
    print ''

    TIME=N.array([])

    for r in RAYS:
        print ''

        start=time.time()
        pm.num_rays=int(r)

        casedir=pm.casedir
        pm.saveparam(casedir)

        crs=CRS(casedir)

        crs.heliostatfield(field=pm.field, num_hst=int(pm.n_heliostat), hst_w=float(pm.W_heliostat), hst_h=float(pm.H_heliostat), hst_z=float(pm.hst_z), hst_rho=float(pm.hst_rho), slope=float(pm.slope), R1=pm.R1, dsep=pm.dsep, tower_h=float(pm.H_tower), tower_r=float(pm.tower_r))

        crs.receiversystem(receiver=pm.receiver, rec_w=float(pm.rec_w), rec_h=float(pm.rec_h), rec_x=float(pm.rec_x), rec_y=float(pm.rec_y), rec_z=float(pm.rec_z), rec_tilt=float(pm.rec_tilt), rec_grid=int(pm.rec_grid), rec_abs=float(pm.rec_abs))

        crs.annualsolar_regular(nd=int(pm.nd), nh=int(pm.nh), latitude=float(pm.latitude), sunshape=pm.sunshape, sunsize=float(pm.sunsize), clearsky=True, plotdni=False)

        annualfolder=casedir+'/annual'
        crs.run_annual(annualfolder, num_rays=pm.num_rays, mode='design', genvtk_hst=True)
                                                                        
        end=time.time()
        print ''
        print ''
        print 'Simulation', int(r) , 'rays'
        print 'total time', end-start, 's' 
        N.savetxt(casedir+'/time.csv', N.r_[r, end-start], fmt='%.4f', delimiter=',')

    return 999

    
    
if __name__=='__main__':
    inputs={'casedir': "./result/demo"}
    run_simul(inputs)
