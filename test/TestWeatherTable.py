#! /bin/env python2

import unittest

import OMPython

class TestWeatherTable(unittest.TestCase):
	def setUp(self):
		model = 'SolarTherm.Test.TestWeatherTable'
		self.omc = OMPython.OMCSession()
		self.ex = self.omc.execute
		self.assertTrue(self.ex('loadModel(Modelica)'))
		self.assertTrue(self.ex('loadModel('+model+')'))

		ans = self.ex('simulate('+model+', stopTime=3)')
		#print(self.ex('getErrorString()'))
		self.assertEqual(ans['SimulationResults']['messages'], '""')

	def test_table(self):
		#self.ex('plot({linear.y[1], cderiv.y[1], cseg.y[1]})')
		self.assertAlmostEqual(self.ex('val(linear.y[1], 0.5)'), 2.5)
		self.assertAlmostEqual(self.ex('val(linear.y[1], 1.5)'), 2)
		self.assertAlmostEqual(self.ex('val(linear.y[1], 2.5)'), 2.5)
		self.assertAlmostEqual(self.ex('val(cderiv.y[1], 0)'), 3)
		self.assertAlmostEqual(self.ex('val(cderiv.y[1], 1)'), 2)
		self.assertAlmostEqual(self.ex('val(cderiv.y[1], 2)'), 2)
		self.assertAlmostEqual(self.ex('val(cderiv.y[1], 3)'), 3)
		self.assertAlmostEqual(self.ex('val(cseg.y[1], 0.5)'), 3)
		self.assertAlmostEqual(self.ex('val(cseg.y[1], 1.5)'), 2)
		self.assertAlmostEqual(self.ex('val(cseg.y[1], 2.5)'), 2)

if __name__ == '__main__':
	unittest.main()
