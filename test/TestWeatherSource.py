#! /bin/env python2

import unittest

import OMPython

from math import pi

class TestWeatherSource(unittest.TestCase):
	def setUp(self):
		model = 'SolarTherm.Test.TestWeatherSource'
		self.omc = OMPython.OMCSession()
		self.ex = self.omc.execute
		self.assertTrue(self.ex('loadModel(Modelica)'))
		self.assertTrue(self.ex('loadModel('+model+')'),
				msg=self.ex('getErrorString()'))

		# Azimuth can be very sensitive at high altitude so increasing number
		# of intervals.
		ans = self.ex('simulate('+model+', stopTime=86400, numberOfIntervals=2000)')
		#print(ans)
		self.assertEqual(ans['SimulationResults']['messages'], '""',
				msg=self.ex('getErrorString()'))

	def test_source(self):
		#self.ex('plot({wea.alt, wea.azi})')
		#self.ex('plot({wea.ghi, wea.dni})')
		#self.ex('plot({wea.Tdry, wea.Tdew})')
		self.assertAlmostEqual(self.ex('val(wea.lat, 0)'), -34.236)
		self.assertAlmostEqual(self.ex('val(wea.lon, 0)'), 142.087)
		tstart = 6600
		solar_noon = str(12*60*60 + 34*60 + 54 - tstart)
		self.assertAlmostEqual(self.ex('val(wea.alt, ' + solar_noon + ')')*180/pi,
				78.8, delta=0.1)
		self.assertAlmostEqual(self.ex('val(wea.azi, ' + solar_noon + ')')*180/pi,
				360.0, delta=1.0) # very sensitive

if __name__ == '__main__':
	unittest.main()
