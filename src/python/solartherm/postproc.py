from __future__ import division

import solartherm.finances as fin
import DyMat
import xml.etree.ElementTree as ET
import re

class SimResult(object):
	def __init__(self, fn, init_fn=None):
		"""
		fn: results file (*_res*.mat)
		init_fn: input paramet file (*_init*.xml)
		"""
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
			# Find the .xml file with the name matching the .mat file.
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
	
	def get_names(self):
		return self.mat.names()

	def get_time(self, name):
		return self.mat.abscissa(name, valuesOnly=True)

	def get_values(self, name):
		return self.mat.data(name)

	def get_unit(self, name):
		return self.units[name]

	def lower_ind(self, ab, t):
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
	
	def closest(self, name, t):
		"""Closest point in interval.
		"""
		ab = self.mat.abscissa(name, valuesOnly=True)

		il = self.lower_ind(ab, t)
		iu = il + 1

		if t <= ((ab[iu] + ab[il])/2):
			return self.mat.data(name)[il]
		else:
			return self.mat.data(name)[iu]

	def interpolate(self, name, t):
		"""Linear interpolation of point.
		"""
		ab = self.mat.abscissa(name, valuesOnly=True)

		il = self.lower_ind(ab, t)
		iu = il + 1

		vl = self.mat.data(name)[il]
		vu = self.mat.data(name)[iu]

		if ab[il] == ab[iu]:
			return vl
		else:
			return (vu - vl)*(t - ab[il])/(ab[iu] - ab[il]) + vl
	
	def integrate(self, name, t0, t1):
		"""Integration of linear interpolation over interval
		"""
		ab = self.mat.abscissa(name, valuesOnly=True)
		val = self.mat.data(name)

		il = self.lower_ind(ab, t0)
		iu = self.lower_ind(ab, t1) + 1

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
			v.append(self.integrate(name, t0, t1)/step)

		return t, v

class SimResultElec(SimResult):
	def calc_perf(self):
		"""Calculate the solar power plant performance.
		Some of the metrics will be returned as none if simulation runtime is
		not a multiple of a year.
		"""
		var_names = self.get_names()
		assert('E_elec' in var_names), "For a levelised cost of electricity calculation, It is expected to see E_elec variable in the results file!"

		eng_t = self.mat.abscissa('E_elec', valuesOnly=True) # Time [s]
		eng_v = self.mat.data('E_elec') # Cumulative electricity generated [J]
		cap_v = self.mat.data('C_cap') # Capital costs [$]
		om_y_v = self.mat.data('C_year') # O&M costs per year [$/year]
		om_p_v = self.mat.data('C_prod') # O&M costs per production per year [$/W/year]
		disc_v = self.mat.data('r_disc') # Discount rate [-]
		life_v = self.mat.data('t_life') # Plant lifetime [year]
		cons_v = self.mat.data('t_cons') # Construction time [year]
		name_v = self.mat.data('P_name') # Generator nameplate [W]
		rev_v = self.mat.data('R_spot') # Cumulative revenue [$]

		dur = eng_t[-1] - eng_t[0] # Time duration [s]
		years = dur/31536000 # number of years of simulation [year]
		# Only provide certain metrics if runtime is a multiple of a year
		close_to_year = years > 0.5 and abs(years - round(years)) <= 0.01

		epy = fin.energy_per_year(dur, eng_v[-1]) # Energy expected in a year [J]
		srev = rev_v[-1] # spot market revenue [$]
		lcoe = None # Levelised cost of electricity
		capf = None # Capacity factor
		if close_to_year: 
			lcoe = fin.lcoe_r(cap_v[0], om_y_v[0] + om_p_v[0]*epy, disc_v[0],
					int(life_v[0]), int(cons_v[0]), epy)
			capf = fin.capacity_factor(name_v[0], epy)

		# Convert to useful units
		epy = epy/(1e6*3600) # Convert from J/year to MWh/year
		if close_to_year: 
			lcoe = lcoe*1e6*3600 # Convert from $/J to $/MWh
			capf = 100*capf

		return [epy, lcoe, capf, srev,]

	perf_n = ['epy', 'lcoe', 'capf', 'srev']
	perf_u = ['MWh/year', '$/MWh', '%', '$']


class SimResultFuel(SimResult):
	def calc_perf(self):
		"""Calculate solar fuels plant performance.
		Some of the metrics will be returned as none if simulation runtime is
		not a multiple of a year.
		"""
		var_names = self.get_names()

		assert('V_fuel' in var_names), "For a fuel_calc calculation, it is expected to see V_fuel variable in the results file!"

		V_fuel_t = self.mat.abscissa('V_fuel', valuesOnly=True) # Time [s]
		V_fuel_v = self.mat.data('V_fuel') # Cumulative produced fuel [m3]
		C_cap_v = self.mat.data('C_cap') # Capital costs [$]
		C_labor_v = self.mat.data('C_labor') # Labor cost [$/year]
		C_catalyst_v = self.mat.data('C_catalyst') # Catalysts cost [$/year]
		C_om_v = self.mat.data('C_om') # Maintenance cost [$/year]
		C_water_v = self.mat.data('C_water') # Cost of water [$/year]
		C_algae_v = self.mat.data('C_algae') # Cost of algae [$/year]
		C_H2_v = self.mat.data('C_H2')  # Cost of hydrogen [$/year]
		C_elec_v = self.mat.data('C_elec') # Cost of electricity consumption [$/year]
		disc_v = self.mat.data('r_disc') # Discount rate [-]
		infl_v = self.mat.data('r_i') # Inflation rate [-]
		life_v = self.mat.data('t_life') # Plant lifetime [year]
		cons_v = self.mat.data('t_cons') # Construction time [year]
		name_v = self.mat.data('FT.v_flow_fuel_des') # Nominal fuel volumetric flow rate [m3/s]
		rev_v = self.mat.data('R_spot') # cumulative revenue

		C_op_v = C_water_v + C_algae_v + C_H2_v + C_elec_v # Operating costs [$/year]
		C_year = C_labor_v[0] + C_catalyst_v[0] + C_om_v[0] + C_op_v[-1] # Total operational costs [$/year]

		dur = V_fuel_t[-1] - V_fuel_t[0] # Time duration [s]
		years = dur/31536000 # number of years of simulation [year]
		# Only provide certain metrics if runtime is a multiple of a year
		close_to_year = years > 0.5 and abs(years - round(years)) <= 0.01

		fpy = fin.fuel_per_year(dur, V_fuel_v[-1]) # Fuel produced in a year [m3/year]
		srev = rev_v[-1] # Spot market revenue [$/year]
		lcof = None # Levelised cost of fuel
		capf = None # Capacity factor
		if close_to_year: 
			lcof = fin.lcof_r(C_cap_v[0], C_year, disc_v[0], int(life_v[0]), int(cons_v[0]), fpy)
			capf = fin.capacity_factor_f(name_v[0], fpy)

		# Convert to useful units
		fpy = fpy*1e3 # convert from m3/year to L/year
		if close_to_year: 
			lcof = lcof/1e3 # convert from $/m3 to $/L
			capf = 100*capf

		return [fpy, lcof, capf, srev,]

	perf_n = ['fpy', 'lcof', 'capf', 'srev']
	perf_u = ['L/year', '$/L', '%', '$']

class CSVResult(object):
	"""Results from a CSV file.
	Assumes first row is a header.
	Assumes first column is time.
	"""
	def __init__(self, fn, delim=','):
		self.fn = fn
		self.delim = delim
		self.names = []
		self.data = {}
		self.units = {}
		self.load_res()
	
	def load_res(self):
		f = open(self.fn)
		header = f.readline().split(self.delim)
		for label in header:
			l = label.split('(')
			name = l[0].strip()
			self.names.append(name)
			if len(l) > 1:
				self.units[name] = l[1].strip().strip(')')
			else:
				self.units[name] = ''
			self.data[name] = []

		for line in f.readlines():
			l = line.split(self.delim)
			for i, val in enumerate(l):
				self.data[self.names[i]].append(float(val))

	def get_names(self):
		return self.names

	def get_time(self, name):
		return self.data[self.names[0]] # assume first

	def get_values(self, name):
		return self.data[name]

	def get_unit(self, name):
		return self.units[name]
