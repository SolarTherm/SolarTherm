#! /bin/env python2

import unittest

import OMPython
import os

class TestWeatherFileChecker(unittest.TestCase):
	def setUp(self):
		modelfile = 'TestWeatherFileChecker.mo'
		model = 'TestWeatherFileChecker'
		self.omc = OMPython.OMCSession()
		self.ex = self.omc.execute
		self.assertTrue(self.ex('loadModel(Modelica)'))
		self.assertTrue(self.ex('loadModel(SolarTherm)'),
				msg=self.ex('getErrorString()'))
		self.assertTrue(self.ex('loadFile("'+modelfile+'")'),
				msg=self.ex('getErrorString()'))

		if os.path.isfile('resources/weatherfile2.motab'):
			os.remove('resources/weatherfile2.motab')
		ans = self.ex('simulate('+model+', stopTime=1)')
		#print(ans)
		self.assertEqual(ans['SimulationResults']['messages'], '""',
				msg=self.ex('getErrorString()'))

	def test_checker(self):
		self.assertTrue(self.ex('val(fn1_correct, 0)'))
		self.assertTrue(self.ex('val(fn2_correct, 0)'))
		self.assertTrue(os.path.isfile('resources/weatherfile2.motab'))

if __name__ == '__main__':
	unittest.main()
