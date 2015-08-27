#! /bin/env python2

import unittest

import OMPython

class TestExternalC(unittest.TestCase):
	def setUp(self):
		modelfile = 'TestExternalC.mo'
		model = 'TestExternalC'
		self.omc = OMPython.OMCSession()
		self.ex = self.omc.execute
		self.assertTrue(self.ex('loadModel(Modelica)'))
		self.assertTrue(self.ex('loadFile("'+modelfile+'")'),
				msg=self.ex('getErrorString()'))

		ans = self.ex('simulate('+model+', stopTime=4)')
		self.assertEqual(ans['SimulationResults']['messages'], '""',
				msg=self.ex('getErrorString()'))

	def test_squaring(self):
		self.assertEqual(self.ex('val(y, 1)'), 1)
		self.assertEqual(self.ex('val(y, 2)'), 4)

if __name__ == '__main__':
	unittest.main()
