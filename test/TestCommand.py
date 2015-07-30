#! /bin/env python2

import unittest

import OMPython
import os

class TestCommand(unittest.TestCase):
	def setUp(self):
		model = 'SolarTherm.Test.TestCommand'
		self.omc = OMPython.OMCSession()
		self.ex = self.omc.execute
		self.assertTrue(self.ex('loadModel(Modelica)'))
		self.assertTrue(self.ex('loadModel('+model+')'),
				msg=self.ex('getErrorString()'))

		if os.path.isfile('TestCommandTouched'):
			os.remove('TestCommandTouched')
		ans = self.ex('simulate('+model+', stopTime=1)')
		self.assertEqual(ans['SimulationResults']['messages'], '""',
				msg=self.ex('getErrorString()'))

	def test_touching(self):
		self.assertEqual(self.ex('val(result, 0)'), 0)
		self.assertTrue(os.path.isfile('TestCommandTouched'))
		

if __name__ == '__main__':
	unittest.main()
