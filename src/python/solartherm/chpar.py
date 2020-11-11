#!/usr/bin/env python
'''
change simulation parameters

# set in solartherm
#==================
# SM
# H_tower
# fb
# U_value
# t_storage

# optical model
#=================
# wea_file='gen3p3_Daggett_TMY3.motab'
# dni_des=909.06
# W_helio=10
# H_helio=10
# rho_helio=0.9
# slope_error=2e-3
# H_tower=200
# n_row_oelt=8
# n_col_oelt=25
# H_rcv
# W_rcv
# Q_in_rcv

# fb
# R1
'''
import numpy as N
import xml.etree.ElementTree as ET
import xml
import json

class ProcesXML:
    
    def __init__(self, xmlfile):
        print ''
        print ''
        print 'START'

        self.xmlfile=xmlfile
        self.init_et=ET.parse(self.xmlfile) 
        self.root=self.init_et.getroot() 

    def read_par(self, par_name):   
        val=self.root.find('*ScalarVariable[@name=\''+par_name+'\']/*[@start]').attrib['start']
        return val

    def write_par(self, par_n, par_v, one=True):
        
        if one:
            self.root.find('*ScalarVariable[@name=\''+par_n+'\']/*[@start]').attrib['start']=par_v

        else:
            for i, n in enumerate(par_n):
                print i, n, par_v[i]
                self.root.find('*ScalarVariable[@name=\''+n+'\']/*[@start]').attrib['start']=par_v[i]

        self.init_et.write(self.xmlfile)            


class SetPar:

    def __init__(self, jsonfile, mofile):

        with open(jsonfile) as f:
            self.content = json.load(f)
            # content is a list with lots of string
        f.close()

        with open(mofile) as f:
            self.src = f.read().splitlines()
            # content is a list with lots of string
        f.close()
        self.mofile=mofile


    def set_par(self, par_n, par_v):
        for i, n in enumerate(par_n):
            par_v[i]=float(par_v[i])
            if par_v[i]>100:
                par_v[i]='%.0f'%par_v[i]
            elif par_v[i]>10:
                par_v[i]='%.1f'%par_v[i]
            elif par_v[i]>0.1:
                par_v[i]='%.2f'%par_v[i]
            elif par_v[i]>0.01:
                par_v[i]='%.3f'%par_v[i]
            elif par_v[i]>0.01:
                par_v[i]='%.4f'%par_v[i]
            elif par_v[i]>1e-3:
                par_v[i]='%.4f'%par_v[i]
            elif par_v[i]>1e-6:
                par_v[i]='%.7f'%par_v[i]    
            elif par_v[i]>1e-13:
                par_v[i]='%.13f'%par_v[i]         

            info=self.content["variables"][n]
            ln=info['source']['info']['lineEnd'] # line number
            line=self.src[int(ln)-1].split(" ") # content in that line in .mo 
            t=0
            for s in xrange(len(line)-1):
                if line[s]=='=':
                    t=s+1
            line[t]=str(par_v[i])
                    
            self.src[int(ln)-1]=" ".join(line)
            print self.src[int(ln)-1]
        newfile='\n'.join(self.src)

        outF = open(self.mofile, "w")
        outF.writelines(newfile)
        outF.close()


if __name__=='__main__':
    mofile='/home/660/yxw660/test-auto/Reference_2.mo'
    jsonfile='/home/660/yxw660/test-auto/Reference_2_info.json'
    sp=SetPar(jsonfile, mofile)
    sp.set_par(['SM', 't_storage'], [3, 24])

    '''
    xmlfile='/home/660/yxw660/test-auto/Reference_2_init.xml'

    pxml=ProcesXML(xmlfile)
    val=pxml.read_par('SM')
    print 'sm=', val
    val=pxml.read_par('t_storage')
    print 't_storage=', val     

    par_n=['t_storage', 'SM']
    par_v=['16','2']
    pxml.write_par(par_n, par_v)

    val=pxml.read_par('SM')
    print 'updated sm=', val
    val=pxml.read_par('t_storage')
    print 'updated t_storage=', val
    '''
    
