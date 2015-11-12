from __future__ import division

import solartherm.finances as fin
import DyMat
import xml.etree.ElementTree as ET
import re

def get_performance(fn):
	mat = DyMat.DyMatFile(fn)
	# Note that values are provided before and after event for quantities

	# Work in SI units
	epy = fin.energy_per_year(
			mat.abscissa('E_elec')[0][-1] - mat.abscissa('E_elec')[0][0],
			mat.data('E_elec')[-1])
	lcoe = fin.lcoe(mat.data('C_cap')[0], mat.data('C_main')[0],
			mat.data('r_disc')[0], int(mat.data('t_life')[0]), epy)
	capf = fin.capacity_factor(mat.data('P_rate')[0], epy)
	srev = mat.data('R_spot')[-1]

	# Convert to useful units
	epy = epy/(1e6*3600) # convert from J to MWh
	lcoe = lcoe*1e6*3600 # convert from $/J to $/MWh
	capf = 100*capf

	return {'epy (MWh/year)': epy,
			'lcoe ($/MWh)': lcoe,
			'capf (%)': capf,
			'srev ($)': srev,
			}

class SimResult(object):
	def __init__(self, fn, init_fn=None):
		self.fn = fn
		self.init_fn = init_fn
		self.mat = None
		self.units = None
		self.load_res()
	
	def load_res(self):
		self.mat = DyMat.DyMatFile(self.fn)
		self.load_units()

	def load_units(self):
		self.units = None
		init_fn = self.init_fn

		if init_fn is None:
			# Try version based off result file
			res_re = re.compile('(\S+)_res\.mat')
			ps = res_re.match(self.fn)
			if ps is not None:
				init_fn = ps.groups()[0] + '_init.xml'

		# Can fail
		et = None
		if init_fn is not None:
			try:
				et = ET.parse(init_fn)
			except IOError:
				pass

		if et is not None:
			root = et.getroot()

			self.units = {}
			for n in self.mat.names():
				ns = str(n)
				node = root.find('*ScalarVariable[@name=\''+ns+'\']/*[@unit]')
				self.units[ns] = '' if node is None else node.attrib['unit']
	
	def get_lower_ind(self, ab, t):
		"""Get index for point just below or equal to the requested time.
		"""
		assert ab[0] <= t <= ab[-1], "Time outside range"

		il = int(len(ab)*t/(ab[-1] - ab[0]))
		il = min(len(ab)-2, max(0, il))

		while t < ab[il]:
			il -= 1
		while t > ab[il+1]:
			il += 1

		return il
	
	def get_closest(self, name, t):
		"""Closest point in interval.
		"""
		ab = self.mat.abscissa(name, valuesOnly=True)

		il = self.get_lower_ind(ab, t)
		iu = il + 1

		if t <= ((ab[iu] + ab[il])/2):
			return self.mat.data(name)[il]
		else:
			return self.mat.data(name)[iu]

	def get_interp(self, name, t):
		"""Linear interpolation of point.
		"""
		ab = self.mat.abscissa(name, valuesOnly=True)

		il = self.get_lower_ind(ab, t)
		iu = il + 1

		vl = self.mat.data(name)[il]
		vu = self.mat.data(name)[iu]

		if ab[il] == ab[iu]:
			return vl
		else:
			return (vu - vl)*(t - ab[il])/(ab[iu] - ab[il]) + vl
