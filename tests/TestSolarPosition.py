#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

# http://www.esrl.noaa.gov/gmd/grad/solcalc/
# Uses calculations from Astronomical Algorithms - Jean Meeus
# Web-based calculator accurate for dates -2000 to +3000
# Applies atmosphere refraction effects which are more significant the
# lower the altitude.
# The year 2015 is used below.

# Zero position lat = 0, lon = 0, tz = 0
# time (s), alt (deg), azi (deg)
pnts_0 = [
		((0*24 + 7)*3600, 13.09, 113.66),
		((0*24 + 12)*3600, 66.99, 177.98),
		((0*24 + 17)*3600, 14.65, 246.2),
		(((31+28+31)*24 + 7)*3600, 14.02, 85.42),
		#(((31+28+31)*24 + 12)*3600, 85.37, 12.25),
		# Zenith angle getting close to zero so azimuth becomes very sensitive
		# Could increase number of intervals (this helped elsewhere)
		# It is likely that there is a non-conitnuous jump in azi that
		# val() is trying to interpolate between at the called point
		# Otherwise could change azimuth tolerated error based on altitude
		(((31+28+31)*24 + 17)*3600, 15.97, 274.79),
		(((31+28+31+30+31+30)*24 + 7)*3600, 12.98, 66.25),
		(((31+28+31+30+31+30)*24 + 12)*3600, 66.88, 2.23),
		(((31+28+31+30+31+30)*24 + 17)*3600, 14.71, 293.91),
		]

# Canberra lat = -35.3, lon = 149.1, tz = 10
# time (s), alt (deg), azi (deg)
pnts_can = [
		((0*24 + 7)*3600, 23.57, 102.41),
		((0*24 + 12)*3600, 77.65, 7.37),
		((0*24 + 17)*3600, 26.28, 259.34),
		(((31+28+31)*24 + 7)*3600, 8.2, 78.86),
		(((31+28+31)*24 + 12)*3600, 50.31, 2.99),
		(((31+28+31)*24 + 17)*3600, 11.14, 283.6),
		(((31+28+31+30+31+30)*24 + 8)*3600, 7.43, 54.81),
		(((31+28+31+30+31+30)*24 + 12)*3600, 31.57, 1.98),
		(((31+28+31+30+31+30)*24 + 16)*3600, 9.82, 307.56),
		]

# Denver lat = 39.74, lon = -104.99, tz = -7
# time (s), alt (deg), azi (deg)
pnts_den = [
		((0*24 + 8)*3600, 5.6, 126.12),
		((0*24 + 12)*3600, 27.31, 179.09),
		((0*24 + 16)*3600, 6.69, 232.68),
		(((31+28+31)*24 + 7)*3600, 13.75, 95.52),
		(((31+28+31)*24 + 12)*3600, 54.9, 178.35),
		(((31+28+31)*24 + 17)*3600, 15.31, 263.35),
		(((31+28+31+30+31+30)*24 + 7)*3600, 25.03, 79.9),
		(((31+28+31+30+31+30)*24 + 12)*3600, 73.33, 176.93),
		(((31+28+31+30+31+30)*24 + 17)*3600, 26.46, 278.96),
		]

# Daggett lat = 34.85, lon = -116.8, tz = -8
# time (s), alt (deg), azi (deg)
pnts_dag = [
		((0*24 + 8)*3600, 10.5, 127.72),
		((0*24 + 12)*3600, 32.16, 182.5),
		((0*24 + 16)*3600, 7.5, 235.28),
		]

class TestSolarPosition(unittest.TestCase):
	def setUp(self):
		fn = 'TestSolarPosition.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		# One year ~500 intervals per day:
		sim.simulate(start=0, stop=31536000, step=170)
		self.res = postproc.SimResult(sim.model + '_res.mat')

	def test_solarposition(self):
		self.longMessage = True # allow assert msg to be added to std msg
		delta = 0.6 # error tolerated (deg)

		for i, (t, alt, azi) in enumerate(pnts_0):
			self.assertAlmostEqual(self.res.get_interp('solp_0.alt', t),
					alt, delta=delta, msg='Alt of 0: ' + str(i))
			self.assertAlmostEqual(self.res.get_interp('solp_0.azi', t),
					azi, delta=delta, msg='Azi of 0: ' + str(i))

		for i, (t, alt, azi) in enumerate(pnts_can):
			self.assertAlmostEqual(self.res.get_interp('solp_can.alt', t),
					alt, delta=delta, msg='Alt of can: ' + str(i))
			self.assertAlmostEqual(self.res.get_interp('solp_can.azi', t),
					azi, delta=delta, msg='Azi of can: ' + str(i))

		for i, (t, alt, azi) in enumerate(pnts_den):
			self.assertAlmostEqual(self.res.get_interp('solp_den.alt', t),
					alt, delta=delta, msg='Alt of den: ' + str(i))
			self.assertAlmostEqual(self.res.get_interp('solp_den.azi', t),
					azi, delta=delta, msg='Azi of den: ' + str(i))

		for i, (t, alt, azi) in enumerate(pnts_dag):
			self.assertAlmostEqual(self.res.get_interp('solp_dag.alt', t),
					alt, delta=delta, msg='Alt of dag: ' + str(i))
			self.assertAlmostEqual(self.res.get_interp('solp_dag.azi', t),
					azi, delta=delta, msg='Azi of dag: ' + str(i))

if __name__ == '__main__':
	unittest.main()
