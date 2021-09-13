#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc
import os, subprocess, platform
import DyMat
import xml.etree.ElementTree as ET
import xml

def ST():
	# follow the same pattern as in weatherFileChecker.mo..\
	ST = os.environ.get('SOLARTHERM_SHELL')
	assert ST
	import shlex, sys
	from pathlib import Path
	print("ST =",ST)
	if platform.syste()=="Windows":
		st1 = ST.split(" ")
	else:
		st1 = shlex.split(ST)
	print("st1 =",st1)
	# let's make sure we have what we expect...
	assert Path(st1[0]) == Path(sys.executable)
	assert Path(st1[1]) == Path(os.environ.get('HOME'))/".local"/"bin"/"st"
	return st1
#	import platform, shutil,sys, os
#	from pathlib import Path
#	if platform.system()=="Windows":
#		st1 = Path(os.environ.get('HOME'))/".local"/"bin"/"st"
#		assert st1.exists()
#		return [sys.executable,st1]
#	else:
#		return ['st']

class ProcessXML:
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
		
		
		cmd = ST() + ['simulate',fn,'SM=%s'%(self.sm,),'t_storage=%s'%(self.t_storage,)]
		print("CMD =",cmd)
		shell = False
		if platform.system()=="Windows":
			shell=True
		subprocess.run(cmd,shell=shell,check=True)
		
		self.mat=DyMat.DyMatFile(res_fn)
		self.pxml=ProcessXML(xml_fn)
		#self.pxml2=ProcessXML(xml_fn2)

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

