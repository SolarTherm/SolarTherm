#! /bin/env python2

import unittest

import OMPython
import os

class TestWeatherFileChecker(unittest.TestCase):
	def setUp(self):
		model = 'SolarTherm.Test.TestWeatherFileChecker'
		self.omc = OMPython.OMCSession()
		self.ex = self.omc.execute
		self.assertTrue(self.ex('loadModel(Modelica)'))
		self.assertTrue(self.ex('loadModel('+model+')'),
				msg=self.ex('getErrorString()'))

		if os.path.isfile('weather2.mo'):
			os.remove('weather2.mo')
		ans = self.ex('simulate('+model+', stopTime=1)')
		self.assertEqual(ans['SimulationResults']['messages'], '""',
				msg=self.ex('getErrorString()'))

	def test_checker(self):
		self.assertTrue(self.ex('val(fn1_correct, 0)'))
		self.assertTrue(self.ex('val(fn2_correct, 0)'))
		self.assertTrue(os.path.isfile('weather2.mo'))

if __name__ == '__main__':
	unittest.main()
