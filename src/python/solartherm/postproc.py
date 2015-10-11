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
