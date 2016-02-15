from __future__ import division

def energy_per_year(dt, e):
	return 365*24*3600*e/dt

def lcoe(c_cap, c_om, r, t_life, t_cons, epy):
	"""Levelised cost of electricity.

	We take the convention that payments made or energy produced during a year
	are discounted at the start of that year.  For example, the O&M
	costs M paid during the second year has a present value of M/(1 + r).  This
	will tend to overestimate costs but also overestimate the value of the
	energy produced.  These will tend to cancel out so the affect on the LCOE
	should be minimal.
	"""
	nu = 0.
	de = 0.

	# Assume capital cost is evenly split between years in construction phase,
	# else if no construction phase it is all paid up front
	if t_cons == 0:
		nu += c_cap
	else:
		for i in range(t_cons):
			nu += (c_cap/t_cons)/((1 + r)**i)

	for i in range(t_cons, t_cons+t_life):
		nu += c_om/((1 + r)**i)
		de += epy/((1 + r)**i)

	return nu/de

def capacity_factor(p_rate, epy):
	return epy/(p_rate*365*24*3600)
