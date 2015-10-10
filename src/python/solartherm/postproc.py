from __future__ import division

import solartherm.finances as fin
import DyMat

def get_performance(fn):
	mat = DyMat.DyMatFile(fn)
	epy = fin.energy_per_year(mat.data('P_elec'))
	lcoe = fin.lcoe(mat.data('C_cap')[0], mat.data('C_main')[0],
			mat.data('r_disc')[0], int(mat.data('t_life')[0]), epy)
	capf = fin.capacity_factor(mat.data('P_rate')[0], epy)
	return {'epy': epy, 'lcoe': lcoe, 'capf': capf}
