import numpy as N
import os


class Parameters:

    def __init__(self):
        '''
        default parameters

        e.g. a 50 MWe power plant (Yogi Goswami, Principles of Solar Engineering, Third Edition, page 480, section 8.8)
             design point DNI 950 W/m2, SM=1.8
             the required field rating is 305 MW
             the total reflector area is approximated as 483,000 m2
             tower height 137 m for a surround field, 183 m for a polar field

            for PS10, the annual capacity of the field is around 120GWh
        '''
        self.Sun()
        self.Heliostat()
        self.Receiver()
        self.simulation()
        self.dependent_par()

    def Sun(self):
        '''
            (1) lat       : float, latitude of the plant lcation
            (2) dni_des       : float, dni at design point (W/m2)   
            (3) sunshape  :   str, 'pillbox' or 'Buie' 
            (4) sunsize   : float, 
                -- for 'pillbox': half angle of the pillbox sunshape (degree)
                -- for 'Buie': circumsolar ratio (CSR)  

            (5) extinction: float, around 1e-6, the extinction coefficient if the atmosphere is surrounded by participant medium
        '''
        self.lat=37.44 # latitude, default: location of PS10
        self.dni_des=1000.
        self.sunshape='pillbox'
        self.sunsize=4.65*1.e-3*180./N.pi # convert rad to degree --> solstice convention
        self.extinction=1e-6
        self.wea_file=None



    def Heliostat(self):
        '''
            (1) field_type : str,
                -- 'polar', 'polar-half', 'surround' or 'surround-half' for desiging a new field 
                -- the directory of the layout file
                    the layout file is a 'csv' file, (n+2, 7)
                   - n is the total number of heliostats 
                   - the 1st row is the number of each column
                   - the 2nd row is the unit 
                   - the first three columns are X, Y, Z coordinates of each heliostat
                   - the fourth column is the focal length
                   - the last three columns are the aiming points
            (2) Q_in_rcv   : float, required heat of the receiver (W)
            (3) W_helio    : float, width of a heliostat (m) 
            (4) H_helio    : float, height of a heliostat (m)
            (5) slope_error: float, slope error(radians)
            (6) rho_helio  : float, reflectivity of heliostat 
            (7) H_tower    : float, tower height (m)
            (8) R_tower    : float, radius of tower (m)
            (9) concret_tower: bool, True-a solid concrete tower, or False-a truss tower
            (10)single_filed : bool, True-one tower one field, or False-multi-tower
            (11)R1         : float, layout parameter, the distance of the first row of heliostat 
            (12)dsep       : float, layout parameter, the separation distance of heliostats (m)
            (13)fb         : float, in (0-1), a factor to expand the field to reduce block 
            ---(*) n_helios:   int, number of heliostats for the designed field 
            ---(*) Z_helio : float, the installation height of the heliostat
        '''

        self.field_type='polar'
        self.Q_in_rcv=10e6 # required heat of the receiver  
        self.W_helio=10.
        self.H_helio=10.
        self.slope_error=2.e-3 # radian
        self.rho_helio=0.9
        self.H_tower=100.
        self.R_tower=0.001  # shading effect of tower is neglected at the moment
        self.concret_tower=False
        self.single_field=True 

        self.R1=90.
        self.dsep=0.
        self.fb=0.7

    def Receiver(self):
        '''
            (1) rcv_type  :   str, 'flat', 'cylinder', 'particle' or 'stl', type of the receiver
            (2) H_rcv     : float, height of a flat receiver or radius of a cylindrical receiver (m) 
            (3) W_rcv     : float, width of the receiver (m)
            (4) tilt_rcv  : float, tilt angle of the receiver (deg), 0 is where the receiver face to the horizontal
            (5) alpha_rcv : float, receiver surface absorptivity (0-1), set as 1 if rcv_type='particle'
            (6) n_H_rcv   :   int, number of discretisation of the receiver in the height direction
            (7) n_W_rcv   :   int, number of discretisation of the receiver in the width direction (for a flat receiver) 
                                    or in the circular direction (for a cylindrical receiver) 
            (8) X_rcv     : float, x location of the receiver (m)
            (9) Y_rcv     : float, y location of the receiver (m)
            ---(*) z_rcv  : float, z location of the receiver (m)

        '''
        self.rcv_type='flat'
        self.H_rcv=10.
        self.W_rcv=10.
        self.tilt_rcv=0. # receiver tilt angle
        self.alpha_rcv=1. 
        self.n_H_rcv=10
        self.n_W_rcv=10
        self.X_rcv=0. # receiver location
        self.Y_rcv=0.


    def simulation(self):
        '''
        n_row_oelt: int, number of rows of the lookup table (i.e. simulated days per year)
        n_col_oelt: int, number of columns of the lookup table (i.e. simulated number of hours per day)
        n_rays    : int, number of rays for the simulation
        n_procs   : int, number of processors for the mcrt simulation 
        casedir   : str, the directory for saving the result files
        '''  
        self.n_row_oelt=5
        self.n_col_oelt=5
        self.n_rays=int(1e6)
        self.n_procs=1
        self.casedir='.'

    def dependent_par(self):
        '''
        '''
        self.Z_helio=self.H_helio*0.7
        self.Z_rcv=self.H_tower        
        if self.lat>=0:
            self.hemisphere='North'
        elif self.lat<0:
            self.hemisphere='South'

       # estimate a rough number of large field
        eta_field=0.4 # assumed field effieicy at design point
        self.n_helios=self.Q_in_rcv/self.W_helio/self.H_helio/self.dni_des/eta_field
        if self.field_type=='polar':
            self.n_helios*=2.  

    def saveparam(self, savedir):
        if not os.path.exists(savedir):
            os.makedirs(savedir)
    
        param=N.array([
    
              ['field', self.field_type, '-'],  
              ['Q_in_rcv', self.Q_in_rcv, 'W'],      
              ['n_helios(pre_des)', self.n_helios, '-'],    
              ['W_helio', self.W_helio, 'm'],    
              ['H_helio', self.H_helio, 'm'],
              ['Z_helio', self.Z_helio, 'm'],      
              ['rho_helio', self.rho_helio, '-'],    
              ['slope_error', self.slope_error, 'rad'],
              ['H_tower', self.H_tower, 'm'],    
              ['R_tower', self.R_tower, 'm'], 
              ['concret_tower', self.concret_tower, '-'],    
              ['single_field', self.single_field, '-'],  
              ['fb factor', self.fb, '-'],     
              ['R1', self.R1, 'm'],    
              ['dsep', self.dsep, 'm'],    
              ['rcv_type', self.rcv_type, '-'],  
              ['H_rcv', self.H_rcv, 'm'],
              ['W_rcv', self.W_rcv, 'm'],   
              ['tilt_rcv', self.tilt_rcv, 'deg'],  
              ['alpha_rcv', self.alpha_rcv, '-'],  
              ['n_H_rcv', self.n_H_rcv, '-'],   
              ['n_W_rcv', self.n_W_rcv, '-'],    
              ['X_rcv', self.X_rcv, 'm'],   
              ['Y_rcv', self.Y_rcv, 'm'],   
              ['Z_rcv', self.Z_rcv, 'm'],   
              ['n_row_oelt', self.n_row_oelt, '-'] , 
              ['n_col_oelt', self.n_col_oelt, '-'] ,
              ['n_rays', self.n_rays, '-'] ,
              ['n_procs', self.n_procs, '-'] 
              ])


        N.savetxt(savedir+'/simulated_parameters.csv', param, delimiter=',', fmt='%s')
    





                
            

        
