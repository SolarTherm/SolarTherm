from __future__ import division

import solartherm.finances as fin
import DyMat
import xml.etree.ElementTree as ET
import re

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
			res_re = re.compile('(\S+)_res_?(\S+)?\.mat')
			ps = res_re.match(self.fn)
			if ps is not None:
				if ps.groups()[1] is not None:
					init_fn = ps.groups()[0] + '_init_' + ps.groups()[1] + '.xml'
				else:
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
		# Note that values are provided before and after events for quantities
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
	
	def get_integration(self, name, t0, t1):
		"""Integration of linear interpolation over interval
		"""
		ab = self.mat.abscissa(name, valuesOnly=True)
		val = self.mat.data(name)

		il = self.get_lower_ind(ab, t0)
		iu = self.get_lower_ind(ab, t1) + 1

		vsum = 0.
		for i in range(il, iu):
			vl = val[i]
			vu = val[i+1]

			tl = ab[i]
			tu = ab[i+1]

			if tl == tu:
				continue

			if tl < t0:
				vl = (vu - vl)*(t0 - tl)/(tu - tl) + vl
				tl = t0
			if tu > t1:
				vu = (vu - vl)*(t1 - tl)/(tu - tl) + vl
				tu = t1

			vsum += 0.5*(vu + vl)*(tu - tl)

		return vsum

	def sample(self, name, step):
		ab = self.mat.abscissa(name, valuesOnly=True)
		n = int((ab[-1] - ab[0])/step)

		t = []
		v = []
		for i in range(n):
			t0 = step*i + ab[0]
			t1 = step*(i + 1) + ab[0]
			t.append((t0 + t1)/2)
			v.append(self.get_integration(name, t0, t1)/step)

		return t, v
	
	def calc_perf(self):
		"""Calculate plant performance.

		Some of the metrics will be returned as none if simulation runtime is
		not a multiple of a year.
		"""
		eng_t = self.mat.abscissa('E_elec', valuesOnly=True)
		eng_v = self.mat.data('E_elec') # cumulative electricity generated
		cap_v = self.mat.data('C_cap') # capital costs
		om_y_v = self.mat.data('C_year') # O&M costs per year
		om_p_v = self.mat.data('C_prod') # O&M costs per production per year
		disc_v = self.mat.data('r_disc') # discount factor
		life_v = self.mat.data('t_life') # plant lifetime
		cons_v = self.mat.data('t_cons') # construction time
		name_v = self.mat.data('P_name') # generator nameplate
		rev_v = self.mat.data('R_spot') # cumulative revenue

		dur = eng_t[-1] - eng_t[0]
		years = dur/31536000
		# Only provide certain metrics if runtime is a multiple of a year
		close_to_year = years > 0.5 and abs(years - round(years)) <= 0.01

		epy = fin.energy_per_year(dur, eng_v[-1]) # energy expected in a year
		srev = rev_v[-1] # spot market revenue
		lcoe = None # levelised cost of electricity
		capf = None # capacity factor
		if close_to_year: 
			lcoe = fin.lcoe(cap_v[0], om_y_v[0] + om_p_v[0]*epy, disc_v[0],
					int(life_v[0]), int(cons_v[0]), epy)
			capf = fin.capacity_factor(name_v[0], epy)

		# Convert to useful units
		epy = epy/(1e6*3600) # convert from J/year to MWh/year
		if close_to_year: 
			lcoe = lcoe*1e6*3600 # convert from $/J to $/MWh
			capf = 100*capf

		return [epy, lcoe, capf, srev,]

	# Static class variables
	perf_n = ['epy', 'lcoe', 'capf', 'srev']
	perf_u = ['MWh/year', '$/MWh', '%', '$']
