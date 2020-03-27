import numpy as N
#from tracer.models.heliostat_field import solar_vector
#import matplotlib.pyplot as plt
from scipy.spatial import Delaunay
from gen_vtk import gen_vtk

class FieldPF:

    def __init__(self, receiver_norm=N.r_[0,1,0]):
        '''
        Evaluation of field initial performance
        1. cosine factors: sun - heliostat
        2. another cosine factors: receiver -heliostat
        
        azimuth: float, the solar azimuth angle, from South to West
        zenith: float, the solar zenith angle, 0 from vertical
        receiver_normal: (3,) array, normal vector of the receiver aperature 

        '''
        #self.sun_vec=self.get_solar_vector(azimuth, zenith)
        self.rec_norm=receiver_norm.reshape(3,1)



    def get_solar_vector(self, azimuth, zenith):
        """
        Calculate the solar vector using elevation and azimuth.

        Arguments:
        azimuth - the sun's azimuth, in deg, 
	        from South increasing towards to the West
        zenith - angle created between the solar vector and the Z axis, in deg.

        Returns: a 3-component 1D array with the solar vector.
        """
        #copied from tracer.models.heliostat_field import solar_vector
        #TODO change it to Solstice convetion if necessary

        azimuth*=N.pi/180.
        zenith*=N.pi/180.

        sun_z = N.cos(zenith)
        sun_y=-N.sin(zenith)*N.cos(azimuth)
        sun_x=-N.sin(zenith)*N.sin(azimuth)
        sun_vec = N.r_[sun_x, sun_y,sun_z] 


        return sun_vec

    def get_normals(self, towerheight, hstpos, sun_vec):

        tower_vec=-hstpos
        tower_vec[:,-1]+=towerheight
        tower_vec/=N.sqrt(N.sum(tower_vec**2, axis=1)[:,None])

        hst_norms=sun_vec+tower_vec
        hst_norms/=N.sqrt(N.sum(hst_norms**2, axis=1)[:,None])        
        return hst_norms

    def get_rec_view(self, towerheight, hstpos):
        # angle between normal of the receiver apterture and the RH
        # RH is the vector from the receiver to the heliostat (i.e. -tower_vec)

        tower_vec=-hstpos
        tower_vec[:,-1]+=towerheight
        tower_vec/=N.sqrt(N.sum(tower_vec**2, axis=1)[:,None])

        view=N.arccos(N.dot(-tower_vec, self.rec_norm))
        view=view.flatten()
        vis_idx=(view<1.5) # the heliostat that can be seen by the receiver

        return vis_idx


    def get_cosine(self,hst_norms, sun_vec):
 
        cos_factor=N.sum(hst_norms*sun_vec, axis=1)

        return cos_factor

    def heliostat(self, width, height ):
        '''
        the local coordinate of the heliostat
        '''
        x=N.linspace(-width/2., width/2., 2)
        y=N.linspace(-height/2., height/2., 2)
        
        xx, yy=N.meshgrid(x, y)
        coords=N.column_stack([xx.ravel(),yy.ravel()])   
        tri=Delaunay(coords).simplices
        #plt.figure(1) 
        #plt.triplot(coords[:,0], coords[:,1], tri)   
        #plt.show()
        return coords, tri

    def view_heliostats(self, width, height, normals, hstpos):
        
        coord1, tri1=self.heliostat(width, height)

        ele=len(tri1)
        nc=len(coord1)

        num_hst=len(hstpos)

        COORD=N.zeros(num_hst*nc*3).reshape(num_hst*nc, 3)
        TRI=N.zeros(num_hst*ele*3).reshape(num_hst*ele, 3)

        norm_x=normals[:,0]
        norm_y=normals[:,1]
        norm_z=normals[:,2]          
  
        for i in xrange(num_hst):            
         
            TRI[i*ele: (i+1)*ele]=tri1+i*nc

            trans = N.eye(4)
            trans[:3,3] = hstpos[i]

            x=coord1[:,0]
            y=coord1[:,1]
            z=float(hstpos[i,2])*N.ones(nc)  

            cd=N.vstack((x, y, z, N.ones(nc)))   
            cd_t=N.dot(trans, cd)

            xx=cd_t[0]
            yy=cd_t[1]
            zz=cd_t[2]

            COORD[i*nc: (i+1)*nc,0]=xx
            COORD[i*nc: (i+1)*nc,1]=yy
            COORD[i*nc: (i+1)*nc,2]=zz

        #plt.figure(1) 
        #plt.triplot(COORD[:,0], COORD[:,1], TRI)   
        #plt.show()        
        return COORD, TRI, ele, nc

    def plot_cosine(self, savename,pm):
        x=self.hstpos[:,0]
        y=self.hstpos[:,1]
        z=self.hstpos[:,2]
        av=(self.view<N.pi/2.)
        plt.figure(1)
        cm = plt.cm.get_cmap('rainbow')
        cs=plt.scatter(x[av], y[av], c=self.cosine_factor[av], cmap=cm,s=30)
        plt.colorbar(cs)
        plt.title('Cosine factors\n Tower height %s m'%pm )
        plt.savefig(open(savename, 'w'),dpi=500, bbox_inches='tight')
        plt.close()	


    def plot_select(self, savename,pm):
        x=self.hstpos[:,0]
        y=self.hstpos[:,1]
        z=self.hstpos[:,2]

        plt.figure(1)
        fig,ax1=plt.subplots()
        cm = plt.cm.get_cmap('rainbow')
     
        av=(self.view<1.5)
        cs=plt.scatter(x[av], y[av], c=self.view[av], cmap=cm)
        plt.colorbar(cs)
        nv=(self.view>=1.5)
        plt.scatter(x[nv], y[nv], c='gray')
        plt.title('Receiver view \n tilt %s deg'%pm )
        #plt.title('Receiver view \n Tower height %s m'%pm )
        plt.savefig(open(savename, 'w'),dpi=500, bbox_inches='tight')
        plt.close()	
       
def rotx(ang):
    """Generate a homogenous trransform for ang radians around the x axis"""
    s = N.sin(ang); c = N.cos(ang)
    return N.array([
        [1., 0, 0, 0],
        [0, c,-s, 0],
        [0, s, c, 0],
        [0, 0, 0, 1.]
    ])

def roty(ang):
    """Generate a homogenous trransform for ang radians around the y axis"""
    s = N.sin(ang); c = N.cos(ang)
    return N.array([
        [c, 0, s, 0],
        [0, 1., 0, 0],
        [-s,0, c, 0],
        [0, 0, 0, 1.]
    ])

def rotz(ang):
    """Generate a homogenous trransform for ang radians around the z axis"""
    s = N.sin(ang); c = N.cos(ang)
    return N.array([
        [c,-s, 0, 0],
        [s, c, 0, 0],
        [0, 0, 1., 0],
        [0, 0, 0, 1.]
    ])

def translate(x=0, y=0, z=0):
    """Generate a homogenous transform for translation by x, y, z"""
    return N.array([
        [1., 0, 0, x],
        [0, 1., 0, y],
        [0 ,0, 1., z],
        [0, 0, 0, 1.]
    ])
          

if __name__=='__main__':
    #pos_and_aiming=N.loadtxt('/media/yewang/Work/svn_ye/Solstice-tutorial/cases/2-Validation/layout.csv', delimiter=',', skiprows=2)
    pos_and_aiming=N.loadtxt('./pos_and_aiming.csv', delimiter=',', skiprows=2)
    pos=pos_and_aiming[:,:3]
    aim=pos_and_aiming[:,4:]
    azimuth=N.r_[0.]
    zenith=N.r_[12.]
    field=FieldPF(azimuth, zenith,N.r_[0,1,0])
    sun_vec=field.get_solar_vector(azimuth, zenith)
    norms=field.get_normals(towerheight=70., hstpos=pos, sun_vec=sun_vec)
    #field.heliostat(10, 8)
    COORD, TRI, ele, nc=field.view_heliostats(10., 8., norms, pos)
    cos=field.get_cosine(towerheight=70., hstpos=pos)
    savedir='./field.vtk'
    COS=N.repeat(cos, ele)
    DATA={'cos':COS}
    NORMS=N.repeat(norms, ele, axis=0)
    gen_vtk(savedir, COORD.T, TRI, NORMS, True, DATA)
        
