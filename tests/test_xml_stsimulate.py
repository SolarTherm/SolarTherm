from __future__ import division
import pytest
import cleantest

from solartherm import simulation
from solartherm import postproc
import os, subprocess, platform
import DyMat
import xml.etree.ElementTree as ET
import xml

def STshell():
	# follow the same pattern as in weatherFileChecker.mo..\
	ST = os.environ.get('SOLARTHERM_SHELL')
	assert ST
	import shlex, sys
	from pathlib import Path
	print("ST =",ST)
	if platform.system()=="Windows":
		st1 = ST.split(" ")
	else:
		st1 = shlex.split(ST)
	print("st1 =",st1)
	# let's make sure we have what we expect...
	#assert Path(st1[0]) == Path(sys.executable)
	#assert Path(st1[1]) == Path(os.environ.get('HOME'))/".local"/"bin"/"st"
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


def test_xml_stsimulate():
	fn = '../examples/Reference_2.mo'
	res_fn='./Reference_2_res_0.mat'
	xml_fn='./Reference_2_init_0.xml'
	#xml_fn2='./Reference_2_init.xml'
	sm=2.8
	t_storage=9
	
	cmd = STshell() + ['simulate',fn,'SM=%s'%(sm,),'t_storage=%s'%(t_storage,)]
	print("CMD =",cmd)
	shell = False
	if platform.system()=="Windows":
		shell=True
	subprocess.run(cmd,shell=shell,check=True)
	
	mat=DyMat.DyMatFile(res_fn)
	pxml=ProcessXML(xml_fn)

	SM=mat.data("SM")
	ST=mat.data("t_storage")
	print('')
	print('     :', 'sm ', 't_storage')
	print('model:', SM[0], ST[0])
	print('input:', sm, t_storage)
	print('xml_0:', pxml.read_par("SM"), pxml.read_par("t_storage"))

	assert SM[0] == sm
	assert ST[0] == t_storage
	#cleantest.clean("Reference_2") # clash with test_xml_param.py


if __name__ == '__main__':
	unittest.main()

# vim: ts=4:sw=4:noet:tw=80
