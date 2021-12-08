import solsticepy
from solsticepy.design_bd import *
from solsticepy.gen_flux_map import gencsvannual
import numpy as np
import os

def set_param(inputs={}):
    '''
    set parameters
    '''
    pm=Parameters()
    for k, v in inputs.iteritems():
        try:
            setattr(pm, k, v)
        except Exception as e:
            sys.stderr.write("%s\n"%(str(e)))
            raise RuntimeError("invalid parameter '%s'"%(k,))

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
    print ('')

    TIME=np.array([])
    print('')

    start=time.time()

    casedir=pm.casedir
    tablefile=casedir+'/OELT_Solstice.motab'
    if os.path.exists(tablefile):
        print('')
        print('Load exsiting OELT')

    else:
        if pm.aperture_angle_y == 0.:
                pm.aperture_angle_y=None
        else:
                pm.aperture_angle_y=float(pm.aperture_angle_y)

        pm.saveparam(casedir)

        # create the environment and scene
        # =========

        bd=BD(latitude=pm.lat, casedir=casedir)

        bd.receiversystem(receiver=pm.rcv_type, rec_abs=float(pm.alpha_rcv), rec_w=float(pm.W_rcv), rec_l=float(pm.H_rcv), rec_z=float(pm.Z_rcv), rec_grid=int(pm.n_H_rcv), cpc_nfaces=int(pm.cpc_nfaces), cpc_theta_deg=float(pm.cpc_theta_deg), cpc_h_ratio=float(pm.cpc_h_ratio), cpc_nZ=float(pm.cpc_nZ),
        aperture_angle_x=float(pm.aperture_angle_x), aperture_angle_y=pm.aperture_angle_y, secref_offset=pm.secref_offset, aim_z=float(pm.H_tower), secref_inv_eccen=float(pm.secref_inv_eccen), tilt_secref=float(pm.tilt_secref), rho_secref=float(pm.rho_secref), rho_cpc=float(pm.rho_cpc), slope_error=float(pm.slope_error_bd))

        bd.heliostatfield(field=pm.field_type, hst_rho=pm.rho_helio, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=int(pm.n_helios), R1=pm.R1, fb=pm.fb, dsep=pm.dsep, x_max=150., y_max=150.)

        bd.yaml(sunshape=pm.sunshape,csr=pm.csr,half_angle_deg=pm.half_angle_deg, std_dev=pm.std_dev)

        oelt, A_land=bd.field_design_annual(dni_des=900., num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt), weafile=pm.wea_file, method=1, Q_in_des=pm.Q_in_rcv, n_helios=None, zipfiles=False, gen_vtk=False, plot=False)

        if (A_land==0):
                tablefile=None
        else:
                A_helio=pm.H_helio*pm.W_helio
                output_matadata_motab(table=oelt, field_type=pm.field_type, aiming='single', n_helios=bd.n_helios, A_helio=A_helio, eff_design=bd.eff_des, H_rcv=pm.H_rcv, W_rcv=pm.W_rcv, H_tower=pm.H_tower, Q_in_rcv=bd.Q_in_rcv, A_land=A_land, A_secref=bd.A_secref, A_cpc=bd.A_cpc, savedir=tablefile)

        # Create vtk files and 1D flux map
        # =========

        nd = pm.n_row_oelt
        nh = pm.n_col_oelt

        bd.yaml(sunshape=pm.sunshape,csr=pm.crs,half_angle_deg=pm.half_angle_deg,std_dev=pm.std_dev)

        oelt, A_land=bd.annual_oelt(dni_des=900., num_rays=int(pm.n_rays), nd=int(nd), nh=int(nh), zipfiles=False, gen_vtk=True, plot=False, verbose=True)

        # Read vtk files and produce 1D flux map in csv files
        # =========
        
        dataname = 'Front_faces_Absorbed_flux'
        gencsvannual(casefolder=casedir, vtkname='receiver', savedir=casedir,  dataname=dataname, latitude=pm.lat, deletefolder=True)


    return tablefile



if __name__=='__main__':

    # =========
        case="./test"
        weafile='../../Data/Weather/AUS_WA_Leinster_Airport_954480_TMY.motab'
        ## Variables
        cpc_theta_deg=26.
        cpc_h_ratio=0.6
        aperture_angle_x=160.
        aperture_angle_y=0.
        secref_offset=0.
        secref_inv_eccen=0.7
        H_tower=80.64
        fb=0.9618
        Z_rcv=0.
        tilt_secref=5.
        # fixed parameters
        ## Siumulation
        num_rays=int(5e5)#int(5e6)
        ndays=5#5
        nhours=5#22
        ## Field Characteristics
        sunshape='buie'
        crs=0.02
        lat=-27.85 # Leinster (WA, AUS) degree
        Q_in_rcv=50e6
        field_type = 'surround'
        R1 = 15.
        ## Heliostats
        W_helio=6.1 # ASTRI helio size
        H_helio=6.1
        Z_helio=0.
        ## Beam-Down components: Receiver + Secondary Mirror + CPC
        receiver='beam_down'
        slope_error=1.e-3 # radian
        rho_secref=0.95
        rho_cpc=0.95
        W_rcv=8.
        H_rcv=8.
        cpc_nfaces=4
        n_H_rcv=40

        inputs={'casedir': case, 'wea_file': weafile, 'cpc_theta_deg': cpc_theta_deg, 'cpc_h_ratio': cpc_h_ratio, 'aperture_angle_x': aperture_angle_x, 'aperture_angle_y': aperture_angle_y, 'secref_offset': secref_offset, 'secref_inv_eccen': secref_inv_eccen,
        'H_tower': H_tower, 'fb': fb, 'Z_rcv': Z_rcv, 'tilt_secref': tilt_secref, 'W_rcv': W_rcv, 'H_rcv': H_rcv, 'n_rays': num_rays, 'n_row_oelt': ndays, 'n_col_oelt': nhours, 'sunshape': sunshape, 'crs': crs,'lat': lat, 'Q_in_rcv': Q_in_rcv,
        'field_type': field_type, 'R1': R1, 'W_helio': W_helio, 'H_helio': H_helio, 'Z_helio': Z_helio, 'rcv_type': receiver, 'slope_error': slope_error, 'slope_error_bd': slope_error, 'n_H_rcv': n_H_rcv,
        'rho_secref': rho_secref, 'rho_cpc': rho_cpc, 'cpc_nfaces': cpc_nfaces}

        run_simul(inputs)
