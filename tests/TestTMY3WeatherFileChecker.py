#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

import csv
from math import pi

with open('../SolarTherm/Data/Weather/USA_CA_Los_Angeles_Intl_Arpt_722950_TMY3.CSV', 'rb') as f:
	reader = csv.reader(f)
	csvFileArray = []
	for row in reader:
		csvFileArray.append(row)

str_1 = csvFileArray[2]
str_2 = csvFileArray[4001]
str_3 = csvFileArray[8001]
str_4 = csvFileArray[8761]

L = [4,7,31,34,37,40,43,46]

l_1=[str_1[1],]
for i in L:
	l_1.append(float(str_1[i]))
#print l_1

l_2=[str_2[1],]
for i in L:
	l_2.append(float(str_2[i]))

l_3=[str_3[1],]
for i in L:
	l_3.append(float(str_3[i]))

l_4=[str_4[1],]
for i in L:
	l_4.append(float(str_4[i]))

class TestTMY3WeatherFileChecker(unittest.TestCase):
	def setUp(self):
		fn = 'TestTMY3WeatherFileChecker.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=1, step=5)
		self.res = postproc.SimResult(sim.model + '_res.mat')


	def test_tmy3_weather_file(self):
		self.assertAlmostEqual(self.res.interpolate('l1[2]', 1), l_1[1]) 
		self.assertAlmostEqual(self.res.interpolate('l1[3]', 1), l_1[2])
		self.assertAlmostEqual(self.res.interpolate('l1[4]', 1), l_1[3])
		self.assertAlmostEqual(self.res.interpolate('l1[5]', 1), l_1[4])
		self.assertAlmostEqual(self.res.interpolate('l1[6]', 1), l_1[5]) 
		self.assertAlmostEqual(self.res.interpolate('l1[7]', 1), l_1[6])
		self.assertAlmostEqual(self.res.interpolate('l1[8]', 1), l_1[7])
		self.assertAlmostEqual(self.res.interpolate('l1[9]', 1), l_1[8])

		self.assertAlmostEqual(self.res.interpolate('l2[2]', 1), l_2[1]) 
		self.assertAlmostEqual(self.res.interpolate('l2[3]', 1), l_2[2])
		self.assertAlmostEqual(self.res.interpolate('l2[4]', 1), l_2[3])
		self.assertAlmostEqual(self.res.interpolate('l2[5]', 1), l_2[4])
		self.assertAlmostEqual(self.res.interpolate('l2[6]', 1), l_2[5]) 
		self.assertAlmostEqual(self.res.interpolate('l2[7]', 1), l_2[6])
		self.assertAlmostEqual(self.res.interpolate('l2[8]', 1), l_2[7])
		self.assertAlmostEqual(self.res.interpolate('l2[9]', 1), l_2[8])

		self.assertAlmostEqual(self.res.interpolate('l3[2]', 1), l_3[1]) 
		self.assertAlmostEqual(self.res.interpolate('l3[3]', 1), l_3[2])
		self.assertAlmostEqual(self.res.interpolate('l3[4]', 1), l_3[3])
		self.assertAlmostEqual(self.res.interpolate('l3[5]', 1), l_3[4])
		self.assertAlmostEqual(self.res.interpolate('l3[6]', 1), l_3[5]) 
		self.assertAlmostEqual(self.res.interpolate('l3[7]', 1), l_3[6])
		self.assertAlmostEqual(self.res.interpolate('l3[8]', 1), l_3[7])
		self.assertAlmostEqual(self.res.interpolate('l3[9]', 1), l_3[8])

		self.assertAlmostEqual(self.res.interpolate('l4[2]', 1), l_4[1]) 
		self.assertAlmostEqual(self.res.interpolate('l4[3]', 1), l_4[2])
		self.assertAlmostEqual(self.res.interpolate('l4[4]', 1), l_4[3])
		self.assertAlmostEqual(self.res.interpolate('l4[5]', 1), l_4[4])
		self.assertAlmostEqual(self.res.interpolate('l4[6]', 1), l_4[5]) 
		self.assertAlmostEqual(self.res.interpolate('l4[7]', 1), l_4[6])
		self.assertAlmostEqual(self.res.interpolate('l4[8]', 1), l_4[7])
		self.assertAlmostEqual(self.res.interpolate('l4[9]', 1), l_4[8])

if __name__ == '__main__':
	unittest.main()
