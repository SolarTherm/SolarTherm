#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

import csv
from math import pi
#####################################

with open('../SolarTherm/Data/Weather/USA_CA_Los_Angeles_Intl_Arpt_722950_TMY3.CSV', 'rb') as f:
	reader = csv.reader(f)
	csvFileArray = []
	for row in reader:
		csvFileArray.append(row)
str_1 = csvFileArray[2]
#str_2 = csvFileArray[4001]
#str_3 = csvFileArray[8001]
#str_4 = csvFileArray[8761]
#print str_1
L = [4,7,31,34,37,40,43,46]

l_1=[str_1[1],]
for i in L:
	l_1.append(float(str_1[i]))
print l_1
#####################################

class TestTMY3WeatherFileChecker(unittest.TestCase):
	def setUp(self):
		fn = 'TestTMY3WeatherFileChecker.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=1, step=5)
		self.res = postproc.SimResult(sim.model + '_res.mat')



	def test_tmy3_weather_file(self):
		# TODO need to add specific tests here
		pass

if __name__ == '__main__':
	unittest.main()
