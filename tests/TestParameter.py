#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc
from solartherm import params
import os
import glob
import DyMat
import xml.etree.ElementTree as ET
import xml

class TestParameter(unittest.TestCase):
	def setUp(self):

		fn = '../examples/Reference_2.mo'
		self.res_fn='./Reference_2_res.mat'
		self.xml_fn='./Reference_2_init.xml'

		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])


	def test_excel(self):

		tree=params.Tree()   
		tree.load_xml(self.xml_fn)
		params.export_values_to_excel('export_params.xlsx', tree, inputxml=self.xml_fn)

		tree.update('SM.description', '*****test updating excel******')
		tree.write_xml(output_xml='./Reference_2_update.xml')	
		params.export_values_to_excel('export_params_update.xlsx', tree)



if __name__ == '__main__':
	unittest.main()

