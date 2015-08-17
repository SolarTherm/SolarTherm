#! /bin/env python2

import unittest

import OMPython

from math import pi

# For year 2015
# http://www.esrl.noaa.gov/gmd/grad/solcalc/

# time (s), alt (deg), azi (deg)
pnts_0 = [
		((0*24 + 5)*3600, -14.51, 113.83),
		((0*24 + 12)*3600, 66.99, 177.98),
		((0*24 + 18)*3600, 1.2, 247.02),
		]

class TestSolarPosition(unittest.TestCase):
	def setUp(self):
		model = 'SolarTherm.Test.TestSolarPosition'
		self.omc = OMPython.OMCSession()
		self.ex = self.omc.execute
		self.assertTrue(self.ex('loadModel(Modelica)'))
		self.assertTrue(self.ex('loadModel('+model+')'),
				msg=self.ex('getErrorString()'))

		# One day 500 intervals:
		#ans = self.ex('simulate('+model+', stopTime=86400)')
		# One year 500 intervals per day:
		ans = self.ex('simulate('+model+
				', stopTime=31536000, numberOfIntervals=182500)')
		self.assertEqual(ans['SimulationResults']['messages'], '""',
				msg=self.ex('getErrorString()'))

	def test_solarposition(self):
		# Need to test against calculations on the web for one northern and one
		# southern hemisphere location at various times throughout the year.
		# Need to run the simulation at high enough resolution and check within
		# accuracy of the given method.

		#self.ex('plot({solp_0.zen, solp_0.dec, solp_0.azi, solp_0.alt})')

		self.longMessage = True
		for i, (t, alt, azi) in enumerate(pnts_0):
			self.assertAlmostEqual(self.ex('val(solp_0.alt, '+str(t)+')')*180/pi,
					alt, delta=1, msg='Alt of: ' + str(i))
			self.assertAlmostEqual(self.ex('val(solp_0.azi, '+str(t)+')')*180/pi,
					azi, delta=1, msg='Azi of: ' + str(i))

		#time = 0*24*3600 + 12*3600
		#self.assertAlmostEqual(self.ex('val(solp_0.alt, '+str(time)+')'),
		#		66.99*pi/180, 2)
		#self.assertAlmostEqual(self.ex('val(solp_0.azi, '+str(time)+')'),
		#		177.98*pi/180, 2)

		#time = 0*24*3600 + 12*3600
		#self.assertAlmostEqual(self.ex('val(solp_0.alt, '+str(time)+')'),
		#		66.99*pi/180, 2)
		#self.assertAlmostEqual(self.ex('val(solp_0.azi, '+str(time)+')'),
		#		177.98*pi/180, 2)

		#time = 0*24*3600 + 12*3600
		#self.assertAlmostEqual(self.ex('val(solp_can.alt, '+str(time)+')'),
		#		1.355, 2)
		#self.assertAlmostEqual(self.ex('val(solp_can.azi, '+str(time)+')'),
		#		0.128, 2)

if __name__ == '__main__':
	unittest.main()
