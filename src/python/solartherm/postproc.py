from __future__ import division

import solartherm.finances as fin
import DyMat

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
	def __init__(self, fn):
		self.fn = fn
		self.mat = None
		self.load_res()
	
	def load_res(self):
		self.mat = DyMat.DyMatFile(self.fn)
	
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

		if t <= ((ab[ul] + ab[il])/2):
			return self.mat.data(name)[il]
		else:
			return self.mat.data(name)[ul]

	def get_interp(self, name, t):
		"""Linear interpolation of point.
		"""
		ab = self.mat.abscissa(name, valuesOnly=True)

		il = self.get_lower_ind(ab, t)
		iu = il + 1

		vl = self.mat.data(name)[il]
		vu = self.mat.data(name)[iu]

		return (vu - vl)*(t - ab[il])/(ab[iu] - ab[il]) + vl
