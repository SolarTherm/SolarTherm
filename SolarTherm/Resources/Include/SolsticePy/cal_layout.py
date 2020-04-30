import numpy as N
import matplotlib.pyplot as plt
from cal_sun import *
from gen_vtk import gen_vtk


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

    X={}
    Y={}
    Nrows_zone=N.array([])
    Nhel_zone=N.array([])
    delta_az_zone=N.array([])

    num=0
    i=0
    print ''
    print 'total_hst', num_hst
    #print 'DM', DM
    #print 'dRm', delta_Rmin
    #print 'Nhel1', Nhel1

    while num<num_hst*3:
        Nrows= int((2.**(i))*Nhel1/5.44)
        Nhel=(2**(i))*Nhel1
        R=Nhel/2./N.pi*DM
        delta_az=2.*N.pi/Nhel

        Nrows_zone=N.append(Nrows_zone, Nrows)
        Nhel_zone=N.append(Nhel_zone, Nhel)
        delta_az_zone=N.append(delta_az_zone, delta_az)

        #print ''
        #print 'zone', i
        #print 'R', R
        #print 'rows', Nrows
        #print 'hst', Nhel
        #print 'daz', delta_az


        nh=N.arange(Nhel)
        azimuth=N.zeros((int(Nrows), int(Nhel)))
        azimuth[0::2, :]=delta_az/2.+nh*delta_az-N.pi/2. # the odd rows
        azimuth[1::2, :]=nh*delta_az-N.pi/2.

        row=N.arange(Nrows)
        r=R+row*delta_Rmin
    
        xx=r[:, None]*N.sin(azimuth)
        yy=r[:, None]*N.cos(azimuth)

        X[i]=xx
        Y[i]=yy
        num+=len(xx.flatten())
        i+=1

    Nzones=i


    print ''
    print 'Denest field', num

    if field=='surround':
        num_hst*=2
    # expanding the field
    #

    wr=width/height
    const=(1.-(1.-fb)*wr/(2.*wr-(N.sqrt(1.+wr**2)+dsep/height)))*height

    XX=N.array([])
    YY=N.array([])
    for i in xrange(Nzones):

        Nrows=int(Nrows_zone[i])
        Nhel=int(Nhel_zone[i])
        delta_az=delta_az_zone[i]

        R=N.zeros((Nrows, Nhel))
       
        if i==0:
            # first zone
            R[0]=R1 # first row

        else:
            # second zones
            R[0,  ::2]=Rn+1.5*DRn
            R[0,  1::2]=Rn+1.5*DRn            
            #R[0,-1]=0.5*(R[0,0]+Rn[-1])

        xx=X[i]
        yy=Y[i]
        zz=N.ones(N.shape(xx))*hst_z
        cosw, coseT=cal_cosw_coset(latitude, towerheight,xx, yy, zz)
        row=N.arange(Nrows)
        cosw=cosw.reshape(Nrows, Nhel)  
        coseT=coseT.reshape(Nrows, Nhel)

        Delta_R=cosw/coseT*const
        Delta_R[Delta_R<delta_Rmin]=delta_Rmin

        for j in xrange(1, Nrows):
            R[j]=R[j-1]+Delta_R[j-1]
  
        Rn=R[-1]
        DRn=Delta_R[-1]

        nh=N.arange(Nhel)
        azimuth=N.zeros((Nrows, Nhel))
        azimuth[0::2, :]=delta_az/2.+nh*delta_az-N.pi/2. # the odd rows
        azimuth[1::2, :]=nh*delta_az-N.pi/2.

        azimuth=azimuth.flatten()
        R=R.flatten()
        if field=='polar':
            if i<2:
                idx= (azimuth>-N.pi/2.)*(azimuth<N.pi/2.)

            else:
                idx=(azimuth>-N.pi/2.+i*N.pi/40.)* (azimuth<N.pi/2.-i*N.pi/40.)

            xx=R[idx]*N.sin(azimuth[idx])
            yy=R[idx]*N.cos(azimuth[idx])

        else:                       
            xx=R*N.sin(azimuth)
            yy=R*N.cos(azimuth)       
        XX=N.append(XX, xx)
        YY=N.append(YY, yy)

    num_hst=int(num_hst)
    XX=XX[:num_hst]
    YY=YY[:num_hst]
    print 'expanded field', num_hst

    hstpos=N.zeros(num_hst*3).reshape(num_hst, 3)
    hstpos[:, 0]=XX
    hstpos[:, 1]=YY
    hstpos[:,2]=hst_z

    # the aiming point is a default point
    # it is required to be revised for receiver performance
    aim_x=N.zeros(num_hst)
    aim_y=N.zeros(num_hst)
    aim_z=N.ones(num_hst)*towerheight

    foc=N.sqrt((XX-aim_x)**2+(YY-aim_y)**2+(hstpos[:,2]-aim_z)**2)

    pos_and_aiming=N.append(XX, (YY, hstpos[:,2], foc, aim_x, aim_y, aim_z))
    title=N.array(['x', 'y', 'z', 'foc', 'aim x', 'aim y', 'aim z', 'm', 'm', 'm', 'm', 'm', 'm', 'm'])
    pos_and_aiming=pos_and_aiming.reshape(7,len(pos_and_aiming)/7)
    pos_and_aiming=N.append(title, pos_and_aiming.T)
    pos_and_aiming=pos_and_aiming.reshape(len(pos_and_aiming)/7, 7)
    
    N.savetxt('%s/pos_and_aiming.csv'%savedir, pos_and_aiming, fmt='%s', delimiter=',')

    if plot:
        fts=24
        plt.figure(dpi=100.,figsize=(12,9))
        plt.plot(XX, YY, '.')
        #plt.xlim(-2000, 2000)
        #plt.ylim(0, 2500)
        plt.xticks(fontsize=fts)
        plt.yticks(fontsize=fts)
        #plt.savefig(open('./%s-expand-fb%s-desp.png'%(field, fb),'w'), bbox_inches='tight')
        plt.show()
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


def cal_cosw_coset(latitude, towerheight, xx, yy, zz):
    '''
    towerheight: tower height
    xx, yy, zz: coordinates of heliostats

    cosw is cos(omega)
    coset is cos(epsilon_T) 
    see eq.(2) Francisco J. Collado, Jesus Guallar, Campo: Generation of regular heliostat fields, 2012
    '''

    hst_pos=N.append(xx, (yy, zz))
    hst_pos=hst_pos.reshape(3, len(xx.flatten())) # 3 x n
    tower_vec=-hst_pos
    tower_vec[-1]+=towerheight
    tower_vec/=N.sqrt(N.sum(tower_vec**2, axis=0)) # 3 x n
    unit=N.array([[0.], [0.], [1.]])
    unit=N.repeat(unit, len(tower_vec[0]), axis=1)
    coseT=N.sum(tower_vec*unit, axis=0)

    sun=SunPosition()
    dd=sun.days(21, 'Mar')
    delta=sun.declination(dd)
    h=N.arange(8, 17)

    latitude=latitude/180.*N.pi
    delta=delta/180.*N.pi
    omega=(-180.+15.*h)/180.*N.pi
    theta=N.arccos(N.cos(latitude)*N.cos(delta)*N.cos(omega)+N.sin(latitude)*N.sin(delta))

    a1=N.cos(theta)*N.sin(latitude)-N.sin(delta)
    a2=N.sin(theta)*N.cos(latitude)
    b=a1/a2
    phi=abs(N.arccos((N.cos(theta)*N.sin(latitude)-N.sin(delta))/(N.sin(theta)*N.cos(latitude)))) # unit radian
    phi[abs(b+1.)<1e-10]=N.pi
    phi[abs(b-1.)<1e-10]=0.
    phi[omega<0]=-phi[omega<0]
     
    cosw=N.zeros(len(tower_vec[0]))
    sun_z = N.cos(theta)
    sun_y=-N.sin(theta)*N.cos(phi)
    sun_x=-N.sin(theta)*N.sin(phi)
    sun_vec = N.append(sun_x, (sun_y, sun_z))
    sun_vec=sun_vec.reshape(3, len(sun_x)) # 3xs

    for i in xrange(len(sun_vec[0])):
        sv=N.repeat(sun_vec[:,i], len(tower_vec[0])).reshape(3, len(tower_vec[0]))
        hst_norms=sv+tower_vec
        hst_norms/=N.linalg.norm(hst_norms, axis=0)
        cosw+=N.sum(sv*hst_norms, axis=0)
    cosw/=float(len(sun_vec[0]))
    return cosw, coseT



if __name__=='__main__':
    # value in the reference paper: Collado and Guallar, 2012
    # width = 12.3, height=9.75
    # R1=87.5m, R2=175m, R3=350m
    # Nrows1=6, Nrows2=12. Nrows3=25
    # Rmin=13.6m, DM=DH=15.7m
    # Nhel1=35 
    #pos_and_aim=radial_stagger(latitude=34., num_hst=20000, width=12.3, height=9.75, hst_z=1., towerheight=100, R1=87.5, fb=0.7, dsep=0., field='polar', savedir='.', plot=True)
    pos_and_aim=radial_stagger(latitude=34., num_hst=22640, width=10., height=10., hst_z=0., towerheight=250, R1=80, fb=0., dsep=0., field='polar', savedir='.', plot=True)
      
