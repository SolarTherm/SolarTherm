import numpy as N
import matplotlib.pyplot as plt
from cal_field import *
from cal_sun import *
from gen_vtk import gen_vtk
from cal_field import *
from cal_sun import *

def radial_stagger(latitude, num_hst, width, height, hst_z, towerheight, R1, fb, dsep=0., field='polar', savedir='.', plot=False):
    '''
    Ref. (Collado and Guallar, 2012), Campo: Generation of regular heliostat field.

    Generate a rather large field

    Arguements:
    num_hst    : int, number of heliostats
    width      : float, mirror width (m)
    height     : float, mirror height (m)
    hst_z      : float, the vertical location of each heliostat (m)
    towerheight: float, tower height (m)
    R1         : float, distance from the first row to the bottom of the tower (0, 0, 0)
    dsep       : float, separation distance (m)
    field      : str, 'polar-half' or 'surround-half' or 'polar' or 'surround' field, 
                       the 'half' option is for simulation a symmetric field
    savedir    : str, directory of saving the pos_and_aiming.csv

    Return:
    pos_and_aiming: (n, 7) array, position, focal length and aiming point of each generated heliostat
    '''
 
    # heliostat diagonal distantce
    DH=N.sqrt(height**2+width**2) 

    # distance between contiguous helistat center on the X and Y plane
    DM=DH+dsep

    # minimum radial increment
    delta_Rmin=0.866*DM

    # number of heliostats in the first row
    Nhel1 =int(2.*N.pi*R1/DM)


    # the total number of zones (estimated)
    #Nzones=int(N.log(5.44*3*(num_hst/az_rim*N.pi)/Nhel1**2+1)/N.log(4))+1

    X=N.array([])
    Y=N.array([])
    Nrows_zone=N.array([])
    Nhel_zone=N.array([])
    delta_az_zone=N.array([])

    num=0
    i=0
    print 'DM', DM
    print 'dRm', delta_Rmin
    print 'Nhel1', Nhel1

    while num<num_hst*3:
        Nrows= int((2.**(i))*Nhel1/5.44)
        Nhel=(2**(i))*Nhel1
        R=Nhel/2./N.pi*DM
        delta_az=2.*N.pi/Nhel

        Nrows_zone=N.append(Nrows_zone, Nrows)
        Nhel_zone=N.append(Nhel_zone, Nhel)
        delta_az_zone=N.append(delta_az_zone, delta_az)

        print ''
        print 'zone', i
        print 'R', R
        print 'rows', Nrows
        print 'hst', Nhel
        print 'daz', delta_az

        for row in xrange(Nrows):

            r=R+float(row)*delta_Rmin

            for nh in xrange(Nhel):
          
                if row%2==0:
                    # the odd row
                    azimuth=delta_az/2.+float(nh)*delta_az-N.pi/2.
       
                else:
                    # the even row
                    azimuth=float(nh)*delta_az-N.pi/2.
         
                xx=r*N.sin(azimuth)
                yy=r*N.cos(azimuth)
     
                X=N.append(X, xx)
                Y=N.append(Y, yy)
                num+=1
        i+=1
    Nzones=i


    print ''
    print ' Denest field'
    print ' total hst', num

    # expanding the field
    #
    Xexp=N.array([])
    Yexp=N.array([])
    num=0
    sun=SunPosition()
    dd=sun.days(21, 'Mar')
    delta=sun.declination(dd)
    daytime,sunrise=sun.solarhour(delta, latitude)
    Sun_vec=[]
    for h in range(8,17):
        h=h
        omega=-180.+15.*h 
        theta=sun.zenith(latitude, delta, omega)
        phi=sun.azimuth(latitude, theta, delta, omega)
        #print phi,theta
        field1=FieldPF(azimuth=N.r_[phi], zenith=N.r_[theta],receiver_norm=N.r_[0,1,0])
        sun_vec=field1.get_solar_vector(azimuth=N.r_[phi], zenith=N.r_[theta])
        Sun_vec.append(sun_vec)    

    wr=width/height
    const=(1.-(1.-fb)*wr/(2.*wr-(N.sqrt(1.+wr**2)+dsep/height)))*height

    Delta_R=N.array([])
    R=N.array([])
    hst=0 # hst index
    for i in xrange(Nzones):

        Nrows=int(Nrows_zone[i])
        Nhel=int(Nhel_zone[i])
        delta_az=delta_az_zone[i]

        for row in xrange(Nrows):
            if row==0 and i==0: # first row in first zone
    	        r=R1
            for nh in xrange(Nhel):

                if num<num_hst:

                    if row>0:
                        r=R[hst-Nhel]+Delta_R[hst-Nhel]
                    if row ==0 and i>0:
                        if nh%2==0:
                            r=R[hst-Nhel/2-int(nh/2)]+1.5*Delta_R[hst-Nhel/2-int(nh/2)]
                        if nh%2!=0 and nh!=Nhel-1:
                            r=0.5*(R[hst-Nhel/2-int((nh-1)/2)]+1.5*Delta_R[hst-Nhel/2-int((nh-1)/2)]+R[hst-Nhel/2-int((nh+1)/2)]+1.5*Delta_R[hst-Nhel/2-int((nh+1)/2)])
                        if nh==Nhel-1:
                            r=0.5*(R[hst-1]+R[hst-Nhel+1])

                    #if row==0 and Nzones!=0:

                    R=N.append(R,r)

                    pos=N.array([X[hst],Y[hst],hst_z])
                    Cosw=[]
                    CoseT=[]
                    for h in range(len(Sun_vec)):
                        cosw, coseT=field1.cal_cosw_coset(towerheight=towerheight,sun_vec=Sun_vec[h],hst_pos=pos)
                        Cosw.append(cosw)
                        CoseT.append(coseT)
                    cosw=sum(Cosw)/len(Cosw)
                    coseT=sum(CoseT)/len(CoseT)
                    delta_R=cosw/coseT*const
                    delta_R=max(delta_R,delta_Rmin)
                    #print i,row,nh,delta_R,r, delta_R+r
                    Delta_R=N.append(Delta_R,delta_R)

                    if row%2==0:
                        # the odd row
                        azimuth=delta_az/2.+float(nh)*delta_az-N.pi/2.
           
                    else:
                        # the even row
                        azimuth=float(nh)*delta_az-N.pi/2.
             
                    if field=='polar':
                            if i<2:
                                if (azimuth>-N.pi/2. and azimuth<N.pi/2.):
                                    xx=r*N.sin(azimuth)
                                    yy=r*N.cos(azimuth)  
                                    Xexp=N.append(Xexp, xx)
                                    Yexp=N.append(Yexp, yy)   
                                    num+=1
                            else:
                                if azimuth>-N.pi/2.+i*N.pi/40. and azimuth<N.pi/2.-i*N.pi/40.:
                                    xx=r*N.sin(azimuth)
                                    yy=r*N.cos(azimuth)       

                                    Xexp=N.append(Xexp, xx)
                                    Yexp=N.append(Yexp, yy)   
                                    num+=1
  
                    else:                       

                        xx=r*N.sin(azimuth)
                        yy=r*N.cos(azimuth)       

                        Xexp=N.append(Xexp, xx)
                        Yexp=N.append(Yexp, yy)

                        num+=1
                    hst+=1

    num=len(Xexp)
    print ''
    print ' Expanded field'
    print ' total hst ', num

    hstpos=N.zeros(num*3).reshape(num, 3)
    hstpos[:, 0]=Xexp
    hstpos[:, 1]=Yexp
    hstpos[:,2]=hst_z

    # the aiming point is a default point
    # it is required to be revised for receiver performance
    aim_x=N.zeros(num)
    aim_y=N.zeros(num)
    aim_z=N.ones(num)*towerheight

    foc=N.sqrt((Xexp-aim_x)**2+(Yexp-aim_y)**2+(hstpos[:,2]-aim_z)**2)

    pos_and_aiming=N.append(Xexp, (Yexp, hstpos[:,2], foc, aim_x, aim_y, aim_z))
    title=N.array(['x', 'y', 'z', 'foc', 'aim x', 'aim y', 'aim z', 'm', 'm', 'm', 'm', 'm', 'm', 'm'])
    pos_and_aiming=pos_and_aiming.reshape(7,len(pos_and_aiming)/7)
    pos_and_aiming=N.append(title, pos_and_aiming.T)
    pos_and_aiming=pos_and_aiming.reshape(len(pos_and_aiming)/7, 7)
    
    N.savetxt('%s/pos_and_aiming.csv'%savedir, pos_and_aiming, fmt='%s', delimiter=',')

    if plot:
        fts=24
        plt.figure(dpi=100.,figsize=(12,9))
        plt.plot(Xexp, Yexp, '.')
        #plt.xlim(-2000, 2000)
        #plt.ylim(0, 2500)
        plt.xticks(fontsize=fts)
        plt.yticks(fontsize=fts)
        plt.savefig(open('./%s-expand-fb%s-desp.png'%(field, fb),'w'), bbox_inches='tight')
        plt.close()

    return pos_and_aiming


def aiming_cylinder(r_height,r_diameter, pos_and_aiming, savefolder, c_aiming=0.):

	'''
	The aiming method is developed following the deviation-based multiple aiming.
	Reference: Augsburger G. Thermo-economic optimisation of large solar tower power plants[R]. EPFL, 2013.
	The input parameters include:
	r_height: receiver height
	r_diameter: receiver diameter
	c_aiming: an aiming co-efficient
	csv: the field layout file
	'''
	r_radius=0.5*r_diameter
	hst_info=pos_and_aiming[2:].astype(float)
	num_hst=hst_info.size/7
	#print num_hst
	foc=hst_info[:,3] # the focal lenghts of all the heliostats

	# ranked the hsts according to focal lenghts
	hst_info_ranked = hst_info[N.argsort(foc)[::1]]

	for i in range(num_hst):
		
		if (i+1)%2==0: # negative
			hst_info_ranked[i,6]=hst_info_ranked[i,6]+0.5*r_height*c_aiming*(float(num_hst)-1-i)/num_hst
		else:
			hst_info_ranked[i,6]=hst_info_ranked[i,6]-0.5*r_height*c_aiming*(float(num_hst)-1-i)/num_hst
		
		hst_info_ranked[i,4]=hst_info_ranked[i,0]*r_radius/N.sqrt(hst_info_ranked[i,0]**2+hst_info_ranked[i,1]**2)
		hst_info_ranked[i,5]=hst_info_ranked[i,1]*r_radius/N.sqrt(hst_info_ranked[i,0]**2+hst_info_ranked[i,1]**2)
		#print hst_info_ranked[i,0],hst_info_ranked[i,1],hst_info_ranked[i,4],hst_info_ranked[i,5]
		hst_info_ranked[i,3]=N.sqrt((hst_info_ranked[i,0]-hst_info_ranked[i,4])**2+(hst_info_ranked[i,1]-hst_info_ranked[i,5])**2+(hst_info_ranked[i,2]-hst_info_ranked[i,6])**2)


	title=N.array(['x', 'y', 'z', 'foc', 'aim x', 'aim y', 'aim z', 'm', 'm', 'm', 'm', 'm', 'm', 'm'])

	pos_and_aiming_new=N.append(title, hst_info_ranked)
	pos_and_aiming_new=pos_and_aiming_new.reshape(len(pos_and_aiming_new)/7, 7)

	csv_new=savefolder+'/pos_and_aiming.csv'# the output field file
	N.savetxt(csv_new, pos_and_aiming_new, fmt='%s', delimiter=',')

	return hst_info_ranked	



if __name__=='__main__':
    # value in the reference paper: Collado and Guallar, 2012
    # width = 12.3, height=9.75
    # R1=87.5m, R2=175m, R3=350m
    # Nrows1=6, Nrows2=12. Nrows3=25
    # Rmin=13.6m, DM=DH=15.7m
    # Nhel1=35 
    #pos_and_aim=radial_stagger(latitude=34., num_hst=20000, width=12.3, height=9.75, hst_z=1., towerheight=100, R1=87.5, fb=0.7, dsep=0., field='polar', savedir='.', plot=True)
    pos_and_aim=radial_stagger(latitude=34., num_hst=22640, width=10., height=10., hst_z=0., towerheight=250, R1=80, fb=0., dsep=0., field='polar', savedir='.', plot=True)
      
