#! /bin/env python2

import unittest

import OMPython

class TestExternalC(unittest.TestCase):
	def setUp(self):
		modelfile = 'TestOptimisation.mo'
		model = 'AO'
		self.omc = OMPython.OMCSession()
		self.ex = self.omc.execute
		self.assertTrue(self.ex('loadModel(Modelica)'))
		self.assertTrue(self.ex('setCommandLineOptions("+g=Optimica")'))
		self.assertTrue(self.ex('loadFile("'+modelfile+'")'),
				msg=self.ex('getErrorString()'))

		ans = self.ex('optimize('+model+', stopTime=1, numberOfIntervals=50)')
		print(ans)
		self.assertEqual(ans['SimulationResults']['messages'], {},
				msg=self.ex('getErrorString()'))

	def test_optimum(self):
		#self.ex('plot({x1, x2, u})')
		self.assertAlmostEqual(self.ex('val(x1, 0)'), 1.0, 5)
		self.assertAlmostEqual(self.ex('val(x2, 0)'), 0.0, 5)
		self.assertAlmostEqual(self.ex('val(u, 1)'), 5.0, 5)

if __name__ == '__main__':
	unittest.main()
