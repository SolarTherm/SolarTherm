#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi

class TestWeatherSource(unittest.TestCase):
	def setUp(self):
		fn = 'TestWeatherSource.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop=86400, step=40)
		self.res = postproc.SimResult(sim.model + '_res.mat')

		# Azimuth can be very sensitive at high altitude so increasing number
		# of intervals.
		# Also because of val() interpolates between 0 and 360 at solar noon
		# if not a sampled instant.

	def test_source(self):
		self.assertAlmostEqual(self.res.closest('wea.lat', 0), -34.236)
		self.assertAlmostEqual(self.res.closest('wea.lon', 0), 142.087)
		tstart = 6600
		solar_noon = 12*60*60 + 34*60 + 54 - tstart
		self.assertAlmostEqual(self.res.interpolate('wea.wbus.alt', solar_noon),
				78.8, delta=0.1)
		self.assertAlmostEqual(self.res.interpolate('wea.wbus.azi', solar_noon),
				360.0, delta=1.0) # very sensitive around noon

if __name__ == '__main__':
	unittest.main()
