from __future__ import division

def energy_per_year(dt, e):
	return 365*24*3600*e/dt

def lcoe(c_cap, c_main, r, t_life, epy):
	nu = 0.
	de = 0.

	nu = nu + c_cap/(1 + r)**1
	for i in range(1, t_life+1):
		nu = nu + c_main/((1 + r)**i)
		de = de + epy/((1 + r)**i)

	return nu/de

def capacity_factor(p_rate, epy):
	return epy/(p_rate*365*24*3600)
