#! /bin/env python2
# -*- coding: utf-8 -*-

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi
import xlsxwriter

import os

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = '../examples/NaSaltSCO2System_modular.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='120s',solver='dassl')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_sched(self):
		def getval(n):
			return self.res.interpolate(n,1)

		self.assertAlmostEqual(self.perf[0], 569076.05, 2) # epy
		self.assertAlmostEqual(self.perf[1], 75.17, 2) # LCOE
		self.assertAlmostEqual(self.perf[2], 64.96, 2) # Capacity factor
		self.assertAlmostEqual(getval('R_des')/1e6, 633.04, 2) # Receiver thermal input
		self.assertAlmostEqual(getval('Q_rec_out')/1e6, 581.38, 2) # Receiver thermal output
		self.assertAlmostEqual(getval('P_gross')/1e6, 111.0, 2) # Power block gross rating
		self.assertAlmostEqual(getval('SM'), 2.67, 2) # Solar multiple
		self.assertAlmostEqual(getval('H_tower'), 47.0, 2) # Tower height
		self.assertAlmostEqual(getval('n_heliostat'), 2822.0, 2) # Number of heliostas
		self.assertAlmostEqual(getval('n_modules'), 58.0, 2) # Number of modules
		print "-----------------------------------------------------------------------"
		print 'Energy per year:                          %6.2f MWh'%(self.perf[0])
		print 'Capacity factor:                          %6.2f %%'%(self.perf[2])
		print 'LCOE:                                     $%6.2f/MWh'%(self.perf[1])
		print "-----------------------------------------------------------------------"
		print 'Receiver thermal input at design point:   %6.2f MW'%(getval('R_des')/1e6)
		print 'Receiver thermal output at design point:  %6.2f MW'%(getval('Q_rec_out')/1e6)
		print 'Power block gross rating at design point: %6.2f MW'%(getval('P_gross')/1e6)
		print 'Solar multiple:                           %4.2f   '%(getval('SM'))
		print 'Tower height (per module):                %4.1f  m'%(getval('H_tower'))
		print 'Number of heliostats (per module):        %i'%(getval('n_heliostat'))
		print 'Number of modules:                        %i'%(getval('n_modules'))

		workbook = xlsxwriter.Workbook('report.xlsx')
		worksheet = workbook.add_worksheet('sodium_single_tower')
		# Row names
		worksheet.write(0, 0, 'Item')
		worksheet.write(1, 0,'Energy per year (MWh)')
		worksheet.write(2, 0,'Capacity factor (\%)')
		worksheet.write(3, 0,'LCOE (\$/MWh)')
		worksheet.write(4, 0,'Number of modules')
		worksheet.write(5, 0,'Receiver thermal input at design point (MWt)')
		worksheet.write(6, 0,'Receiver thermal output at design point (\%)')
		worksheet.write(7, 0,'Solar to thermal efficiency (\%)')
		worksheet.write(8, 0,'Solar to electric efficiency (\%)')
		worksheet.write(9, 0,'Power block gross rating at design point (MWe)')
		worksheet.write(10, 0,'Power block efficiency at design point (\%)')
		worksheet.write(11, 0,'Full load hours of storage (h)')
		worksheet.write(12, 0,'Storage capacity (kWht)')
		worksheet.write(13, 0,'Solar multiple')
		worksheet.write(14, 0,'Receiver diameter (m)')
		worksheet.write(15, 0,'Receiver height (m)')
		worksheet.write(16, 0,'Tower height (m)')
		worksheet.write(17, 0,'Number of heliostats')
		worksheet.write(18, 0,'Number of heliostats per module')
		worksheet.write(19 ,0 ,'Field cost(M\$)')
		worksheet.write(20 ,0 ,'Site improvements cost(M\$)')
		worksheet.write(21 ,0 ,'Tower cost(M\$)')
		worksheet.write(22 ,0 ,'Receiver cost(M\$)')
		worksheet.write(23 ,0 ,'Heat exchanger cost(M\$)')
		worksheet.write(24 ,0 ,'Storage cost(M\$)')
		worksheet.write(25 ,0 ,'Power block cost(M\$)')
		worksheet.write(26 ,0 ,'Balance of plant cost(M\$)')
		worksheet.write(27 ,0 ,'Tower piping cost(M\$)')
		worksheet.write(28 ,0 ,'Piping network cost(M\$)')
		worksheet.write(29 ,0 ,'Cold Pumps cost(M\$)')
		worksheet.write(30 ,0 ,'Direct capital cost subtotal(M\$)')
		worksheet.write(31 ,0 ,'Contingency cost(M\$)')
		worksheet.write(32 ,0 ,'Total direct capital cost(M\$)')
		worksheet.write(33 ,0 ,'EPC and owner costs(M\$)')
		worksheet.write(34 ,0 ,'Land cost(M\$)')
		worksheet.write(35 ,0 ,'Total capital (installed cost)(M\$)')
		# values
		worksheet.write(0, 1, 'Value')
		worksheet.write(1, 1, round(self.perf[0],1))
		worksheet.write(2, 1, round(self.perf[2],2))
		worksheet.write(3, 1, round(self.perf[1],2))
		worksheet.write(4, 1, getval('n_modules'))
		worksheet.write(5, 1, round(getval('R_des')/1e6,1))
		worksheet.write(6, 1, round(getval('Q_rec_out')/1e6,1))
		worksheet.write(7, 1, round(self.res.interpolate('receiver.E_rec',31536000)/self.res.interpolate('heliostatsField.E_dni',31536000)*100,1))
		worksheet.write(8, 1, round(self.res.interpolate('powerBlock.E_net',31536000)/self.res.interpolate('heliostatsField.E_dni',31536000)*100,1))
		worksheet.write(9, 1, round(getval('P_gross')/1e6,1))
		worksheet.write(10, 1, round(getval('eff_blk')*100,1))
		worksheet.write(11, 1, round(getval('t_storage'),1))
		worksheet.write(12, 1, round(getval('E_max')/3600/1e6,1))
		worksheet.write(13, 1, round(getval('SM'),1))
		worksheet.write(14, 1, '-')
		worksheet.write(15, 1, '-')
		worksheet.write(16, 1, round(getval('H_tower'),1))
		worksheet.write(17, 1, round(getval('n_heliostat'),0))
		worksheet.write(18, 1, getval('n_modules')*round(getval('n_heliostat'),0))
		worksheet.write(19, 1, round(getval('C_field')/1e6,1))
		worksheet.write(20, 1, round(getval('C_site')/1e6,1))
		worksheet.write(21, 1, round(getval('C_tower')/1e6,1))
		worksheet.write(22, 1, round(getval('C_receiver')/1e6,1))
		worksheet.write(23, 1, round(getval('C_hx')/1e6,1))
		worksheet.write(24, 1, round(getval('C_storage')/1e6,1))
		worksheet.write(25, 1, round(getval('C_block')/1e6,1))
		worksheet.write(26, 1, round(getval('C_bop')/1e6,1))
		worksheet.write(27, 1, '-')
		worksheet.write(28, 1, round(getval('C_piping')/1e6,1))
		worksheet.write(29, 1, round(getval('C_pumps')/1e6,1))
		worksheet.write(30, 1, round(getval('C_cap_dir_sub')/1e6,1))
		worksheet.write(31, 1, round(getval('C_contingency')/1e6,1))
		worksheet.write(32, 1, round(getval('C_cap_dir_tot')/1e6,1))
		worksheet.write(33, 1, round(getval('C_EPC')/1e6,1))
		worksheet.write(34, 1, round(getval('C_land')/1e6,1))
		worksheet.write(35, 1, round(getval('C_cap')/1e6,1))
		cell_format = workbook.add_format({'bold': True, 'font_color': 'red'})
		worksheet.set_column('A:A', 50, cell_format)
		workbook.close()

if __name__ == '__main__':
	unittest.main()
