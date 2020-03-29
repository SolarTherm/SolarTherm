import numpy as N
from datetime import datetime

def output_motab(table,savedir=None):
    '''
    output the .motab table fiel
    '''
    f=open(savedir, 'w')
    f.write('#1\n')
    

    # size of the lookup table
    m=N.shape(table)[0]-2
    n=N.shape(table)[1]-2
    f.write('double optics(%s, %s)\n'%(m,n))

    hour_angle=table[2, 3:]
    declination=table[3:,2]

    for i in xrange(m):
        if i ==0:
            row_i=N.append(0, hour_angle)
        else:
            row_i=N.append(declination[i-1], table[2+i, 3:])

        #content=N.array2string(row_i, formatter={'float_kind':lambda x: "%.2f" % row_i})
        #content=N.array2string(row_i, precision=2, separator=' ', suppress_small=True)
        #f.write(content+'\n')
        f.write(" ".join(map(str, row_i)))
        f.write("\n")

    f.close()


def output_matadata_motab(table, field_type, aiming, n_helios, A_helio, eff_design, H_rcv, W_rcv, H_tower, Q_in_rcv, A_land, savedir=None):
    '''
    output the .motab table fiel
    '''
    f=open(savedir, 'w')
    f.write('#1\n')
    f.write('#Comments: Field type: %s, Aiming Strategy: %s, Date:%s\n'%(field_type, aiming, datetime.now()))
    f.write('#METALABELS,n_helios,A_helio,Eff_design,H_rcv,W_rcv,H_tower, Q_in_rcv, A_land\n')
    f.write('##METAUNITS,real,m2,real,m,m,m,W,m2\n')
    f.write('#METADATA,%s,%s,%s,%s,%s,%s,%s,%s\n'%(n_helios,A_helio,eff_design,H_rcv,W_rcv,H_tower,Q_in_rcv,A_land))

    # size of the lookup table
    m=N.shape(table)[0]-2
    n=N.shape(table)[1]-2
    f.write('double optics(%s, %s)\n'%(m,n))

    hour_angle=table[2, 3:]
    declination=table[3:,2]

    for i in xrange(m):
        if i ==0:
            row_i=N.append(0, hour_angle)
        else:
            row_i=N.append(declination[i-1], table[2+i, 3:])

        #content=N.array2string(row_i, formatter={'float_kind':lambda x: "%.2f" % row_i})
        #content=N.array2string(row_i, precision=2, separator=' ', suppress_small=True)
        #f.write(content+'\n')
        f.write(" ".join(map(str, row_i)))
        f.write("\n")

    f.close()
