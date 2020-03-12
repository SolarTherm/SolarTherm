import numpy as N


def gen_vtk(savedir, points, indices, norms, colormap=True, DATA=None):
    '''
    points - x, y, z
    indices - vertices of the triangle mesh
    DATA - dic, key is 'cosine' or 'atm' or others
    num - number of cell data 
    '''
    num_points=len(points.T)
    num_tri=len(indices)
    f=open(savedir, 'w')
    f.write('# vtk DataFile Version 2.0\n')
    f.write('test\n')
    f.write('ASCII\n')
    f.write('DATASET POLYDATA\n')
    f.write('POINTS %s double\n'%num_points)
    for i in xrange(num_points):
        x=points[0,i]
        y=points[1,i]
        z=points[2,i]
        f.write('%.8f %.8f %.8f\n'%(x, y, z))
    f.write('POLYGONS %s %s\n'%(num_tri, num_tri*4))
    for i in xrange(num_tri):
        id1=indices[i,0]
        id2=indices[i,1]
        id3=indices[i,2]
        f.write('3 %.0f %.0f %.0f\n'%(id1, id2, id3))  
    f.write('CELL_DATA %s\n'%(num_tri))
    f.write('NORMALS cell_normals float\n')

    for i in xrange(num_tri):
        nx=norms[i,0]
        ny=norms[i,1]
        nz=norms[i,2]
        
        f.write('%.8f %.8f %.8f\n'%(nx, ny, nz))  
        

    if colormap:    

        totalnum=len(DATA)         
        f.write('FIELD PrimaryData %s\n'%(totalnum))
        interest=DATA.keys()
        for m in interest:
            f.write('%s 1 %s double\n'%(m, num_tri))
            for i in xrange(num_tri):
                f.write('%.8f\n'%(DATA[m][i]))            

       
        f.close()


if __name__=='__main__':
    gen_vtk()

