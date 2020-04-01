import os
import sys
import time
import numpy as N
import matplotlib.pyplot as plt
from uncertainties import ufloat
from scipy.interpolate import interp1d,interp2d
import matplotlib.cm as cm
from scipy.optimize import curve_fit

from proces_raw import *
from cal_layout import radial_stagger
from cal_field import *
from cal_sun import *
from gen_YAML import gen_YAML
from gen_vtk import *
from input import Parameters
from output_solartherm import *


class CRS:
    '''
    A Central Receiver System (CRS) that includes three parts, 
    the sun, the field and the receiver.
    '''

    def __init__(self, latitude, casedir):
        '''
        Arguements:
            casedir : str, the directory of the case 
        '''
        self.casedir=casedir
        
        if not os.path.exists(casedir):
            os.makedirs(casedir)
        self.latitude=latitude
        self.sun=SunPosition()


    def heliostatfield(self, field, hst_rho, slope, hst_w, hst_h, tower_h, tower_r=0.01, hst_z=0., num_hst=0., R1=0., fb=0., dsep=0.):

        '''
        Arguements:
            (1) field     : str,
                -- 'polar', 'polar-half', 'surround' or 'surround-half' for desiging a new field 
                -- the directory of the layout file
                    the layout file is a 'csv' file, (n+2, 7)
                   - n is the total number of heliostats 
                   - the 1st row is the number of each column
                   - the 2nd row is the unit 
                   - the first three columns are X, Y, Z coordinates of each heliostat
                   - the fourth column is the focal length
                   - the last three columns are the aiming points
            (2) hst_w     : float, width of a heliostat (m) 
            (3) hst_h     : float, height of a heliostat (m)
            (4) hst_z     : float, the installation height of the heliostat
            (5) hst_rho   : float, reflectivity of heliostat 
            (6) slope     : float, slope error(radians)
            (7) R1        : float, layout parameter, the distance of the first row of heliostat 
            (8) dsep      : float, layout parameter, the separation distance of heliostats (m)
            (9) tower_h    : float, tower height (m)
            (10)tower_r   : float, radius of tower (m)
            (11)num_hst  :   int, number of heliostats used in the field design 
            (12)Q_in_rcv :   int, required heat of the receiver in the field design 
         '''
       
        if field[-3:]=='csv':
            print 'KNOWN FIELD'
            layout=N.loadtxt(field, delimiter=',', skiprows=2)

        else:
            # design a new field            
            savefolder=self.casedir+'/des_point'
            if not os.path.exists(savefolder):
                os.makedirs(savefolder)

            pos_and_aiming=radial_stagger(latitude=self.latitude, num_hst=num_hst, width=hst_w, height=hst_h, hst_z=hst_z, towerheight=tower_h, R1=R1, fb=fb, dsep=0., field=field, savedir=savefolder, plot=False)        
              
            layout=pos_and_aiming[2:, :]

        self.hst_pos=layout[:,:3].astype(float)
        self.hst_foc=layout[:,3].astype(float) 
        self.hst_aims=layout[:,4:].astype(float)
        self.hst_w=hst_w
        self.hst_h=hst_h
        self.hst_rho=hst_rho
        self.slope=slope
        self.tower_h=tower_h    
        self.tower_r=tower_r

    def receiversystem(self, receiver, rec_w=0., rec_h=0., rec_x=0., rec_y=0., rec_z=100., rec_tilt=0., rec_grid=10, rec_abs=1.):

        '''
        Arguements:
            (1) receiver  :   str, 'flat', 'cylinder' or directory of the 'stl', type of the receiver
            (2) rec_w     : float, width of a flat receiver or radius of a cylindrical receiver (m) 
            (3) rec_h     : float, height of the receiver (m)
            (4) rec_x     : float, x location of the receiver (m)
            (5) rec_y     : float, y location of the receiver (m)
            (6) rec_z     : float, z location of the receiver (m)
            (7) rec_tilt  : float, tilt angle of the receiver (deg), 0 is where the receiver face to the horizontal
            (8) rec_grid  :   int, the grid of the receiver, e.g. 100 by 100 mesh elements
            (9) rec_abs   : float, receiver surface absorptivity, e.g. 0.9
        '''
        self.receiver=receiver
        self.rec_abs=rec_abs

        if receiver[-3:]=='stl':
            self.rec_param=N.r_[rec_w, rec_h, receiver, rec_x, rec_y, rec_z, rec_tilt]
        elif receiver=='flat':
            self.rec_param=N.r_[rec_w, rec_h, rec_grid, rec_x, rec_y, rec_z, rec_tilt]
        elif receiver=='cylinder': 
            self.rec_param=N.r_[rec_w, rec_h, rec_grid, rec_x, rec_y, rec_z, rec_tilt]  

        

    def run(self, azimuth, elevation, dni, savefolder, num_rays, yamlfile=None, genvtk_hst=False, visualise=False):
        '''
        Run solstice (one single sun position)

        Arguements:

        azimuth   : float, from East to North (degree)
        elevation : float, 0 is horizontal (degree)
        savefolder:   str, directory for saving the case-related files
        numrays   :   int, number of rays   
        yamlfile  : None or str, None - generate new yaml files for the case
                                 str  - directory of the exsited yaml files 
        genvtk_hst: bool, True - save the heliostat results in vtk
        visualise : bool, True - create file for visualisation (solstice vtk)
        '''
        if self.latitude<0:
            hemisphere='South'
        else:
            hemisphere='North'

        if not os.path.exists(savefolder):
            os.makedirs(savefolder)

        #att_factor=self.get_attenuation_factor()
        att_factor=1e-6
        print 'attenuation', att_factor
        if yamlfile==None:
            gen_YAML(dni, self.sunshape, self.sunsize, self.hst_pos, self.hst_foc, self.hst_aims,  self.hst_w, self.hst_h, self.hst_rho, self.slope, self.receiver, self.rec_param, self.rec_abs, savefolder, hemisphere, self.tower_h, self.tower_r, spectral=False, medium=att_factor, OneHeliostat=False)
            yamlfile=savefolder

        # run solstice
        os.system("solstice -D%s,%s -v -n %s -R %s/input-rcv.yaml -fo %s/simul %s/input.yaml"%(azimuth, elevation, num_rays, yamlfile, savefolder, yamlfile))

        # get results         
        rawfile=savefolder+'/simul'
        Qabs, Qtot, performance_hst=proces_raw_results(rawfile,savefolder,self.hst_rho, dni) 

        if genvtk_hst:       
            self.generateVTK(eta_hst=performance_hst, savevtk=savefolder)

        if visualise:
            # preparing post processing
            os.system('solstice -D%s,%s -g format=obj:split=geometry -fo %s/geom %s/input.yaml'%(azimuth, elevation, savefolder, savefolder))
            os.system('solstice -D%s,%s -q -n 100 -R %s/input-rcv.yaml -p default %s/input.yaml > %s/solpaths'%(azimuth, elevation, savefolder, savefolder, savefolder))
            #
            # postprocessing in C (provided by Cyril Caliot)
            os.system('solppraw %s/simul'%(savefolder))
            os.system('solmaps %s/simul'%(savefolder))
            os.system('solpp %s/geom %s/simul'%(savefolder, savefolder))
            os.system('solpath %s/solpaths'%(savefolder))

        return Qabs, Qtot, performance_hst
     

    def run_annual(self, annualfolder, num_rays, weafile=None, genvtk_hst=False):
        '''
        Annual performance
    
        num_rays: int, number of rays
        designMode: bool,   True - heliostat field design mode
                            False- annual lookup table mode
        '''

        if not os.path.exists(annualfolder):
            os.makedirs(annualfolder)

        run=N.r_[0]
   
        #TODO gen YAML just once, but need to change dni
        #gen_YAML(1000, self.sunshape, self.sunsize, self.hst_pos, self.hst_foc, self.hst_aims,  self.hst_w, self.hst_h, self.hst_rho, self.slope, self.receiver, self.rec_param, self.rec_abs, annualfolder, self.tower_h, self.tower_r, spectral=False, medium=0, OneHeliostat=False)
        # performance of individual heliostat is recorded
        ANNUAL=N.zeros((self.n_helios, 2))   

        for i in xrange(len(self.case_list)):    
            c=int(self.case_list[i,0].astype(float))
            if c not in run:
                azimuth=self.sol_azi[c-1]
                elevation= self.sol_ele[c-1]

                if N.sin(elevation*N.pi/180.)>=1.e-5:
                    dni=1618.*N.exp(-0.606/(N.sin(elevation*N.pi/180.)**0.491))
                else:
                    dni=0.

                print ''
                print ''
                print 'sun position:', (c)
                print 'azimuth:',  azimuth, ', elevation:',elevation

                onesunfolder=annualfolder+'/sunpos_%s'%(c)
                if not os.path.exists(onesunfolder):
                    os.makedirs(onesunfolder) 
                # run solstice
                if elevation<1.:
                    efficiency_total=0.
                    performance_hst=N.zeros((len(self.hst_pos), 2))  
                else:
                    Qabs, Qtot, performance_hst=self.run(azimuth, elevation, dni, savefolder=onesunfolder, num_rays=num_rays, yamlfile=None, genvtk_hst=True, visualise=False)
                    efficiency_total=Qabs/Qtot
                
                ANNUAL+=performance_hst
            else:
                ANNUAL+=performance_hst

            for a in xrange(len(self.table[3:])):
                for b in xrange(len(self.table[0,3:])):
                    val=re.findall(r'\d+',    self.table[a+3,b+3])
                    if val==[]:
                        self.table[a+3,b+3]=0
                    else:
                        if c==float(val[0]):
                            self.table[a+3,b+3]=efficiency_total

            run=N.append(run,c)   
     
        N.savetxt(self.casedir+'/lookup_table.csv', self.table, fmt='%s', delimiter=',')

        if 1:
            self.generateVTK(eta_hst=ANNUAL, savevtk=annualfolder) 
        '''
        QABS=ANNUAL[:,1]
        QTOT=ANNUAL[:,0]
        ETA=N.sum(QABS)/N.sum(QTOT)
        print ''
        print 'annual efficiency', ETA
        N.savetxt(self.casedir+'/eta.csv', [ETA], fmt="%.6f", delimiter=',')
        '''

    def field_design(self, Q_in_des, latitude, dni_des, num_rays, genvtk_hst=False, plot=False):
        '''
        design the field according to parameters at design point
        spring equinox, solar noon

        Q_in_des: float, the required heat of the receiver at design point (W)
        latitude: float, latitude (deg)

        '''   
        designfolder=self.casedir+'/field_design'

        day=self.sun.days(21, 'Mar')
        dec=self.sun.declination(day)
        hra=0. # solar noon

        zen=self.sun.zenith(latitude, dec, hra)
        azi=self.sun.azimuth(latitude, zen, dec, hra)        
        azi_des, ele_des=self.sun.convert_convention('solstice', azi, zen) 
        
        Qabs, Qtot, performance_hst=self.run(azi_des, ele_des, dni_des, designfolder, num_rays, genvtk_hst=genvtk_hst)

        Qin=performance_hst[:,1]
        Qsolar=performance_hst[0,0]
        ID=Qin.argsort()
        ID=ID[::-1]
        power=0.
        select_hst=N.array([])

        for i in xrange(len(ID)):
            if power<Q_in_des:
                idx=ID[i]
                select_hst=N.append(select_hst, idx)
                power+=Qin[idx]

        print 'power @design', power

        select_hst=select_hst.astype(int)

        self.hst_pos= self.hst_pos[select_hst,:]
        self.hst_foc=self.hst_foc[select_hst]
        self.hst_aims=self.hst_aims[select_hst,:]

        self.n_helios=len(select_hst) 
        self.eff_des=power/Qsolar/float(self.n_helios)

        print 'efficiency @design', self.eff_des
        Xmax=max(self.hst_pos[:,0])
        Xmin=min(self.hst_pos[:,0])
        Ymax=max(self.hst_pos[:,1])
        Ymin=min(self.hst_pos[:,1])
        A_land=(Xmax-Xmin)*(Ymax-Ymin)
        print 'land area', A_land

        num_hst=len(self.hst_pos)
        title=N.array([['x', 'y', 'z', 'foc', 'aim x', 'aim y', 'aim z'], ['m', 'm', 'm', 'm', 'm', 'm', 'm']])
        design_pos_and_aim=N.hstack((self.hst_pos, self.hst_foc.reshape(num_hst, 1)))
        design_pos_and_aim=N.hstack((design_pos_and_aim, self.hst_aims))
        #symmetric=design_pos_and_aim
        #symmetric[:, 0]=-symmetric[:, 0]
        #design_pos_and_aim=N.vstack((design_pos_and_aim, symmetric))
        #designed_field=design_pos_and_aim
        design_pos_and_aim=N.vstack((title, design_pos_and_aim))
        N.savetxt(self.casedir+'/pos_and_aiming.csv', design_pos_and_aim, fmt='%s', delimiter=',')

        if plot:
            fts=18
            plt.figure(2)
            fig,ax=plt.subplots()
            XX=self.hst_pos[:,0]
            YY=self.hst_pos[:,1]
            cm = plt.cm.get_cmap('jet')
            cs=plt.scatter(XX,YY,c=Qin[select_hst], cmap=cm, s=60,marker='s')  
            clb=plt.colorbar(cs)
            #clb.ax.set_title(' $\eta$',y=1.,fontsize=fts)
            plt.tight_layout()
            plt.ylabel('y (m)' ,fontsize=fts)
            plt.xlabel('x (m)',fontsize=fts)
            plt.xticks(fontsize=fts)
            plt.yticks(fontsize=fts)
            plt.savefig(self.casedir+"/eta_annual_field.png", bbox_inches='tight')
            plt.close()  
        return power, self.eff_des, A_land

    def field_design_annual(self, method, Q_in_des, n_helios, latitude, dni_des, num_rays, nd, nh, weafile, zipfiles=False, genvtk_hst=False, plot=False):
        '''
        design the field according to parameters at design point
        spring equinox, solar noon

        Q_in_des: float, the required heat of the receiver at design point (W)
        latitude: float, latitude (deg)

        '''  
        designfolder=self.casedir+'/des_point'
        if not os.path.exists(designfolder):
            os.makedirs(designfolder)
        self.annualsolar(nd, nh)
        dni_weight=self.dni_TMY(weafile, nd, nh)
        print ''
        print 'field design'
        day=self.sun.days(21, 'Mar')
        dec=self.sun.declination(day)
        hra=0. # solar noon
 
        zen=self.sun.zenith(latitude, dec, hra)
        azi=self.sun.azimuth(latitude, zen, dec, hra)        
        azi_des, ele_des=self.sun.convert_convention('solstice', azi, zen) 
        
        Qabs, Qtot, performance_hst_des=self.run(azi_des, ele_des, dni_des, designfolder, num_rays, genvtk_hst=genvtk_hst)
        per_helio=N.hstack((self.hst_pos, performance_hst_des))
        N.savetxt(designfolder+'/results-heliostats.csv', per_helio, fmt='%.2f', delimiter=',')        

        os.system('rm %s/simul'%designfolder)
        os.system('rm %s/*yaml'%designfolder)
        os.system('rm %s/*raw*'%designfolder)
        if zipfiles:
            os.system('zip -r -D %s/optical.zip %s'%(self.casedir, designfolder))
            os.system('rm -r %s'%designfolder)

        hst_annual={}
        des_table=self.table
        #if Qabs>=Q_in_des:
        # annual ranking

        run=N.r_[0]
        nhst=len(self.hst_pos)
        ANNUAL=N.zeros(nhst)   

        for i in xrange(len(self.case_list)):    
            c=int(self.case_list[i,0].astype(float))
            if c not in run:
                azimuth=self.sol_azi[c-1]
                elevation= self.sol_ele[c-1]

                if N.sin(elevation*N.pi/180.)>=1.e-5:
                    dni=1618.*N.exp(-0.606/(N.sin(elevation*N.pi/180.)**0.491))
                else:
                    dni=0.
  
                print ''
                print ''
                print 'sun position:', (c)
                print 'azimuth:',  azimuth, ', elevation:',elevation

                onesunfolder=self.casedir+'/sunpos_%s'%(c)
                if not os.path.exists(onesunfolder):
                    os.makedirs(onesunfolder) 
                # run solstice
                if elevation<1.:
                    efficiency_total=0.
                    performance_hst=N.zeros((nhst, 2))  
                    efficiency_hst=N.zeros(nhst)
                else:
                    Qabs, Qtot, performance_hst=self.run(azimuth, elevation, dni, savefolder=onesunfolder, num_rays=num_rays, yamlfile=None, genvtk_hst=genvtk_hst, visualise=False)
                    efficiency_total=Qabs/Qtot
                    efficiency_hst=performance_hst[:,1]/performance_hst[:,0]
                    N.savetxt(onesunfolder+'/results-heliostats.csv', performance_hst, fmt='%.2f', delimiter=',')   
                hst_annual[c]=performance_hst
              
                os.system('rm %s/simul'%onesunfolder)
                os.system('rm %s/*yaml'%onesunfolder)
                os.system('rm %s/*raw*'%onesunfolder)
                if zipfiles:
                    os.system('zip -r -D %s/optical.zip %s'%(self.casedir, onesunfolder))
                    os.system('rm -r %s'%onesunfolder)

            cc=0
            for a in xrange(len(des_table[3:])):
                for b in xrange(len(des_table[0,3:])):
                    val=re.findall(r'\d+', des_table[a+3,b+3])
                    if val==[]:
                        des_table[a+3,b+3]=0
                    else:
                        if c==float(val[0]):
                            #des_table[a+3,b+3]=efficiency_total # this line cause wired problem
                            if cc==0: # avoid adding the symetrical point
                                ANNUAL+=dni_weight[a,b]*efficiency_hst
                                cc+=1
            run=N.append(run,c)               
        N.savetxt(self.casedir+'/annual_hst.csv',ANNUAL, fmt='%.2f', delimiter=',')
 
        Qin=performance_hst_des[:,1]
        Qsolar=performance_hst_des[0,0]
        ID=ANNUAL.argsort()
        ID=ID[::-1]

        select_hst=N.array([])

        if method==1:
            power=0.
            self.Q_in_rcv=Q_in_des
            for i in xrange(len(ID)):
                if power<Q_in_des:
                    idx=ID[i]
                    select_hst=N.append(select_hst, idx)
                    power+=Qin[idx]

            print 'power @design', power
        else:
            num_hst=0
            power=0.
            for i in xrange(len(ID)):
                if num_hst<n_helios:
                    idx=ID[i]
                    select_hst=N.append(select_hst, idx)
                    num_hst+=1
                    power+=Qin[idx]

            self.Q_in_rcv=power
            print 'power @design', power            

        select_hst=select_hst.astype(int)

        self.hst_pos= self.hst_pos[select_hst,:]
        self.hst_foc=self.hst_foc[select_hst]
        self.hst_aims=self.hst_aims[select_hst,:]

        self.n_helios=len(select_hst) 
        self.eff_des=power/Qsolar/float(self.n_helios)

        print 'efficiency @design', self.eff_des
        Xmax=max(self.hst_pos[:,0])
        Xmin=min(self.hst_pos[:,0])
        Ymax=max(self.hst_pos[:,1])
        Ymin=min(self.hst_pos[:,1])
        A_land=(Xmax-Xmin)*(Ymax-Ymin)
        print 'land area', A_land

        num_hst=len(self.hst_pos)
        title=N.array([['x', 'y', 'z', 'foc', 'aim x', 'aim y', 'aim z'], ['m', 'm', 'm', 'm', 'm', 'm', 'm']])
        design_pos_and_aim=N.hstack((self.hst_pos, self.hst_foc.reshape(num_hst, 1)))
        design_pos_and_aim=N.hstack((design_pos_and_aim, self.hst_aims))
        #symmetric=design_pos_and_aim
        #symmetric[:, 0]=-symmetric[:, 0]
        #design_pos_and_aim=N.vstack((design_pos_and_aim, symmetric))
        #designed_field=design_pos_and_aim
        design_pos_and_aim=N.vstack((title, design_pos_and_aim))
        N.savetxt(self.casedir+'/pos_and_aiming.csv', design_pos_and_aim, fmt='%s', delimiter=',')
        N.savetxt(self.casedir+'/selected_hst.csv', select_hst, fmt='%.0f', delimiter=',')


        # lookup table
        oelt=self.table
        run=N.r_[0]
        
        for i in xrange(len(self.case_list)):    
            c=int(self.case_list[i,0].astype(float))
            if c not in run:                
                #sundir=designfolder+'/sunpos_%s'%c
                #res_hst=N.loadtxt(sundir+'/results-heliostats.csv', skiprows=1, delimiter=',')
                res_hst=hst_annual[c]
                Qtot=res_hst[:,0]
                Qin=res_hst[:,1]
                eff=N.sum(Qin[select_hst])/N.sum(Qtot[select_hst])
                print ''
                print 'sun position:', (c), 'eff', eff

            for a in xrange(len(oelt[3:])):
                for b in xrange(len(oelt[0,3:])):
                    val=re.findall(r'\d+',oelt[a+3,b+3])
                    if val==[]:
                        oelt[a+3,b+3]=0
                    else:
                        if c==float(val[0]):
                            oelt[a+3,b+3]=eff

        #N.savetxt(self.casedir+'/lookup_table.csv', oelt, fmt='%s', delimiter=',')

        #else:
        #    print 'bad design'
        #    oelt=0
        #    A_land=0

        return oelt, A_land
        


    def annualsolar(self, nd, nh, sunshape='pillbox', sunsize=0.2664):
        '''
        Arguements:
            nd      :  int, number of points in the declination movement ( -- suggest nd>=5)
            nh      :  int, number of points in the morning in a day
            clearsky: bool, True - clear sky model; False - TMY data
            plotdni : bool, True - plot the dni distribution vs the elevation angle 

        Return:
            sol_azi :
            sol_ele :
            table   :
            case_list:
            vDNI    :
        '''
        # declination angle (deg)  
        # -23.45 ~ 23.45
        nd=int(nd)
        nh=int(nh)

        DELTA=N.linspace(-23.45, 23.45, nd)
        solartime=N.linspace(-180., 180., nh) # deg
        #time=12.+solartime/15 # hour

        table=N.zeros(((nh+3)*(nd+3)))
        table=table.astype(str)
        for i in xrange(len(table)):
            table[i]=''
        table=table.reshape(nd+3, nh+3)
        table[0,0]='Lookup table'
        table[3,0]='Declination (deg)'
        table[0,3]='Hour angle (deg)'

        table[3:,1 ]=N.arange(1,nd+1)
        table[1 ,3:]=N.arange(1,nh+1)

        table[3:,2 ]=DELTA   
        table[2 ,3:]=solartime
     
        c=1
        AZI=N.array([])
        ZENITH=N.array([])

        case_list=N.array(['Case','declination (deg)','solar hour angle (deg)', 'azimuth (deg) S-to-W ', 'zenith (deg)'])        

        for i in xrange(nd):
            delta=DELTA[i]
            hour, sunrise=self.sun.solarhour(delta, self.latitude)
            sunset=-sunrise
            for j in xrange(nh):
                omega=solartime[j]
                if (omega>sunset or omega<sunrise):
                    table[3+i,3+j]='-' 

                else:
                    if omega<0:

                        table[3+i, 3+j]=' case %s'%(c)
                        table[3+i, -(1+j)]='***%s'%(c)

                        #zenith angle
                        theta=self.sun.zenith(self.latitude, delta, omega)
                        # azimuth        
                        phi=self.sun.azimuth(self.latitude, theta, delta, omega)
                        AZI=N.append(AZI, phi)
                        ZENITH=N.append(ZENITH, theta)

                        case_list=N.append(case_list, (c, delta, omega, phi, theta)) 

                        #zenith angle (afternoon)
                        theta=self.sun.zenith(self.latitude, delta, -omega)
                        # azimuth        
                        phi=self.sun.azimuth(self.latitude, theta, delta, -omega)    
                        case_list=N.append(case_list, (c, delta, -omega, phi, theta))                 

                        c+=1

                    elif omega==0:
                        table[3+i, 3+j]=' case %s'%(c)

                        #zenith angle
                        theta=self.sun.zenith(self.latitude, delta, omega)
                        # azimuth        
                        phi=self.sun.azimuth(self.latitude, theta, delta, omega)
                        AZI=N.append(AZI, phi)
                        ZENITH=N.append(ZENITH, theta)

                        case_list=N.append(case_list, (c, delta, omega, phi, theta)) 
                        c+=1
        case_list=case_list.reshape(len(case_list)/5, 5)
         
        # convert to solstice convention
        self.sol_azi, self.sol_ele=self.sun.convert_convention('solstice', AZI, ZENITH)
                             
        self.table=table
        self.case_list=case_list[1:]
        self.sunshape=sunshape
        self.sunsize=sunsize
        #N.savetxt(self.casedir+'/annual_lookup_table.csv', table, fmt='%s', delimiter=',')
        #N.savetxt(self.casedir+'/annual_simulation_list.csv', case_list, fmt='%s', delimiter=',')    


    def dni_TMY(self, weafile, nd, nh):
        '''
        Argument:

        weafile : str, directory of the weather file .motab
        # col0 - time (s)
        # col1 - GHI
        # col2 -DNI (W/m2)
        # col3 -DHI 
            ...
        '''
        with open(weafile) as f:
            content=f.read().splitlines()
        f.close()
        
        lines=len(content)
        seconds=N.array([])
        dni=N.array([])
        for i in xrange(2, lines):
            l=content[i].split(",")  
            seconds=N.append(seconds, l[0])         
            dni=N.append(dni, l[2])
        seconds=seconds.astype(float)
        days=seconds/3600/24
        wea_dec=N.array([])
        for d in days:
            wea_dec=N.append(wea_dec, self.sun.declination(d)) #deg

        wea_hra=((seconds/3600.)%24-12.)*15. #deg
        wea_dni=dni.astype(float)

        hra_lim=180.*(float(nh)/float(nh-1))
        dec_lim=23.45*(float(nd)/float(nd-1))
        hra_bin=N.linspace(-hra_lim, hra_lim, nh+1) 
        dec_bin=N.linspace(-dec_lim, dec_lim, nd+1)
        bins=N.array([hra_bin, dec_bin])


        dni_weight, xbins, ybins=N.histogram2d(wea_hra, wea_dec, bins, weights=wea_dni)

        return dni_weight.T

    def get_attenuation_factor(self):
    
        foc=self.hst_foc.astype(float)

        # to get the attenuation factor
        def func(x, b):
            return N.exp(-b * x)
        def fun_two(x):
            return 0.99321-0.0001176*x+1.97e-8*x**2
        xdata = N.linspace(0, N.max(foc), N.max(foc)*100)
        y = fun_two(xdata)
        ydata = y
        popt, pcov = curve_fit(func, xdata, ydata)
        y2 = [func(i, popt[0]) for i in xdata]
        att_factor =popt[0]
        return att_factor

    def generateVTK(self,eta_hst, savevtk):

        FPF=FieldPF(0., 0., N.r_[0., 1., 0.])
        norms=N.zeros(N.shape(self.hst_pos))
        norms[:,-1]=1.
        COORD, TRI, element, nc=FPF.view_heliostats(width=self.hst_w, height=self.hst_h, normals=norms, hstpos=self.hst_pos)
        NORMS=N.repeat(norms, element, axis=0)

        #field performance
        hst_tot  =eta_hst[:,0]
        rec_abs=eta_hst[:,1]

        hst_eff=rec_abs/hst_tot 

        savevtk=savevtk+'/results-field.vtk'
        TOT=N.repeat(hst_tot, element) 
        ABS=N.repeat(rec_abs, element)   
        EFF=N.repeat(hst_eff, element) 

        DATA={'tot': TOT, 'rec_abs': ABS, 'efficiency':EFF}
        gen_vtk(savedir=savevtk, points=COORD.T, indices=TRI, norms=NORMS, colormap=True, DATA=DATA)

if __name__=='__main__':
    start=time.time()
    casedir='./test-annual-trim'
    pm=Parameters()
    pm.Q_in_rcv=565e6
    pm.nd=8
    pm.nh=25
    pm.H_tower=250.
    pm.H_rcv=24.
    pm.W_rcv=24.
    pm.dependent_par()
    pm.saveparam(casedir)
    print pm.fb
    print pm.H_tower
    crs=CRS(latitude=pm.lat, casedir=casedir)   
    weafile='/home/yewang/solartherm-integration/SolarTherm/Data/Weather/gen3p3_Daggett_TMY3.motab'
    crs.heliostatfield(field=pm.field_type, hst_rho=pm.rho_helio, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios, R1=pm.R1, fb=pm.fb, dsep=pm.dsep)

    crs.receiversystem(receiver=pm.rcv_type, rec_w=float(pm.W_rcv), rec_h=float(pm.H_rcv), rec_x=float(pm.X_rcv), rec_y=float(pm.Y_rcv), rec_z=float(pm.Z_rcv), rec_tilt=float(pm.tilt_rcv), rec_grid=int(pm.n_H_rcv), rec_abs=float(pm.alpha_rcv))

    crs.field_design_annual(Q_in_des=pm.Q_in_rcv, latitude=pm.lat, dni_des=900., num_rays=int(1e6), nd=pm.nd, nh=pm.nh, weafile=weafile, genvtk_hst=False, plot=False)

    end=time.time()
    print 'total time %.2f'%((end-start)/60.), 'min'
 

    #annualfolder=casedir+'/annual'
    #crs.run_annual(annualfolder, num_rays=int(1e6))

    #end=time.time()
    #print 'total time %.2f'%((end-start)/60.), 'min' 

    '''
    annual=N.loadtxt('./annual_hst.csv', delimiter=',')

    hst=crs.hst_pos

    plt.figure(2)
    plt.scatter(hst[:,0].astype(float), hst[:,1].astype(float), c=annual)
    plt.savefig(open('./field.png','w'), bbox_inches='tight')
    plt.close()
    '''
