from __future__ import division

# Performance-related metrics for a solar power plant

def energy_per_year(dt, e):
	"""Electrical energy produced annually in J/year"""
	return 365*24*3600*e/dt

def lcoe_r(c_cap, c_year, r, t_life, t_cons, epy):
	"""Real levelised cost of electricity in $/J.

	We take the convention that payments made or energy produced during a year
	are discounted at the end of that year. For example, the O&M
	costs M paid during the first year has a present value of M/(1 + r).  This
	will tend to underestimate costs but also underestimate the value of the
	energy produced. These will tend to cancel out, but there will remain a 
	difference between LCOE calculated using the start of the year.

	The capital costs are discounted at the start of the year instead, and are
	split over each year of construction. This should probably be handled with
	loans.
	Note that here the real discounted rate (i.e. r) has been used to calculate
	the real LCOE.
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

	for i in range(t_cons+1, t_cons+t_life+1):
		nu += c_year/((1 + r)**i)
		de += epy/((1 + r)**i)

	return nu/de

def lcoe_n(c_cap, c_year, r, i, t_life, t_cons, epy):
	"""Nominal levelised cost of electricity in $/J.

	Note that here the nominal discounted rate (i.e. d) has been used to calculate
	the nominal LCOE.
	"""
	d = (1+r)*(1+i)-1;
	nu = 0.
	de = 0.

	if t_cons == 0:
		nu += c_cap
	else:
		for i in range(t_cons):
			nu += (c_cap/t_cons)/((1 + d)**i)

	for i in range(t_cons+1, t_cons+t_life+1):
		nu += c_year/((1 + d)**i)
		de += epy/((1 + d)**i)

	return nu/de

def lcoe_r_d(c_cap, c_year, r, r_d, t_life, t_cons, epy):
	""""Real levelised cost of electricity in $/J with the effect of system degredation (r_d) taken into account"""
	nu = 0.
	de = 0.

	if t_cons == 0:
		nu += c_cap
	else:
		for i in range(t_cons):
			nu += (c_cap/t_cons)/((1 + r)**i)

	for i in range(t_cons+1, t_cons+t_life+1):
		nu += c_year/((1 + r)**i)
		de += epy*((1-r_d)**(i-t_cons))/((1 + r)**i)

	return nu/de

def lcoe_n_d(c_cap, c_year, r, i, r_d, t_life, t_cons, epy):
	"""Nominal levelised cost of electricity in $/J with the effect of system degredation (r_d) taken into account"""
	d = (1+r)*(1+i)-1;
	nu = 0.
	de = 0.

	if t_cons == 0:
		nu += c_cap
	else:
		for i in range(t_cons):
			nu += (c_cap/t_cons)/((1 + d)**i)

	for i in range(t_cons+1, t_cons+t_life+1):
		nu += c_year/((1 + d)**i)
		de += epy*((1-r_d)**(i-t_cons))/((1 + d)**i)

	return nu/de

def capacity_factor(p_rate, epy):
	"""Capacity factor for a solar power plant"""
	return epy/(p_rate*365*24*3600)

# Performance-related metrics for a solar fuel system

def fuel_per_year(dt, v_fuel):
	"""Fuel produced annually in m3/year"""
	return 365*24*3600*v_fuel/dt

def lcof_r(c_cap, c_year, r, t_life, t_cons, fpy):
	"""Real levelised cost of fuel in $/m3.

	Note that here the real discounted rate (i.e. r) has been used to calculate
	the real LCOF.
	"""
	nu = 0.
	de = 0.

	if t_cons == 0:
		nu += c_cap
	else:
		for i in range(t_cons):
			nu += (c_cap/t_cons)/((1 + r)**i)

	for i in range(t_cons+1, t_cons+t_life+1):
		nu += c_year/((1 + r)**i)
		de += fpy/((1 + r)**i)

	return nu/de

def lcof_n(c_cap, c_year, r, i, t_life, t_cons, fpy):
	"""Nominal levelised cost of fuel in $/m3.

	Note that here the nominal discounted rate (i.e. d) has been used to calculate
	the nominal LCOF.
	"""
	d = (1+r)*(1+i)-1;
	nu = 0.
	de = 0.

	if t_cons == 0:
		nu += c_cap
	else:
		for i in range(t_cons):
			nu += (c_cap/t_cons)/((1 + d)**i)

	for i in range(t_cons+1, t_cons+t_life+1):
		nu += c_year/((1 + d)**i)
		de += fpy/((1 + d)**i)

	return nu/de

def lcof_r_d(c_cap, c_year, r, r_d, t_life, t_cons, fpy):
	"""Real levelised cost of fuel in $/m3 with the effect of system degredation (r_d) taken into account"""
	nu = 0.
	de = 0.

	if t_cons == 0:
		nu += c_cap
	else:
		for i in range(t_cons):
			nu += (c_cap/t_cons)/((1 + r)**i)

	for i in range(t_cons+1, t_cons+t_life+1):
		nu += c_year/((1 + r)**i)
		de += fpy*((1-r_d)**(i-t_cons))/((1 + r)**i)

	return nu/de

def lcof_n_d(c_cap, c_year, r, i, r_d, t_life, t_cons, fpy):
	"""Nominal levelised cost of fuel in $/m3 with the effect of system degredation (r_d) taken into account"""
	d = (1+r)*(1+i)-1;
	nu = 0.
	de = 0.

	if t_cons == 0:
		nu += c_cap
	else:
		for i in range(t_cons):
			nu += (c_cap/t_cons)/((1 + d)**i)

	for i in range(t_cons+1, t_cons+t_life+1):
		nu += c_year/((1 + d)**i)
		de += fpy*((1-r_d)**(i-t_cons))/((1 + d)**i)

	return nu/de

def capacity_factor_f(v_rate, fpy):
	"""Capacity factor for a solar fuel system"""
	return fpy/(v_rate*365*24*3600)

def annualised_capital_cost(c_cap, r, t_life):
	"""Annualised capital cost in $/year"""
	crf = (r*((1 + r)**t_life)) / ((1 + r)**t_life - 1) # capital recovery factor
	return c_cap * crf
