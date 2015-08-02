#! /bin/env python2

import unittest

import OMPython

class TestSolarPosition(unittest.TestCase):
	def setUp(self):
		model = 'SolarTherm.Test.TestSolarPosition'
		self.omc = OMPython.OMCSession()
		self.ex = self.omc.execute
		self.assertTrue(self.ex('loadModel(Modelica)'))
		self.assertTrue(self.ex('loadModel('+model+')'),
				msg=self.ex('getErrorString()'))

		ans = self.ex('simulate('+model+', stopTime=4)')
		self.assertEqual(ans['SimulationResults']['messages'], '""',
				msg=self.ex('getErrorString()'))

	def test_solarposition(self):
		# Need to test against calculations on the web for one northern and one
		# southern hemisphere location at various times throughout the year.
		# Need to run the simulation at high enough resolution and check within
		# accuracy of the given method.
		pass

if __name__ == '__main__':
	unittest.main()
