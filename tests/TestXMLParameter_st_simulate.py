#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc
import os, subprocess
import DyMat
import xml.etree.ElementTree as ET
import xml

class ProcesXML:
    def __init__(self, xmlfile):

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
                print(i, n, par_v[i])
                self.root.find('*ScalarVariable[@name=\''+n+'\']/*[@start]').attrib['start']=par_v[i]

        self.init_et.write(self.xmlfile)      


class TestXMLparameter(unittest.TestCase):
	def setUp(self):
		fn = '../examples/Reference_2.mo'
		res_fn='./Reference_2_res_0.mat'
		xml_fn='./Reference_2_init_0.xml'
		#xml_fn2='./Reference_2_init.xml'
		self.sm=2.8
		self.t_storage=9
		subprocess.check_call(['st_simulate',fn,'SM=%s'%(self.sm,),'t_storage=%s'%(self.t_storage,)])
		self.mat=DyMat.DyMatFile(res_fn)
		self.pxml=ProcesXML(xml_fn)
		#self.pxml2=ProcesXML(xml_fn2)
		

	def test_sched(self):

		sm=self.mat.data("SM")
		st=self.mat.data("t_storage")
		print('')
		print('     :', 'sm ', 't_storage')
		print('model:', sm[0], st[0])
		print('input:', self.sm, self.t_storage)
		print('xml_0:', self.pxml.read_par("SM"), self.pxml.read_par("t_storage"))
		#print 'xml  :',self.pxml2.read_par("SM"),self.pxml2.read_par("t_storage")

		self.assertEqual(sm[0], self.sm)
		self.assertEqual(st[0], self.t_storage)
		os.system('rm Reference_2*')


if __name__ == '__main__':
	unittest.main()

