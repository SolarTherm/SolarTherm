#! /bin/env python2

import unittest

import OMPython

class TestWeatherTable(unittest.TestCase):
	def setUp(self):
		modelfile = 'TestWeatherTable.mo'
		model = 'TestWeatherTable'
		self.omc = OMPython.OMCSession()
		self.ex = self.omc.execute
		self.assertTrue(self.ex('loadModel(Modelica)'))
		self.assertTrue(self.ex('loadModel(SolarTherm)'),
				msg=self.ex('getErrorString()'))
		self.assertTrue(self.ex('loadFile("'+modelfile+'")'),
				msg=self.ex('getErrorString()'))

		ans = self.ex('simulate('+model+', stopTime=3)')
		self.assertEqual(ans['SimulationResults']['messages'], '""',
				msg=self.ex('getErrorString()'))

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
