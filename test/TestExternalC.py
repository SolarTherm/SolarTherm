#! /bin/env python2

import unittest

import OMPython

class TestWeatherTable(unittest.TestCase):
	def setUp(self):
		model = 'SolarTherm.Test.TestExternalC'
		self.omc = OMPython.OMCSession()
		self.ex = self.omc.execute
		self.assertTrue(self.ex('loadModel(Modelica)'))
		self.assertTrue(self.ex('loadModel('+model+')'))

		ans = self.ex('simulate('+model+', stopTime=4)')
		#print(self.ex('getErrorString()'))
		self.assertEqual(ans['SimulationResults']['messages'], '""')

	def test_table(self):
		self.assertEqual(self.ex('val(y, 1)'), 1)
		self.assertEqual(self.ex('val(y, 2)'), 4)

if __name__ == '__main__':
	unittest.main()
