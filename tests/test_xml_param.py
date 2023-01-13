#!/bin/env python

from __future__ import division
import pytest

from solartherm import simulation
from solartherm import postproc
import os
import DyMat
import xml.etree.ElementTree as ET
import xml
import cleantest

class ProcesXML:
    def __init__(self, xmlfile):
        print('')
        print('')
        print('START')

        self.xmlfile=xmlfile
        self.init_et=ET.parse(self.xmlfile) 
        self.root=self.init_et.getroot() 

    def read_par(self, par_name):   
        val=self.root.find('*ScalarVariable[@name=\''+par_name+'\']/*[@start]').attrib['start']
        return val

    def write_par(self, par_n, par_v, one=True):
        
        if one:
            self.root.find('*ScalarVariable[@name=\''+par_n+'\']/*[@start]').attrib['start']=str(par_v)

        else:
            for i, n in enumerate(par_n):
                print(i, n, par_v[i])
                self.root.find('*ScalarVariable[@name=\''+n+'\']/*[@start]').attrib['start']=str(par_v[i])

        self.init_et.write(self.xmlfile)      


def test_xmlparameter():
	fn = '../examples/Reference_2.mo'
	res_fn='./Reference_2_res.mat'
	xml_fn='./Reference_2_init.xml'
	
	sm=2.8
	t_storage=9

	sim = simulation.Simulator(fn)
	sim.compile_model()

	pxml=ProcesXML(xml_fn)
	pxml.write_par(par_n=['SM', 't_storage'], par_v=[sm, t_storage],one=False)

	sim.compile_sim(args=['-s'])
	sim.simulate(start=0, stop=10, step=0.1)		

	mat=DyMat.DyMatFile(res_fn)

	SM=mat.data("SM")
	T_STORAGE=mat.data("t_storage")

	print('')
	print('     :', 'sm ', 't_storage')
	print('model:', SM[0], T_STORAGE[0])
	print('input:', sm, t_storage)
	print('xml  :', pxml.read_par("SM"), pxml.read_par("t_storage"))

	assert SM[0] == sm
	assert T_STORAGE[0] == t_storage
	
	#cleantest.clean('Reference_2') # name clash with test_xml_stsimulate

# vim: ts=4:sw=4:noet:tw=80
